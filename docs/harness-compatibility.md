# Harness Compatibility

Validated on 2026-09-16 after the writing collection migration. Canonical skills are installed as complete directories;
references use paths relative to the skill, so the bucketed source layout can
be flattened without losing resources.

## Supported installation

| Harness | Installer location | Explicit-only metadata |
| --- | --- | --- |
| Codex | `~/.agents/skills/`, project `.agents/skills/`, legacy `$CODEX_HOME/skills/` | `agents/openai.yaml`: `policy.allow_implicit_invocation: false` |
| Claude Code | `~/.claude/skills/` | SKILL.md: `disable-model-invocation: true` |
| Cursor | project `.cursor/skills/` or `~/.cursor/skills/` | SKILL.md: `disable-model-invocation: true` |

Copy is the default. Symlink mode keeps the canonical source live. Existing
explicit-only skills carry both metadata forms. The optional Cursor bridge
only locates skills and does not repeat their triggers. Installing skills does
not apply this repository's AGENTS.md to other projects.

Cursor can also discover compatibility directories used by other harnesses.
Avoid independently editing copies of the same skill in several discovery
locations. Remote/cloud environments need their own installation or supported
sync; a successful local install does not provision them.

## Reproducible package checks

Run `bash scripts/test-install.sh`. It uses disposable temporary directories,
without changing live harness installations, and checks:
- Frontmatter, invocation-policy parity, catalog entries, and resource links.
- Copy/symlink packages across 14 scenarios, with and without personal skills.
- Every installed file against canonical content, and installed relative links.
- Deprecated-skill pruning, including karpathy-guidelines, research-paper-writing, and edit-article.
- Writing skill sibling references and the shared editing contract; human
  companion documents stay outside installed packages.

`bash scripts/lint-skills.sh` is the faster source-only check. It validates this
repository's simple frontmatter conventions, not arbitrary YAML documents.

## Native discovery checks performed

- Codex app-server `initialize` then `skills/list` against a temporary repository
  install: all 38 skills returned, with no errors for these packages.
- Claude Code streaming control `initialize` with an isolated CLAUDE_CONFIG_DIR:
  all 38 skills appeared in the command catalog.
- Neither check started a model turn. The Codex listing does not expose implicit
  invocation policy; policy parity is checked statically, not inferred from
  `enabled` in that response.
- Cursor packages and documented discovery metadata passed. Cursor Agent CLI
  was unavailable on this host; an interactive Cursor load was not exercised.

These checks establish installation and discovery compatibility to the extent
listed. They do not establish comparative model quality or guarantee automatic
skill selection for every prompt.

## Primary references

- [Codex skills](https://learn.chatgpt.com/docs/build-skills)
- [Claude Code skills](https://code.claude.com/docs/en/skills)
- [Cursor skills](https://cursor.com/docs/skills)
