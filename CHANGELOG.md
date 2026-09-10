# Changelog

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
