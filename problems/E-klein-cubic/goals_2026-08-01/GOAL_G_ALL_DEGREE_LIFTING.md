# Goal G — an all-degree nonlinear landing theorem

**Repository:** `mattrobball/unirational`  
**Pinned mathematical baseline:** `715faf441289e2589b9325311b6613ea0331bf88`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** autonomous theorem/CAS worker in goal mode  
**Priority:** 4  
**Permitted headline direction:** negative or positive  
**Current headline:** **OPEN**

## 0. Mission

Turn the stabilizer/normal-cone machine into an exact all-degree decision theorem.

The negative target is to prove that no nonzero homogeneous \(G\)-equivariant self-covariant

\[
p:W\longrightarrow W
\]

satisfies the landing identity \(F(p)=0\) in any degree. Together with the accepted source-exhaustiveness theorem, this proves that the Klein cubic is not \(G\)-unirational.

The positive target is to construct and algebraize one compatible global state into an actual landing covariant, which proves \(G\)-unirationality.

A finite degree ladder, a nonzero sample residual, a formal inverse-limit element, or a free-fibre recurrence is not an all-degree result.

## 1. Binding current state

Consume:

```text
problems/E-klein-cubic/HANDOFF.md
problems/E-klein-cubic/CURRENT_PATHS.md
problems/E-klein-cubic/REPAIR.md
problems/E-klein-cubic/certificates/GLOBAL_TRANSITION_DIAGRAM.md
problems/E-klein-cubic/certificates/LOCAL_TRANSITION_MODULES.md
problems/E-klein-cubic/certificates/lifting/
problems/E-klein-cubic/certificates/global_transition/
```

At the pinned baseline:

1. The exact stabilizer census, tangent/normal characters, marked residual \(S_3\) geometry, and all local transition modules are installed.
2. The finite marked-state screen survives. Three global necessary families remain:
   - `based_minus_lines_odd_m`;
   - `residual_e1_swap_both`, with \(d=6m+1\);
   - `residual_e_ge7_generic_swap_both`.
3. The linear inverse-limit module is nonzero in characteristic zero. For each fixed odd \(m\), residual plane jets grow quadratically in \(d\), while the presently imposed line/point constraints grow linearly. Therefore a purely linear fixed-locus obstruction cannot work in high degree.
4. Every fixed degree has a finite terminal lifting system: \(F(p)\) has degree \(3d\), so the normal-order tower terminates. The isolation cutoff \(N_\star=d+2m+1\) and the free-fibre symbolic recurrence are retained.
5. The degree-13 and degree-19 residuals are sample values, not degree-wide obstructions. At degree 25, later kernel freedom cancels a nonzero particular residual and the formal free-fibre zero locus survives.
6. The attempted all-degree step is blocked because finite generation has not been proved for the **full** equalizer/Fitting layers over the proposed \((m,d)\)-semigroup grading. Finite generation of local modules or the free fibre is insufficient.

## 2. Exact theorem boundary

For every admissible pair \((m,d)\), let \(\mathcal L_{m,d}\) denote the projective nonlinear landing support of the complete global transition/equalizer object, including:

- symbolic order \(m\) along the union of 55 involution plus-planes;
- the triple-line equalizer on the 55 \(V_4\) lines;
- residual point kernels and finite irrelevant torsion;
- \(D_{12}\) minus-line restrictions;
- \(C_3\) lines and \(C_6\) endpoints;
- \(A_4,D_{10},D_{12}\) point links;
- marked elliptic/type-I/type-II data;
- every coefficient of the nonlinear identity \(F(p)=0\).

The negative theorem sought is

\[
\mathcal L_{m,d}=\varnothing
\qquad
\text{for every admissible }(m,d).
\]

The positive theorem sought is an exact point of some \(\mathcal L_{m,d}\) that lifts to one global coefficient vector \(p\) and satisfies the original identity.

No claim about \(\mathcal L_{m,d}\) may be made from independent local choices: one global \(G\)-covariant coefficient vector must underlie every restriction.

## 3. Work packages

### G0 — define the correct universal algebraic object

Construct a precise noetherian candidate encoding all degrees and normal orders. It must distinguish:

- polynomial degree \(d\);
- symbolic plane order \(m\);
- residual normal order;
- source fixed line, exceptional normal-direction line, and target fixed line;
- sheaf-level sections, literal graded pieces, and finite irrelevant torsion.

Possible frameworks include a multigraded Rees algebra/module of the full incidence arrangement, a coherent sheaf on the iterated blowup/normal-cone stack, or another finite-type equivariant construction. The worker must prove that its \((m,d)\)-fibres recover the existing transition modules and equalizer maps exactly.

Do not use the false short Cech complex. Do not replace symbolic powers by ordinary powers of the union ideal.

### G1 — prove finite generation, or replace it with a valid all-degree theorem

Prove a theorem strong enough to reduce the infinitely many supports \(\mathcal L_{m,d}\) to finite data. Acceptable forms include:

1. finite generation of the complete multigraded equalizer module and its nonlinear obstruction ideal over a finitely generated semigroup algebra;
2. eventual periodicity/quasi-polynomiality together with a certified finite exceptional range;
3. a representation-stability theorem with effective bounds;
4. a structural identity that kills every admissible fibre without finite generation;
5. a positive algebraization theorem producing a covariant from a compatible formal family.

The proof must include the triple-line, point-link, marked-elliptic, and irrelevant-torsion layers. A theorem for the local/free plane module alone does not pass G1.

If the proposed finite-generation statement is false, exhibit a precise counterexample and formulate a corrected universal object before proceeding.

### G2 — obtain an effective finite decision problem

From G1, derive explicit bounds or residue classes such that checking finitely many bidegrees and finitely many generators decides every \(\mathcal L_{m,d}\).

Required outputs:

- a finite list of bidegrees/semigroup generators or an exact recurrence;
- a proof that multiplication/composition operations preserve the full global equalizer and the nonlinear landing equations;
- explicit treatment of primitive versus scalar-multiple covariants;
- a proof that finite irrelevant torsion and low-degree discrepancies are inside the bounded exceptional set.

The crude sheaf-regularity bound may be used only with a proof that it controls literal graded pieces and every nonlinear specialization required.

### G3 — decide the finite universal support

Build the resulting finite presentation and decide its projective support in characteristic zero, or by a proper good-reduction argument with exact transfer.

For a negative result, provide an exact unit/Fitting/radical certificate covering every generator and every exceptional bidegree. For a positive result, produce one compatible coefficient vector and verify every incidence and every coefficient of \(F(p)\).

Sample evaluations, generic-rank calculations, or a nonzero terminal residual do not decide support.

### G4 — apply the headline bridge

#### Negative branch

Re-audit the accepted source-exhaustiveness theorem and prove that absence of every homogeneous landing self-covariant excludes every \(G\)-unirational map, including maps represented after scalar multiplication or composition.

#### Positive branch

Verify the constructed covariant in the original \(W\)-coordinates, prove it is nonzero and gives the required dominant rational map, and state the \(G\)-unirationality theorem.

## 4. Optional fixed-locus strengthening

A refined Albanese/Picard/Prym or fixed-centre \(1\)-motive may be incorporated only if it is functorially attached to the **resolved transition system** and cuts the surviving families. The ordinary image-of-\(H\)-fixed-subvariety obstruction has already been exhausted at Levels 1 and 2: a new invariant must see normal exits, blowup centres, or nonlinear divisor classes.

Any such invariant must be expressed as an exact algebraic constraint on the universal object of G0, not as a heuristic intermediate-Jacobian analogy.

## 5. Acceptance and exits

### Headline-negative success

```text
G-ALL-DEGREE-EMPTY-HEADLINE-NEGATIVE
```

Required payload:

- correct universal multigraded object;
- finite-generation/periodicity/structural theorem;
- effective finite reduction;
- exact emptiness certificate;
- source-exhaustiveness bridge.

### Headline-positive success

```text
G-COVARIANT-HEADLINE-POSITIVE
```

Required payload:

- exact global coefficient vector;
- full incidence compatibility;
- original identity \(F(p)=0\);
- dominance and \(G\)-equivariance proof.

### Structural advance without decision

```text
G-STRUCTURAL-UNDECIDED
```

Use only after proving a substantial theorem such as finite generation, a counterexample to the proposed grading, or an exact corrected recurrence. State the smallest remaining finite support problem.

### Honest stop

```text
G-UNDECIDED
```

Name the exact missing theorem and do not run a degree ladder in its place.

## 6. Prohibitions and stopping rules

1. No finite degree ladder substitutes for an all-degree theorem.
2. No sample residual or generic free-fibre rank is a support obstruction.
3. Do not call formal compatible states covariants.
4. Do not drop the \(V_4\) equalizer, point kernels, \(C_3/A_4\) links, elliptic markings, or irrelevant torsion.
5. Do not use a false Cech complex or conflate symbolic and ordinary powers.
6. Do not assume finite generation merely because every fixed-\(m\) module is finite over its coordinate ring.
7. Every positive state must be traced to one global coefficient vector and checked in the original equation.
8. Prime 67 is never the sole decision fibre.
9. No Magma dependency is permitted.

## 7. Output contract

Write only under

```text
problems/E-klein-cubic/goal_runs/G_ALL_DEGREE/
```

and do not modify sealed historical packets. Provide:

```text
STATUS.md
UNIVERSAL_OBJECT.md
FINITE_GENERATION.md
DECISION.md
produce_*.py / *.m2 / *.jl / *.lean as appropriate
verify_*.py
SEAL.json
```

`STATUS.md` must begin with one of the four exits above. The independent verifier must reconstruct the finite presentation, recurrence, or support certificate rather than merely read a stored status flag.