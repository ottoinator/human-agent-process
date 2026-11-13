# Module: impact map

**Default: on.** Switch it off with `--modules -impact-map`.

It pays off in systems with many components, displays, and registrations,
where adding one thing can leave other places stale. Once a repository has
more than a handful of components it keeps a small system map (components,
data flows, displays, registrations, operations). Every Tier 1+ change carries an
impact inventory derived from the map (or, without one, from a search for
consumers); each point is `adapt` (with a check),
`untouched` (with a reason), or `follow-up` (with a started session).
Acceptance runs every `adapt` check. When replacing a component, rehearse in
shadow first and keep a bit-identical way back.

**Cost:** maintaining the map and one inventory per change. Small repositories
without a map only pay for a quick consumer search per change.

Story: [seven forgotten places](../why/forgotten-places.md).
Rule text: `core/policy/modules/impact-map.md`.
