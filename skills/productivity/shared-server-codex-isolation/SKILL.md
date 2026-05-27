---
name: shared-server-codex-isolation
description: Explicit-only ($shared-server-codex-isolation). Bootstrap personal Codex isolation on a shared multi-user host so subscription, threads, and skills stay separate from global ~/.codex/. Use when invoked for new-cluster Codex setup, personal Codex home placement, codex-wjs, host migration, or avoiding shell credential leakage. Not implicit. Not for Cursor-only setup or single-user machines.
disable-model-invocation: true
---

# Shared-Server Codex Isolation

**Invoke:** `$shared-server-codex-isolation` only.

Personal skill for **wjs**. Help run Codex on a **shared host** with a personal
identity (subscription, threads, skills) that does not collide with global
defaults or another user's state.

Do **not** assume paths, env vars, or config schema from another cluster or
Codex version. Discover how **this** Codex CLI works first, then apply the
principles below.

## Goals

The setup must achieve:

1. **Personal home** — auth, sessions, skills, and personal config live in a
   user-owned directory, not the default global Codex home.
2. **Clean shell** — launcher clears or overrides shell credentials and base
   URLs that could hijack auth before Codex starts.
3. **Workspace boundary** — Codex runs only under user-approved code/data roots;
   default workspace is the current directory (`$PWD`).
4. **`codex-wjs` entry** — daily use and login go through `codex-wjs`; the
   launcher script path is an implementation detail, and bare `codex` must not
   be the normal path.
5. **Persistence and privacy** — personal home survives restarts, stays private,
   and is never committed to git.

## Two Concepts

1. **Personal Codex home** — fixed for the user on this cluster (identity).
2. **Workspace roots** — code/data trees where Codex may run (context).

These may live in **different directories**. The launcher binds identity to
workspace; nesting personal home inside a repo is not required.

See [references/placement-rules.md](./references/placement-rules.md) for where
to put each artifact and what to avoid.

## Agent Workflow

### 1. Discover current Codex behavior

Inspect on **this** host before writing files:

```bash
command -v codex
codex --help
codex login --help
```

Read current docs or help output for: custom home directory mechanism, login
flow, config file locations, project-level config discovery, and relevant
environment variables. **Do not hardcode** names or schema from memory or
another cluster.

Ask the user when needed:

- Private persistent root on this cluster
- Workspace roots (repos, datasets)
- Whether proxy is required for OpenAI

### 2. Plan layout

- Place **personal home** under the user's private, persistent root.
- Place **launcher** at a stable path, then expose **`codex-wjs`** on PATH
  (symlink to launcher under `bin/` is the default pattern).
- List **workspace roots** for the allowlist.
- Keep personal home **outside** git repos that get pushed.

### 3. Implement minimally

Create only what this Codex version needs to meet the goals:

- Personal home directory with restrictive permissions
- Launcher that sets personal home, sanitizes shell env, validates cwd against
  an allowlist, optionally applies proxy for this process only, then execs Codex
- **`codex-wjs`** — thin entry (symlink, wrapper, or shell function) that
  delegates to the launcher; put it on PATH via personal rc or terminal profile
- Personal and project config using **current** Codex schema (read help/docs)
- Login through `codex-wjs` so credentials land in personal home

Prefer the smallest working setup. Add project config or proxy only when the
user or environment requires them.

### 4. Verify

Confirm all of:

- `command -v codex-wjs` resolves in a fresh intended terminal
- `codex-wjs login status` succeeds
- Credentials and sessions are under personal home, not global default
- Launch from an allowed project directory works (`cd` there, then `codex-wjs`)
- Launch from a disallowed temporary/system directory is refused
- Bare `codex` is documented as unsupported for daily use

Leave a short note beside the launcher documenting `codex-wjs`, paths, and
daily commands for **this** cluster.

## Daily Use

```bash
cd <project-dir>
codex-wjs
codex-wjs resume
codex-wjs login status
```

## Design Notes

When implementing the launcher and `codex-wjs`, prefer these patterns from prior
deployments. Verify env-var names and Codex flags against current CLI help — do
not copy verbatim from another cluster.

- Sanitize **all** shell vars that can redirect auth or endpoint, not just API
  keys (base URL, org/project IDs, and similar overrides).
- Refuse a symlinked personal home before exporting it as the Codex home.
- Normalize cwd with `cd -P` before allowlist checks; string prefix match on
  raw paths can be bypassed by symlinks.
- Distinguish a path argument from a Codex subcommand by shape (e.g. starts
  with `/`, `.`, or `..`) so `resume`, `login`, and `exec` reach Codex.
- Apply proxy via `source` in the launcher process only; do not write proxy
  exports to `.bashrc` unless the user explicitly wants global proxy.
- Keep isolation logic in one launcher; make `codex-wjs` a thin symlink or
  wrapper that delegates to it.
- Use `exec codex "$@"` so signals and exit codes pass through cleanly.
- Fail fast with a clear stderr message for each precondition (missing home,
  unreadable config, disallowed workspace).

## Isolated vs Context-Dependent

| Stays personal (fixed home) | Depends on cwd / host |
|-----------------------------|------------------------|
| Subscription / auth | Codex CLI binary (often global) |
| Threads / sessions pool | Files Codex reads and writes |
| Personal skills / plugins | Project config (if Codex supports it) |
| Personal preferences | Session records its starting directory |

## Do Not

- Invoke without explicit user request.
- Copy paths or config from another cluster without re-validating here.
- Commit auth tokens, sqlite state, or personal home to git.
- Modify other users' directories, environments, or processes.
- Bake version-specific env var names or TOML keys into this skill — read current
  Codex behavior at setup time.

## References

- [references/placement-rules.md](./references/placement-rules.md)

## Trigger Tests

- Should trigger (explicit only): user invokes `$shared-server-codex-isolation`
  or asks to set up `codex-wjs` isolation on a shared cluster.
- Should not trigger: "Install wujs-curated-skills"; "Configure Cursor MCP";
  ambient mentions of Codex without invoking this skill.
