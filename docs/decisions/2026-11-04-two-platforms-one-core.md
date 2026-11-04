# Decision: two platforms, one core

Date: 2026-11-04
Status: accepted

## Context

Version 1.x was a Claude Code setup: skills, a global instruction file, a
hook, and an installer that symlinked into the user's home directory. The same
process was also wanted on Codex. Maintaining two hand-written copies would
drift, as the 1.x docs and skill references already had to be kept byte-equal
by a QA diff.

## Decision

One shared core in `core/` (policy rules, optional modules, role definitions,
platform notes) is the only hand-edited source of rules. A build generates two
distributions: a Claude Code plugin, and a Codex plugin plus agents plus a
managed `AGENTS.md` block. Skills live once in `plugins/human-agent-process/skills/`
and are platform-neutral (no tool names). Modules are optional; growth,
concurrency, and routines are on by default. Every classification starts with
a `hap_gate:` line so loading can be checked. The installer
(`scripts/install.sh`) writes the instruction blocks and agents with backups
and can migrate a 1.x install.

## Alternatives

- **Two hand-maintained forks.** Rejected: drift within a few edits.
- **Skills only, no always-on block.** Rejected: plugins carry no global
  instructions, and without the block the gate and roles are not loaded.
- **Keep one platform.** Rejected: the audience uses both.

## Consequences

Easier: one edit reaches both platforms; the docs link to a single copy of
each reference. Harder: platform differences (turn limits, instruction
loading) must be stated, not hidden, see the platform pages. Breaking: `claude/`
moved to `plugins/`, and the lightrag skill is now an example, not a default.
Existing users run `scripts/install.sh --migrate-from-1x`.
