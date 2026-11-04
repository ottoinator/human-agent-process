import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { ROOT, PLUGIN, tempCopy, runStatus, node } from "./helpers.mjs";
import { BLOCK_LIMIT, loadCore, renderBlock, resolveModules } from "../scripts/build.mjs";

const pkg = JSON.parse(fs.readFileSync(path.join(ROOT, "package.json"), "utf8"));

test("build --check is clean (no drift)", () => {
  assert.equal(runStatus(["scripts/build.mjs", "--check"], { cwd: ROOT }), 0);
});

test("hand-edited generated file is detected", () => {
  for (const f of ["plugins/human-agent-process/agents/critic.md", "plugins/human-agent-process/codex/agents/critic.toml", "plugins/human-agent-process/policy/CLAUDE.block.md"]) {
    const dir = tempCopy();
    fs.appendFileSync(path.join(dir, f), "\nhand edit\n");
    assert.equal(runStatus(["scripts/build.mjs", "--check"], { cwd: dir }), 1, f);
  }
});

test("stale file in a generated directory is detected", () => {
  const dir = tempCopy();
  fs.writeFileSync(path.join(dir, "plugins/human-agent-process/agents/ghost.md"), "x");
  assert.equal(runStatus(["scripts/build.mjs", "--check"], { cwd: dir }), 1);
});

test("manifests and marketplaces carry the package version", () => {
  const v = pkg.version;
  const read = (p) => JSON.parse(fs.readFileSync(path.join(ROOT, p), "utf8"));
  assert.equal(read("plugins/human-agent-process/.claude-plugin/plugin.json").version, v);
  assert.equal(read("plugins/human-agent-process/.codex-plugin/plugin.json").version, v);
  assert.equal(read(".claude-plugin/marketplace.json").plugins[0].version, v);
  assert.equal(read(".agents/plugins/marketplace.json").plugins[0].version, v);
  assert.equal(read("plugins/human-agent-process/.codex-plugin/plugin.json").skills, "./skills/");
});

test("fixture: a manifest with a different version is detected", () => {
  const dir = tempCopy();
  const p = path.join(dir, "plugins/human-agent-process/.codex-plugin/plugin.json");
  fs.writeFileSync(p, fs.readFileSync(p, "utf8").replace(pkg.version, "9.9.9"));
  assert.equal(runStatus(["scripts/build.mjs", "--check"], { cwd: dir }), 1);
});

test("claude agents: model, tools, header", () => {
  const critic = fs.readFileSync(path.join(PLUGIN, "agents/critic.md"), "utf8");
  assert.match(critic, /^model: opus$/m);
  assert.match(critic, /^disallowedTools: Edit, Write, NotebookEdit$/m);
  assert.match(critic, /GENERATED from core\/roles\/critic\.md — edit the source/);
  const impl = fs.readFileSync(path.join(PLUGIN, "agents/implementer.md"), "utf8");
  assert.match(impl, /^model: sonnet$/m);
  assert.doesNotMatch(impl, /disallowedTools/);
  const res = fs.readFileSync(path.join(PLUGIN, "agents/researcher.md"), "utf8");
  assert.match(res, /^tools: WebSearch, WebFetch, Read, Grep, Glob$/m);
});

test("codex agents: inherited sandbox, access note, no model key, turn budget", () => {
  const t = fs.readFileSync(path.join(PLUGIN, "codex/agents/implementer.toml"), "utf8");
  // Codex custom agents inherit the parent session's sandbox; a per-agent key would be misleading.
  assert.doesNotMatch(t, /^sandbox_mode\s*=/m);
  assert.match(t, /Codex access note: Write only inside the scope named in the brief\./);
  assert.doesNotMatch(t, /^model\s*=/m);
  assert.match(t, /Turn budget: stop after about 60 turns with a checkpoint report; Codex does not enforce this\./);
  const r = fs.readFileSync(path.join(PLUGIN, "codex/agents/researcher.toml"), "utf8");
  assert.doesNotMatch(r, /^sandbox_mode\s*=/m);
  assert.match(r, /^\[features\]\nshell_tool = false$/m);
});

test("policy block with all modules stays within the limit", () => {
  const loaded = loadCore();
  const ids = resolveModules("all", loaded.modules);
  for (const platform of ["claude", "codex"]) {
    const b = renderBlock(platform, ids, pkg.version, loaded);
    assert.ok(Buffer.byteLength(b) <= BLOCK_LIMIT, `${platform} block ${Buffer.byteLength(b)} bytes`);
    assert.match(b, /^<!-- human-agent-process:begin v2\.0\.0 modules=.+ -->\n/);
    assert.ok(b.endsWith("<!-- human-agent-process:end -->\n"));
  }
});

test("fixture: oversized module makes the build fail", () => {
  const dir = tempCopy();
  const f = path.join(dir, "core/policy/modules/growth.md");
  fs.appendFileSync(f, "\n" + "filler words to exceed the limit. ".repeat(300));
  let status = 0;
  try { node(["scripts/build.mjs"], { cwd: dir }); } catch (e) { status = e.status; }
  assert.equal(status, 1);
});
