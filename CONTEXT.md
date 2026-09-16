# wujs-curated-skills Context

This repository is a curated skill collection for engineering, writing, and
tool workflows. It is not a general package manager or a bulk mirror of
upstream skill collections.

## Language

**Curated skill**:
A skill intentionally kept in this repository for its reusable domain
knowledge, chosen preferences, or operational constraints.

**Original skill**:
A curated skill whose content was created primarily for this repository.

**Adapted skill**:
A curated skill derived from an upstream project and changed for this
repository's target tools, conventions, or personal workflows. Adapted skills
must preserve attribution and license metadata when applicable.

**External source**:
An upstream repository, article, documentation page, or installed local skill
that a curated skill is derived from or compared against.

**Bucket**:
A top-level category under `skills/` that describes the skill's purpose.

**Install target**:
An agent tool that can consume skills, currently Codex, Cursor, and Claude
Code.

**Codex user skill**:
A curated skill installed for all local Codex sessions under
`$HOME/.agents/skills/<skill-name>/`.

**Codex repo skill**:
A curated skill installed for one repository or project under
`.agents/skills/<skill-name>/`.

**OpenAI skill metadata**:
Optional Codex-specific metadata stored inside a skill at `agents/openai.yaml`.
It can control Codex UI metadata, implicit invocation policy, and declared tool
dependencies. It is scoped to one skill, not the whole repository.

**Adapter**:
Tool-specific documentation, manifest data, or templates that bridge this
repository's canonical skill layout to an install target.

**Adapter-generated output**:
A file or directory produced from canonical skills for a target tool, such as a
Cursor skill directory under `.cursor/skills/`, a Cursor `.mdc` rule, or an
installed Codex skill directory. Generated output is not a canonical skill source.

**Canonical source**:
The source file for a skill inside this repository:
`skills/<bucket>/<skill>/SKILL.md`.

**Symlink install**:
An install mode where a target tool points at this repository's skill
directories. This keeps local edits live but requires safeguards against
symlink loops.

**Copy install**:
An install mode where skill directories are copied into the target tool's skill
directory. This is safer for stable use but requires explicit updates.

## Relationships

- A **bucket** contains many **curated skills**.
- A **curated skill** may be an **original skill** or an **adapted skill**.
- An **adapted skill** cites one or more **external sources**.
- An **adapter** describes how curated skills map to one **install target**.
- **OpenAI skill metadata** may refine Codex behavior for one **curated skill**.
- The top-level README lists all installable skills; bucket READMEs list every
  skill in that bucket.

## Open Placeholders

- Adapted-skill update workflow should be formalized if adapted skills become
  numerous.
