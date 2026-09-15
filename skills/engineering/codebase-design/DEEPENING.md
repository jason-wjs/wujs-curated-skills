# Dependency Boundaries

Choose a test strategy that exercises the behavior at risk:
- In-process logic can often be tested directly.
- A local substitute can speed feedback, but validate differences that matter
  against the real dependency.
- Owned remote services need contract or integration checks where transport,
  ordering, or serialization matters; an in-memory adapter alone cannot prove it.
- Third-party dependencies may use focused doubles alongside real contract checks
  when feasible. Reuse existing boundaries before creating a new port.

An abstraction can justify itself through isolation or stable ownership with
one implementation. Multiple adapters do not automatically justify one.

When consolidating modules, preserve meaningful regression coverage. Remove
obsolete implementation-coupled tests only after checking what behavior they
protect; interface tests do not automatically supersede all lower-level tests.
