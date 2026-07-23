# Verification and Rollback

Verify only selected modules, but always prove that shared defaults remain
unchanged.

## Acceptance matrix

| Surface | Expected |
| --- | --- |
| Base SSH alias | Connects as before |
| Shared shell files | No unapproved diff |
| WJS alias | Opens personal shell/profile |
| Bare `codex` | Same shared/global resolution |
| `codex-wjs` | Personal profile and managed binary |
| Wrong host/profile | Fails closed |
| Allowed workspace | Starts successfully |
| Disallowed workspace | Refuses |
| Git identity | Repository-local WJS values |
| Git credentials | Interactive/cache only; no stored token |
| GitHub route | Matches network classification |
| OpenAI route | Matches network classification |
| Reverse listener | Loopback-only; absent when service stops |
| Codex login | User-confirmed personal login |
| App daemon | Profile-private bootstrap/start/version succeeds |
| Codex App | New log attempt reaches connected state |

For shared storage, connect to every host simultaneously and confirm distinct
`CODEX_HOME`, package path, daemon process, socket, and proxy mapping.

## Negative tests

- Run `codex-wjs` from `/tmp`.
- Supply an unknown profile.
- Attempt a known profile on the wrong stable hostname.
- Stop the optional tunnel and verify a clear failure.
- Confirm the App-only `codex` wrapper is absent from ordinary PATH.
- Confirm Git config outside a prepared repo is unchanged.
- Confirm no listener binds `0.0.0.0`.

## Codex App logs

Use a newly triggered connection and current timestamps. Expected stages:

```text
codex_path_probe
codex_version_probe
app_server_bootstrap
proxy_command_starting
connected
```

Do not diagnose from an old cached error after the server was changed.

## Rollback

Before changes, record:

- timestamped personal-file backups;
- local SSH config backup or exact inserted block;
- remote `authorized_keys` checksum and exact appended public-key line;
- proxy user-unit name and prior enabled/active state;
- created profile directories;
- repository-local Git values before modification.

Rollback removes only artifacts created by this deployment:

1. Disable the new proxy user unit, then remove that unit.
2. Remove the exact dedicated public-key line, preserving all others.
3. Remove the exact local WJS SSH block/key created for this profile.
4. Restore replaced personal files from timestamped backups.
5. Restore previous repository-local Git values.
6. Remove new profile directories only after confirming they contain no needed
   sessions, code, or credentials.

Never use broad deletion, `git reset --hard`, or wholesale replacement of
shared files.

## Final report

Include:

- local controller and target aliases;
- non-secret profile mapping;
- modules applied and skipped;
- all changed files and services;
- proxy decision per destination;
- login steps completed by the user;
- positive and negative verification results;
- backup paths and rollback commands;
- residual limitation that same-UID users are not security-isolated.

