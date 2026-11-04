import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { skillFiles, markdownFiles, rel, ROOT } from "./helpers.mjs";
import { parseFrontmatter } from "../scripts/build.mjs";

const ALLOWED = new Set(["name", "description", "license", "metadata", "allowed-tools", "compatibility"]);
const PLATFORM_TOOLS = /\b(?:Agent tool|Skill tool)\b|spawn_agent|AskUserQuestion|TodoWrite|apply_patch/;

export function checkSkill(file, text) {
  const errors = [];
  const m = text.match(/^---\n([\s\S]*?)\n---\n/);
  if (!m) return [`${file}: no frontmatter`];
  const keys = {};
  let cur = null;
  for (const line of m[1].split("\n")) {
    const kv = line.match(/^([A-Za-z][\w-]*):\s*(.*)$/);
    if (kv) { cur = kv[1]; keys[cur] = kv[2]; if (!ALLOWED.has(cur)) errors.push(`${file}: field ${cur} not allowed`); }
    else if (!/^\s/.test(line) && line.trim()) errors.push(`${file}: bad frontmatter line`);
    else if (cur === "description") keys.description += " " + line.trim();
  }
  const dir = path.basename(path.dirname(file));
  if (keys.name !== dir) errors.push(`${file}: name "${keys.name}" != directory "${dir}"`);
  if (!keys.description) errors.push(`${file}: description missing`);
  else if (keys.description.length > 1024) errors.push(`${file}: description over 1024 chars`);
  return errors;
}

const skills = skillFiles();

test("skill spec", (t) => {
  if (!skills.length) return t.skip("no skills in plugins/human-agent-process/skills yet");
  const errors = skills.flatMap((f) => checkSkill(f, fs.readFileSync(f, "utf8")));
  assert.deepEqual(errors, []);
});

test("fixture: spec violations are detected", () => {
  const bad = "---\nname: other\ndescription: x\nmodel: opus\n---\nbody";
  const errs = checkSkill("a/skills/foo/SKILL.md", bad);
  assert.ok(errs.some((e) => /not allowed/.test(e)));
  assert.ok(errs.some((e) => /!= directory/.test(e)));
  assert.ok(checkSkill("a/foo/SKILL.md", `---\nname: foo\ndescription: ${"x".repeat(1025)}\n---\n`).some((e) => /1024/.test(e)));
});

test("no platform tool names in shared skills", (t) => {
  if (!skills.length) return t.skip("no skills yet");
  const files = skills.flatMap((f) => { const d = path.dirname(f); return fs.readdirSync(d, { recursive: true }).filter((x) => x.endsWith(".md")).map((x) => path.join(d, x)); });
  const hits = files.filter((f) => PLATFORM_TOOLS.test(fs.readFileSync(f, "utf8"))).map(rel);
  assert.deepEqual(hits, []);
  assert.ok(PLATFORM_TOOLS.test("use the Agent tool"));
});

test("markdown relative links resolve", () => {
  const broken = [];
  for (const f of markdownFiles()) {
    const text = fs.readFileSync(f, "utf8").replace(/```[\s\S]*?```/g, "");
    for (const m of text.matchAll(/\[[^\]]*\]\(([^)\s]+)\)/g)) {
      const target = m[1].split("#")[0];
      if (!target || /^[a-z][a-z0-9+.-]*:/i.test(target) || target.startsWith("/")) continue;
      if (!fs.existsSync(path.resolve(path.dirname(f), decodeURI(target)))) broken.push(`${rel(f)} -> ${m[1]}`);
    }
  }
  assert.deepEqual(broken, []);
});

test("core roles have the required frontmatter", () => {
  for (const r of ["critic", "implementer", "qa-runner", "researcher"]) {
    const { meta } = parseFrontmatter(fs.readFileSync(path.join(ROOT, `core/roles/${r}.md`), "utf8"));
    for (const k of ["name", "description", "model_class", "effort", "max_turns", "access"]) assert.ok(meta[k], `${r}.${k}`);
  }
});
