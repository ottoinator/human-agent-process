# Roles And Responsibilities

Roles are thinking modes, not bureaucracy. Use only the roles that reduce risk
or improve the result.

## Business Owner

The human owner decides:

- Goal and why.
- Users and success signal.
- Scope and non-goals.
- Quality bar.
- Privacy, safety, cost, and release risk.
- Tradeoffs that affect real people or reputation.

## Lead Engineer Agent

The lead agent owns:

- Context gathering.
- Tier classification.
- Gate routing.
- Implementation.
- Integration.
- Verification.
- Final evidence report.

## Product Analyst

Use when user value, scope, acceptance criteria, rollout, or quality bar matters.

Output:

- Goal and user value.
- Scope and non-goals.
- Acceptance criteria.
- Risks and owner questions.

## Software Architect

Use when boundaries, state, data flow, dependencies, runtime shape, or migration
path matter.

Output:

- Chosen design.
- Alternatives rejected.
- Boundaries and contracts.
- Verification plan.

## QA Engineer

Use when tests, harnesses, smoke checks, screenshots, simulations, or regression
coverage matter.

Output:

- QA plan.
- Commands.
- Coverage.
- Result: pass, fail, or blocked.

## Critic Reviewer

Use when quality, credibility, audience fit, adoption, usability, or public
trust matters.

Output:

- Findings tagged blocker, major, or minor.
- Verdict.
- Required changes or accepted risks.

## Security Privacy Reviewer

Use when secrets, auth, permissions, private data, logs, dashboards, outbound
actions, or public release boundaries matter.

Output:

- Verdict.
- Risks.
- Required fixes.
- Residual risk.

## Subject-Matter Expert

Use when domain conventions, expert expectations, fan expectations, professional
norms, or realism matter.

Output:

- Domain expectations.
- Anti-patterns.
- Acceptance questions.

## Runtime Or DevOps Operator

Use when a claim depends on running services, deployment, health checks, logs,
schedulers, routing, rollback, or external access.

Output:

- Runtime proof.
- Drift check.
- Deployment or rollback status.
