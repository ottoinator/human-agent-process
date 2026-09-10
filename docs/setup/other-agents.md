# Setup: Other Agents

The process is text. Anything that reads Markdown instructions can follow it.

## Agents that read `AGENTS.md`

Copy [`../../templates/project/AGENTS.md`](../../templates/project/AGENTS.md)
into the project root and fill the placeholders. It carries the tiers, the
owner/agent split, the QA command, and the done contract, so a project needs
nothing else to start. This repository's own [`AGENTS.md`](../../AGENTS.md) is
a filled-in example.

## Agents with a skills or tools directory

Each `SKILL.md` under `claude/skills/` is a self-contained contract: purpose,
when to use, steps, output contract. Point your agent at the directory, or
paste the relevant `SKILL.md` into its system prompt. The `references/` folders
hold the longer text a skill points to; include them when context allows.

The `lightrag-local` skill needs `bash`, `curl`, and `python3` for its script.
Everything else is prose.

## Agents with only a system prompt

Use [`../../claude/CLAUDE.md`](../../claude/CLAUDE.md) as the system prompt. It
is the compact form of the whole process: stance, tiers, done contract, memory
rules. Roughly two thousand words.

## Running the critic gate without subagents

The critic gate wants independence: a fresh context that did not produce the
work. If your agent cannot spawn one, run the critic as a second session (or a
second agent) with `claude/skills/critic-reviewer/SKILL.md` as its brief and the
artefact plus its premises as input. A self-review checklist in the same
context is better than nothing but does not satisfy a mandatory gate; say so in
the report.
