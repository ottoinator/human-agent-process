---
name: start-gate
description: Use before any Tier 1+ work, and always before a new project or product. Classifies the request, emits the one-line `hap_gate:` marker, and fills the start-gate record (goal, user, success signal, scope, non-goals, risks, role plan, evidence plan, owner questions with recommendations, own decisions, critic response). Implementation, scaffolding, repository setup and migrations stay blocked until the record says allow_build true.
license: CC-BY-4.0
---

# Start Gate

The hard stop in front of Tier 1+ work. It exists so that scope, risk, and the
proof of "done" are written down before anything is built, and so the owner
sees one bundled set of questions instead of a trickle.

## Step 1: classify and emit the marker

Classify the request with the tiers of the core rules (0 trivial, 1 small,
2 feature or user-facing, 3 new project or product or high risk). A new
project and a new product are the same thing and always Tier 3.

Start the answer with exactly one line:

```text
hap_gate: tier=<0|1|2|3> allow_build=<true|false> critic=<required|not-required>
```

Tier 0 needs no record: emit the line with `allow_build=true`, do the work,
verify it.

## Step 2: for Tier 1+, fill the record

Use `templates/PROJECT_START.md` from the human-agent-process repository, or
an equivalent chat block with the same fields:

- goal, user, success signal, quality bar
- scope and non-goals; what would disappoint even if it runs
- risks and constraints (cost, privacy, safety, data, operations)
- role plan: which of critic, implementer, qa-runner, researcher run, with
  scope, write scope, verification, and output
- evidence plan: the runnable acceptance check with at least one case that
  must pass and one that must fail, and the thinnest end-to-end slice to build
  first
- owner questions, each with a recommendation; or "none"
- the lead's own decisions, so they are visible
- critic response: every blocker and major answered as fixed, owner question,
  accepted risk, deferred, or not applicable
- if the project activates a module (growth, concurrency, routines,
  impact-map, second-opinion, design-reference, remote-review), the module's
  fields from its policy text

## Step 3: decide allow_build

- Tier 1: `allow_build=true` once goal, acceptance check, and owner questions
  are written down.
- Tier 2: `true` after the plan critic has answered and its blockers and
  majors are handled.
- Tier 3: stays `false` until the owner has answered the one bundled
  clarification. After that, no further questions about the project.

Until the marker says `allow_build=true`, do not scaffold, create
repositories, run migrations, set up containers, or write implementation code.
Research, reading, and writing the record itself are allowed.

## Output contract

Return the marker line, the filled record (or its location), the open owner
questions with recommendations, and the next step. Report to the owner in the
fixed form of the core rules: Done, Needed from you, Link.
