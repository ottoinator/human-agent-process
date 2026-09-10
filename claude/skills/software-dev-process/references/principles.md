# Principles

Six principles carry the whole process. Everything else in this repository is
an application of them to a tier, a gate, or an artefact type.

## 1. Intent before output

Before producing anything substantial, restate: the goal, why it matters, who
it is for, what success looks like, the quality bar, the constraints, and what
would disappoint the owner even if the result "works". A wrong restatement is
cheap to correct; a wrong artefact is not.

## 2. Scale process with risk

Ceremony follows blast radius, not effort or file type. A one-line fix in a
throwaway script needs nothing. A one-line fix in a skill that runs unattended
in other people's sessions needs a review. Tiers (`docs/process/lifecycle.md`)
exist so that the decision is made once, explicitly, at the start.

## 3. Humans own judgment, agents own execution

Humans decide goal, audience, scope, naming, quality bar, acceptable risk,
privacy posture, cost, licensing, positioning, and release. Agents read context,
choose the smallest coherent change, implement, verify, and report. An agent
that silently decides a business trade-off has left its lane; a human who has to
debug work an agent called finished has been let down by it.

## 4. Claims need evidence

"Done", "tested", "validated", "secure", and "production-ready" are claims.
Each needs an artefact behind it: a test run, a rendered page, a screenshot, a
diff against the source of record, a review. Use the weakest honest claim.
Where real human, user, or market validation has not happened, say
`human-validation-missing` (see the evidence labels in `quality-gates.md` and `docs/reference/validation-model.md`).

Provenance is part of evidence. Verify against the **authoritative** source —
the running system, the source code, the system of record, the primary
document. Marketing material, plans, tickets, and your own earlier artefacts
are leads, not proof (see the `knowledge-work-process` skill).

## 5. Secrets out, specifics in

Never commit secrets, credentials, tokens, API keys, or passwords. Reference an
environment variable, never a value. That boundary is absolute.

Do not generalise it into abstracting away operational detail. Inside a private
team repository, skills work *because* they name the specifics: real page IDs,
channel names, fixture data. Confidential source material is kept out of shared
history by a `.gitignore` next to the data, not by watering down the skill that
reads it.

The test is not the repository's visibility but whether *this particular
material* is going somewhere you do not control. Inside a private repo, keep
the specifics. For anything genuinely published, abstract the operational
detail out of the published copy and keep the specific version private. This
repository is the published copy.

## 6. Done means integrated and verified

Done is not "the code changed" or "I wrote the text". Done is: the change is
where it belongs, it was verified with evidence that matches the claim, an
independent critic saw substantial work before the owner did, the durable
outcome is captured where the next person will find it, and the final report
says what was and was not verified.
