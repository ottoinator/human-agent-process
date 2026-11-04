#!/usr/bin/env bash
# QA in Docker. Default: runs on the COMMITTED HEAD (git bundle -> clone inside the image),
# so uncommitted changes are not tested. --worktree: mounts the working tree read-only (fast local loop).
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO"
MODE=head
for a in "$@"; do
  case "$a" in
    --worktree) MODE=worktree ;;
    -h|--help) echo "usage: scripts/qa.sh [--worktree]"; exit 0 ;;
    *) echo "unknown option: $a" >&2; exit 2 ;;
  esac
done
command -v docker >/dev/null 2>&1 || { echo "QA blocked: docker not available" >&2; exit 1; }

CTX="$(mktemp -d)"; trap 'rm -rf "${CTX:?}"' EXIT
cp Dockerfile.qa "$CTX/Dockerfile.qa"
if [ "$MODE" = head ]; then
  git bundle create "$CTX/repo.bundle" HEAD >/dev/null 2>&1
  QA_CONTEXT="$CTX" docker compose -f compose.yaml run --rm --build qa
else
  : > "$CTX/repo.bundle"
  docker build -q -f "$CTX/Dockerfile.qa" --target base -t hap-qa-base "$CTX" >/dev/null
  docker run --rm -v "$REPO:/src:ro" -w /src hap-qa-base bash -c 'npm test && bash tests/e2e/install-smoke.sh'
fi
echo "QA passed ($MODE)"
