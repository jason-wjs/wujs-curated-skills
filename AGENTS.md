# Repository Instructions

This repository stores curated skills for engineering, writing, and tool
workflows. Keep the canonical skill source under `skills/<bucket>/<skill>/SKILL.md`.

## Buckets

- `skills/engineering/` — general engineering behavior and code-work skills.
- `skills/productivity/` — general planning, writing, and collaboration workflows.
- `skills/writing/` — writing tasks, shared editing preferences, and examples.
- `skills/tools/` — concrete external tools, CLIs, services, and platforms.

## Maintenance Rules

- Every skill directory must contain a `SKILL.md` with `name` and
  `description` frontmatter.
- `description` should describe when to use the skill, not summarize its
  workflow.
- Every bucket must have a `README.md` listing each skill in that bucket with a
  one-line description and a link to `SKILL.md`.
- Top-level `README.md` should list all installable skills.
- `manifest.json` is the installer source of truth for the single skill set.
- Discover environment-specific paths and identities at use time; do not
  default to the curator’s machine or account.
- Adapted third-party skills must preserve source attribution and license
  metadata when applicable.
- When adding, removing, or renaming a skill, update the relevant bucket
  README, top-level README, `manifest.json`, and `docs/external-sources.md` if
  the skill has an upstream source.
- Keep heavy examples, references, scripts, and assets out of `SKILL.md` unless
  they are core to the runtime workflow. Link to them from `SKILL.md` instead.

## Skill Design

- Assume the agent is capable. Add guidance for local knowledge, an explicit
  preference, or an observed failure; avoid generic exhortations.
- Describe narrow triggers and outcomes. Read references only for the current
  task; fixed steps belong where ordering or operational risk requires them.
- Honor existing authorization. Clarify consequential ambiguity, not routine
  implementation choices. Do not add repeated approval gates.
- Tie completion and verification to the requested result. Avoid mandatory
  review chains, agent counts, and tests for invented requirements.
- For code changes, validate external inputs at their boundaries and rely on
  established internal contracts. Fallbacks, retries, and compatibility branches
  need real requirements or reachable failure scenarios. Preserve security,
  resource cleanup, and meaningful error handling.
- Keep canonical skills harness-neutral; optional tools need a usable fallback.
  Match explicit invocation policy in frontmatter and Codex metadata.

## Adapter Rules

- `adapters/` files are tool-specific bridges, not the canonical skill source.
- Do not duplicate full skill bodies in adapter docs.
- If an adapter needs a manifest or generated output, document the source of
  truth and regeneration path.

## Documentation Rules

- Use `CONTEXT.md` for repository terminology and project model.
- Keep human writing guides and their editable sources under `for-humans/writing/`,
  separate from installed skills. Private corpora remain outside the repository.
- Writing skills share `skills/writing/general-writing/references/editing-contract.md`;
  link to it instead of prescribing duplicate editing pipelines.
- Keep current policies and their rationale in the relevant maintained document;
  use Git history for past changes rather than separate decision records.
- Use `.out-of-scope/` only if repeated requests need an explicit rejection
  record.

## Verification

- Run `bash scripts/lint-skills.sh` after skill or reference changes.

- Run `bash scripts/test-install.sh` after changing `scripts/install.sh`,
  `manifest.json`, adapter paths, or skill install layout.
