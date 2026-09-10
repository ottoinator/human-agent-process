# `memory/` — the second brain (LightRAG)

The process treats a persistent, searchable memory as part of *done*: search it
for prior art before substantial work, capture the durable outcome after. This
directory is the reference setup for that memory: a local
[LightRAG](https://github.com/HKUDS/LightRAG) container, bound to loopback,
with a backup script that refuses to overwrite good history with a wipe.

The `lightrag-local` skill (`../claude/skills/lightrag-local/`) is the client.
It never manages the container beyond restarting it.

## Setup

```bash
mkdir -p ~/lightrag/{data/rag_storage,data/inputs,scripts}
cp docker-compose.yml ~/lightrag/
cp .env.example ~/lightrag/.env         # then fill in your LLM + embedding keys
chmod 600 ~/lightrag/.env
cd ~/lightrag && docker compose up -d
curl -s http://127.0.0.1:9621/health
```

The `.env` holds provider keys and stays out of every repository. The compose
file mounts it read-only into the container.

If you place the compose file elsewhere, tell the skill with
`LIGHTRAG_COMPOSE=<path>` in `~/.lightrag-local.env` so self-heal can find it.

## Backups

The client's self-heal ladder launches Docker Desktop with `open -a Docker`,
which is macOS-only; on Linux start the daemon yourself and the rest works.

```bash
cp scripts/backup.sh ~/lightrag/scripts/backup.sh && chmod +x ~/lightrag/scripts/backup.sh
~/lightrag/scripts/backup.sh          # snapshot now
~/lightrag/scripts/backup.sh list     # snapshots with document counts
```

Snapshots land in `~/lightrag-backups/<timestamp>/`, hardlink-deduped against
the previous one, read-only, 30 kept. Two properties worth knowing:

- **It refuses to snapshot a suspected wipe.** If the document store shrank by
  more than 80% since the last snapshot the run aborts and existing snapshots
  are preserved. Override once with `touch ~/lightrag-backups/.allow-shrink`.
- **It tolerates live writes.** rsync partial-transfer codes during ingest are
  retried, then accepted only after a completeness check.

Run it on a timer. On macOS, `com.example.lightrag-backup.plist` is a launchd
template (twice daily plus at login); replace the label and the path, then:

```bash
cp com.example.lightrag-backup.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.example.lightrag-backup.plist
```

## Why this much care for a notebook

Once, a bare `DELETE /documents` call ignored its document-id payload and
wiped an entire knowledge base of several hundred entries while returning
success, and there was no backup of any kind. The client script has no delete
command, the skill forbids hand-rolled deletes, and the backup exists, because
of that afternoon.

## Privacy posture

The store is local and not encrypted at rest. Embeddings and queries go to
whichever LLM provider the `.env` names. Treat it like a personal notebook on
this machine: business-confidential is generally fine, secrets and
HR-confidential material never (see the *Do not store* list in the skill).
