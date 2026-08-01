# Goal D — equivariant degree formulas, motives, and integral cohomological obstructions

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** autonomous intersection-theory/motivic worker in goal mode  
**Priority tier:** blue-sky but mathematically plausible negative route  
**Permitted headline direction:** negative  
**Current headline:** **OPEN**

## 0. Mission

Find an integral equivariant degree-formula or motivic obstruction to a dominant \(G\)-equivariant rational map

\[
\mathbf P(W)\dashrightarrow X
\]

of relative dimension one. The existing rational Hodge injection is too flexible; this route seeks congruences or indecomposable integral summands visible through equivariant Chow groups, cobordism, \(K\)-theory, Steenrod operations, or fixed-point localization.

A successful theorem must apply to dominant maps of different dimensions or to a canonically extracted generically finite correspondence. A same-dimension degree formula cannot be applied without constructing that correspondence and controlling its degree.

## 1. Starting data

1. \(G=\operatorname{PSL}_2(11)\) acts linearly and generically freely on \(\mathbf P^4\) and preserves the smooth cubic threefold \(X\).
2. A resolved dominant map \(f:Z\to X\) has relative dimension one. A \(G\)-invariant ample class \(\eta\) gives a split rational Hodge injection via \(f_*(\eta\cup-)\).
3. The exact fixed-point/eigenspace census and tangent characters are installed for every subgroup stratum.
4. The source resolution is built from equivariant blowups; blowup formulas are available in Chow, \(K\)-theory, cobordism, and motives.
5. The direct Burnside/set-theoretic fixed-locus obstruction fails because normal exceptional directions provide exits.

## 2. Exact targets

Prove one of the following types of theorem.

### D-A — equivariant characteristic-number congruence

Associate to any resolved dominant map a \(G\)-equivariant generically finite cycle/correspondence \(Y\to X\), obtained by intersecting with a controlled invariant relatively ample divisor. Compute its degree and derive a congruence from Rost/Merkurjev degree formulas, equivariant localization, or characteristic numbers that cannot be satisfied by any possible \(Y\) arising from \(\mathbf P^4\) blowups.

### D-B — equivariant motive summand obstruction

Show that a dominant map would force the integral or mod-\(p\) \(G\)-motive of \(X\) to be a summand of a motive assembled from \(\mathbf P^4\) and admissible blowup centres. Prove an indecomposable summand, Steenrod operation, or torsion class of \(X\) cannot occur in such an assembly.

### D-C — quotient-stack canonical-dimension obstruction

Compute a functorial invariant of \([X/G]\) or the generic \(G\)-torsor showing that its canonical/essential dimension cannot be compressed to three, using equivariant Chow rings, Chern classes of the five-dimensional representation, or cohomological invariants not already killed by the linearized Picard/Amitsur calculation.

## 3. Work packages

### D0 — theorem selection and bridge audit

Survey applicable degree-formula and equivariant-motive theorems with exact hypotheses. Select only statements valid for:

- characteristic zero;
- finite group actions with stabilizers;
- rational maps resolved by blowups;
- relative dimension one or a justified complete-intersection reduction.

Write the full implication to non-\(G\)-unirationality before computation.

### D1 — compute target invariants

Compute exactly, as \(G\)-modules and integral structures where relevant:

- Chow groups and primitive cohomology of \(X\);
- Chern and characteristic numbers;
- equivariant Chow/Chern classes of tangent and normal bundles;
- Steenrod operations mod \(2,3,5,11\);
- fixed-point localization contributions for cyclic and elementary subgroups;
- integral/polarized intermediate-Jacobian lattice data if used.

Identify a candidate invariant that is not already reproduced by the known Hodge-centre channels.

### D2 — compute the closure under equivariant blowups

Using the exact stabilizer census and a general equivariant blowup formula, characterize the subgroup of invariants obtainable from \(\mathbf P^4\) by blowups along admissible centres. Include nonlinear positive-genus centres rather than assuming only the certified linear strata.

If an invariant can always be supplied by an arbitrary centre, add geometric restrictions from the base-locus/degree/normal-cone machine or abandon that invariant.

### D3 — contradiction or explicit surviving model

Prove the target invariant lies outside the source-generated closure. Alternatively, construct a centre system reproducing it and thereby refute this route at the chosen invariant.

## 4. Exits

```text
D-EQUIVARIANT-DEGREE-HEADLINE-NEGATIVE
D-MOTIVE-HEADLINE-NEGATIVE
D-INVARIANT-REPRODUCIBLE
D-STRUCTURAL-UNDECIDED
```

A negative exit requires a complete theorem covering all admissible resolutions, not only the certified linear blowups.

## 5. Prohibitions

1. Do not apply a generically finite degree formula directly to the relative-dimension-one map.
2. Do not use rational Hodge characters alone; that screen already has wide slack.
3. Do not ignore nonlinear or exchanged blowup centres.
4. The vanishing linearized-Picard/higher-Amitsur branch is already exhausted; do not rename it.
5. Fixed-point localization must include indeterminacy resolution and exceptional components.
6. No Magma dependency.

## 6. Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs/D_EQUIVARIANT_MOTIVE/
```

Provide `STATUS.md`, `THEOREM_AUDIT.md`, `TARGET_INVARIANTS.md`, `BLOWUP_CLOSURE.md`, exact calculation payloads, independent verifiers, and `SEAL.json`.