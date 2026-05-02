---
name: obsidian-vault
description: Use when finding, creating, editing, linking, or organizing notes in the Obsidian vault, especially when preserving wikilinks, index notes, backlinks, and the vault's existing flat note conventions matters.
---

# Obsidian Vault

## Vault

Path: `path/to/my/obsidian-vault`

The vault is mostly flat at the root. Prefer links and index notes over folder
hierarchies.

## Safety Rules

- Search before creating a note; avoid duplicates with slightly different names.
- Do not delete, bulk rename, or bulk move notes unless explicitly requested.
- Preserve existing note structure and voice when editing.
- Keep local absolute paths out of note content unless the note already uses
  them or the user asks for them.
- When unsure whether a note should be new or merged into an existing note,
  report the closest matches and ask.

## Naming

- Use Title Case filenames: `Topic Name.md`.
- Use index notes to aggregate related topics: `Skills Index.md`, `RAG Index.md`.
- Index notes are lists or short sections of `[[wikilinks]]`.
- If an existing numbered sequence is present, continue that sequence.
- Do not introduce folders for organization unless the vault already has a
  matching local convention for that topic.

## Obsidian Syntax

- Link to notes with `[[Note Title]]`.
- Link to sections with `[[Note Title#Heading]]`.
- Use aliases when helpful: `[[Canonical Note|display text]]`.
- Embed notes or assets only when requested: `![[Note Title]]`.
- Use tags sparingly and only when nearby notes already use the same tag style.
- Use callouts when they improve scanability:

```markdown
> [!note]
> Short note text.
```

## Search Workflow

Prefer `rg` for content search and `find` for filenames:

```bash
VAULT="/mnt/d/Obsidian Vault/AI Research"

find "$VAULT" -iname "*keyword*.md"
rg -n "keyword|related phrase" "$VAULT" --glob "*.md"
find "$VAULT" -iname "*Index*.md"
```

Before creating a note:

1. Search by likely title words.
2. Search by content synonyms.
3. Search index notes for related clusters.
4. Search backlinks if extending an existing topic.

## Create Note Workflow

1. Pick the most specific Title Case filename that matches the vault style.
2. Write the note as a compact unit of learning.
3. Add links to related notes near the bottom under a short heading such as
   `## Related`.
4. Update the most relevant index note if one exists.
5. If no relevant index exists, mention that rather than creating one by
   default.

## Edit Note Workflow

1. Read the full note before editing.
2. Preserve existing headings, links, tags, and formatting unless changing them
   is the point of the task.
3. Keep edits local to the requested section or topic.
4. Add new related links only when they materially improve navigation.
5. After editing, check whether backlinks or index notes need a small update.

## Backlinks

Find notes that link to a note:

```bash
rg -n "\\[\\[Note Title(\\||\\]|#)" "/mnt/d/Obsidian Vault/AI Research" --glob "*.md"
```

When renaming a note, update backlinks in the same turn unless the user asks not
to rename references.
