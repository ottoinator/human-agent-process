# Module: remote review

**Default: off.**

Switch it on when the owner reviews results on a phone or another device.
Every visible or browsable result ends with a link reachable from the owner's
device (private network or HTTPS), checked for a successful response.
Localhost and file paths only ever appear in addition. If no route exists,
report `Review link blocked: <reason>` with the next step.

**Cost:** a reachable route per reviewable result. Leave it off when the owner
works at the same machine.

Rule text: `core/policy/modules/remote-review.md`.
