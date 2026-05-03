# Authoring Guidelines

Use these rules when creating or adapting skills in this repository.

## Frontmatter

- `name` is required and should use lowercase words separated by hyphens.
- `description` is required and must describe trigger conditions, not summarize
  the workflow.
- Front-load the main capability, file types, commands, and trigger words so
  Codex can still match the skill if descriptions are shortened.
- Keep `description` under 1024 characters.
- Preserve `license` or source metadata for adapted skills when applicable.

## Skill Body

- Keep `SKILL.md` focused on runtime instructions.
- Put long examples, reference material, scripts, and assets beside the skill
  and link to them from `SKILL.md`.
- Make boundaries explicit: when to use, when not to use, and what more
  specific skills take precedence.
- Prefer concrete commands, checks, and failure modes over abstract advice.
- Avoid project history in the skill body except for brief attribution.

## Codex Compatibility

- Codex loads each skill's `name`, `description`, and file path first, then
  reads the full `SKILL.md` only after selecting the skill.
- Users can explicitly invoke a skill with `$skill-name`; Codex can also invoke
  a skill implicitly when the prompt matches `description`.
- Add `agents/openai.yaml` only when a skill needs Codex-specific UI metadata,
  tool dependencies, or invocation policy.
- Use `policy.allow_implicit_invocation: false` for skills that should run only
  when explicitly requested.
- Prefer instruction-only skills. Add scripts only for deterministic operations,
  external tooling, repeated generated code, or explicit error handling.
- For every new or materially changed skill, test at least three prompts that
  should trigger it and two prompts that should not.

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
- Run `bash scripts/lint-skills.sh` after changing skill metadata, README
  coverage, or manifest entries.
- Run `bash scripts/test-install.sh` when install behavior or manifest entries
  change.

## Placeholders

Use `PLACEHOLDER:` for intentionally incomplete project-specific details. Do
not use vague TODOs where a future maintainer cannot tell what decision remains.
