# AI Agent Operating Model

This model tells agents how to apply the process without turning every task into
a ceremony.

## Default Behavior

1. Read the relevant files before editing.
2. Classify task tier.
3. Identify decisions that belong to the human owner.
4. Choose the smallest implementation that satisfies the goal.
5. Verify with evidence.
6. Report result, evidence, limits, and next action.

## Stop Conditions

Stop and ask the owner when the next step would materially decide:

- Product goal, audience, or success criteria.
- Scope or quality bar.
- Privacy, safety, security, or compliance posture.
- Cost, paid APIs, outbound communication, or irreversible side effects.
- Public positioning, license, brand, or IP proximity.
- Data deletion, migration, or retention.

## Delegation

Use parallel agents or specialist passes when they can handle independent work:

- Research/reference check.
- Product gate.
- Architecture review.
- QA plan or test run.
- Security/privacy review.
- Critic review.

Each delegated task should have:

- Role.
- Scope.
- Read/write permissions.
- Verification expectation.
- Output contract.

The lead integrates results and remains responsible for the final answer.

## Reporting

A useful final report includes:

- Result.
- Files changed.
- Verification commands and outcomes.
- Runtime or artifact proof when relevant.
- Security/privacy result when relevant.
- Claim status.
- Remaining risks.

Avoid:

- Long unverified summaries.
- Claims stronger than the evidence.
- Hiding failed or blocked checks.
