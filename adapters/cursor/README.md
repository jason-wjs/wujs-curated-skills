# Cursor Adapter

Cursor does not directly consume Agent Skills directories. This repository
provides a project-local rule bridge:

```text
<project>/.cursor/rules/wujs-curated-skills.mdc
```

The bridge points Cursor at the canonical skill sources in this repository
without duplicating full skill bodies.

The bridge tracks promoted skills from `manifest.json`. Personal skills are not
included in the default Cursor bridge because they are environment-specific.

## Install

```bash
bash scripts/install.sh --tool cursor --project /path/to/project
```

Development symlink install:

```bash
bash scripts/install.sh --tool cursor --project /path/to/project --method symlink
```

Install to the current project:

```bash
bash scripts/install.sh --tool cursor
```

## Behavior

- Default install mode is `copy`.
- Cursor installs only the `.mdc` bridge, not every skill directory.
- The canonical skill sources remain under `skills/<bucket>/<skill>/SKILL.md`.
- Run `bash scripts/lint-skills.sh` after changing promoted skills so the
  bridge stays aligned with `manifest.json`.
