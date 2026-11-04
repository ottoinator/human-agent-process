#!/usr/bin/env bash
# Installer for the human-agent process v2: policy block + Codex agents + plugin commands.
# Works on macOS and Linux (no GNU-only flags). Requires node.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN="$REPO/plugins/human-agent-process"
TARGET=both
MODULES=default
CLAUDE_HOME="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
AGENTS_SKILLS="${AGENTS_SKILLS_DIR:-}"
CODEX_HOME_FLAG=0
DRY=0; UNINSTALL=0; MIGRATE=0; FORCE=0; PLUGIN_CMD=1

usage() {
  cat <<USAGE
Usage: scripts/install.sh [--claude|--codex|--both] [--modules a,b|default|all|none]
  [--claude-home DIR] [--codex-home DIR] [--dry-run] [--uninstall]
  [--migrate-from-1x] [--force] [--no-plugin-cmd]
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    --claude) TARGET=claude ;;
    --codex) TARGET=codex ;;
    --both) TARGET=both ;;
    --modules) MODULES="${2:?--modules needs a value}"; shift ;;
    --claude-home) CLAUDE_HOME="${2:?}"; shift ;;
    --codex-home) CODEX_HOME_DIR="${2:?}"; CODEX_HOME_FLAG=1; shift ;;
    --dry-run) DRY=1 ;;
    --uninstall) UNINSTALL=1 ;;
    --migrate-from-1x) MIGRATE=1 ;;
    --force) FORCE=1 ;;
    --no-plugin-cmd) PLUGIN_CMD=0 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

command -v node >/dev/null 2>&1 || { echo "node is required" >&2; exit 1; }
do_claude=0; do_codex=0
if [ "$TARGET" = claude ] || [ "$TARGET" = both ]; then do_claude=1; fi
if [ "$TARGET" = codex ] || [ "$TARGET" = both ]; then do_codex=1; fi
# Skills fallback: under the given Codex home when --codex-home is set, else ~/.agents/skills.
if [ -z "$AGENTS_SKILLS" ]; then
  if [ "$CODEX_HOME_FLAG" = 1 ]; then AGENTS_SKILLS="$CODEX_HOME_DIR/skills"; else AGENTS_SKILLS="$HOME/.agents/skills"; fi
fi
# Plugin commands must act on the same homes as the files we write.
export CLAUDE_CONFIG_DIR="$CLAUDE_HOME" CODEX_HOME="$CODEX_HOME_DIR"
STAMP="$(date +%Y%m%d%H%M%S)"
DRYFLAG=""; if [ "$DRY" = 1 ]; then DRYFLAG="--dry-run"; fi
TMP="$(mktemp -d)"; trap 'rm -rf "${TMP:?}"' EXIT

blockfile() { node "$REPO/scripts/lib/blockfile.mjs" "$@"; }
verb() { if [ "$DRY" = 1 ]; then echo "would $1"; else echo "$1"; fi; }

install_agents() {
  local dest="$CODEX_HOME_DIR/agents" f name
  if [ "$DRY" != 1 ]; then mkdir -p "$dest"; fi
  for f in "$PLUGIN"/codex/agents/*.toml; do
    name="$(basename "$f")"
    if [ -e "$dest/$name" ] && cmp -s "$f" "$dest/$name"; then
      echo "same $dest/$name"
    elif [ -e "$dest/$name" ] && [ "$FORCE" != 1 ]; then
      echo "SKIP $dest/$name (exists and differs; use --force)"
    else
      if [ -e "$dest/$name" ]; then
        verb "backup $dest/$name -> $name.hap-backup-$STAMP"
        if [ "$DRY" != 1 ]; then cp -p "$dest/$name" "$dest/$name.hap-backup-$STAMP"; fi
      fi
      verb "copy $dest/$name"
      if [ "$DRY" != 1 ]; then cp "$f" "$dest/$name"; fi
    fi
  done
}

uninstall_agents() {
  local dest="$CODEX_HOME_DIR/agents" f name bak
  for f in "$PLUGIN"/codex/agents/*.toml; do
    name="$(basename "$f")"
    if [ -e "$dest/$name" ]; then
      if cmp -s "$f" "$dest/$name"; then
        bak="$(ls -1 "$dest/$name".hap-backup-* 2>/dev/null | sort | tail -n 1 || true)"
        if [ -n "$bak" ]; then
          verb "restore $dest/$name from $(basename "$bak")"
          if [ "$DRY" != 1 ]; then cp -p "$bak" "$dest/$name"; fi
        else
          verb "remove $dest/$name"
          if [ "$DRY" != 1 ]; then rm -f "${dest:?}/${name:?}"; fi
        fi
      else
        echo "KEEP $dest/$name (content differs from ours)"
      fi
    fi
  done
}

copy_skills() {
  if [ ! -d "$PLUGIN/skills" ]; then echo "no skills directory in plugin; nothing to copy"; return 0; fi
  local d name
  if [ "$DRY" != 1 ]; then mkdir -p "$AGENTS_SKILLS"; fi
  for d in "$PLUGIN"/skills/*/; do
    name="$(basename "$d")"
    if [ -e "$AGENTS_SKILLS/$name" ]; then
      if diff -r "$d" "$AGENTS_SKILLS/$name" >/dev/null 2>&1; then echo "same $AGENTS_SKILLS/$name"
      else echo "SKIP $AGENTS_SKILLS/$name (exists and differs)"; fi
    else
      verb "copy skill $AGENTS_SKILLS/$name"
      if [ "$DRY" != 1 ]; then cp -R "$d" "$AGENTS_SKILLS/$name"; fi
    fi
  done
}

uninstall_skills() {
  if [ ! -d "$PLUGIN/skills" ]; then return 0; fi
  local d name
  for d in "$PLUGIN"/skills/*/; do
    name="$(basename "$d")"
    if [ -d "$AGENTS_SKILLS/$name" ] && diff -r "$d" "$AGENTS_SKILLS/$name" >/dev/null 2>&1; then
      verb "remove skill $AGENTS_SKILLS/$name"
      if [ "$DRY" != 1 ]; then rm -rf "${AGENTS_SKILLS:?}/${name:?}"; fi
    fi
  done
}

migrate() {
  local l t
  if [ -d "$CLAUDE_HOME/skills" ]; then
    for l in "$CLAUDE_HOME"/skills/*; do
      if [ ! -L "$l" ]; then continue; fi
      t="$(readlink "$l")"
      case "$t" in
        */claude/skills/*)
          case "$t" in
            *human-agent-process*|"$REPO"/*)
              verb "remove stale skill symlink $l -> $t"
              if [ "$DRY" != 1 ]; then rm -f "${l:?}"; fi ;;
          esac ;;
      esac
    done
  fi
  l="$CLAUDE_HOME/hooks/memory-capture-reminder.sh"
  if [ -L "$l" ]; then
    t="$(readlink "$l")"
    case "$t" in
      *human-agent-process*|"$REPO"/*)
        verb "remove stale hook symlink $l -> $t"
        if [ "$DRY" != 1 ]; then rm -f "${l:?}"; fi
        echo "note: remove the matching hook entry from settings.json by hand if present" ;;
    esac
  fi
}

if [ "$MIGRATE" = 1 ]; then migrate; fi

if [ "$UNINSTALL" = 1 ]; then
  if [ "$do_claude" = 1 ]; then blockfile remove "$CLAUDE_HOME/CLAUDE.md" $DRYFLAG; fi
  if [ "$do_codex" = 1 ]; then
    blockfile remove "$CODEX_HOME_DIR/AGENTS.md" $DRYFLAG
    uninstall_agents
    uninstall_skills
  fi
  if [ "$PLUGIN_CMD" = 1 ] && [ "$DRY" = 0 ]; then
    if [ "$do_claude" = 1 ] && command -v claude >/dev/null 2>&1; then
      claude plugin uninstall human-agent-process@human-agent-process || echo "claude plugin uninstall failed (ignored)"
    fi
    if [ "$do_codex" = 1 ] && command -v codex >/dev/null 2>&1; then
      codex plugin remove human-agent-process@human-agent-process || echo "codex plugin remove failed (ignored)"
      codex plugin marketplace remove human-agent-process || echo "codex marketplace remove failed (ignored)"
    fi
  fi
  echo "uninstall done (backups *.hap-backup-* are kept)"
  exit 0
fi

if [ "$do_claude" = 1 ]; then
  node "$REPO/scripts/build.mjs" --block claude --modules "$MODULES" > "$TMP/claude.block"
  [ -s "$TMP/claude.block" ] || { echo "block generation produced no output; nothing written" >&2; exit 1; }
  blockfile upsert "$CLAUDE_HOME/CLAUDE.md" "$TMP/claude.block" $DRYFLAG
fi
if [ "$do_codex" = 1 ]; then
  node "$REPO/scripts/build.mjs" --block codex --modules "$MODULES" > "$TMP/codex.block"
  [ -s "$TMP/codex.block" ] || { echo "block generation produced no output; nothing written" >&2; exit 1; }
  blockfile upsert "$CODEX_HOME_DIR/AGENTS.md" "$TMP/codex.block" $DRYFLAG
  install_agents
fi

if [ "$do_claude" = 1 ]; then
  echo "Claude Code skills and agents come with the plugin. In Claude Code run:"
  echo "  /plugin marketplace add $REPO"
  echo "  /plugin install human-agent-process@human-agent-process"
  if [ "$PLUGIN_CMD" = 1 ] && [ "$DRY" = 0 ] && command -v claude >/dev/null 2>&1; then
    { claude plugin marketplace add "$REPO" && claude plugin install human-agent-process@human-agent-process; } \
      || echo "claude plugin commands failed; run the two /plugin commands above"
  fi
fi
if [ "$do_codex" = 1 ]; then
  codex_ok=0
  if [ "$PLUGIN_CMD" = 1 ] && [ "$DRY" = 0 ] && command -v codex >/dev/null 2>&1; then
    if codex plugin marketplace add "$REPO" && codex plugin add human-agent-process@human-agent-process; then codex_ok=1
    else echo "codex plugin commands failed; copying skills instead"; fi
  fi
  if [ "$codex_ok" = 0 ]; then copy_skills; fi
fi
if [ "$DRY" = 1 ]; then echo "dry run: nothing written"; fi
exit 0
