# Codex Adapter

Codex consumes skills from OpenAI Agent Skills discovery locations. This
repository installs curated skills to:

```text
$HOME/.agents/skills/<skill-name>/          # user scope
<project>/.agents/skills/<skill-name>/      # repository scope
```

Legacy local setups can still install to:

```text
${CODEX_HOME:-$HOME/.codex}/skills/<skill-name>/
```

Each installed skill directory contains `SKILL.md` and any adjacent reference
files, scripts, assets, or Codex-specific `agents/openai.yaml` metadata.

## Install

```bash
bash scripts/install.sh --tool codex --scope user
bash scripts/install.sh --tool codex --scope repo --project /path/to/project
```

Development symlink install:

```bash
bash scripts/install.sh --tool codex --method symlink
```

Include personal skills:

```bash
bash scripts/install.sh --tool codex --include-personal
```

Legacy install:

```bash
bash scripts/install.sh --tool codex --scope legacy
```

## Behavior

- Default install mode is `copy`.
- Default Codex scope is `user`.
- Personal skills are skipped unless `--include-personal` is passed.
- Skill names are flattened at install time, e.g.
  `skills/tools/bcecmd` installs to `$HOME/.agents/skills/bcecmd`.
- Codex-specific behavior belongs in each skill's `agents/openai.yaml`, not in
  this adapter directory.

## Invocation and Verification

See [harness compatibility](../../docs/harness-compatibility.md) for invocation
metadata, supported install scopes, and the exact validation performed. The
installer does not modify global coding instructions or require other skills
to run automatically.
