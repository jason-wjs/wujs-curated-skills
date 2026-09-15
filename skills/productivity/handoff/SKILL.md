---
name: handoff
description: "Use when preparing another session or agent to continue work in progress."
---

# Handoff

Write a concise, redacted continuation note. Use the requested destination or
an OS temporary directory, and return the absolute path. Temporary files may
not be available on another host; state that when handing off across machines.

Capture the goal, current state, decisions and authorization already given,
remaining work, blockers, relevant verification, and the next useful action.
Include failed attempts only when they prevent repeated work. Distinguish
observed facts from assumptions.

Reference existing specs, plans, ADRs, commits, and diffs rather than copying
them. Include relevant branch/worktree information. Suggest skills only when
they offer a concrete benefit. Exclude credentials and sensitive transcripts.

This note records execution state; it does not replace the requirements spec.
