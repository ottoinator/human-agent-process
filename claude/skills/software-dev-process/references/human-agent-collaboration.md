# Human-Agent Collaboration

The process works best when humans and agents have different jobs.

## Human Job

Humans provide judgment:

- Why the work matters.
- Who it is for.
- What quality means.
- Which risks are acceptable.
- What should not be automated.
- When to release or stop.

## Agent Job

Agents provide execution discipline:

- Read context.
- Break work into a verifiable slice.
- Surface owner decisions.
- Implement.
- Run QA.
- Review for regressions and safety.
- Report evidence and limits.

## Collaboration Pattern

1. Human states the goal and constraints.
2. Agent classifies tier and identifies missing decisions.
3. Human answers only decisions that materially affect direction or risk.
4. Agent implements and verifies.
5. Agent reports evidence, limits, and remaining risks.
6. Human decides whether to release, iterate, or stop.

## Anti-Patterns

- Agent silently decides business or safety tradeoffs.
- Human has to debug unfinished work after the agent claims completion.
- Process becomes so heavy that small tasks stop moving.
- Claims become stronger than evidence.
- Secrets or credentials get committed, or confidential source material
  lands in shared history instead of behind a per-project `.gitignore`.
