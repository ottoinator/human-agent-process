**Adapter: LightRAG, via the `lightrag-local` skill.** A local knowledge base
about your work, projects, people, customers/partners/suppliers, decisions,
meetings, strategy, and reusable lessons. It runs locally (setup in `memory/`
of the human-agent-process repository) and this skill talks to it over HTTP.
Treat it as default working memory across business *and* technical tasks.

- **Search:** invoke `lightrag-local` · `lightrag.sh ensure` confirms health
  and self-heals · `lightrag.sh search "<phrasing>"` two or three times ·
  `lightrag.sh context "<question>"` for raw evidence without an LLM call.
- **Capture is automatic.** When the work produced a durable artefact, write it
  as the final step **without asking first**; the default is capture, applied
  silently. Ask only when durability is *genuinely* ambiguous (a half-finished
  draft the user may discard). "I wasn't sure" is not a reason to ask.
  Templates (Decision · Meeting · Person · Customer/Partner/Supplier · Project
  status · Lesson/Runbook) and the source-naming scheme live in the skill.
  Name the source on the first write: dedupe is by content hash.
- **Audit:** `lightrag.sh docs` lists stored documents; diff it against the
  walked sources.
- **Never delete.** The wrapper exposes no delete command on purpose; do not
  hand-roll `curl` against endpoints it does not expose.
- **Privacy posture:** the store is local and not encrypted at rest, and
  embeddings and queries go to the LLM provider named in its `.env`. Treat it
  like a personal notebook on this machine.
