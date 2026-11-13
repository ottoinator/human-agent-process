# Module: second opinion

**Default: on.** Switch it off with `--modules -second-opinion`.

It uses only a call and quota the owner has set up; without one it records
`second_opinion: unavailable` and continues. The brief carries no secrets,
credentials, or private data. Consult only (a) before shipping such a change, or
(b) when a decision-relevant contradiction survives one targeted local check.
Send a brief (state, evidence, your thesis, the question, the critic findings
marked "known, do not repeat"), never an open repository. At most one
consultation per work package, inside a fixed quota. The lead decides on every
point and records acceptance or rejection.

**Pairings.** The natural pair is the other platform this repository
supports: a Claude Code lead asks Codex, a Codex lead asks Claude. Both run
from the command line, so a short wrapper that sends the brief and enforces
the quota is enough. Any other model family works too.

**Cost:** one external call per package and the quota it burns. It is not a
second review gate: general review stays with the critic.

Rule text: `core/policy/modules/second-opinion.md`.
