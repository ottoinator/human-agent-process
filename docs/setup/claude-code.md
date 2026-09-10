# Setup: Claude Code

The `claude/` directory mirrors `~/.claude`. Installing it takes one command
and gives every Claude Code session the process, the skills, and the memory
rules.

## 1. Install the layer

```bash
git clone https://github.com/ottoinator/human-agent-process.git
cd human-agent-process
./scripts/install.sh
```

The script symlinks the four process skills in `claude/skills/` into
`~/.claude/skills/`, copies the Stop hook to `~/.claude/hooks/`, and installs
`claude/CLAUDE.md` as `~/.claude/CLAUDE.md` if you have none — otherwise it
leaves yours alone and tells you what to merge. It never overwrites an existing
file. Symlinks mean a `git pull` updates the skills in place.

The process needs a **memory adapter** (`../reference/memory-layer.md`). The
`--memory` flag picks it:

- `--memory lightrag` (default) — also links the `lightrag-local` skill and
  pastes `claude/memory/lightrag.md` into the *Installed adapter* block of the
  global `CLAUDE.md`.
- `--memory none` — process only. Every Tier 2/3 report will say prior-art
  search and capture could not run, which is the honest state until you
  append your own adapter's block between the `memory-adapter` markers.
- `--memory <file>` — paste that file as the adapter block instead (for an
  adapter that lives outside this repository).

An explicit `--memory` also works on an existing `~/.claude/CLAUDE.md` that
carries the `memory-adapter` markers: only the marked block is replaced, the
rest of the file is left alone.

Then register the hook: merge `claude/settings.example.json` into
`~/.claude/settings.json` (the `hooks.Stop` entry). Hooks are a settings-level
concept, so the script does not edit that file for you.

## 2. Start the memory service (for the LightRAG adapter)

Follow [`../../memory/README.md`](../../memory/README.md). Without a running
service the skills still work; every report will say that prior-art search and
capture could not run, which is the honest state.

## 3. Verify

Open Claude Code anywhere and ask:

```text
Which process skills are available, and what tier is "add a dark-mode toggle
to the settings page"?
```

You should see the four process skills plus your memory adapter named, a Tier 2
classification, and the gates it would run, including the critic gate and
whether it is mandatory or advisory for that repository.

## 4. Per project

Copy [`../../templates/claude/CLAUDE.project.md`](../../templates/claude/CLAUDE.project.md)
into the project root as `CLAUDE.md` and fill the placeholders: what the
project is, its QA command, its branching convention, the blast-radius rules
that make the critic gate mandatory *here*, and where published artefacts live.
Keep it a navigation file that links out; do not paste process text into it —
the global file already carries that.

For a shared team repository, add the team's own lane rules (which paths need
a PR, which autosave) and the rule that all tooling changes get a critic pass
in addition to the PR review. Write that rule in the repo; do not rely on the
global file knowing your repo's name.

## 5. Keep a naming glossary

The most frequent high-cost error in knowledge work is a wrong product,
feature, or customer name. Keep the exact names in your Claude Code
auto-memory (the `MEMORY.md` the harness maintains per project) or in the
project `CLAUDE.md`, and let the QA gate check against it.

## Uninstall

```bash
./scripts/install.sh --uninstall
```

Removes the symlinks and the hook. Leaves `~/.claude/CLAUDE.md` and
`settings.json` for you to edit.
