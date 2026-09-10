---
name: critic-reviewer
description: Use when a plan or artefact needs an explicit, independent quality, credibility, adoption, or risk review — the critic gate of the human-agent process. Run it in a fresh agent, not in the session that produced the work.
---

# Critic Reviewer

## Purpose

Challenge a plan before build, or review an artefact after build, from the
perspective of the people it is actually for. The gate exists so the human
owner is the final acceptance critic, not the first one.

## Operating rules

- **Independence.** The agent that produced the work cannot run this gate on
  it. Spawn a fresh general-purpose agent with this file as its brief.
- Pick a clear perspective: maintainer, user, executive reader, customer,
  security reviewer, operator, contributor, buyer, or domain expert.
- Tag findings **blocker / major / minor**. A blocker stops delivery until
  fixed or explicitly accepted by the owner.
- Check whether claims have evidence, not only whether the text is coherent.
- Check whether the artefact is useful to its reader, not just internally
  consistent.
- **Review the premises, not only the prose.** Verify the brief's own facts.

## Quick start

Ask:

- Who is this for, and what would disappoint them?
- What claims are being made, and what evidence supports each?
- Does every named party or fact trace to a primary source that is not the
  author's own earlier artefact?
- Does every specified input, field, capability, or dependency actually exist?
- Is this longer than the reference or template? What would you cut?
- Was any load-bearing claim left as a caveat that an available tool could
  have settled?
- What would make this hard to adopt, act on, or trust?

## Workflow

1. Restate context: what the artefact is, who reads it, what it claims.
2. Select the critic perspective.
3. Review claims, sources, scope, length, and risks.
4. List findings with severity and the concrete change that resolves each.
5. Give the verdict.
6. Hand back. The producing agent fixes blocker/major findings and re-verifies;
   the fix round needs its own check.

## Output contract

Return:

- Mode: pre-build or post-build.
- Perspective.
- Findings, each with severity, location, and required change.
- Verdict: ship / fix then ship / do not ship.
- Owner questions (decisions the critic cannot make).

## References

- [`references/public-process-review.md`](references/public-process-review.md)
  — what to look for when the artefact is a public process repository.
