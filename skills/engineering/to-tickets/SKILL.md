---
name: to-tickets
description: "Use when splitting an agreed plan into independently verifiable implementation tickets."
disable-model-invocation: true
---

# To Tickets

Read the plan, spec, or discussion and relevant implementation context.
Split work into verifiable outcomes with genuine blocking dependencies. Prefer
vertical slices when useful, but do not require every ticket to touch every
layer. Keep a coherent mechanical refactor together when it can land safely;
use expand/migrate/contract only when deployment or consumer compatibility needs it.

Each ticket should state:
- What it delivers and relevant parent/spec references.
- Acceptance criteria tied to supported behavior.
- Blocking tickets, or none.
- Any unresolved decision that prevents implementation.

Match granularity to work that can be completed and verified coherently. Avoid
speculative prefactoring and tickets whose only purpose is maintaining machinery
the agent introduced without a requirement. Discuss consequential decomposition
choices; do not repeat approval of a breakdown already agreed.

Use the requested destination or `docs/agents/issue-tracker.md`. Otherwise write
local files under `.scratch/<feature-slug>/issues/<NN>-<slug>.md` in dependency
order. Publish externally only within the user's authorization, using native
blocking links if supported or explicit references otherwise. Mark blocked
questions honestly rather than labeling every ticket ready.

Return the ticket locations and dependencies. Creating tickets does not itself
authorize executing them, closing their parent, or clearing the session context.
