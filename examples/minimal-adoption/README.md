# Minimal Adoption

The smallest useful version of the process, for one person and one agent.

## Claude Code

```text
/plugin marketplace add ottoinator/human-agent-process
/plugin install human-agent-process@human-agent-process
```

Then, in a terminal, install the always-on rules and roles:

```bash
git clone https://github.com/ottoinator/human-agent-process.git
cd human-agent-process && scripts/install.sh --claude --dry-run
scripts/install.sh --claude
```

Skip the memory adapter for now; reports will say capture was not possible,
which is true.

## Codex

```bash
codex plugin marketplace add ottoinator/human-agent-process
git clone https://github.com/ottoinator/human-agent-process.git
cd human-agent-process && scripts/install.sh --codex
```

## Any other agent

Copy `templates/project/AGENTS.md` into your project root and fill the four
placeholders. Nothing else.

## First task

```text
Classify this task, name the owner questions you cannot answer yourself, and
propose the smallest verifiable slice: <your task>.
```

You should get the line `hap_gate: tier=... allow_build=... critic=...`, a
short list of questions or an explicit "none", an acceptance check, and, if
the task is Tier 2, a note on whether the critic gate is mandatory or advisory
and why.

## What to add later

- A memory adapter ([example](../memory-adapter-lightrag/README.md)) once you
  notice yourself re-explaining context to the agent.
- Modules (`scripts/install.sh --modules all`) as the matching risks appear;
  see [the module pages](../../docs/modules/growth.md).
- A project `AGENTS.md` (`templates/project/AGENTS.md`) once the repo has
  conventions worth writing down: a QA command, protected paths, names that
  must be spelled right.
