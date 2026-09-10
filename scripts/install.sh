#!/usr/bin/env bash
# Install the Claude Code layer of human-agent-process into ~/.claude.
# Symlinks skills (so `git pull` updates them), copies the hook, installs the
# global CLAUDE.md only if none exists. Never overwrites. --uninstall reverses
# the symlinks and the hook.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
SRC="$REPO/claude"

say() { printf '%s\n' "$*"; }

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

if [ "${1:-}" = "--uninstall" ]; then uninstall; exit 0; fi

mkdir -p "$CLAUDE_HOME/skills" "$CLAUDE_HOME/hooks"

# Skills: symlink each directory.
for d in "$SRC"/skills/*/; do
  name="$(basename "$d")"
  target="$CLAUDE_HOME/skills/$name"
  if [ -L "$target" ]; then
    ln -sfn "${d%/}" "$target"; say "updated symlink  $target"
  elif [ -e "$target" ]; then
    say "SKIP  $target exists and is not a symlink — remove it to install this skill"
  else
    ln -s "${d%/}" "$target"; say "linked  $target"
  fi
done

# Hook: copy (hooks are referenced by absolute path from settings.json).
hook_dst="$CLAUDE_HOME/hooks/memory-capture-reminder.sh"
if [ -e "$hook_dst" ]; then
  say "SKIP  $hook_dst exists"
else
  cp "$SRC/hooks/memory-capture-reminder.sh" "$hook_dst"; chmod +x "$hook_dst"
  say "copied  $hook_dst"
fi

# Global CLAUDE.md: install only if absent.
if [ -e "$CLAUDE_HOME/CLAUDE.md" ]; then
  say "SKIP  $CLAUDE_HOME/CLAUDE.md exists — merge $SRC/CLAUDE.md into it by hand"
else
  cp "$SRC/CLAUDE.md" "$CLAUDE_HOME/CLAUDE.md"; say "installed  $CLAUDE_HOME/CLAUDE.md"
fi

say
say "Next: merge claude/settings.example.json into $CLAUDE_HOME/settings.json (hooks.Stop),"
say "      and set up the memory service: memory/README.md"
