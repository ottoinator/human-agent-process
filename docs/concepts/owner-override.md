# Owner Override

A premise you set once and agents build on instead of reopening. Without it,
an agent re-evaluates "should we really do it this way?" in every session,
after every context compaction, and in every subagent.

## Use

Start a message with one of these forms (case does not matter):

| You write | Effect |
| --- | --- |
| `Owner Override: <premise>` | records the premise as `OO-<n>` |
| `Owner Override lift: OO-3` | lifts it |
| `Owner Override replace OO-3: <premise>` | lifts OO-3, records the new text as a new number |
| `Owner Override list` | the lead shows the active list |

The premise is the first paragraph of the message; the rest is an ordinary
task. The reply starts with a word-for-word acknowledgement such as
`Recorded: OO-1: ...`. If the message cannot be recorded (broken form, list
too long, register not writable) it is blocked with the reason, so you see it.

What a premise means for agents is the binding text the hook delivers with the
list: build on it, do not re-evaluate it, report measurements unchanged, one
note per premise at most and only for a concrete new risk (money, data,
security, legal), and a premise replaces no approval from the owner list.

## What is deterministic and what is not

- **Deterministic:** recording, lifting, numbering (never reused), the hash
  chain, delivery of the list at session start, in subagents, after
  compaction, and with the next prompt of a running session.
- **Not deterministic:** whether an agent keeps to a premise. The text is
  context, not a lock. A hook cannot stop an agent from ignoring it.
- Only the owner's own message writes. Text that comes from a file, a tool, a
  subagent, a pasted block, a quotation, or merely mentions the keyword
  records nothing. Unattended runs (`claude -p`, `codex exec`) record
  nothing. The command line has no way to set or lift.

## Where it lives

One script, `plugins/human-agent-process/hooks/owner_override.py`, for both
platforms, and one register shared by them:
`~/.human-agent-process/owner-overrides/ledger.jsonl` (override with
`OWNER_OVERRIDE_DIR`). Append-only, one hash-chained line per set or lift
(about 500 bytes), plus a derived `active.md`. Check with
`python3 owner_override.py list | context | check | selftest`.

## Claude Code and Codex

| | Claude Code | Codex |
| --- | --- | --- |
| Hook install | comes with the plugin (`hooks/hooks.json`) | installer copies the script and merges three entries into `~/.codex/hooks.json`; other entries stay, uninstall removes only ours |
| Events | session start, prompt, subagent start | session start, prompt, subagent start |
| Needs your action | no | **yes: run `/hooks` in Codex and approve the three `hap-owner-override` hooks.** Until then Codex runs no hook and Owner Override is silent. The installer says so; it never approves for you |
| Fallback | policy block rule | policy block rule |

The always-on policy block in both `CLAUDE.md` and `AGENTS.md` carries a short
rule, so a premise you state is respected even where the hook is not active;
only the register and the delivery need the hook. Skip the hook with
`scripts/install.sh --no-owner-override`.

Both platforms deliver the same way: at session start, at subagent start, and with the next prompt of a running session. A change reaches a running session only at its next prompt, not in the middle of a tool call.
