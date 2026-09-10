# Minimal Adoption

The smallest useful version of the process, for one person and one agent.

## Claude Code

```bash
git clone https://github.com/ottoinator/human-agent-process.git
cd human-agent-process && ./scripts/install.sh
```

That installs the global `CLAUDE.md` (if you have none) and the five skills.
Skip the memory service for now; the reports will say capture was not possible,
which is true.

## Any other agent

Copy `templates/project/AGENTS.md` into your project root and fill the four
placeholders. Nothing else.

## First task

```text
Classify this task, name the owner questions you cannot answer yourself, and
propose the smallest verifiable slice: <your task>.
```

You should get a tier, a short list of questions or an explicit "none", an
acceptance check, and — if the task is Tier 2 — a note on whether the critic
gate is mandatory or advisory here and why.

## What to add later

- The memory service (`memory/README.md`) once you notice yourself
  re-explaining context to the agent.
- A project `CLAUDE.md` (`templates/claude/CLAUDE.project.md`) once the repo
  has conventions worth writing down: a QA command, protected paths, names that
  must be spelled right.
