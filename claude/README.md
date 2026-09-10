# `claude/` — the Claude Code layer

This directory mirrors `~/.claude`. Install it with `../scripts/install.sh`, or
by hand:

| File | Goes to | What it does |
| --- | --- | --- |
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | Global instructions: the process stance, tiers, done contract, and the memory rules. Loads in every session. |
| `skills/*` | `~/.claude/skills/<name>` (symlink) | The five skills Claude Code can invoke by name. |
| `hooks/memory-capture-reminder.sh` | `~/.claude/hooks/` | A Stop hook that reminds once per session to capture durable outcomes. |
| `settings.example.json` | merge into `~/.claude/settings.json` | Registers the hook. The path assumes the default `~/.claude`; adjust it if you installed with `CLAUDE_HOME` set. |

If you already have a `~/.claude/CLAUDE.md`, append this one or keep the two
sections you want; nothing here depends on being the only content.

## Skills

| Skill | Use when |
| --- | --- |
| `software-dev-process` | Building software or agent tooling with a human owner. Tiers, gates, roles, done contract. |
| `knowledge-work-process` | Producing documents and decisions: briefings, pages, decks, reports, minutes, updates. |
| `critic-reviewer` | An independent quality, credibility, adoption, or risk review of a plan or artefact. |
| `qa-engineer` | Reproducible verification evidence before delivery, for code or documents. |
| `lightrag-local` | The memory layer: prior art before work, capture after. Talks to a local LightRAG service (`../memory/`). |

Each `SKILL.md` is self-contained. The `references/` folders hold the longer
text a skill points to; the normative human-readable version is in `../docs/`.
