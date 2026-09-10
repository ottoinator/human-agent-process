#!/usr/bin/env bash
# Static QA for this repository. Node only; markdownlint runs when npx exists.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

echo "== repo tree ==";        node tests/assert-repo-tree.mjs
echo "== internal links ==";   node tests/check-internal-links.mjs
echo "== secret patterns ==";  node tests/check-secret-patterns.mjs
echo "== skill front matter =="; node tests/check-skills.mjs
echo "== paired docs ==";       node tests/check-paired-docs.mjs
echo "== shell syntax ==";     bash -n scripts/*.sh claude/hooks/*.sh claude/skills/lightrag-local/scripts/*.sh memory/scripts/*.sh
if [ "${QA_MARKDOWNLINT:-1}" = "1" ] && command -v npx >/dev/null 2>&1; then
  echo "== markdownlint =="
  npx --yes markdownlint-cli2@0.18.1 "**/*.md" "#node_modules" || { echo "markdownlint failed"; exit 1; }
else
  echo "== markdownlint == skipped (no npx or QA_MARKDOWNLINT=0)"
fi
echo "QA passed"
