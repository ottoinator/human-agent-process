# Runtime and memory policy

Reference for the `lightrag-local` Skill. The Skill is a thin HTTP client for an
existing local LightRAG container. This document explains the runtime
assumptions, endpoint mapping, and memory hygiene rules in more depth than
`SKILL.md`.

## Runtime assumptions

- Host: macOS, with Docker Desktop installed and running.
- A LightRAG container already exists on this machine. The Skill does **not**
  create, recreate, or manage it.
- The default service URL is `http://127.0.0.1:9621`. Port is bound to
  `127.0.0.1` only, so the API is not reachable from the network — this is the
  reason the Skill tolerates a missing `LIGHTRAG_API_KEY`.
- LightRAG is the upstream project at <https://github.com/HKUDS/LightRAG>.

### Configuration sources, in order

1. Environment: `LIGHTRAG_URL`, `LIGHTRAG_API_KEY`.
2. File: `~/.lightrag-local.env` (overridable via `LIGHTRAG_CONFIG`).
3. Built-in defaults: `LIGHTRAG_URL=http://127.0.0.1:9621`, no API key.

The Skill never writes secrets to its own files. If the server is configured to
require auth, set the key like this:

```bash
export LIGHTRAG_API_KEY="..."
# or, persistent:
cat > ~/.lightrag-local.env <<'EOF'
LIGHTRAG_URL=http://127.0.0.1:9621
LIGHTRAG_API_KEY=...
EOF
chmod 600 ~/.lightrag-local.env
```

### Container discovery

`status` greps `docker ps` for rows whose name or image contains `lightrag`.
This is informational only; the Skill never depends on a fixed container name.

## Endpoint mapping

| CLI command         | HTTP                                     | Notes |
|---------------------|------------------------------------------|-------|
| `health`            | `GET  /health`                           | also reports `auth_mode` |
| `docs`              | `GET  /documents`                        | document index |
| `pipeline-status`   | `GET  /documents/pipeline_status`        | ingest progress |
| `search "<q>"`      | `POST /query` `{mode:"mix", include_references:true, stream:false}` | full LLM answer + refs |
| `context "<q>"`     | `POST /query` `{mode:"mix", only_need_context:true, include_references:true, include_chunk_content:true, stream:false}` | retrieved evidence only, no LLM call |
| `write "<src>" "<text>"` | `POST /documents/text` `{text, file_source}` | inserts a single text |
| `write-file <path>` | `POST /documents/text` with file body    | `file_source` = basename |
| `reprocess`         | `POST /documents/reprocess_failed`       | empty body |

`mix` is LightRAG's default and combines vector search with knowledge-graph
reasoning. Use `context` rather than `search` whenever you want raw chunks for
citation, comparison, or low-cost lookups (no LLM call).

## Auth handling

- If `LIGHTRAG_API_KEY` is set, every request includes `X-API-Key: $key`.
- If the server returns `401`/`403`, the Skill prints a clear message naming
  the env var and the config file. It does not try to recover silently.

## Memory hygiene

LightRAG here is a **second brain** for the user's whole work life — projects,
people, partners/suppliers, decisions, meetings, strategy, and lessons —
not just a coding scratchpad. The rules below are framed for that use.

The "do not store" list in `SKILL.md` is operational. The reasons:

1. **Secrets** — LightRAG is a knowledge base, not a vault. Anything stored
   is embedded and indexed; revoking a leaked secret is painful. Redact
   before writing.
2. **HR / personal-confidential** (salary, reviews, disciplinary, third-party
   personal data) — even on a local Mac, treat the index as exportable.
3. **Raw dumps** — emails, chats, stack traces, logs — without a written
   summary they are noise. Store the *insight* or *fact*, not the dump.
4. **Transient status** — half-finished PRs, in-flight todos, scratch state
   that will be wrong in a week.

Project-specific facts about the user's own projects, customers, suppliers,
and decisions are **not** trivia — those are the point of the second brain.
Write them.

### When to write

A few good triggers:

- After a meeting or sync with action items, decisions, or a changed
  understanding of a relationship.
- After making a real decision (product, marketing, ops, hiring, partnership)
  whose rationale and trade-offs matter beyond the moment.
- After learning a durable fact about a person, customer, partner, or
  supplier (role, preferences, strategic posture, owner internally).
- After a project status meaningfully changes (milestone, blocker, pivot).
- After fixing a non-obvious bug, building an agent/automation pattern,
  hitting a known-bad approach, or codifying a runbook.

### When **not** to write

- A routine edit, message, or one-off scratch script.
- A passing thought that would not survive a week.
- Anything that needs more than ~30 lines to express — usually the entry is
  unfocused; tighten or split.

### Templates

`SKILL.md` defines six templates: **Decision, Meeting, Person, Customer/
Partner/Supplier, Project status, Lesson/Runbook**. Pick the closest fit;
do not force a meeting into the lesson template or vice versa. If two fit,
pick the one whose primary question matches the entry ("what was decided"
vs "what happened" vs "who is this person").

### Worked example — Lesson / Runbook

```
Title: Treat Docker `restart: unless-stopped` as the autostart contract on macOS
Context: LightRAG container needs to come back after Mac reboot.
Problem: `deploy.restart_policy` only applies in Swarm mode and is silently
         ignored by `docker compose up`.
Solution: Use top-level `restart: unless-stopped` plus Docker Desktop
         AutoStart=true; verify after a real Docker daemon restart.
Why: Compose v2 maps `restart:` to the engine restart policy; `deploy.*` is
       Swarm-only.
Reuse: Any single-host Compose service that must self-heal.
Do not apply when: Service is intentionally session-scoped, or you want
                     `on-failure` semantics with a max-retry cap.
Risks: Will also restart after intentional `docker kill`, masking crashes.
Sources: docker compose docs (deploy.restart_policy vs restart),
         Docker Desktop settings-store.json `AutoStart`.
```

### Worked example — Decision

```
Title: Use OpenAI gpt-4o-mini as default LLM for local LightRAG
Context: Setting up LightRAG on Mac as a personal second brain. Choice between
         OpenAI, Gemini, and local Ollama.
Decision: OpenAI gpt-4o-mini + text-embedding-3-small.
Rationale: Lowest setup friction, good quality/cost ratio for a personal KB,
             no extra infra to manage. Ollama keeps Mac fan loud during ingest.
Trade-offs: Data leaves the machine for embeddings + LLM calls. Acceptable for
            non-secret business memory; not acceptable for HR/credentials.
Who / when: <owner>, <month year>.
Affects: All future writes go through OpenAI; switching later means
                re-embedding the whole index.
Sources: ~/lightrag/.env, LightRAG env.example.
```

### Worked example — Person

```
Name / role: <example> Head of Product
Organisation: <example> Acme Travel
Relationship context: Ongoing partnership discussion since a trade fair in 2026.
What matters to them / style: Direct, data-driven; prefers crisp written
                              follow-ups over long calls.
Last status: Awaiting our integration scoping doc; we promised end of May.
Sensitivities: Cost-sensitive on per-API-call pricing.
Sources: trade-fair notes, last email thread.
```

Strong entries answer "what is true", "what to do" and "what *not* to do" in
three or four lines each — regardless of which template you pick.

## Failure modes

| Symptom                               | Likely cause                                    | Action |
|---------------------------------------|-------------------------------------------------|--------|
| `curl failed`                         | Docker not running or container down            | `docker ps`, then `docker compose up -d` in the LightRAG dir |
| `HTTP 401/403`                        | Auth enabled, key missing                       | Set `LIGHTRAG_API_KEY` |
| `HTTP 500` from `/query`              | LLM provider error (e.g. OpenAI)                | Check provider key in the container's `.env`; container logs |
| `pipeline-status` shows stuck pending | Ingest worker idle or LLM rate-limited          | `reprocess`, then re-check |
| Search returns thin results           | Index small, or query too narrow                | Try several phrasings; `docs` to see what is actually indexed |

Always prefer fixing the cause over working around it in the Skill.
