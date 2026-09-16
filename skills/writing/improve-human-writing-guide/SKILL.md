---
name: improve-human-writing-guide
description: "Use when creating, revising, or compiling a human-readable writing guide or its LaTeX/PDF companion."
license: MIT
---

# Improve Human Writing Guide

Apply the [shared editing defaults](../general-writing/references/editing-contract.md) to the requested passage.

Write the guide for people. Keep tool routing and agent instructions in skills;
keep explanation and teaching examples in the human artifact. Read the affected
source, its context, and relevant template files. A local edit does not require
all guides or all writing skills.

For this collection's guide, use
[bundled guide maintenance](references/bundled-paper-guide.md). The human
materials live at `for-humans/writing/` in a wujs-curated-skills checkout and
are not installed by the skill installer. Use a supplied checkout or guide path;
ask for it only when needed to perform the requested edit.

Ground advice in the supplied sources. Label reconstructed teaching examples,
preserve attribution, and keep private corpora outside the collection. Avoid
turning one author's choice into a universal rule. Verify template commands
against the actual preamble rather than guessing from their names.

When changing LaTeX content, build the requested artifact, inspect affected
pages and overall layout, and fix errors introduced by the change. Publish the
matching named PDF at the guide's documented location. Preserve existing entry
names; use descriptive names for new projects. Report the source/PDF paths and
any build limitation. Do not run mandatory Humanizer or other style passes.
