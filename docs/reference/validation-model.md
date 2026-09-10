# Validation Model

Claims carry labels that say what kind of evidence stands behind them.

## Evidence types

`automated-test` — a deterministic or repeatable tool check: tests, lint, link
check, structure assertion, secret scan.

`reference-comparison` — comparison against external docs, standards,
conventions, or the system of record.

`ai-review` — a review by an independent AI critic, persona, or specialist
pass. Useful; not the same as a human.

`synthetic-data` — generated or anonymised examples, fixtures, simulations.

`runtime` — evidence from a running system or a rendered artefact: health
check, logs, screenshot, the published page opened and read.

`in-use` — the thing has been applied in real work over time by its author.
Stronger than `ai-review`, weaker than external adoption.

`human-validation-missing` — a marker that real user, customer, maintainer,
market, or expert validation is absent.

## Claim rules

- Use the weakest honest claim.
- Prefer "checked" over "validated", "in use by its author" over "proven".
- Keep the evidence next to the claim.
- A blocked check is reported as blocked, never as passed.
- A provisional rating stays labelled provisional until verified against the
  authoritative source.
