# Module: remote review

**Default: on.** Switch it off with `--modules -remote-review`.

Every visible or browsable result ends with a link the owner can open on the
device they review on, checked for a successful response. If the agent does
not know that device, it asks once at intake. For a phone or another device
the link must be reachable from it (private network or HTTPS); localhost and
file paths only ever appear in addition. Exposing anything to the public
internet stays an owner decision. If no route exists,
report `Review link blocked: <reason>` with the next step.

**Cost:** a reachable route per reviewable result. When the owner
reviews at the same machine, a local link is enough.

Rule text: `core/policy/modules/remote-review.md`.
