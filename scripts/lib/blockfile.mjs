#!/usr/bin/env node
// Marked-block upsert/remove with byte-exact restore. Used by scripts/install.sh.
// Usage: blockfile.mjs upsert <file> <blockfile> [--dry-run] | remove <file> [--dry-run]
import fs from "node:fs";
import path from "node:path";

const BEGIN = /^<!-- human-agent-process:begin [^\n]*-->\n/m;
const END = "<!-- human-agent-process:end -->\n";
const enc = "latin1";

function regions(text) {
  const out = [];
  let from = 0;
  for (;;) {
    const m = BEGIN.exec(text.slice(from));
    if (!m) break;
    const start = from + m.index;
    const e = text.indexOf(END, start + m[0].length);
    if (e < 0) break;
    out.push([start, e + END.length]);
    from = e + END.length;
  }
  return out;
}

const ts = () => new Date().toISOString().replace(/[-:]/g, "").replace(/\..*/, "");
const [cmd, file, arg3] = process.argv.slice(2);
const dry = process.argv.includes("--dry-run");
if (!file) { console.error("usage: blockfile.mjs upsert|remove <file> ..."); process.exit(2); }
const side = `${file}.hap-state`;
const exists = fs.existsSync(file);
const orig = exists ? fs.readFileSync(file, enc) : "";

if (cmd === "upsert") {
  const block = fs.readFileSync(arg3, enc);
  const regs = regions(orig);
  if (regs.length === 0) {
    const nonl = orig.length > 0 && !orig.endsWith("\n");
    const sep = orig.length > 0;
    const next = orig + (nonl ? "\n" : "") + (sep ? "\n" : "") + block;
    console.log(`${dry ? "would append" : "append"} block: ${file}`);
    if (!dry) {
      fs.mkdirSync(path.dirname(file), { recursive: true });
      if (exists) fs.copyFileSync(file, `${file}.hap-backup-${ts()}`);
      fs.writeFileSync(side, JSON.stringify({ created: !exists, nonl, sep }) + "\n");
      fs.writeFileSync(file, next, enc);
    }
  } else {
    let next = orig;
    for (let i = regs.length - 1; i >= 0; i--) {
      const [s, e] = regs[i];
      next = next.slice(0, s) + (i === 0 ? block : "") + next.slice(e);
    }
    if (next === orig) console.log(`unchanged block: ${file}`);
    else {
      console.log(`${dry ? "would replace" : "replace"} block: ${file}`);
      if (!dry) fs.writeFileSync(file, next, enc);
    }
  }
} else if (cmd === "remove") {
  const regs = regions(orig);
  if (!exists || regs.length === 0) { console.log(`no block: ${file}`); process.exit(0); }
  let st = null;
  try { st = JSON.parse(fs.readFileSync(side, "utf8")); } catch { /* no sidecar */ }
  let next = orig;
  let first = regs[0][0];
  for (let i = regs.length - 1; i >= 0; i--) next = next.slice(0, regs[i][0]) + next.slice(regs[i][1]);
  const sep = st ? st.sep : next.slice(0, first).endsWith("\n\n");
  if (sep && next.slice(0, first).endsWith("\n")) { next = next.slice(0, first - 1) + next.slice(first); first -= 1; }
  if (st && st.nonl && next.slice(0, first).endsWith("\n")) next = next.slice(0, first - 1) + next.slice(first);
  if (next.trim() === "" && st && st.created) {
    console.log(`${dry ? "would delete" : "delete"} file (created by install): ${file}`);
    if (!dry) { fs.unlinkSync(file); fs.rmSync(side, { force: true }); }
  } else {
    console.log(`${dry ? "would remove" : "remove"} block: ${file}`);
    if (!dry) { fs.writeFileSync(file, next, enc); fs.rmSync(side, { force: true }); }
  }
} else {
  console.error("usage: blockfile.mjs upsert|remove ...");
  process.exit(2);
}
