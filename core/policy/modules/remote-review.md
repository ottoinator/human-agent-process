---
id: remote-review
title: Remote review link
kind: module
default: on
---
## Module: remote review link

Every visible or browsable result ends with a link the owner can open on the device they review on, checked for a successful response. If you do not know that device, ask once at intake. When it is another device such as a phone, the link must be reachable from it (private network or HTTPS); localhost and file paths only ever appear in addition, and exposing anything to the public internet is an outbound action that needs the owner. If no route exists, report `Review link blocked: <reason>` with the next step.
