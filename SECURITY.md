# Security Policy

This repository is a public toolkit: rules, skills, templates, and an
installer. It operates no hosted service.

## Reporting

Please do not open public issues for vulnerabilities, secrets, or private
data. Use GitHub private vulnerability reporting (the "Report a vulnerability"
button on the repository's Security tab).

## What the installer touches

`scripts/install.sh` writes outside this repository: a managed block in your
global instruction files (`CLAUDE.md` and `AGENTS.md`) and role files in the
agents directories of Claude Code and Codex. It makes a backup before every
write, supports `--dry-run` to preview and `--uninstall` to remove what it
added, and never edits content outside its own markers. Read the dry run
before installing. Reports about the installer overwriting, leaking, or
widening permissions are in scope.

## Public safety rules

Do not contribute API keys, tokens, passwords, cookies, private keys, `.env`
files, private logs, transcripts, screenshots, customer data, internal
hostnames, or agent instructions that grant broad permissions without
approval boundaries.

## Supported surface

Repository content, CI configuration, and the installer.
