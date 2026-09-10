#!/usr/bin/env bash
# lightrag-local: thin curl wrapper around an existing local LightRAG service.
# Designed for macOS (self-heal launches Docker Desktop); works on Linux with a
# running Docker daemon. Requires: bash, curl, python3.

set -u
set -o pipefail

# ---------- Config loading ----------
DEFAULT_URL="http://127.0.0.1:9621"
CONFIG_FILE="${LIGHTRAG_CONFIG:-$HOME/.lightrag-local.env}"

if [ -f "$CONFIG_FILE" ]; then
    # shellcheck disable=SC1090
    set -a
    . "$CONFIG_FILE"
    set +a
fi

LIGHTRAG_URL="${LIGHTRAG_URL:-$DEFAULT_URL}"
LIGHTRAG_URL="${LIGHTRAG_URL%/}"   # strip trailing slash
LIGHTRAG_API_KEY="${LIGHTRAG_API_KEY:-}"

# Self-heal config (see cmd_ensure). Override any of these via env or $CONFIG_FILE.
LIGHTRAG_COMPOSE="${LIGHTRAG_COMPOSE:-$HOME/lightrag/docker-compose.yml}"
LIGHTRAG_CONTAINER="${LIGHTRAG_CONTAINER:-lightrag}"
# LR_AUTOHEAL=1 (default): data/health calls transparently try one self-heal
# on a connection failure. Set LIGHTRAG_AUTOHEAL=0 to disable.
LR_AUTOHEAL="${LIGHTRAG_AUTOHEAL:-1}"

# ---------- Helpers ----------
err() { printf 'lightrag: %s\n' "$*" >&2; }
die() { err "$*"; exit 1; }

require_cmd() {
    for c in "$@"; do
        command -v "$c" >/dev/null 2>&1 || die "missing required command: $c"
    done
}

require_cmd curl python3

auth_header_args=()
if [ -n "$LIGHTRAG_API_KEY" ]; then
    auth_header_args=(-H "X-API-Key: $LIGHTRAG_API_KEY")
fi

# Run curl once, capture body to stdout and HTTP status to a variable.
# Returns: 0 = 2xx, 2 = connection failure, 3 = auth, 4 = other HTTP error.
# Usage: _http_call_once METHOD PATH [curl_args...]
_http_call_once() {
    local method="$1"; shift
    local path="$1"; shift
    local url="$LIGHTRAG_URL$path"
    local tmp; tmp="$(mktemp -t lightrag.XXXXXX)"
    local code
    code=$(curl -sS -o "$tmp" -w '%{http_code}' \
        -X "$method" ${auth_header_args[@]+"${auth_header_args[@]}"} "$@" "$url") || {
            err "curl failed for $method $path"
            rm -f "$tmp"
            return 2
        }
    cat "$tmp"
    rm -f "$tmp"
    case "$code" in
        2??) return 0 ;;
        401|403) err "HTTP $code from $path — authentication required. Set LIGHTRAG_API_KEY (env or $CONFIG_FILE)."; return 3 ;;
        *) err "HTTP $code from $path"; return 4 ;;
    esac
}

# http_call wraps _http_call_once with one transparent self-heal retry when the
# service is unreachable (connection failure). Healing output goes to stderr so
# it never pollutes the JSON body that callers pipe into pretty_json.
#
# The request body is passed as the curl arg "@-" (read from stdin). Since a
# retry would find stdin already drained, we buffer stdin to a temp file and
# rewrite "@-" to "@<file>" so both attempts send the identical body.
http_call() {
    local args=("$@")
    local body_tmp="" i
    for i in "${!args[@]}"; do
        if [ "${args[$i]}" = "@-" ]; then
            body_tmp="$(mktemp -t lightrag-body.XXXXXX)"
            cat > "$body_tmp"
            args[$i]="@$body_tmp"
            break
        fi
    done

    _http_call_once "${args[@]}"
    local rc=$?
    if [ "$rc" -eq 2 ] && [ "$LR_AUTOHEAL" = "1" ] && [ -z "${LR_IN_HEAL:-}" ]; then
        err "service unreachable — attempting self-heal, then one retry"
        LR_IN_HEAL=1 cmd_ensure >&2
        _http_call_once "${args[@]}"
        rc=$?
    fi

    [ -n "$body_tmp" ] && rm -f "$body_tmp"
    return $rc
}

pretty_json() {
    python3 -c 'import json,sys
try:
    print(json.dumps(json.load(sys.stdin), indent=2, ensure_ascii=False))
except Exception:
    sys.exit(0)'
}

json_encode() {
    # Builds a JSON object from env vars named LR_JSON_<KEY>.
    python3 - <<'PY'
import json, os
out = {}
for k, v in os.environ.items():
    if k.startswith("LR_JSON_"):
        key = k[len("LR_JSON_"):]
        if v in ("true", "false"):
            out[key.lower()] = (v == "true")
        else:
            try:
                out[key.lower()] = int(v)
            except ValueError:
                out[key.lower()] = v
print(json.dumps(out, ensure_ascii=False))
PY
}

discover_containers() {
    if ! command -v docker >/dev/null 2>&1; then
        echo "  (docker CLI not found)"
        return
    fi
    if ! docker ps >/dev/null 2>&1; then
        echo "  (docker daemon not reachable)"
        return
    fi
    local rows
    rows=$(docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' 2>/dev/null \
        | grep -iE 'lightrag' || true)
    if [ -z "$rows" ]; then
        echo "  (no running container matched 'lightrag')"
    else
        printf '%s\n' "$rows" | awk -F'\t' '{printf "  %s  [%s]  %s  %s\n",$1,$2,$3,$4}'
    fi
}

# ---------- Self-heal helpers ----------
health_ok() {
    local code
    code=$(curl -sS -o /dev/null -w '%{http_code}' -m 5 \
        ${auth_header_args[@]+"${auth_header_args[@]}"} \
        "$LIGHTRAG_URL/health" 2>/dev/null) || return 1
    case "$code" in 2??) return 0 ;; *) return 1 ;; esac
}

docker_daemon_ok() { command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; }

wait_for_health() {
    local timeout="${1:-60}" i=0
    while [ "$i" -lt "$timeout" ]; do
        health_ok && return 0
        sleep 2; i=$((i+2))
    done
    return 1
}

wait_for_daemon() {
    local timeout="${1:-90}" i=0
    while [ "$i" -lt "$timeout" ]; do
        docker_daemon_ok && return 0
        sleep 3; i=$((i+3))
    done
    return 1
}

# Resolve the LightRAG container name (running or stopped): exact match first,
# then any container whose name contains 'lightrag'.
resolve_container() {
    local exact
    exact="$(docker ps -a --format '{{.Names}}' 2>/dev/null | grep -ix "$LIGHTRAG_CONTAINER" | head -1)"
    if [ -n "$exact" ]; then printf '%s\n' "$exact"; return; fi
    docker ps -a --format '{{.Names}}' 2>/dev/null | grep -i 'lightrag' | head -1
}

# cmd_ensure: bring the service back to healthy via an escalation ladder.
#   healthy already        -> done
#   docker daemon down     -> open -a Docker (macOS), wait
#   container stopped      -> docker start
#   still down + compose   -> docker compose up -d
#   verify, else diagnose
cmd_ensure() {
    if health_ok; then
        echo "lightrag: healthy at $LIGHTRAG_URL"
        return 0
    fi
    err "not reachable at $LIGHTRAG_URL — attempting self-heal"

    if ! command -v docker >/dev/null 2>&1; then
        err "docker CLI not found — cannot auto-heal. Start the LightRAG service manually."
        return 1
    fi

    if ! docker_daemon_ok; then
        if [ "$(uname)" = "Darwin" ]; then
            err "docker daemon not running — launching Docker Desktop (open -a Docker)"
            open -a Docker 2>/dev/null || err "could not launch Docker Desktop"
        else
            err "docker daemon not running — start it, then re-run"
        fi
        if ! wait_for_daemon 90; then
            err "docker daemon did not come up within 90s — heal aborted"
            return 1
        fi
        err "docker daemon is up"
    fi

    local cname; cname="$(resolve_container)"
    if [ -n "$cname" ]; then
        err "starting container: $cname"
        docker start "$cname" >/dev/null 2>&1 || err "docker start $cname failed — will try compose"
    else
        err "no existing lightrag container found — will try compose"
    fi

    if ! health_ok; then
        if [ -f "$LIGHTRAG_COMPOSE" ]; then
            err "bringing stack up via compose: $LIGHTRAG_COMPOSE"
            docker compose -f "$LIGHTRAG_COMPOSE" up -d >/dev/null 2>&1 \
                || err "docker compose up failed"
        else
            err "compose file not found at $LIGHTRAG_COMPOSE — skipping compose step"
        fi
    fi

    if wait_for_health 60; then
        echo "lightrag: healed — healthy at $LIGHTRAG_URL"
        return 0
    fi

    err "self-heal did not restore health within timeout. Diagnostics follow:"
    LR_AUTOHEAL=0 cmd_status >&2
    return 1
}

usage() {
    cat <<EOF
Usage: lightrag.sh <command> [args]

Commands:
  status                          Show config, key presence, health, docker info
  ensure                          Self-heal: verify health, restart the container /
                                  Docker if needed, wait until healthy (aliases: heal, up)
  health                          GET  /health
  docs                            GET  /documents
  pipeline-status                 GET  /documents/pipeline_status
  search "<query>"                POST /query  (mode=mix, include_references=true)
  context "<query>"               POST /query  (only_need_context, include_chunk_content)
  write "<source>" "<text>"       POST /documents/text  with file_source=<source>
  write-file "<path>"             POST /documents/text  reading body from file
  reprocess                       POST /documents/reprocess_failed

There is deliberately no delete command. See SKILL.md, "Deletion is forbidden".

Env / Config:
  LIGHTRAG_URL          default $DEFAULT_URL  (current: $LIGHTRAG_URL)
  LIGHTRAG_API_KEY      optional, sent as X-API-Key
  LIGHTRAG_CONFIG       overrides $CONFIG_FILE
  LIGHTRAG_COMPOSE      compose file for self-heal (current: $LIGHTRAG_COMPOSE)
  LIGHTRAG_CONTAINER    container name for self-heal (current: $LIGHTRAG_CONTAINER)
  LIGHTRAG_AUTOHEAL     1=auto self-heal on unreachable (default), 0=off
EOF
}

# ---------- Commands ----------
cmd_health() { http_call GET /health | pretty_json; }
cmd_docs()   { http_call GET /documents | pretty_json; }
cmd_pipe()   { http_call GET /documents/pipeline_status | pretty_json; }

cmd_status() {
    echo "LightRAG URL : $LIGHTRAG_URL"
    if [ -n "$LIGHTRAG_API_KEY" ]; then
        local masked="${LIGHTRAG_API_KEY:0:4}…(${#LIGHTRAG_API_KEY} chars)"
        echo "API key      : present  [$masked]"
    else
        echo "API key      : not set"
    fi
    echo "Config file  : $CONFIG_FILE $( [ -f "$CONFIG_FILE" ] && echo "(loaded)" || echo "(not present)" )"
    echo
    echo "Health:"
    if ! ( LR_AUTOHEAL=0 cmd_health ) 2>&1 | sed 's/^/  /'; then
        echo "  health check failed"
    fi
    echo
    echo "Docker containers (matching 'lightrag'):"
    discover_containers
}

cmd_search() {
    [ $# -ge 1 ] || die "search needs a query string"
    local q="$1"
    LR_JSON_query="$q" LR_JSON_mode="mix" LR_JSON_include_references="true" LR_JSON_stream="false" \
        json_encode \
        | http_call POST /query -H 'Content-Type: application/json' --data-binary @- \
        | pretty_json
}

cmd_context() {
    [ $# -ge 1 ] || die "context needs a query string"
    local q="$1"
    LR_JSON_query="$q" LR_JSON_mode="mix" \
    LR_JSON_only_need_context="true" \
    LR_JSON_include_references="true" \
    LR_JSON_include_chunk_content="true" \
    LR_JSON_stream="false" \
        json_encode \
        | http_call POST /query -H 'Content-Type: application/json' --data-binary @- \
        | pretty_json
}

cmd_write() {
    [ $# -ge 2 ] || die "write needs <source> <text>"
    local src="$1"; shift
    local text="$*"
    LR_JSON_text="$text" LR_JSON_file_source="$src" \
        json_encode \
        | http_call POST /documents/text -H 'Content-Type: application/json' --data-binary @- \
        | pretty_json
}

cmd_write_file() {
    [ $# -ge 1 ] || die "write-file needs <path>"
    local path="$1"
    [ -f "$path" ] || die "file not found: $path"
    # file_source becomes the searchable reference name, so name the file well
    # before writing (e.g. decision-product-example-2026.md).
    local src; src="$(basename "$path")"
    local text; text="$(cat "$path")"
    LR_JSON_text="$text" LR_JSON_file_source="$src" \
        json_encode \
        | http_call POST /documents/text -H 'Content-Type: application/json' --data-binary @- \
        | pretty_json
}

cmd_reprocess() {
    http_call POST /documents/reprocess_failed -H 'Content-Type: application/json' --data '{}' \
        | pretty_json
}

# ---------- Dispatch ----------
[ $# -ge 1 ] || { usage; exit 64; }
sub="$1"; shift
case "$sub" in
    status)            cmd_status "$@" ;;
    ensure|heal|up)    cmd_ensure "$@" ;;
    health)            cmd_health "$@" ;;
    docs)              cmd_docs "$@" ;;
    pipeline-status)   cmd_pipe "$@" ;;
    search)            cmd_search "$@" ;;
    context)           cmd_context "$@" ;;
    write)             cmd_write "$@" ;;
    write-file)        cmd_write_file "$@" ;;
    reprocess)         cmd_reprocess "$@" ;;
    -h|--help|help)    usage ;;
    *)                 err "unknown command: $sub"; usage; exit 64 ;;
esac
