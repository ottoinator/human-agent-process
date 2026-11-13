# Decision: all modules are on by default

Date: 2026-11-13
Status: accepted

## Context

In 2.0.0 four modules were off by default: impact-map, second-opinion,
design-reference, and remote-review. They were off because they cost context
and some need something from the environment (another model family, a route
the owner's device can reach, a design tool). The effect was that a default
install left out several of the parts that make the process worth using, and
most people never switch on what they do not know about.

## Decision

Every module is on by default. Each module rule gates itself, so a rule that
does not apply costs only its text in the block:

- impact-map: a system map once a repository has more than a handful of
  components; the inventory on every Tier 1+ change stays, built from a
  consumer search when no map exists.
- second-opinion: the two existing triggers stay (money or statistics risk, a
  contradiction that survives one local check). It consults only through a
  call and quota the owner has set up, never a model that merely happens to be
  reachable; without one the report records `second_opinion: unavailable`.
  The brief carries no secrets, credentials, or private data. Sending data to
  another vendor stays an owner choice, made by setting up that call.
- design-reference: only user-facing Tier 2/3 work.
- remote-review: the link must open on the device the owner reviews on; the
  agent asks once at intake if it does not know that device; exposing
  anything publicly stays an owner decision.

Opting out uses a minus prefix: `--modules -remote-review,-impact-map` means
all default modules except those. `--modules a,b` still selects an exact set,
`none` still selects none. Mixing both forms is an error.

## Consequences

- The all-modules block is about 10.8 KB (Claude) and 11.3 KB (Codex), under
  the 12 KB limit the build enforces. New modules now compete for the last
  0.7 KB and must stay short or replace text.
- Existing installs keep the modules recorded in their block until the owner
  reruns the installer; rerunning without `--modules` now installs all.
- The runs in `docs/start/see-it-work.md` were recorded with the 2.0.0
  defaults (four modules off); they show no module behaviour.
