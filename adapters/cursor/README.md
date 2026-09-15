# Cursor Adapter

Cursor discovers Agent Skills from `.cursor/skills/<skill-name>/`. This installer
places them either under the target project (default) or under your user home.

It also installs an optional locator bridge:

```text
<project>/.cursor/rules/wujs-curated-skills.mdc   # --cursor-scope project (default)
$HOME/.cursor/rules/wujs-curated-skills.mdc       # --cursor-scope user
```

The bridge points to installed skill directories. Each SKILL.md owns its trigger
and invocation policy; the bridge does not duplicate or broaden those rules.

Promoted skills from `manifest.json` are installed into `.cursor/skills/` by
default. Personal skills are omitted unless you pass `--include-personal`.

## Install

Project scope (default): skills and bridge under `<project>/.cursor/`:

```bash
bash scripts/install.sh --tool cursor --project /path/to/project
```

User scope: skills and bridge under `$HOME/.cursor/` (`--project` is ignored
for Cursor in this mode):

```bash
bash scripts/install.sh --tool cursor --cursor-scope user
```

Development symlink install:

```bash
bash scripts/install.sh --tool cursor --project /path/to/project --method symlink
bash scripts/install.sh --tool cursor --cursor-scope user --method symlink
```

Install to the current project (project scope):

```bash
bash scripts/install.sh --tool cursor
```

## Behavior

- Default install mode is `copy`.
- Default Cursor scope is `project`: one directory per skill under
  `<project>/.cursor/skills/`, bridge under `<project>/.cursor/rules/`.
- With `--cursor-scope user`, the same layout is written under `$HOME/.cursor/`.
- The canonical skill sources remain under `skills/<bucket>/<skill>/SKILL.md`.
- Run `bash scripts/lint-skills.sh` after changing promoted skills to check
  catalog entries, invocation metadata, and linked resources.

## Invocation and Verification

See [harness compatibility](../../docs/harness-compatibility.md) for invocation
metadata, supported install scopes, and the exact validation performed. The
installer does not modify global coding instructions or require other skills
to run automatically.
