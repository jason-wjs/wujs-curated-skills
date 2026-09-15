# Capability-first skill curation

Date: 2026-09-15
Status: Accepted

## Decision

Keep task-specific knowledge, user preferences, real operational constraints,
and useful command entrypoints. Replace general coaching and fixed itineraries
with outcomes and decision criteria. Preserve existing authorization and make
optional resources and delegation conditional. Keep the source portable across
Codex, Claude Code, and Cursor.

Remove karpathy-guidelines. Preserve the concurrent removal of zoom-out. Keep other command names while narrowing and
simplifying their behavior; their personal usefulness still needs usage evidence.
Add focused deslop cleanup and retain TDD without speculative test requirements.
Credential entry must bypass model context; an ordinary question dialog does
not provide that guarantee. Keep shared-server ownership boundaries and rollback.

## Trade-offs

Less prescribed process gives the model more discretion. Runtime effectiveness
must be evaluated in real tasks; install tests establish packaging compatibility,
not model quality. Detailed procedures remain for fragile operations. We do not
maintain separate model-specific copies or automatically synchronize upstream.

## Basis

- [OpenAI: Rethinking skills and prompts for GPT-6 Astra](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra)
- User-reported redundant defensive code and unsafe credential handoffs.
- [Source records](../external-sources.md) retain attribution and local decisions.
