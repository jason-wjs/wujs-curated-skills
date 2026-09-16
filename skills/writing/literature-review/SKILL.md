---
name: literature-review
description: "Use when researching and writing a source-grounded literature review, survey, or related-work synthesis."
license: MIT
---

# Literature Review

Apply the [shared editing defaults](../general-writing/references/editing-contract.md) to the requested passage.

Establish the review question, scope, comparison unit, and retrieval cutoff.
For a substantial review, use the [review plan](assets/review-plan.md),
[source ledger](assets/source-ledger.csv), and
[claim-evidence matrix](assets/claim-evidence-matrix.csv). A paragraph edit
with supplied citations does not need a new retrieval project.

Read [evidence workflow](references/evidence-workflow.md) for retrieval and
technical recipe comparisons. Prefer versioned papers, appendices, official
repositories, and model cards. Verify bibliographic details and the passage
supporting each substantive claim. Label reported results, derivations,
inferences, conflicts, and undisclosed details distinctly.

Compare like units: do not transfer a recipe or result across checkpoints,
model sizes, modalities, or releases without support. A leaderboard difference
does not establish a mechanism. Organize synthesis around distinctions that
answer the review question and cite evidence near claims or table cells.

For a LaTeX deliverable, consult
[project conventions](../paper-writing/references/latex-project-conventions.md).
For a full review using the bundled ledger layout, run
`scripts/audit_review.py <review-project>` from this skill's directory to
check citations, placeholders, and ledger completeness; this is a structural
check, not verification of source truth. Build and inspect the requested PDF,
then report its path, retrieval cutoff, and material evidence gaps.
