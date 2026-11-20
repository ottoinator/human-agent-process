#!/usr/bin/env node
// Merge or remove the Owner Override hook entries in a Codex hooks.json, touching nothing else.
// Usage: node hooks.mjs upsert|remove <hooks.json> <script-path> [--dry-run]
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

export const EVENTS = ["SessionStart", "UserPromptSubmit", "SubagentStart"];
export const MARK = "hap-owner-override";

const isOurs = (h) => typeof h?.command === "string" && h.command.includes(MARK);

export function upsert(doc, script) {
  const out = structuredClone(doc ?? {});
  out.hooks ??= {};
  for (const ev of EVENTS) {
    const groups = (out.hooks[ev] ??= []);
    if (!Array.isArray(groups)) throw new Error(`hooks.${ev} is not a list`);
    const cmd = `python3 "${script}"`;
    let found = false;
    for (const g of groups) for (const h of g.hooks ?? []) if (isOurs(h)) { h.command = cmd; found = true; }
    if (!found) groups.push({ hooks: [{ type: "command", command: cmd, timeout: 10 }] });
  }
  return out;
}

export function remove(doc) {
  const out = structuredClone(doc ?? {});
  for (const ev of Object.keys(out.hooks ?? {})) {
    if (!Array.isArray(out.hooks[ev])) continue;
    out.hooks[ev] = out.hooks[ev]
      .map((g) => ({ ...g, hooks: (g.hooks ?? []).filter((h) => !isOurs(h)) }))
      .filter((g) => g.hooks.length);
    if (!out.hooks[ev].length) delete out.hooks[ev];
  }
  if (out.hooks && !Object.keys(out.hooks).length) delete out.hooks;
  return out;
}

if (process.argv[1] && fs.realpathSync(process.argv[1]) === fs.realpathSync(fileURLToPath(import.meta.url))) {
  const [cmd, file, script, flag] = process.argv.slice(2);
  const dry = flag === "--dry-run";
  let doc = null;
  if (fs.existsSync(file)) {
    try { doc = JSON.parse(fs.readFileSync(file, "utf8")); }
    catch (e) { console.error(`SKIP ${file}: not valid JSON (${e.message}); add the hook by hand`); process.exit(3); }
  }
  if (cmd === "remove" && doc === null) process.exit(0);
  let next = null;
  try { next = cmd === "upsert" ? upsert(doc, script) : cmd === "remove" ? remove(doc) : null; }
  catch (e) { console.error(`SKIP ${file}: unexpected shape (${e.message}); add the hook by hand`); process.exit(3); }
  if (!next) { console.error("usage: hooks.mjs upsert|remove <file> <script> [--dry-run]"); process.exit(2); }
  const text = JSON.stringify(next, null, 2) + "\n";
  if (fs.existsSync(file) && fs.readFileSync(file, "utf8") === text) { console.log(`same ${file}`); process.exit(0); }
  if (dry) { console.log(`would write ${file}`); process.exit(0); }
  if (fs.existsSync(file)) {
    const bak = `${file}.hap-backup-${Date.now()}`;
    fs.copyFileSync(file, bak); console.log(`backup ${bak}`);
  }
  if (cmd === "remove" && !Object.keys(next).length) { fs.rmSync(file); console.log(`removed ${file}`); process.exit(0); }
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, text);
  console.log(`wrote ${file}`);
}
