# Seven forgotten places

**What happened.** A new component was added to a system. Every acceptance
check was green: its own tests passed and the build was clean. Weeks later it
turned out that seven other places had never been told: a status page, a
registry, two dashboards, a backup list, an alert rule, and a documentation
index. The component ran, but the system around it looked as if it did not
exist.

**Why it slipped through.** Acceptance only checked what the author remembered.
Nothing listed the consumers and registrations of the thing being added.

**The rule.** Keep a small system map and derive an impact inventory for each
change, plus a search for consumers. Each point is adapted (with a check),
untouched (with a reason), or a started follow-up. Acceptance runs every
adapted check. See [impact-map module](../modules/impact-map.md).
