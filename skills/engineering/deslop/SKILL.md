---
name: deslop
description: "Use when simplifying a diff with unnecessary defensive branches, fallback behavior, or abstraction."
---

# Deslop

Inspect the requested diff and its callers. Include uncommitted and untracked
changes when they are in scope; use the actual branch base rather than assuming
`main`. Find complexity introduced without an independent requirement.

For a suspicious check, catch, retry, default, or compatibility branch, identify
which supported input or reachable failure needs it and what the caller should
observe. Validate at external boundaries; use established contracts inside them.

Simplify redundant internal validation, exception handlers that hide failure,
unsupported fallback behavior, and abstractions without a current purpose.
A test or document added for the same speculative mechanism is not evidence
that the mechanism is required. Preserve supported behavior, security checks,
resource cleanup, and real I/O recovery. If the contract is unclear, investigate
before removing the defense.

Keep the change local. Fix type errors instead of suppressing them; do not
weaken tests to disguise a regression. Run relevant checks and summarize the
removed complexity, preserved behavior, and any unresolved cases.

This is an on-demand cleanup. It does not require another review workflow or
automatically run after every edit.
