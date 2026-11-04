---
id: tiers-and-start-gate
title: Tiers and the start gate
kind: core
---
## Tiers and the start gate

Classify every request before acting:

| Tier | Meaning | Minimum process |
|---|---|---|
| 0 | Trivial, reversible (typo, rename, one-line fix) | do it, verify it |
| 1 | Small change with a clear owner intent | one matching review or QA pass |
| 2 | Feature, workflow, or anything user-facing | research, plan, critic before and after build, QA |
| 3 | New project or product, or high risk (money, data, security, public) | Tier 2 plus deep research, architecture, owner clarification |

A new project and a new product are the same thing and always Tier 3.

For Tier 1 and above, run the **start gate** before any scaffold, repository setup, migration, or code change. It records goal, user, success signal, scope, non-goals, risks, the subagent plan, the evidence that will prove "done", the owner questions (each with a recommendation), the lead's own decisions, and the critic's response. Implementation starts only when the gate says `allow_build: true`. A Tier 3 gate keeps `allow_build: false` until the owner has answered the clarification.

Start your first reply to every new request, Tier 0 included, with one machine-readable line, so humans and tools can check the classification:

`hap_gate: tier=<0|1|2|3> allow_build=<true|false> critic=<required|not-required>`

Example for a typo fix: `hap_gate: tier=0 allow_build=true critic=not-required`.

Use `templates/PROJECT_START.md` from the human-agent-process repository for the gate record.
