# Module: routines

**Default: on.**

Switch it on when a plan promises something that runs repeatedly: a scheduled
job, a service, a recurring agent run. Each routine is listed machine-readably
in the plan (id, kind, cadence, maximum gap, due date) and in one central
expected-routines list. A package is done only when every promised routine
exists with its schedule and has run once. A daily read-only check reports
routines that are missing, overdue, or unlisted.

**Cost:** one list entry per routine plus the daily check. Leave it off if
nothing recurring is promised.

Rule text: `core/policy/modules/routines.md`.
