# Project Agent Instructions

Copy this file into a project root and adapt the placeholders.

## Project Context

- Project name: `<name>`
- Project intent: `<business | private | learning | internal tool | public product>`
- Primary users: `<users>`
- Quality bar: `<prototype | internal | polished slice | production | public-scale>`

## Working Rules

- Read local context before editing.
- Classify every task as Tier 0, 1, 2, or 3.
- Ask the owner before deciding goal, scope, user impact, safety, privacy, cost,
  release, or irreversible operations.
- Keep changes scoped.
- Prefer existing project patterns.
- Do not commit secrets, private data, logs, or generated noise.

## Tier Guide

- Tier 0: direct answer or tiny command.
- Tier 1: small local fix; define acceptance check and run focused QA.
- Tier 2: feature or workflow change; run product, architecture, QA, and critic
  gates as relevant.
- Tier 3: new product, major rewrite, public release, or hard-to-reverse
  decision; run full discovery and validation.

## Required Checks

Project QA command:

```bash
<qa-command>
```

If QA cannot run, report it as blocked with the reason.

## Done Contract

Before final delivery, report:

- Result.
- Files changed.
- Verification command and result.
- Security/privacy review when relevant.
- Runtime or artifact proof when relevant.
- Remaining risks and evidence gaps.
