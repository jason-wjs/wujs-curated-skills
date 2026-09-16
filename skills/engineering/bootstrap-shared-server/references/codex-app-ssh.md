# Codex App over a Shared SSH Account

Codex App probes for a command named `codex` and starts its managed
`app-server`. A terminal-only `codex-dev` wrapper is therefore insufficient.
Do not solve this by replacing global `codex`.

## Design

Use:

1. unchanged base SSH alias and ordinary key;
2. `<base>_dev` alias with a dedicated key;
3. one appended forced-command entry for that key;
4. a dispatcher that recognizes App bootstrap commands;
5. a profile-private directory containing an App-only wrapper named `codex`;
6. the official managed standalone Codex installation in profile-private
   `CODEX_HOME`.

The App-only wrapper is never in an ordinary terminal PATH.

## Dedicated key

Generate a separate local key and add an entry like this to the remote shared
account's `authorized_keys`:

```text
restrict,pty,command="<personal-root>/ssh-codex-dispatch.sh <profile>" ssh-ed25519 <public-key> <comment>
```

Back up `authorized_keys` first. Append one line; never replace or normalize
existing entries. Confirm the server's OpenSSH supports the selected key
options. Loosen only the specific restriction required by the environment.

## Dispatcher behavior

Pseudocode:

```bash
export DEV_CODEX_PROFILE=<validated-profile>
original="${SSH_ORIGINAL_COMMAND:-}"

if [[ -z "$original" ]]; then
  exec bash --rcfile "<personal-root>/.bashrc-dev" -i
fi

if [[ "$original" == *CODEX_REMOTE_PAYLOAD* &&
      "$original" == *"Codex remote SSH requires SHELL"* ]]; then
  export CODEX_INSTALL_DIR="<personal-root>/app-bin/<profile>"
  exec bash -lc "$original"
fi

export BASH_ENV="<personal-root>/.bashrc-dev-extras.sh"
exec bash -lc "$original"
```

Validate the profile against a fixed allowlist before using it in a path.
Treat the App signature as version-sensitive: inspect current local App logs
when an update changes remote behavior.

## App-only wrapper

Create:

```text
PERSONAL_ROOT/app-bin/PROFILE/codex
```

with:

```bash
#!/usr/bin/env bash
set -euo pipefail
export DEV_CODEX_PROFILE=<profile>
exec <personal-root>/bin/codex-dev "$@"
```

The App bootstrap prepends `CODEX_INSTALL_DIR` to PATH, so only that command
finds this personal `codex`.

## Managed standalone requirement

Install Codex through the official managed installer with the profile's
`CODEX_HOME` and installation directory. Review the installer before running
it. Verify:

```bash
codex-dev --version
codex-dev login status
codex-dev app-server daemon bootstrap
codex-dev app-server daemon start
codex-dev app-server daemon version
```

The managed executable should resolve through:

```text
CODEX_HOME/packages/standalone/current/codex
```

If CLI use succeeds but bootstrap reports that a managed standalone install is
missing, replace the ad hoc binary with the official managed layout inside the
personal home. Do not install it globally.

## Why `RemoteCommand` is insufficient

`RemoteCommand bash --rcfile ... -i` is convenient for a terminal-only alias,
but conflicts with tools that send their own SSH command. An App-capable alias
needs the dispatcher to distinguish:

- no remote command: personal interactive shell;
- ordinary remote command: normal command with personal helpers available;
- Codex App bootstrap: temporary App-only `codex`.

## Verification

Terminal invariants:

```bash
ssh <base>_dev 'command -v codex || true; command -v codex-dev'
ssh <base>_dev 'codex --version 2>/dev/null || true'
ssh <base>_dev 'cd <allowed-root> && codex-dev --version'
```

Simulate the App path exposure:

```bash
ssh <base>_dev \
  'echo CODEX_REMOTE_PAYLOAD >/dev/null; echo "Codex remote SSH requires SHELL" >/dev/null; PATH="${CODEX_INSTALL_DIR}:$PATH"; command -v codex; codex --version'
```

Then reconnect in Codex App and inspect current desktop logs. The successful
sequence should include:

```text
codex_path_probe
codex_version_probe
app_server_bootstrap
proxy_command_starting
connected
```

Old failures may remain in logs or UI state. Require a new timestamped attempt
before judging the fix.

## Failure map

| Symptom | Likely cause |
| --- | --- |
| `remote-codex-not-found` | Dispatcher did not expose App-only `codex` |
| Managed standalone missing | CLI binary was copied manually |
| Token endpoint region 403 | Proxy/direct egress region is unsupported |
| Token request send error | Proxy/tunnel cannot reach auth endpoint |
| App reconnect loop | Inspect newest bootstrap/proxy logs and daemon socket |
| Works on one shared-PFS host only | Profiles share `CODEX_HOME` or wrong proxy map |
| Terminal bare `codex` becomes personal | App wrapper leaked into normal PATH; rollback |

