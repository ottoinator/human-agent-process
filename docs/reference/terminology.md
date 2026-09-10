# Terminology

**Agent** — an AI system acting on a task with tools, context, and instructions.

**Owner** — the human decision-maker for goal, audience, scope, naming, risk,
privacy, cost, and release. "Business owner" in the software flow.

**Tier** — the risk class of a task (0–3) that decides how much process applies.
Classified before the work starts.

**Gate** — a decision point that checks whether work can proceed, needs
revision, or requires owner input. Product intent, reference, structure or
architecture, QA, critic, security/privacy.

**Critic gate** — an independent review, from the audience's perspective, run
before the owner sees Tier 2/3 work. Mandatory or advisory by blast radius.

**Blast radius** — who is affected when the change is wrong, and how soon
anyone would notice. The property that prices the critic gate.

**Evidence** — an artefact that supports a claim: a test result, a rendered
page, a screenshot, a diff against the source of record, a review.

**Authoritative source / system of record** — where a fact actually lives:
source code, the running system, the product knowledge base, live data, the
signed document. Everything else is a lead.

**Provisional** — a claim grounded only in a lead, labelled as such, to be
verified before delivery.

**Load-bearing claim** — a claim the artefact's conclusion depends on. Resolve
it before producing; do not flag it inside the artefact.

**Knowledge work** — work whose output is a document or a decision rather than
code: briefings, pages, decks, reports, minutes, dashboards, updates.

**Memory layer / second brain** — the persistent, searchable store of decisions,
people, projects, and lessons. Searched before work, written after.

**Capture** — writing the durable outcome of a task to the memory layer. Part of
*done* for Tier 2/3.

**`human-validation-missing`** — an explicit marker that real user, customer,
market, or expert validation has not happened.

**Done contract** — the conditions that must be satisfied before work is
honestly complete.
