---
name: diagnosing-bugs
description: "Use when investigating a hard-to-reproduce bug, an unclear root cause, or a performance regression."
---

# Diagnose Bugs

Establish the user's actual symptom and a way to distinguish a fix from a
plausible explanation. Read relevant code, logs, and project decisions as
needed; forming a hypothesis may be necessary to build a reproduction.

Choose a useful feedback signal: a failing test, CLI fixture, HTTP request,
browser interaction, trace replay, or measured performance baseline. Minimize
the scenario when that improves diagnosis. For intermittent failures, record
reproduction frequency and conditions rather than claiming determinism.

Compare plausible causes using observations that distinguish them. There is
no required hypothesis count or phase order. Avoid speculative fixes based
only on nearby suspicious code. If reproduction is unavailable, continue
useful analysis, label uncertainty, and request only the missing evidence or
access needed to test the conclusion.

For human-only reproduction, [scripts/hitl-loop.template.sh](scripts/hitl-loop.template.sh)
can capture a repeatable observation loop; it is optional and must not capture
credentials or other sensitive input.

## Finish

Fix the demonstrated cause with the smallest appropriate change. Add a
regression test when a meaningful test can exercise the real failure; otherwise
state what was verified and what remains unverified. Recheck the original
symptom, remove temporary instrumentation, and summarize the cause and evidence.

Keep architectural follow-ups separate unless necessary for this fix. A missing
test seam alone does not authorize a redesign. Preserve real boundary checks;
new retries, fallbacks, or compatibility branches need a concrete failure model.
