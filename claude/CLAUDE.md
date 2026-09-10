# Working Process (Human-Agent Process)

How non-trivial work gets done here. The detailed model lives in two skills;
invoke the matching one for Tier 2/3 work:

- **`knowledge-work-process`** — briefings, published pages, decks, reports,
  minutes, dashboards, chat and ticket updates, positioning and go-to-market.
- **`software-dev-process`** — features, increments, fixes, prototypes, repos,
  releases, and agent tooling (skills, hooks, automations).

Both share the stance, tiers, and done contract below. The memory layer (below)
is this process's **memory**: the BEFORE (prior art) and AFTER (capture) steps,
not a separate workflow.

## Core stance

- **Intent before output.** Restate goal, who it is for, what success looks
  like, and what would disappoint even if it "works", before producing.
- **Scale process with risk.** Tiny tasks stay tiny; hard-to-reverse work gets
  real gates. No process theatre, no recklessness.
- **Humans own judgment, agents own execution.** Ask the owner before deciding
  goal, scope, audience, naming, risk, privacy, cost, release, or anything
  irreversible. Otherwise execute, verify, report.
- **Claims need evidence.** Do not call work done, validated, or
  production-ready beyond the evidence. Say `human-validation-missing` when
  that is the truth.
- **AI critic before human review.** For Tier 2/3 work, run an AI critic pass
  — spawn a fresh general-purpose agent with `critic-reviewer/SKILL.md` as its
  brief plus the premises to check; invoking the skill inside the producing
  session is self-review and does not satisfy the gate — and fix its
  blocker/major findings *before* the owner sees the artefact. The owner is the **final acceptance** critic, not the first.
  Self-review by the producing agent does not count. Where the gate is
  mandatory, skipping it is a process failure even if the output happens to be
  fine. **Advisory governs whether you run the pass, never whether you act on
  it**: a blocker from a pass you did run still stops delivery until fixed or
  explicitly accepted by the owner.

  Scope it by what the change *is*, not by which repo it sits in.

  **Mandatory:**
  - **All Tier 2/3 knowledge work** — anything a customer or the whole
    organisation sees. For content this *is* the quality gate; there is no PR
    behind it.
  - **Code that runs unattended or loads into other sessions**, wherever it
    lives: skills, agents, commands, hooks and their scripts, a job runner that
    invokes an agent on its own.
  - **Anything hard to reverse or serving other people:** auth, money, data
    migration or deletion, multi-tenant or access-control changes, a public
    release, a deployed customer-facing app.

  **Advisory — everything else**, i.e. ordinary Tier 2/3 software work in a
  repo whose only consumer is its author. Default to running it; skip only when
  you can name why *this change* is below the bar, and **name that reason in
  the report.** Never let a report imply a gate ran when it did not.

## Tiers (covers code AND knowledge work)

- **Tier 0** — direct answer / tiny edit. Just do it.
- **Tier 1** — small artefact or local fix. Read context, define the
  acceptance check, verify the one thing that matters.
- **Tier 2** — substantial artefact: a feature, or a briefing / published page
  / deck / report / dashboard / announcement. Run product-intent + reference
  (memory prior art) + QA + critic gates; capture to memory.
- **Tier 3** — new product, public release, strategic or positioning work, or a
  hard-to-reverse decision. Run discovery, research, critic, and an explicit
  owner-decision pass first.

## Done contract

Done = intent clear · right gates run · **AI critic gate run before human
review (Tier 2/3) with its blocker/major findings fixed, or, where advisory, an
explicit statement that it was skipped and why** · artefact delivered where it
belongs · **names, claims, and audience verified** (keep a naming glossary in
your auto-memory and check against it) · durable artefacts **captured to
memory** · a final report stating evidence, whether the critic ran, and
remaining gaps honestly.

---

# Persistent Memory (LightRAG — "second brain")

`lightrag-local` is your persistent **second brain**: a local knowledge base
about your work, projects, people, customers/partners/suppliers, decisions,
meetings, strategy, and reusable lessons. It runs locally. Treat it as default
working memory across business *and* technical tasks, not just coding.

## Use it BEFORE non-trivial work, especially when the task involves

- an active or recurring **project**
- preparing for, running, or following up on a **meeting**
- a named **customer, partner, supplier, vendor, or stakeholder**
- **strategic, organisational, or leadership** topics
- **product, marketing, go-to-market, pricing, or positioning** decisions
- **operations, runbooks, processes** that recur
- non-trivial **debugging, architecture, deployment, automation, agent design**
- any moment where *"we have probably been here before"* is plausible

Steps: invoke the `lightrag-local` skill · confirm health · search with 2–3
focused phrasings · treat results as **prior art** that still needs verifying
against the current document, repo, conversation, or system.

## Use it AFTER such work — capture is MANDATORY and AUTOMATIC

If a task fell into any category above **and** produced a durable artefact (a
published page, a decision, a meeting outcome, a project status, a
customer/partner update, a reusable lesson or runbook), **capture it to memory
as the final step, without asking first**. The default is capture, applied
silently. The user should never have to ask "did you save this?".

Templates (Decision · Meeting · Person · Customer/Partner/Supplier · Project
status · Lesson/Runbook) live in the skill.

**Skip capture** when the content fails the quality bar (durable, compact,
reusable), falls under *Do not store*, or already exists with the same source
name and unchanged content. **Ask first** only when durability is *genuinely*
ambiguous (a half-finished draft the user may discard). "I wasn't sure" is not a
reason to ask.

**After writing**, state in one line what was captured (source name + what it
covers). Do not ask permission beforehand.

## When the user asks "did I capture this?" — audit source-first

Do not audit by searching memory and confirming hits; that never surfaces
gaps. Walk the sources of the recent work first (files modified in the last
days in each active project directory; pages recently modified in the
publishing system), list stored documents with `lightrag.sh docs`, and diff.
Presence is searchable; absence requires walking the sources.

## Quality bar

Store only knowledge that is **durable, compact, and reusable**. One screen,
not a log dump. If a future you would not benefit from reading it in six
months, do not store it.

## Do not store

- secrets, credentials, tokens, passwords, OAuth, JWT, API keys
- salary, performance reviews, disciplinary or HR-confidential content
- raw confidential commercial documents not explicitly approved for memory
- third-party personal data without clear business reuse value
- raw email/chat dumps without a written summary
- noisy intermediate status (transient PR state, in-flight todos)

The store is local and not encrypted at rest. Treat it like a personal
notebook on this machine.

## If the memory service is unavailable

Continue the task. State explicitly that memory search and/or capture could
not be performed and why. Do not retry indefinitely.
