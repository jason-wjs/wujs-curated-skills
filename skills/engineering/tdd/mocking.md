# Test Doubles

Prefer real local collaborators when they are fast and controllable. Use focused
doubles for external services, time/randomness, expensive dependencies, or failure
injection. Reuse existing dependency boundaries before adding new ones.

A double should model behavior relevant to the test, not reproduce an entire
implementation. If transport, serialization, or persistence is the risk, verify
that contract against the real boundary where feasible. Avoid asserting internal
call sequences unless that sequence itself is a required behavior (for example,
retry limits or resource cleanup).

Dependency injection can improve control, but do not redesign unrelated code
solely to make it mockable. Use the smallest meaningful test seam.
