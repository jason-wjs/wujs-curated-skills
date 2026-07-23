#!/usr/bin/env python3
"""Render reviewed bootstrap candidates for a shared SSH host.

The renderer never connects to a host or edits live configuration.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
import shlex
from urllib.parse import urlsplit


PROFILE_RE = re.compile(r"[a-zA-Z0-9][a-zA-Z0-9_.-]*")


def q(value: str) -> str:
    return shlex.quote(value)


def bash_array(values: list[str]) -> str:
    return "\n".join(f"  {q(value)}" for value in values)


def authorized_keys_escape(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', '\\"')


def toml_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=True)


def toml_array(values: list[str]) -> str:
    return "[" + ", ".join(toml_string(value) for value in values) + "]"


def render_start_codex(args: argparse.Namespace) -> str:
    proxy = ""
    if args.proxy_url:
        proxy = f"""
WJS_PROXY_URL={q(args.proxy_url)}
export http_proxy="$WJS_PROXY_URL" https_proxy="$WJS_PROXY_URL"
export HTTP_PROXY="$WJS_PROXY_URL" HTTPS_PROXY="$WJS_PROXY_URL"
export NO_PROXY=localhost,127.0.0.1
export no_proxy="$NO_PROXY"
"""

    hostname_check = ""
    if args.remote_hostname:
        hostname_check = f"""
if [[ "$(hostname)" != {q(args.remote_hostname)} ]]; then
  echo "Profile $PROFILE is not valid on host $(hostname)." >&2
  exit 1
fi
"""

    return f"""#!/usr/bin/env bash
set -euo pipefail

PERSONAL_ROOT={q(args.personal_root)}
PROFILE={q(args.profile)}
PERSONAL_CODEX_HOME={q(args.codex_home)}
CODEX_BIN={q(args.codex_bin)}
ALLOWED_WORKDIRS=(
{bash_array(args.allowed_root)}
)

if [[ -n "${{WJS_CODEX_PROFILE:-}}" && "$WJS_CODEX_PROFILE" != "$PROFILE" ]]; then
  echo "Profile mismatch: expected $PROFILE, got $WJS_CODEX_PROFILE" >&2
  exit 1
fi
export WJS_CODEX_PROFILE="$PROFILE"
{hostname_check}

if [[ -L "$PERSONAL_CODEX_HOME" || ! -d "$PERSONAL_CODEX_HOME" ]]; then
  echo "Invalid personal CODEX_HOME: $PERSONAL_CODEX_HOME" >&2
  exit 1
fi
if [[ ! -x "$CODEX_BIN" ]]; then
  echo "Missing personal Codex CLI: $CODEX_BIN" >&2
  exit 1
fi

is_app_server=false
requested_workdir="$PWD"
expect_workdir=false
for arg in "$@"; do
  if [[ "$expect_workdir" == true ]]; then
    requested_workdir="$arg"
    expect_workdir=false
    continue
  fi
  case "$arg" in
    app-server) is_app_server=true ;;
    -C|--cd) expect_workdir=true ;;
    --cd=*) requested_workdir="${{arg#--cd=}}" ;;
  esac
done

case "${{1:-}}" in
  --version|-V|version|--help|-h|help|login|logout)
    requested_workdir="${{ALLOWED_WORKDIRS[0]}}"
    ;;
esac
if [[ "$is_app_server" == true ]]; then
  requested_workdir="${{ALLOWED_WORKDIRS[0]}}"
fi

if [[ ! -d "$requested_workdir" ]]; then
  echo "Requested workspace does not exist: $requested_workdir" >&2
  exit 1
fi
requested_workdir="$(cd -P "$requested_workdir" && pwd)"

allowed=false
for allowed_workdir in "${{ALLOWED_WORKDIRS[@]}}"; do
  if [[ ! -d "$allowed_workdir" ]]; then
    echo "Configured workspace does not exist: $allowed_workdir" >&2
    exit 1
  fi
  allowed_workdir="$(cd -P "$allowed_workdir" && pwd)"
  if [[ "$requested_workdir" == "$allowed_workdir" ||
        "$requested_workdir" == "$allowed_workdir"/* ]]; then
    allowed=true
    break
  fi
done
if [[ "$allowed" != true ]]; then
  echo "Refusing to start codex-wjs outside allowed workspaces:" >&2
  printf "  %s\\n" "${{ALLOWED_WORKDIRS[@]}}" >&2
  echo "Requested: $requested_workdir" >&2
  exit 1
fi

export CODEX_HOME="$PERSONAL_CODEX_HOME"
export CODEX_SQLITE_HOME="$PERSONAL_CODEX_HOME"
unset OPENAI_API_KEY
unset CODEX_API_KEY
unset OPENAI_BASE_URL
unset OPENAI_ORG_ID
unset OPENAI_PROJECT_ID
{proxy}
cd "$requested_workdir"
exec "$CODEX_BIN" "$@"
"""


def render_codex_wjs(args: argparse.Namespace) -> str:
    return f"""#!/usr/bin/env bash
set -euo pipefail
export WJS_CODEX_PROFILE={q(args.profile)}
exec {q(args.personal_root + '/start_codex.sh')} "$@"
"""


def render_bashrc_extras(args: argparse.Namespace) -> str:
    proxy_helpers = ""
    manual_proxy_url = args.proxy_url or args.git_proxy_url
    if manual_proxy_url:
        proxy_helpers = f"""
_wjs_proxy_url={q(manual_proxy_url)}

wjs_proxy_on() {{
  export http_proxy="$_wjs_proxy_url" https_proxy="$_wjs_proxy_url"
  export HTTP_PROXY="$_wjs_proxy_url" HTTPS_PROXY="$_wjs_proxy_url"
  export NO_PROXY=localhost,127.0.0.1
  export no_proxy="$NO_PROXY"
  echo "WJS proxy enabled: $_wjs_proxy_url"
}}

wjs_proxy_off() {{
  unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
  unset all_proxy ALL_PROXY no_proxy NO_PROXY
  echo "WJS proxy disabled"
}}
"""

    return f"""# Personal shell additions; never redefine bare codex.
[[ -n "${{_WJS_EXTRAS_LOADED:-}}" ]] && return 0
_WJS_EXTRAS_LOADED=1

export WJS_CODEX_PROFILE="${{WJS_CODEX_PROFILE:-{args.profile}}}"
export PATH={q(args.personal_root + '/bin')}:"$PATH"
{proxy_helpers}"""


def render_bashrc_wjs(args: argparse.Namespace) -> str:
    return f"""# Personal interactive shell. Shared defaults remain shared.
if [[ -z "${{_WJS_GLOBAL_BASHRC_SOURCED:-}}" ]]; then
  _WJS_GLOBAL_BASHRC_SOURCED=1
  if [[ -f "$HOME/.bashrc" ]]; then
    source "$HOME/.bashrc"
  fi
fi

if [[ -z "${{_WJS_EXTRAS_LOADED:-}}" ]]; then
  source {q(args.personal_root + '/.bashrc-wjs-extras.sh')}
fi
"""


def identity_lines(identity_file: str) -> str:
    if not identity_file:
        return ""
    return f"    IdentityFile {identity_file}\n    IdentitiesOnly yes\n"


def render_ssh_block(args: argparse.Namespace) -> str:
    base_identity = identity_lines(args.identity_file)
    wjs_identity = identity_lines(args.wjs_identity_file)
    return f"""# Merge with existing SSH config; do not duplicate the base block.
Host {args.host_alias}
    HostName {args.hostname}
    Port {args.port}
    User {args.user}
{base_identity.rstrip()}

Host {args.wjs_host_alias}
    HostName {args.hostname}
    Port {args.port}
    User {args.user}
{wjs_identity.rstrip()}
    StrictHostKeyChecking accept-new
"""


def render_dispatcher(args: argparse.Namespace) -> str:
    hostname_check = ""
    if args.remote_hostname:
        hostname_check = f"""
if [[ "$(hostname)" != {q(args.remote_hostname)} ]]; then
  echo "Profile $profile is not valid on host $(hostname)." >&2
  exit 1
fi
"""
    return f"""#!/usr/bin/env bash
set -euo pipefail

PERSONAL_ROOT={q(args.personal_root)}
expected_profile={q(args.profile)}
profile="${{1:-}}"
if [[ "$profile" != "$expected_profile" ]]; then
  echo "Invalid WJS SSH profile: $profile" >&2
  exit 1
fi
export WJS_CODEX_PROFILE="$profile"
{hostname_check}

original="${{SSH_ORIGINAL_COMMAND:-}}"
if [[ -z "$original" ]]; then
  exec bash --rcfile "$PERSONAL_ROOT/.bashrc-wjs" -i
fi

if [[ "$original" == *CODEX_REMOTE_PAYLOAD* &&
      "$original" == *"Codex remote SSH requires SHELL"* ]]; then
  export CODEX_INSTALL_DIR="$PERSONAL_ROOT/app-bin/$profile"
  exec bash -lc "$original"
fi

export BASH_ENV="$PERSONAL_ROOT/.bashrc-wjs-extras.sh"
exec bash -lc "$original"
"""


def render_app_codex(args: argparse.Namespace) -> str:
    return f"""#!/usr/bin/env bash
set -euo pipefail
export WJS_CODEX_PROFILE={q(args.profile)}
exec {q(args.personal_root + '/bin/codex-wjs')} "$@"
"""


def render_authorized_key_command(args: argparse.Namespace) -> str:
    command = f"{args.personal_root}/ssh-codex-dispatch.sh {args.profile}"
    return (
        f'restrict,pty,command="{authorized_keys_escape(command)}" '
        f"ssh-ed25519 <PASTE_{args.profile.upper()}_WJS_PUBLIC_KEY> "
        f"{args.profile}-wjs\n"
    )


def render_proxy_service(args: argparse.Namespace) -> str:
    return f"""[Unit]
Description=WJS reverse proxy for {args.profile}
After=network-online.target
Wants=network-online.target

[Service]
Environment=AUTOSSH_GATETIME=0
ExecStart=/usr/bin/autossh -M 0 -N -T \\
  -o ExitOnForwardFailure=yes \\
  -o ServerAliveInterval=30 \\
  -o ServerAliveCountMax=3 \\
  -R 127.0.0.1:{args.remote_proxy_port}:127.0.0.1:{args.laptop_proxy_port} \\
  {args.tunnel_ssh_alias}
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
"""


def render_git_helper(args: argparse.Namespace) -> str:
    proxy = ""
    if args.git_proxy_url:
        proxy = f"""
git config --local http.proxy {q(args.git_proxy_url)}
git config --local https.proxy {q(args.git_proxy_url)}
"""
    return f"""#!/usr/bin/env bash
set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Run this helper from inside the intended Git repository." >&2
  exit 1
fi

git config --local user.name {q(args.git_user_name)}
git config --local user.email {q(args.git_user_email)}
git config --local credential.helper {q(args.git_credential_helper)}
{proxy}
printf 'Configured repository-local Git identity for %s <%s>.\\n' \\
  {q(args.git_user_name)} {q(args.git_user_email)}
"""


def render_profile_toml(args: argparse.Namespace) -> str:
    if args.enable_reverse_proxy:
        proxy_mode = "reverse-tunnel"
    elif args.proxy_url or args.git_proxy_url:
        proxy_mode = "proxy"
    else:
        proxy_mode = "direct"

    return f"""profile = {toml_string(args.profile)}
base_alias = {toml_string(args.host_alias)}
wjs_alias = {toml_string(args.wjs_host_alias)}
ssh_host = {toml_string(args.hostname)}
ssh_port = {args.port}
ssh_user = {toml_string(args.user)}
remote_hostname = {toml_string(args.remote_hostname)}
personal_root = {toml_string(args.personal_root)}
allowed_roots = {toml_array(args.allowed_root)}
shared_storage_group = {toml_string(args.shared_storage_group)}

[modules]
shell = true
network = true
git = true
codex = true
codex_app = {str(args.enable_codex_app).lower()}

[network]
mode = {toml_string(proxy_mode)}
openai_proxy = {toml_string(args.proxy_url)}
github_proxy = {toml_string(args.git_proxy_url)}
reverse_tunnel = {str(args.enable_reverse_proxy).lower()}
"""


def render_install_notes(args: argparse.Namespace) -> str:
    app_notes = ""
    if args.enable_codex_app:
        app_notes = f"""
4. For Codex App:

   - Install `ssh-codex-dispatch.sh` at
     `{args.personal_root}/ssh-codex-dispatch.sh`.
   - Install `app-codex` at
     `{args.personal_root}/app-bin/{args.profile}/codex`.
   - Back up `authorized_keys`, replace the placeholder in
     `authorized-key-command.txt`, and append exactly one entry.
   - Install official managed Codex into `{args.codex_home}`.
"""
    proxy_notes = ""
    if args.enable_reverse_proxy:
        proxy_notes = f"""
5. On the always-on laptop, review and install
   `{args.profile}-wjs-proxy.service` as a user unit. Confirm `autossh`,
   SSH reachability, local proxy port {args.laptop_proxy_port}, remote port
   {args.remote_proxy_port}, and linger policy before enabling it.
"""

    return f"""# Candidate Install Notes

These files are not installed. Review every path and command first.

1. Create the personal directories and profile home:

   install -d -m 700 {args.personal_root}/bin
   install -d -m 700 {args.codex_home}

2. Install personal files without changing shared rc or global codex:

   install -m 700 start_codex.sh {args.personal_root}/start_codex.sh
   install -m 700 bin-codex-wjs {args.personal_root}/bin/codex-wjs
   install -m 700 setup_git_local.sh {args.personal_root}/bin/setup_git_local.sh
   install -m 644 .bashrc-wjs .bashrc-wjs-extras.sh {args.personal_root}/

3. Keep `profile.toml` as the non-secret deployment record. Merge only the
   reviewed SSH blocks into the local SSH config.
{app_notes}{proxy_notes}
Verify base `codex`, personal `codex-wjs`, allowlist rejection, login status,
managed app-server when enabled, and current Codex App logs.
"""


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output-dir", required=True)
    parser.add_argument("--profile", required=True)
    parser.add_argument("--personal-root", required=True)
    parser.add_argument("--codex-home", default="")
    parser.add_argument("--codex-bin", default="")
    parser.add_argument("--allowed-root", action="append", default=[])
    parser.add_argument("--proxy-url", default="")
    parser.add_argument("--git-proxy-url", default="")
    parser.add_argument("--git-user-name", default="jason-wjs")
    parser.add_argument("--git-user-email", default="jason-w@sjtu.edu.cn")
    parser.add_argument(
        "--git-credential-helper", default="cache --timeout=3600"
    )
    parser.add_argument("--shared-storage-group", default="")
    parser.add_argument("--host-alias", required=True)
    parser.add_argument("--wjs-host-alias", default="")
    parser.add_argument("--hostname", required=True)
    parser.add_argument("--remote-hostname", default="")
    parser.add_argument("--port", type=int, default=22)
    parser.add_argument("--user", default="root")
    parser.add_argument("--identity-file", default="~/.ssh/id_ed25519")
    parser.add_argument("--wjs-identity-file", default="")
    parser.add_argument("--enable-codex-app", action="store_true")
    parser.add_argument("--enable-reverse-proxy", action="store_true")
    parser.add_argument("--tunnel-ssh-alias", default="")
    parser.add_argument("--laptop-proxy-port", type=int)
    parser.add_argument("--remote-proxy-port", type=int)
    args = parser.parse_args()

    if not PROFILE_RE.fullmatch(args.profile):
        parser.error("--profile must contain only letters, digits, dot, underscore, or hyphen")
    if not args.allowed_root:
        args.allowed_root = [args.personal_root]
    if not args.codex_home:
        args.codex_home = f"{args.personal_root}/codex-home/{args.profile}"
    if not args.codex_bin:
        args.codex_bin = f"{args.codex_home}/packages/standalone/current/codex"
    if not args.wjs_host_alias:
        args.wjs_host_alias = f"{args.host_alias}_wjs"
    if not args.wjs_identity_file:
        args.wjs_identity_file = f"~/.ssh/id_ed25519_{args.profile}_wjs"
    if not args.shared_storage_group:
        args.shared_storage_group = args.profile

    for name, value in {
        "--host-alias": args.host_alias,
        "--wjs-host-alias": args.wjs_host_alias,
        "--tunnel-ssh-alias": args.tunnel_ssh_alias,
    }.items():
        if value and not PROFILE_RE.fullmatch(value):
            parser.error(f"{name} must be a single safe SSH alias")
    for name, value in {
        "--personal-root": args.personal_root,
        "--codex-home": args.codex_home,
        "--codex-bin": args.codex_bin,
        "--hostname": args.hostname,
        "--remote-hostname": args.remote_hostname,
        "--user": args.user,
        "--identity-file": args.identity_file,
        "--wjs-identity-file": args.wjs_identity_file,
        "--proxy-url": args.proxy_url,
        "--git-proxy-url": args.git_proxy_url,
        "--git-user-name": args.git_user_name,
        "--git-user-email": args.git_user_email,
        "--git-credential-helper": args.git_credential_helper,
        "--shared-storage-group": args.shared_storage_group,
    }.items():
        if "\n" in value or "\r" in value:
            parser.error(f"{name} must not contain newlines")
    if not 1 <= args.port <= 65535:
        parser.error("--port must be between 1 and 65535")
    for name, value in {
        "--proxy-url": args.proxy_url,
        "--git-proxy-url": args.git_proxy_url,
    }.items():
        if not value:
            continue
        parsed = urlsplit(value)
        if parsed.scheme not in {"http", "https", "socks5", "socks5h"}:
            parser.error(f"{name} must use http, https, socks5, or socks5h")
        if not parsed.hostname:
            parser.error(f"{name} must include a host")
        if parsed.username or parsed.password or parsed.query or parsed.fragment:
            parser.error(f"{name} must not contain credentials, query, or fragment")

    if args.enable_reverse_proxy:
        required = {
            "--tunnel-ssh-alias": args.tunnel_ssh_alias,
            "--laptop-proxy-port": args.laptop_proxy_port,
            "--remote-proxy-port": args.remote_proxy_port,
        }
        missing = [name for name, value in required.items() if not value]
        if missing:
            parser.error(
                "--enable-reverse-proxy requires " + ", ".join(missing)
            )
        for name, value in {
            "--laptop-proxy-port": args.laptop_proxy_port,
            "--remote-proxy-port": args.remote_proxy_port,
        }.items():
            if not 1 <= value <= 65535:
                parser.error(f"{name} must be between 1 and 65535")
        if not args.proxy_url:
            args.proxy_url = f"http://127.0.0.1:{args.remote_proxy_port}"

    return args


def main() -> int:
    args = parse_args()
    out = Path(args.output_dir)
    out.mkdir(parents=True, exist_ok=True)

    files = {
        "start_codex.sh": render_start_codex(args),
        "bin-codex-wjs": render_codex_wjs(args),
        ".bashrc-wjs": render_bashrc_wjs(args),
        ".bashrc-wjs-extras.sh": render_bashrc_extras(args),
        "setup_git_local.sh": render_git_helper(args),
        "profile.toml": render_profile_toml(args),
        "ssh-config-block.txt": render_ssh_block(args),
        "install-notes.md": render_install_notes(args),
    }
    if args.enable_codex_app:
        files.update(
            {
                "ssh-codex-dispatch.sh": render_dispatcher(args),
                "app-codex": render_app_codex(args),
                "authorized-key-command.txt": render_authorized_key_command(args),
            }
        )
    if args.enable_reverse_proxy:
        files[f"{args.profile}-wjs-proxy.service"] = render_proxy_service(args)

    executable_names = {
        "start_codex.sh",
        "bin-codex-wjs",
        "ssh-codex-dispatch.sh",
        "app-codex",
        "setup_git_local.sh",
    }
    for name, content in files.items():
        path = out / name
        path.write_text(content, encoding="utf-8")
        if name in executable_names:
            path.chmod(0o700)

    print(f"Rendered {len(files)} candidate files into {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
