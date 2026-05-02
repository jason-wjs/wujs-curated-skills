# Claude Code Adapter

Claude Code consumes skills as directories under:

```text
~/.claude/skills/<skill-name>/
```

Each installed skill directory should contain `SKILL.md` and any adjacent
reference files, scripts, or assets.

## Install

```bash
bash scripts/install.sh --tool claude
```

Development symlink install:

```bash
bash scripts/install.sh --tool claude --method symlink
```

Include personal skills:

```bash
bash scripts/install.sh --tool claude --include-personal
```

## Behavior

- Default install mode is `copy`.
- Personal skills are skipped unless `--include-personal` is passed.
- Skill names are flattened at install time, e.g.
  `skills/engineering/karpathy-guidelines` installs to
  `~/.claude/skills/karpathy-guidelines`.
