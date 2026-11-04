---
id: growth
title: Growth contract
kind: module
default: on
---
## Module: growth contract

Before building any persistent writer (file, directory, table, log, bundle, inbox), state: what triggers a write, size per write/day/month, an upper bound or retention, and the alarm path. Write only on a real content change: no clocks, heartbeats, or drifting values in the content identity. Never store content-addressed output as a full copy per revision; deduplicate. Measure real growth 24 hours and 7 days after go-live; a deviation is a finding.
