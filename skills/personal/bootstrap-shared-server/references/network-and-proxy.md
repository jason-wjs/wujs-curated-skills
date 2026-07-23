# Network and Proxy

Proxy configuration is optional. Select it from current measurements, not from
the previous host's configuration.

## Selection order

1. Direct server egress.
2. Stable cluster/server proxy with a suitable exit region.
3. SSH reverse tunnel from an always-on personal machine.
4. Stop and report no reliable route.

Classify OpenAI and GitHub independently. Direct GitHub may work while OpenAI
auth is blocked, or the reverse may be true.

Distinguish:

- DNS, timeout, or TLS failure;
- HTTP region restriction;
- successful auth but failed API/App endpoint;
- GitHub authentication failure unrelated to networking.

## Scope

- `codex-wjs` applies its selected OpenAI proxy to the Codex process.
- Git repositories receive `http.proxy`/`https.proxy` only when GitHub needs
  that route.
- `.bashrc-wjs-extras.sh` may define manual `wjs_proxy_on/off` for ad hoc shell
  operations.

Do not export a proxy automatically for every shell. A stale endpoint can make
SSH-launched tools hang.

## Manual helper

```bash
wjs_proxy_on() {
  local url=http://127.0.0.1:<remote-port>
  export http_proxy="$url" https_proxy="$url"
  export HTTP_PROXY="$url" HTTPS_PROXY="$url"
  export NO_PROXY=localhost,127.0.0.1
  export no_proxy="$NO_PROXY"
}

wjs_proxy_off() {
  unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
  unset all_proxy ALL_PROXY no_proxy NO_PROXY
}
```

Use namespaced names unless compatibility with existing helpers is explicitly
required.

## Reverse tunnel

Use only when the proxy machine is expected to stay awake:

```bash
autossh -M 0 -N -T \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  -R 127.0.0.1:<remote-port>:127.0.0.1:<proxy-port> \
  <base-alias>
```

Bind the remote listener to loopback. Allocate and document one remote port per
host/profile.

Prefer a user systemd unit on the proxy machine:

```ini
[Unit]
Description=WJS reverse proxy for <profile>
After=network-online.target
Wants=network-online.target

[Service]
Environment=AUTOSSH_GATETIME=0
ExecStart=/usr/bin/autossh -M 0 -N -T \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  -R 127.0.0.1:<remote-port>:127.0.0.1:<proxy-port> \
  <base-alias>
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
```

Enable the unit and linger only after approval. Linger survives logout, not
sleep, shutdown, proxy failure, network loss, expired SSH access, or a changed
server endpoint.

## Verification

Check:

- local proxy listener;
- user unit `ActiveState`, `SubState`, and restart count;
- remote loopback listener and port ownership;
- bounded OpenAI/GitHub requests through the selected route;
- clear failure when the tunnel is stopped;
- no silent fallback to an unapproved route.

Other people using the same remote UID can deliberately use the loopback
listener. Scoping prevents accidental use, not access.

