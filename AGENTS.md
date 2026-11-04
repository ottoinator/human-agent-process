# Agent Instructions

For agents working on this repository, not for agents that use the process.
This repo is the source of a process toolkit with two generated distributions.
It is documentation, skills, and installer code, not an application runtime.

## Layout

```text
core/                      the only hand-edited source of rules
  policy/core/             always-on rules (owner boundary, tiers + start gate, roles, critic, QA, memory)
  policy/modules/          optional modules (growth, concurrency, routines, impact-map, second-opinion, design-reference, remote-review)
  platforms/               per-platform notes
  roles/                   critic, implementer, qa-runner, researcher
plugins/human-agent-process/skills/   platform-neutral skills (hand-edited)
scripts/  tests/           installer, build, static QA (generated outputs are written by the build)
docs/  templates/  examples/          human docs, copyable templates, walkthroughs
```

## Rules for changes

- Edit `core/`, then run the build. Never hand-edit generated files (agents,
  generated policy blocks, manifests produced by the build); the next build
  overwrites them and QA flags drift.
- Skills stay platform-neutral: no tool names, "start the critic role in a
  fresh context", reference only core rules, module checks worded "if the
  project activates the X module". Frontmatter has only name, description
  (1024 characters at most), optional license and metadata.
- Each skill directory is self-contained: `SKILL.md` plus `references/`. Docs
  link to the skill references; do not duplicate them.
- When a concept changes, change it everywhere in the same change: core,
  skill, template, doc, example.
- Public repo: no secrets, personal paths, hostnames, project or company
  names, amounts. Examples are fictional. No unsupported claims such as
  "validated" or "production-ready".

## Build and test

```bash
scripts/qa.sh
```

If QA cannot run, report it as blocked and say why. Do not substitute a
description of what QA would have found.

## Tiers for changes here

- Tier 0/1: typo, link, clarified paragraph. Run QA.
- Tier 2: a change to a skill, role, gate, or template others copy. Run an
  independent critic pass before asking the owner to review.
- Tier 3: a new required gate, licence change, public claim, or restructure.
  Write a decision record in `docs/decisions/` first.

## Done contract

Report: what changed and why it fits the layout, tier and whether the critic
ran, the QA command and result, the public-safety check, and remaining gaps.
