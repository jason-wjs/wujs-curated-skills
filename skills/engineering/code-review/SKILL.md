---
name: code-review
description: "Use when reviewing a PR, branch, commit range, or uncommitted changes for actionable defects and requirement gaps."
---

# Code Review

Establish the requested review scope from the user and repository state.
For a branch, compare against its actual base with `git diff <base>...HEAD`.
For current work, inspect staged and unstaged diffs and relevant untracked
files; `...HEAD` alone excludes these. Use explicit two-point comparisons when
the user requests an exact commit range. Ask only if ambiguity changes scope.

Read the relevant requirements, callers, tests, and repository conventions.
Use the conversation as a requirements source when no separate spec exists;
absence of a spec is not a reason to block a code review.

Review both:
- Correctness and requirements: regressions, missing behavior, security,
  failure handling, and changes outside the agreed scope.
- Maintainability: concrete complexity or contract problems, including
  unnecessary internal checks, swallowed exceptions, and speculative fallbacks.

Trace whether a defense serves a real input boundary or reachable failure.
Keep necessary validation and recovery. Style preferences and generic code
smells alone are not actionable findings; omit issues already enforced by tools.

Use separate reviewers only when available, authorized, and useful for the
scope. Otherwise review locally. Consolidate duplicate findings and rank by
impact regardless of review axis.

Report actionable findings with file/line, triggering conditions, consequence,
and a suggested direction. Separate uncertainty from confirmed defects. If
none are found, say so and mention material verification limits. A review
request does not itself authorize implementing fixes or posting comments.
