# Decision: the process is memory-agnostic; the store is an adapter

Date: 2026-09-10
Status: accepted

## Context

Version 1.0.0 wired the process skills to one store: `software-dev-process`,
`knowledge-work-process`, the quality-gates done contract, the templates, and
the global `CLAUDE.md` all named `lightrag-local`. Anyone running a different
memory (a team knowledge service, a hosted vector store, a policy-bound
long-term memory with its own write contract) had to fork the process to swap
the store — and the fork then drifted from upstream.

## Decision

The process names only "the memory adapter". An adapter is a skill or plugin
that meets the contract in `docs/reference/memory-layer.md`: search, capture
with its own write policy, a stored-documents listing, a *do not store* list,
no delete, an honest unavailable state. The global `CLAUDE.md` carries the
adapter-independent rules and a marked *Installed adapter* block;
`scripts/install.sh --memory` pastes the chosen adapter's block
(`claude/memory/<adapter>.md`) into it. LightRAG stays as the reference
adapter and the default.

QA enforces the split: the four process skills must not name the reference
store or any adapter shipped under `claude/memory/`, the markers must exist,
and every adapter block must be non-trivial.

## Alternatives

- **Keep LightRAG hard-wired; maintain private forks.** Rejected: every
  process improvement would need a manual merge into each fork, and the forks
  would silently diverge in gate semantics.
- **Make memory optional and drop it from the done contract.** Rejected:
  capture is what makes the next session cheaper; removing it from *done*
  removes the reason it happens.
- **Describe adapters in prose only, without markers or a test.** Rejected:
  the wiring would drift back to one store within a few edits.

## Consequences

Easier: swapping the store is a one-file change plus an adapter skill; the
process can be installed without any memory service and reports the gap
honestly. Harder: adapter authors must write their own block and keep the
capture policy explicit. Riskier: a weak adapter (no listing, or a delete
path) can be plugged in; the contract is a checklist, not enforcement.

## Evidence

- `tests/check-skills.mjs` fails when a process skill names the reference
  store or a shipped adapter.
- `scripts/install.sh --memory none` installs a working process layer whose
  reports state that memory did not run.
- Origin: a second installation of this process on a machine whose long-term
  memory is a policy-bound service with a classified write contract, where the
  1.0.0 layer could not be installed without contradicting local rules.
