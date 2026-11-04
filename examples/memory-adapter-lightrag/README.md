# Example memory adapter: LightRAG

A worked example of the memory adapter contract
([contract](../../docs/reference/memory-layer.md)). It is not installed by
default and not part of the plugin.

- [`service/`](service/README.md) - a local LightRAG container, a backup
  script, and a scheduler template.
- [`skill/`](skill/SKILL.md) - the client skill that talks to the service.
- [`adapter-block.md`](adapter-block.md) - the instruction block that tells
  the agent which adapter is installed and how to capture.

Copy the skill into your agent's skills directory and paste the block into
your global instruction file if you want to use it. For a different store,
write your own block and skill that meet the same contract.
