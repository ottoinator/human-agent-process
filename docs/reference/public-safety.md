# Public Safety

This repository is public, so it follows the published-copy rule of principle 5
(`../process/principles.md`): abstract operational detail out, keep the
specific version private.

## Do not publish

- Secrets, tokens, credentials, cookies, private keys, `.env` files.
- Private logs, transcripts, screenshots, traces, raw support data.
- Local machine paths, hostnames, internal service names.
- Customer, employee, or personal data, and named real parties in examples.
- Operational runbooks that reveal private infrastructure.
- Organisation-specific product names, page IDs, channel names.

## Safe pattern

Convert private workflow knowledge into abstract principles, sanitised or
fictional examples, placeholder-based templates (`<like-this>`), public-safe
skill contracts, and evidence labels instead of private proof dumps. Where a
lesson came from a real incident, keep the lesson and drop the identifying
detail.

## Review checklist

- Are examples fictional or sanitised?
- Are all links intended to be public?
- Does any path reveal a private machine or network?
- Does any text imply validation that has not happened?
- Does any agent instruction grant broad permissions without approval rules?
- Would the private version of a skill still work? (If yes, you may have
  published something that should have stayed specific — check.)
