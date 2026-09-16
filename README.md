# wujs-curated-skills

A curated collection for engineering, writing, and everyday work with Codex,
Claude Code, and Cursor, maintained by Wu Junsong.

The collection preserves useful domain knowledge, editing preferences, and
operational constraints. Skills supply context that changes an agent’s
choices, while leaving routine execution to the model. Writing covers research
papers, grants, reviewer responses, presentations, and general prose; human
writing guides live separately under [for-humans/](for-humans/writing/README.md).

Original skills and adapted upstream skills share one installable catalog.
Attribution and licenses remain with adapted material. Environment-specific
paths, identities, and service settings are discovered or supplied at use time.

## Curation Principles

- Keep narrow triggers and guidance grounded in recurring needs or observed
  failures; avoid repeating general model capabilities.
- Load detailed references only when the task needs them.
- Preserve user intent, editing scope, and existing authorization.
- Maintain one canonical source for all three supported harnesses.

This approach follows OpenAI’s
[Rethinking skills and prompts](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra).

## Current Skills

### Engineering

- **[bootstrap-shared-server](./skills/engineering/bootstrap-shared-server/SKILL.md)** — Use when explicitly preparing, auditing, or repairing a per-user development environment on an SSH-accessible shared Linux cluster.
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
- **[obsidian-vault](./skills/tools/obsidian-vault/SKILL.md)** — Use when finding, creating, or editing notes in an Obsidian vault while preserving its existing conventions and links.
- **[pueue](./skills/tools/pueue/SKILL.md)** — Use when the user requests Pueue/pueued or an existing Pueue queue needs inspection, task submission, or troubleshooting.

### Writing

- **[abstract-writing](./skills/writing/abstract-writing/SKILL.md)** — Use when drafting, revising, or diagnosing a research abstract as a standalone argument.
- **[academic-voice](./skills/writing/academic-voice/SKILL.md)** — Use when specifically adjusting scholarly tone or removing corporate and social-media register from research exposition.
- **[anti-defensive-writing](./skills/writing/anti-defensive-writing/SKILL.md)** — Use when a passage contains redundant defensive caveats or the user asks to reduce apologetic phrasing; use rebuttal-writing for reviewer responses.
- **[better-usage](./skills/writing/better-usage/SKILL.md)** — Use when a sentence is grammatical but its subject, verb, or object expresses the wrong semantic relation.
- **[general-writing](./skills/writing/general-writing/SKILL.md)** — Use when polishing general prose or diagnosing clarity, voice, or formulaic phrasing outside a more specific writing task.
- **[grant-planning](./skills/writing/grant-planning/SKILL.md)** — Use when choosing or comparing grant research stories, aims, team roles, feasibility, or scope before application drafting.
- **[grant-writing](./skills/writing/grant-writing/SKILL.md)** — Use when drafting or revising grant and fellowship application answers from a research plan and sponsor requirements.
- **[humanizer](./skills/writing/humanizer/SKILL.md)** — Use when the user asks to diagnose or revise formulaic, generic, or AI-sounding prose.
- **[improve-human-writing-guide](./skills/writing/improve-human-writing-guide/SKILL.md)** — Use when creating, revising, or compiling a human-readable writing guide or its LaTeX/PDF companion.
- **[literature-review](./skills/writing/literature-review/SKILL.md)** — Use when researching and writing a source-grounded literature review, survey, or related-work synthesis.
- **[non-autoregressive-writing-pass](./skills/writing/non-autoregressive-writing-pass/SKILL.md)** — Use when reviewing a completed draft’s titles, paragraph openings, endings, and transitions against the whole argument.
- **[paper-writing](./skills/writing/paper-writing/SKILL.md)** — Use when planning, drafting, or revising a research paper or its sections; use abstract-writing for an abstract-only task.
- **[presentation-making](./skills/writing/presentation-making/SKILL.md)** — Use when planning, drafting, revising, or reviewing presentation slides and speaker notes.
- **[prompt-improving](./skills/writing/prompt-improving/SKILL.md)** — Use when the user asks to improve or clarify a prompt while preserving its intent and natural style.
- **[rebuttal-writing](./skills/writing/rebuttal-writing/SKILL.md)** — Use when drafting reviewer responses, author-response letters, or point-by-point revision memos.
- **[writing](./skills/writing/writing/SKILL.md)** — Use when a writing request spans genres or needs routing and no focused writing skill has already been selected.
- **[writing-cadence](./skills/writing/writing-cadence/SKILL.md)** — Use when revising choppy rhythm, monotonous sentence shapes, repeated openings, or mechanical contrast patterns.

## Repository Layout

```text
skills/
  engineering/   General engineering behavior and code-work skills
  productivity/  Planning, writing, and collaboration workflows
  tools/         External tools, CLIs, services, and platforms
  writing/       Writing tasks, editing preferences, and reference examples
adapters/        Tool-specific notes for Codex, Cursor, and Claude Code
for-humans/      Human-readable guides and reusable document projects
docs/            Install, authoring, and external-source documentation
scripts/         Installer and maintenance scripts
```

The complete install set is declared in
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

All catalog skills are included by default. Use `--method symlink` while
developing skills. The former `personal` category has been removed; old
`--include-personal` commands still work and emit a deprecation notice.

See [docs/install.md](./docs/install.md) for details.

## Human Writing Materials

[Writing guides and templates](for-humans/writing/README.md) retain the human
companion materials separately from installed agent skills.

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
execution to the agent. See [curation principles](docs/authoring-guidelines.md#curation-principles)
and [portable coding preferences](docs/coding-preferences.md).

`to-spec` captures requirements; `handoff` records execution state and links the
spec. `deslop` is an on-demand cleanup for unnecessary defensive complexity.
Existing optional commands remain available; installation is not a claim that
every skill should run on every task.

The installer copies complete skill directories; it does not change your global
AGENTS.md/CLAUDE.md or install mandatory review hooks. See
[compatibility checks](docs/harness-compatibility.md) for scope and verification.
