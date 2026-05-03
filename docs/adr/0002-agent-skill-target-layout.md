# ADR 0002: Agent Skill Target Layout

## Status

Accepted

## Context

This repository maintains one curated set of skills for multiple agentic coding
tools. Codex, Claude Code, and Cursor do not consume skills in exactly the same
way:

- Codex follows the OpenAI Agent Skills layout and discovers skills from
  `.agents/skills`, `$HOME/.agents/skills`, admin locations, and bundled system
  skills.
- Claude Code consumes skill directories under `~/.claude/skills`.
- Cursor does not directly consume Agent Skills directories and needs a rule
  bridge.

The repository already keeps canonical skill sources under
`skills/<bucket>/<skill>/SKILL.md` and installs from `manifest.json`.

## Decision

Keep `skills/<bucket>/<skill>/` as the canonical authoring layout for this
repository. Installation and adapter generation map that canonical source to
each target tool:

- Codex user scope: `$HOME/.agents/skills/<skill-name>/`
- Codex repository scope: `<project>/.agents/skills/<skill-name>/`
- Codex legacy scope: `${CODEX_HOME:-$HOME/.codex}/skills/<skill-name>/`
- Claude Code: `$HOME/.claude/skills/<skill-name>/`
- Cursor: `<project>/.cursor/rules/wujs-curated-skills.mdc`

Codex-specific per-skill metadata belongs inside the skill directory at
`agents/openai.yaml`. It is not a repository-level adapter and is not consumed
by Cursor or Claude Code.

`adapters/` remains tool-specific bridge documentation or generated output. It
must not duplicate full skill bodies.

## Consequences

- One canonical skill body can serve all supported tools.
- Codex support follows the current OpenAI discovery paths without giving up the
  repository's bucketed source layout.
- Cursor and Claude Code remain supported through target-specific installation
  behavior.
- Skills that need Codex-specific invocation policy or UI metadata can opt in
  with `agents/openai.yaml`.
