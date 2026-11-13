# Module: design reference

**Default: off.**

Switch it on for user-facing Tier 2/3 work. The work starts from a concrete
design reference (a generated or drawn screen, not only colours). Record its
source, translate its composition and visual assets, and after build compare
reference and runtime side by side on desktop and mobile. A result that looks
clearly more generic than its reference is `needs_visual_pass`, not done. No
hidden process badges in end-user interfaces.

**Cost:** a design reference before build and a visual review after. Leave it
off for back-end and tooling work.

**Tools.** The rule is tool-neutral: any concrete screen works, drawn or
generated. A good fit is [Google Stitch](https://stitch.withgoogle.com/),
which generates complete screens from a text brief and exports a screenshot
and HTML the agent can translate. If your agent tool can reach Stitch (for
example through an MCP server), the researcher or lead creates the screen
before build and records its project and screen IDs in the start-gate
record. The reference is a visual target, not production code to copy.

Rule text: `core/policy/modules/design-reference.md`.
