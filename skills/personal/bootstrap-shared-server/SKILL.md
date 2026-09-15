---
name: bootstrap-shared-server
description: "Use when explicitly preparing, auditing, or repairing Wu Junsong’s personal environment on an SSH-accessible shared Linux cluster."
disable-model-invocation: true
---

# Bootstrap Shared Server

Prepare the requested personal development environment while preserving shared
shell, Git, and bare `codex` behavior. Full bootstrap runs from the local
controller with an existing working SSH alias and personal persistent root.
A server-side session may perform a requested server-only repair, but cannot
claim local SSH or end-to-end verification.

Read [operating-contract.md](references/operating-contract.md) for ownership,
authorization, idempotency, and the limits of same-UID isolation before live
changes. Use [audit-and-profile.md](references/audit-and-profile.md) to discover
host-specific paths and create a non-secret profile. Never copy another host's
proxy, port, or storage assumptions.

## Select only the needed modules

| Request | Reference |
| --- | --- |
| `audit` | [Audit and profile](references/audit-and-profile.md); read-only |
| `shell` | [Personal shell](references/personal-shell.md) |
| `network` | [Connectivity and optional proxy](references/network-and-proxy.md) |
| `git` | [Repository-local private Git](references/private-git.md) |
| `codex` | [Personal launcher and state](references/codex-isolation.md) |
| `codex-app` | [SSH dispatcher and app-server](references/codex-app-ssh.md) |
| `verify` | [Acceptance and rollback](references/verification-and-rollback.md) |
| `repair` | The named module only |
| `full` | Audit, then only modules needed for the requested environment |

When no mode is named, infer the scope from the request; a single broken module
does not imply full bootstrap. Apply selected dependencies in shell, network,
Git, Codex CLI, then optional Codex App order where needed.

## Prepare, apply, verify

Render candidates outside live paths with [scripts/render_profile.py](scripts/render_profile.py).
Resolve its path from this skill directory; use `--help` for its current options.
Review the actual files and mappings, backup/rollback plan, and required user
login steps before requesting any missing authorization. Existing explicit
approval of those changes remains valid; ask again only for changed scope or
new consequential actions.

Back up changed personal files and preserve existing shared entries. Personal
launchers, state, Git identity, and proxy settings stay scoped to the agreed
host/profile/workspace. Keep reverse proxies on loopback. Same-UID separation
prevents accidental cross-use, not access by another person sharing that UID.

Credential entry belongs to the user, through a proven secret-entry control
or their own uncaptured terminal. Ordinary chat/question dialogs are not safe
credential entry. Never read auth files or place secrets in generated profiles,
command arguments, service units, or logs.

Verify the selected modules and unchanged shared defaults using
[verification-and-rollback.md](references/verification-and-rollback.md).
Report completed changes, skipped/unverified modules, non-secret mappings,
backups, and rollback commands. Do not claim full success from partial checks.
