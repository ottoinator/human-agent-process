# Contributing

Thank you for helping improve the Human-Agent Process.

## Good contributions

- **Adoption reports.** What you copied, what you changed, what broke. Open an
  issue with the `workflow_improvement` template.
- Clearer process text, better templates, stronger skill contracts, more
  realistic (fictional) examples.
- QA checks that catch structure, link, front-matter, or public-safety issues.

## Before you open a pull request

1. Keep the change scoped. One concept per PR.
2. When a concept changes, update every place it appears: doc, skill,
   template, example. The `SKILL.md` files must remain self-contained.
3. Run the QA harness:

   ```bash
   ./scripts/qa.sh
   ```

4. Keep it public-safe: no private examples, paths, logs, screenshots,
   credentials, or organisation-specific assumptions. Placeholders in angle
   brackets are the convention.
5. Fill in the pull request template. It is the done contract for this repo.

## Claim integrity

Do not add claims such as "production-ready", "validated", "secure",
"enterprise-grade", or "industry standard" unless the PR also adds the evidence
that supports them. Use the evidence labels in
[docs/reference/validation-model.md](docs/reference/validation-model.md).

## Changes to the process itself

A new required gate, a changed tier boundary, or a new mandatory step is a
Tier 3 change to this repository. Add a decision record (see
[docs/process/decision-records.md](docs/process/decision-records.md)) to the
PR so future maintainers know why.
