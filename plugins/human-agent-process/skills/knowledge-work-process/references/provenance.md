# Provenance

"Has a citation" is not "verified". These rules exist because artefacts that
cited sources were still wrong, and the cost landed on the reader.

## 1. Authoritative source, not just any source

For a claim about what a product does, what data it holds, or whether a defect
exists, the authority is the **system of record**: source code, the running
system, the product knowledge base, live data, the signed contract.

Marketing briefings, sales-plan feature lists, roadmap decks, and tickets are
**leads**. They are optimistic and they age. A capability rating grounded only
in them is **provisional**: label it as such, and verify it against the
authoritative source before delivery.

If the authoritative source was unavailable while you produced (tool down, no
access), re-verify every provisional line the moment it becomes available.
Do not ship provisional ratings as firm.

*Lesson behind the rule:* in one capability assessment, roughly nine lines
were wrong because plan and marketing material had been treated as capability
evidence. A sweep against the product knowledge base flipped them, mostly
downwards.

## 2. Resolve, don't flag

If a claim is **load-bearing** for the artefact — what the product does today,
what data exists, whether the customer's report matches the documentation — and
a tool in reach can settle it, **settle it before producing**. Not in a caveat
on the page.

A contradiction between a customer's report and the documentation is a
**blocker to drafting**, not a box on the page. Resolving it routinely changes
the size of the work.

Never specify something the system cannot supply — a data field that does not
exist, an integration path that is not supported. That is not a hedge; it is an
unbuildable requirement.

`human-validation-missing` is for what **cannot** be verified now. It is not a
licence to ship what you did not check.

*Lesson behind the rule:* one requirements page needed three separate
interventions for exactly this — an unresolved contradiction, an invented field
list, and unverified customer claims — all settleable with tools that were
already open.

## 3. Named parties trace to a primary source

A page you wrote last week is a prior claim, not evidence. Citing it is
circular sourcing.

For any list of customers, stakeholders, or supporters, sort every name into:

- **asked for it** — a request on record;
- **demonstrably does this today** — verified against their actual business;
- **plausible, unvalidated** — an inference.

Never blur the tiers. Check the party's actual business model before citing
them as support. State the true count plainly: one named customer with evidence
beats an inflated list that collapses under one question.

## 4. Match the reader and the reference's length

When a worked example or template exists, **count its words**; do not only copy
its styling. More context is not safer: a reader who cannot find the decision
is worse served by a longer document.

Write in the readers' language. Do not quote internal messages. Cut the origin
story; how the work came to exist rarely helps the person acting on it.

**On revision the artefact does not grow.** Integrate or drop findings. Never
append them.

## Briefing the critic on provenance

A critic reviewing "as the audience" checks coherence, not foundations. Give it
explicit questions (see the critic gate notes in the skill): does every named party trace
to a primary source that is not ours? does every specified input exist? is this
longer than the reference? was anything left unresolved that a tool could
settle?
