# Placement Rules

Apply on the **current** cluster. Do not copy paths from elsewhere.

## Principles

| Rule | Why |
|------|-----|
| User-private directory | Not `/root`, `/tmp`, shared homes, or other users' trees |
| Persistent storage | Auth and sessions must survive restarts |
| Personal home ≠ workspace | Identity directory can sit outside code/data trees |
| Secrets outside git | Personal home must not live in a pushed repository |
| Stable launcher path | Same entry command from any allowed project |

## Recommended Pattern

Separate **config hub** from **workspaces**:

```text
USER_PRIVATE_ROOT/          # persistent, user-owned
├── launcher script
└── personal Codex home/    # fixed identity store

WORKSPACE_ROOT_1/           # allowlisted code
WORKSPACE_ROOT_2/           # allowlisted data (optional)
```

Personal home and launcher usually live under `USER_PRIVATE_ROOT`. Workspace
roots are listed in the launcher's allowlist only — they need not contain the
launcher.

Single-tree layout (everything under one user root) is fine when the cluster
gives the user only one private tree.

## Per Artifact

| Artifact | Where |
|----------|--------|
| Personal Codex home | User private root; restrictive permissions |
| Launcher | User private root or `~/bin/`; stable path |
| Proxy config | Beside launcher; sourced at launch only, not `.bashrc` |
| Project config | At workspace roots, if Codex supports project-level config |

## Avoid

- Default global Codex home (the isolation target)
- Ephemeral directories (`/tmp`)
- Directories inside git repos that get pushed
- Other users' paths on shared hosts

## Agent Checklist

Before creating files, confirm:

1. User's private persistent root on this host
2. Workspace roots Codex should access
3. Whether proxy is needed
4. Current Codex CLI home/login/config mechanism (from help output)

Default: hub under private root, multiple workspace roots in allowlist.
