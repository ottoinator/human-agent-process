# Contributing

Thank you for helping improve the Human-Agent Process.

## Good contributions

- **Adoption reports.** What you installed, what you changed, what broke. Open
  an issue with the `workflow_improvement` template.
- Clearer process text, better templates, stronger skill contracts, more
  realistic (fictional) examples.
- QA checks that catch structure, link, front-matter, or public-safety issues.

## Before you open a pull request

1. Keep the change scoped. One concept per PR.
2. Rules live in `core/`. Edit there, then run the build so the generated
   distributions follow. Never hand-edit generated files.
3. Skills live in `plugins/human-agent-process/skills/`, stay platform-neutral
   (no tool names) and self-contained. When a concept changes, update every
   place it appears: core, skill, template, doc, example.
4. Run the QA harness:

   ```bash
   scripts/qa.sh
   ```

5. Keep it public-safe: no private examples, paths, logs, screenshots,
   credentials, or organisation-specific assumptions. Placeholders in angle
   brackets are the convention.
6. Fill in the pull request template. It is the done contract for this repo.

## Claim integrity

Do not add claims such as "production-ready", "validated", "secure",
"enterprise-grade", or "industry standard" unless the PR also adds the
evidence that supports them. Use the evidence labels in
[docs/reference/validation-model.md](docs/reference/validation-model.md).

## Changes to the process itself

A new required gate, a changed tier boundary, or a new mandatory step is a
Tier 3 change. Add a decision record in `docs/decisions/` (see
[the template](plugins/human-agent-process/skills/software-dev-process/references/decision-records.md))
so future maintainers know why.
