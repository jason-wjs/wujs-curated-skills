# Writing

General prose, academic papers, proposals, presentations, and prompt editing
share this writing collection. Its name reflects that broader scope.

Seventeen retained entrypoints from academic-writing-skills, simplified around
user preferences and task-specific evidence. Install with this repository's
installer; it includes the complete writing collection, so relative sibling
references work in copy and symlink layouts. Copying one folder manually may
omit its shared references.

## Editing defaults

[Editing scope and voice](./general-writing/references/editing-contract.md) is
the single maintained source for editing preferences. Sentence polishing keeps
structure by default; paragraph polishing permits reorganization. Facts,
arguments, evidence strength, and necessary conditions remain intact. Missing
premises or evidence are reported outside the prose. No mandatory style chain.

## Entrypoints

- **[abstract-writing](./abstract-writing/SKILL.md)** — Use when drafting, revising, or diagnosing a research abstract as a standalone argument.
- **[academic-voice](./academic-voice/SKILL.md)** — Use when specifically adjusting scholarly tone or removing corporate and social-media register from research exposition.
- **[anti-defensive-writing](./anti-defensive-writing/SKILL.md)** — Use when a passage contains redundant defensive caveats or the user asks to reduce apologetic phrasing; use rebuttal-writing for reviewer responses.
- **[better-usage](./better-usage/SKILL.md)** — Use when a sentence is grammatical but its subject, verb, or object expresses the wrong semantic relation.
- **[general-writing](./general-writing/SKILL.md)** — Use when polishing general prose or diagnosing clarity, voice, or formulaic phrasing outside a more specific writing task.
- **[grant-planning](./grant-planning/SKILL.md)** — Use when choosing or comparing grant research stories, aims, team roles, feasibility, or scope before application drafting.
- **[grant-writing](./grant-writing/SKILL.md)** — Use when drafting or revising grant and fellowship application answers from a research plan and sponsor requirements.
- **[humanizer](./humanizer/SKILL.md)** — Use when the user asks to diagnose or revise formulaic, generic, or AI-sounding prose.
- **[improve-human-writing-guide](./improve-human-writing-guide/SKILL.md)** — Use when creating, revising, or compiling a human-readable writing guide or its LaTeX/PDF companion.
- **[literature-review](./literature-review/SKILL.md)** — Use when researching and writing a source-grounded literature review, survey, or related-work synthesis.
- **[non-autoregressive-writing-pass](./non-autoregressive-writing-pass/SKILL.md)** — Use when reviewing a completed draft’s titles, paragraph openings, endings, and transitions against the whole argument.
- **[paper-writing](./paper-writing/SKILL.md)** — Use when planning, drafting, or revising a research paper or its sections; use abstract-writing for an abstract-only task.
- **[presentation-making](./presentation-making/SKILL.md)** — Use when planning, drafting, revising, or reviewing presentation slides and speaker notes.
- **[prompt-improving](./prompt-improving/SKILL.md)** — Use when the user asks to improve or clarify a prompt while preserving its intent and natural style.
- **[rebuttal-writing](./rebuttal-writing/SKILL.md)** — Use when drafting reviewer responses, author-response letters, or point-by-point revision memos.
- **[writing](./writing/SKILL.md)** — Use when a writing request spans genres or needs routing and no focused writing skill has already been selected.
- **[writing-cadence](./writing-cadence/SKILL.md)** — Use when revising choppy rhythm, monotonous sentence shapes, repeated openings, or mechanical contrast patterns.

## Examples and human companions

Paper references cover theory plus validation (Action Chunking), empirical
methods (DPPO and OGPO), and empirical mechanisms (Much Ado About Noising).
The collection also includes abstract analyses, rebuttal examples, grant
patterns, and templates. Original private papers and proposals stay outside
this repository; use a task-supplied corpus when needed. Bundled analyses are
sufficient for ordinary work and do not imply the originals were inspected.

[Human materials](../../for-humans/writing/README.md) are kept in the repository,
not installed as skills. They retain their published source and PDF versions;
the current agent instructions do not prescribe all advice in those guides.
No patent-specific skill or patent example corpus is bundled.

`paper-writing` replaces the removed personal `research-paper-writing` skill.
`general-writing` replaces the redundant personal `edit-article` entrypoint.
All seventeen names from academic-writing-skills remain available. Install with
`--prune` to remove obsolete research-paper-writing and edit-article installations in the chosen
scope. The original academic-writing-skills checkout is retained for comparison.

## Maintenance

Update the shared editing contract once; domain skills link to it directly.
Keep references task-selective and preserve component licenses. See
[upstream records](../../docs/external-sources.md#writing-collection).
