---
name: bootstrap-shared-server
description: "Explicit-only ($bootstrap-shared-server). Use when running from a local Codex App/CLI or local Cursor controller to audit, bootstrap, repair, or verify Wu Junsong's personal development environment on an already SSH-accessible shared Linux cluster with an existing personal directory: personal shell, network/proxy selection, private Git, codex-wjs identity isolation, optional Codex App SSH routing, and rollback-safe validation. Not implicit."
---

# Bootstrap Shared Server

**Invoke:** `$bootstrap-shared-server` only.

Prepare a shared Linux account for personal development without changing
defaults seen by other people.

## Preconditions

Full bootstrap must start from the local controller:

- local Codex App;
- local Codex CLI;
- a local Cursor window, not a Cursor Remote SSH window.

Stop full mode when `$SSH_CONNECTION` or `$SSH_TTY` indicates that the agent is
already running on the target. A remote session may perform an explicitly
requested server-only repair, but it cannot modify local SSH configuration,
manage a proxy laptop, inspect local Codex App logs, or claim end-to-end
success.

The base SSH alias must already connect, and the user-approved personal
persistent directory must already exist. This skill does not create Linux
users, alter SSH daemon policy, or establish the cluster's base access.

Read [operating-contract.md](./references/operating-contract.md) before any
live change.

## Modes

| Mode | Scope |
| --- | --- |
| `full` | Audit and prepare all requested modules |
| `audit` | Read-only host, storage, shell, network, Git, and Codex inventory |
| `shell` | Personal rc, PATH, helpers, and profile selection |
| `network` | Direct/proxy classification and optional reverse tunnel |
| `git` | Per-repository private Git identity and authentication |
| `codex` | `codex-wjs`, private `CODEX_HOME`, and allowlist |
| `codex-app` | Dedicated SSH key, forced dispatcher, and managed app-server |
| `verify` | Acceptance matrix without configuration changes |
| `repair` | One named module only; preserve all unrelated state |

When the user does not name a mode, use `full`, but enable only modules that
the audit proves necessary.

## Contract

- Bare `codex` retains the server's shared/global meaning.
- `codex-wjs` is the explicit personal Codex CLI.
- Git identity, proxy, and credential helpers are repository-local.
- Personal shell and proxy exports never enter shared rc files.
- A `*_wjs` alias selects a WJS route; it does not create another Linux user.
- Shared persistent storage uses a distinct profile and `CODEX_HOME` per host.
- A reverse proxy is optional and host-specific, never a copied default.
- Same-UID separation prevents accidental cross-use; it is not a security
  boundary.

## Workflow

### 1. Confirm the controller

Record the local hostname, OS, current application context, and whether the
process is already inside SSH. Resolve the base alias with `ssh -G`.

If running in a remote Cursor/Codex thread, stop full mode and tell the user to
invoke this skill from a local session.

### 2. Audit without writing

Follow [audit-and-profile.md](./references/audit-and-profile.md). Determine:

1. Base alias, host, port, shared Linux user, shell, and authentication.
2. Personal persistent root and canonical workspace allowlist.
3. Whether multiple hosts share that root.
4. Existing shared shell, Git, proxy, and global Codex behavior.
5. Direct OpenAI and GitHub connectivity on every host.
6. Whether Codex App support is required.
7. Whether an always-on proxy machine is available and actually stays awake.

Do not read or print credentials, complete auth files, cookies, private keys,
or token-bearing URLs.

### 3. Create a non-secret profile

Assign one stable profile per host. Record only non-secret facts using the
schema in [audit-and-profile.md](./references/audit-and-profile.md). Never
reuse a hostname, path, proxy URL, or port from another cluster without
rediscovery.

### 4. Present the plan

Before live changes, show:

- selected modules and why each is needed;
- exact local, target, and optional proxy-host files;
- profile, workspace, and proxy mappings;
- global/shared files that will remain untouched;
- timestamped backup and rollback strategy;
- actions that require the user to log in or enter a credential.

Wait for approval of this audited plan.

### 5. Render and review candidates

Use the renderer as a starting point:

```bash
python3 scripts/render_profile.py \
  --output-dir /tmp/<profile>-bootstrap \
  --profile <profile> \
  --host-alias <base-alias> \
  --hostname <ssh-host> \
  --remote-hostname <remote-hostname> \
  --port <port> \
  --user <shared-user> \
  --personal-root <personal-root> \
  --allowed-root <workspace-root>
```

Add proxy, reverse-tunnel, or Codex App flags only after their modules are
selected. The renderer writes candidates only; it never connects or installs.
Review every generated path and command.

### 6. Apply modules in dependency order

1. [personal-shell.md](./references/personal-shell.md)
2. [network-and-proxy.md](./references/network-and-proxy.md)
3. [private-git.md](./references/private-git.md)
4. [codex-isolation.md](./references/codex-isolation.md)
5. [codex-app-ssh.md](./references/codex-app-ssh.md)

Skip unneeded modules. Back up before replacing any personal file. For shared
files such as `authorized_keys`, append only the reviewed entry and preserve
all existing lines.

### 7. Hand credentials to the user

The user performs ChatGPT/Codex login and GitHub PAT entry interactively.
Never ask the user to paste a token into chat. Never place a secret in a
command argument, generated candidate, deployment profile, shell history,
service unit, or repository.

### 8. Verify and report

Run [verification-and-rollback.md](./references/verification-and-rollback.md).
Do not report success until all requested local, server, proxy, Git, Codex CLI,
and Codex App paths pass with new timestamps.

The final report lists changes, skipped modules, services, non-secret profile
mappings, user-completed login state, backups, and exact rollback commands.

## Approval Gates

Require explicit approval immediately before:

- editing local `~/.ssh/config`;
- generating or installing a dedicated SSH key;
- appending to remote `authorized_keys`;
- enabling a user systemd/autossh service or linger;
- installing managed Codex;
- replacing an existing personal launcher or rc file;
- removing legacy bootstrap artifacts.

## Hard Rules

- Never modify shared `~/.bashrc`, `~/.profile`, `/etc/profile`, global Git
  config, SSH daemon config, firewall rules, or global systemd units.
- Never replace, wrap, alias, or redefine shared bare `codex`.
- Never put personal `codex` in `/usr/local/bin` or shared `~/.local/bin`.
- Never configure Git identity, credential helper, or proxy with `--global`.
- Never enable a proxy for every shell automatically.
- Never bind a reverse proxy to `0.0.0.0`.
- Never delete or rewrite existing `authorized_keys` entries.
- Never install a laptop tunnel merely because a previous Baidu host needed
  one.
- Never claim that same-UID files or loopback ports are private from another
  person using the same UID.
- Never make live changes before audit, plan review, and approval.
