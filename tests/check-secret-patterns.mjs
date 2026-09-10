import fs from "node:fs";
import path from "node:path";

const patterns = [
  /sk-[A-Za-z0-9_-]{20,}/,
  /github_pat_[A-Za-z0-9_]{20,}/,
  /gh[pousr]_[A-Za-z0-9_]{20,}/,
  /-----BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY-----/,
  /AWS_SECRET_ACCESS_KEY\s*=\s*\S{10,}/i,
  /password\s*=\s*["'][^"'<]{8,}["']/i,
  /xox[abp]-[A-Za-z0-9-]{10,}/,
];
// Private-context words that must not appear in a published copy.
const privateWords = [/\bnezasa\b/i, /\/Users\/[a-z]+\//, /reneotto/i, /atlassian\.net/i];
const skipDirs = new Set([".git", "node_modules"]);
const skipExt = new Set([".png", ".jpg", ".jpeg", ".gif", ".pdf", ".zip"]);
let failed = false;

function walk(dir) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, e.name);
    if (e.isDirectory()) { if (!skipDirs.has(e.name)) walk(full); continue; }
    if (skipExt.has(path.extname(e.name).toLowerCase())) continue;
    const rel = path.relative(process.cwd(), full);
    const text = fs.readFileSync(full, "utf8");
    for (const p of patterns) if (p.test(text)) { console.error(`possible secret pattern in ${rel}`); failed = true; }
    if (rel !== "tests/check-secret-patterns.mjs" && rel !== "tests/check-skills.mjs")
      for (const p of privateWords) if (p.test(text)) { console.error(`private reference in ${rel}: ${p}`); failed = true; }
  }
}
walk(process.cwd());
if (failed) process.exit(1);
