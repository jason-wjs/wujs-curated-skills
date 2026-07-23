# Audit and Profile

## Local audit

Run from the controller:

```bash
test -z "${SSH_CONNECTION:-}" && test -z "${SSH_TTY:-}"
hostname
uname -a
ssh -G <base-alias>
ssh -o BatchMode=yes <base-alias> 'true'
```

Inspect the effective alias rather than copying text from another cluster.
Confirm which local key, proxy jump, host, port, and user are active.

## Remote read-only audit

```bash
ssh <base-alias> '
  id
  hostname
  printf "shell=%s\n" "$SHELL"
  command -v bash git curl python3 codex 2>/dev/null || true
  type -a codex 2>/dev/null || true
  df -hT
  df -ih
'
```

For the proposed personal root:

```bash
ssh <base-alias> '
  root=<personal-root>
  test -d "$root"
  test -w "$root"
  readlink -f "$root"
  findmnt -T "$root" 2>/dev/null || true
'
```

When several nodes share storage, compare canonical path, mount source,
filesystem type, hostname, inode availability, and write behavior on each
node. Do not assume two public endpoints are the same instance.

## Network matrix

Classify each destination separately:

| Destination | Direct | Existing proxy | Selected route |
| --- | --- | --- | --- |
| OpenAI auth | unknown/pass/fail/region-blocked | same | direct/proxy/tunnel |
| ChatGPT/App | unknown/pass/fail/region-blocked | same | direct/proxy/tunnel |
| GitHub HTTPS | unknown/pass/fail | same | direct/proxy/tunnel |

Use bounded DNS/TLS/HTTP probes. A Google response does not prove OpenAI auth
or GitHub access. Do not send tokens in diagnostic requests.

## Profile schema

Maintain a non-secret deployment record during the task:

```toml
profile = "cluster_gpu_1"
base_alias = "cluster_gpu_1"
wjs_alias = "cluster_gpu_1_wjs"
ssh_host = "203.0.113.10"
ssh_port = 22
ssh_user = "root"
remote_hostname = "instance-abc"
personal_root = "/shared/wjs"
allowed_roots = ["/shared/wjs"]
shared_storage_group = "cluster_gpu"

[modules]
shell = true
network = true
git = true
codex = true
codex_app = true

[network]
openai_route = "direct"
github_route = "direct"
reverse_tunnel = false
```

The record must never contain:

- private keys or public-key bodies;
- PATs, OAuth tokens, cookies, or auth JSON;
- proxy credentials;
- token-bearing URLs;
- complete `auth.json` or Codex session data.

For shared storage, use a distinct `profile`, `remote_hostname`, Codex home,
App wrapper, daemon socket, and optional reverse port per host.

