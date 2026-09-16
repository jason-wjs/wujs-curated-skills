#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/wujs-curated-skills-install-test.XXXXXX")"
trap 'rm -rf "$TMP_DIR"' EXIT

assert_file() {
  local path="$1"
  [[ -f "$path" ]] || { echo "missing file: $path" >&2; exit 1; }
}

assert_no_path() {
  local path="$1"
  [[ ! -e "$path" && ! -L "$path" ]] || { echo "unexpected path exists: $path" >&2; exit 1; }
}

echo "[test] installer help"
bash "$REPO_DIR/scripts/install.sh" --help >/dev/null

echo "[test] skill lint"
bash "$REPO_DIR/scripts/lint-skills.sh" >/dev/null

echo "[test] codex user copy includes all skills by default"
HOME="$TMP_DIR/codex-user-home" bash "$REPO_DIR/scripts/install.sh" --tool codex >/dev/null
assert_file "$TMP_DIR/codex-user-home/.agents/skills/diagnosing-bugs/SKILL.md"
assert_no_path "$TMP_DIR/codex-user-home/.agents/skills/karpathy-guidelines"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/improve-codebase-architecture/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/improve-codebase-architecture/HTML-REPORT.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/improve-codebase-architecture/agents/openai.yaml"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/tdd/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/tdd/agents/openai.yaml"
assert_no_path "$TMP_DIR/codex-user-home/.agents/skills/zoom-out"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/grill-me/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/grill-me/agents/openai.yaml"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/handoff/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/grill-with-docs/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/grill-with-docs/agents/openai.yaml"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/teach/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/teach/MISSION-FORMAT.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/write-a-skill/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/bcecmd/SKILL.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/bcecmd/references/setup-and-troubleshooting.md"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/bootstrap-shared-server/SKILL.md"
assert_no_path "$TMP_DIR/codex-user-home/.agents/skills/shared-server-codex-isolation"
assert_no_path "$TMP_DIR/codex-user-home/.agents/skills/shared-server-git-private"
assert_file "$TMP_DIR/codex-user-home/.agents/skills/obsidian-vault/SKILL.md"
assert_no_path "$TMP_DIR/codex-user-home/.agents/skills/research-paper-writing"

echo "[test] codex repo copy includes all skills"
bash "$REPO_DIR/scripts/install.sh" --tool codex --scope repo --project "$TMP_DIR/codex-project" >/dev/null
assert_file "$TMP_DIR/codex-project/.agents/skills/diagnosing-bugs/SKILL.md"
assert_no_path "$TMP_DIR/codex-project/.agents/skills/karpathy-guidelines"
assert_file "$TMP_DIR/codex-project/.agents/skills/improve-codebase-architecture/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/tdd/SKILL.md"
assert_no_path "$TMP_DIR/codex-project/.agents/skills/zoom-out"
assert_file "$TMP_DIR/codex-project/.agents/skills/grill-me/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/handoff/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/grill-with-docs/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/teach/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/teach/MISSION-FORMAT.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/write-a-skill/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/bcecmd/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/bootstrap-shared-server/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/bootstrap-shared-server/references/private-git.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/bootstrap-shared-server/references/codex-isolation.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/bootstrap-shared-server/references/codex-app-ssh.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/bootstrap-shared-server/scripts/render_profile.py"
assert_file "$TMP_DIR/codex-project/.agents/skills/bootstrap-shared-server/agents/openai.yaml"
assert_no_path "$TMP_DIR/codex-project/.agents/skills/edit-article"
assert_file "$TMP_DIR/codex-project/.agents/skills/obsidian-vault/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/paper-writing/SKILL.md"
assert_file "$TMP_DIR/codex-project/.agents/skills/paper-writing/agents/openai.yaml"
assert_no_path "$TMP_DIR/codex-project/.agents/skills/shared-server-codex-isolation"
assert_no_path "$TMP_DIR/codex-project/.agents/skills/shared-server-git-private"

echo "[test] codex legacy copy"
CODEX_HOME="$TMP_DIR/codex-legacy" bash "$REPO_DIR/scripts/install.sh" --tool codex --scope legacy >/dev/null
assert_file "$TMP_DIR/codex-legacy/skills/diagnosing-bugs/SKILL.md"
assert_file "$TMP_DIR/codex-legacy/skills/handoff/SKILL.md"
assert_file "$TMP_DIR/codex-legacy/skills/teach/SKILL.md"
assert_file "$TMP_DIR/codex-legacy/skills/teach/MISSION-FORMAT.md"
assert_file "$TMP_DIR/codex-legacy/skills/bootstrap-shared-server/SKILL.md"
assert_no_path "$TMP_DIR/codex-legacy/skills/shared-server-codex-isolation"
assert_no_path "$TMP_DIR/codex-legacy/skills/shared-server-git-private"
assert_file "$TMP_DIR/codex-legacy/skills/obsidian-vault/SKILL.md"

echo "[test] claude copy uses temporary HOME"
HOME="$TMP_DIR/home" bash "$REPO_DIR/scripts/install.sh" --tool claude >/dev/null
assert_file "$TMP_DIR/home/.claude/skills/diagnosing-bugs/SKILL.md"
assert_no_path "$TMP_DIR/home/.claude/skills/karpathy-guidelines"
assert_file "$TMP_DIR/home/.claude/skills/improve-codebase-architecture/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/tdd/SKILL.md"
assert_no_path "$TMP_DIR/home/.claude/skills/zoom-out"
assert_file "$TMP_DIR/home/.claude/skills/grill-me/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/handoff/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/grill-with-docs/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/teach/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/teach/MISSION-FORMAT.md"
assert_file "$TMP_DIR/home/.claude/skills/write-a-skill/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/bcecmd/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/bootstrap-shared-server/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/bootstrap-shared-server/references/network-and-proxy.md"
assert_file "$TMP_DIR/home/.claude/skills/bootstrap-shared-server/references/private-git.md"
assert_file "$TMP_DIR/home/.claude/skills/bootstrap-shared-server/references/codex-isolation.md"
assert_file "$TMP_DIR/home/.claude/skills/bootstrap-shared-server/scripts/render_profile.py"
assert_no_path "$TMP_DIR/home/.claude/skills/edit-article"
assert_file "$TMP_DIR/home/.claude/skills/obsidian-vault/SKILL.md"
assert_file "$TMP_DIR/home/.claude/skills/paper-writing/SKILL.md"
assert_no_path "$TMP_DIR/home/.claude/skills/shared-server-codex-isolation"
assert_no_path "$TMP_DIR/home/.claude/skills/shared-server-git-private"

echo "[test] cursor install copies bridge rule and Cursor skill directories"
bash "$REPO_DIR/scripts/install.sh" --tool cursor --project "$TMP_DIR/project" >/dev/null
assert_file "$TMP_DIR/project/.cursor/rules/wujs-curated-skills.mdc"
assert_file "$TMP_DIR/project/.cursor/skills/diagnosing-bugs/SKILL.md"
assert_no_path "$TMP_DIR/project/.cursor/skills/karpathy-guidelines"
assert_file "$TMP_DIR/project/.cursor/skills/improve-codebase-architecture/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/improve-codebase-architecture/HTML-REPORT.md"
assert_file "$TMP_DIR/project/.cursor/skills/improve-codebase-architecture/agents/openai.yaml"
assert_file "$TMP_DIR/project/.cursor/skills/tdd/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/tdd/agents/openai.yaml"
assert_no_path "$TMP_DIR/project/.cursor/skills/zoom-out"
assert_file "$TMP_DIR/project/.cursor/skills/grill-me/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/grill-me/agents/openai.yaml"
assert_file "$TMP_DIR/project/.cursor/skills/handoff/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/grill-with-docs/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/grill-with-docs/agents/openai.yaml"
assert_file "$TMP_DIR/project/.cursor/skills/teach/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/teach/MISSION-FORMAT.md"
assert_file "$TMP_DIR/project/.cursor/skills/write-a-skill/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/bcecmd/SKILL.md"
assert_file "$TMP_DIR/project/.cursor/skills/bcecmd/references/setup-and-troubleshooting.md"
assert_file "$TMP_DIR/project/.cursor/skills/bootstrap-shared-server/SKILL.md"
assert_no_path "$TMP_DIR/project/.cursor/skills/shared-server-codex-isolation"
assert_no_path "$TMP_DIR/project/.cursor/skills/shared-server-git-private"
assert_file "$TMP_DIR/project/.cursor/skills/obsidian-vault/SKILL.md"
assert_no_path "$TMP_DIR/project/.cursor/skills/research-paper-writing"

echo "[test] cursor install accepts deprecated include-personal option"
bash "$REPO_DIR/scripts/install.sh" --tool cursor --project "$TMP_DIR/cursor-compat" --include-personal >/dev/null 2>"$TMP_DIR/compat-warning"
rg -q "deprecated" "$TMP_DIR/compat-warning"
assert_file "$TMP_DIR/cursor-compat/.cursor/skills/bootstrap-shared-server/SKILL.md"
assert_file "$TMP_DIR/cursor-compat/.cursor/skills/bootstrap-shared-server/references/operating-contract.md"
assert_file "$TMP_DIR/cursor-compat/.cursor/skills/bootstrap-shared-server/references/verification-and-rollback.md"
assert_file "$TMP_DIR/cursor-compat/.cursor/skills/bootstrap-shared-server/scripts/render_profile.py"
assert_no_path "$TMP_DIR/cursor-compat/.cursor/skills/edit-article"
assert_file "$TMP_DIR/cursor-compat/.cursor/skills/obsidian-vault/SKILL.md"
assert_file "$TMP_DIR/cursor-compat/.cursor/skills/paper-writing/SKILL.md"

echo "[test] cursor symlink skill install"
bash "$REPO_DIR/scripts/install.sh" --tool cursor --project "$TMP_DIR/cursor-symlink" --method symlink >/dev/null
[[ -L "$TMP_DIR/cursor-symlink/.cursor/rules/wujs-curated-skills.mdc" ]] || {
  echo "expected symlink install for cursor bridge" >&2
  exit 1
}
[[ -L "$TMP_DIR/cursor-symlink/.cursor/skills/tdd" ]] || {
  echo "expected symlink install for tdd" >&2
  exit 1
}

echo "[test] cursor user scope installs skills and bridge under HOME/.cursor"
fake_project="$TMP_DIR/cursor-user-ignored-project"
mkdir -p "$fake_project"
HOME="$TMP_DIR/cursor-user-home" bash "$REPO_DIR/scripts/install.sh" --tool cursor --cursor-scope user --project "$fake_project" >/dev/null
assert_file "$TMP_DIR/cursor-user-home/.cursor/skills/diagnosing-bugs/SKILL.md"
assert_file "$TMP_DIR/cursor-user-home/.cursor/skills/handoff/SKILL.md"
assert_file "$TMP_DIR/cursor-user-home/.cursor/skills/teach/SKILL.md"
assert_file "$TMP_DIR/cursor-user-home/.cursor/skills/teach/MISSION-FORMAT.md"
assert_file "$TMP_DIR/cursor-user-home/.cursor/skills/bcecmd/references/setup-and-troubleshooting.md"
assert_file "$TMP_DIR/cursor-user-home/.cursor/rules/wujs-curated-skills.mdc"
assert_file "$TMP_DIR/cursor-user-home/.cursor/skills/bootstrap-shared-server/SKILL.md"
assert_no_path "$TMP_DIR/cursor-user-home/.cursor/skills/shared-server-codex-isolation"
assert_no_path "$TMP_DIR/cursor-user-home/.cursor/skills/shared-server-git-private"
assert_no_path "$fake_project/.cursor"

echo "[test] cursor user scope rejects invalid --cursor-scope"
if HOME="$TMP_DIR/cursor-user-home2" bash "$REPO_DIR/scripts/install.sh" --tool cursor --cursor-scope bogus --project "$TMP_DIR/x" 2>/dev/null; then
  echo "expected failure for bogus --cursor-scope" >&2
  exit 1
fi

echo "[test] tool all respects cursor user scope for HOME/.cursor"
HOME="$TMP_DIR/all-user-home" bash "$REPO_DIR/scripts/install.sh" --tool all --cursor-scope user >/dev/null
assert_file "$TMP_DIR/all-user-home/.agents/skills/diagnosing-bugs/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.agents/skills/handoff/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.agents/skills/teach/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.agents/skills/teach/MISSION-FORMAT.md"
assert_file "$TMP_DIR/all-user-home/.agents/skills/bootstrap-shared-server/SKILL.md"
assert_no_path "$TMP_DIR/all-user-home/.agents/skills/shared-server-codex-isolation"
assert_no_path "$TMP_DIR/all-user-home/.agents/skills/shared-server-git-private"
assert_file "$TMP_DIR/all-user-home/.claude/skills/diagnosing-bugs/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.claude/skills/handoff/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.claude/skills/teach/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.claude/skills/teach/MISSION-FORMAT.md"
assert_file "$TMP_DIR/all-user-home/.claude/skills/bootstrap-shared-server/SKILL.md"
assert_no_path "$TMP_DIR/all-user-home/.claude/skills/shared-server-codex-isolation"
assert_no_path "$TMP_DIR/all-user-home/.claude/skills/shared-server-git-private"
assert_file "$TMP_DIR/all-user-home/.cursor/skills/diagnosing-bugs/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.cursor/skills/handoff/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.cursor/skills/teach/SKILL.md"
assert_file "$TMP_DIR/all-user-home/.cursor/skills/teach/MISSION-FORMAT.md"
assert_file "$TMP_DIR/all-user-home/.cursor/skills/bcecmd/references/setup-and-troubleshooting.md"
assert_file "$TMP_DIR/all-user-home/.cursor/rules/wujs-curated-skills.mdc"
assert_file "$TMP_DIR/all-user-home/.cursor/skills/bootstrap-shared-server/SKILL.md"
assert_no_path "$TMP_DIR/all-user-home/.cursor/skills/shared-server-codex-isolation"
assert_no_path "$TMP_DIR/all-user-home/.cursor/skills/shared-server-git-private"

echo "[test] codex symlink"
HOME="$TMP_DIR/codex-symlink-home" bash "$REPO_DIR/scripts/install.sh" --tool codex --method symlink >/dev/null
[[ -L "$TMP_DIR/codex-symlink-home/.agents/skills/tdd" ]] || {
  echo "expected symlink install for tdd" >&2
  exit 1
}

echo "[test] codex --prune removes deprecated skill dirs only when requested"
HOME="$TMP_DIR/codex-prune-home" bash "$REPO_DIR/scripts/install.sh" --tool codex >/dev/null
mkdir -p \
  "$TMP_DIR/codex-prune-home/.agents/skills/karpathy-guidelines" \
  "$TMP_DIR/codex-prune-home/.agents/skills/writing-great-skills" \
  "$TMP_DIR/codex-prune-home/.agents/skills/shared-server-codex-isolation" \
  "$TMP_DIR/codex-prune-home/.agents/skills/shared-server-git-private"
echo "stale" > "$TMP_DIR/codex-prune-home/.agents/skills/karpathy-guidelines/SKILL.md"
echo "stale" > "$TMP_DIR/codex-prune-home/.agents/skills/writing-great-skills/SKILL.md"
echo "stale" > "$TMP_DIR/codex-prune-home/.agents/skills/shared-server-codex-isolation/SKILL.md"
echo "stale" > "$TMP_DIR/codex-prune-home/.agents/skills/shared-server-git-private/SKILL.md"
HOME="$TMP_DIR/codex-prune-home" bash "$REPO_DIR/scripts/install.sh" --tool codex >/dev/null
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/karpathy-guidelines/SKILL.md"
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/writing-great-skills/SKILL.md"
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/shared-server-codex-isolation/SKILL.md"
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/shared-server-git-private/SKILL.md"
HOME="$TMP_DIR/codex-prune-home" bash "$REPO_DIR/scripts/install.sh" --tool codex --prune >/dev/null
assert_no_path "$TMP_DIR/codex-prune-home/.agents/skills/karpathy-guidelines"
assert_no_path "$TMP_DIR/codex-prune-home/.agents/skills/writing-great-skills"
assert_no_path "$TMP_DIR/codex-prune-home/.agents/skills/shared-server-codex-isolation"
assert_no_path "$TMP_DIR/codex-prune-home/.agents/skills/shared-server-git-private"
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/bootstrap-shared-server/SKILL.md"
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/write-a-skill/SKILL.md"
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/grilling/SKILL.md"
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/to-spec/SKILL.md"
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/code-review/SKILL.md"
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/research/SKILL.md"
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/codebase-design/SKILL.md"
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/domain-modeling/CONTEXT-FORMAT.md"
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/diagnosing-bugs/scripts/hitl-loop.template.sh"

echo "[test] obsolete writing skills are preserved without prune and removed with prune"
for name in research-paper-writing edit-article; do
  mkdir -p "$TMP_DIR/codex-prune-home/.agents/skills/$name"
  echo "stale" > "$TMP_DIR/codex-prune-home/.agents/skills/$name/SKILL.md"
done
HOME="$TMP_DIR/codex-prune-home" bash "$REPO_DIR/scripts/install.sh" --tool codex >/dev/null
for name in research-paper-writing edit-article; do
  assert_file "$TMP_DIR/codex-prune-home/.agents/skills/$name/SKILL.md"
done
HOME="$TMP_DIR/codex-prune-home" bash "$REPO_DIR/scripts/install.sh" --tool codex --prune >/dev/null
for name in research-paper-writing edit-article; do
  assert_no_path "$TMP_DIR/codex-prune-home/.agents/skills/$name"
done
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/paper-writing/SKILL.md"
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/general-writing/SKILL.md"
assert_file "$TMP_DIR/codex-prune-home/.agents/skills/general-writing/references/editing-contract.md"

echo "[test] claude symlink includes all skills"
HOME="$TMP_DIR/claude-symlink-home" bash "$REPO_DIR/scripts/install.sh" --tool claude --method symlink >/dev/null

echo "[test] repeat symlink installs and refresh former personal source links"
HOME="$TMP_DIR/codex-symlink-home" bash "$REPO_DIR/scripts/install.sh" --tool codex --method symlink >/dev/null
for method in copy symlink; do
  migration_home="$TMP_DIR/migrate-$method"
  mkdir -p "$migration_home/.agents/skills"
  for name in bootstrap-shared-server obsidian-vault; do
    ln -s "$REPO_DIR/skills/personal/$name" "$migration_home/.agents/skills/$name"
  done
  HOME="$migration_home" bash "$REPO_DIR/scripts/install.sh" --tool codex --method "$method" >/dev/null
  assert_file "$migration_home/.agents/skills/bootstrap-shared-server/SKILL.md"
  assert_file "$migration_home/.agents/skills/obsidian-vault/SKILL.md"
  cmp "$REPO_DIR/skills/engineering/bootstrap-shared-server/SKILL.md" "$migration_home/.agents/skills/bootstrap-shared-server/SKILL.md"
  cmp "$REPO_DIR/skills/tools/obsidian-vault/SKILL.md" "$migration_home/.agents/skills/obsidian-vault/SKILL.md"
done

echo "[test] misplaced source link is rejected without changing repository"
mkdir -p "$TMP_DIR/bad-link-home/.agents/skills"
ln -s "$REPO_DIR" "$TMP_DIR/bad-link-home/.agents/skills/bootstrap-shared-server"
if HOME="$TMP_DIR/bad-link-home" bash "$REPO_DIR/scripts/install.sh" --tool codex >"$TMP_DIR/bad-link-output" 2>&1; then
  echo "expected refusal for link to repository root" >&2
  exit 1
fi
rg -q 'symlink into this repo' "$TMP_DIR/bad-link-output"
assert_file "$REPO_DIR/manifest.json"

echo "[test] bootstrap candidate behavior"
python3 "$REPO_DIR/scripts/test-bootstrap-profile.py"

echo "[test] complete packages across supported install locations"
python3 "$REPO_DIR/scripts/check-installed-skills.py" "$TMP_DIR"

echo "All install tests passed."
