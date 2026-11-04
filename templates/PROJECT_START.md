# Project Start

The record of the start gate (see the `start-gate` skill and the core rule
"Tiers and the start gate"). Fill it before any scaffold, repository setup,
migration, or code. Delete fields that do not apply and say why in one line.

```text
hap_gate: tier=<0|1|2|3> allow_build=<true|false> critic=<required|not-required>
```

## Classification

- Tier:
- Intent (new project, feature, fix, ...):
- Repository and visibility:
- Runtime:
- QA command (isolated harness):

## Goal

What are we trying to achieve, and why now?

## User and success signal

Who benefits? How will we know the first useful version is good enough?

## Quality bar

Prototype, internal use, polished slice, production, or public scale?

## Scope and non-goals

- In:
- Out:

## Disappointment risk

What would disappoint even if the implementation runs?

## Constraints and risks

Time, cost, privacy, safety, data, operations, maintenance.

## Research

- Problem:
- Alternatives:
- Patterns worth reusing:
- Non-copy boundaries:

## Role plan

| Role | Why | Scope / write scope | Verification | Output |
| --- | --- | --- | --- | --- |
| critic (pre-build) | | | | |
| implementer | | | | |
| qa-runner | | | | |
| researcher | | | | |
| critic (post-build) | | | | |

## Evidence plan

- Acceptance check (runnable, known answers):
  - must pass:
  - must fail:
- Thinnest end-to-end slice first:

## Owner questions

Each with a recommendation. Write "none" if there are none.

1. Question - recommendation:

## Lead decisions

Decisions taken without asking, so they are visible:

-

## Critic response

| Finding | Severity | Answer (fixed, owner question, accepted risk, deferred, n/a) |
| --- | --- | --- |
| | | |

## Module fields (only for modules the project activates)

- growth: write trigger, size per write/day/month, bound or retention, alarm path
- concurrency: write paths, co-writers, lock, end behaviour, supervised first run
- routines: machine-readable list (id, kind, cadence, max gap, due)
- impact-map: impact inventory, each point adapt / untouched / follow-up
- second-opinion: brief sent, answer, accepted or rejected per point
- design-reference: reference source, asset parity, side-by-side review plan
- remote-review: review link and its response check

## Allow build

`allow_build: false`
