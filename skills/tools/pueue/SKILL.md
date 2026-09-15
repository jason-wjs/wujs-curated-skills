---
name: pueue
description: "Use when managing or troubleshooting local shell-command queues with Pueue/pueued."
---

# Pueue

Use `pueue` to manage long-running shell commands through the local `pueued`
daemon. Treat it as a single-user local task queue: useful between `nohup` or
`tmux` and heavier systems such as Slurm, Airflow, Kubernetes Jobs, or Celery.

## Fit

Use this skill when the user wants to queue shell commands that keep running
after terminal or SSH disconnects; control local parallelism; inspect status,
logs, and completion results; pause, resume, kill, restart, reorder, stash,
delay, group, or add simple dependencies between local tasks; or use JSON
status/log output in small scripts.

Do not present Pueue as a distributed, multi-user, high-throughput, or complex
workflow scheduler. Use a purpose-built scheduler for cluster nodes, central
multi-user access control, durable workflow DAGs, resource-aware placement, or
hundreds of coordinated jobs.

## Safety Rules

- Prefer read-only checks before changing queues: `command -v pueue`,
  `command -v pueued`, `pueue status`, and `pueue group`.
- Confirm intent before destructive operations: `pueue reset`, broad
  `pueue kill`, broad `pueue clean`, or daemon shutdown.
- Preserve shell quoting. When adding commands, quote the whole command unless
  the user explicitly wants local shell expansion before enqueueing.
- Use `--working-directory` when a command must run from a specific path.
- Do not assume Pueue is installed or the daemon is running.

## Quick Start

```bash
command -v pueue
command -v pueued
pueue status
# Start the daemon only if needed.
pueued --daemonize
pueue add --working-directory "$PWD" 'long-running-command --flag value'
pueue status
pueue log <task-id>
pueue follow <task-id>
```

## Operations

Control parallelism, groups, stashing, delay, and dependencies:

```bash
pueue parallel 2
pueue group add downloads --parallel 4
pueue add --group downloads 'curl -LO https://example.com/file'
pueue add --stashed 'expensive-command'
pueue enqueue <task-id>
pueue add --delay 'tomorrow 02:00' 'nightly-command'
first=$(pueue add --print-task-id 'prepare-data')
pueue add --after "$first" 'train-model'
```

Control running work and script against results:

```bash
pueue pause
pueue start
pueue restart <task-id>
pueue kill <task-id>
pueue wait
pueue status --json
pueue log --json <task-id>
```

## Troubleshooting

- If `pueue status` says no config exists, the daemon may never have been
  started for this user.
- If a task starts in the wrong directory, re-add or restart it with
  `--working-directory`.
- If a command behaves differently than expected, check shell quoting and the
  environment captured when the task was added.
- If logs are missing, compare `pueue log <task-id>` with
  `pueue log --json <task-id>` before changing state.

## Trigger Tests

- Should trigger: "Use pueue to queue these training commands"; "Why did my
  Pueue task fail?"; "Run four downloads in parallel with pueued".
- Should not trigger: "Design an Airflow DAG for daily ETL"; "Schedule jobs on
  a multi-node Slurm cluster".
- Keep implicit invocation enabled for local task queue, long-running shell
  command, and `pueued` prompts.
