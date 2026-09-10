@AGENTS.md

## Claude Code

- `AGENTS.md` is the canonical instruction file for this repository. This
  adapter makes it load in Claude Code and adds no rules of its own.
- The skills under `claude/skills/` are the ones this repo publishes. To use
  them in *this* checkout, run `./scripts/install.sh` once; Claude Code then
  finds them in `~/.claude/skills/` in every project, including this one.
- Markdown instructions are advisory context. A hard prohibition needs a
  permission rule, a hook, or code, not a stronger adjective.
