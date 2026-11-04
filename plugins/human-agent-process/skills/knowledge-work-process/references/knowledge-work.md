# Knowledge-Work Process

The same process, mapped onto documents and decisions instead of code:
briefings, requirement pages, decks, reports, meeting minutes, dashboards,
announcements, positioning and go-to-market memos, status updates in chat or a
ticket tracker.

The principles are unchanged (the `software-dev-process` skill holds them). What changes is what
the tiers, gates, and QA look like when the artefact is a page rather than a
pull request.

## Tier guide

- **Tier 0 — Direct.** A question, a lookup, a one-line reply, a wording
  tweak. Just answer. No gates.
- **Tier 1 — Small artefact.** A short internal note, a single-section edit, a
  routine status update, a minor slide change. Read local context, state the
  acceptance check, verify the one thing that matters (names right, link
  works).
- **Tier 2 — Substantial artefact.** A full briefing, a published wiki page, a
  customer- or partner-facing deck, a report with numbers, a minutes
  publication, a dashboard update, a multi-channel announcement. Run product
  intent, the reference gate (memory prior art plus the source), the structure
  gate, the knowledge-work QA gate below, and the critic gate (mandatory).
  Capture to memory.
- **Tier 3 — Strategic or hard to reverse.** New external positioning, a launch
  plan, a pricing or go-to-market decision, a leadership proposal, anything
  that shapes how the organisation is seen or is costly to walk back. Add
  discovery, research lanes, and an explicit owner-decision pass before
  publishing.

## Gates, translated

- **Product intent** → Who reads this, what decision or action should it drive,
  what would make it land flat even if it is well written?
- **Research / reference** → Search memory for prior art first, then verify
  against the actual source (transcript, repository, page, data export).
  Priors are hypotheses, not facts.
- **Architecture** → For knowledge work this is *structure*: the outline, what
  is in and out, naming, where it lives, what it supersedes.
- **QA** → the knowledge-work QA gate below.
- **Critic** → Read it as the actual audience (executive, customer, partner,
  beta user, teammate running the playbook). Useful, credible, correctly
  scoped, free of overclaim? Brief it on the premises
  (see the critic gate notes in the skill).
- **Security / privacy** → No secrets, no unapproved confidential data,
  correct audience framing (beta or early-adopter where the product is not
  generally available), no customer PII in shared or external material.

## Provenance rules

These four rules were each learned the expensive way. Full text with the
reasoning in `provenance.md`.

1. **Cite an authoritative source, not just any source.** Marketing
   briefings, sales-tier feature lists, and decks are leads, not evidence.
   A rating grounded only in them is provisional; label it and verify against
   the system of record before delivery.
2. **Resolve, don't flag.** If a claim is load-bearing and a tool in reach can
   settle it, settle it before producing, not in a caveat inside the artefact.
   Never specify something the system cannot supply.
3. **Trace named parties to a primary source, never to your own earlier
   artefact.** Sort each name into *asked for it* · *demonstrably does this
   today* · *plausible, unvalidated*, and never blur the tiers.
4. **Match the artefact to the reader and to the reference's length.** Count
   the words of the worked example. On revision the artefact does not grow:
   integrate or drop findings, never append them.

## QA gate for knowledge work

There is no test harness for a document. Verification means checking the things
that actually break a knowledge artefact:

- **Renders and publishes correctly** — the page saved and displays, the deck
  opens, links resolve, tables did not mangle. Actually open it; do not infer
  from the source.
- **Names are exact** — product, feature, customer, and person names per the
  team's naming glossary. This is a frequent, high-cost error class; treat the
  name check as a required step.
- **Claims match evidence** — numbers trace to the export, quotes are
  verbatim, "validated" and "production-ready" are not claimed without basis.
- **Audience fit** — framing matches who reads it (beta soft-sell vs internal
  vs launch announcement).
- **Registry or index updated** — whatever list of published pages or
  artefacts the team keeps.

Report QA as **pass / fail / blocked**, never silently optimistic.

## Done contract (knowledge work)

Done is not "I wrote the text". Done means:

- Owner intent clear or assumptions stated.
- Right tier and gates for the risk.
- Every load-bearing claim resolved against the system of record, not flagged
  in the artefact.
- Named parties traced to primary sources, not to our own earlier pages.
- AI critic gate run before human review (Tier 2/3), pointed at premises as
  well as prose, and its blocker/major findings fixed.
- Artefact published or delivered where it belongs.
- Names, claims, and audience verified.
- Captured to memory when it produced a durable artefact — part of *done*, not
  an afterthought (through the memory adapter; where its write policy needs
  authorization, proposed and reported as pending).
- Final report states what changed, the evidence, that the critic gate ran,
  and remaining gaps honestly.

Handing un-critiqued Tier 2/3 work to the human is a process failure even if
the work turns out fine.

## How this composes with domain skills

This process wraps the skills that *do* the work — the one that builds the
report, the one that drafts the requirements page, the one that posts the
update. It decides the tier, routes the gates, and enforces the done contract.
It does not replace them, and a domain skill that already carries its own QA
and capture steps satisfies this process by running them.
