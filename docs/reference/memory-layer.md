# The Memory Layer

The process assumes a persistent, searchable memory that outlives the session:
a second brain for decisions, people, projects, customers and partners,
runbooks, and lessons. It is not a separate workflow. It is the **BEFORE** and
**AFTER** of every substantial task.

## Before: prior art

For any task touching an active project, a meeting, a named external party, a
strategic or product decision, a recurring operation, or non-trivial technical
work: search memory first, with two or three phrasings. Treat the result as
prior art — a hypothesis to verify against the current source, not a fact.

## After: capture

If the task produced a durable artefact (a decision, a meeting outcome, a
project status, a customer update, a lesson, a runbook, a published page),
capture it as the final step, **automatically, without asking**. The user
should never have to ask "did you save this?". State in one line what was
captured.

Skip when the content fails the quality bar (durable, compact, reusable),
falls under *do not store*, or already exists unchanged. Ask first only when
durability is genuinely ambiguous.

## Auditing coverage

"Did I capture everything?" is not answered by searching memory for known
items. Walk the sources of the recent work — files modified in the last days,
pages recently published — then diff against the list of stored documents.
Presence is searchable; absence requires walking the sources.

## Quality bar and exclusions

One screen, not a log dump. Never secrets, HR-confidential material,
unapproved confidential documents, raw dumps without a summary, or transient
status. The full lists live in the global `CLAUDE.md`
(`../../claude/CLAUDE.md`) and the `lightrag-local` skill.

## Reference implementation

This repository uses a local [LightRAG](https://github.com/HKUDS/LightRAG)
container as the store (`../../memory/`) and the `lightrag-local` skill as the
client (`../../claude/skills/lightrag-local/`). Any store with search and
append and a naming convention would do; the rules above do not depend on the
implementation. Three lessons that do transfer:

- **Name the source on the first write.** Dedupe is by content hash; a bad
  label is cosmetic and not worth deletion risk.
- **Have no delete in the client.** A bulk-delete endpoint once wiped an
  entire store while returning success.
- **Back up before you need to**, and make the backup refuse to overwrite good
  history with an empty store.

## In a shared repository

Memory is per person. Cross-person continuity comes from what the team commits
to its shared repository, so routine recurring artefacts already recorded
there need not be duplicated into memory. Reserve capture for durable,
reusable, cross-cutting knowledge.
