---
name: tdd
description: "Use when the user requests test-first development or a red-green-refactor workflow."
---

# Test-Driven Development

Work in small behavior slices: write a test, observe its relevant failure,
implement enough to pass, then refactor while preserving behavior.

Derive tests from agreed requirements, existing contracts, and real failure
scenarios. Prioritize observable behavior at useful interfaces. Do not invent
unsupported inputs or recovery requirements merely to add edge-case tests;
a test the agent just wrote is not independent evidence of a requirement.
Expected values should come from a spec, known-good example, or independent
calculation; do not repeat the implementation in the assertion.

Resolve consequential interface or behavior ambiguity with the user. Reuse
existing decisions and authorization; routine test selection and implementation
do not need a new approval gate.

## Loop

- Choose the next meaningful behavior rather than prewriting a speculative
  suite. Existing seams are preferred when they exercise the actual behavior.
- Confirm the test fails for the intended reason, not a broken fixture/import.
- Implement the behavior without speculative abstractions or fallbacks.
- Run affected tests. Refactor when there is a concrete clarity or duplication
  benefit; testing is not an instruction to redesign surrounding code.
- Complete the relevant project checks after a coherent change. Repeat checks
  when new edits or failures justify it, not as a ritual after every edit.

Validate external input at its boundary. Rely on established internal contracts;
retain error handling for reachable I/O failures, cleanup, and security checks.

## References

Read only what the task needs:
- [tests.md](tests.md): behavior-oriented test examples.
- [mocking.md](mocking.md): choosing real dependencies and test doubles.
- [Codebase design](../codebase-design/SKILL.md): when an interface or dependency
  boundary prevents meaningful testing.
