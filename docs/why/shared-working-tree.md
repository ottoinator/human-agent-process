# Two agents, one working tree

**What happened.** Two scheduled agents wrote into the same repository. One
was midway through editing when the other ran `git add -A` and committed.
The second agent's commit contained the first agent's half-finished files, and
the first agent then failed on a clean tree. A cleanup step elsewhere
discarded the leftovers, so the work was lost.

**Why it slipped through.** Each agent was correct alone. Nobody had written
down who else writes to those paths, and "commit everything" looked harmless.

**The rule.** Every automated writer declares its write paths, co-writers,
lock, and end behaviour before it is built. It commits only its own paths,
never discards foreign changes (it rescues them to a named ref plus a patch
and reports), and its first run is supervised. See
[concurrency module](../modules/concurrency.md).
