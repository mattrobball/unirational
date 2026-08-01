# Goal J — resolved fixed-centre Albanese, Prym, and Hodge obstruction

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** autonomous Hodge/birational-geometry worker in goal mode  
**Priority tier:** high-risk conceptual negative route  
**Permitted headline direction:** negative  
**Current headline:** **OPEN**

## 0. Mission

Upgrade the exhausted set-theoretic fixed-locus test to an invariant of the **resolved fixed-component and blowup-centre tree**. Use normalizer-equivariant Albanese/Picard torsors, Prym factors, integral Hodge structures, and polarization/isogeny data to prove that no \(G\)-equivariant resolution of a dominant map \(\mathbf P^4\dashrightarrow X\) can exist.

The ordinary statement “the fixed elliptic is not rationally chain connected” is already used and is bypassed by the exceptional normal direction mapping to a rational fixed line. A successful obstruction must see those normal exits and the positive-genus centres created later in the resolution.

## 1. Binding current state

1. For an involution \(t\),
   \[
   X^t=E_t\sqcup L_t,
   \]
   where \(E_t\) is elliptic and \(L_t\simeq\mathbf P^1\). The residual \(S_3\) acts on \(E_t\), with its order-three subgroup acting by translation by nonzero 3-torsion.
2. The source plus-plane is forced into the base locus, but its exceptional normal \(\mathbf P^1\) can map to \(L_t\). This defeats the direct rational-chain-connectedness argument.
3. The exact fixed-stratum machine has global formal survivors and a nonzero linear inverse limit; another set-theoretic subgroup scan cannot close the problem.
4. The corrected Hodge-centre theorem gives a split \(G\)-equivariant injection
   \[
   H^3(X,\mathbf Q)\hookrightarrow H^3(Z,\mathbf Q)
   \]
   for any resolved dominant map, and therefore forces positive-irregularity blowup centres. The current character screen leaves many channels and gives no contradiction.
5. The certified linear planes, lines, and point centres have \(H^1=0\); any actual lift must create additional nonlinear curves or irregular surfaces.

## 2. Exact target

Construct a functorial invariant \(\mathcal M\) of a \(G\)-equivariant resolution that includes:

- for each \(H\le G\), the Albanese/Picard \(1\)-motive of components of \(Z^H\);
- affine normalizer actions and torsor classes, not only linear actions on \(H^{1,0}\);
- restriction and norm maps for subgroup inclusions;
- contributions of fixed parts of blowup centres;
- the polarized/isogeny realization of the \(H^3(X)\) summand;
- incidence compatibility at \(V_4,A_4,D_{12}\), and other multiple-fixed strata.

Prove that every source-side resolution tree built from \(\mathbf P^4\) and admissible equivariant centres has invariant lying in a class that cannot receive the corresponding target fixed-locus/Prym data.

## 3. Work packages

### J0 — compute the exact involution \(1\)-motive

For one involution and its residual \(S_3\):

1. compute the affine action on \(\operatorname{Alb}^1(E_t)\) and its class in \(H^1(S_3,E_t)\);
2. compute the linear character on \(H^{1,0}(E_t)\);
3. compute period/index and norm restrictions for equivariant multisections;
4. incorporate the marked type-I/type-II and \(C_6\) divisors into a generalized Jacobian or relative Picard \(1\)-motive;
5. prove independence of origin and all functoriality statements.

A finite torsion observation must be tied to actual degrees/multiplicities of normal-cone transition curves before it can obstruct a live family.

### J1 — blowup-centre propagation theorem

Prove an equivariant blowup formula for the fixed-component \(1\)-motives. If a \(t\)-stable centre \(C\) is blown up, describe the new fixed exceptional components from the \(\pm1\) normal eigenspaces and identify their Albanese/Picard contributions.

Deduce a precise theorem: the first resolved fixed component mapping nontrivially to \(E_t\) must be supported over a positive-genus fixed centre whose Albanese has an \(E_t\)-quotient with the required residual affine action.

### J2 — polarized Hodge/isogeny refinement

Strengthen the existing character screen from complex representations to rational Hodge structures and polarized abelian varieties up to isogeny.

Tasks:

- compute the \(G\)-equivariant isogeny type of \(J(X)\) and the invariant/anti-invariant pieces for each subgroup class;
- compute actual \(H^1\)-representations and endomorphism algebras of candidate centre orbits;
- test whether the required CM/isogeny/polarization factors can occur;
- distinguish natural polarizations from arbitrary rational Hodge summands;
- account for pairs of centres exchanged by an involution, which can contribute invariant diagonal classes without lying in the fixed tree.

Do not apply Prym Torelli from a mere rational isogeny injection unless the natural polarization is controlled.

### J3 — geometric realization of surviving centre channels

For every Hodge-character channel surviving the existing screen, decide whether an actual smooth equivariant centre can occur in a resolution of a polynomial map with the certified base strata. Use:

- equivariant Hilbert schemes/invariant ideals;
- degree and genus budgets;
- normal-bundle and incidence constraints;
- subgroup orbit sizes;
- the global coefficient-vector coupling from the landing equations.

The goal is either to eliminate all channels or reduce them to a finite explicit list of centre systems.

### J4 — global incompatibility

Assemble the subgroup \(1\)-motives and polarized Hodge factors over the orbit/incidence category. Prove that every admissible centre system fails at least one of:

- the residual affine torsor/norm condition;
- the required \(J(X)\) isogeny factor;
- polarization compatibility;
- triple-incidence compatibility;
- realizability in the base-resolution tower.

Then connect the impossibility to the absence of a resolved \(G\)-unirational map.

## 4. Exits

```text
J-FIXED-CENTRE-HEADLINE-NEGATIVE
J-FINITE-CENTRE-LIST-STRUCTURAL
J-INVARIANT-TOO-WEAK
J-UNDECIDED
```

A headline exit requires an exhaustive theorem for all equivariant resolutions, not only the first exceptional divisor.

## 5. Prohibitions

1. Nontrivial \(J(E_t)\) alone does not obstruct unirationality.
2. Do not ignore exceptional normal exits to rational components.
3. Do not identify affine translation on \(E_t\) with pullback action on \(\operatorname{Pic}^0(E_t)\).
4. Do not infer polarized Prym equality from an unpolarized isogeny factor.
5. Do not ignore centres exchanged by \(H\) rather than fixed pointwise.
6. Character multiplicity alone is already known to be too weak.
7. No Magma dependency.

## 6. Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs/J_FIXED_CENTRE_PRYM/
```

Provide `STATUS.md`, `ONE_MOTIVE.md`, `BLOWUP_FORMULA.md`, `HODGE_ISOGENY.md`, `CENTRE_REALIZABILITY.md`, exact computation payloads, independent verifiers, and `SEAL.json`.