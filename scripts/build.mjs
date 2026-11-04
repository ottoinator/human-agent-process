#!/usr/bin/env node
// Generator: core/ -> plugin manifests, agents, policy blocks, marketplaces.
// Usage: node scripts/build.mjs [--check] | --block claude|codex --modules a,b|default|all|none
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { renderClaudeAgent } from "./lib/claude.mjs";
import { renderCodexAgent } from "./lib/codex.mjs";

export const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
export const BLOCK_LIMIT = 12288;
const PLUGIN = "plugins/human-agent-process";
const REPO_URL = "https://github.com/ottoinator/human-agent-process";
const DESCRIPTION =
  "Human-agent process: owner boundary, tiers, critic gate, QA and evidence rules, and workflow skills; four subagent roles come with the Claude plugin and the Codex installer.";

export function parseFrontmatter(text) {
  const m = text.match(/^---\n([\s\S]*?)\n---\n?([\s\S]*)$/);
  if (!m) return { meta: {}, body: text };
  const meta = {};
  for (const line of m[1].split("\n")) {
    const kv = line.match(/^([A-Za-z_][\w-]*):\s*(.*)$/);
    if (kv) meta[kv[1]] = kv[2].trim();
  }
  return { meta, body: m[2] };
}

function readDir(root, dir) {
  const d = path.join(root, dir);
  return fs.readdirSync(d).filter((f) => f.endsWith(".md")).sort().map((f) => {
    const { meta, body } = parseFrontmatter(fs.readFileSync(path.join(d, f), "utf8"));
    return { file: f, id: f.replace(/\.md$/, ""), meta, body };
  });
}

export function loadCore(root = ROOT) {
  const core = readDir(root, "core/policy/core");
  const modules = readDir(root, "core/policy/modules");
  const roles = readDir(root, "core/roles").map((r) => ({ ...r, meta: { ...r.meta, name: r.meta.name || r.id } }));
  const platforms = {
    claude: parseFrontmatter(fs.readFileSync(path.join(root, "core/platforms/claude.md"), "utf8")).body,
    codex: parseFrontmatter(fs.readFileSync(path.join(root, "core/platforms/codex.md"), "utf8")).body,
  };
  return { core, modules, roles, platforms };
}

export function resolveModules(spec, modules) {
  const all = modules.map((m) => m.id);
  if (spec === "all") return all;
  if (spec === "none") return [];
  if (spec === "default") return modules.filter((m) => m.meta.default === "on").map((m) => m.id);
  const want = spec.split(",").map((s) => s.trim()).filter(Boolean);
  for (const w of want) if (!all.includes(w)) throw new Error(`unknown module: ${w} (known: ${all.join(", ")})`);
  return all.filter((id) => want.includes(id));
}

export function renderBlock(platform, moduleIds, version, loaded) {
  const { core, modules, platforms } = loaded;
  if (!platforms[platform]) throw new Error(`unknown platform: ${platform}`);
  const parts = [`Human-agent process v${version}. Managed block: do not edit between the markers; reinstall to change it.`];
  for (const c of core) parts.push(c.body.trim());
  for (const m of modules) if (moduleIds.includes(m.id)) parts.push(m.body.trim());
  parts.push(platforms[platform].trim());
  const list = moduleIds.length ? moduleIds.join(",") : "none";
  return `<!-- human-agent-process:begin v${version} modules=${list} -->\n${parts.join("\n\n")}\n<!-- human-agent-process:end -->\n`;
}

const json = (o) => JSON.stringify(o, null, 2) + "\n";

export function generate(root = ROOT) {
  const version = JSON.parse(fs.readFileSync(path.join(root, "package.json"), "utf8")).version;
  const loaded = loadCore(root);
  const out = new Map();
  const author = { name: "Rene Otto" };
  const base = { name: "human-agent-process", version, description: DESCRIPTION, author, license: "MIT", repository: REPO_URL };
  out.set(`${PLUGIN}/.claude-plugin/plugin.json`, json(base));
  out.set(`${PLUGIN}/.codex-plugin/plugin.json`, json({ ...base, skills: "./skills/",
    interface: { displayName: "Human-Agent Process", shortDescription: "Owner boundary, tiers, critic gate, QA and evidence rules.", category: "Productivity" } }));
  for (const r of loaded.roles) {
    out.set(`${PLUGIN}/agents/${r.meta.name}.md`, renderClaudeAgent(r));
    out.set(`${PLUGIN}/codex/agents/${r.meta.name}.toml`, renderCodexAgent(r));
  }
  const def = resolveModules("default", loaded.modules);
  const allIds = resolveModules("all", loaded.modules);
  for (const [platform, file] of [["claude", "CLAUDE.block.md"], ["codex", "AGENTS.block.md"]]) {
    out.set(`${PLUGIN}/policy/${file}`, renderBlock(platform, def, version, loaded));
    const size = Buffer.byteLength(renderBlock(platform, allIds, version, loaded));
    if (size > BLOCK_LIMIT) throw new Error(`${platform} block with all modules is ${size} bytes, limit ${BLOCK_LIMIT}`);
  }
  out.set(".claude-plugin/marketplace.json", json({
    name: "human-agent-process",
    owner: author,
    plugins: [{ name: "human-agent-process", source: "./plugins/human-agent-process", description: DESCRIPTION, version }],
  }));
  out.set(".agents/plugins/marketplace.json", json({
    name: "human-agent-process",
    interface: { displayName: "Human-Agent Process" },
    plugins: [{ name: "human-agent-process", version, source: { source: "local", path: "./plugins/human-agent-process" },
      policy: { installation: "AVAILABLE", authentication: "ON_INSTALL" }, category: "Productivity" }],
  }));
  return out;
}

const GENERATED_DIRS = [`${PLUGIN}/agents`, `${PLUGIN}/codex/agents`, `${PLUGIN}/policy`];

export function check(root = ROOT) {
  const out = generate(root);
  const problems = [];
  for (const [rel, content] of out) {
    const p = path.join(root, rel);
    if (!fs.existsSync(p)) problems.push(`missing: ${rel}`);
    else if (fs.readFileSync(p, "utf8") !== content) problems.push(`differs: ${rel}`);
  }
  for (const d of GENERATED_DIRS) {
    const dp = path.join(root, d);
    if (!fs.existsSync(dp)) continue;
    for (const f of fs.readdirSync(dp)) if (!out.has(`${d}/${f}`)) problems.push(`stale: ${d}/${f}`);
  }
  return problems;
}

export function write(root = ROOT) {
  const out = generate(root);
  for (const d of GENERATED_DIRS) {
    const dp = path.join(root, d);
    if (!fs.existsSync(dp)) continue;
    for (const f of fs.readdirSync(dp)) if (!out.has(`${d}/${f}`)) fs.rmSync(path.join(dp, f));
  }
  for (const [rel, content] of out) {
    const p = path.join(root, rel);
    fs.mkdirSync(path.dirname(p), { recursive: true });
    fs.writeFileSync(p, content);
  }
  return out.size;
}

if (process.argv[1] && fs.realpathSync(path.resolve(process.argv[1])) === fs.realpathSync(fileURLToPath(import.meta.url))) {
  const args = process.argv.slice(2);
  try {
    if (args[0] === "--check") {
      const problems = check();
      if (problems.length) { console.error("generated files out of date:\n" + problems.join("\n")); process.exit(1); }
      console.log("build --check: clean");
    } else if (args[0] === "--block") {
      const platform = args[1];
      const mi = args.indexOf("--modules");
      const spec = mi >= 0 ? args[mi + 1] : "default";
      const version = JSON.parse(fs.readFileSync(path.join(ROOT, "package.json"), "utf8")).version;
      const loaded = loadCore();
      process.stdout.write(renderBlock(platform, resolveModules(spec, loaded.modules), version, loaded));
    } else {
      console.log(`build: wrote ${write()} files`);
    }
  } catch (e) { console.error(e.message); process.exit(1); }
}
