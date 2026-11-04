# Codex

The Codex distribution has three parts: plugin skills, four custom agents, and
an always-on policy block.

## Install

From a checkout of this repository, run:

```bash
scripts/install.sh --codex
codex plugin list    # human-agent-process@human-agent-process  installed, enabled
```

The installer writes the managed policy block, copies the custom-agent files,
adds the checkout as a Codex plugin marketplace and installs the plugin that
provides the skills (`codex plugin add human-agent-process@human-agent-process`).
If either plugin command fails, the installer copies the skills to
`~/.agents/skills/` (or `<codex-home>/skills` with `--codex-home`) instead;
use those fallback copies or run
`codex plugin marketplace add <repository-path-or-url>` and
`codex plugin add human-agent-process@human-agent-process` by hand. Start a new Codex session after installation.

## Installed files and use

- The plugin provides `critic-reviewer`, `knowledge-work-process`,
  `qa-engineer`, `software-dev-process`, and `start-gate`. Codex may select a
  matching skill automatically; invoke one explicitly as `$skill-name`.
- `~/.codex/agents/*.toml` defines the `critic`, `implementer`, `qa-runner`,
  and `researcher` custom agents. Ask Codex to delegate a bounded task to a
  named agent. In the CLI, `/subagents` inspects or switches among threads;
  it does not install or configure agents.
- The installer maintains a marked block in `~/.codex/AGENTS.md` and keeps
  backups when it changes that file. Codex stops adding discovered instruction
  files when their combined size reaches `project_doc_max_bytes`, 32 KiB by
  default. This project separately limits its generated all-modules block to
  12 KiB.

## Differences from Claude Code

Codex plugins package skills but do not provide plugin-level always-on global
instructions, so Codex needs the managed `AGENTS.md` block. Codex custom agents
also have no enforced per-agent turn budget; the role budget is an instruction
and ends at a checkpoint. A custom-agent TOML cannot replace the parent
session's sandbox or approval policy. Read-only role instructions are
behavioral; choose enforceable permissions for the parent session.

## Uninstall

```bash
scripts/install.sh --codex --uninstall
```

The installer removes the plugin (`codex plugin remove`), its marketplace, its
marked policy block, unchanged generated agent files (restoring a file it
backed up under `--force`), and any
fallback skill directories whose contents still exactly match this
distribution. It retains backup files; differing agent or fallback skill files
are kept and reported.

## Troubleshooting

- If skills are missing, run `codex plugin list`, confirm the plugin is
  installed and enabled, then start a new session.
- If the plugin is unavailable, run `codex plugin marketplace list`, add the
  repository again, and retry `codex plugin add`.
- If an agent is missing, confirm its TOML file is in `~/.codex/agents/` and
  start a new session.
- If the policy is missing, check whether `~/.codex/AGENTS.override.md` exists;
  a non-empty override takes precedence over `~/.codex/AGENTS.md`. Also check
  the 32 KiB instruction limit.
- If a role can edit despite saying read-only, tighten the parent session's
  permissions. Custom-agent files inherit those settings.

See the [quickstart](../start/quickstart.md) and
[install for agents](../start/install-for-agents.md).
