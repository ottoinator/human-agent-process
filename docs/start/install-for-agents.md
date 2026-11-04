# Install for agents

Follow these steps when the owner says "install human-agent-process". Do not
skip the verification. Never print secrets or overwrite files without the
backup the installer makes.

## 1. Detect the platform

- Claude Code if you can run `/plugin` commands or `~/.claude` exists.
- Codex if the `codex` command exists or `~/.codex` exists.
- Both can be true; install both.

## 2. Get the repository

```bash
git clone https://github.com/ottoinator/human-agent-process.git
cd human-agent-process
```

## 3. Dry run, then install

```bash
scripts/install.sh --claude --dry-run     # or --codex, or --both
```

Read the list of files it would write. It writes outside the repository
(instruction file, agents directory) and keeps backups. If it reports an older
1.x install, rerun with `--migrate-from-1x`. If it reports a conflict with
foreign content, stop and tell the owner; do not force it. Then:

```bash
scripts/install.sh --claude               # or --codex, or --both
```

Add `--modules default|all|a,b` only if the owner asked for modules.

**Other locations** (a test, a sandbox, a non-default config directory): the
installer writes outside the repository only under the given homes; the
plugin commands it runs use the same homes:

```bash
scripts/install.sh --both --claude-home /path/claude --codex-home /path/codex
```

Add `--no-plugin-cmd` only when the `claude` or `codex` command is not
available; the installer then prints the plugin commands and, for Codex,
copies the skills.

`--claude-home` and `--codex-home` default to `$CLAUDE_CONFIG_DIR` (or
`~/.claude`) and `$CODEX_HOME` (or `~/.codex`); plugin commands run against
the same homes. `AGENTS_SKILLS_DIR` (the Codex skill fallback) defaults to
`<codex-home>/skills` when `--codex-home` is given, else `~/.agents/skills`.

## 4. Register the plugin

- Claude Code: `/plugin marketplace add ottoinator/human-agent-process`, then
  `/plugin install human-agent-process@human-agent-process`. If you cannot run
  slash commands, give the owner these two lines.
- Codex: the installer already ran `codex plugin marketplace add <checkout>`
  and `codex plugin add human-agent-process@human-agent-process` (or copied
  the skills if that failed). Check with `codex plugin list`: the line must
  say `installed`, not `not installed`.

## 5. Verify

Start a new session (rules load at session start) and answer this test
request: "Add a dark-mode toggle to the settings page."

Your answer must begin with a line of this form:

```text
hap_gate: tier=<0|1|2|3> allow_build=<true|false> critic=<required|not-required>
```

For this request expect `tier=2` and `critic=required`. Also confirm that the
skills `start-gate`, `software-dev-process`, `knowledge-work-process`,
`critic-reviewer`, and `qa-engineer` are listed and that the four roles exist.

If the line is missing: the managed block is not loaded. Check that the
instruction file contains the block (look for the begin and end markers) and
that the session was restarted.

## 6. Report

Report in the owner's form (Done, Needed from you, Link): what was installed,
which modules, what backups exist, and the result of the verification.
Uninstall is `scripts/install.sh --uninstall` with the same platform flag.
