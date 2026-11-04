# Changelog

## 2.0.0 - 2026-11-04

One shared core, two generated distributions: a Claude Code plugin and a Codex
plugin with agents and a managed `AGENTS.md` block. Decision record:
`docs/decisions/2026-11-04-two-platforms-one-core.md`.

**Breaking: `claude/` moved to `plugins/`. Run
`scripts/install.sh --migrate-from-1x`.** The symlink-based 1.x install and
`--memory` flag are gone.

- New `core/` holds the always-on rules, optional modules (growth,
  concurrency, routines, impact-map, second-opinion, design-reference,
  remote-review), platform notes, and the four roles (critic, implementer,
  qa-runner, researcher).
- New `start-gate` skill and the `hap_gate:` marker line; templates
  `PROJECT_START.md` and `HANDOFF.md`.
- Skills are platform-neutral and live in `plugins/human-agent-process/skills/`.
- `lightrag-local` is now an example adapter under
  `examples/memory-adapter-lightrag/`, not a shipped skill.
- Removed the 1.x global `CLAUDE.md`, Stop hook, and settings example, and the
  duplicated `docs/process/` and `docs/knowledge-work/` copies; docs link to
  the skill references.
- New docs: start, concepts, modules, platforms, why.
- Docs and skills are CC BY 4.0, code is MIT (`REUSE.toml`).

## 1.1.0 — 2026-09-10

The process is memory-agnostic. Decision record:
`docs/decisions/2026-09-10-memory-adapter.md`.

- Process skills, the done contract, and the templates refer to "the memory
  adapter" instead of `lightrag-local`. QA fails when a process skill names
  the reference store or a shipped adapter.
- The global `CLAUDE.md` splits into adapter-independent memory rules and a
  marked *Installed adapter* block. `claude/memory/lightrag.md` is the block
  for the reference adapter.
- `scripts/install.sh --memory lightrag | none | <file>` chooses the adapter;
  `lightrag` stays the default and keeps the 1.0.0 behaviour.
- Adapter contract in `docs/reference/memory-layer.md`.
- The Stop hook wording no longer assumes a particular client.

## 1.0.0 — 2026-09-10

Initial public release. Supersedes `human-agent-dev-process`.

- Two flows on one spine: software development and knowledge work.
- Blast-radius rule for the critic gate (mandatory vs advisory).
- Provenance rules: authoritative sources, resolve-don't-flag, primary sources
  for named parties, length matched to the reference.
- Memory layer (prior art before, capture after) as part of the done contract.
- Five installable skills: `software-dev-process`, `knowledge-work-process`,
  `critic-reviewer`, `qa-engineer`, `lightrag-local`.
- Claude Code setup: global and project `CLAUDE.md` templates, install script.
- Node-only QA harness with CI; no Docker requirement.
