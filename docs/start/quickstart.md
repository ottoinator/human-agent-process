# Quickstart

Five minutes. Pick your platform; both share the same rules and roles.

## Claude Code

```text
/plugin marketplace add ottoinator/human-agent-process
/plugin install human-agent-process@human-agent-process
```

The plugin brings the skills and the four roles (critic, implementer,
qa-runner, researcher). Plugins carry no global instructions, so also install
the always-on rules block:

```bash
git clone https://github.com/ottoinator/human-agent-process.git
cd human-agent-process
scripts/install.sh --claude --dry-run   # shows what it would write
scripts/install.sh --claude
```

## Codex

```bash
git clone https://github.com/ottoinator/human-agent-process.git
cd human-agent-process
scripts/install.sh --codex
```

The script writes a managed block into your `AGENTS.md` and the role agents
into your agents directory.

## Both, or more modules

```bash
scripts/install.sh --both --modules all
scripts/install.sh --claude --modules growth,routines
```

Modules are optional rule sets; see the [module pages](../modules/growth.md).
Existing 1.x install: add `--migrate-from-1x`. Remove everything again with
`--uninstall`.

## Check that it works

Ask your agent: "Add a dark-mode toggle to the settings page." The first line
of its answer must be:

```text
hap_gate: tier=2 allow_build=false critic=required
```

(`allow_build` turns true once the start gate record is filled and the plan
critic has answered.) If the line is missing, the always-on rules are not
loaded; see [install for agents](install-for-agents.md).

## Next

- [Tiers and the start gate](../concepts/tiers-and-start-gate.md)
- [Why the rules exist](../why/happy-path-done.md)
