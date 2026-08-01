# Goal KLS — minimal primitive covariants, foliations, and conductor support

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** autonomous theorem/CAS worker in goal mode  
**Priority tier:** serious high-risk negative route  
**Permitted headline direction:** negative  
**Current headline:** **OPEN**

## 0. Mission

Prove a representation-specific minimality-to-discrepancy/conductor theorem for a hypothetical primitive minimal-degree rank-four landing covariant, reduce all possible conductor configurations to a finite exact list, and eliminate that list. The desired conclusion is that no primitive landing covariant exists in any degree, hence the Klein cubic is not \(G\)-unirational by the accepted exhaustive covariant reduction.

This route must begin with the missing geometric theorem. A large conductor computation without that theorem has no headline force.

## 1. Binding current state

The repository has already established substantial conditional and negative data.

1. The KLS rank-drop/logarithmic-field framework applies to a primitive rank-four covariant and produces a distinguished conductor-support polynomial, historically denoted by the degree-22 factor `P22` in the relevant packets.
2. Literal support `h=P22` and a broad squarefree-multiple branch `h=P22*k`, with the additional coprime/center hypotheses recorded in the repository, have been excluded.
3. Degree-25 and degree-28 logarithmic-field branches tied to `P22` are excluded at their stated scope.
4. Pair-lc, pair-plt, normality, and generic target-pair geometry do **not** alone force complete conductor cancellation. Exact countermodels in the repository show that the missing implication is genuinely representation-specific.
5. The primitive quartic equivariant endomorphism can precompose a solution and multiply its degree by four. Therefore bounded-degree KLS exclusions cannot be extrapolated to all degrees; a minimal primitive theorem is essential.
6. The current frontier is a theorem of the form
   \[
   \text{minimal primitive rank-four landing covariant}
   \Longrightarrow
   \text{one of finitely many conductor configurations }\mathcal C_1,\ldots,\mathcal C_r.
   \]

## 2. Exact target theorem

Let \(p:W\to W\) be a nonzero primitive homogeneous \(G\)-equivariant landing covariant of minimal degree among all such covariants, and suppose its generic differential has rank four. Construct the associated codimension-one foliation/logarithmic distribution and conductor divisor on the normalized graph/image model.

Prove an effective theorem that forces:

- the divisorial support to be built from the finite invariant/relative-invariant factors available in the exact representation;
- multiplicities and centers to satisfy explicit discrepancy and minimality inequalities;
- every non-conductor factor to lie in a finite bounded list of degrees/characters;
- all exceptional codimension-at-least-two centers to lie in a finite orbit list;
- precomposition by the quartic endomorphism to contradict minimality unless the configuration belongs to an explicit finite family.

The theorem must be strong enough that exact CAS elimination of the resulting finite configurations proves no \(p\) exists.

## 3. Work packages

### K0 — reconstruct the exact KLS interface

Identify, from the sealed packets, the exact objects used by the KLS argument:

- normalized graph/image and conductor;
- logarithmic differential/foliation form;
- invariant factors and their characters/degrees;
- the factor `P22` and every proved local/global property;
- the quartic precomposition operation and its effect on degree, primitivity, saturation, rank drop, conductor, and discrepancies.

Write a theorem-boundary ledger separating proved statements, conditional statements, and counterexamples.

### K1 — prove the minimality-to-discrepancy theorem

Develop a proof using the **specific** \(G\)-representation and invariant ring. Possible ingredients include:

- equivariant saturation and gcd structure of the coordinate forms;
- canonical bundle/discrepancy formulas on the normalized graph;
- Camacho–Sad/Baum–Bott-type constraints for the induced foliation;
- degree formulas for logarithmic differentials;
- minimality under the quartic self-endomorphism;
- orbit-size and character restrictions on invariant divisors and centers;
- conductor pullback and ramification formulas.

Generic theorems known to be false in the repository's countermodels may not be reasserted. Every extra hypothesis must be proved for the Klein covariant setup.

### K2 — finite conductor classification

From K1, enumerate every possible configuration

\[
(h; m_i; Z_j; \chi_j; d\bmod N)
\]

up to the exact group action and scalar/invariant multiplication. Include:

- literal and multiple `P22` branches;
- possible residual invariant factors;
- nonnormal and normal branches;
- exceptional centers of codimension at least two;
- all degree congruence classes compatible with minimality.

Prove exhaustiveness symbolically. The finite list, not a sampled list, is the output.

### K3 — exact elimination of each configuration

For every configuration:

1. build the exact coefficient/incidence equations;
2. use character and local valuation blocks before global elimination;
3. prove emptiness or derive a contradiction with primitivity, rank four, smooth generic landing, or the conductor/discrepancy ledger;
4. verify every CAS-dependent assertion independently.

Previously excluded literal and squarefree-multiple branches may be consumed rather than recomputed, but their hypotheses must match the configuration exactly.

### K4 — all-degree conclusion

Prove that any landing covariant has a primitive minimal representative to which K1 applies. Address:

- common scalar factors;
- composition with equivariant endomorphisms;
- possible generic differential rank below four;
- inseparability issues are absent in characteristic zero;
- passage from no primitive covariant to no \(G\)-unirational map.

## 4. Exits

### Headline success

```text
KLS-ALL-CONFIGURATIONS-EMPTY-HEADLINE-NEGATIVE
```

Required: minimality theorem, exhaustive finite list, exact elimination, and the source-exhaustiveness bridge.

### Theorem counterexample

```text
KLS-MINIMALITY-COUNTERMODEL
```

Produce an exact Klein-specific or general counterexample destroying the proposed implication, and identify whether a corrected hypothesis remains plausible.

### Structural theorem only

```text
KLS-FINITE-CLASSIFICATION-UNDECIDED
```

Use after proving K1/K2 but before closing every finite configuration.

### Honest stop

```text
KLS-NO-THEOREM
```

Do not run a degree ladder. State the precise missing geometric implication.

## 5. Prohibitions

1. No large CAS campaign begins before K1 supplies an exhaustive finite theorem.
2. Do not infer all-degree nonexistence from degrees 25/28 or from `P22` branches alone.
3. Do not use normality, lc, or plt in a form refuted by the stored countermodels.
4. Do not assume conductor support equals the visible invariant factor without proof after normalization.
5. Every configuration list must be proved exhaustive.
6. No Magma dependency.

## 6. Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs/KLS_MINIMALITY/
```

Provide `STATUS.md`, `INTERFACE_AUDIT.md`, `MINIMALITY_THEOREM.md`, `CONFIGURATIONS.json`, exact elimination payloads, independent verifiers, and `SEAL.json`.