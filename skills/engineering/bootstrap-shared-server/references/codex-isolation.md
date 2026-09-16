# Codex Isolation

## Invariants

- Bare `codex` remains the shared/global command.
- `codex-dev` is the only personal terminal entrypoint.
- Personal state never uses shared `~/.codex`.
- Workspaces are allowlisted before Codex starts.
- Inherited API keys and endpoint overrides cannot hijack the personal
  subscription.

This is command hygiene, not protection from another person using the same UID.

## Layout

```text
PERSONAL_ROOT/
├── start_codex.sh
├── bin/codex-dev
├── codex-home/<profile>/
├── app-bin/<profile>/codex       # App-only, when enabled
└── ssh-codex-dispatch.sh         # App-only, when enabled
```

For shared persistent storage, every host receives its own profile,
`CODEX_HOME`, managed package tree, app-server socket, logs, and App wrapper.

## Launcher

The personal launcher must:

1. Validate the profile against a fixed list.
2. Validate the remote hostname when it is stable.
3. Reject missing or symlinked `CODEX_HOME`.
4. Canonicalize the requested workdir.
5. Enforce the configured allowed roots; reject paths outside them.
6. Export profile-specific `CODEX_HOME` and `CODEX_SQLITE_HOME`.
7. Unset inherited `OPENAI_API_KEY`, `CODEX_API_KEY`, `OPENAI_BASE_URL`,
   organization, and project variables.
8. Apply the selected OpenAI proxy only to the Codex process.
9. Execute the personal Codex binary.

Allow version/help/login and app-server control commands to run from a
canonical allowed root rather than an arbitrary current directory.

## Managed standalone

Codex App requires the official managed standalone layout inside the profile:

```text
CODEX_HOME/packages/standalone/current/codex
```

A manually copied CLI may work interactively but fail
`app-server daemon bootstrap`. Review the official installer before running it
with the personal `CODEX_HOME`; never install the personal binary globally.

The user completes ChatGPT/Codex login through `codex-dev`. Do not copy,
inspect, print, or synchronize auth files between profiles.

## Terminal verification

```bash
ssh <base-alias> 'command -v codex || true; codex --version 2>/dev/null || true'
ssh <personal-alias> 'command -v codex || true; command -v codex-dev'
ssh <personal-alias> 'cd <allowed-root> && codex-dev --version'
ssh <personal-alias> 'codex-dev -C /tmp exec true'  # must refuse unless /tmp is allowlisted
ssh <personal-alias> 'cd <allowed-root> && codex-dev login status'
```

Read [codex-app-ssh.md](./codex-app-ssh.md) only when App support is requested.

