# wujs-curated-skills

Personal curated skills for agentic coding tools.

This repository collects skills that Wu Junsong wants to install, adapt, and
maintain across tools such as Codex, Cursor, and Claude Code. It may contain
original skills, locally adapted third-party skills, and thin wrappers around
external tools.

It is not a bulk mirror of upstream skill collections. When a third-party skill
is adapted here, the local copy should preserve attribution and license
metadata and be maintained intentionally.

## Why This Exists

- Turn recurring agent workflows into installable skills instead of repeating
  long prompts across projects.
- Keep personal tool knowledge, such as BOS transfer workflows and Obsidian
  note conventions, close to the agents that need it.
- Adapt useful upstream skills deliberately while preserving local ownership
  boundaries.
- Keep Codex, Claude Code, and Cursor behavior aligned from one canonical skill
  source.

## Current Skills

### Engineering

- **[karpathy-guidelines](./skills/engineering/karpathy-guidelines/SKILL.md)** —
  Lightweight guardrails for non-trivial coding, review, and refactoring where
  hidden assumptions, overengineering, broad diffs, or weak verification could
  cause mistakes.

### Productivity

- **[grill-me](./skills/productivity/grill-me/SKILL.md)** — Interview the user
  relentlessly about a plan or design until each branch of the decision tree is
  resolved.
- **[grill-with-docs](./skills/productivity/grill-with-docs/SKILL.md)** —
  Stress-test a plan against project domain language and ADRs, updating
  documentation as decisions crystallize.

### Tools

- **[bcecmd](./skills/tools/bcecmd/SKILL.md)** — Use Baidu BCE BOS through the
  `bcecmd` CLI for bucket operations, uploads, downloads, syncs, validation,
  and troubleshooting.

### Personal

- **[edit-article](./skills/personal/edit-article/SKILL.md)** — Edit and
  improve articles by restructuring sections, improving clarity, and tightening
  prose. Environment-specific.
- **[obsidian-vault](./skills/personal/obsidian-vault/SKILL.md)** — Search,
  create, edit, link, and organize Obsidian notes while preserving wikilinks,
  backlinks, index notes, and existing vault conventions. Environment-specific.

## Repository Layout

```text
skills/
  engineering/   General engineering behavior and code-work skills
  productivity/  Planning, writing, and collaboration workflows
  tools/         External tools, CLIs, services, and platforms
  personal/      Local setup, paths, notes, and preferences
adapters/        Tool-specific notes for Codex, Cursor, and Claude Code
docs/            Install, authoring, external-source, and ADR documentation
scripts/         Installer and maintenance scripts
```

Promoted and personal install sets are declared in
[manifest.json](./manifest.json).

## Install

Use the installer:

```bash
bash scripts/install.sh --tool codex
bash scripts/install.sh --tool claude
bash scripts/install.sh --tool cursor --project /path/to/project
```

Use `--method symlink` while developing skills, and `--include-personal` when
you explicitly want environment-specific personal skills installed.

See [docs/install.md](./docs/install.md) for details.

## Maintainer Docs

- [CONTEXT.md](./CONTEXT.md) defines the repository language.
- [AGENTS.md](./AGENTS.md) defines maintainer instructions for agents.
- [docs/external-sources.md](./docs/external-sources.md) records upstream
  sources and adapted skills.
- [docs/authoring-guidelines.md](./docs/authoring-guidelines.md) records skill
  authoring guidance for this repository.

## License

MIT License. See [LICENSE](./LICENSE).
