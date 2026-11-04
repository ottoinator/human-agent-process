---
id: platform-claude
title: Claude Code notes
kind: platform
---
## Claude Code notes

- Roles are the plugin subagents `human-agent-process:critic`, `:implementer`, `:qa-runner`, `:researcher`; start them with the Agent tool. Their `maxTurns` is enforced by Claude Code.
- Skills from the plugin load through the Skill tool (`human-agent-process:<skill>`).
- Markdown rules are advisory context. Hard prohibitions belong in `permissions` or hooks in `settings.json`.
