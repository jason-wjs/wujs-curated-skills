---
name: pueue
description: "Use when the user requests Pueue/pueued or an existing Pueue queue needs inspection, task submission, or troubleshooting."
---

# Pueue

Operate the intended daemon’s shell-command queue. Establish the target host,
user, configuration/profile, and queue state before submitting or changing
work; a reachable local client may target a remote daemon. A generic long
command does not by itself require adopting Pueue.

## Commands and versions

Use the installed `pueue --version` and relevant subcommand `--help` for syntax.
Inspect status and groups to reuse the existing setup. Match client and daemon
versions when diagnosing compatibility problems. Consult the official
[release notes](https://github.com/Nukesor/pueue/releases) for that version;
unreleased changes on main are not installed capabilities. In particular,
v3-to-v4 migration changes state/protocol compatibility. Do not upgrade,
restart the daemon, or reset queues as a routine troubleshooting shortcut.

## Submission and control

- Select explicit task IDs or a dedicated group. Scope parallelism, pause,
  restart, and cleanup to the requested work; queue-wide changes can affect
  unrelated jobs. Honor existing authorization and clarify only missing scope.
- Set the working directory deliberately. Preserve the intended shell quoting
  and distinguish expansion at submission time from expansion during execution.
  Check the configured task shell/environment when commands differ from an
  interactive session; interactive aliases and rc files may not be available.
- Keep the workload in the foreground inside Pueue. An extra `&` or daemonizing
  child can make Pueue report completion while the real work continues.
- Inspect failure status and logs before retrying. Restarting can repeat side
  effects, so use the task’s actual recovery behavior rather than blind retries.

Report submitted task IDs, target daemon/group, and current state. Submission
is sufficient for a queue-only request; when completion is requested, verify
exit results and relevant outputs before claiming success. Use structured
status/log output when available and keep diagnostic stderr separate from JSON.

For shell and daemon pitfalls, consult the official
[troubleshooting guide](https://github.com/Nukesor/pueue/wiki/Common-Pitfalls-and-Debugging)
as needed.
