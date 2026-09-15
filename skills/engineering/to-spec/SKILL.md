---
name: to-spec
description: "Use when turning an aligned discussion into requirements and acceptance criteria for implementation."
disable-model-invocation: true
---

# To Spec

Capture what is to be built and how completion will be judged. Synthesize the
conversation and relevant repository evidence without restarting an interview.
Record unresolved consequential choices as open questions; ask only when they
prevent a useful spec. Do not invent requirements to fill a template.

Include the sections the task needs:
- Problem and intended outcome.
- Supported behavior, scope, and meaningful exclusions.
- Agreed contracts and implementation decisions, including their reasons.
- Acceptance criteria and relevant validation strategy.
- Open questions or missing evidence.

Use user stories when they clarify distinct needs. Scale their number and the
document's detail to the task. Link current code and prototypes when useful;
label implementation observations separately from required behavior.

## Destination

Use the user's destination or the project's `docs/agents/issue-tracker.md`.
If no destination is established, save to `.scratch/<feature-slug>/spec.md`
and report the path. Publish externally only when requested or already
authorized. Mark ready for implementation only if blocking questions are resolved.

A spec describes the target. For current execution state, failed attempts, and
next-session instructions, use `handoff` instead; reference the spec there.
