---
name: software-dev-process
description: Use when building software with a human owner and AI agent collaborators — features, increments, bug fixes, prototypes, repos, releases, and agent tooling (skills, subagents, commands, hooks, their scripts). Classify tier, run risk-scaled quality gates, route specialist roles, and deliver against an evidence-based done contract. The subject is the code, not the artefact the code produces — for briefings, requirement pages, decks, reports, minutes and dashboards, use knowledge-work-process.
---

# Software Development Process

A lightweight, evidence-driven process for humans and AI agents building
software together. It decides how much ceremony a piece of work needs, routes
the right review passes, and holds the work to a done contract where **claims
must match evidence**.

## When to use

**The discriminator: the thing you are building is the code, not the artefact
the code produces.** Writing the generator is this skill. Running it to produce
a report or a page is knowledge work.

- A **feature or increment** in a product, service, or app.
- A **bug fix with real risk** — shared state, unattended execution, a blast
  radius wider than the diff.
- A **refactor, migration, or dependency change** with behaviour at stake.
- A **new prototype, repo, or product**.
- **Packaging or cutting a release.**
- A **skill, subagent, slash command, hook, or the script behind one** —
  anything that loads into other sessions or runs unattended.
- Any multi-file change where "it looked right" is not evidence.

## When NOT to use

- **Product and business artefacts** — briefings, requirements, published
  pages, decks, reports, minutes, dashboards, roadmap and go-to-market work.
  Those are `knowledge-work-process`.
- **Operating a tool, as opposed to changing it.** "The job didn't post" is an
  operational question; follow that tool's runbook. It becomes this skill's
  work once you decide to change its code.
- **Tier 0 work.** No gates on a typo.

## Steps

1. **Restate intent** — goal, why, who it is for, success signal, quality bar,
   constraints, and what would disappoint even if it runs.
2. **Determine the host repo's conventions** — branching, review, release, CI
   or none — and follow them. Do not import ceremony a repo does not have; a
   repo that commits straight to `main` is following its convention, not
   showing you a gap.
3. **Classify Tier 0–3** ([`references/lifecycle.md`](references/lifecycle.md)).
4. **Run only the gates the tier and risk require**
   ([`references/quality-gates.md`](references/quality-gates.md)).
5. **Surface owner decisions** — ask before deciding goal, scope, audience,
   risk, privacy, cost, naming, or release (Stop Conditions in
   [`references/ai-agent-operating-model.md`](references/ai-agent-operating-model.md)).
6. **Search memory for prior art** (`lightrag-local`), then verify against the
   source.
7. **Implement the smallest coherent slice.**
8. **Verify with evidence that matches the claim** — actually run it; do not
   infer.
9. **Critic gate (Tier 2/3, before the human sees it)** — `critic-reviewer` or
   a fresh general-purpose subagent with a critic scope; fix blocker/major
   findings, then re-verify. Mandatory or advisory per blast radius
   ([`references/critic-gate.md`](references/critic-gate.md)); report it either
   way.
10. **Conform and land** — the host repo's contribution and release convention.
11. **Capture** the durable decision, runbook, or architecture choice to memory.
12. **Report against the output contract.**

### Tiers (summary; detail in [`references/lifecycle.md`](references/lifecycle.md))

- **Tier 0 — Mini.** Direct answer, one-off command, tiny edit. Just do it.
- **Tier 1 — Small change.** Narrow fix, local edit. Read context, define the
  acceptance check, run the smallest relevant verification.
- **Tier 2 — Substantial.** A feature, a multi-file change, user-facing or
  runtime behaviour, a data flow — or anything that runs unattended for others.
  A new or materially changed skill is Tier 2 even as a single stateless file:
  it runs in other people's sessions, which is what the tier measures. Gates:
  product intent, reference, architecture, QA, critic, plus security/privacy
  where data, auth, logs, or outbound side effects exist.
- **Tier 3 — New product / hard to reverse.** A new repo or product, a public
  release, a major rewrite, a large architecture decision, something packaged
  for install. Add discovery, research lanes, post-build review, and an
  explicit owner-decision pass *before* building.

### Roles (thinking modes; use only those that reduce risk)

Business Owner (human) · Lead Engineer Agent (you) · Product Analyst · Software
Architect · QA Engineer · Critic Reviewer · Security/Privacy Reviewer ·
Subject-Matter Expert · Runtime/DevOps Operator. Output contracts in
[`references/roles-and-responsibilities.md`](references/roles-and-responsibilities.md);
the human/agent split and its anti-patterns in
[`references/human-agent-collaboration.md`](references/human-agent-collaboration.md).
Delegate independent passes to subagents with a clear scope and output contract.

### Operating rules

The six principles are in [`references/principles.md`](references/principles.md).
In practice:

- Classify tier **before** implementing.
- Keep owner decisions separate from agent execution.
- Scale gates with risk — no ceremony on small tasks, no recklessness on large.
- **Claims need evidence.** Never call work robust, secure, production-ready,
  or validated beyond the evidence; mark `human-validation-missing` when that
  is the truth. **Provenance matters:** verify against the authoritative source
  — source code, the running system, the product knowledge base. Docs,
  tickets, and marketing are leads, not proof.
- **AI critic before human review.** The human is the *final acceptance*
  critic; self-review by the producing agent is not a substitute.
  **Mandatory** where nobody would watch the failure or it is hard to undo:
  code that runs unattended or loads into other sessions (skills, agents,
  hooks, their scripts, a job runner that invokes an agent), auth, money, data
  migration or deletion, access-control and multi-tenant changes, a public
  release, a deployed customer-facing app. **Advisory otherwise** — default to
  running it; skip only when you can name why *this change* is below the bar,
  and name that reason in the report. **Advisory governs whether you run the
  pass, never whether you act on it.**
- **QA is project-defined.** Use whatever actually exercises the change: the
  test suite, a selftest oracle, a `--dry-run`, lint/typecheck, a real run
  against a scratch target, a screenshot. Pick the cheapest check that produces
  real evidence, and never report QA as passed without running something.
- **Secrets out, specifics in.** Never commit credentials. Do not water down
  a private skill by abstracting its operational detail; keep confidential
  source material out of history with a `.gitignore`, not by vagueness. Only a
  genuinely published copy gets abstracted.
- **Done means integrated and verified**, not "the code changed".

## Output / templates

Every run of this skill reports:

> **Context** (host repo and its conventions) · **tier** + rationale · **owner
> questions** (or why none) · **gates used** (for Tier 2/3, state explicitly
> whether the AI critic gate ran, and where advisory and skipped, why) ·
> **result** · **files changed** · **verification commands + outcomes** ·
> **runtime/artefact proof** where claimed · **security/privacy result** where
> relevant · **conformance** (the host repo's contribution convention met) ·
> **claim status** (with `human-validation-missing` where honest) · **remaining
> risks** · **what was captured to memory**.

Document templates (task brief, review report, RCA, handoff, project start,
acceptance criteria, architecture decision, QA plan, release checklist, PR and
issue templates) live in the repository this skill ships from, under
`templates/` (`realpath ~/.claude/skills/software-dev-process/../../..` when
installed by symlink; otherwise github.com/ottoinator/human-agent-process). They assume things a given repo may not have (CI, `AGENTS.md`,
public releases): where a checkbox cannot be honestly ticked, delete it rather
than paste it unticked into a PR.

For a change to the process model itself — a new required gate, a new
mandatory step — use the host repo's ADR or design-doc convention;
[`references/decision-records.md`](references/decision-records.md) holds a
template if it has none.

## Notes & gotchas

- **Composes with, does not replace, the specialists.** `qa-engineer` owns the
  QA gate when tests and repro evidence matter; `critic-reviewer` owns the
  critic gate; `lightrag-local` supplies prior art before and captures the
  durable decision or runbook after. This skill decides tier, routes gates,
  and enforces the done contract.
- **If a specialist skill is not installed**, run the gate as a
  fresh-perspective pass — a general-purpose subagent with an explicit critic
  or QA scope and an output contract — and say in the report that that is what
  you did. Do not silently skip it.
- **`critic-reviewer` is a skill, not a subagent type.** Invoking it inside the
  producing session is self-review with a checklist. For an independent pass,
  spawn a general-purpose agent and hand it the critic scope and the premises
  to check.
- **Why the gate is mandatory in some places and advisory in others.** Blast
  radius. A defective skill runs unattended in several people's sessions and
  nobody watches it fail; a defect in a project whose only consumer is its
  author is found on the next run. The mandatory list is written as
  properties of the change, not as a list of repos, so it does not go stale.
- **Pure-capability skill** — no config, no state, nothing to set up.
- **Provenance.** Descended from `human-agent-dev-process`
  (github.com/ottoinator/human-agent-dev-process), refined through daily use,
  and published as part of `human-agent-process`.
