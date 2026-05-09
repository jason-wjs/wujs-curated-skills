# Cursor Adapter

Cursor discovers Agent Skills from `.cursor/skills/<skill-name>/`. This installer
places them either under the target project (default) or under your user home.

It also installs a rule bridge for routing and index hints:

```text
<project>/.cursor/rules/wujs-curated-skills.mdc   # --cursor-scope project (default)
$HOME/.cursor/rules/wujs-curated-skills.mdc       # --cursor-scope user
```

The bridge lists when to open which `SKILL.md` under this repository's canonical
layout (`skills/<bucket>/<skill>/SKILL.md`) without duplicating full skill bodies
in the rule file.

Promoted skills from `manifest.json` are installed into `.cursor/skills/` by
default. Personal skills are omitted unless you pass `--include-personal`.

## Install

Project scope (default): skills and bridge under `<project>/.cursor/`:

```bash
bash scripts/install.sh --tool cursor --project /path/to/project
```

User scope: skills and bridge under `$HOME/.cursor/` (`--project` is ignored
for Cursor in this mode):

```bash
bash scripts/install.sh --tool cursor --cursor-scope user
```

Development symlink install:

```bash
bash scripts/install.sh --tool cursor --project /path/to/project --method symlink
bash scripts/install.sh --tool cursor --cursor-scope user --method symlink
```

Install to the current project (project scope):

```bash
bash scripts/install.sh --tool cursor
```

## Behavior

- Default install mode is `copy`.
- Default Cursor scope is `project`: one directory per skill under
  `<project>/.cursor/skills/`, bridge under `<project>/.cursor/rules/`.
- With `--cursor-scope user`, the same layout is written under `$HOME/.cursor/`.
- The canonical skill sources remain under `skills/<bucket>/<skill>/SKILL.md`.
- Run `bash scripts/lint-skills.sh` after changing promoted skills so the
  bridge stays aligned with `manifest.json`.
