# BCECmd Reference

Detailed setup and troubleshooting notes for `bcecmd`.

## New Server Setup

Use this when a server has never been configured for `bcecmd`.

### Install On Linux

Use the current approved `bcecmd` binary source for the environment. If the
example version below is unavailable, ask the user for the approved download
location instead of guessing a replacement.

```bash
wget https://doc.bce.baidu.com/bos-optimization/linux-bcecmd-0.5.8.zip
unzip linux-bcecmd-0.5.8.zip
cd linux-bcecmd-0.5.8
sudo ln -s "$(pwd)/bcecmd" <bin-dir>/bcecmd
```

If `sudo` is unavailable, add the extracted directory to `PATH` for the current
shell or user profile instead of creating the global symlink.

Verify:

```bash
command -v bcecmd
bcecmd --version
```

### Configure Credentials

First check whether existing credentials work with a read-only operation on
the requested BOS prefix. Do not request fresh keys when setup already works.

If credentials are needed, explicitly hand credential entry to the user:

- Use a dedicated secret-entry control only when its documented contract
  writes directly to the credential destination or secret store without
  returning values to the model, tool results, or logs. A masked display alone
  is insufficient. Ordinary chat/question tools are not secret-entry controls.
- If no such control is available, ask the user to run the following command
  directly in their own terminal on the target host, under the intended account
  and configuration path. Do not run the credential-entry session through
  agent-controlled stdin or capture its screen, transcript, or output.

```bash
bcecmd -c
```

The user enters AK/SK from their credential source directly into that session.
Do not claim the CLI masks input unless verified for the installed version.
Use the agreed endpoint, region, and config path; preserve unrelated settings.
On a shared account, use the agreed personal configuration rather than
overwriting shared credentials. Ask the user to report only completion or a
redacted error, never the keys or a configuration transcript.

After configuration, verify with a read-only bucket list:

```bash
bcecmd bos ls
```

If this lists buckets, the server has usable credentials and network access.

Common local credential locations include `~/.go-bcecli/credentials` and
tool-specific config paths passed with `--conf-path`. Inspect only existence,
ownership, and permissions when needed; do not read or print their contents.
Prefer a read-only request to the intended prefix when bucket listing is not
permitted. Report only authentication/access status, with sensitive error
details redacted.

## Bucket Choice

Use bucket names with lowercase letters, digits, and hyphens. Avoid
underscores.

```bash
bcecmd bos mb bos:/my-project-bucket
```

If bucket creation fails due to permission or name conflicts, use an agreed
shared bucket with a clear prefix:

```bash
bos:/deliver/<user-or-project>/path/
```

## Sync Vs Recursive Copy

Prefer `sync` for dataset directories because it is repeatable and can
resume/skip already synced files:

```bash
bcecmd bos sync "$SRC" "$DST" --dryrun
bcecmd bos sync "$SRC" "$DST" --yes --concurrency 16
```

Use `cp -r` for simple one-off copies when repeatability is less important:

```bash
bcecmd bos cp "$SRC" "$DST" -r
```

Avoid `--restart` unless intentionally disabling breakpoint continuation.

## Large Dataset Download Via PFS Data Flow

When downloading large datasets from BOS to GPU/PFS storage, prefer the
platform's data-flow feature if available instead of pulling everything through
`bcecmd` on the login node.

Use the console path:

```text
pfs -> gpu-pfs -> data flow -> create task
```

Set the destination carefully. The destination root is already selected by the console. For example, to place
data under `<pfs-destination-root>/dataset`, enter the relative destination:

```text
dataset
```

Do not enter a full filesystem path unless the console explicitly asks for
one.

## Common Errors

- `illegal character : _`: bucket name contains `_`; replace with `-`.
- DNS or `lookup ... Temporary failure in name resolution`: network access
  failed; retry with proper network access/approval.
- Permission error creating bucket: credentials can use BOS but cannot create
  buckets; ask an admin to create one or use an approved bucket prefix.
- `more......` after `bos ls`: output is truncated/paginated by the tool; list
  a narrower prefix to inspect specific content.
- `bcecmd: command not found`: install it or add the extracted
  `linux-bcecmd-*` directory to `PATH`.
- `bcecmd bos ls` fails after `bcecmd -c`: credentials may be wrong, expired,
  or missing BOS permissions; reconfigure from the approved credential source.
- `bcecmd bos ls` OK but `bos ls bos:/bucket/...` Access Denied: try
  `UsePathStyle = no` in `~/.go-bcecli/config`; also check blank `Region`/
  `Domain` from a bad non-interactive `bcecmd -c`.
