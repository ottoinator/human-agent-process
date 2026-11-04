# Memory adapter

Working memory (session notes, current constraints) is separate from
long-term memory (durable, sanitized knowledge). Long-term memory is an
adapter: any store you choose, or none. With none, reports say that prior-art
search and capture could not run.

Write to long-term memory only a root cause with its fix, a guardrail, a
runbook step, a rejected alternative with its reason, or a non-obvious
constraint. Never progress, transient state, raw data, secrets, or what the
repository already records. Recalled entries are prior art to verify against
the source, not truth.

An adapter provides search, capture with its own write policy, a listing of
stored documents, a do-not-store list, no delete, and an honest unavailable
state. The full contract is in the
[memory layer reference](../reference/memory-layer.md); a worked example is
[the LightRAG adapter](../../examples/memory-adapter-lightrag/README.md).
The decision record is
[memory adapter](../decisions/2026-09-10-memory-adapter.md).
