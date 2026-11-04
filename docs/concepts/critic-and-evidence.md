# Critic and evidence

## Critic before the human

From Tier 2, an independent critic reviews the plan before build and the
artefact after build, in a fresh context. Self-review does not count.
Severity: `blocker` stops delivery, `major` is fixed before the owner sees
the work, `minor` is optional. Every blocker and major gets an answer: fixed,
owner question, accepted risk, deferred, or not applicable.

The critic checks the premises, not only the prose: do the facts in the brief
exist, and do the sources trace to the system of record?

## Evidence before done

"Done" needs evidence for every success criterion. Not model confidence, not a
subagent's completion message, not a happy path, not an HTTP 200.

- Define acceptance as a runnable check with known answers: at least one case
  that must pass and one that must fail.
- Report done only after you have seen that check green yourself.
- Report the number of valid results, not the number of runs.
- Build the thinnest end-to-end slice first, then widen.
- Push is not deploy; runtime claims need health, log, URL, screenshot, or
  replay evidence.

A repeated incident needs the violated invariant, the producer-to-consumer
path, a falsified alternative, a negative test, and a guardrail. A second
break of the same kind needs a systemic guardrail.

See the story [done on a happy path](../why/happy-path-done.md). Details:
[critic gate](../../plugins/human-agent-process/skills/software-dev-process/references/critic-gate.md),
[critic skill](../../plugins/human-agent-process/skills/critic-reviewer/SKILL.md),
[validation labels](../reference/validation-model.md).
