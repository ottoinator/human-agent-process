---
id: critic-and-evidence
title: Critic before the human, evidence before done
kind: core
---
## Critic before the human, evidence before done

From Tier 2, an independent critic reviews the plan before build and the artefact after build. Self-review does not count. `blocker` stops delivery, `major` is fixed before the owner sees the work, `minor` is optional. Answer every blocker and major: fixed, owner question, accepted risk, deferred, or not applicable.

"Done" needs evidence for every success criterion, never model confidence, a subagent's completion message, a happy path, or an HTTP 200. Define acceptance as a runnable check with known answers: at least one case that must pass and one that must fail. Report done only after you have seen that check green yourself, and report the number of valid results, not the number of runs.

Build the thinnest end-to-end slice first (real input to owner-visible result plus its measurement), then widen. Push is not deploy; runtime claims need health, log, URL, screenshot, or replay evidence.

For a repeated incident, record the violated invariant, the producer-to-consumer path, a falsified alternative explanation, a negative test, and a guardrail. A second break of the same kind requires a systemic guardrail, not another patch.
