# The log that grew by gigabytes

**What happened.** A small job wrote a status file whenever it ran. The file's
identity, used to decide "has this changed", included a timestamp. Every run
therefore looked new, and every run stored a full copy. A few weeks later the
disk was full and unrelated services failed.

**Why it slipped through.** Each write was tiny, so nobody sized the total.
Nothing alarmed on growth, and "it only writes when something changes" was an
assumption, not a test.

**The rule.** Before building a persistent writer, state the write trigger,
sizes per write, day, and month, a bound or retention, and the alarm path.
Keep clocks and drifting values out of the content identity, deduplicate
content-addressed output, and measure real growth after go-live. See
[growth module](../modules/growth.md).
