---
name: codebase-design
description: "Use when choosing a module interface or examining coupling and testability."
---

# Codebase Design

Prefer interfaces that hide meaningful complexity and keep related changes
local. Evaluate them through actual callers and observable behavior. The
project's established terminology takes precedence over this vocabulary.

- Module: a function, class, package, or subsystem with an interface.
- Interface: the facts callers need, including types, invariants, failure modes,
  ordering, and configuration.
- Depth: how much useful behavior callers get for the interface they must learn.
- Seam: a place where behavior can be substituted; an adapter fills that role.

Ask what happens if an abstraction is removed: does complexity disappear, or
move into its callers? Keep isolation and dependency boundaries when they solve
real problems, even with one current implementation. Avoid adding abstraction
solely for hypothetical future implementations or test mocks.

Design tests around behavior at a useful interface. Dependency injection and
pure functions are options, not reasons to refactor unrelated code. Retain
necessary effects and validate at real external boundaries; rely on established
contracts inside them.

For a dependency-boundary decision, read [DEEPENING.md](DEEPENING.md).
For meaningful alternative interfaces, read [DESIGN-IT-TWICE.md](DESIGN-IT-TWICE.md).
