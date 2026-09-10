# Human-Agent Process

A working process for humans and AI agents doing real work together, in two
flavours that share one spine:

- **Software development** — features, fixes, prototypes, repos, releases, and
  the agent tooling (skills, hooks, automations) that runs unattended.
- **Knowledge work** — briefings, requirement pages, decks, reports, meeting
  minutes, dashboards, announcements, positioning and go-to-market memos.

The spine is five sentences long:

1. **Intent before output.** Restate the goal, who it is for, what success looks
   like, and what would disappoint even if it "works".
2. **Scale process with risk.** Tiny tasks stay tiny; hard-to-reverse work gets
   real gates.
3. **Humans own judgment, agents own execution.** Ask the owner about goal,
   scope, audience, naming, risk, privacy, cost, release, and anything
   irreversible. Otherwise execute, verify, report.
4. **Claims need evidence.** Never call work done, validated, or production-ready
   beyond what you can show. Say `human-validation-missing` when that is true.
5. **AI critic before human review.** For substantial work an independent
   critic pass runs *before* the owner sees the result. The human is the final
   acceptance critic, not the first one.

This repository is the working Claude Code setup that runs this process —
global instructions, five skills, a memory layer, a hook — published so it can
be installed on another machine in one command, plus the process written out
for humans and for agents that are not Claude Code.

## Who it is for

- People who do most of their work with an AI agent and want it to be
  predictable, verifiable, and honest about what it did.
- Small teams that want a shared way of working without heavyweight project
  management.
- Product, design, and operations people whose output is documents and
  decisions, not code — the knowledge-work half exists for you.
- Agent builders who want reusable tier, gate, role, and review patterns.

## Quick start

### For a human

1. Read [docs/process/principles.md](docs/process/principles.md) (five minutes).
2. Pick the flow you do most: [software](docs/process/lifecycle.md) or
   [knowledge work](docs/knowledge-work/README.md).
3. Learn the four tiers and the done contract. That is the whole model; the
   rest is detail you look up when a task needs it.

### For Claude Code

```bash
git clone https://github.com/ottoinator/human-agent-process.git
cd human-agent-process
./scripts/install.sh
```

That symlinks the skills into `~/.claude/skills/`, copies the Stop hook, and
installs [claude/CLAUDE.md](claude/CLAUDE.md) as your global `CLAUDE.md` if
you have none (otherwise it tells you what to merge). From then on every
session knows the tiers, the gates, and the done contract, and can invoke
`software-dev-process`, `knowledge-work-process`, `critic-reviewer`, and
`qa-engineer` by name.

The process is **memory-agnostic**: it assumes a memory adapter for prior art
before and capture after, but not a particular store. `install.sh` defaults to
the reference adapter (`--memory lightrag`, the `lightrag-local` skill plus a
local service from [memory/README.md](memory/README.md)); `--memory none` or
`--memory <file>` plugs in another. The contract an adapter has to meet is in
[docs/reference/memory-layer.md](docs/reference/memory-layer.md). Full
walkthrough: [docs/setup/claude-code.md](docs/setup/claude-code.md).

### For a project

Copy [templates/claude/CLAUDE.project.md](templates/claude/CLAUDE.project.md)
(Claude Code) or [templates/project/AGENTS.md](templates/project/AGENTS.md)
(any agent) into the project root and fill in the placeholders. For a new
product or a large piece of work, start from
[templates/project/PROJECT_START.md](templates/project/PROJECT_START.md).

### For another agent

[AGENTS.md](AGENTS.md) is the canonical agent instruction file for this
repository and a worked example of the pattern. [docs/setup/other-agents.md](docs/setup/other-agents.md)
explains how to wire the skills into agents that do not read `SKILL.md` files.

## The model in one screen

| Tier | Software | Knowledge work | Process |
| --- | --- | --- | --- |
| **0** | One-off command, tiny edit | Lookup, one-line reply, wording tweak | Just do it |
| **1** | Narrow fix, local change | Short note, single section edit, routine status | Read context, name the acceptance check, verify the one thing that matters |
| **2** | Feature, multi-file change, anything unattended | Briefing, published page, deck, report, minutes, announcement | Intent, reference, structure/architecture, QA, **critic**, security/privacy as relevant |
| **3** | New product, public release, migration, hard-to-reverse | Positioning, launch plan, pricing, leadership proposal | Add discovery, research lanes, and an explicit owner-decision pass *before* building |

**Done** means: intent clear · right gates run · AI critic ran before human
review (Tier 2/3) and its blocker/major findings are fixed · artefact delivered
where it belongs · names, claims, and audience verified · durable outcome
captured to memory · final report states evidence and remaining gaps honestly.
Full text: [docs/process/quality-gates.md](docs/process/quality-gates.md) and
[docs/knowledge-work/README.md](docs/knowledge-work/README.md).

## Repository map

```text
claude/              Mirror of ~/.claude: global CLAUDE.md, skills/, hooks/, settings.example.json
  skills/            software-dev-process · knowledge-work-process · critic-reviewer · qa-engineer · lightrag-local (reference memory adapter)
  memory/            Adapter blocks for the global CLAUDE.md, one per memory implementation
memory/              The reference second brain: LightRAG compose file, .env.example, backup script, launchd template
docs/process/        Normative process: principles, lifecycle, roles, gates, critic gate
docs/knowledge-work/ The same process mapped onto documents and decisions, plus the provenance rules
docs/reference/      Terminology, evidence labels, public safety, the memory layer and its adapter contract
docs/decisions/      Accepted decision records
docs/setup/          Installing this for Claude Code and for other agents
templates/           Copyable files: project CLAUDE.md, AGENTS.md, project, agent, knowledge, GitHub
examples/            Non-normative walkthroughs: minimal adoption, a feature, a briefing
scripts/             install.sh and the QA wrapper
tests/               Static checks: tree, links, secrets and private references, skill front matter
AGENTS.md            Agent instructions for this repo (and a filled-in example of the pattern)
CLAUDE.md            Claude Code adapter for this repo — loads AGENTS.md
```

## What is deliberately not here

- **No runtime.** This is documentation, templates, and skills. The QA harness
  checks the repository, not your product.
- **No organisation-specific detail.** The process was extracted from daily use
  inside a product team; names, systems, page IDs, and channels were replaced
  with placeholders, and the QA harness fails on the ones we know about. The
  private version keeps its specifics; this is the published copy (principle 5).
- **No claim of universality.** It is one team's working model, made copyable.
  See [Validation status](#validation-status).

## Relationship to `human-agent-dev-process`

This repository supersedes
[ottoinator/human-agent-dev-process](https://github.com/ottoinator/human-agent-dev-process),
which covered software only and had no Claude Code layer. The lifecycle,
roles, gates, and templates were carried over and refined through months of
daily use; the knowledge-work flow, the blast-radius rule for the critic gate,
the provenance rules, the memory layer with its client skill and backup, and
the installable Claude Code setup are new.

## Validation status

Evidence labels used in this repository (see
[docs/reference/validation-model.md](docs/reference/validation-model.md)):

- `automated-test` — the static QA in `tests/` runs in CI on every push.
- `ai-review` — an independent AI critic reviewed the repository on
  2026-09-10, before the first publication; its one blocker and six major
  findings were fixed and QA re-run.
- `in-use` — the process is applied daily by its author across software and
  knowledge work; the rules that read like scar tissue are. Unverifiable by a
  reader, so labelled, not proven.
- `human-validation-missing` — no external team has adopted this version yet.
  Feedback is the point of publishing it.

## QA

```bash
./scripts/qa.sh
```

Runs the repository-tree assertion, the internal link and anchor check, the
secret and private-reference scan, the skill front-matter and self-containment
check, and a shell syntax check, with Node and bash only. Markdown lint runs
in CI and locally when `npx` is available.

## Licensing

- Code, scripts, and copyable templates: MIT — see [LICENSE](LICENSE).
- Documentation and process text: CC BY 4.0 — see [LICENSE-DOCS.md](LICENSE-DOCS.md).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). The most useful contributions are
adoption reports: what you copied, what you changed, and what broke.
