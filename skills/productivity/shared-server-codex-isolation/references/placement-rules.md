# Placement Rules

Apply on the current host. Do not copy paths from another cluster without
revalidating the Codex binary, storage, proxy, and shell behavior.

## Principles

| Rule | Why |
| --- | --- |
| Bare `codex` stays global | Shared accounts need a predictable default for everyone |
| Personal entry is `codex-wjs` | The user opts into private auth/state explicitly |
| User-private persistent root | Auth and threads survive restarts and are not owned by someone else |
| Personal home is not a repo | Auth, sqlite state, and logs must never be pushed |
| Allowlist lives in launcher | Workspace scope is enforced before Codex starts |
| Proxy is process-local | Avoid changing other users' shell/network behavior |

## Recommended Layout

```text
USER_PRIVATE_ROOT/
├── start_codex.sh          # isolation logic
├── bin/codex-wjs           # wrapper or symlink -> start_codex.sh
├── .codex-home/            # personal Codex home, mode 700
├── .bashrc-wjs             # optional personal interactive shell
├── .bashrc-wjs-extras.sh   # PATH and proxyon/proxyoff helpers
└── .bashrc-wjs-autoload.sh # optional source-from-personal-rc helper

WORKSPACE_ROOT_1/           # allowlisted code/data
WORKSPACE_ROOT_2/
```

`USER_PRIVATE_ROOT` and workspace roots may be the same tree when the server
only provides one private directory. Otherwise, keep identity/state separate
from code and list workspaces in `start_codex.sh`.

## SSH Aliases

A `_wjs` SSH alias may be useful as a terminal convenience, but it should only
load the personal shell profile so `codex-wjs` is on PATH. It must not make
`codex` personal.

Terminal-only example:

```sshconfig
Host server_wjs
    HostName server.example
    User root
    IdentityFile ~/.ssh/id_ed25519
    RequestTTY yes
    RemoteCommand bash --rcfile /data_team/junsong/.bashrc-wjs -i
```

Do not use this alias for automation that needs arbitrary remote commands unless
you remove `RemoteCommand` for that workflow.

## Per Artifact

| Artifact | Where |
| --- | --- |
| Global `codex` | Existing server path; do not wrap for WJS |
| Personal Codex home | `USER_PRIVATE_ROOT/.codex-home`, restrictive permissions |
| Launcher | `USER_PRIVATE_ROOT/start_codex.sh` |
| Personal command | `USER_PRIVATE_ROOT/bin/codex-wjs` |
| Personal rc | `USER_PRIVATE_ROOT/.bashrc-wjs` |
| Proxy helpers | Personal rc and launcher process only |
| Project config | Workspace roots, only if current Codex supports it |

## Avoid

- `/usr/local/bin/codex` or `/root/.local/bin/codex` WJS wrappers
- `alias codex=codex-wjs` or shell functions named `codex`
- Editing shared `.bashrc` for everyone
- Ephemeral temp directories for personal Codex home
- Other users' trees
- Auth/state under a pushed git repository

## Checklist

Before creating files, confirm:

1. The true global `codex` path and version
2. User-private persistent root
3. Workspace roots for the allowlist
4. Whether proxy is required
5. Whether Codex App can invoke `codex-wjs app-server`; if not, keep App on
   global Codex under explicit-only policy
