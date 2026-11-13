# Decision: the README speaks to people first

Date: 2026-11-13
Status: accepted

## Context

The 2.0.0 README explained the mechanics (tiers, gate line, modules, build
pipeline) but not the outcome: that a person can hand over work in plain
language and get finished, tested results from a team of roles. Readers had
no reason to try it, and no way to compare it with an agent used as it ships.

## Decision

The README leads with the outcome, a real excerpt, what you can hand over, a
comparison with plain Claude Code and Codex, highlights, and both platforms
side by side. Mechanics (tiers, modules) follow. The comparison is backed by
two recorded runs in `docs/start/see-it-work.md`, including the case where the
process makes little difference (a small change), so the page does not
overclaim.

Module pages may name concrete public tools as fitting examples (Google Stitch
for design references, the other supported platform for second opinions)
while the rule text in `core/` stays tool-neutral.

## Consequences

- Public claims stay within the validation labels: `in-use` is labelled as a
  claim, `human-validation-missing` stays visible.
- The recorded runs carry a date. When rules change materially, re-record
  them or mark them as recorded with an older version.
- No rule, skill, or installer change; generated distributions are untouched.
