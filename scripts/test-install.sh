#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP_DIR="${TMPDIR:-/tmp}/wujs-curated-skills-install-test"

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

assert_file() {
  local path="$1"
  [[ -f "$path" ]] || { echo "missing file: $path" >&2; exit 1; }
}

assert_no_path() {
  local path="$1"
  [[ ! -e "$path" ]] || { echo "unexpected path exists: $path" >&2; exit 1; }
}

echo "[test] installer help"
bash "$REPO_DIR/scripts/install.sh" --help >/dev/null

echo "[test] skill lint"
bash "$REPO_DIR/scripts/lint-skills.sh" >/dev/null

echo "[test] codex user copy skips personal by default"
HOME="$TMP_DIR/codex-user-home" bash "$REPO_DIR/scripts/install.sh" --tool codex >/dev/null
assert_file "$TMP_DIR/codex-user-home/.agents/skills/diagnose/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/karpathy-guidelines/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/improve-codebase-architecture/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/tdd/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/zoom-out/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/zoom-out/agents/openai.yaml"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/grill-me/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/grill-me/agents/openai.yaml"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/grill-with-docs/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/grill-with-docs/agents/openai.yaml"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/write-a-skill/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/bcecmd/SKILL.md"
assert_no_path "$TMP_DIR/codex-user-home/.agents/skills/obsidian-vault"

echo "[test] codex repo copy includes personal when requested"
bash "$REPO_DIR/scripts/install.sh" --tool codex --scope repo --project "$TMP_DIR/codex-project" --include-personal >/dev/null
assert_file "$TMP_DIR/codex-project/.agents/skills/diagnose/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/karpathy-guidelines/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/improve-codebase-architecture/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/tdd/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/zoom-out/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/grill-me/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/grill-with-docs/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/write-a-skill/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/bcecmd/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/edit-article/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/obsidian-vault/SKILL.md"

echo "[test] codex legacy copy"
CODEX_HOME="$TMP_DIR/codex-legacy" bash "$REPO_DIR/scripts/install.sh" --tool codex --scope legacy >/dev/null
assert_file "$TMP_DIR/codex-legacy/skills/diagnose/SKILL.md"
assert_no_path "$TMP_DIR/codex-legacy/skills/obsidian-vault"

echo "[test] claude copy uses temporary HOME"
HOME="$TMP_DIR/home" bash "$REPO_DIR/scripts/install.sh" --tool claude --include-personal >/dev/null
assert_file "$TMP_DIR/home/.claude/skills/diagnose/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/karpathy-guidelines/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/improve-codebase-architecture/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/tdd/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/zoom-out/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/grill-me/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/grill-with-docs/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/write-a-skill/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/bcecmd/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/edit-article/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/obsidian-vault/SKILL.md"

echo "[test] cursor adapter"
bash "$REPO_DIR/scripts/install.sh" --tool cursor --project "$TMP_DIR/project" >/dev/null
assert_file "$TMP_DIR/project/.cursor/rules/wujs-curated-skills.mdc"

echo "[test] codex symlink"
HOME="$TMP_DIR/codex-symlink-home" bash "$REPO_DIR/scripts/install.sh" --tool codex --method symlink >/dev/null
[[ -L "$TMP_DIR/codex-symlink-home/.agents/skills/karpathy-guidelines" ]] || {
  echo "expected symlink install for karpathy-guidelines" >&2
  exit 1
}

echo "All install tests passed."
