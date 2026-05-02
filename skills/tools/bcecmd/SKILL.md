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
configured, see [REFERENCE.md](REFERENCE.md#new-server-setup).

## Upload

For repeatable dataset uploads, prefer `sync`:

```bash
SRC=/absolute/local/dataset/path
DST=bos:/bucket-name/project/dataset-name/

bcecmd bos sync "$SRC" "$DST" --dryrun
bcecmd bos sync "$SRC" "$DST" --yes --concurrency 16
```

Use a trailing slash on the BOS destination when the intent is to put a
directory's contents under a prefix.

For simple recursive copies:

```bash
bcecmd bos cp ./testbcecmd/ bos:/lab-test/test -r
```

## Download

For repeatable downloads:

```bash
bcecmd bos sync bos:/bucket-name/project/dataset-name/ ./dataset-name --yes
```

For simple recursive copies:

```bash
bcecmd bos cp bos:/lab-test/test/ test_download -r
```

For large BOS-to-GPU/PFS transfers, prefer the platform data-flow feature when
available. See [REFERENCE.md](REFERENCE.md#large-dataset-download-via-pfs-data-flow).

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

Use [REFERENCE.md](REFERENCE.md) for new-server setup, credential configuration,
bucket naming, PFS data flow, and common errors.
