// Codex outputs: standalone custom-agent TOML files.

export function renderCodexAgent(role) {
  const access = {
    "read-only": "Do not edit files. This is a behavioral boundary: Codex custom agents inherit the parent session's sandbox and approval settings.",
    "web-read-only": "Do not edit files or run shell commands. This is a behavioral boundary: Codex custom agents inherit the parent session's sandbox and approval settings.",
    write: "Write only inside the scope named in the brief. Codex custom agents inherit the parent session's sandbox and approval settings.",
  }[role.meta.access];
  if (!access) throw new Error(`role ${role.meta.name}: bad access`);
  const instr =
    `${role.body.trim()}\n\nCodex access note: ${access}\n\nTurn budget: stop after about ${role.meta.max_turns} turns with a checkpoint report; Codex does not enforce this.\n`;
  if (instr.includes("'''")) throw new Error(`role ${role.meta.name}: body contains ''' (cannot use TOML literal string)`);
  const lines = [
    `# GENERATED from core/roles/${role.meta.name}.md — edit the source`,
    `name = ${JSON.stringify(role.meta.name)}`,
    `description = ${JSON.stringify(role.meta.description)}`,
    `model_reasoning_effort = ${JSON.stringify(role.meta.effort)}`,
    `developer_instructions = '''`,
    `${instr}'''`,
  ];
  if (role.meta.access === "web-read-only") lines.push("", "[features]", "shell_tool = false");
  return [...lines, ""].join("\n");
}
