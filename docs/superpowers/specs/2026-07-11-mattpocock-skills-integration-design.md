# 2026-07-11 Matt Pocock skills integration design

## Goal

Curate a deliberate subset of [mattpocock/skills](https://github.com/mattpocock/skills)
into this repository (not a bulk mirror), refactor the grill stack to match
upstream's thin-wrapper layout, add the idea→ship pipeline core, and support
optional install pruning of renamed upstream leftovers.

## Scope (approved)

**Include**

- Refactor: `grilling`, `domain-modeling`, thin `grill-me` / `grill-with-docs`
- Pipeline: `to-spec`, `to-tickets`, `implement`, `code-review`
- Discipline: `research`, `codebase-design`
- Upgrade: `diagnosing-bugs` (synced from upstream; formerly local `diagnose`)
- Upgrade: `write-a-skill` (keep process + merge `writing-great-skills` principles)
- Install: `--prune` + `manifest.json` → `deprecated_skill_names`

**Exclude**

- `ask-matt`, `setup-matt-pocock-skills`, `wayfinder`, `triage`, `prototype`,
  `resolving-merge-conflicts`, deprecated/in-progress/misc upstream skills

## Approach

Selected adaptation (not wholesale vendor). Pipeline skills replace Matt's
setup skill with an inline issue-tracker resolution: prefer
`docs/agents/issue-tracker.md` in the *target* project; otherwise ask once
(GitHub via `gh` vs local `.scratch/<feature>/`).

## Install / prune

- Default `copy` still `rm -rf` + recopies each active skill basename.
- `--prune` deletes only basenames listed in `deprecated_skill_names` that are
  not still active under `skills` / `personal`.
- Initial deprecated names: `ask-matt`, `diagnose`,
  `setup-matt-pocock-skills`, `writing-great-skills`.

## Verification

- `bash scripts/lint-skills.sh`
- `bash scripts/test-install.sh` (includes prune smoke test)
