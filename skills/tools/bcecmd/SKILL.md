---
name: bcecmd
description: Use Baidu BCE BOS through the bcecmd CLI. Use when checking bcecmd setup, listing BOS buckets or prefixes, uploading/downloading datasets, validating transfers, choosing BOS paths, or troubleshooting BOS transfer failures.
---

# BCECmd

Use `bcecmd` for Baidu BCE/BOS object storage. Treat BOS paths as object
prefixes, not real directories:

```bash
bos:/bucket-name/prefix/path/
```

## Safety Rules

- Never print access keys, secret keys, STS tokens, or full credential files.
- Never write access keys, secret keys, or passwords into repository files.
- Run a read-only check before writes: `bcecmd --version`, `bcecmd bos ls`, or
  `bcecmd bos ls bos:/bucket/prefix/`.
- Do not use deletion or mirror behavior unless the user explicitly asks for
  remote extras to be removed.
- Prefer user-specific prefixes inside shared buckets.
- If network/DNS fails in the sandbox but the operation is needed, rerun the
  same command with the normal approval/escalation flow.

## Quick Start

Check installation and credentials:

```bash
command -v bcecmd
bcecmd --version
bcecmd bos ls
```

If `bcecmd` is missing or `bcecmd bos ls` fails because the server is not
configured, see [setup-and-troubleshooting.md](references/setup-and-troubleshooting.md#new-server-setup).

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
available. See [setup-and-troubleshooting.md](references/setup-and-troubleshooting.md#large-dataset-download-via-pfs-data-flow).

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

## More Detail

Use [setup-and-troubleshooting.md](references/setup-and-troubleshooting.md) for
new-server setup, credential configuration, bucket naming, PFS data flow, and
common errors.
