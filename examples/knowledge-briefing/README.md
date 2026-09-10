# Walkthrough: a Tier 2 knowledge artefact

Fictional, to show the shape of a run. A product manager at a B2B software
company needs a one-page briefing for the leadership team on whether to build
a "group orders" capability that a customer asked for.

## 1. Intent

Reader: leadership, ten minutes, deciding whether to fund discovery. Decision
to drive: fund / defer / decline. Disappointment risk: a page that is well
written but does not let them decide because the key facts are hedged.

## 2. Tier and gates

Tier 2: a published page the whole leadership team reads. Critic gate
**mandatory**. Reference artefact: the last funded briefing, 640 words.

## 3. Prior art and sources

Memory search returns the customer's earlier requests and a related decision
from last year. The agent treats these as leads and verifies against the
system of record: the product knowledge base for what the platform supports
today, the ticket tracker for the actual customer request, the CRM for which
other customers handle group orders.

## 4. Resolve before drafting

Three load-bearing questions, all settleable with tools already open:

- Does the platform hold a group-size field today? **Knowledge base
  says no.** The briefing must not assume it.
- Did the customer ask for reserved capacity or for shared order views?
  **The ticket says shared order views**; a colleague's summary said reserved
  capacity.
  Contradiction resolved by reading the ticket, not by noting both.
- Which other customers would use this? CRM shows **one** that demonstrably
  handles group orders today; two more are plausible. The briefing says
  "one customer asked, one more demonstrably does this, two plausible", not
  "four customers".

## 5. Produce

620 words, in the leadership team's language, decision options up front.
Exact product names checked against the naming glossary.

## 6. QA and critic

QA: page published, opened, links resolve, numbers trace, names exact, index
updated. Critic (fresh agent, briefed as a sceptical CFO and pointed at the
premises): flags one **blocker** — the cost estimate cites a sales deck's
"two-week integration" claim; the engineering estimate in the tracker says
six. Fixed, re-verified. One minor: cut the paragraph on how the request came
in. Cut. Word count did not grow.

## 7. Deliver, capture, report

Published to the leadership space, index updated. Captured as a decision-
pending entry: the question, the three resolved facts, the options, the
sources. Report states: Tier 2, gates run, critic ran and what it caught, QA
pass, one claim marked `human-validation-missing` (the plausible customers).
