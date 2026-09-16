---
name: obsidian-vault
description: "Use when finding, creating, or editing notes in an Obsidian vault while preserving its existing conventions and links."
---

# Obsidian Vault

Resolve the vault from the user or established project configuration. Ask for
its location only when missing; example paths are not defaults.

Read the relevant notes and nearby examples before editing. Follow their
filename casing, folder layout, frontmatter, tags, and index conventions.
A flat vault, Title Case filenames, and index notes are optional conventions,
not requirements to impose on an existing vault.

Search titles and content before creating a note. Extend a matching note when
that serves the request; clarify only when choosing between matches would
change the intended content or scope. Use `rg --files` and `rg` within the
resolved vault, or an available Obsidian interface.

Preserve wiki links, heading/block anchors, aliases, embeds, and frontmatter.
When a requested rename or move affects links, update the affected references
and indexes; check both wiki links and Markdown links, including relative asset
paths. Avoid changing unrelated notes or vault/plugin configuration.

Match the requested editing scope and the note’s voice. Add related links
where useful in the vault’s existing style. Verify changed links resolve and
report the note paths and any unresolved references.
