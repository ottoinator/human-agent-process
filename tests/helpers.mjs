import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";

export const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
export const PLUGIN = path.join(ROOT, "plugins/human-agent-process");
export const rel = (p) => path.relative(ROOT, p).split(path.sep).join("/");

export function walk(dir, filter = () => true, out = []) {
  if (!fs.existsSync(dir)) return out;
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    if ([".git", "node_modules"].includes(e.name)) continue;
    const p = path.join(dir, e.name);
    if (e.isDirectory()) walk(p, filter, out);
    else if (filter(p)) out.push(p);
  }
  return out;
}

/** Copy the working tree (no .git, no node_modules) into a fresh temp dir. */
export function tempCopy() {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), "hap-test-"));
  fs.cpSync(ROOT, dir, { recursive: true, filter: (s) => !/[\\/](\.git|node_modules)([\\/]|$)/.test(s) });
  return dir;
}

export const node = (args, opts = {}) =>
  execFileSync(process.execPath, args, { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"], ...opts });

export function runStatus(args, opts = {}) {
  try { node(args, opts); return 0; } catch (e) { return e.status ?? 1; }
}

export const skillFiles = () => walk(path.join(PLUGIN, "skills"), (p) => path.basename(p) === "SKILL.md");
export const markdownFiles = () => walk(ROOT, (p) => p.endsWith(".md"));
