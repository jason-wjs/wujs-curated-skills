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
assert_file "$TMP_DIR/codex-user-home/.agents/skills/shared-server-codex-isolation/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/shared-server-codex-isolation/references/placement-rules.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/shared-server-codex-isolation/agents/openai.yaml"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/bcecmd/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/bcecmd/references/setup-and-troubleshooting.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/shared-server-git-private/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/shared-server-git-private/references/setup-git-local-helper.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/shared-server-git-private/references/pat-and-credentials.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/shared-server-git-private/agents/openai.yaml"
assert_no_path "$TMP_DIR/codex-user-home/.agents/skills/obsidian-vault"
assert_no_path "$TMP_DIR/codex-user-home/.agents/skills/research-paper-writing"

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
assert_file "$TMP_DIR/codex-project/.agents/skills/shared-server-codex-isolation/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/shared-server-codex-isolation/references/placement-rules.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/shared-server-codex-isolation/agents/openai.yaml"
assert_file "$TMP_DIR/codex-project/.agents/skills/bcecmd/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/edit-article/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/obsidian-vault/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/research-paper-writing/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/research-paper-writing/agents/openai.yaml"
assert_file "$TMP_DIR/codex-project/.agents/skills/shared-server-git-private/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/shared-server-git-private/references/setup-git-local-helper.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/shared-server-git-private/references/pat-and-credentials.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/shared-server-git-private/agents/openai.yaml"

echo "[test] codex legacy copy"
CODEX_HOME="$TMP_DIR/codex-legacy" bash "$REPO_DIR/scripts/install.sh" --tool codex --scope legacy >/dev/null
assert_file "$TMP_DIR/codex-legacy/skills/diagnose/SKILL.md"
assert_file "$TMP_DIR/codex-legacy/skills/shared-server-codex-isolation/SKILL.md"
assert_file "$TMP_DIR/codex-legacy/skills/shared-server-codex-isolation/references/placement-rules.md"
assert_file "$TMP_DIR/codex-legacy/skills/shared-server-codex-isolation/agents/openai.yaml"
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
assert_file "$TMP_DIR/home/.claude/skills/shared-server-codex-isolation/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/shared-server-codex-isolation/references/placement-rules.md"
assert_file "$TMP_DIR/home/.claude/skills/shared-server-codex-isolation/agents/openai.yaml"
assert_file "$TMP_DIR/home/.claude/skills/bcecmd/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/edit-article/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/obsidian-vault/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/research-paper-writing/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/shared-server-git-private/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/shared-server-git-private/references/setup-git-local-helper.md"
assert_file "$TMP_DIR/home/.claude/skills/shared-server-git-private/references/pat-and-credentials.md"
assert_file "$TMP_DIR/home/.claude/skills/shared-server-git-private/agents/openai.yaml"

echo "[test] cursor install copies bridge rule and Cursor skill directories"
bash "$REPO_DIR/scripts/install.sh" --tool cursor --project "$TMP_DIR/project" >/dev/null
assert_file "$TMP_DIR/project/.cursor/rules/wujs-curated-skills.mdc"
assert_file "$TMP_DIR/project/.cursor/skills/diagnose/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/karpathy-guidelines/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/improve-codebase-architecture/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/tdd/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/zoom-out/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/zoom-out/agents/openai.yaml"
assert_file "$TMP_DIR/project/.cursor/skills/grill-me/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/grill-me/agents/openai.yaml"
assert_file "$TMP_DIR/project/.cursor/skills/grill-with-docs/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/grill-with-docs/agents/openai.yaml"
assert_file "$TMP_DIR/project/.cursor/skills/write-a-skill/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/shared-server-codex-isolation/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/shared-server-codex-isolation/references/placement-rules.md"
assert_file "$TMP_DIR/project/.cursor/skills/shared-server-codex-isolation/agents/openai.yaml"
assert_file "$TMP_DIR/project/.cursor/skills/bcecmd/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/bcecmd/references/setup-and-troubleshooting.md"
assert_file "$TMP_DIR/project/.cursor/skills/shared-server-git-private/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/shared-server-git-private/references/setup-git-local-helper.md"
assert_file "$TMP_DIR/project/.cursor/skills/shared-server-git-private/references/pat-and-credentials.md"
assert_file "$TMP_DIR/project/.cursor/skills/shared-server-git-private/agents/openai.yaml"
assert_no_path "$TMP_DIR/project/.cursor/skills/obsidian-vault"
assert_no_path "$TMP_DIR/project/.cursor/skills/research-paper-writing"

echo "[test] cursor install includes personal skills when requested"
bash "$REPO_DIR/scripts/install.sh" --tool cursor --project "$TMP_DIR/cursor-personal" --include-personal >/dev/null
assert_file "$TMP_DIR/cursor-personal/.cursor/skills/edit-article/SKILL.md"
assert_file "$TMP_DIR/cursor-personal/.cursor/skills/obsidian-vault/SKILL.md"
assert_file "$TMP_DIR/cursor-personal/.cursor/skills/research-paper-writing/SKILL.md"

echo "[test] cursor symlink skill install"
bash "$REPO_DIR/scripts/install.sh" --tool cursor --project "$TMP_DIR/cursor-symlink" --method symlink >/dev/null
[[ -L "$TMP_DIR/cursor-symlink/.cursor/rules/wujs-curated-skills.mdc" ]] || {
  echo "expected symlink install for cursor bridge" >&2
  exit 1
}
[[ -L "$TMP_DIR/cursor-symlink/.cursor/skills/karpathy-guidelines" ]] || {
  echo "expected symlink install for karpathy-guidelines" >&2
  exit 1
}

echo "[test] cursor user scope installs skills and bridge under HOME/.cursor"
fake_project="$TMP_DIR/cursor-user-ignored-project"
mkdir -p "$fake_project"
HOME="$TMP_DIR/cursor-user-home" bash "$REPO_DIR/scripts/install.sh" --tool cursor --cursor-scope user --project "$fake_project" >/dev/null
assert_file "$TMP_DIR/cursor-user-home/.cursor/skills/diagnose/SKILL.md"
assert_file "$TMP_DIR/cursor-user-home/.cursor/skills/shared-server-codex-isolation/SKILL.md"
assert_file "$TMP_DIR/cursor-user-home/.cursor/skills/shared-server-codex-isolation/references/placement-rules.md"
assert_file "$TMP_DIR/cursor-user-home/.cursor/skills/shared-server-codex-isolation/agents/openai.yaml"
assert_file "$TMP_DIR/cursor-user-home/.cursor/skills/bcecmd/references/setup-and-troubleshooting.md"
assert_file "$TMP_DIR/cursor-user-home/.cursor/skills/shared-server-git-private/SKILL.md"
assert_file "$TMP_DIR/cursor-user-home/.cursor/rules/wujs-curated-skills.mdc"
assert_no_path "$fake_project/.cursor"

echo "[test] cursor user scope rejects invalid --cursor-scope"
if HOME="$TMP_DIR/cursor-user-home2" bash "$REPO_DIR/scripts/install.sh" --tool cursor --cursor-scope bogus --project "$TMP_DIR/x" 2>/dev/null; then
  echo "expected failure for bogus --cursor-scope" >&2
  exit 1
fi

echo "[test] tool all respects cursor user scope for HOME/.cursor"
HOME="$TMP_DIR/all-user-home" bash "$REPO_DIR/scripts/install.sh" --tool all --cursor-scope user >/dev/null
assert_file "$TMP_DIR/all-user-home/.agents/skills/diagnose/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.agents/skills/shared-server-codex-isolation/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.agents/skills/shared-server-codex-isolation/references/placement-rules.md"
assert_file "$TMP_DIR/all-user-home/.agents/skills/shared-server-codex-isolation/agents/openai.yaml"
assert_file "$TMP_DIR/all-user-home/.claude/skills/diagnose/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.claude/skills/shared-server-codex-isolation/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.claude/skills/shared-server-codex-isolation/references/placement-rules.md"
assert_file "$TMP_DIR/all-user-home/.claude/skills/shared-server-codex-isolation/agents/openai.yaml"
assert_file "$TMP_DIR/all-user-home/.cursor/skills/diagnose/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.cursor/skills/shared-server-codex-isolation/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.cursor/skills/shared-server-codex-isolation/references/placement-rules.md"
assert_file "$TMP_DIR/all-user-home/.cursor/skills/shared-server-codex-isolation/agents/openai.yaml"
assert_file "$TMP_DIR/all-user-home/.cursor/skills/bcecmd/references/setup-and-troubleshooting.md"
assert_file "$TMP_DIR/all-user-home/.cursor/skills/shared-server-git-private/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.cursor/rules/wujs-curated-skills.mdc"

echo "[test] codex symlink"
HOME="$TMP_DIR/codex-symlink-home" bash "$REPO_DIR/scripts/install.sh" --tool codex --method symlink >/dev/null
[[ -L "$TMP_DIR/codex-symlink-home/.agents/skills/karpathy-guidelines" ]] || {
  echo "expected symlink install for karpathy-guidelines" >&2
  exit 1
}

echo "All install tests passed."
