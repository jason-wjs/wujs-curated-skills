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

## Repository-Native Skills

### `skills/productivity/shared-server-git-private`

- Local source: `skills/productivity/shared-server-git-private/SKILL.md`
- Adjacent references:
  `skills/productivity/shared-server-git-private/references/setup-git-local-helper.md`,
  `skills/productivity/shared-server-git-private/references/pat-and-credentials.md`
- Codex policy: `agents/openai.yaml` with `allow_implicit_invocation: false`
- Local policy: explicit-only workflow for jason-wjs private Git on shared hosts.
  Installed with promoted skills via `manifest.json`.

### `skills/productivity/shared-server-codex-isolation`

- Local source: `skills/productivity/shared-server-codex-isolation/SKILL.md`
- Adjacent references: `skills/productivity/shared-server-codex-isolation/references/placement-rules.md`
- Codex policy: `agents/openai.yaml` with `allow_implicit_invocation: false`
- Local policy: explicit-only workflow for shared-host Codex isolation. Authored
  in this repository from deployment practice. No upstream vendored copy.
  Installed with promoted skills via `manifest.json`.

## Local Installed Skills

Some initial skill baselines were copied from the local Codex installation
under `/home/humanoid/.codex/skills/`.

- `bcecmd` is maintained here as a local tool workflow skill.
- `obsidian-vault` is maintained here as a personal local workflow skill, with
  `kepano/obsidian-skills` as syntax/workflow reference material.
