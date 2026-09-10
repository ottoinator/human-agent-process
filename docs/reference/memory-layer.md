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
capture it as the final step, **following the adapter's write policy** — the
reference adapter captures automatically and silently; a policy-bound adapter
may file a proposal that waits for authorization. Either way the user should
never have to ask "did you save this?": state in one line what was captured,
or what was proposed and is pending.

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
(`../../claude/CLAUDE.md`); an adapter may add stricter ones.

## The memory adapter contract

The process does not depend on a particular store. It depends on a **memory
adapter**: a skill or plugin that the global `CLAUDE.md` names under
*Installed adapter*, and that provides:

1. **Search** — a prior-art query the agent can run before work, with results
   it can cite.
2. **Capture** — an append path for a durable, compact, reusable entry, with
   the adapter's own write policy (automatic, proposed, or contract-bound).
3. **A stored-documents listing**, so coverage can be audited source-first.
4. **A *do not store* list** at least as strict as the one in the global
   `CLAUDE.md`.
5. **No delete.** The adapter exposes no destructive operation to the agent.
6. **An honest unavailable state** — when the store is unreachable the adapter
   says so, and the process skills report that prior-art search and capture
   could not run.

The process skills refer only to "the memory adapter"; the adapter's block in
`CLAUDE.md` (`../../claude/memory/`) carries its commands and its capture
policy. Swapping the store means swapping that block and the adapter skill,
not editing the process.

Claude Code's own auto-memory (`MEMORY.md`) is working memory for one machine
and one project, not an adapter: it has no search across projects and no
capture policy.

## Reference adapter

This repository ships one adapter: a local [LightRAG](https://github.com/HKUDS/LightRAG)
container as the store (`../../memory/`), the `lightrag-local` skill as the
client (`../../claude/skills/lightrag-local/`), and the block
`../../claude/memory/lightrag.md` for the global `CLAUDE.md`. Its capture
policy is *automatic and silent*. Three lessons that transfer to any adapter:

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
