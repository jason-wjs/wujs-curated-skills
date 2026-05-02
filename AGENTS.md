# Repository Instructions

This repository stores curated skills for agentic coding tools. Keep the
canonical skill source under `skills/<bucket>/<skill>/SKILL.md`.

## Buckets

- `skills/engineering/` — general engineering behavior and code-work skills.
- `skills/productivity/` — general planning, writing, and collaboration workflows.
- `skills/tools/` — concrete external tools, CLIs, services, and platforms.
- `skills/personal/` — Wu Junsong-specific workflows, paths, and preferences.

## Maintenance Rules

- Every skill directory must contain a `SKILL.md` with `name` and
  `description` frontmatter.
- `description` should describe when to use the skill, not summarize its
  workflow.
- Every bucket must have a `README.md` listing each skill in that bucket with a
  one-line description and a link to `SKILL.md`.
- Top-level `README.md` should list promoted skills. Personal skills may be
  listed separately as environment-specific.
- `manifest.json` is the installer source of truth for promoted and personal
  skill sets.
- Adapted third-party skills must preserve source attribution and license
  metadata when applicable.
- When adding, removing, or renaming a skill, update the relevant bucket
  README, top-level README, `manifest.json`, and `docs/external-sources.md` if
  the skill has an upstream source.
- Keep heavy examples, references, scripts, and assets out of `SKILL.md` unless
  they are core to the runtime workflow. Link to them from `SKILL.md` instead.

## Adapter Rules

- `adapters/` files are tool-specific bridges, not the canonical skill source.
- Do not duplicate full skill bodies in adapter docs.
- If an adapter needs a manifest or generated output, document the source of
  truth and regeneration path.

## Documentation Rules

- Use `CONTEXT.md` for repository terminology and project model.
- Use `docs/adr/` for durable design decisions.
- Use `.out-of-scope/` only if repeated requests need an explicit rejection
  record.

## Verification

- Run `bash scripts/test-install.sh` after changing `scripts/install.sh`,
  `manifest.json`, adapter paths, or skill install layout.
