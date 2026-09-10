# Templates — read this before copying one

| Folder | Contents | Repo assumptions |
| --- | --- | --- |
| `claude/` | `CLAUDE.project.md` — a project-level Claude Code file that links out and states the local conventions. | None. The global `claude/CLAUDE.md` carries the process; this one carries the project. |
| `project/` | `AGENTS.md`, `PROJECT_START`, `ACCEPTANCE_CRITERIA`, `ARCHITECTURE_DECISION`, `QA_PLAN`, `RELEASE_CHECKLIST` | Written for multi-repo, CI-backed projects. Check each assumption against the repo you are in — see below. |
| `agent/` | `TASK_BRIEF`, `REVIEW_REPORT`, `RCA_REPORT`, `HANDOFF` | None. Agent-to-agent handoffs, safe as-is. |
| `knowledge/` | `ARTEFACT_BRIEF`, `KNOWLEDGE_QA`, `CAPTURE_NOTE` | None. The knowledge-work equivalents of the project templates. |
| `github/` | PR and issue templates | A `.github/` directory. Without one, they still work as a checklist pasted into a description. |

**Scope the caveats by what the repo has, not by which repo it is.**

| Template assumes | If the repo has it | If it doesn't |
| --- | --- | --- |
| **CI runs the checks** — `RELEASE_CHECKLIST` has "CI passes or blockers are documented" | Use it as written. | Delete the line. "CI passes" is not evidence when there is no CI — name the command you ran and its outcome. |
| **A test harness** | Use it. | QA is whatever exercises the change: the test suite, a selftest, a dry run, lint, a real run on a scratch target, a screenshot. |
| **Public releases** — `PROJECT_START` has a Visibility field | Fill it in. | Skip it. A private repo has no visibility decision to make. |
| **An `AGENTS.md` at the project root** | Copy `project/AGENTS.md`. | If the repo uses `CLAUDE.md` navigation files, extend that file instead of adding a second, inert instruction file. |

Never paste an unrunnable checkbox into a PR description and leave it for your
reviewer.
