# Lifecycle And Tiers

Classify the task **before** doing it. The tier decides how much of the rest of
this document applies. When torn between two tiers, name the disappointment
risk out loud and pick the higher tier only if that risk is real.

## Tier 0 — Mini

Direct answer, one-off command, tiny edit, lookup, one-line reply.

Process: none. Do it. Run whatever check is free.

## Tier 1 — Small change

A narrow fix, a local edit, a short note, a single-section update, a routine
status message.

Process:

1. Read the local context.
2. State the acceptance check in one sentence.
3. Do the work.
4. Run the smallest verification that actually exercises it.
5. Report result and check.

## Tier 2 — Substantial

Software: a feature, a multi-file change, user-facing behaviour, a data flow,
runtime behaviour, or **anything that runs unattended or loads into other
people's sessions** (skills, hooks, agents, scheduled jobs) — even when it is a
single file with no state.

Knowledge work: a full briefing, a published page, a customer- or partner-facing
deck, a report, a minutes publication, a dashboard update, a multi-channel
announcement.

Process:

1. Restate intent (principle 1).
2. Reference gate: search memory and prior art, then verify against the source.
3. Structure or architecture gate: outline, boundaries, what is in and out,
   what it supersedes.
4. Surface owner decisions; ask before deciding what is not yours.
5. Implement the smallest coherent slice.
6. QA gate with evidence that matches the claim.
7. **Critic gate** — an independent pass before the owner reviews. Mandatory or
   advisory depending on blast radius; see `critic-gate.md`.
8. Security/privacy pass where data, auth, logs, PII, or outbound side effects
   exist.
9. Deliver where it belongs; capture the durable outcome to memory.
10. Report against the done contract.

## Tier 3 — New or hard to reverse

Software: a new product or repository, a public release, a migration, a major
rewrite, a large architecture decision, something packaged for others to
install.

Knowledge work: new external positioning, a launch plan, a pricing or
go-to-market decision, a leadership proposal, anything that shapes how the
organisation is seen or is costly to walk back.

Process: everything in Tier 2, plus **before** building:

- Discovery: problem, users, alternatives, non-goals, disappointment risk
  (the PROJECT_START template).
- Research lanes: prior art, reference implementations, domain conventions,
  non-copy boundaries.
- An explicit owner-decision pass on goal, scope, quality bar, risk, and
  release. The owner says `allow_build`.

And after building: a post-build critic pass, a security/privacy review, and a
release checklist (the RELEASE_CHECKLIST template).

## Roles

Roles are thinking modes, not headcount (`roles-and-responsibilities.md`). Use
only the ones that reduce risk for this task, and delegate independent passes
(research, QA, critic, security) to separate agents with a clear scope and
output contract (`ai-agent-operating-model.md`).
