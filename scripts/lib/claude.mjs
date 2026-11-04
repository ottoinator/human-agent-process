// Claude Code outputs: subagent files.
const MODEL = { strong: "opus", standard: "sonnet" };
const TOOLS = {
  "read-only": { tools: "Read, Grep, Glob, Bash", deny: "Edit, Write, NotebookEdit" },
  write: { tools: "Read, Edit, Write, Bash, Grep, Glob", deny: null },
  "web-read-only": { tools: "WebSearch, WebFetch, Read, Grep, Glob", deny: "Edit, Write, NotebookEdit, Bash" },
};

export function renderClaudeAgent(role) {
  const t = TOOLS[role.meta.access];
  const model = MODEL[role.meta.model_class];
  if (!t || !model) throw new Error(`role ${role.meta.name}: bad access or model_class`);
  const fm = [
    "---",
    `name: ${role.meta.name}`,
    `description: ${role.meta.description}`,
    `model: ${model}`,
    `effort: ${role.meta.effort}`,
    `maxTurns: ${role.meta.max_turns}`,
    `tools: ${t.tools}`,
  ];
  if (t.deny) fm.push(`disallowedTools: ${t.deny}`);
  fm.push("---");
  return `${fm.join("\n")}\n<!-- GENERATED from core/roles/${role.meta.name}.md — edit the source -->\n\n${role.body.trim()}\n`;
}
