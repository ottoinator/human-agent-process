# Walkthrough: a Tier 2 software change

Fictional, to show the shape of a run. A personal CLI tool that syncs a
calendar to a task list; the owner wants a `--dry-run` flag.

## 1. Intent

Owner: "Add a dry-run flag so I can see what would change before it writes."

Agent restates: goal (preview writes without side effects), user (the owner),
success signal (running with the flag produces the same plan as a real run and
touches nothing), quality bar (internal tool, no release), disappointment risk
(a dry run that still writes, or a preview that differs from the real run).

## 2. Context and tier

The repo commits straight to `main`, has a test suite (`npm test`), no CI.
Tier 2: multi-file, changes runtime behaviour. Critic gate: **advisory** —
the tool's only consumer is its author, nothing runs unattended. The agent
decides to run it anyway because the disappointment risk is a silent write.

## 3. Owner questions

None that block: the flag name is conventional and the output format follows
the existing log style. Stated as assumptions.

## 4. Prior art

Memory search finds a lesson from another tool: "dry-run implemented as a
boolean threaded through every writer — missed one; centralise the write path
first." Agent verifies the current code has two write sites and refactors
them behind one function before adding the flag.

## 5. Implement, verify

Smallest slice: one write gateway, one flag, one test that asserts zero writes
and identical plan output under the flag. `npm test` passes.

## 6. Critic

A fresh general-purpose agent, briefed as "the owner, six months from now,
trusting the dry run": finds that the flag is not mentioned in `--help`
(minor) and that a failed network fetch under dry-run still logs "would
write" for stale data (major — a misleading preview). Agent fixes both,
re-runs the tests.

## 7. Land, capture, report

Commits to `main` per the repo's convention. Captures a runbook entry:
"centralise the write path before adding dry-run; make dry-run surface fetch
failures rather than previewing stale data."

Report: context (personal repo, commits to main, no CI) · Tier 2 · no owner
questions, two assumptions · gates: intent, reference, QA, critic (advisory,
run) · result · files · `npm test` output · claim status: tested, not used in
anger yet (`human-validation-missing`) · captured: one runbook entry.
