---
name: improve-codebase-architecture
description: "Use when assessing architectural friction or proposing a concrete refactor."
disable-model-invocation: true
---

# Improve Codebase Architecture

Investigate the requested area and relevant project terminology and decisions.
When the user gives no area, use recent changes to identify likely hot spots
before widening the scan. Look for concrete costs: changes scattered across callers, leaked implementation
knowledge, duplicated coordination, or behavior that is hard to test reliably.
Explore locally; use optional exploration tools only when available and useful.

For each worthwhile candidate, explain the affected code, observed friction,
proposed change, trade-offs, and how success could be checked. Rank by practical
benefit. A thin module may still earn its place through isolation or a stable
contract; fewer files is not the objective.

Prefer the project's terms. For deep-module analysis, consult
[Codebase Design](../codebase-design/SKILL.md); these are optional analytical terms, not mandatory
replacements for service, API, or boundary. Flag existing ADR trade-offs when
proposing to revisit them.

For an assessment request, present the candidates in an HTML report with
before/after diagrams and a top recommendation, following
[HTML-REPORT.md](HTML-REPORT.md). Honor a requested text-only format. Save the
report to the OS temporary directory and return its absolute path.
Finish with recommendations. If implementation is
already requested and scope is clear, continue; ask about consequential choices
rather than requiring a separate candidate-selection ceremony.

Use [Compare Interface Designs](../codebase-design/DESIGN-IT-TWICE.md) when alternatives would clarify a
real interface decision. Record durable terminology and decisions only when
useful and in scope, following [CONTEXT-FORMAT.md](../domain-modeling/CONTEXT-FORMAT.md)
and [ADR-FORMAT.md](../domain-modeling/ADR-FORMAT.md).
