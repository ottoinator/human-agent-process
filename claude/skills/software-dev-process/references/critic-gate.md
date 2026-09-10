# The Critic Gate

For Tier 2 and Tier 3 work, an independent AI critic reviews the artefact
**before** the human owner sees it. The human is the final acceptance critic,
never the first one. Quality the critic catches is attention the owner never
has to spend. That is what makes the human-agent loop efficient.

## Rules

- **Self-review does not count.** The agent that produced the work cannot run
  the gate on it. Spawn a fresh agent with the `critic-reviewer` skill text as
  its brief, the artefact, and the premises to check. In Claude Code that is
  the Agent tool with `subagent_type: general-purpose`; there is no
  `critic-reviewer` subagent type, and invoking the skill inside the producing
  session is a checklist, not a gate.
- **Mandatory or advisory is decided by the blast radius of the change**, not
  by which repository it sits in. A list of repositories goes stale the day a
  new project starts; a list of properties does not.
- **Advisory governs whether you run the pass, never whether you act on it.**
  A blocker from a pass you did run stops delivery until it is fixed or the
  owner explicitly accepts it.
- **Skipping a mandatory gate is a process failure even if the output happens
  to be fine.** Never let a report imply a gate ran when it did not.

## Mandatory

- **All Tier 2/3 knowledge work** — briefings, requirement pages, decks,
  reports, minutes, dashboards, positioning, anything a customer or the whole
  organisation sees. For content this *is* the quality gate; there is no pull
  request behind it.
- **Code that runs unattended or loads into other sessions**, wherever it
  lives: skills, agents, commands, hooks and their scripts, a job runner that
  invokes an agent on its own. Nobody watches these fail.
- **Anything hard to reverse or serving other people:** auth, money, data
  migration or deletion, multi-tenant or access-control changes, a public
  release, a deployed customer-facing app.
- **Shared tooling repositories** may add "all software work here" as their own
  rule, because a defective skill misfires silently in several people's
  sessions. Write that rule in the repository's own instructions.

## Advisory

Everything else — ordinary Tier 2/3 software work in a repository whose only
consumer is the person writing it. **Default to running it.** Skip only when
you can name why *this change* is below the bar, and **name that reason in the
report.**

## How to brief the critic

A critic asked to "review this as the audience" will check coherence and bless
a tidy document built on unverified foundations. Point it at the **premises**,
not only the prose:

- Does every named party or fact trace to a primary source that is not our own
  earlier artefact?
- Does every specified input, field, or capability actually exist?
- Is this longer than the reference artefact, and what would you cut?
- Was any load-bearing claim left as a caveat that an available tool could
  have settled?
- What claim is stronger than the evidence shown?

Then fix every blocker and major finding, and **re-verify after the fixes**;
the fix round needs its own check.

## Why

The gate is priced to blast radius, not to how much the work matters. A defect
in a personal project is found on the next run by the one person it affects. A
defect in a published briefing or an unattended skill is found by someone else,
later, at a cost you do not control.
