---
id: roles-and-cost
title: Roles and the cost contract
kind: core
---
## Roles and the cost contract

The lead owns meaning, owner questions, integration, and delivery. Four bounded roles do the rest, each in a fresh context:

- **critic** (read-only): plan critique before build, artefact review after build.
- **implementer** (write scope given by the lead): one clearly scoped build slice.
- **qa-runner** (read-only except test output): runs the real verification and reports pass, fail, or blocked.
- **researcher** (read-only, web): problem, alternatives, open-source patterns, design references.

Cost contract:

- One role agent per gate point; never two agents on the same gate, never a general-purpose agent instead of the role.
- At most two subagents at a time; parallel writers need disjoint write scopes; one writer per checkout.
- Every role has a turn budget. A partial result with a checkpoint report is a normal ending; the lead decides whether to resume.
- Briefs stay under 500 words and name scope, write scope, verification, and output contract.
- When the work package changes, write a handoff (goal, state, open items, next step) and continue in a fresh session.
