# Authoring Guidelines

Use these rules when creating or adapting skills in this repository.

## Frontmatter

- `name` is required and should use lowercase words separated by hyphens.
- `description` is required and should start with "Use when..." when possible.
- Describe trigger conditions in `description`; do not summarize the workflow.
- Preserve `license` or source metadata for adapted skills when applicable.

## Skill Body

- Keep `SKILL.md` focused on runtime instructions.
- Put long examples, reference material, scripts, and assets beside the skill
  and link to them from `SKILL.md`.
- Make boundaries explicit: when to use, when not to use, and what more
  specific skills take precedence.
- Prefer concrete commands, checks, and failure modes over abstract advice.
- Avoid project history in the skill body except for brief attribution.

## Categorization

- Put general code-work behavior in `skills/engineering/`.
- Put concrete external tools and service workflows in `skills/tools/`.
- Put local paths, note systems, and personal preferences in `skills/personal/`.

## Documentation Updates

When adding, removing, renaming, or materially changing a skill:

- Update the relevant bucket `README.md`.
- Update the top-level `README.md` if the skill is promoted or user-visible.
- Update `manifest.json` if the skill should be installed.
- Update `docs/external-sources.md` if the skill is adapted from an upstream
  source.
- Add or update an ADR if the change introduces a durable repository policy.
- Run `bash scripts/test-install.sh` when install behavior or manifest entries
  change.

## Placeholders

Use `PLACEHOLDER:` for intentionally incomplete project-specific details. Do
not use vague TODOs where a future maintainer cannot tell what decision remains.
