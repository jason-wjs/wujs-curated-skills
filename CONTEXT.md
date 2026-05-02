# wujs-curated-skills Context

This repository is a curated skill collection for agentic coding tools. It is
not a general package manager and not a bulk mirror of upstream skill
collections.

## Language

**Curated skill**:
A skill intentionally kept in this repository because Wu Junsong wants to
install, adapt, or maintain it as part of a personal agent workflow.

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
A top-level category under `skills/` that describes the skill's purpose and
promotion level.

**Promoted skill**:
A curated skill intended to be visible in the top-level README and installed by
default for the relevant target tools.

**Personal skill**:
A curated skill tied to Wu Junsong's local paths, note system, credentials,
hardware, or preferences. Personal skills may be documented in their bucket but
should be marked as environment-specific.

**Install target**:
An agent tool that can consume skills, currently Codex, Cursor, and Claude
Code.

**Adapter**:
Tool-specific documentation, manifest data, or templates that bridge this
repository's canonical skill layout to an install target.

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
- The top-level README lists promoted skills; bucket READMEs list every skill
  in that bucket.

## Open Placeholders

- Adapted-skill update workflow should be formalized if adapted skills become
  numerous.
