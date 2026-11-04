---
id: platform-codex
title: Codex notes
kind: platform
---
## Codex notes

- Roles are personal custom agents named `critic`, `implementer`, `qa-runner`, and `researcher`, installed in `~/.codex/agents/`. Ask the lead to delegate a bounded task to the named custom agent; in the CLI, `/subagents` inspects or switches among agent threads after they start.
- Plugin skills may trigger automatically. Invoke one explicitly as `$skill-name`, for example `$start-gate`; fallback copies in `~/.agents/skills/` use the same names.
- Codex has no hard per-agent turn limit. Each role's turn budget is advisory, so stop at its checkpoint.
- Custom agents inherit the parent session's sandbox and approval settings. Read-only role text is a behavioral boundary; set enforceable permissions on the parent session, not in the custom-agent TOML.
- Codex plugins do not supply always-on global instructions. The managed `~/.codex/AGENTS.md` block supplies them.
