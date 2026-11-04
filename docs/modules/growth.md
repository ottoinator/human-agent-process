# Module: growth

**Default: on.**

Switch it on when anything you build keeps writing: a file, directory, table,
log, bundle, or inbox. Before building such a writer the plan states the write
trigger, size per write, day, and month, an upper bound or retention, and the
alarm path. It writes only on a real content change: no clocks, heartbeats, or
drifting values in the content identity. Content-addressed output is
deduplicated, never stored as a full copy per revision. Real growth is
measured 24 hours and 7 days after go-live; a deviation is a finding.

**Cost:** a few lines in the plan and two later measurements. Leave it off for
pure read-only or one-shot work.

Story: [the log that grew by gigabytes](../why/log-growth.md).
Rule text: `core/policy/modules/growth.md`.
