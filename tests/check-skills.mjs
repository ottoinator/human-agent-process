// Every skill has front matter with name (== directory) and a description,
// and every relative link inside it resolves within the skill directory
// (skills are copied out of the repo and must be self-contained).
import fs from "node:fs";
import path from "node:path";

const root = "claude/skills";
let failed = false;
for (const dir of fs.readdirSync(root)) {
  const file = path.join(root, dir, "SKILL.md");
  if (!fs.existsSync(file)) { console.error(`${dir}: no SKILL.md`); failed = true; continue; }
  const text = fs.readFileSync(file, "utf8");
  const m = text.match(/^---\n([\s\S]*?)\n---\n/);
  if (!m) { console.error(`${dir}: missing front matter`); failed = true; continue; }
  const name = m[1].match(/^name:\s*(.+)$/m)?.[1]?.trim();
  const desc = m[1].match(/^description:\s*(.+)$/m)?.[1]?.trim();
  if (name !== dir) { console.error(`${dir}: front matter name "${name}" != directory`); failed = true; }
  if (!desc || desc.length < 40) { console.error(`${dir}: description missing or too short`); failed = true; }
  for (const link of text.matchAll(/(?<!!)\[[^\]]+\]\(([^)]+)\)/g)) {
    const raw = link[1];
    if (/^(https?:|mailto:|#)/.test(raw)) continue;
    const target = path.resolve(path.dirname(file), raw.split("#")[0]);
    if (!target.startsWith(path.resolve(root, dir))) { console.error(`${dir}: link escapes skill dir: ${raw}`); failed = true; }
    else if (!fs.existsSync(target)) { console.error(`${dir}: broken link ${raw}`); failed = true; }
  }
  const refDir = path.join(root, dir, "references");
  const extra = fs.existsSync(refDir) ? fs.readdirSync(refDir).filter((f) => f.endsWith(".md")).map((f) => path.join(refDir, f)) : [];
  for (const rf of [file, ...extra]) {
    const t = fs.readFileSync(rf, "utf8");
    if (/`\.\.\//.test(t) || /\]\(\.\.\//.test(t)) { console.error(`${dir}: ${path.basename(rf)} references a path outside the skill (../)`); failed = true; }
  }
}
if (failed) process.exit(1);
