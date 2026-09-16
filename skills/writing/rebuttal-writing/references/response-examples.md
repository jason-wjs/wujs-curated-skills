# Response examples


The following examples distill recurring prose patterns in the OGPO, DPPO,
and Much Ado author-team responses. Copy the linguistic move, not the
technical content. Verify every symbol and fact against the current paper.

### OGPO: Neutral Correction

> **Why \(a_{t,0}\)?** \(a_{t,0}\) is intentional. The critic is trained on
> the fully denoised action executed in the environment; intermediate
> denoising states are not environment actions. We will state this
> distinction explicitly.

Language pattern: a declarative verdict, one clean contrast, and one exact
revision. The response never attributes the confusion to the reviewer.

### OGPO: Candid Tradeoff

> **Compute.** OGPO is slower per update. Its claim is sample efficiency, not
> cheaper gradient updates.

Language pattern: state the unfavorable fact first, then use "X, not Y" to
define the claim.

### DPPO: Compact Concession

> **Discounting.** This is a typo. The exponent should be
> \(\gamma_{\mathrm{ENV}}^{t'-t}\), and we will correct the equation.

Language pattern: no ceremonial apology, no defense, and no extra
explanation for a local error.

### DPPO: Bounded Qualification

> Q-learning can be more sample efficient when it is effective. Our claim is
> narrower: DPPO is more stable in the tested high-precision tasks.

Language pattern: concede first, then use "Our claim is narrower" to prevent
an overbroad reading.

### Much Ado: Scope A Categorical Claim

> We do not claim that generative control policies cannot be multimodal. Our
> claim is that multimodal fitting is not necessary to explain the measured
> gap in the benchmarks studied here.

Language pattern: paired "We do not claim X / Our claim is Y" sentences make
the boundary unmistakable.

### Much Ado: Accept A Confound Without Losing The Point

> Architecture matching explains part of the earlier gap. This is a result of
> the controlled comparison, not an unwanted confound.

Language pattern: accept the premise directly, then recast its scientific
meaning in one sentence.

### Much Ado: State A Negative Result Plainly

> A third MIP step did not materially improve performance, so we retain two
> steps for efficiency. This indicates saturation in the tested setting, not
> universal optimality.

Language pattern: report the null result without embarrassment and close with
a narrow inference.
