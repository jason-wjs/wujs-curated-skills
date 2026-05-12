# External Sources

This document records upstream sources that local curated skills are derived
from or compared against.

## Adapted Skills

### `skills/engineering/karpathy-guidelines`

- Upstream: <https://github.com/forrestchang/andrej-karpathy-skills>
- Local source: `skills/engineering/karpathy-guidelines/SKILL.md`
- License: MIT, preserved in skill frontmatter.
- Local policy: maintained as an adapted skill, not a bulk vendored copy of the
  upstream collection.

### `skills/productivity/grill-me`

- Upstream: <https://github.com/mattpocock/skills>
- Local source: `skills/productivity/grill-me/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: maintained as an adapted skill from the upstream collection.

### `skills/engineering/grill-with-docs`

- Upstream: <https://github.com/mattpocock/skills>
- Local source: `skills/engineering/grill-with-docs/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: maintained as an adapted skill from the upstream collection,
  including its adjacent format reference files.

### `skills/engineering/diagnose`

- Upstream: <https://github.com/mattpocock/skills>
- Local source: `skills/engineering/diagnose/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: maintained as an adapted skill from the upstream collection.

### `skills/engineering/improve-codebase-architecture`

- Upstream: <https://github.com/mattpocock/skills>
- Local source: `skills/engineering/improve-codebase-architecture/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: maintained as an adapted skill from the upstream collection,
  including its adjacent reference files.

### `skills/engineering/tdd`

- Upstream: <https://github.com/mattpocock/skills>
- Local source: `skills/engineering/tdd/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: maintained as an adapted skill from the upstream collection,
  including its adjacent reference files.

### `skills/engineering/zoom-out`

- Upstream: <https://github.com/mattpocock/skills>
- Local source: `skills/engineering/zoom-out/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: maintained as an adapted skill from the upstream collection.

### `skills/productivity/write-a-skill`

- Upstream: <https://github.com/mattpocock/skills>
- Local source: `skills/productivity/write-a-skill/SKILL.md`
- License: MIT, preserved by repository license and this source record.
- Local policy: maintained as an adapted skill from the upstream collection.

### `skills/personal/research-paper-writing`

- Upstream: <https://github.com/Master-cai/Research-Paper-Writing-Skills>
- Upstream commit: `9ee5eddc10068cc52590b3a68a827d3a387f5af9`
- Local source: `skills/personal/research-paper-writing/SKILL.md`
- License: MIT, preserved by repository license, skill attribution, and this
  source record.
- Upstream attribution: most methodology comes from Prof. Peng Sida's public
  study notes and <https://github.com/pengsida/learning_research>.
- Local policy: maintained as an adapted personal skill. It is installed only
  when `--include-personal` is used.

## Reference Sources

### `skills/tools/pueue`

- Reference: <https://github.com/Nukesor/pueue>
- Local source: `skills/tools/pueue/SKILL.md`
- Local policy: not a vendored copy. The local skill summarizes Pueue's public
  tool behavior and repository documentation for agent usage.

### `skills/personal/obsidian-vault`

- Reference: <https://github.com/kepano/obsidian-skills>
- Local source: `skills/personal/obsidian-vault/SKILL.md`
- Local policy: not a vendored copy. The local skill uses Obsidian syntax and
  workflow guidance as reference material while preserving vault-specific
  behavior in the skill itself.

## Reference Collections

These collections may be useful references, but should not be bulk-copied into
this repository.

- `mattpocock/skills` — reference for collection structure, bucket READMEs,
  setup docs, ADRs, and installation safety patterns.
- `obra/superpowers` — reference for workflow skills used by local agents; keep
  installed from upstream rather than bulk-copying into this repository.

## Local Installed Skills

Some initial skill baselines were copied from the local Codex installation
under `/home/humanoid/.codex/skills/`.

- `bcecmd` is maintained here as a local tool workflow skill.
- `obsidian-vault` is maintained here as a personal local workflow skill, with
  `kepano/obsidian-skills` as syntax/workflow reference material.
