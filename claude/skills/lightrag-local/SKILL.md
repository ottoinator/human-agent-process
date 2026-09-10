---
name: lightrag-local
description: Use a local LightRAG service as the user's persistent "second brain" — a knowledge base about projects, decisions, people, customers/partners/suppliers, meetings, strategy, runbooks, and reusable lessons. Use before non-trivial business OR technical work where prior context might apply, and after such work to capture durable, reusable knowledge. Skip for trivial one-off questions.
---

# lightrag-local

The user's **second brain**: a local [LightRAG](https://github.com/HKUDS/LightRAG)
knowledge base for everything worth remembering across their work. Not just
for coding.

The container runs locally (setup in the `memory/` directory of the
`human-agent-process` repository). This skill only talks to it over HTTP:

```
~/.claude/skills/lightrag-local/scripts/lightrag.sh <command> [args]
```

Defaults: `LIGHTRAG_URL=http://127.0.0.1:9621`. If the server requires auth,
the key comes from env `LIGHTRAG_API_KEY` or `~/.lightrag-local.env`.

## When to use

Invoke **before** any non-trivial task, especially if it touches:

- an active or recurring **project**
- a **meeting / sync / call** — prep, live notes, follow-up
- a named **customer, partner, supplier, vendor, stakeholder**
- **strategic / organisational / leadership** topics
- **product, marketing, go-to-market, pricing, positioning** decisions
- **operations, runbooks, processes** that recur
- non-trivial **debugging, architecture, deployment, automation, agent design**
- any moment where *"we have probably been here before"* is plausible

Skip for ad-hoc factual questions with no project link, single-sentence edits,
trivial one-shots.

## Search before work

1. Check the service is reachable, and self-heal it if not:

   ```
   lightrag.sh ensure
   ```

   `ensure` verifies health and, if the service is down, walks the recovery
   ladder (start Docker Desktop → restart the container → `docker compose up
   -d` → wait until healthy). `search`, `context`, `write`, and `health`
   auto-heal once on their own, so you rarely need this step.

2. Search with focused queries; run 2–3 phrasings if the first is thin:

   ```
   lightrag.sh search "<project> status"
   lightrag.sh search "<person or company> last contact"
   lightrag.sh search "decision about <topic>"
   ```

3. For raw evidence without an LLM call:

   ```
   lightrag.sh context "<question>"
   ```

4. Treat results as **prior art**: priors that still must be verified against
   the current document, repo, conversation, or system.

## Capture after work — mandatory and automatic

If the work falls into any trigger category above and produced a durable
artefact (decision, meeting outcome, project status, customer/partner update,
reusable lesson, runbook, published page), **capture it as the final step,
automatically, without asking first**. "Should I save this?" is reserved for
cases where durability or appropriateness is genuinely ambiguous.

Skip only if the content fails the quality bar, falls under *Do not store*, or
duplicates an existing memory.

### Source naming

`<source>` becomes `file_source` and is what appears in search references.
**Name it on the first write**: dedupe is by content hash, so a bad label is
not fixable by re-writing.

```
project/<name>/<topic>
people/<organisation>/<name>
supplier/<name>/<topic>
decision/<area>/<short-id>
meeting/<date>-<topic>
runbook/<area>/<short-id>
lesson/<area>/<short-id>
```

### Templates — pick the one that fits the type of knowledge

**Decision**

```
Title:
Context:
Decision:
Rationale:
Trade-offs:
Who / when:
Affects:
Sources:
```

**Meeting / Sync**

```
Title:
Date / participants:
Topics:
Outcomes:
Action items (who / what / by when):
Open points:
Next meeting:
Sources:
```

**Person / Relationship** — durable facts, not gossip

```
Name / role:
Organisation:
Relationship context:
What matters to them / style:
Last status:
Sensitivities:
Sources:
```

**Customer / Partner / Supplier**

```
Organisation:
Status / stage:
Commercial frame (rough):
Strategic importance:
Internal owner:
Known risks:
Last status:
Sources:
```

**Project status snapshot**

```
Project:
Goal:
Current state:
Next steps:
Blockers:
Owner / stakeholders:
Last update:
Sources:
```

**Lesson / Runbook**

```
Title:
Context:
Problem:
Solution:
Why:
Reuse:
Do not apply when:
Risks:
Sources:
```

Write with:

```
lightrag.sh write "decision/product/example" "Title: ...
Context: ...
Decision: ..."

lightrag.sh write-file ./notes/decision-product-example.md   # file_source = basename
lightrag.sh pipeline-status                                   # verify ingest
```

Re-writing identical content under the same source is treated as a duplicate.
Use a new source name for a new version when both should stay searchable.

## Quality bar

Store only knowledge that is **durable** (true beyond a single ticket or
week), **compact** (one screen), **reusable** (answers "what to do" or "what to
know" next time), and **non-secret**. One strong memory beats three weak ones.
Test: *would reading this in six months on a different project save me ten
minutes?*

## Do not store

- API keys, tokens, passwords, OAuth secrets, JWTs, connection strings
- salary, performance reviews, disciplinary content, HR-confidential data
- raw confidential commercial documents not approved for memory
- third-party personal data without clear, lawful business reuse value
- raw email / chat / log dumps without a written summary
- noisy intermediate status (transient PR state, in-flight todos)
- anything you would not leave in plain text on this machine

If you find a secret-shaped string, redact it before writing.

## Deletion is forbidden

**Never call `DELETE /documents`.** In at least one deployment that endpoint
ignored its `doc_ids` payload and **wiped the entire knowledge base** while
replying `{"status":"success"}`.

- `lightrag.sh` deliberately exposes **no delete command**. That omission is a
  safety feature, not a gap to route around.
- Do not hand-roll `curl` against endpoints the wrapper does not expose.
- A wrong `file_source` name is cosmetic. Never take deletion risk to fix one.

## Backups

`memory/scripts/backup.sh` in the `human-agent-process` repository snapshots the
store with hardlink dedupe, refuses to snapshot a suspected wipe (store shrank
by more than 80%), and tolerates live writes. Run it on a timer (a launchd
template is in `memory/`). Before the wipe above there was no backup of any
kind; do not repeat that.

## Exact commands

```bash
lightrag.sh status            # config, key presence, health, containers
lightrag.sh ensure            # self-heal to healthy (aliases: heal, up)
lightrag.sh health
lightrag.sh docs              # list stored documents
lightrag.sh pipeline-status
lightrag.sh search  "topic or question"
lightrag.sh context "topic or question"
lightrag.sh write "<source>" "<text>"
lightrag.sh write-file ./notes/file.md
lightrag.sh reprocess         # un-stick documents left pending after a restart
```

## If LightRAG is unavailable

The script self-heals first. If `ensure` still fails after that, continue the
user's task, state explicitly that prior-art search and/or capture could not be
performed and why, and move on. Do not retry indefinitely. Set
`LIGHTRAG_AUTOHEAL=0` for a read-only probe.

## Reference

[`references/runtime-and-memory-policy.md`](references/runtime-and-memory-policy.md)
— runtime assumptions, endpoint mapping, memory hygiene, worked examples.
