# See it work

Two real runs, recorded on 2026-11-13. Same agent tool, same model, same
prompt, same empty folder, same permissions (read, write, run commands). The
only difference: one run had the Human-Agent Process plugin and rules block
loaded, the other had nothing. Output is shortened where marked
with `...`; nothing was rewritten. Local paths are replaced by `<folder>`.
Recorded with Claude Code, one run per setup, not repeated or selected; Codex
was not recorded for this page.

## Run 1: a new product from a one-line wish

Prompt:

```text
I want a small web app where neighbours can lend each other tools. Build it.
```

### With Human-Agent Process

The agent wrote no file. Its complete answer:

```text
hap_gate: tier=3 allow_build=false critic=required

This is a new product, so I need one round of clarification before I build
anything. Each question has my recommendation, and "go with your
recommendations" is a fine answer.

Questions

1. Who uses it? One street or building, or any neighbourhood?
   Recommendation: One community per installation. Accounts are invite-only,
   using a shared join code.

2. Sign-in: Email and password, magic link, or no accounts at all?
   Recommendation: Username and password with a shared join code. It needs no
   email service and keeps strangers out.

3. Core flow: What should it do in version 1?
   Recommendation: Four things:
   - Add a tool, with a photo, description and availability.
   - Browse and search tools.
   - Request a loan for dates, which the owner approves or declines.
   - Mark a tool as returned.
   I'd leave out ratings, payments, chat and notifications for now.

4. Tech stack and hosting: Where will it run?
   Recommendation: Python (Flask) with SQLite and server-rendered pages. It's
   a single small app with no build step. It would run locally first, and
   deployment would be a separate step you approve.

5. Language: English or German UI?
   Recommendation: English now, with strings kept in one place so German can
   be added later.

Plan once you answer
- First, the smallest end-to-end slice: join, add a tool, request it,
  approve it.
- Then a critic reviews the plan and, after the build, the result.
- Then tests with known-pass and known-fail cases, and I report back with a
  link to the running app.

Needed from you: your answers to 1-5, or "go with your recommendations".
```

### Without it

The agent started writing code straight away (one command wrote
`package.json`, `server.js`, and `public/index.html` and tested the API with
`curl`; two more fixed `package.json`) and finished with:

```text
I've built a small tool-lending app called Toolshare. It has no dependencies,
only Node, and saves its data to `data.json`. I tested the server with a few
API calls (login, adding a tool, a wrong PIN, serving the page). I haven't
opened the page in a browser, so the interface itself is untested, and I
haven't tried the borrow, approve or return steps.

To run it, use `cd <folder> && npm start` and open http://localhost:3000.
...
Limits
- The PIN is only a light check against someone else using your name. It
  isn't strong security, and there's no password reset.
- It has no HTTPS. ...
```

### What the difference means

The plain agent was honest about it, and that is the point: it chose the
users, the sign-in model, the stack, and the scope on its own, and the core
flow of the product (borrow, approve, return) was never tried. Nothing in the
setup asked it to stop and ask, or to prove the main path before saying
"built".

With the process, every one of those choices came back to the owner as one
bundled round of questions, each with a recommendation, so a single reply
("go with your recommendations") is enough. The plan already names how
"done" will be proven: the thinnest end-to-end slice, a critic before and
after the build, and tests with one case that must pass and one that must
fail.

## Run 2: a small change

Prompt, on a 25-line toy script that syncs calendar events into a task list:

```text
Add a --dry-run flag to sync.py so I can see what would change before it
writes anything.
```

With Human-Agent Process:

```text
hap_gate: tier=1 allow_build=true critic=not-required
...
Done: `sync.py --dry-run` now lists each task it would add and prints a
summary line, and it doesn't write `tasks.json`. I ran it against your data:
it reported `would add: e1 'Dentist'`, and `tasks.json` was still `[]`
afterwards. Running without the flag works as before, but I didn't run that,
because it would have modified your `tasks.json`.

Needed from you: Nothing.

Link: <folder>/sync.py
```

Without it, the agent made an equivalent change, ran an equivalent check (a
byte-for-byte compare of `tasks.json`), and reported it in prose. Both needed
two to three commands.

Here the process adds little, and that is intended: a small, reversible
change is Tier 1, which means a short gate record, one verification, and a
short report, with no research and no critic. To be exact about this run: the
agent kept the gate record to the `hap_gate:` line and checked only the
dry-run path, not the normal write path. The process should cost almost
nothing on trivial work and pay off where a wrong "done" is expensive.

## Try it yourself

Install the process ([quickstart](quickstart.md)), open an empty folder, and
give your agent a product wish in one sentence. Then try the same prompt in a
setup without it. If the result is less convincing for you than it is here,
please tell us in an
[adoption report](../../.github/ISSUE_TEMPLATE/workflow_improvement.yml).
