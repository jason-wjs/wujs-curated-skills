---
name: shared-server-codex-isolation
description: Explicit-only ($shared-server-codex-isolation). Use when setting up or repairing personal Codex isolation on a shared Linux/SSH server, especially codex-wjs, separate CODEX_HOME, allowlisted workspaces, personal shell rc, proxy-scoped launchers, Codex App command constraints, or preserving the global bare codex command for other users. Not implicit.
disable-model-invocation: true
---

# Shared-Server Codex Isolation

**Invoke:** `$shared-server-codex-isolation` only.

Set up Wu Junsong's personal Codex identity on a shared Linux account without
changing the shared default `codex` command.

Core policy:

- `codex` means the host's global/shared Codex, always.
- `codex-wjs` is the only personal entrypoint.
- `codex-wjs` sets the personal Codex home, cleans inherited endpoint/auth env,
  applies process-local proxy when configured, and refuses non-allowlisted
  workspaces.
- SSH aliases may expose a personal shell profile, but they must not make bare
  `codex` use WJS credentials.

This is not a Linux security boundary. It is command-level hygiene for shared
accounts: subscription, auth state, threads, skills, proxy, and workspace scope.

## Goals

1. **Preserve global Codex** — other users keep using `codex` exactly as the
   server provides it.
2. **Explicit personal entry** — daily use and login go through `codex-wjs`.
3. **Personal home** — auth, sessions, skills, and config live under a private,
   persistent user root, not global `~/.codex`.
4. **Clean process env** — launcher removes shell API keys/base URLs/org/project
   vars that could hijack the intended subscription.
5. **Workspace allowlist** — `codex-wjs` runs only under approved roots.
6. **Codex App honesty** — if Codex App cannot be configured to call
   `codex-wjs app-server`, do not fake separation by hijacking `codex`.

## Two Directories

- **Personal root**: stable private directory for `start_codex.sh`,
  `bin/codex-wjs`, `.codex-home`, and optional `.bashrc-wjs`.
- **Workspace roots**: repos/data directories where `codex-wjs` may run.

They may be the same tree, but do not put auth state inside a pushed repo.
See [references/placement-rules.md](./references/placement-rules.md).

## Workflow

### 1. Discover

Inspect this host before writing files:

```bash
command -v codex
type -a codex
codex --version
codex --help
```

Also discover the user's private persistent root, workspace allowlist, proxy
need, and whether the target is terminal-only or also Codex App.

Do not read or print auth tokens, API keys, cookies, or full auth files.

### 2. Generate candidates

Use the bundled renderer when starting from scratch:

```bash
python3 scripts/render_profile_templates.py \
  --output-dir /tmp/codex-wjs-candidate \
  --host-alias server \
  --hostname 10.0.0.1 \
  --user root \
  --personal-root /data_team/junsong \
  --allowed-root /data_team/junsong/projects \
  --codex-bin /usr/bin/codex \
  --proxy-url http://127.0.0.1:7897/
```

Review generated files before installing. The renderer writes only candidate
files; it does not connect to servers.

### 3. Install explicit-only layout

Install only these personal artifacts unless the user requests otherwise:

```text
PERSONAL_ROOT/
├── start_codex.sh
├── bin/codex-wjs          # wrapper or symlink to start_codex.sh
├── .codex-home/           # CODEX_HOME, mode 700; config/auth private
├── .bashrc-wjs            # optional personal interactive shell
├── .bashrc-wjs-extras.sh  # PATH and proxy helpers
└── .bashrc-wjs-autoload.sh
```

Keep `codex-wjs` on PATH via a personal rc file, terminal profile, or explicit
path. On shared accounts, prefer not to edit global `.bashrc`. If an SSH
`*_wjs` alias is useful, make it a terminal convenience that loads
`.bashrc-wjs`; it must not wrap or alias `codex`.

### 4. Login and daily use

```bash
cd <allowlisted-workspace>
codex-wjs login
codex-wjs login status
codex-wjs
codex-wjs resume
```

Bare `codex` remains the global/shared route.

### 5. Verify

Run checks that prove both sides of the split:

```bash
ssh <host> 'command -v codex; codex --version'
ssh <host_wjs> 'command -v codex; command -v codex-wjs'
ssh <host_wjs> 'cd /tmp; codex-wjs exec --help'
ssh <host_wjs> 'cd <allowed-root>; codex-wjs --version'
ssh <host_wjs> 'codex --version'
```

Expected results:

- `codex` resolves to the server's global/shared command and version.
- `codex-wjs` exists in the intended personal terminal/profile.
- `codex-wjs` refuses `/tmp` or other non-allowlisted paths.
- `codex-wjs` works from an allowlisted workspace.
- `codex --version` still works globally and does not depend on WJS state.

For Codex App, verify the exact command it starts. If it hardcodes `codex
app-server`, explicit-only isolation means it will use global Codex. Use WJS
isolation only when the app can invoke `codex-wjs app-server` or another
non-`codex` personal command.

## Hard Rules

Do not install any of these as part of explicit-only isolation:

- `/usr/local/bin/codex` wrapper for WJS
- `/root/.local/bin/codex` wrapper for WJS
- `alias codex=codex-wjs`
- shell function named `codex`
- SSH config that changes bare `codex` into WJS behavior

If a previous host used preserve-global routing wrappers, remove or bypass them
when switching to explicit-only mode, after backing up and confirming the true
global Codex path.

## References

- [references/placement-rules.md](./references/placement-rules.md)

## Trigger Tests

- Should trigger only when the user explicitly invokes
  `$shared-server-codex-isolation` or asks to configure/repair `codex-wjs`
  personal isolation on a shared server.
- Should not trigger for ordinary Codex usage, Cursor-only setup, single-user
  machines, or ambient mentions of Codex.
