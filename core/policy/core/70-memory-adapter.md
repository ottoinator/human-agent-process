---
id: memory-adapter
title: Memory adapter
kind: core
---
## Memory adapter

Separate working memory (session notes, current constraints) from long-term memory (durable, sanitized knowledge). Long-term memory is an adapter: any store the owner chooses, or none.

Write to long-term memory only a root cause with its fix, a guardrail, a runbook step, a rejected alternative with its reason, or a non-obvious constraint. Never write progress, transient state, raw data, secrets, or what the repository and its history already record. Treat recalled entries as prior art to verify against the source, not as truth.
