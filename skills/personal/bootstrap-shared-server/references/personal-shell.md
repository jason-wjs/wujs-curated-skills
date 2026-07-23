# Personal Shell

## Layout

```text
PERSONAL_ROOT/
├── .bashrc-wjs
├── .bashrc-wjs-extras.sh
└── bin/
```

Use Bash only after verifying the target supports it. For another shell,
design a separate personal rc instead of forcing Bash semantics.

## Personal rc

The personal rc may source the shared rc once, then load personal additions:

```bash
if [[ -z "${_WJS_GLOBAL_BASHRC_SOURCED:-}" ]]; then
  _WJS_GLOBAL_BASHRC_SOURCED=1
  [[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
fi

if [[ -z "${_WJS_EXTRAS_LOADED:-}" ]]; then
  source <personal-root>/.bashrc-wjs-extras.sh
fi
```

Personal extras may:

- prepend `PERSONAL_ROOT/bin`;
- set a validated `WJS_CODEX_PROFILE`;
- define namespaced helpers such as `wjs_proxy_on/off`;
- add personal non-secret aliases.

They must not:

- define or alias bare `codex`;
- export a proxy automatically;
- contain credentials;
- modify shared rc files;
- assume a hostname copied from another cluster.

## SSH behavior

For terminal-only use, a `RemoteCommand` can open a personal rc. Do not use
that design when Codex App or other tools send remote commands.

For an App-capable `*_wjs` alias, use the forced dispatcher described in
[codex-app-ssh.md](./codex-app-ssh.md). A no-command session opens
`.bashrc-wjs`; ordinary commands receive only personal extras.

## Shared storage

When multiple nodes share `PERSONAL_ROOT`, the common rc must resolve the
profile from a dispatcher variable or a validated hostname map. Unknown or
mismatched hosts fail closed. Never let the last configured node overwrite
another node's profile.

## Verification

```bash
ssh <base-alias> 'printf "%s\n" "$PATH"'
ssh <wjs-alias> 'printf "%s\n" "$WJS_CODEX_PROFILE"; command -v codex-wjs'
ssh <wjs-alias> 'type -a codex 2>/dev/null || true'
```

The shared route remains unchanged, and the personal App wrapper named
`codex` must not appear in ordinary PATH.

