# Done on a happy path

**What happened.** An agent built a data pipeline, ran it once on a prepared
sample, saw a clean result, and reported "done". The sample was hand-picked.
On the real data path the input was empty, so every downstream view showed
zero and nothing complained. The owner found out days later.

**Why it slipped through.** Completion rested on the agent's confidence and a
single green run. No check could fail, so a green result carried no
information.

**The rule.** Acceptance is a runnable check with known answers: one case that
must pass and one that must fail, run over the real input path. Done is
reported only after the lead has seen the check green, and what is reported is
the number of valid results, not the number of runs. See
[critic and evidence](../concepts/critic-and-evidence.md).
