# Cursor Adapter

Cursor discovers Agent Skills from `<project>/.cursor/skills/<skill-name>/` (the
same skill directory layout as other Cursor skills). This repository also
installs a project-local rule bridge for discoverability and routing:

```text
<project>/.cursor/rules/wujs-curated-skills.mdc
```

The bridge lists when to open which `SKILL.md` under this repository's canonical
layout (`skills/<bucket>/<skill>/SKILL.md`) without duplicating full skill bodies
in the rule file.

Promoted skills from `manifest.json` are installed into `.cursor/skills/` by
default. Personal skills are omitted unless you pass `--include-personal`.

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
- Cursor installs one directory per skill under `.cursor/skills/`, mirroring the
  Codex and Claude layouts, and installs the `.mdc` bridge under `.cursor/rules/`.
- The canonical skill sources remain under `skills/<bucket>/<skill>/SKILL.md`.
- Run `bash scripts/lint-skills.sh` after changing promoted skills so the
  bridge stays aligned with `manifest.json`.
