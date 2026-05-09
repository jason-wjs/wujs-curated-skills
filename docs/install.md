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

# Codex, repository-scoped
bash scripts/install.sh --tool codex --scope repo --project /path/to/project

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
- `--scope user|repo|legacy` — Codex install scope. Defaults to `user`.
- `--project <path>` — project path for Codex repo scope or Cursor install
  (`.cursor/skills/` and `.cursor/rules/`). Defaults to the current directory.
- `--include-personal` — include skills under `skills/personal/`.

## Install Paths

| Tool | Installed Path |
|------|----------------|
| Codex user scope | `$HOME/.agents/skills/<skill-name>` |
| Codex repo scope | `<project>/.agents/skills/<skill-name>` |
| Codex legacy scope | `${CODEX_HOME:-$HOME/.codex}/skills/<skill-name>` |
| Claude Code | `~/.claude/skills/<skill-name>` |
| Cursor Agent Skills | `<project>/.cursor/skills/<skill-name>/` |
| Cursor bridge rule | `<project>/.cursor/rules/wujs-curated-skills.mdc` |

Codex and Claude Code receive one directory per installed skill. Codex user and
repo scopes follow OpenAI's current Agent Skills discovery layout. Cursor
receives the same one-directory-per-skill layout under `.cursor/skills/`, plus
the `.mdc` bridge for routing and index hints.

Use Codex legacy scope only for older local setups that still read
`~/.codex/skills`.

## Personal Skills

Skills under `skills/personal/` are skipped by default because they contain
local paths or preferences. Install them explicitly:

```bash
bash scripts/install.sh --tool codex --include-personal
bash scripts/install.sh --tool cursor --include-personal
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
