// docs/process/*.md and the software-dev-process skill references must stay identical.
import fs from "node:fs";
let failed = false;
for (const f of fs.readdirSync("docs/process")) {
  const a = `docs/process/${f}`, b = `claude/skills/software-dev-process/references/${f}`;
  if (!fs.existsSync(b)) continue;
  if (fs.readFileSync(a, "utf8") !== fs.readFileSync(b, "utf8")) { console.error(`paired files differ: ${a} vs ${b}`); failed = true; }
}
if (failed) process.exit(1);
