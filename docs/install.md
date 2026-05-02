# Install

Use `scripts/install.sh` to install curated skills for Codex, Claude Code, or
Cursor.

The installer reads [manifest.json](../manifest.json). Skills under `skills`
are installed by default; skills under `personal` are installed only with
`--include-personal`.

## Quick Start

```bash
# Codex
bash scripts/install.sh --tool codex

# Claude Code
bash scripts/install.sh --tool claude

# Cursor, current project
bash scripts/install.sh --tool cursor

# All supported targets
bash scripts/install.sh --tool all
```

Default install mode is `copy`.

## Options

```bash
bash scripts/install.sh --tool <codex|claude|cursor|all> [options]
```

- `--method copy|symlink` — install by copying files or creating symlinks.
- `--project <path>` — Cursor project path. Defaults to the current directory.
- `--include-personal` — include skills under `skills/personal/`.

## Install Paths

| Tool | Installed Path |
|------|----------------|
| Codex | `${CODEX_HOME:-~/.codex}/skills/<skill-name>` |
| Claude Code | `~/.claude/skills/<skill-name>` |
| Cursor | `<project>/.cursor/rules/wujs-curated-skills.mdc` |

Codex and Claude Code receive one directory per installed skill. Cursor receives
a `.mdc` bridge rule because it does not directly consume Agent Skills
directories.

## Personal Skills

Skills under `skills/personal/` are skipped by default because they contain
local paths or preferences. Install them explicitly:

```bash
bash scripts/install.sh --tool codex --include-personal
```

## Test Installer

Run the installer smoke tests without touching real user tool directories:

```bash
bash scripts/test-install.sh
```

## Copy Vs Symlink

- `copy` is best for stable day-to-day use.
- `symlink` is best while editing this repository because changes are reflected
  immediately in the target tool.

The installer refuses known symlink-loop cases where a target skill path already
points back into this repository.
