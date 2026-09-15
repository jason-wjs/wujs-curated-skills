# Portable Coding Preferences

Use these preferences in a project's or personal harness instructions when
wanted. Installing this collection does not activate them globally. For Codex
use AGENTS.md; for Claude Code use CLAUDE.md; for Cursor use project AGENTS.md
or a scoped Cursor rule. Avoid duplicating them in several active layers.

> Validate external input where it enters the system. Rely on established
> internal contracts. Add retries, fallbacks, and compatibility behavior only
> for real requirements or reachable failures. Catch errors to recover, translate,
> or add useful context; preserve failure instead of returning fake success.
> Keep security checks, resource cleanup, and real I/O error handling. Test
> supported behavior and real failures; a newly invented test is not evidence
> that a new requirement exists.

Use `deslop` when a diff needs focused cleanup. Use `tdd` for an explicitly
chosen test-first workflow. Neither requires a mandatory multi-agent review chain.
