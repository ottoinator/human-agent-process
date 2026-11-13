---
id: impact-map
title: Impact map
kind: module
default: on
---
## Module: impact map

Once a repository has more than a handful of components, it keeps a small system map (components, data flows, displays, registrations, operations). Every Tier 2+ change, and every Tier 1 change that touches a shared interface, carries an impact inventory derived from the map (or, without one, from a search for consumers): each point is `adapt` (with a check), `untouched` (with a reason), or `follow-up` (with a started session). Acceptance runs every `adapt` check. When replacing a component, rehearse in shadow first and keep a bit-identical way back.
