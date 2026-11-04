# Templates — read this before copying one

| Folder | Contents | Repo assumptions |
| --- | --- | --- |
| *(top level)* | `PROJECT_START.md` (the start-gate record) and `HANDOFF.md` (package change). | None. Both are safe as-is. |
| `project/` | `AGENTS.md`, `ACCEPTANCE_CRITERIA`, `ARCHITECTURE_DECISION`, `QA_PLAN`, `RELEASE_CHECKLIST` | Written for multi-repo, CI-backed projects. Check each assumption against the repo you are in — see below. |
| `agent/` | `TASK_BRIEF`, `REVIEW_REPORT`, `RCA_REPORT` | None. Agent-to-agent handoffs, safe as-is. |
| `knowledge/` | `ARTEFACT_BRIEF`, `KNOWLEDGE_QA`, `CAPTURE_NOTE` | None. The knowledge-work equivalents of the project templates. |
| `github/` | PR and issue templates | A `.github/` directory. Without one, they still work as a checklist pasted into a description. |

**Scope the caveats by what the repo has, not by which repo it is.**

| Template assumes | If the repo has it | If it doesn't |
| --- | --- | --- |
| **CI runs the checks** — `RELEASE_CHECKLIST` has "CI passes or blockers are documented" | Use it as written. | Delete the line. "CI passes" is not evidence when there is no CI — name the command you ran and its outcome. |
| **A test harness** | Use it. | QA is whatever exercises the change: the test suite, a selftest, a dry run, lint, a real run on a scratch target, a screenshot. |
| **Public releases** — `PROJECT_START` has a Visibility field | Fill it in. | Skip it. A private repo has no visibility decision to make. |
| **An `AGENTS.md` at the project root** | Copy `project/AGENTS.md`. | If the repo uses a `CLAUDE.md` that imports `@AGENTS.md`, keep it that way; do not add a second, diverging instruction file. |

Never paste an unrunnable checkbox into a PR description and leave it for your
reviewer.
