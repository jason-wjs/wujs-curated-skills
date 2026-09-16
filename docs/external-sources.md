# External Sources

This document records upstream sources that local curated skills are derived
from or compared against.

## Curation revision — 2026-09-15

The adapted sources below retain their recorded upstream baselines, including
the concurrent TDD/architecture update at `ed37663cc5fbef691ddfecd080dff42f7e7e350d`. Local
bodies now favor narrow triggers, outcome-based guidance, conditional resources,
and existing authorization. This revision is not a synchronization to upstream
HEAD. In particular, research no longer requires a background agent, review
supports working-tree changes and ranks findings, and writing-skills guidance
no longer treats a fixed process or line count as a quality goal.

The design reference is [OpenAI's skill-curation article](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra).
The superseded karpathy-guidelines source was
https://github.com/forrestchang/andrej-karpathy-skills (MIT); its files were removed.

## Adapted Skills

### `skills/productivity/grill-me`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream path: `skills/productivity/grill-me`
- Upstream commit: `391a2701dd94`
- Local source: `skills/productivity/grill-me/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: thin user-invoked wrapper over local `grilling`.

### `skills/productivity/grilling`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream path: `skills/productivity/grilling`
- Upstream commit: `391a2701dd94`
- Local source: `skills/productivity/grilling/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: adapted interview guidance focused on consequential unresolved decisions.

### `skills/productivity/handoff`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream commit: `8370e760d0251a3738e006aeacec6d1cb31dd208`
- Local source: `skills/productivity/handoff/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: maintained as an adapted skill from the upstream collection.

### `skills/productivity/teach`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream commit: `8370e760d0251a3738e006aeacec6d1cb31dd208`
- Local source: `skills/productivity/teach/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: maintained as an adapted skill from the upstream collection,
  including its adjacent format reference files.

### `skills/engineering/grill-with-docs`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream path: `skills/engineering/grill-with-docs`
- Upstream commit: `391a2701dd94`
- Local source: `skills/engineering/grill-with-docs/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: thin user-invoked wrapper over `grilling` + `domain-modeling`.

### `skills/engineering/domain-modeling`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream path: `skills/engineering/domain-modeling`
- Upstream commit: `391a2701dd94`
- Local source: `skills/engineering/domain-modeling/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: adapted with adjacent `CONTEXT-FORMAT.md` and `ADR-FORMAT.md`.

### `skills/engineering/diagnosing-bugs`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream path: `skills/engineering/diagnosing-bugs`
- Upstream commit: `391a2701dd94`
- Local source: `skills/engineering/diagnosing-bugs/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: adapted from upstream `diagnosing-bugs`, including
  `scripts/hitl-loop.template.sh`. Former local name `diagnose` is listed under
  `deprecated_skill_names` for `--prune`.

### `skills/engineering/to-spec`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream path: `skills/engineering/to-spec`
- Upstream commit: `391a2701dd94`
- Local source: `skills/engineering/to-spec/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: adapted; Matt setup skill replaced with inline issue-tracker
  resolution (GitHub or local `.scratch/`).

### `skills/engineering/to-tickets`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream path: `skills/engineering/to-tickets`
- Upstream commit: `391a2701dd94`
- Local source: `skills/engineering/to-tickets/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: adapted; same issue-tracker resolution as `to-spec`.

### `skills/engineering/implement`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream path: `skills/engineering/implement`
- Upstream commit: `391a2701dd94`
- Local source: `skills/engineering/implement/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: adapted; implementation follows existing authorization; TDD and separate review are conditional.

### `skills/engineering/code-review`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream path: `skills/engineering/code-review`
- Upstream commit: `391a2701dd94`
- Local source: `skills/engineering/code-review/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: adapted; setup skill reference replaced with local tracker
  resolution.

### `skills/engineering/research`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream path: `skills/engineering/research`
- Upstream commit: `391a2701dd94`
- Local source: `skills/engineering/research/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: adapted research-note workflow with optional delegation.

### `skills/engineering/codebase-design`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream path: `skills/engineering/codebase-design`
- Upstream commit: `391a2701dd94`
- Local source: `skills/engineering/codebase-design/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: adapted with adjacent `DEEPENING.md` and `DESIGN-IT-TWICE.md`.

### `skills/engineering/improve-codebase-architecture`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream path: `skills/engineering/improve-codebase-architecture`
- Upstream commit: `ed37663cc5fbef691ddfecd080dff42f7e7e350d`
- Local source: `skills/engineering/improve-codebase-architecture/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: retains upstream HTML reports, scope selection, and explicit-only
  invocation; uses curated outcome-based assessment with optional follow-up.
  Shared vocabulary/interface references live in `codebase-design`.

### `skills/engineering/tdd`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream path: `skills/engineering/tdd`
- Upstream commit: `ed37663cc5fbef691ddfecd080dff42f7e7e350d`
- Local source: `skills/engineering/tdd/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: retains upstream test examples, independent expected values,
  metadata, and shared `codebase-design` references. Curated loop avoids repeated
  approval and speculative requirements; refactoring stays tied to concrete benefit.

### `skills/productivity/write-a-skill`

- Upstream: <https://github.com/mattpocock/skills>
- Upstream paths: `skills/productivity/write-a-skill` (historical process) and
  `skills/productivity/writing-great-skills` (principles + glossary)
- Upstream commit: `391a2701dd94`
- Local source: `skills/productivity/write-a-skill/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: keeps the `write-a-skill` name; rewrites the creation guidance and glossary
  around useful task-specific constraints and portable packaging.

## Writing Collection

- Source: <https://github.com/jason-wjs/academic-writing-skills>
- Imported revision: `9ff8f95b790a0e47809a172963c4c4417443f9b8`.
- Local source: all 17 entrypoints under `skills/writing/` and human companions
  under `for-humans/writing/`.
- License: MIT, copyright 2026 Max Simchowitz; preserved in each skill and the
  human companion directory. Skills with an existing component LICENSE also
  carry `LICENSE.academic-writing-skills`.
- Additional origins: Humanizer by Siqi Chen (<https://github.com/blader/humanizer>),
  no-ai-slop by Peter Yang (<https://github.com/petergyang/no-ai-slop>), and
  anti-defensive-writing by Kiterlin (<https://github.com/Kiterlin/anti-defensive-writing>).
  Their original MIT notices remain with their adapted skills.
- Local policy: retain command names and useful examples, shorten entrypoints,
  load references by task, and replace mandatory editing chains with shared
  sentence/paragraph scope preferences. Keep original private corpora outside
  the repository. Human source/PDF artifacts are preserved independently of
  the current agent guidance.
- Replaces `research-paper-writing`, previously adapted from
  <https://github.com/Master-cai/Research-Paper-Writing-Skills> at
  `9ee5eddc10068cc52590b3a68a827d3a387f5af9`. Its former content remains in Git
  history; the deprecated name is pruned only when requested at installation.

## Reference Sources

### `skills/tools/pueue`

- Reference: <https://github.com/Nukesor/pueue>
- Local source: `skills/tools/pueue/SKILL.md`
- Local policy: not a vendored copy. The local skill summarizes Pueue's public
  tool behavior and repository documentation for agent usage. Runtime syntax
  comes from installed-version help; version changes come from official
  [releases](https://github.com/Nukesor/pueue/releases), and shell pitfalls from
  the [upstream guide](https://github.com/Nukesor/pueue/wiki/Common-Pitfalls-and-Debugging).

### `skills/tools/obsidian-vault`

- Reference: <https://github.com/kepano/obsidian-skills>
- Local source: `skills/tools/obsidian-vault/SKILL.md`
- Local policy: not a vendored copy. The local skill uses Obsidian syntax and
  workflow guidance as reference material; naming and organization are learned
  from the target vault rather than prescribed by this collection.

## Reference Collections

These collections may be useful references, but should not be bulk-copied into
this repository.

- `mattpocock/skills` — reference for collection structure, bucket READMEs,
  setup docs, ADRs, and installation safety patterns.
- `obra/superpowers` — reference for workflow skills used by local agents; keep
  installed from upstream rather than bulk-copying into this repository.

## Repository-Native Skills

### `skills/engineering/bootstrap-shared-server`

- Local source: `skills/engineering/bootstrap-shared-server/SKILL.md`
- Adjacent references cover local-controller audit, personal shell, networking,
  private Git, Codex CLI/App routing, verification, and rollback.
- Explicit-only policy: frontmatter `disable-model-invocation: true` and
  Codex `agents/openai.yaml` with `allow_implicit_invocation: false`
- Local policy: explicit-only per-user workflow for preparing an already
  SSH-accessible shared cluster. Authored from deployment practice; no upstream
  vendored copy. Included in the default install; invocation remains explicit-only.

## Local Installed Skills

Some initial skill baselines were copied from the local Codex installation
under `/home/humanoid/.codex/skills/`.

- `bcecmd` is maintained here as a local tool workflow skill.
- `obsidian-vault` is maintained here as an Obsidian workflow skill, with
  `kepano/obsidian-skills` as syntax/workflow reference material.

## `deslop` references

Repository-native wording based on the user's failure cases and comparison with:
- [Cursor deslop](https://github.com/cursor/plugins/blob/main/cursor-team-kit/skills/deslop/SKILL.md)
- [Kubb deslop](https://github.com/kubb-labs/kubb/blob/main/.agents/skills/deslop/SKILL.md)
- [Codex defensive-complexity report](https://github.com/openai/codex/issues/39059)

No upstream skill body is vendored. Local scope includes uncommitted work,
independent justification for defenses, and preserving real trust boundaries.

`zoom-out` was removed by the concurrent upstream-sync commit and remains in
the deprecated installer list; this curation does not restore it.
