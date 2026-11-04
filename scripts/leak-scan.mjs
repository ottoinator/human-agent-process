#!/usr/bin/env node
// Leak scan: generic private-path/host patterns plus optional private terms (env HAP_PRIVATE_TERMS).
// Usage: node scripts/leak-scan.mjs [--root DIR] [--history]
import fs from "node:fs";
import path from "node:path";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";

export const PATTERNS = [
  ["home path", /\/Users\/[a-z]/],
  ["home path", /(?<![\w])\/home\/(?!user\b)[a-z]+\//],
  ["tailnet host", /\.ts\.net/],
  ["private ops path", /~\/ops/],
  ["private routine id", /com\.[a-z]+\.routine/],
];
// Files that define the patterns themselves.
const SELF = new Set(["scripts/leak-scan.mjs", "tests/leak-scan.test.mjs"]);

export function loadTerms(file = process.env.HAP_PRIVATE_TERMS) {
  if (!file || !fs.existsSync(file)) return [];
  return fs.readFileSync(file, "utf8").split("\n").map((l) => l.trim()).filter((l) => l && !l.startsWith("#")).map((t) => t.toLowerCase());
}

export function scanText(label, text, terms) {
  const hits = [];
  const lines = text.split("\n");
  lines.forEach((line, i) => {
    for (const [name, re] of PATTERNS) if (re.test(line)) hits.push(`${label}:${i + 1}: ${name}`);
    const low = line.toLowerCase();
    for (const t of terms) if (low.includes(t)) hits.push(`${label}:${i + 1}: private term`);
  });
  return hits;
}

function files(root) {
  let list;
  try {
    list = execFileSync("git", ["ls-files", "-co", "--exclude-standard"], { cwd: root, encoding: "utf8" }).split("\n").filter(Boolean);
  } catch {
    list = [];
    const walk = (d) => {
      for (const e of fs.readdirSync(path.join(root, d), { withFileTypes: true })) {
        if (e.name === ".git" || e.name === "node_modules") continue;
        const rel = path.join(d, e.name);
        if (e.isDirectory()) walk(rel); else list.push(rel);
      }
    };
    walk("");
  }
  return list;
}

export function scanTree(root, terms = loadTerms()) {
  const hits = [];
  for (const rel of files(root)) {
    if (SELF.has(rel) || !fs.existsSync(path.join(root, rel))) continue;
    const buf = fs.readFileSync(path.join(root, rel));
    if (buf.includes(0)) continue;
    hits.push(...scanText(rel, buf.toString("utf8"), terms));
  }
  return hits;
}

export function scanHistory(root, terms = loadTerms()) {
  const run = (args) => execFileSync("git", args, { cwd: root, encoding: "utf8", maxBuffer: 1 << 30 });
  const hits = [];
  // Scan only what a push would newly publish: commits not reachable from the
  // already-public base (HAP_PUBLIC_BASE, default origin/main when it exists),
  // and within them only added lines plus author and message. Removed lines
  // are already public or never were. Skip diff lines of the pattern files.
  const base = process.env.HAP_PUBLIC_BASE ?? "origin/main";
  let range = ["--all"];
  try { run(["rev-parse", "--verify", "--quiet", base]); range = ["--all", "--not", base]; } catch { /* no public base: scan everything */ }
  const patch = run(["log", ...range, "-p", "--format=commit %H%nauthor %ae %an%nmessage %B"]);
  let skip = false;
  patch.split("\n").forEach((line, i) => {
    if (line.startsWith("diff --git")) skip = [...SELF].some((s) => line.endsWith(`b/${s}`));
    if (skip) return;
    if (line.startsWith("-") || line.startsWith(" ")) return;
    for (const [name, re] of PATTERNS) if (re.test(line)) hits.push(`history:${i + 1}: ${name}`);
    const low = line.toLowerCase();
    for (const t of terms) if (low.includes(t)) hits.push(`history:${i + 1}: private term`);
  });
  return hits;
}

if (process.argv[1] && fs.realpathSync(path.resolve(process.argv[1])) === fs.realpathSync(fileURLToPath(import.meta.url))) {
  const a = process.argv.slice(2);
  const ri = a.indexOf("--root");
  const root = ri >= 0 ? path.resolve(a[ri + 1]) : path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
  const hits = scanTree(root);
  if (a.includes("--history")) hits.push(...scanHistory(root));
  if (hits.length) { console.error(hits.join("\n")); process.exit(1); }
  console.log("leak-scan: clean");
}
