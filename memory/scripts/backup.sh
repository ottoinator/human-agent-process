#!/bin/bash
# LightRAG local backup — hardlink-deduped snapshots of the RAG store.
#
# Exists because a bare `DELETE /documents` once wiped an entire knowledge base
# that had no backup of any kind (no Time Machine, no APFS snapshot, no Docker
# volume copy — the store is a bind mount). Run it on a timer.
#
# Usage:
#   backup.sh            take a snapshot (used by the launchd/cron timer)
#   backup.sh list       list snapshots
#   backup.sh restore <snapshot-dir>   restore a snapshot over the live store
#
# Snapshots live in $LIGHTRAG_BACKUP_DIR/<YYYYmmdd-HHMMSS>/ and are made
# read-only. rsync --link-dest hardlinks unchanged files against the previous
# snapshot, so a daily snapshot of a ~50 MB store costs near-zero disk unless
# the files actually changed.

set -euo pipefail

SRC="${LIGHTRAG_DATA:-$HOME/lightrag/data/rag_storage}"
DEST_ROOT="${LIGHTRAG_BACKUP_DIR:-$HOME/lightrag-backups}"
KEEP="${LIGHTRAG_BACKUP_KEEP:-30}"
LOG="$DEST_ROOT/backup.log"

log() { printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "$LOG" >&2; }

latest_snapshot() {
  find "$DEST_ROOT" -maxdepth 1 -type d -name '20*' 2>/dev/null | sort | tail -1
}

cmd_backup() {
  mkdir -p "$DEST_ROOT"
  [ -d "$SRC" ] || { log "ERROR: source not found: $SRC"; exit 1; }

  # Refuse to snapshot an empty/wiped store over the top of good history --
  # a wipe must never quietly become the newest "backup".
  local docs="$SRC/kv_store_full_docs.json"
  local prev; prev="$(latest_snapshot)"
  if [ -f "$docs" ] && [ -n "$prev" ] && [ -f "$prev/kv_store_full_docs.json" ]; then
    local now_sz prev_sz
    now_sz=$(wc -c <"$docs"); prev_sz=$(wc -c <"$prev/kv_store_full_docs.json")
    if [ "$now_sz" -lt $(( prev_sz / 5 )) ] && [ "$prev_sz" -gt 10000 ]; then
      log "REFUSING: kv_store_full_docs.json shrank ${prev_sz}B -> ${now_sz}B (>80% loss)."
      log "          Suspected wipe. Snapshot NOT taken; previous snapshots preserved."
      log "          If this shrink is intentional, run: touch $DEST_ROOT/.allow-shrink"
      if [ ! -f "$DEST_ROOT/.allow-shrink" ]; then exit 2; fi
      rm -f "$DEST_ROOT/.allow-shrink"
      log "          .allow-shrink present -> proceeding once."
    fi
  fi

  local stamp dest n
  stamp="$(date '+%Y%m%d-%H%M%S')"
  dest="$DEST_ROOT/$stamp"
  # Two runs in the same second would otherwise collide with a read-only dir.
  n=2
  while [ -e "$dest" ]; do dest="$DEST_ROOT/$stamp-$n"; n=$((n+1)); done
  stamp="$(basename "$dest")"

  local -a linkopt=()
  [ -n "$prev" ] && linkopt=(--link-dest="$prev")

  # LightRAG rewrites the store while running, so rsync can legitimately return
  # 23 (partial) / 24 (source file vanished) mid-ingest. Retry once, then accept
  # those codes -- but only after verifying the snapshot is actually complete.
  local rc=0 attempt
  for attempt in 1 2; do
    rc=0
    # ${arr[@]+...} guard: bash 3.2 (macOS) errors on empty array under `set -u`
    rsync -a --delete ${linkopt[@]+"${linkopt[@]}"} "$SRC"/ "$dest"/ || rc=$?
    [ "$rc" -eq 0 ] && break
    if [ "$rc" -eq 23 ] || [ "$rc" -eq 24 ]; then
      log "rsync rc=$rc (store changing during snapshot), attempt $attempt"
      sleep 3
    else
      log "ERROR: rsync failed rc=$rc"; exit "$rc"
    fi
  done

  # Completeness gate: every file in the live store must exist in the snapshot.
  local missing=0 f
  for f in "$SRC"/*; do
    [ -e "$f" ] || continue
    [ -e "$dest/$(basename "$f")" ] || { log "MISSING in snapshot: $(basename "$f")"; missing=1; }
  done
  if [ "$missing" -ne 0 ]; then
    log "ERROR: snapshot $stamp incomplete -- removing it"
    chmod -R u+w "$dest"; rm -rf "$dest"; exit 1
  fi

  chmod -R a-w "$dest"
  [ "$rc" -eq 0 ] || log "snapshot $stamp complete despite rsync rc=$rc (concurrent writes)"

  local n size
  n=$(find "$dest" -type f | wc -l | tr -d ' ')
  size=$(du -sh "$dest" | awk '{print $1}')
  log "snapshot $stamp -- $n files, $size (apparent), linked against ${prev:-none}"

  # rotation
  local all count
  all=$(find "$DEST_ROOT" -maxdepth 1 -type d -name '20*' | sort)
  count=$(printf '%s\n' "$all" | grep -c . || true)
  if [ "$count" -gt "$KEEP" ]; then
    printf '%s\n' "$all" | head -n $(( count - KEEP )) | while read -r old; do
      [ -n "$old" ] || continue
      chmod -R u+w "$old"; rm -rf "$old"; log "pruned $old"
    done
  fi
}

cmd_list() {
  printf '%-22s %8s  %s\n' SNAPSHOT DOCS SIZE
  find "$DEST_ROOT" -maxdepth 1 -type d -name '20*' | sort | while read -r d; do
    local docs=0
    if [ -f "$d/kv_store_full_docs.json" ]; then
      docs=$(python3 -c "import json,sys;print(len(json.load(open(sys.argv[1]))))" "$d/kv_store_full_docs.json" 2>/dev/null || echo '?')
    fi
    printf '%-22s %8s  %s\n' "$(basename "$d")" "$docs" "$(du -sh "$d" | awk '{print $1}')"
  done
}

cmd_restore() {
  local snap="${1:?usage: backup.sh restore <snapshot-dir>}"
  [ -d "$snap" ] || snap="$DEST_ROOT/$snap"
  [ -d "$snap" ] || { echo "no such snapshot: $snap" >&2; exit 1; }
  echo "This overwrites $SRC with $snap"
  echo "Stop the container first:  docker stop lightrag"
  read -r -p "Type RESTORE to proceed: " a
  [ "$a" = "RESTORE" ] || { echo "aborted"; exit 1; }
  mkdir -p "$SRC"; chmod -R u+w "$SRC"
  rsync -a --delete "$snap"/ "$SRC"/
  chmod -R u+w "$SRC"
  echo "restored. start with: docker start lightrag"
}

case "${1:-backup}" in
  backup|"") cmd_backup ;;
  list)      cmd_list ;;
  restore)   shift; cmd_restore "$@" ;;
  *) echo "usage: backup.sh [backup|list|restore <snapshot>]" >&2; exit 64 ;;
esac
