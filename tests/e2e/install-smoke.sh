#!/usr/bin/env bash
# install.sh end-to-end smoke test against temporary homes. Exit non-zero on any failure.
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
INSTALL="$REPO/scripts/install.sh"
T="$(mktemp -d)"; trap 'rm -rf "${T:?}"' EXIT
CH="$T/claude"; XH="$T/codex"; SK="$T/agents-skills"
FAILS=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1"; FAILS=$((FAILS+1)); }
check() { if eval "$2"; then pass "$1"; else fail "$1"; fi; }
run() { bash "$INSTALL" --no-plugin-cmd --claude-home "$CH" --codex-home "$XH" "$@" >"$T/out.log" 2>&1; }
export AGENTS_SKILLS_DIR="$SK"
blocks() { grep -c '^<!-- human-agent-process:begin' "$1" || true; }

mkdir -p "$CH" "$XH/agents"
printf '# My rules\nkeep me\n' > "$CH/CLAUDE.md"
printf 'no trailing newline' > "$XH/AGENTS.md"       # exercises the byte-exact path
printf 'custom = true\n' > "$XH/agents/critic.toml"  # same name, differs
cp "$CH/CLAUDE.md" "$T/claude.orig"; cp "$XH/AGENTS.md" "$T/agents.orig"; cp "$XH/agents/critic.toml" "$T/critic.orig"

run --both; check "install both exits 0" "[ \$? -eq 0 ]"
check "claude block count is 1" "[ \$(blocks '$CH/CLAUDE.md') -eq 1 ]"
check "codex block count is 1" "[ \$(blocks '$XH/AGENTS.md') -eq 1 ]"
check "pre-existing claude content preserved" "head -n 2 '$CH/CLAUDE.md' | cmp -s - '$T/claude.orig'"
check "pre-existing codex content preserved" "head -c 19 '$XH/AGENTS.md' | cmp -s - '$T/agents.orig'"
check "differing agent SKIPped and unchanged" "grep -q 'SKIP .*critic.toml' '$T/out.log' && cmp -s '$XH/agents/critic.toml' '$T/critic.orig'"
check "new agent installed" "cmp -s '$XH/agents/implementer.toml' '$REPO/plugins/human-agent-process/codex/agents/implementer.toml'"
check "plugin commands printed" "grep -q '/plugin install human-agent-process@human-agent-process' '$T/out.log'"

run --both; check "second install exits 0" "[ \$? -eq 0 ]"
check "still one claude block" "[ \$(blocks '$CH/CLAUDE.md') -eq 1 ]"
check "still one codex block" "[ \$(blocks '$XH/AGENTS.md') -eq 1 ]"
run --both --modules all; check "module change replaces in place" "[ \$(blocks '$CH/CLAUDE.md') -eq 1 ] && grep -q 'modules=.*routines' '$CH/CLAUDE.md'"
run --both --modules none; check "modules none" "grep -q 'modules=none' '$CH/CLAUDE.md' && [ \$(blocks '$CH/CLAUDE.md') -eq 1 ]"
check "backup created once" "[ \$(ls '$CH'/CLAUDE.md.hap-backup-* | wc -l) -eq 1 ]"

run --both --dry-run --uninstall; check "dry-run uninstall changes nothing" "[ \$(blocks '$CH/CLAUDE.md') -eq 1 ]"

run --both --uninstall; check "uninstall exits 0" "[ \$? -eq 0 ]"
check "claude file restored byte-identical" "cmp -s '$CH/CLAUDE.md' '$T/claude.orig'"
check "codex file restored byte-identical" "cmp -s '$XH/AGENTS.md' '$T/agents.orig'"
check "custom agent untouched by uninstall" "cmp -s '$XH/agents/critic.toml' '$T/critic.orig'"
check "our agent removed" "[ ! -e '$XH/agents/implementer.toml' ]"

# file that did not exist before install disappears again
NH="$T/fresh"
bash "$INSTALL" --no-plugin-cmd --claude --claude-home "$NH" >/dev/null 2>&1
check "fresh install creates file" "[ -f '$NH/CLAUDE.md' ]"
bash "$INSTALL" --no-plugin-cmd --claude --claude-home "$NH" --uninstall >/dev/null 2>&1
check "uninstall removes file we created" "[ ! -e '$NH/CLAUDE.md' ]"

# migrate-from-1x
mkdir -p "$CH/skills" "$CH/hooks" "$T/old/human-agent-process/claude/skills/software-dev-process" "$T/other"
ln -s "$T/old/human-agent-process/claude/skills/software-dev-process" "$CH/skills/software-dev-process"
ln -s "$T/other" "$CH/skills/unrelated"
touch "$T/old/human-agent-process/memory-capture-reminder.sh"
ln -s "$T/old/human-agent-process/memory-capture-reminder.sh" "$CH/hooks/memory-capture-reminder.sh"
run --claude --migrate-from-1x
check "stale skill symlink removed" "[ ! -L '$CH/skills/software-dev-process' ]"
check "unrelated symlink kept" "[ -L '$CH/skills/unrelated' ]"
check "stale hook symlink removed" "[ ! -L '$CH/hooks/memory-capture-reminder.sh' ]"

# --force overwrites a differing agent
run --codex --force
check "--force overwrites differing agent" "cmp -s '$XH/agents/critic.toml' '$REPO/plugins/human-agent-process/codex/agents/critic.toml'"
check "--force keeps a backup of the foreign agent" "cmp -s \$(ls '$XH'/agents/critic.toml.hap-backup-* | tail -n 1) '$T/critic.orig'"
run --codex --uninstall
check "uninstall after --force restores foreign agent" "cmp -s '$XH/agents/critic.toml' '$T/critic.orig'"

# skills fallback follows --codex-home when AGENTS_SKILLS_DIR is unset
XH2="$T/codex2"
env -u AGENTS_SKILLS_DIR bash "$INSTALL" --no-plugin-cmd --codex --codex-home "$XH2" >/dev/null 2>&1
check "fallback skills under --codex-home" "[ -f '$XH2/skills/start-gate/SKILL.md' ]"

# plugin commands: marketplace add AND plugin add, against the given homes (fake CLIs)
FB="$T/fakebin"; mkdir -p "$FB"
printf '#!/bin/sh\necho "codex CODEX_HOME=$CODEX_HOME $*" >> "%s/calls.log"\n' "$T" > "$FB/codex"
printf '#!/bin/sh\necho "claude CLAUDE_CONFIG_DIR=$CLAUDE_CONFIG_DIR $*" >> "%s/calls.log"\n' "$T" > "$FB/claude"
chmod +x "$FB/codex" "$FB/claude"
XH3="$T/codex3"; CH3="$T/claude3"
PATH="$FB:$PATH" bash "$INSTALL" --both --claude-home "$CH3" --codex-home "$XH3" >/dev/null 2>&1
check "codex marketplace add uses given home" "grep -q 'codex CODEX_HOME=$XH3 plugin marketplace add' '$T/calls.log'"
check "codex plugin add runs (not only marketplace)" "grep -q 'codex CODEX_HOME=$XH3 plugin add human-agent-process@human-agent-process' '$T/calls.log'"
check "claude plugin commands use given home" "grep -q 'claude CLAUDE_CONFIG_DIR=$CH3 plugin install' '$T/calls.log'"
check "no skill copy when plugin installed" "[ ! -e '$XH3/skills/start-gate' ]"
PATH="$FB:$PATH" bash "$INSTALL" --both --claude-home "$CH3" --codex-home "$XH3" --uninstall >/dev/null 2>&1
check "uninstall removes codex plugin" "grep -q 'codex CODEX_HOME=$XH3 plugin remove human-agent-process@human-agent-process' '$T/calls.log'"

# Repo reached through a symlink, called from another directory (macOS /tmp, /var/folders).
mkdir -p "$T/real"; ln -s "$(cd "$(dirname "$INSTALL")/.." && pwd)" "$T/real/repo"; ln -s "$T/real" "$T/link"
CH4="$T/claude4"; XH4="$T/codex4"
(cd / && bash "$T/link/repo/scripts/install.sh" --both --no-plugin-cmd --claude-home "$CH4" --codex-home "$XH4" >/dev/null 2>&1)
check "block has content via symlinked path (claude)" "[ \$(blocks '$CH4/CLAUDE.md') -eq 1 ] && grep -q '## Owner boundary' '$CH4/CLAUDE.md'"
check "block has content via symlinked path (codex)" "[ \$(blocks '$XH4/AGENTS.md') -eq 1 ] && grep -q '## Owner boundary' '$XH4/AGENTS.md'"

# Default install (no --*-home, no env) must not set CLAUDE_CONFIG_DIR/CODEX_HOME for the CLIs.
: > "$T/calls.log"
(env -u CLAUDE_CONFIG_DIR -u CODEX_HOME HOME="$T/home5" PATH="$FB:$PATH" bash "$INSTALL" --both >/dev/null 2>&1)
check "default install leaves CLAUDE_CONFIG_DIR unset" "grep -q 'claude CLAUDE_CONFIG_DIR= plugin install' '$T/calls.log'"
check "default install leaves CODEX_HOME unset" "grep -q 'codex CODEX_HOME= plugin add' '$T/calls.log'"

echo "failures: $FAILS"
[ "$FAILS" -eq 0 ]
