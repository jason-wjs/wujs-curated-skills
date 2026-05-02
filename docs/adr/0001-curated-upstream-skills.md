# ADR 0001: Curated Upstream Skills

## Status

Accepted

## Context

`wujs-curated-skills` is a personal skill collection for installing and
maintaining useful agent skills across Codex, Cursor, and Claude Code.

Some useful skills originate outside this repository. Bulk-vendoring entire
third-party collections would make this repository harder to maintain and blur
ownership. At the same time, adapting a single upstream skill can be valuable
when it becomes part of Wu Junsong's normal agent workflow.

## Decision

This repository may contain local adapted copies of individual third-party
skills when they are intentionally curated and maintained here.

Adapted skills must:

- Preserve attribution to the upstream source.
- Preserve license metadata when applicable.
- Be documented in `docs/external-sources.md`.
- Be reviewed as local maintained content, not treated as an opaque vendored
  blob.

This repository should not bulk-copy third-party skill collections.

## Consequences

- The top-level README can present adapted skills alongside original skills.
- `docs/external-sources.md` becomes part of the maintenance surface.
- Updating from upstream is a deliberate review task, not an automatic sync.
- If adapted skills become numerous, add an update-review checklist before
  taking more upstream copies.
