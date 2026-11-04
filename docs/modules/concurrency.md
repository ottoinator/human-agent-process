# Module: concurrency

**Default: on.**

Switch it on when an automated writer (scheduled job, agent, script) writes
into a git repository or shared state. Before building it, state the write
paths, the co-writers, the lock it takes, and its end behaviour. Commit only
your own paths, never `git add -A`. Never discard or co-commit someone else's
uncommitted changes: stash them to a named ref plus a patch and report it.
Supervise the first run.

**Cost:** a short contract in the plan and a lock around each run. Leave it
off for a repository with exactly one human writer and no automation.

Story: [two agents, one working tree](../why/shared-working-tree.md).
Rule text: `core/policy/modules/concurrency.md`.
