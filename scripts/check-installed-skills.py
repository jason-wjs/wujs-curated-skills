#!/usr/bin/env python3
"""Check every installed resource, not just representative SKILL.md files."""
import json
import re
import sys
from pathlib import Path
from urllib.parse import unquote

repo = Path(__file__).resolve().parents[1]
staging = Path(sys.argv[1])
manifest = json.loads((repo / 'manifest.json').read_text())
# Mirrors the install scenarios in test-install.sh: path, personal, symlink.
cases = [
    ('codex-user-home/.agents/skills', False, False),
    ('codex-project/.agents/skills', True, False),
    ('codex-legacy/skills', False, False),
    ('home/.claude/skills', True, False),
    ('project/.cursor/skills', False, False),
    ('cursor-personal/.cursor/skills', True, False),
    ('cursor-symlink/.cursor/skills', False, True),
    ('cursor-user-home/.cursor/skills', False, False),
    ('all-user-home/.agents/skills', False, False),
    ('all-user-home/.claude/skills', False, False),
    ('all-user-home/.cursor/skills', False, False),
    ('codex-symlink-home/.agents/skills', False, True),
    ('codex-prune-home/.agents/skills', True, False),
    ('claude-symlink-home/.claude/skills', True, True),
]
for location, personal, symlink in cases:
    installed = staging / location
    entries = manifest['skills'] + (manifest['personal'] if personal else [])
    expected = {Path(entry).name for entry in entries}
    actual = {p.name for p in installed.iterdir()}
    assert actual == expected, (location, 'skill set mismatch', actual ^ expected)
    for entry in entries:
        source = repo / entry
        target = installed / source.name
        assert target.is_symlink() == symlink, target
        source_files = {p.relative_to(source) for p in source.rglob('*') if p.is_file()}
        target_files = {p.relative_to(target) for p in target.rglob('*') if p.is_file()}
        assert source_files == target_files, (target, 'resource set mismatch')
        for relative in source_files:
            assert (source / relative).read_bytes() == (target / relative).read_bytes(), target / relative
        for doc in target.rglob('*.md'):
            body = re.sub(r'```.*?```', '', doc.read_text(), flags=re.S)
            for link in re.findall(r'\]\(([^\s)]+)\)', body):
                link = unquote(link.split('#', 1)[0])
                if not link or '://' in link or link.startswith(('/', 'mailto:')):
                    continue
                assert (doc.parent / link).exists(), (doc, link)
print(f'Complete packages and relative resources verified in {len(cases)} install scenarios.')
