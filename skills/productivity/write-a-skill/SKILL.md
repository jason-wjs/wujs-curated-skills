---
name: write-a-skill
description: Create or improve agent skills with predictable structure, progressive disclosure, and bundled resources. Use when the user wants to create, write, edit, or refine a skill.
---

# Writing Skills

A skill exists to wrangle determinism out of a stochastic system. **Predictability** — the agent taking the same *process* every run, not producing the same output — is the root virtue. Bold terms below are defined in [GLOSSARY.md](./GLOSSARY.md).

## Process

1. **Gather requirements** - ask user about:
   - What task/domain does the skill cover?
   - What specific use cases should it handle?
   - Should it be **user-invoked** (explicit only) or **model-invoked** (discoverable from the prompt)?
   - Does it need executable scripts, or should it stay instruction-only?
   - Any reference materials to include?

2. **Draft the skill** - create:
   - SKILL.md with concise instructions
   - references/ files for long or rarely used material
   - scripts/ files if deterministic operations are needed
   - assets/ files for templates or reusable resources
   - agents/openai.yaml only for Codex-specific metadata, invocation policy, or
     tool dependencies

3. **Test triggers** - write:
   - Three prompts that should trigger the skill
   - Two prompts that should not trigger the skill
   - Whether `allow_implicit_invocation` should stay true

4. **Review with user** - present draft and ask:
   - Does this cover your use cases?
   - Anything missing or unclear?
   - Should any section be more/less detailed?

## Principles

Apply these while drafting and when editing an existing skill:

### Invocation

- **Model-invoked**: keep a trigger-rich `description`; pays **context load** every turn; other skills can reach it.
- **User-invoked**: set `disable-model-invocation: true` (and Codex `allow_implicit_invocation: false`); zero context load; only the human can fire it.
- Prefer user-invoked for orchestrators; model-invoked for reusable discipline other skills must call.

### Description

- Front-load the **leading word** and distinct trigger **branches**.
- One trigger per branch — synonym restatements are **duplication**.
- Cut identity already present in the body.

### Information hierarchy

1. **In-skill step** — ordered actions with checkable **completion criteria**.
2. **In-skill reference** — rules consulted on demand.
3. **External reference** — linked files loaded only when a **context pointer** fires.

Push rarely needed material down the ladder (**progressive disclosure**). Keep a concept's definition, rules, and caveats **co-located**.

### Split and prune

- Split by invocation when a distinct leading word deserves its own discoverability.
- Split by sequence when later steps cause **premature completion** of the current one.
- Keep a **single source of truth**; delete **no-ops** and **sediment**; prefer positive steering over **negation**.

## Skill Structure

```
skill-name/
├── SKILL.md           # Main instructions and frontmatter (required)
├── references/        # Detailed docs (if needed)
├── scripts/           # Utility scripts (if needed)
│   └── helper.js
├── assets/            # Templates or resources (if needed)
└── agents/
    └── openai.yaml    # Codex-specific metadata (if needed)
```

## SKILL.md Template

```md
---
name: skill-name
description: Brief description of capability. Use when [specific triggers].
---

# Skill Name

## Workflow

[Imperative steps with explicit inputs and outputs]

## References

[Link to separate files when needed: See references/example.md]
```

## Description Requirements

The description is the main signal Codex sees when deciding whether to load a
skill. Codex starts with each skill's name, description, and file path, then
loads the full SKILL.md only after selecting the skill. Large skill lists have a
context budget, so descriptions can be shortened.

**Goal**: Give your agent just enough info to know:

1. What capability this skill provides
2. When to trigger it (specific keywords, contexts, file types)
3. When not to trigger it, if the boundary is easy to confuse

**Format**:

- Max 1024 chars
- Front-load the core use case and trigger words
- Write in third person or imperative trigger language
- Include "Use when..." when it improves clarity

**Good example**:

```
Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when user mentions PDFs, forms, or document extraction.
```

**Bad example**:

```
Helps with documents.
```

The bad example gives your agent no way to distinguish this from other document skills.

## Codex Metadata

Add `agents/openai.yaml` only when Codex needs behavior beyond SKILL.md.

Use this for explicit-only skills:

```yaml
policy:
  allow_implicit_invocation: false
```

Use `interface` for Codex app display metadata, and `dependencies` when the
skill relies on a specific MCP server or tool.

## When to Add Scripts

Add utility scripts when:

- Operation is deterministic (validation, formatting)
- Same code would be generated repeatedly
- Errors need explicit handling

Scripts save tokens and improve reliability vs generated code.

## When to Split Files

Split into separate files when:

- SKILL.md exceeds 100 lines
- Content has distinct domains (finance vs sales schemas)
- Advanced features are rarely needed

Prefer `references/` for long prose, `scripts/` for executable helpers, and
`assets/` for templates or reusable files.

## Review Checklist

After drafting, verify:

- [ ] Description includes triggers ("Use when...")
- [ ] Description front-loads key trigger words
- [ ] Three should-trigger prompts tested
- [ ] Two should-not-trigger prompts tested
- [ ] Explicit-only skills use `agents/openai.yaml`
- [ ] SKILL.md under 100 lines or discloses heavy reference
- [ ] No time-sensitive info
- [ ] Consistent terminology / leading words
- [ ] Concrete examples included
- [ ] References one level deep
- [ ] No-ops and duplication pruned
