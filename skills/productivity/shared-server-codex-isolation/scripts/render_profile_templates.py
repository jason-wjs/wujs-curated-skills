\
#!/usr/bin/env python3
"""Render explicit-only codex-wjs candidate files for a shared server.

The script writes only to --output-dir. It does not connect to a server, edit
SSH config, or modify live files.
"""

from __future__ import annotations

import argparse
from pathlib import Path
import shlex


def q(value: str) -> str:
    return shlex.quote(value)


def bash_array(values: list[str]) -> str:
    return "\n".join(f"  {q(v)}" for v in values)


def render_start_codex(args: argparse.Namespace) -> str:
    codex_bin_dir = str(Path(args.codex_bin).parent)
    proxy = ""
    if args.proxy_url:
        proxy = f"""
_WJS_PROXY_URL={q(args.proxy_url)}
export http_proxy="$_WJS_PROXY_URL"
export https_proxy="$_WJS_PROXY_URL"
"""
    return f"""#!/usr/bin/env bash
set -euo pipefail

PERSONAL_CODEX_HOME={q(args.codex_home)}
CODEX_BIN={q(args.codex_bin)}
ALLOWED_WORKDIRS=(
{bash_array(args.allowed_root)}
)

if [[ -L "$PERSONAL_CODEX_HOME" ]]; then
  echo "Refusing to use symlinked CODEX_HOME: $PERSONAL_CODEX_HOME" >&2
  exit 1
fi

if [[ ! -x "$CODEX_BIN" ]]; then
  echo "Missing executable Codex CLI: $CODEX_BIN" >&2
  exit 1
fi

if [[ ! -d "$PERSONAL_CODEX_HOME" ]]; then
  echo "Missing personal CODEX_HOME: $PERSONAL_CODEX_HOME" >&2
  exit 1
fi

if [[ ! -r "$PERSONAL_CODEX_HOME/config.toml" ]]; then
  echo "Missing readable personal Codex config: $PERSONAL_CODEX_HOME/config.toml" >&2
  exit 1
fi

export CODEX_HOME="$PERSONAL_CODEX_HOME"
export CODEX_SQLITE_HOME="$PERSONAL_CODEX_HOME"
export PATH={q(codex_bin_dir)}:"$PATH"

unset OPENAI_API_KEY
unset CODEX_API_KEY
unset OPENAI_BASE_URL
unset OPENAI_ORG_ID
unset OPENAI_PROJECT_ID
{proxy}
run_codex() {{
  "$CODEX_BIN" "$@" 2> >(grep -v "failed to clean up stale arg0 temp dirs" >&2)
}}

case "${{1:-}}" in
  --version|-V|version|--help|-h|help)
    run_codex "$@"
    exit $?
    ;;
  app-server)
    cd "${{ALLOWED_WORKDIRS[0]}}"
    run_codex "$@"
    exit $?
    ;;
esac

WORKDIR="$PWD"
if [[ $# -gt 0 ]]; then
  case "$1" in
    /*|.|..|./*|../*)
      WORKDIR="$1"
      shift
      ;;
  esac
fi

if [[ ! -d "$WORKDIR" ]]; then
  echo "Requested workspace does not exist: $WORKDIR" >&2
  exit 1
fi

WORKDIR="$(cd -P "$WORKDIR" && pwd)"

allowed=false
for allowed_workdir in "${{ALLOWED_WORKDIRS[@]}}"; do
  allowed_workdir="$(cd -P "$allowed_workdir" && pwd)"
  if [[ "$WORKDIR" == "$allowed_workdir" || "$WORKDIR" == "$allowed_workdir"/* ]]; then
    allowed=true
    break
  fi
done

if [[ "$allowed" != true ]]; then
  echo "Refusing to start codex-wjs outside allowed workspaces:" >&2
  printf "  %s\\n" "${{ALLOWED_WORKDIRS[@]}}" >&2
  echo "Requested: $WORKDIR" >&2
  exit 1
fi

cd "$WORKDIR"
run_codex "$@"
exit $?
"""


def render_codex_wjs(args: argparse.Namespace) -> str:
    return f"""#!/usr/bin/env bash
set -euo pipefail
exec {q(args.personal_root + '/start_codex.sh')} "$@"
"""


def render_bashrc_extras(args: argparse.Namespace) -> str:
    proxy_funcs = ""
    if args.proxy_url:
        proxy_funcs = f"""
_wjs_proxy_url={q(args.proxy_url)}

proxyon() {{
  export http_proxy="$_wjs_proxy_url" https_proxy="$_wjs_proxy_url"
  echo "Proxy enabled: http_proxy=$http_proxy"
}}

proxyoff() {{
  unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY all_proxy ALL_PROXY no_proxy NO_PROXY
  echo "Proxy disabled"
}}
"""
    return f"""# WJS personal shell extras. Does not redefine bare codex.
[[ -n "${{_WJS_EXTRAS_LOADED:-}}" ]] && return 0
_WJS_EXTRAS_LOADED=1

export PATH={q(args.personal_root + '/bin')}:{q(args.personal_root + '/.local/bin')}:$PATH
{proxy_funcs}"""


def render_autoload(args: argparse.Namespace) -> str:
    cases = "|".join(f"{root}|{root}/*" for root in args.allowed_root)
    return f"""# Optional: source from a personal rc to expose codex-wjs only in allowed workspaces.
case "${{PWD:-}}" in
  {cases})
    if [[ -z "${{_WJS_EXTRAS_LOADED:-}}" && -f {q(args.personal_root + '/.bashrc-wjs-extras.sh')} ]]; then
      source {q(args.personal_root + '/.bashrc-wjs-extras.sh')}
    fi
    ;;
esac
"""


def render_bashrc_wjs(args: argparse.Namespace) -> str:
    return f"""# Personal interactive shell for WJS Codex isolation.
# Bare codex remains the global/shared command; use codex-wjs for personal Codex.
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


def render_ssh_block(args: argparse.Namespace) -> str:
    identity = (
        f"    IdentityFile {args.identity_file}\n    IdentitiesOnly yes\n"
        if args.identity_file
        else ""
    )
    return f"""Host {args.host_alias}
    HostName {args.hostname}
    Port {args.port}
    User {args.user}
{identity.rstrip()}

# Optional terminal-only personal shell. It exposes codex-wjs but leaves codex global.
Host {args.host_alias}_wjs
    HostName {args.hostname}
    Port {args.port}
    User {args.user}
{identity.rstrip()}
    RequestTTY yes
    RemoteCommand bash --rcfile {args.personal_root}/.bashrc-wjs -i
"""


def render_install_notes(args: argparse.Namespace) -> str:
    return f"""# Install Notes

1. Create directories:

   install -d -m 755 {args.personal_root} {args.personal_root}/bin {args.personal_root}/.local/bin
   install -d -m 700 {args.codex_home}
   touch {args.codex_home}/config.toml && chmod 600 {args.codex_home}/config.toml

2. Install files:

   install -m 755 start_codex.sh {args.personal_root}/start_codex.sh
   install -m 755 bin-codex-wjs {args.personal_root}/bin/codex-wjs
   install -m 644 .bashrc-wjs .bashrc-wjs-extras.sh .bashrc-wjs-autoload.sh {args.personal_root}/

3. Verify explicit-only behavior:

   codex --version
   {args.personal_root}/bin/codex-wjs --version
   cd /tmp && {args.personal_root}/bin/codex-wjs exec --help
   cd {args.allowed_root[0]} && {args.personal_root}/bin/codex-wjs --version

Do not install a file named codex for WJS routing.
"""


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output-dir", required=True)
    parser.add_argument("--personal-root", default="/data_team/junsong")
    parser.add_argument("--codex-home", default="")
    parser.add_argument("--codex-bin", default="/usr/bin/codex")
    parser.add_argument("--allowed-root", action="append", default=[])
    parser.add_argument("--proxy-url", default="")
    parser.add_argument("--host-alias", default="server")
    parser.add_argument("--hostname", default="PLACEHOLDER_HOSTNAME")
    parser.add_argument("--port", default="22")
    parser.add_argument("--user", default="root")
    parser.add_argument("--identity-file", default="~/.ssh/id_ed25519")
    args = parser.parse_args()

    if not args.codex_home:
        args.codex_home = args.personal_root + "/.codex-home"
    if not args.allowed_root:
        args.allowed_root = [args.personal_root]

    out = Path(args.output_dir)
    out.mkdir(parents=True, exist_ok=True)
    files = {
        "start_codex.sh": render_start_codex(args),
        "bin-codex-wjs": render_codex_wjs(args),
        ".bashrc-wjs": render_bashrc_wjs(args),
        ".bashrc-wjs-extras.sh": render_bashrc_extras(args),
        ".bashrc-wjs-autoload.sh": render_autoload(args),
        "ssh-config-block.txt": render_ssh_block(args),
        "install-notes.md": render_install_notes(args),
    }
    for name, content in files.items():
        path = out / name
        path.write_text(content, encoding="utf-8")
        if name in {"start_codex.sh", "bin-codex-wjs"}:
            path.chmod(0o755)
    print(f"Rendered {len(files)} explicit-only files into {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
