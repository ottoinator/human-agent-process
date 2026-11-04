import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import os from "node:os";
import { execFileSync } from "node:child_process";
import { ROOT, tempCopy, markdownFiles, walk, rel, runStatus } from "./helpers.mjs";
import { scanTree, scanText, loadTerms } from "../scripts/leak-scan.mjs";

// Built from pieces so this file does not trip its own scan.
const SECRETS = [
  ["github token", new RegExp("gh[pousr]_" + "[A-Za-z0-9]{30,}")],
  ["api key", new RegExp("sk-" + "[A-Za-z0-9_-]{24,}")],
  ["aws key", new RegExp("AKIA" + "[0-9A-Z]{16}")],
  ["slack token", new RegExp("xox[abprs]-" + "[A-Za-z0-9-]{10,}")],
  ["private key", new RegExp("-----BEGIN [A-Z ]*PRIVATE" + " KEY-----")],
  ["bearer", new RegExp("Bearer " + "[A-Za-z0-9._-]{30,}")],
];
const textFiles = () => walk(ROOT, (p) => /\.(md|mjs|sh|json|toml|ya?ml|txt)$/.test(p));

test("no secret patterns in the working tree", () => {
  const hits = [];
  for (const f of textFiles()) {
    const text = fs.readFileSync(f, "utf8");
    for (const [name, re] of SECRETS) if (re.test(text)) hits.push(`${rel(f)}: ${name}`);
  }
  assert.deepEqual(hits, []);
});

test("secret patterns detect planted values", () => {
  assert.ok(SECRETS[0][1].test("ghp_" + "a".repeat(36)));
  assert.ok(SECRETS[4][1].test("-----BEGIN RSA PRIVATE" + " KEY-----"));
});

test("leak scan: working tree is clean", () => {
  const terms = loadTerms();
  assert.deepEqual(scanTree(ROOT, terms), []);
});

test("leak scan: generic patterns", () => {
  const bad = ["/Users/" + "alice/x", "/home/" + "bob/x", "host.ts" + ".net", "~/" + "ops/x", "com.acme." + "routine.x"];
  for (const b of bad) assert.ok(scanText("f", b, []).length, b);
  assert.equal(scanText("f", "/home/" + "user/x", []).length, 0);
});

test("leak scan: planted private term in a temp copy is detected", () => {
  const dir = tempCopy();
  const termFile = path.join(dir, "terms.txt");
  fs.writeFileSync(termFile, "# comment\nZebraSecretTerm\n");
  fs.writeFileSync(path.join(dir, "planted.md"), "mentions zebrasecretterm here\n");
  const hits = scanTree(dir, loadTerms(termFile));
  assert.ok(hits.some((h) => h.startsWith("planted.md")));
  const env = { ...process.env, HAP_PRIVATE_TERMS: termFile };
  assert.equal(runStatus(["scripts/leak-scan.mjs", "--root", dir], { cwd: dir, env }), 1);
});

test("leak scan: --history finds a term only present in history", () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), "hap-hist-"));
  const git = (...a) => execFileSync("git", ["-c", "user.email=t@example.com", "-c", "user.name=t", ...a], { cwd: dir, stdio: "pipe" });
  git("init", "-q");
  fs.writeFileSync(path.join(dir, "a.txt"), "hidden-history-term\n");
  git("add", "."); git("commit", "-q", "-m", "add");
  fs.writeFileSync(path.join(dir, "a.txt"), "clean\n");
  git("commit", "-qam", "clean");
  const termFile = path.join(dir, "..", `terms-${path.basename(dir)}.txt`);
  fs.writeFileSync(termFile, "hidden-history-term\n");
  const env = { ...process.env, HAP_PRIVATE_TERMS: termFile };
  const script = path.join(ROOT, "scripts/leak-scan.mjs");
  assert.equal(runStatus([script, "--root", dir], { env }), 0);
  assert.equal(runStatus([script, "--root", dir, "--history"], { env }), 1);
});
