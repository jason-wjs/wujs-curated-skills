# Placement Rules

Apply on the **current** cluster. Do not copy paths from elsewhere.

## Principles

| Rule | Why |
|------|-----|
| User-private directory | Not root-owned homes, temporary directories, shared homes, or other users' trees |
| Persistent storage | Auth and sessions must survive restarts |
| Personal home ≠ workspace | Identity directory can sit outside code/data trees |
| Secrets outside git | Personal home must not live in a pushed repository |
| Stable `codex-wjs` command | Same entry from any allowed project without typing launcher path |

## Recommended Pattern

Separate **config hub** from **workspaces**:

```text
USER_PRIVATE_ROOT/          # persistent, user-owned
├── start_codex.sh          # launcher (isolation logic)
├── bin/codex-wjs           # symlink → launcher
├── .codex-home/            # personal Codex home
├── .bashrc-wjs             # optional personal rc (PATH, proxyon/proxyoff)

WORKSPACE_ROOT_1/           # allowlisted code
WORKSPACE_ROOT_2/           # allowlisted data (optional)
```

Personal home, launcher, and `codex-wjs` usually live under `USER_PRIVATE_ROOT`.
Expose `codex-wjs` on PATH via personal rc or a managed terminal profile — do
not modify shared global `.bashrc` on multi-user hosts.

Workspace roots are listed in the launcher's allowlist only; they need not
contain the launcher or `codex-wjs`.

Single-tree layout (everything under one user root) is fine when the cluster
gives the user only one private tree.

## Per Artifact

| Artifact | Where |
|----------|--------|
| Personal Codex home | User private root; restrictive permissions |
| Launcher (`start_codex.sh`) | User private root; owns isolation logic |
| `codex-wjs` | `bin/codex-wjs` symlink to launcher, or equivalent on PATH |
| Personal rc | User private root; sources global rc, adds `bin/` to PATH |
| Proxy | `proxyon` / `proxyoff` in personal rc; Codex launcher inlines same URL |
| Project config | At workspace roots, if Codex supports project-level config |

## Avoid

- Default global Codex home (the isolation target)
- Ephemeral temporary directories
- Directories inside git repos that get pushed
- Other users' paths on shared hosts
- Modifying shared global shell init for PATH (use personal rc or terminal profile)

## Agent Checklist

Before creating files, confirm:

1. User's private persistent root on this host
2. Workspace roots Codex should access
3. Whether proxy is needed
4. Current Codex CLI home/login/config mechanism (from help output)

Default: hub under private root with `codex-wjs`, multiple workspace roots in
allowlist.
