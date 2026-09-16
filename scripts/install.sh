#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST="$REPO_DIR/manifest.json"

TOOL=""
METHOD="copy"
PROJECT_DIR="$PWD"
PRUNE=false
SCOPE="user"
CURSOR_SCOPE="project"

usage() {
  cat <<'USAGE'
Usage:
  bash scripts/install.sh --tool <codex|claude|cursor|all> [options]

Options:
  --method <copy|symlink>    Install method (default: copy)
  --scope <user|repo|legacy> Codex install scope (default: user)
  --cursor-scope <project|user>  Cursor skills + bridge: project .cursor/ or user ~/.cursor/ (default: project)
  --project <path>           Project path for Codex repo scope or Cursor project scope (default: cwd)
  --include-personal         Deprecated no-op; all catalog skills are included
  --prune                    Remove deprecated skill dirs listed in manifest.json
  -h, --help                 Show help

Examples:
  bash scripts/install.sh --tool codex
  bash scripts/install.sh --tool codex --scope repo --project /path/to/project
  bash scripts/install.sh --tool codex --scope legacy
  bash scripts/install.sh --tool claude --method symlink
  bash scripts/install.sh --tool cursor --project /path/to/project
  bash scripts/install.sh --tool cursor --cursor-scope user
  bash scripts/install.sh --tool all
  bash scripts/install.sh --tool codex --prune
USAGE
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --tool)
        [[ $# -lt 2 ]] && { echo "error: --tool requires a value" >&2; exit 1; }
        TOOL="$2"; shift 2 ;;
      --method)
        [[ $# -lt 2 ]] && { echo "error: --method requires a value" >&2; exit 1; }
        METHOD="$2"; shift 2 ;;
      --scope)
        [[ $# -lt 2 ]] && { echo "error: --scope requires a value" >&2; exit 1; }
        SCOPE="$2"; shift 2 ;;
      --project)
        [[ $# -lt 2 ]] && { echo "error: --project requires a value" >&2; exit 1; }
        PROJECT_DIR="$2"; shift 2 ;;
      --cursor-scope)
        [[ $# -lt 2 ]] && { echo "error: --cursor-scope requires a value" >&2; exit 1; }
        CURSOR_SCOPE="$2"; shift 2 ;;
      --include-personal)
        echo "warning: --include-personal is deprecated; all catalog skills are included." >&2; shift ;;
      --prune)
        PRUNE=true; shift ;;
      -h|--help)
        usage; exit 0 ;;
      *)
        echo "error: unknown argument: $1" >&2
        usage
        exit 1 ;;
    esac
  done

  [[ -z "$TOOL" ]] && { echo "error: --tool is required" >&2; usage; exit 1; }
  case "$TOOL" in codex|claude|cursor|all) ;; *) echo "error: unknown tool: $TOOL" >&2; exit 1 ;; esac
  case "$METHOD" in copy|symlink) ;; *) echo "error: --method must be copy or symlink" >&2; exit 1 ;; esac
  case "$SCOPE" in user|repo|legacy) ;; *) echo "error: --scope must be user, repo, or legacy" >&2; exit 1 ;; esac
  case "$CURSOR_SCOPE" in project|user) ;; *) echo "error: --cursor-scope must be project or user" >&2; exit 1 ;; esac
}

manifest_skill_dirs() {
  [[ -f "$MANIFEST" ]] || { echo "error: missing manifest: $MANIFEST" >&2; exit 1; }

  python3 - "$MANIFEST" <<'PY'
import json
import sys
from pathlib import Path

manifest = Path(sys.argv[1])
repo = manifest.parent
data = json.loads(manifest.read_text())

paths = list(data.get("skills", []))

for rel in paths:
    path = (repo / rel).resolve()
    if not (path / "SKILL.md").is_file():
        raise SystemExit(f"manifest entry missing SKILL.md: {rel}")
    print(path)
PY
}

ensure_not_repo_parent_symlink() {
  local dest="$1" src="$2"
  if [[ -L "$dest" ]]; then
    local resolved
    resolved="$(python3 - "$dest" <<'PYRESOLVE'
from pathlib import Path
import sys
print(Path(sys.argv[1]).resolve())
PYRESOLVE
)"
    # Safe refreshes replace the link itself, including now-dangling old paths.
    [[ "$resolved" == "$src" ]] && return 0
    case "$(basename "$src"):$resolved" in
      "bootstrap-shared-server:$REPO_DIR/skills/personal/bootstrap-shared-server"|\
      "obsidian-vault:$REPO_DIR/skills/personal/obsidian-vault") return 0 ;;
    esac
    case "$resolved" in
      "$REPO_DIR"|"$REPO_DIR"/*)
        echo "error: $dest is a symlink into this repo ($resolved)" >&2
        echo "Remove it first, then rerun the installer." >&2
        exit 1 ;;
    esac
  fi
}

install_dir() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  ensure_not_repo_parent_symlink "$dest" "$src"

  if [[ -e "$dest" && ! -L "$dest" && "$METHOD" == "symlink" ]]; then
    echo "error: refusing to replace non-symlink directory with symlink: $dest" >&2
    exit 1
  fi

  if [[ "$METHOD" == "symlink" ]]; then
    ln -sfn "$src" "$dest"
  else
    rm -rf "$dest"
    mkdir -p "$dest"
    cp -a "$src/." "$dest/"
  fi
}

manifest_deprecated_names() {
  python3 - "$MANIFEST" <<'PY'
import json
import sys
from pathlib import Path

data = json.loads(Path(sys.argv[1]).read_text())
active = {
    Path(entry).name
    for entry in data.get("skills", [])
}
for name in data.get("deprecated_skill_names", []):
    if not isinstance(name, str) or not name or "/" in name or name in (".", ".."):
        raise SystemExit(f"invalid deprecated_skill_names entry: {name!r}")
    if name in active:
        raise SystemExit(
            f"deprecated_skill_names entry {name!r} is still listed under skills"
        )
    print(name)
PY
}

prune_deprecated_skills() {
  local root="$1" label="$2"
  [[ "$PRUNE" == true ]] || return 0
  mkdir -p "$root"

  local name dest count=0
  while IFS= read -r name; do
    [[ -n "$name" ]] || continue
    dest="$root/$name"
    if [[ -e "$dest" || -L "$dest" ]]; then
      rm -rf "$dest"
      echo "[$label] pruned $name -> $dest"
      count=$((count + 1))
    fi
  done < <(manifest_deprecated_names)

  echo "[$label] pruned $count deprecated skill(s)"
}

install_agent_skills() {
  local root="$1" label="$2"
  mkdir -p "$root"

  local count=0
  while IFS= read -r src; do
    local name dest
    name="$(basename "$src")"
    dest="$root/$name"
    install_dir "$src" "$dest"
    echo "[$label] $METHOD $name -> $dest"
    count=$((count + 1))
  done < <(manifest_skill_dirs)

  echo "[$label] installed $count skill(s)"
  prune_deprecated_skills "$root" "$label"
}

install_codex() {
  case "$SCOPE" in
    user)
      install_agent_skills "$HOME/.agents/skills" "codex:user" ;;
    repo)
      install_agent_skills "$PROJECT_DIR/.agents/skills" "codex:repo" ;;
    legacy)
      install_agent_skills "${CODEX_HOME:-$HOME/.codex}/skills" "codex:legacy" ;;
  esac
}

install_claude() {
  install_agent_skills "$HOME/.claude/skills" "claude"
}

install_cursor() {
  local skills_root rules_dir label
  case "$CURSOR_SCOPE" in
    project)
      skills_root="$PROJECT_DIR/.cursor/skills"
      rules_dir="$PROJECT_DIR/.cursor/rules"
      label="cursor:project"
      ;;
    user)
      skills_root="$HOME/.cursor/skills"
      rules_dir="$HOME/.cursor/rules"
      label="cursor:user"
      ;;
  esac

  local src="$REPO_DIR/adapters/cursor/wujs-curated-skills.mdc"
  local dest="$rules_dir/wujs-curated-skills.mdc"

  [[ -f "$src" ]] || { echo "error: missing cursor adapter: $src" >&2; exit 1; }
  mkdir -p "$rules_dir"

  if [[ "$METHOD" == "symlink" ]]; then
    ln -sfn "$src" "$dest"
  else
    cp "$src" "$dest"
  fi

  echo "[$label] $METHOD adapter -> $dest"

  install_agent_skills "$skills_root" "$label"
}

main() {
  parse_args "$@"

  if [[ "$TOOL" == "codex" || "$TOOL" == "all" ]]; then
    install_codex
  fi
  if [[ "$TOOL" == "claude" || "$TOOL" == "all" ]]; then
    install_claude
  fi
  if [[ "$TOOL" == "cursor" || "$TOOL" == "all" ]]; then
    install_cursor
  fi
}

main "$@"
