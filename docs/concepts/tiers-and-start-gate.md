# Tiers and the start gate

Every request is classified before work starts.

| Tier | Meaning | Minimum process |
| --- | --- | --- |
| 0 | Trivial, reversible | do it, verify it |
| 1 | Small change, clear intent | one matching review or QA pass |
| 2 | Feature, workflow, user-facing | research, plan, critic before and after build, QA |
| 3 | New project or product, or high risk | Tier 2 plus deep research, architecture, owner clarification |

A new project and a new product are the same thing: always Tier 3.

## The start gate

From Tier 1 up, nothing is scaffolded, set up, migrated, or coded until the
start gate record says `allow_build: true`. The record states goal, user,
success signal, scope, non-goals, risks, role plan, evidence plan, owner
questions with recommendations, the lead's own decisions, and the critic's
answer. Tier 3 stays `false` until the owner has answered the one bundled
clarification.

Template: [`templates/PROJECT_START.md`](../../templates/PROJECT_START.md).
Skill: [start-gate](../../plugins/human-agent-process/skills/start-gate/SKILL.md).

## The marker line

Every classification begins with one machine-readable line:

```text
hap_gate: tier=<0|1|2|3> allow_build=<true|false> critic=<required|not-required>
```

Humans scan it, tools can check it, and a missing line is the quickest sign
that the rules are not loaded.

## Detail

Tier definitions and gates in depth:
[lifecycle](../../plugins/human-agent-process/skills/software-dev-process/references/lifecycle.md)
and
[quality gates](../../plugins/human-agent-process/skills/software-dev-process/references/quality-gates.md).
