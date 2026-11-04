# Roles and the cost contract

The lead owns meaning, owner questions, integration, and delivery. Four
bounded roles do the rest, each in a fresh context.

| Role | Access | Job |
| --- | --- | --- |
| critic | read-only | plan critique before build, artefact review after |
| implementer | write scope set by the lead | one scoped build slice |
| qa-runner | read-only except test output | real verification: pass, fail, blocked |
| researcher | read-only, web | problem, alternatives, patterns, references |

Role definitions live in `core/roles/`; the build generates the platform
files from them.

## Cost contract

- One role agent per gate point. Never two agents on the same gate, never a
  general-purpose agent instead of the role.
- At most two subagents at a time. One writer per checkout; parallel writers
  need disjoint write scopes.
- Every role has a turn budget. A partial result with a checkpoint report is a
  normal ending; the lead decides whether to resume. Claude Code enforces the
  budget, Codex treats it as advice ([platforms](../platforms/codex.md)).
- Briefs stay under 500 words: scope, write scope, verification, output
  contract.
- When the work package changes, write a [handoff](../../templates/HANDOFF.md)
  and continue in a fresh session.

Why: roles that overlap burn budget twice and blur who is accountable.

Details: [roles and responsibilities](../../plugins/human-agent-process/skills/software-dev-process/references/roles-and-responsibilities.md).
