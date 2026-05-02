# BCECmd Reference

Detailed setup and troubleshooting notes for `bcecmd`.

## New Server Setup

Use this when a server has never been configured for `bcecmd`.

### Install On Linux

```bash
wget https://doc.bce.baidu.com/bos-optimization/linux-bcecmd-0.5.8.zip
unzip linux-bcecmd-0.5.8.zip
cd linux-bcecmd-0.5.8
sudo ln -s "$(pwd)/bcecmd" /usr/local/bin/bcecmd
```

If `sudo` is unavailable, add the extracted directory to `PATH` for the current
shell or user profile instead of creating the global symlink.

Verify:

```bash
command -v bcecmd
bcecmd --version
```

### Configure Credentials

Run the interactive config command:

```bash
bcecmd -c
```

When prompted, paste the access key and secret key from the approved credential
source, then accept defaults unless the user provides a custom endpoint,
region, or config path.

After configuration, verify with a read-only bucket list:

```bash
bcecmd bos ls
```

If this lists buckets, the server has usable credentials and network access.

Common local credential locations include `~/.go-bcecli/credentials` and
tool-specific config paths passed with `--conf-path`. When inspecting them,
mask values:

```bash
awk -F= '{ if ($0 ~ /^[[:space:]]*$/ || $0 ~ /^[[:space:]]*#/) print $0; else if (NF >= 2) print $1 " = <set>"; else print $0 }' ~/.go-bcecli/credentials
```

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

Set the destination carefully. The destination root is already
`/mnt/pfs/scalelab`. For example, to place data under
`/mnt/pfs/scalelab/dataset`, enter:

```text
/dataset
```

Do not enter `/mnt/pfs/scalelab/dataset` unless the console explicitly asks for
an absolute filesystem path.

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
