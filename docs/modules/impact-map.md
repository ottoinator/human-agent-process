# Module: impact map

**Default: off.**

Switch it on for a system with many components, displays, and registrations,
where adding one thing can leave other places stale. The repository keeps a
small system map (components, data flows, displays, registrations,
operations). Every Tier 1+ change carries an impact inventory derived from it
plus a search for consumers; each point is `adapt` (with a check),
`untouched` (with a reason), or `follow-up` (with a started session).
Acceptance runs every `adapt` check. When replacing a component, rehearse in
shadow first and keep a bit-identical way back.

**Cost:** maintaining the map and one inventory per change. Worth it once
forgotten places have caused incidents.

Story: [seven forgotten places](../why/forgotten-places.md).
Rule text: `core/policy/modules/impact-map.md`.
