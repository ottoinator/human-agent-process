# Agent Instructions

This repository is a public process toolkit: documentation, installable skills,
copyable templates, and static QA. It is not an application runtime. It is also
an example of the pattern it describes, so keep it honest.

## Read order

1. `README.md`
2. `docs/process/principles.md`
3. `docs/process/lifecycle.md` and `docs/process/quality-gates.md`
4. `docs/knowledge-work/README.md` when the change touches the knowledge flow
5. The skill, template, or example you are changing

The eight files under `docs/process/` that also exist under
`claude/skills/software-dev-process/references/` are kept byte-identical; QA
diffs them. Edit the `docs/` copy and copy it over.

## Boundaries

- `docs/process/` and `docs/knowledge-work/` are normative. They define the process.
- `claude/` mirrors `~/.claude`. `claude/skills/*` are the agent-facing
  contracts; each skill directory must stay self-contained (SKILL.md and its
  `references/`), because it is symlinked out of this repo and read without
  the docs.
- `templates/` are copied into other projects and adapted there.
- `examples/` are illustrative and non-normative.
- `docs/reference/` explains terms, evidence labels, public safety, and memory.
- `scripts/` and `tests/` are static QA only. Process logic stays in the docs.

When a concept changes, change it everywhere it appears in the same commit:
doc, skill, template, example. The QA link check will not catch drift in
meaning; you have to.

## Who decides what

Humans own goal, audience, scope, naming, risk, privacy, cost, licensing,
public positioning, and release. Stop and ask when the next step would decide
one of those.

Agents own reading context first, choosing the smallest coherent change,
verifying with evidence, running QA, and reporting honestly, including what
was not verified.

## Tier rules for changes to this repo

- **Tier 0** — typo, wording, link fix. Just do it and run QA.
- **Tier 1** — a clarified paragraph, a new example section, a template field.
  Name the acceptance check, run QA.
- **Tier 2** — a change to a skill, a gate, a tier definition, or a template
  that others copy. Run an independent critic pass *before* asking the owner
  to review, because these files load into other people's sessions.
- **Tier 3** — a new required gate, a licence change, a public claim, a
  restructure. Write a decision record (`docs/process/decision-records.md`) and
  get an explicit owner decision before building.

## Public safety

Never add secrets, tokens, `.env` files, private logs, transcripts,
screenshots, customer or personal data, internal hostnames, or local machine
paths. Examples are fictional or sanitised. Do not add claims such as
"industry standard", "production-proven", or "validated" without evidence and
a human who stands behind them.

## Required QA

```bash
./scripts/qa.sh
```

If it cannot run, report QA as **blocked** and say why. Do not substitute a
description of what QA would have found.

## Done contract

Before final delivery, report: what changed and why it fits the boundaries ·
tier and whether a critic pass ran (and if it was skipped, why) · QA command
and result · public-safety check result · remaining gaps, including
`human-validation-missing` where honest.
