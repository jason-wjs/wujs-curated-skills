# wujs-curated-skills Plan

This is a temporary planning document for bootstrapping this repository.
It records project architecture and file responsibilities while the project
is being built. It can be abandoned after the repository structure and docs
are complete.

## Project Positioning

`wujs-curated-skills` is a personal skills collection for agentic coding tools.
It stores skills that Wu Junsong wants to curate, install, adapt, and maintain
as part of a personal agent workflow. Skills may be original, locally adapted
from upstream projects, or thin wrappers around external tools.

Third-party skill collections should not be bulk-vendored into this repository.
When a third-party skill is adapted here, keep attribution and license metadata,
and treat the local copy as an intentionally maintained fork.

Initial target tools:

- Codex
- Cursor
- Claude Code

## Architecture

```text
wujs-curated-skills/
  README.md
  AGENTS.md
  CLAUDE.md -> AGENTS.md
  CONTEXT.md
  plan.md
  skills/
    tools/
      README.md
    personal/
      README.md
    engineering/
      README.md
  adapters/
    codex/
    claude/
    cursor/
  docs/
    adr/
    install.md
    external-sources.md
    authoring-guidelines.md
  scripts/
    install.sh
```

## Skill Categories

`skills/tools/`

Skills for concrete external tools, CLIs, services, and platforms.
Example: `bcecmd`.

`skills/personal/`

Skills for personal workflows, knowledge systems, notes, and preferences.
Example: `obsidian-vault`.

`skills/engineering/`

Skills for general software engineering practice, code quality, debugging,
architecture, and implementation discipline.
Example: `karpathy-guidelines`.

## File Responsibilities

`README.md`

User-facing main document. It explains what this skill collection is, why it
exists, how to install it, and what each official skill does.

`AGENTS.md`

Canonical maintainer instructions for agents working in this repository. It
defines bucket rules, maintenance rules, and which changes must update README
or adapter docs.

`CLAUDE.md`

Symlink to `AGENTS.md` for Claude Code compatibility. `AGENTS.md` remains the
single source of truth.

`CONTEXT.md`

Repository domain language and project model. It should define terms such as
curated skill, adapted skill, external source, adapter, install target,
category bucket, copy, symlink, and canonical source.

`skills/<category>/<skill>/SKILL.md`

The canonical source for each curated skill. Each skill should be self-contained
and may include local `scripts/`, `references/`, or `assets/` directories when
needed. Adapted skills must preserve source attribution and license metadata
when applicable.

`adapters/`

Tool-specific notes or templates for Codex, Cursor, and Claude Code. These are
not the primary skill source; they exist only to bridge tool-specific loading
or rule formats.

`docs/install.md`

Detailed install and update instructions.

`docs/adr/`

Durable architectural and maintenance decisions for this repository.

`docs/external-sources.md`

Records third-party skill collections that should usually be installed from
upstream, and any upstream sources that local adapted skills are derived from.

`docs/authoring-guidelines.md`

Guidelines for creating, adapting, classifying, and maintaining curated skills.

`scripts/install.sh`

Installer. It scans `skills/<category>/<skill>/SKILL.md` and installs skills
into each target tool in the layout expected by that tool.

## Design Decisions

- Use directory structure as the skill index. No `registry/` module.
- Keep repository-internal skills grouped by category.
- Install output may be flattened per target tool if that improves
  compatibility.
- Do not bulk-copy third-party collections into this repository.
- Local copies of third-party skills are allowed when they are intentionally
  adapted, attributed, licensed, and maintained as curated skills.
- Keep root-level `agents/`, `commands/`, and `hooks/` out of scope for now.
  Add them only if multiple curated skills need shared runtime extensions.
