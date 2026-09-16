# Authoring Guidelines

Use these rules when creating or adapting skills in this repository.

## Curation Principles

Keep guidance that changes the agent's decisions: task-specific knowledge,
personal preferences, real operational constraints, and useful command
entrypoints. Describe outcomes and decision criteria; reserve fixed sequences
for operations whose ordering matters. Load references and use optional tools
only when the task needs them. Honor existing authorization without adding
repeated approval gates.

Curate individual upstream skills through deliberate review. Preserve their
attribution and licenses in the skill and record sources in
[external-sources.md](external-sources.md). Maintain adapted content locally;
do not bulk-copy collections or automatically synchronize upstream changes.
Keep one canonical source across harnesses instead of model-specific copies.

Preserve concrete operational safeguards, including shared-server ownership
and rollback. Credential entry must bypass model context; an ordinary chat
question dialog does not provide that guarantee.

Evaluate usefulness through real tasks and observed failures. Installation
checks establish packaging compatibility, not writing or reasoning quality.
Avoid prescribed review chains and tests for speculative requirements.

These principles follow
[Rethinking skills and prompts for GPT-6 Astra](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra).

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
- Put writing tasks and their reference examples in `skills/writing/`.
- Put human-readable writing companions in `for-humans/writing/`.
- Put concrete external tools and service workflows in `skills/tools/`.
- Categorize by capability. Discover local paths, identities, and vault
  conventions at use time instead of baking in the curator’s environment.

## Documentation Updates

When adding, removing, renaming, or materially changing a skill:

- Update the relevant bucket `README.md`.
- Update the top-level `README.md` when the skill catalog changes.
- Update `manifest.json` if the skill should be installed.
- Update `docs/external-sources.md` if the skill is adapted from an upstream
  source.
- Update policies and their rationale in the relevant maintained document;
  keep historical change narratives in Git history.
- Run `bash scripts/lint-skills.sh` after changing skill metadata, README
  coverage, or manifest entries.
- Run `bash scripts/test-install.sh` when install behavior or manifest entries
  change.

## Placeholders

Use `PLACEHOLDER:` for intentionally incomplete project-specific details. Do
not use vague TODOs where a future maintainer cannot tell what decision remains.
