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

- **[code-review](./skills/engineering/code-review/SKILL.md)** — Two-axis
  review (Standards + Spec) of the diff since a fixed point.
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)** — Shared
  vocabulary for designing deep modules, seams, and adapters.
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)** —
  Disciplined diagnosis loop for hard bugs and performance regressions.
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)** —
  Actively sharpen domain language and record ADRs / `CONTEXT.md`.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)** —
  Grilling session that also runs domain-modeling.
- **[implement](./skills/engineering/implement/SKILL.md)** — Build a spec or
  ticket with tdd and code-review.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)** —
  Find deepening opportunities that make code more testable and AI-navigable.
- **[karpathy-guidelines](./skills/engineering/karpathy-guidelines/SKILL.md)** —
  Lightweight guardrails for non-trivial coding, review, and refactoring where
  hidden assumptions, overengineering, broad diffs, or weak verification could
  cause mistakes.
- **[research](./skills/engineering/research/SKILL.md)** — Investigate a
  question against primary sources and save cited findings.
- **[tdd](./skills/engineering/tdd/SKILL.md)** — Test-driven development with a
  red-green-refactor loop and behavior-focused tests.
- **[to-spec](./skills/engineering/to-spec/SKILL.md)** — Synthesize the current
  conversation into a published spec.
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)** — Break a plan or
  spec into tracer-bullet tickets with blocking edges.
- **[zoom-out](./skills/engineering/zoom-out/SKILL.md)** — Ask for a higher-level
  map of unfamiliar code and its relevant modules and callers.

### Productivity

- **[grill-me](./skills/productivity/grill-me/SKILL.md)** — User entry for a
  grilling session without writing project docs.
- **[grilling](./skills/productivity/grilling/SKILL.md)** — Relentless
  one-question-at-a-time interview loop shared by grill entry points.
- **[handoff](./skills/productivity/handoff/SKILL.md)** — Compact the current
  conversation into a redacted handoff document for a fresh agent.
- **[shared-server-codex-isolation](./skills/productivity/shared-server-codex-isolation/SKILL.md)** —
  **Explicit-only.** Configure personal `codex-wjs` isolation on shared servers
  while preserving bare `codex` as the global default.
- **[shared-server-git-private](./skills/productivity/shared-server-git-private/SKILL.md)** —
  **Explicit-only.** jason-wjs shared-host private Git: per-repo local identity,
  ask/discover proxy per host, user-supplied Fine-grained PAT.
- **[teach](./skills/productivity/teach/SKILL.md)** — Create and maintain a
  stateful teaching workspace with missions, lessons, resources, references,
  assets, and learning records.
- **[write-a-skill](./skills/productivity/write-a-skill/SKILL.md)** — Create or
  improve agent skills with predictable structure, progressive disclosure, and
  bundled resources.

### Tools

- **[bcecmd](./skills/tools/bcecmd/SKILL.md)** — Use Baidu BCE BOS through the
  `bcecmd` CLI for bucket operations, uploads, downloads, syncs, validation,
  and troubleshooting.
- **[pueue](./skills/tools/pueue/SKILL.md)** — Use Pueue/`pueued` for local
  single-user long-running shell command queues, including status, logs,
  groups, parallelism, dependencies, pause/resume, and restarts.

### Personal

- **[edit-article](./skills/personal/edit-article/SKILL.md)** — Edit and
  improve articles by restructuring sections, improving clarity, and tightening
  prose. Environment-specific.
- **[obsidian-vault](./skills/personal/obsidian-vault/SKILL.md)** — Search,
  create, edit, link, and organize Obsidian notes while preserving wikilinks,
  backlinks, index notes, and existing vault conventions. Environment-specific.
- **[research-paper-writing](./skills/personal/research-paper-writing/SKILL.md)** —
  Improve ML/CV/NLP-style academic paper writing with section guides, paragraph
  flow checks, claim-evidence alignment, and reviewer-facing self-review.
  Environment-specific.

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
