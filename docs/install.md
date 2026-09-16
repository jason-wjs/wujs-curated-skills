# Install

Use `scripts/install.sh` to install curated skills for Codex, Claude Code, or
Cursor.

The installer reads [manifest.json](../manifest.json). All entries under `skills`
are installed by default.

Canonical sources live under `skills/<bucket>/<skill>/`; installation maps each
complete directory to the target paths below. `adapters/` contains tool-specific
bridges, not duplicate skill bodies. Codex-specific `agents/openai.yaml` stays
inside its skill directory. See [harness compatibility](harness-compatibility.md)
for metadata behavior and validation scope.

## Quick Start

```bash
# Codex
bash scripts/install.sh --tool codex

# Codex, repository-scoped
bash scripts/install.sh --tool codex --scope repo --project /path/to/project

# Claude Code
bash scripts/install.sh --tool claude

# Cursor, current project (default)
bash scripts/install.sh --tool cursor

# Cursor, user-global skills + bridge under ~/.cursor/
bash scripts/install.sh --tool cursor --cursor-scope user

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
- `--cursor-scope project|user` — Cursor install target: `<project>/.cursor/`
  (default) or `$HOME/.cursor/`. Ignored by Codex and Claude.
- `--project <path>` — project path for Codex repo scope and for Cursor when
  `--cursor-scope project` (skills and bridge under that project's `.cursor/`).
  Defaults to the current directory.
- `--prune` — after installing, remove skill directories whose basenames are
  listed in `manifest.json` → `deprecated_skill_names` (and are not still
  active under `skills`). Safe for renamed upstream leftovers such
  as `writing-great-skills` or `diagnose`.

## Install Paths

| Tool | Installed Path |
|------|----------------|
| Codex user scope | `$HOME/.agents/skills/<skill-name>` |
| Codex repo scope | `<project>/.agents/skills/<skill-name>` |
| Codex legacy scope | `${CODEX_HOME:-$HOME/.codex}/skills/<skill-name>` |
| Claude Code | `~/.claude/skills/<skill-name>` |
| Cursor Agent Skills (project) | `<project>/.cursor/skills/<skill-name>/` |
| Cursor bridge rule (project) | `<project>/.cursor/rules/wujs-curated-skills.mdc` |
| Cursor Agent Skills (user) | `$HOME/.cursor/skills/<skill-name>/` |
| Cursor bridge rule (user) | `$HOME/.cursor/rules/wujs-curated-skills.mdc` |

Codex and Claude Code receive one directory per installed skill. Codex user and
repo scopes follow OpenAI's current Agent Skills discovery layout. Cursor uses
`--cursor-scope project` (default) or `--cursor-scope user` for a machine-wide
`~/.cursor/skills/` layout, with the bridge rule installed alongside under the
same scope's `.cursor/rules/`.

Use Codex legacy scope only for older local setups that still read
`~/.codex/skills`.

## Former Personal Category

`bootstrap-shared-server` now lives in engineering and `obsidian-vault` in tools.
Both are included by default; installed directory names stay the same. Rerun
an install command for each scope you use to refresh old copies or links.
The installer retargets links to the former source paths in this checkout;
it does not modify remote server deployments or vault contents.

`--include-personal` is accepted as a deprecated no-op for existing scripts.
There is no separate personal install set.

## Writing Skills Migration

The default install includes all 17 writing entrypoints. They use relative
sibling references, including the shared editing contract in `general-writing`;
install the collection together instead of manually copying a single folder.
The human guides under `for-humans/writing/` stay in the checkout and are not
installed into harness skill directories.

`paper-writing` replaces the former personal `research-paper-writing` entry;
`general-writing` replaces `edit-article` for general article editing.
Use `--prune` with the usual install command to remove these deprecated names in
that target scope. Without `--prune`, existing deprecated installations remain.
Repeat for any other scopes you use. The source academic-writing-skills checkout
is not deleted or modified by this migration or the installer.

## Test Installer

Run the installer smoke tests without touching real user tool directories:

```bash
bash scripts/test-install.sh
```

## Copy Vs Symlink

- `copy` is best for stable day-to-day use.
- `symlink` is best while editing this repository because changes are reflected
  immediately in the target tool.

The installer permits links to the exact skill source and the two former
personal source paths, but rejects links to other locations in this repository
to avoid replacing a source directory through a misplaced link.
