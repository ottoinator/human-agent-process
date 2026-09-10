#!/usr/bin/env bash
# Install the Claude Code layer of human-agent-process into ~/.claude.
# Symlinks the process skills (so `git pull` updates them), copies the hook,
# installs the global CLAUDE.md only if none exists, and pastes the chosen
# memory adapter's block into it. Never overwrites a file; with an explicit
# --memory it replaces only the marked adapter block of an existing CLAUDE.md.
# --uninstall reverses the symlinks and the hook.
#
#   ./scripts/install.sh                   # process + reference adapter (LightRAG)
#   ./scripts/install.sh --memory none     # process only; reports will say memory did not run
#   ./scripts/install.sh --memory <file>   # process + your own adapter block
#   ./scripts/install.sh --uninstall
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
SRC="$REPO/claude"
PROCESS_SKILLS=(software-dev-process knowledge-work-process critic-reviewer qa-engineer)
MEMORY="lightrag"
MEMORY_EXPLICIT=0

say() { printf '%s\n' "$*"; }
die() { say "error: $*" >&2; exit 1; }

link_skill() {
  local d="$SRC/skills/$1" target="$CLAUDE_HOME/skills/$1"
  [ -d "$d" ] || die "no such skill in repo: $1"
  if [ -L "$target" ]; then
    ln -sfn "$d" "$target"; say "updated symlink  $target"
  elif [ -e "$target" ]; then
    say "SKIP  $target exists and is not a symlink — remove it to install this skill"
  else
    ln -s "$d" "$target"; say "linked  $target"
  fi
}

has_markers() {
  grep -q '<!-- memory-adapter:begin -->' "$1" && grep -q '<!-- memory-adapter:end -->' "$1"
}

# Replace the block between the memory-adapter markers with the adapter file.
paste_adapter() {
  local claude_md="$1" block="$2"
  has_markers "$claude_md" || die "$claude_md has no memory-adapter markers; append $block by hand"
  local tmp; tmp="$(mktemp)"
  awk -v block="$block" '
    /<!-- memory-adapter:begin -->/ { print; while ((getline line < block) > 0) print line; skip=1; next }
    /<!-- memory-adapter:end -->/   { skip=0 }
    !skip { print }
  ' "$claude_md" > "$tmp" && mv "$tmp" "$claude_md"
}

uninstall() {
  for d in "$SRC"/skills/*/; do
    name="$(basename "$d")"
    link="$CLAUDE_HOME/skills/$name"
    if [ -L "$link" ]; then rm "$link"; say "removed symlink $link"; fi
  done
  hook="$CLAUDE_HOME/hooks/memory-capture-reminder.sh"
  [ -f "$hook" ] && rm "$hook" && say "removed $hook"
  say "left $CLAUDE_HOME/CLAUDE.md and settings.json untouched — edit by hand."
}

while [ $# -gt 0 ]; do
  case "$1" in
    --uninstall) uninstall; exit 0 ;;
    --memory) [ $# -ge 2 ] || die "--memory needs a value: lightrag | none | <file>"; MEMORY="$2"; MEMORY_EXPLICIT=1; shift 2 ;;
    -h|--help) sed -n '2,12p' "$0" | grep -v '^set '; exit 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done

# Resolve the adapter block before touching anything.
ADAPTER_BLOCK=""
case "$MEMORY" in
  none) ;;
  lightrag) ADAPTER_BLOCK="$SRC/memory/lightrag.md" ;;
  *) ADAPTER_BLOCK="$MEMORY"; [ -f "$ADAPTER_BLOCK" ] || die "adapter block not found: $ADAPTER_BLOCK" ;;
esac

mkdir -p "$CLAUDE_HOME/skills" "$CLAUDE_HOME/hooks"

# Process skills: symlink each directory.
for s in "${PROCESS_SKILLS[@]}"; do link_skill "$s"; done
# The reference adapter ships its own skill.
[ "$MEMORY" = "lightrag" ] && link_skill lightrag-local

# Hook: copy (hooks are referenced by absolute path from settings.json).
hook_dst="$CLAUDE_HOME/hooks/memory-capture-reminder.sh"
if [ -e "$hook_dst" ]; then
  say "SKIP  $hook_dst exists"
else
  cp "$SRC/hooks/memory-capture-reminder.sh" "$hook_dst"; chmod +x "$hook_dst"
  say "copied  $hook_dst"
fi

# Global CLAUDE.md: install only if absent, then paste the adapter block.
if [ -e "$CLAUDE_HOME/CLAUDE.md" ]; then
  say "SKIP  $CLAUDE_HOME/CLAUDE.md exists — merge $SRC/CLAUDE.md into it by hand"
  if [ "$MEMORY_EXPLICIT" = 1 ] && [ -n "$ADAPTER_BLOCK" ] && has_markers "$CLAUDE_HOME/CLAUDE.md"; then
    paste_adapter "$CLAUDE_HOME/CLAUDE.md" "$ADAPTER_BLOCK"
    say "replaced the memory-adapter block in $CLAUDE_HOME/CLAUDE.md with $ADAPTER_BLOCK"
  elif [ -n "$ADAPTER_BLOCK" ]; then
    say "      and paste $ADAPTER_BLOCK between its memory-adapter markers (pass --memory explicitly to have this done for you)"
  fi
else
  cp "$SRC/CLAUDE.md" "$CLAUDE_HOME/CLAUDE.md"; say "installed  $CLAUDE_HOME/CLAUDE.md"
  if [ -n "$ADAPTER_BLOCK" ]; then
    paste_adapter "$CLAUDE_HOME/CLAUDE.md" "$ADAPTER_BLOCK"; say "memory adapter: $MEMORY ($ADAPTER_BLOCK)"
  else
    say "memory adapter: none — reports will state that prior-art search and capture could not run"
  fi
fi

say
say "Next: merge claude/settings.example.json into $CLAUDE_HOME/settings.json (hooks.Stop)"
[ "$MEMORY" = "lightrag" ] && say "      and set up the memory service: memory/README.md"
exit 0
