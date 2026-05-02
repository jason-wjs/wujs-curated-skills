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

echo "[test] codex copy skips personal by default"
CODEX_HOME="$TMP_DIR/codex-default" bash "$REPO_DIR/scripts/install.sh" --tool codex >/dev/null
assert_file "$TMP_DIR/codex-default/skills/karpathy-guidelines/SKILL.md"
assert_file "$TMP_DIR/codex-default/skills/grill-me/SKILL.md"
assert_file "$TMP_DIR/codex-default/skills/grill-with-docs/SKILL.md"
assert_file "$TMP_DIR/codex-default/skills/write-a-skill/SKILL.md"
assert_file "$TMP_DIR/codex-default/skills/bcecmd/SKILL.md"
assert_no_path "$TMP_DIR/codex-default/skills/obsidian-vault"

echo "[test] codex copy includes personal when requested"
CODEX_HOME="$TMP_DIR/codex-personal" bash "$REPO_DIR/scripts/install.sh" --tool codex --include-personal >/dev/null
assert_file "$TMP_DIR/codex-personal/skills/karpathy-guidelines/SKILL.md"
assert_file "$TMP_DIR/codex-personal/skills/grill-me/SKILL.md"
assert_file "$TMP_DIR/codex-personal/skills/grill-with-docs/SKILL.md"
assert_file "$TMP_DIR/codex-personal/skills/write-a-skill/SKILL.md"
assert_file "$TMP_DIR/codex-personal/skills/bcecmd/SKILL.md"
assert_file "$TMP_DIR/codex-personal/skills/edit-article/SKILL.md"
assert_file "$TMP_DIR/codex-personal/skills/obsidian-vault/SKILL.md"

echo "[test] claude copy uses temporary HOME"
HOME="$TMP_DIR/home" bash "$REPO_DIR/scripts/install.sh" --tool claude --include-personal >/dev/null
assert_file "$TMP_DIR/home/.claude/skills/karpathy-guidelines/SKILL.md"
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
CODEX_HOME="$TMP_DIR/codex-symlink" bash "$REPO_DIR/scripts/install.sh" --tool codex --method symlink >/dev/null
[[ -L "$TMP_DIR/codex-symlink/skills/karpathy-guidelines" ]] || {
  echo "expected symlink install for karpathy-guidelines" >&2
  exit 1
}

echo "All install tests passed."
