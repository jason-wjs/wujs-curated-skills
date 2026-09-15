---
name: write-a-skill
description: "Use when creating or revising a reusable agent skill."
---

# Write a Skill

Identify the recurring task and what the agent needs beyond its existing
capabilities: local knowledge, a chosen convention, a fragile operation, or a
failure observed in practice. Use information already supplied before asking.

Write a narrow description that distinguishes this task from adjacent tasks.
Keep the entrypoint focused on the intended outcome, decision criteria, and
constraints that actually affect execution. Use ordered steps only when order
matters. Put conditional detail in linked references and repeated deterministic
operations in scripts. A short skill needs neither a router nor a line quota.

Preserve existing authorization. Ask about unresolved scope or consequential
choices; do not insert draft approval or per-step confirmation by default.
Keep completion tied to the user's deliverable, including necessary validation.

## Portability

- Canonical source here is `skills/<bucket>/<name>/SKILL.md`.
- Include `name` and a concise `description` in YAML frontmatter.
- Preserve invocation policy. For an explicitly requested user-only skill,
  set `disable-model-invocation: true` for Claude Code/Cursor and
  `policy.allow_implicit_invocation: false` in `agents/openai.yaml` for Codex.
- Resolve references relative to the skill file and scripts relative to the
  skill directory, not the task's working directory.
- Use available harness tools; provide a local alternative to optional agents
  or integrations. Do not assume a particular tool API exists everywhere.
- Update the manifest, bucket README, top README, and applicable source records.
  Preserve upstream license and attribution when adapting material.

## Check the result

Try representative matching and non-matching requests. Inspect whether the
skill would load unnecessary material, stop prematurely, or expand the task.
Check linked resources and run changed scripts with safe fixtures. For install
layout or manifest changes, run `bash scripts/test-install.sh`.

Use actual failures to refine the skill. Do not claim behavioral effectiveness
from formatting checks alone. See [GLOSSARY.md](GLOSSARY.md) for local terms.
