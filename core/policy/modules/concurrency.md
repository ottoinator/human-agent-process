---
id: concurrency
title: Concurrency contract
kind: module
default: on
---
## Module: concurrency contract

Before building any automated writer into a git repository or shared state (scheduled job, agent, script), state: write paths, co-writers, the lock it takes, and its end behaviour. Commit only your own paths, never `git add -A`. Never discard or co-commit someone else's uncommitted changes; stash them to a named ref plus a patch file and report it. Supervise the first run.
