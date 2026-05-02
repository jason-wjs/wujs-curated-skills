# Codex Adapter

Codex consumes skills as directories under:

```text
${CODEX_HOME:-~/.codex}/skills/<skill-name>/
```

Each installed skill directory should contain `SKILL.md` and any adjacent
reference files, scripts, or assets.

## Install

```bash
bash scripts/install.sh --tool codex
```

Development symlink install:

```bash
bash scripts/install.sh --tool codex --method symlink
```

Include personal skills:

```bash
bash scripts/install.sh --tool codex --include-personal
```

## Behavior

- Default install mode is `copy`.
- Personal skills are skipped unless `--include-personal` is passed.
- Skill names are flattened at install time, e.g.
  `skills/tools/bcecmd` installs to `~/.codex/skills/bcecmd`.
