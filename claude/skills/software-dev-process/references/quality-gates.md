# Quality Gates

A gate is a decision point: proceed, revise, or ask the owner. Run only the
gates the tier and risk require. Never report a gate as passed without having
run it.

## Product intent

Who is this for, what should it enable them to decide or do, what would make it
land flat even if it is technically correct? Output: goal, user value, scope,
non-goals, acceptance criteria, owner questions.

## Research / reference

Search memory and prior art first; then verify against the actual source
(repository, running system, transcript, data export, primary document). Priors
are hypotheses. Output: what exists already, what to reuse, what not to copy,
what the authoritative source says.

## Architecture / structure

Software: boundaries, state, data flow, dependencies, runtime shape, migration
path, alternatives rejected. Knowledge work: the outline, what is in and out,
naming, where it lives, what it supersedes. Output: chosen design and why.

## QA

QA is project-defined. Use whatever actually exercises the change in *this*
project: the test suite, a selftest oracle, a dry run, lint and typecheck, a
real run against a scratch target, a rendered page, a screenshot. Pick the
cheapest check that produces real evidence for the claim. Report **pass /
fail / blocked**, never silently optimistic. A blocked check is not a passed
check.

For knowledge artefacts the QA gate is spelled out in
the `knowledge-work-process` skill: renders and publishes, names exact, claims trace
to source, audience fit, index updated.

## Critic

An independent review of the artefact from the real audience's perspective,
with findings tagged blocker / major / minor, run **before** the owner reviews.
When it is mandatory, when it is advisory, and how to brief it are in
`critic-gate.md`. A blocker stops delivery until fixed or explicitly accepted by
the owner.

## Security / privacy

Where secrets, auth, permissions, private data, logs, PII, outbound actions, or
a public boundary are involved: verdict, risks, required fixes, residual risk.
For published material: no secrets, no unapproved confidential content, correct
audience framing (beta vs. generally available), no customer PII.

## Done contract

Work is done when the relevant slice satisfies all of:

- Intent is clear or assumptions are explicit.
- Owner decisions are resolved or explicitly deferred.
- Scope and non-goals are clear.
- The change is complete and scoped.
- QA evidence matches the claims.
- The critic gate ran where required, and its blocker/major findings are fixed
  — or, where advisory, the report says it was skipped and why.
- Security/privacy review ran where relevant.
- Documentation changed where behaviour changed.
- The artefact is delivered where it belongs.
- Names, claims, and audience are verified.
- The durable outcome is captured to memory (the `lightrag-local` skill).
- The final report states evidence, whether the critic ran, and remaining gaps
  honestly, with `human-validation-missing` where that is the truth.
