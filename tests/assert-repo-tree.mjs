import fs from "node:fs";
import path from "node:path";

const required = [
  "README.md", "AGENTS.md", "CLAUDE.md", "LICENSE", "LICENSE-DOCS.md",
  "CONTRIBUTING.md", "CODE_OF_CONDUCT.md", "SECURITY.md", "CHANGELOG.md",
  "docs/process/principles.md", "docs/process/lifecycle.md",
  "docs/process/quality-gates.md", "docs/process/critic-gate.md",
  "docs/knowledge-work/README.md", "docs/knowledge-work/provenance.md",
  "docs/reference/public-safety.md", "docs/reference/memory-layer.md",
  "docs/setup/claude-code.md",
  "claude/CLAUDE.md", "claude/settings.example.json",
  "claude/hooks/memory-capture-reminder.sh",
  "claude/skills/software-dev-process/SKILL.md",
  "claude/skills/knowledge-work-process/SKILL.md",
  "claude/skills/critic-reviewer/SKILL.md",
  "claude/skills/qa-engineer/SKILL.md",
  "claude/skills/lightrag-local/SKILL.md",
  "claude/skills/lightrag-local/scripts/lightrag.sh",
  "claude/memory/lightrag.md",
  "docs/decisions",
  "memory/README.md", "memory/docker-compose.yml", "memory/.env.example",
  "memory/scripts/backup.sh",
  "templates/README.md", "templates/claude/CLAUDE.project.md",
  "templates/project/AGENTS.md", "templates/knowledge/ARTEFACT_BRIEF.md",
  "examples/minimal-adoption/README.md",
  "scripts/install.sh", "scripts/qa.sh", ".github/workflows/qa.yml",
];
const forbidden = [".env", "node_modules", ".DS_Store", "claude/settings.json", "claude/settings.local.json"];

let failed = false;
for (const f of required) if (!fs.existsSync(f)) { console.error(`missing required path: ${f}`); failed = true; }

function walk(dir) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const rel = path.relative(process.cwd(), path.join(dir, e.name));
    if (rel.startsWith(".git")) continue;
    if (forbidden.some((x) => rel === x || rel.endsWith(`/${x}`))) { console.error(`forbidden path present: ${rel}`); failed = true; }
    if (e.isDirectory()) walk(path.join(dir, e.name));
  }
}
walk(process.cwd());
if (failed) process.exit(1);
