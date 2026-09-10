# <Project name> — navigation for humans and agents

> Loads at the start of every Claude Code session in this repo. It says *where
> things are* and *how this repo works*, and links out. The process itself
> (tiers, gates, done contract, memory rules) comes from the global
> `~/.claude/CLAUDE.md`; do not repeat it here.

## What this is

<One paragraph: what the project does, who it is for, current stage
(prototype | internal | production).>

## Where things are

```text
<dir>/     <what lives there>            → <dir>/README.md or CLAUDE.md
<dir>/     <what lives there>
```

## How this repo works

- **QA command:** `<command>` — the thing that exercises a change. If it
  cannot run, report QA as blocked.
- **Branching:** `<commit to main | branch + PR for these paths: ...>`
- **Release:** `<how a change reaches users, if at all>`
- **Critic gate is mandatory here for:** `<paths or properties — e.g. anything
  under .claude/, anything that runs on a schedule, auth, data migration>`.
  Advisory elsewhere; name the reason when skipped.
- **Published artefacts live in:** `<wiki space / folder / tracker>`; keep
  `<index file>` updated when you publish.

## Naming precision

<Exact product, feature, team, and customer names that must be spelled right.
Retired names that must not be used externally.>

## Sensitive material

<Which directories hold confidential source material, and the `.gitignore`
that keeps it out of history. Which audiences may see what.>

## Memory

Per-person memory (the `lightrag-local` skill) is not this repo's source of
truth. <Say what is: e.g. "the committed archive under `archive/`".> Capture
durable, reusable, cross-cutting outcomes; do not duplicate routine artefacts
already recorded here.
