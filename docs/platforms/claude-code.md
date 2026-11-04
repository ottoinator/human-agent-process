# Claude Code

What differs from the shared core.

- **Distribution:** a plugin (`human-agent-process`) with the skills and the
  four role subagents `human-agent-process:critic`, `:implementer`,
  `:qa-runner`, `:researcher`.
- **Always-on rules:** a plugin carries no global instructions, so
  `scripts/install.sh --claude` writes a managed, marker-delimited block into
  your global `CLAUDE.md` and keeps a backup.
- **Turn budget:** each role's `maxTurns` is enforced by Claude Code. A
  partial result with a checkpoint report is the expected ending.
- **Fresh context:** subagents always start from a fresh context, so the
  "critic in a fresh context" rule holds by construction.
- **Skills** load through the plugin as `human-agent-process:<skill>`.
- **Enforcement:** the rules are advisory context. Hard prohibitions belong in
  `permissions` or hooks in `settings.json`; each needs its own owner
  decision before you install it.

Install: `/plugin marketplace add ottoinator/human-agent-process`, then
`/plugin install human-agent-process@human-agent-process`, then the script.
See the [quickstart](../start/quickstart.md).
