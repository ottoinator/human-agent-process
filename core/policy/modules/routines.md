---
id: routines
title: Promised routines
kind: module
default: on
---
## Module: promised routines

Every routine a plan promises (scheduled job, service, recurring agent run) is listed machine-readably in the plan (id, kind, cadence, maximum gap, due date) and in one central expected-routines list. A package is done only when each promised routine exists with its schedule and has had its first run. A daily read-only check reports routines that are missing, overdue, or unlisted.
