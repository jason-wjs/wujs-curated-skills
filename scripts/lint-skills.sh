#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

python3 - "$REPO_DIR" <<'PY'
import json
import re
import sys
from pathlib import Path
from urllib.parse import unquote

repo = Path(sys.argv[1])
errors: list[str] = []


def rel(path: Path) -> str:
    return str(path.relative_to(repo))


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def frontmatter(path: Path) -> dict[str, str]:
    text = read(path)
    lines = text.splitlines()
    if not lines or lines[0] != "---":
        errors.append(f"{rel(path)}: missing opening frontmatter marker")
        return {}
    try:
        end = lines[1:].index("---") + 1
    except ValueError:
        errors.append(f"{rel(path)}: missing closing frontmatter marker")
        return {}

    data: dict[str, str] = {}
    for line in lines[1:end]:
        if not line.strip() or line.startswith("#"):
            continue
        if ":" not in line:
            errors.append(f"{rel(path)}: invalid frontmatter line: {line}")
            continue
        key, value = line.split(":", 1)
        data[key.strip()] = value.strip().strip('"').strip("'")
    return data


manifest_path = repo / "manifest.json"
if not manifest_path.is_file():
    errors.append("missing manifest.json")
    manifest = {"skills": [], "personal": []}
else:
    manifest = json.loads(read(manifest_path))

manifest_entries = [
    Path(entry)
    for section in ("skills", "personal")
    for entry in manifest.get(section, [])
]

skill_dirs = sorted(path.parent for path in (repo / "skills").glob("*/*/SKILL.md"))
manifest_dirs = sorted((repo / entry).resolve() for entry in manifest_entries)

for entry in manifest_entries:
    directory = (repo / entry).resolve()
    if not (directory / "SKILL.md").is_file():
        errors.append(f"manifest entry missing SKILL.md: {entry}")

for directory in skill_dirs:
    skill = directory / "SKILL.md"
    data = frontmatter(skill)
    name = data.get("name")
    description = data.get("description")

    if not name:
        errors.append(f"{rel(skill)}: missing name frontmatter")
    elif not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", name):
        errors.append(f"{rel(skill)}: name must be kebab-case")
    elif name != directory.name:
        errors.append(f"{rel(skill)}: name '{name}' must match directory '{directory.name}'")

    if not description:
        errors.append(f"{rel(skill)}: missing description frontmatter")
    else:
        if len(description) > 1024:
            errors.append(f"{rel(skill)}: description exceeds 1024 characters")
        if "use when" not in description.lower() and "when " not in description.lower():
            errors.append(f"{rel(skill)}: description should include trigger conditions")

    bucket_readme = directory.parent / "README.md"
    if not bucket_readme.is_file():
        errors.append(f"{rel(directory.parent)}: missing README.md")
    else:
        bucket_text = read(bucket_readme)
        expected = f"./{directory.name}/SKILL.md"
        if expected not in bucket_text:
            errors.append(f"{rel(bucket_readme)}: missing link to {expected}")

    openai_yaml = directory / "agents" / "openai.yaml"
    explicit = data.get("disable-model-invocation") == "true"
    if data.get("disable-model-invocation", "false") not in {"true", "false"}:
        errors.append(f"{rel(skill)}: disable-model-invocation must be boolean")
    codex_explicit = False
    if openai_yaml.exists():
        text = read(openai_yaml)
        if not text.strip():
            errors.append(f"{rel(openai_yaml)}: file is empty")
        if "allow_implicit_invocation:" in text:
            value = text.split("allow_implicit_invocation:", 1)[1].splitlines()[0].strip()
            if value not in {"true", "false"}:
                errors.append(f"{rel(openai_yaml)}: allow_implicit_invocation must be true or false")
            codex_explicit = value == "false"
    if explicit != codex_explicit:
        errors.append(f"{rel(skill)}: explicit invocation differs between Codex and Claude/Cursor")

    # Validate real relative Markdown resource links, excluding fenced examples.
    for doc in directory.rglob("*.md"):
        body = re.sub(r"```.*?```", "", read(doc), flags=re.S)
        for target in re.findall(r"\]\(([^\s)]+)\)", body):
            target = unquote(target.split("#", 1)[0])
            if not target or "://" in target or target.startswith(("/", "mailto:")):
                continue
            if not (doc.parent / target).exists():
                errors.append(f"{rel(doc)}: missing linked resource {target}")

top_readme = repo / "README.md"
if top_readme.is_file():
    top_text = read(top_readme)
    for entry in manifest.get("skills", []):
        expected = f"{entry.removeprefix('./')}/SKILL.md"
        if expected not in top_text:
            errors.append(f"README.md: missing promoted skill link {expected}")
else:
    errors.append("missing README.md")

cursor_bridge = repo / "adapters" / "cursor" / "wujs-curated-skills.mdc"
if cursor_bridge.is_file():
    cursor_text = read(cursor_bridge)
    if "alwaysApply: false" not in cursor_text:
        errors.append(f"{rel(cursor_bridge)}: bridge must remain optional")
    for entry in manifest.get("personal", []):
        name = Path(entry).name
        if name in cursor_text:
            errors.append(f"{rel(cursor_bridge)}: should not include personal skill {name}")
else:
    errors.append(f"missing {rel(cursor_bridge)}")

for directory in manifest_dirs:
    if directory not in skill_dirs:
        errors.append(f"manifest entry is outside discovered skills: {rel(directory)}")

for directory in skill_dirs:
    if directory not in manifest_dirs:
        errors.append(f"{rel(directory)}: skill is not listed in manifest.json")

if errors:
    print("Skill lint failed:", file=sys.stderr)
    for error in errors:
        print(f"- {error}", file=sys.stderr)
    raise SystemExit(1)

print(f"Skill lint passed ({len(skill_dirs)} skills).")
PY
