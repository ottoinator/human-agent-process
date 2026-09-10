#!/usr/bin/env bash
# Stop hook: remind ONCE per session to verify memory capture. Non-blocking.
# Installs via settings.example.json -> ~/.claude/settings.json ("hooks.Stop").
input=$(cat)
sid=$(printf '%s' "$input" | sed -n 's/.*"session_id" *: *"\([^"]*\)".*/\1/p' | head -1)
sid="${sid:-nosession}"
marker="${TMPDIR:-/tmp}/claude-memory-capture-${sid}"
if [ ! -e "$marker" ]; then
  : > "$marker"
  cat <<'JSON'
{"suppressOutput":true,"hookSpecificOutput":{"hookEventName":"Stop","additionalContext":"Capture check (global memory rule): if this session produced a durable decision, project-status change, meeting outcome, customer/partner update, or reusable lesson, confirm it is captured in the memory layer (lightrag.sh docs) before ending — a repo or project-file note is NOT capture. Self-audit source-first, then report."}}
JSON
fi
exit 0
