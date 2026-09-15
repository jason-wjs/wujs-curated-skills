---
name: bcecmd
description: "Use when transferring data with bcecmd or configuring and troubleshooting Baidu BOS access."
---

# BCECmd

Use BOS object prefixes (`bos:/bucket/prefix/`) and prefer a personal prefix in
shared buckets. Confirm the intended source and destination. Ordinary transfer
authorization does not imply deleting remote extras or mirroring a bucket.

Check existing access before requesting credentials. AK/SK entry belongs to the
user through a dedicated control proven to keep values out of model context,
tool results, and logs. Ordinary chat/question dialogs are not secret inputs.
Without that capability, use the user's own uncaptured terminal. Never read
credential contents or put secrets in commands or repository files.

## Read what the task needs

- [Transfers](references/transfers.md): copy/sync commands and result checks.
- [Credential setup](references/setup-and-troubleshooting.md#configure-credentials):
  missing or expired credentials, including the user-input handoff.
- [Setup and troubleshooting](references/setup-and-troubleshooting.md): installation,
  bucket naming, permissions, networking, and PFS data-flow selection.

For large BOS-to-GPU/PFS transfers, check whether platform data flow is available
before choosing a login-node transfer. Use the transfer result and destination
checks to establish completion; report failures and incomplete verification.
