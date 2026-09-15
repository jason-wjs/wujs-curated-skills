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

- **[code-review](./skills/engineering/code-review/SKILL.md)** — Use when reviewing a PR, branch, commit range, or uncommitted changes for actionable defects and requirement gaps.
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)** — Use when choosing a module interface or examining coupling and testability.
- **[deslop](./skills/engineering/deslop/SKILL.md)** — Use when simplifying a diff with unnecessary defensive branches, fallback behavior, or abstraction.
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)** — Use when investigating a hard-to-reproduce bug, an unclear root cause, or a performance regression.
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)** — Use when resolving domain terminology or documenting a consequential architecture decision.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)** — Use when interviewing about a plan while recording domain terms and consequential decisions.
- **[implement](./skills/engineering/implement/SKILL.md)** — Use when the user asks to implement an agreed spec or tickets.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)** — Use when assessing architectural friction or proposing a concrete refactor.
- **[research](./skills/engineering/research/SKILL.md)** — Use when gathering source-backed technical findings into a reusable research note.
- **[tdd](./skills/engineering/tdd/SKILL.md)** — Use when the user requests test-first development or a red-green-refactor workflow.
- **[to-spec](./skills/engineering/to-spec/SKILL.md)** — Use when turning an aligned discussion into requirements and acceptance criteria for implementation.
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)** — Use when splitting an agreed plan into independently verifiable implementation tickets.

### Productivity

- **[grill-me](./skills/productivity/grill-me/SKILL.md)** — Use when the user explicitly asks for an interview to challenge a plan without creating project documents.
- **[grilling](./skills/productivity/grilling/SKILL.md)** — Use when the user wants their plan or assumptions challenged through an interview.
- **[handoff](./skills/productivity/handoff/SKILL.md)** — Use when preparing another session or agent to continue work in progress.
- **[teach](./skills/productivity/teach/SKILL.md)** — Use when creating or continuing a multi-session learning workspace with lessons and learning records.
- **[write-a-skill](./skills/productivity/write-a-skill/SKILL.md)** — Use when creating or revising a reusable agent skill.

### Tools

- **[bcecmd](./skills/tools/bcecmd/SKILL.md)** — Use when transferring data with bcecmd or configuring and troubleshooting Baidu BOS access.
- **[pueue](./skills/tools/pueue/SKILL.md)** — Use when managing or troubleshooting local shell-command queues with Pueue/pueued.

### Personal

Environment-specific; install with `--include-personal`.

- **[bootstrap-shared-server](./skills/personal/bootstrap-shared-server/SKILL.md)** — Use when explicitly preparing, auditing, or repairing Wu Junsong’s personal environment on an SSH-accessible shared Linux cluster.
- **[edit-article](./skills/personal/edit-article/SKILL.md)** — Use when revising an article’s structure, paragraph flow, or prose.
- **[obsidian-vault](./skills/personal/obsidian-vault/SKILL.md)** — Use when finding or editing notes in the user’s Obsidian vault with its existing naming and linking conventions.
- **[research-paper-writing](./skills/personal/research-paper-writing/SKILL.md)** — Use when drafting or revising ML/CV/NLP paper sections, presentation, or claim-evidence alignment.

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

`skills/` is the canonical source layout. Installers and adapters map those
skills to each target tool: Codex uses OpenAI's `.agents/skills` discovery
layout, Claude Code receives skill directories under `~/.claude/skills`, and
Cursor receives skill directories under `<project>/.cursor/skills/` (default)
or `$HOME/.cursor/skills/` when using `--cursor-scope user`, plus a matching
`.mdc` bridge under `.cursor/rules/` in the same scope.

## Install

Use the installer:

```bash
bash scripts/install.sh --tool codex
bash scripts/install.sh --tool codex --scope repo --project /path/to/project
bash scripts/install.sh --tool claude
bash scripts/install.sh --tool cursor --project /path/to/project
bash scripts/install.sh --tool cursor --cursor-scope user
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

## Curation and Compatibility

Skills preserve local knowledge and chosen workflows while leaving routine
execution to the agent. See [the curation decision](docs/adr/0003-capability-first-skills.md)
and [portable coding preferences](docs/coding-preferences.md).

`to-spec` captures requirements; `handoff` records execution state and links the
spec. `deslop` is an on-demand cleanup for unnecessary defensive complexity.
Existing optional commands remain available; installation is not a claim that
every skill should run on every task.

The installer copies complete skill directories; it does not change your global
AGENTS.md/CLAUDE.md or install mandatory review hooks. See
[compatibility checks](docs/harness-compatibility.md) for scope and verification.
