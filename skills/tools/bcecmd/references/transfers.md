# BOS Transfers

## Quick Start

Check installation and credentials:

```bash
command -v bcecmd
bcecmd --version
bcecmd bos ls
```

If `bcecmd` is missing or `bcecmd bos ls` fails because the server is not
configured, see [setup-and-troubleshooting.md](setup-and-troubleshooting.md#new-server-setup).

## Upload

For repeatable dataset uploads, prefer `sync`:

```bash
SRC=<local-dataset-path>
DST=bos:/bucket-name/project/dataset-name/

bcecmd bos sync "$SRC" "$DST" --dryrun
bcecmd bos sync "$SRC" "$DST" --yes --concurrency 16
```

Use a trailing slash on the BOS destination when the intent is to put a
directory's contents under a prefix.

For simple recursive copies:

```bash
bcecmd bos cp ./example-data/ bos:/bucket-name/project/example-data/ -r
```

## Download

For repeatable downloads:

```bash
bcecmd bos sync bos:/bucket-name/project/dataset-name/ ./dataset-name --yes
```

For simple recursive copies:

```bash
bcecmd bos cp bos:/bucket-name/project/example-data/ ./example-data -r
```

For large BOS-to-GPU/PFS transfers, prefer the platform data-flow feature when
available. See [setup-and-troubleshooting.md](setup-and-troubleshooting.md#large-dataset-download-via-pfs-data-flow).

## Verify

List the destination prefix:

```bash
bcecmd bos ls bos:/bucket-name/project/dataset-name/
```

For large directories, inspect narrower prefixes or sample files:

```bash
bcecmd bos ls bos:/bucket-name/project/dataset-name/subdir/
```

A successful `sync` summary such as `[N] success, [0] failure` is the primary
success signal.

