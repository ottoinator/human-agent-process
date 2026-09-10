---
name: knowledge-work-process
description: Use when planning, producing, reviewing, or delivering non-trivial knowledge work with a human owner and AI agent — briefings, requirement pages, published wiki pages, decks, reports, meeting minutes, dashboards, chat or ticket updates, positioning and go-to-market memos. Classify tier, run risk-scaled gates, verify names/claims/audience, deliver against an evidence-based done contract, and capture durable artefacts to memory. For building software (features, fixes, prototypes, repos, releases), use software-dev-process instead.
---

# Knowledge-Work Process

The human-agent process, adapted for documents and decisions. Same spine as
`software-dev-process` — intent before output, scale process with risk, humans
own judgment / agents own execution, claims need evidence, done means
integrated and verified — with the tiers, gates, and QA mapped onto knowledge
artefacts instead of code.

Use it for: briefings, published pages, customer- or partner-facing decks,
reports with numbers, minutes publications, dashboards, multi-channel
announcements, status updates in chat or a tracker, positioning and
go-to-market work.

## Operating rules

- Classify task tier before producing.
- Keep human-owner decisions separate from agent execution. Ask before
  deciding goal, scope, audience, naming, risk, privacy, cost, release, or
  anything irreversible or reputation-bearing.
- Scale gates with risk — a one-line reply is not a launch memo.
- Claims need evidence — numbers trace to the source, quotes are verbatim, no
  "production-ready / validated" without basis. Use `human-validation-missing`
  honestly.
- **Provenance: cite an AUTHORITATIVE source, not just any source.** "Has a
  citation" is not "verified". For capability or fact claims, the authority is
  the system of record (product knowledge base, specs, source code, live
  data). **Marketing briefings, sales-tier feature lists, and decks are LEADS,
  not evidence.** A rating grounded only in them is **provisional**: label it
  and verify before delivery. If the authoritative source was unavailable
  while you produced, re-verify every provisional line the moment it is back.
- **RESOLVE, don't flag.** If a claim is load-bearing — what a product does
  today, what data it holds, whether a defect exists — and a tool in reach can
  settle it, **settle it before producing**, not in a caveat inside the
  artefact. A contradiction between a customer's report and the documentation
  is a **blocker to drafting**, not a box on the page. Never specify something
  the system cannot supply; that is not a hedge, it is an unbuildable
  requirement. `human-validation-missing` is for what **cannot** be verified
  now, not a licence to ship what you did not check.
- **Trace named parties to a PRIMARY source, never to your own earlier
  artefact.** A page you wrote last week is a prior claim, not evidence. Sort
  each name into **asked for it** · **demonstrably does this today** ·
  **plausible, unvalidated**, and never blur the tiers. One named customer
  with evidence beats an inflated list.
- **Match the artefact to the reader, and to the reference's LENGTH.** When a
  worked example exists, count its words. More context is not safer. Write in
  the readers' language, do not quote internal messages, cut the origin story.
  **On revision the artefact does not grow**: integrate or drop findings,
  never append them.
- **Always run the AI critic before handing anything to the human.** For Tier
  2/3 this is MANDATORY and runs *before* the owner sees the artefact. Self-
  review by the producing agent is not a substitute: spawn a fresh
  general-purpose agent with the `critic-reviewer` scope, point it at the
  premises, and act on its findings before delivery.
- Done is not "I wrote the text" — see the done contract.

## Quick start

1. Restate goal, why, who reads it, success signal, quality bar, constraints.
2. Classify Tier 0–3 ([`references/knowledge-work.md`](references/knowledge-work.md)).
3. Run only the gates the tier and risk require.
4. Surface owner decisions; ask before deciding what is not yours.
5. Search memory for prior art (`lightrag-local`), then verify against source.
6. **Resolve the load-bearing claims before producing** — what the product
   does, what data exists, whether each named party checks out.
7. Produce the smallest coherent artefact — to the reference's length.
8. Verify (knowledge-work QA gate: renders, names exact, claims trace,
   audience fit, index updated). For anything rendered, actually open it.
9. **Run the AI critic gate** from the real audience's perspective, **pointed
   at the premises** (sources, existence of specified inputs, length). Fix
   every blocker/major, then re-verify.
10. Deliver where it belongs, then capture to memory. On revision, integrate
    or drop findings — the artefact does not grow.
11. Report what changed, evidence, remaining gaps — and state the critic ran.

## Tiers (full guide in [`references/knowledge-work.md`](references/knowledge-work.md))

- **Tier 0 — Direct.** A lookup, a one-line reply, a wording tweak. Just do it.
- **Tier 1 — Small artefact.** A short note, a single-section edit, a routine
  status update. Read context, state the acceptance check, verify the one
  thing that matters (names right, link works).
- **Tier 2 — Substantial artefact.** A full briefing, a published page, a
  customer/partner deck, a report, a dashboard update, a minutes publication,
  a multi-channel announcement. Product intent + reference (memory prior art +
  source) + structure + knowledge-work QA + critic (mandatory). Capture.
- **Tier 3 — Strategic / hard to reverse.** New external positioning, launch
  plan, pricing or go-to-market decision, leadership proposal. Discovery,
  research lanes, critic, and an explicit owner-decision pass before
  publishing.

## Gates and QA (translated)

Product intent · research/reference (memory prior art is mandatory, then
verify against source) · structure (outline, in/out, naming, where it lives,
what it supersedes) · knowledge-work QA (incl. **provenance check: is each
claim backed by an authoritative source, or only by marketing/sales
material?**) · **critic (MANDATORY for Tier 2/3, before the human review) —
read it as the actual audience, tag blocker/major/minor, audit provenance,
fix before delivery** · security/privacy (no secrets, no unapproved
confidential data, correct beta/early-adopter framing, no customer PII in
shared material). Full text in
[`references/knowledge-work.md`](references/knowledge-work.md).

**Point the critic at the premises, not only the prose.** A critic asked to
review "as the audience" will bless a tidy document built on unverified
foundations. Give it explicit questions: does every named party trace to a
primary source that is not ours? does every specified input exist? is this
longer than the reference, and what would you cut? was any claim left
unresolved that an available tool could settle?

## Composes with other skills

- `lightrag-local` — the BEFORE (prior art) and AFTER (capture) of every Tier
  2/3 task; the done contract depends on it.
- Domain skills that *do* the work (a report builder, a requirements drafter,
  a publishing skill). This process wraps them: it decides tier, routes gates,
  and enforces the done contract.
- `critic-reviewer` — the critic gate for credibility, adoption, audience fit.
- `qa-engineer` — when the verification needs a reproducible checklist.

## Done contract (knowledge work)

Done = owner intent clear or assumptions stated · right tier and gates for the
risk · **every load-bearing claim resolved against the system of record, not
flagged in the artefact** · **named parties traced to primary sources** · **AI
critic gate run before human review (Tier 2/3), pointed at premises as well as
prose, blocker/major findings fixed** · artefact published/delivered where it
belongs · **names, claims, and audience verified** (names per your naming
glossary — a frequent, high-cost error class) · **captured to memory** when it
produced a durable artefact · final report states what changed, the evidence,
that the critic ran, and remaining gaps honestly. Report QA as pass / fail /
blocked, never silently optimistic. Handing un-critiqued Tier 2/3 work to the
human is a process failure even if the work turns out fine.

## Notes & gotchas

- The four provenance rules were each learned on a real artefact that cited
  sources and was still wrong. The reasoning is in
  [`references/provenance.md`](references/provenance.md).
- Pure-capability skill — no config, no state.
