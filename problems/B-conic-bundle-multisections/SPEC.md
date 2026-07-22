# Problem B — Rational multisections on general (2,3) hypersurfaces in P^2 x P^2

> **Resolution update (2026-07-22).** The headline question has an affirmative
> answer.  For a general line \(L\subset\mathbf P^2_y\), the vertical surface
> \(S=X\cap(\mathbf P^2_x\times L)\) is rational.  Taking the third point on
> the tangent line to each cubic fiber of
> \(X\to\mathbf P^2_x\) maps \(S\) birationally to a horizontal rational
> divisor of class \((10,1)\).  Its degree over \(\mathbf P^2_y\) is \(20\),
> so it gives a degree-20 unirational parametrization of a general \(X\).
> The complete proof and universal resultant check are in
> [`certificates/tangent_residual_theorem.md`](certificates/tangent_residual_theorem.md),
> with the corrected earlier program and its independent results synthesized
> in [RESOLUTION.md](RESOLUTION.md).

## Setup and convention

X ⊂ P^2_x × P^2_y a general hypersurface of bidegree (2, d): degree 2 in the
x-variables, degree d in the y-variables. dim X = 3. Write
F(x, y) = x^T A(y) x with A(y) a symmetric 3×3 matrix of degree-d forms in y.

- π = pr_y : X → P^2_y is a **conic bundle** (Harris's third variety, notes
  p. 23); discriminant Δ = {det A(y) = 0} ⊂ P^2_y, a curve of degree 3d.
- K_X = O_X(−1, d−3) by adjunction. For the primary target **d = 3**:
  K_X = O_X(−1, 0), and pr_x : X → P^2_x is a fibration in plane cubics
  (genus-1 curves) — X carries both a conic bundle and a genus-one fibration.
  It is not an elliptic fibration: the Picard calculation makes every
  multisection degree a multiple of 3, so there is no section.
- Primary target: **d = 3** (discriminant degree 9). d = 2 is the calibration
  case (known unirational, see below).  The tangent--residual theorem in fact 5
  below now proves that the general \(d=3\) member is unirational.  Ordinary
  rationality still fails, and a very general member is not stably rational;
  these statements are compatible with the positive unirationality theorem.

Status context: unirationality of conic bundle threefolds is broadly open, but
this particular \((2,3)\) family is now settled affirmatively;
the classical expectation "large discriminant ⟹ not unirational" was
recently dented by unirational conic bundles with arbitrarily large
discriminant degree (special families). Stable irrationality results
(Hassett–Kresch–Tschinkel style) do NOT obstruct unirationality
(Artin–Mumford is unirational and stably irrational).

## Why a multisection certifies unirationality

**Proposition (classical; the engine of this problem).** If S ⊂ X is a
surface with rational normalization such that π|_S : S → P^2_y is dominant
(a "horizontal rational multisection", say of degree N over the base), then
X is unirational of degree N: the base change X ×_{P^2_y} S → S is a conic
bundle over a rational surface with a tautological rational point over the
function field (the diagonal copy of S), hence has a section, hence is
birational to S × P^1, which is rational; the projection to X is dominant of
degree N.

Conversely, if X is unirational then images of general planes under a
dominant map P^3 ⇢ X provide horizontal rational surfaces. So for this X:

> **X unirational ⟺ X contains a horizontal surface with rational
> normalization.** Harris's refinement 11b ("rational surfaces other than
> preimages of rational curves in the second factor") is exactly the
> horizontal condition.

A found S is a *finite certificate*: rationality of an explicit surface is
decidable in practice (Castelnuovo: q = h^1(O) = 0 and P_2 = h^0(2K) = 0 on
a resolution), and the dominant map P^2 × P^1 ⇢ X can be written down.

## Structural facts that shape the search (prove-once lemmas)

1. **Every surface in X is a divisor, and its base-degree is even.**
   dim X = 3, and Grothendieck–Lefschetz gives Pic(X) = Z·H_x ⊕ Z·H_y for
   the smooth ample divisor X in P^2×P^2. A surface S ∈ |O_X(a, b)| has
   degree over the base S · f = 2a (f = conic fiber class; H_x·f = 2,
   H_y·f = 0). Horizontal ⟺ a ≥ 1. In particular **no section and no
   odd-degree multisection exists** — consistent with the nontrivial
   2-torsion Brauer class of the generic conic (restriction–corestriction
   parity). Pipeline sanity checks are free: any search that "finds" an
   odd-degree horizontal surface has a bug.

2. **Smooth members are never rational (d = 3).** Adjunction:
   K_S = ((a−1)H_x + (b + d − 3)H_y)|_S. For d = 3 and a ≥ 1 this is
   effective or trivial in every class: (a, b) = (1, 0) gives K_S = 0 — S is
   the K3 double plane branched along the degree-6 curve σ^T adj(A) σ (see
   3) — and every other horizontal class has K_S effective. **Hence the hunt
   is exclusively for SINGULAR members whose normalization is rational.** For
   normal members, the relevant correction comes from discrepancies on a
   resolution; a conductor correction occurs only for nonnormal members. This
   is the precise sense in which the problem is a needle-hunt: rationality must
   come from branch-curve degeneration, not from a class choice.

3. **Explicit branch model for a = 1 (degree-2 multisections).** A member of
   |O_X(1, k)| is X ∩ {σ(y)·x = 0} for a basepoint-free
   σ : P^2_y → (P^2_x)^∨ given by three degree-k forms. For an integral member
   S, the normalization of P^2_y in C(S) — equivalently, the normalized finite
   model obtained from Stein factorization — is the double cover branched along

       B_σ = σ(y)^T adj(A(y)) σ(y)

   (the dual-conic condition "the line σ(y) is tangent to the fiber conic").
   adj(A) has entries of degree 2d, so **deg B_σ = 2k + 2d**. Check:
   d = 3, k = 0 gives
   the sextic (K3) of fact 2; d = 2, k = 0 gives a quartic.
   The rationality question for S becomes the classical rational double
   plane question for (P^2, B_σ). Nodes give A_1 points and ordinary triple
   points give D_4 points upstairs; both are rational double points and do NOT
   reduce p_g. Ordinary multiplicity 4 is the first case imposing an adjunction
   condition. More generally, a branch point of multiplicity r imposes
   vanishing order floor(r/2)−1 on the adjoints, together with the corresponding
   infinitely-near proximity conditions. For a reduced irreducible B, a point
   of multiplicity deg B−2 or deg B−1 makes the pencil through it a genus-zero
   fibration, hence gives rationality over C by Tsen. The unrestricted
   "multiplicity ≥ deg B−2" statement is false for reducible cones. If σ has
   base points or common factors, first resolve the base locus and normalize
   away square branch factors. The full classical Castelnuovo–Enriques theory
   of rational double planes applies.

4. **Calibration: d = 2 is unirational via this exact mechanism.**
   For bidegree (2,2), a general class (1,0) member is a double plane branched
   along a smooth quartic (deg B = 2k+2d = 4): over an algebraically closed
   field it is a rational degree-2 del Pezzo, horizontal of base-degree 2. So
   the general complex (2,2) hypersurface is unirational. Over F_p or Q,
   geometric rationality alone does not give a ground-field parametrization;
   L0 must separately produce a rational point/unirational map. The pipeline
   MUST reproduce this: find S, certify q = P_2 = 0, and emit the dominant map.

5. **Tangent residuals solve the primary \(d=3\) case.**  Fix a general line
   \(L\subset\mathbf P^2_y\).  The surface
   \(S=X\cap(\mathbf P^2_x\times L)\) is a conic bundle over
   \(L\simeq\mathbf P^1\), hence is rational by Tsen.  On a smooth cubic fiber
   \(C_x\) of \(X\to\mathbf P^2_x\), send
   \(p\in C_x\cap L\) to the residual point \(r\) in
   \(T_pC_x\cdot C_x=2p+r\).  The three residual points are collinear and
   sweep a divisor \(T\).

   The universal binary resultant identity shows that the residual line is
   degree five in the coefficients of the cubic.  Those coefficients are
   quadratic in \(x\), so

   \[
   [T]=10H_x+H_y.
   \]

   The residual map \(S\dashrightarrow T\) is birational, while
   \(T\to\mathbf P^2_y\) has degree \(20\).  Thus \(T\) is the required
   horizontal rational surface and base change gives a dominant degree-20
   rational map to \(X\).  See the exact theorem and checker in
   `certificates/tangent_residual_theorem.md` and
   `certificates/tangent_residual_local_checks.py`.

## Parameter counts for the degree-two subproblem

For d = 3, class (1, k): parameters = 3·C(k+2, 2) − 1 (the σ's)
≈ 1.5k². The smooth value is p_g = h^0(O_{P^2}(k)) = C(k+2, 2).
An ordinary r-fold branch point, allowed to move, heuristically costs
C(r+1,2)−2 conditions but removes only C(floor(r/2),2) independent adjoints.
Thus an ordinary quadruple point costs 8 conditions and imposes at most one
independent adjunction condition: using only quadruple points would cost ≈ 4k²
against ≈ 1.5k² parameters.
A single point of multiplicity deg(B)−2 is more efficient but still costs
≈ 2k² + O(k), leaving a heuristic deficit ≈ 0.5k². These are only naive
counts: special dependencies, infinitely-near clusters, square factors, and q
and P_2 all matter. Making a correctly formulated adjoint-ideal incidence
rigorous is deliverable L1.  These counts concern only the classes `(1,k)`;
they never predicted the class-`(10,1)` tangent--residual surface and are not
evidence against the affirmative theorem.

## Computational objectives

The following records the original search program.  Its L0 and L1 outputs
remain independently useful certificates, but the tangent--residual theorem
supersedes L2 as a route to the headline answer.

**L0 — calibration (must pass before anything counts).**
1. Random (2,2) over F_p: construct the (1,0) member, verify dP2 invariants
   (K^2 = 2, q = P_2 = 0) in M2, emit the unirational parametrization of X.
2. Verify emptiness sanity: no horizontal surface of odd base-degree can be
   produced by any search route (statically true by fact 1; keep as an
   assertion in the harness).

**L1 — certified exclusion frontier for d = 3 (the workhorse; each item a
small theorem via the incidence/semicontinuity certificate, README).**
For k = 0, 1, 2, 3 and prescribed non-negligible singularity clusters Σ
(ordinary quadruple/higher points, infinitely-near clusters, or even branch
components): decide whether the general X admits σ with B_σ realizing Σ.
Track the resulting adjoint ideals and verify p_g, q, and P_2 on the canonical
resolution. Method: incidence {(X, σ, singularity cluster)} — the conditions
are explicit polynomial conditions on (coefficients of X, σ); compute the
incidence dimension over F_p and compare to dim P(coeffs of X) = 59.
Fast screen: rank of the linearized condition matrix at random points (rank
semicontinuity); confirm claims with honest saturated-ideal dimension runs.
Output: statements of the form "the general (2,3) hypersurface has no
(1,k)-member with adjoint cluster Σ, k ≤ 3." The first certified case is in
`certificates/k0_no_triple.m2`: for general X, no k=0 branch sextic has even a
multiplicity-3 point, so every |H_x| member has K3 as its smooth minimal model.
For k=1, `certificates/k1_frontier.md` gives the exhaustive finite list of
rational residual-branch strata after square factors are removed, including
the separate linear-adjoint and doubled-weight conic cluster conditions.  The
proper one-`t=3` octic stratum is excluded by
`certificates/k1_work/proper_sixfold_theorem.md`, and the squared-line theorem
in `certificates/k1_work/square_line_theorem.md` removes the entire residual
sextic row, reducible higher square factors, and `B_sigma=0`.  The stronger
conic-factor theorem in `certificates/k1_work/conic_factor_theorem.md` removes
the entire residual-quartic row.  Finally,
`certificates/k1_work/cubic_factor_theorem.md` excludes even a single integral
cubic factor and therefore removes the residual-conic row.  After those
square-factor exclusions, the only row left at that stage was the square-free
octic row with three `t=2` centers.  The triangle theorem
in `certificates/k1_work/proper_three_center_theorem.md` excludes the subrow in
which all three essential centers are proper.  Thus every remaining diagram
has at least one infinitely-near essential center.  The further theorem
`certificates/k1_work/adjacent_nested_pair_theorem.md` excludes every root
type `[2,1]` in which the repeated essential centers are adjacent, as well as
the proper-root successive-free adjacent chain of root type `[3]`.  Its exact
determinant-bound and codimension arithmetic is checked in
`certificates/k1_work/adjacent_nested_pair_local_checks.py`.  The further theorem
`certificates/k1_work/three_singleton_first_near_theorem.md` excludes every
remaining root type `[1,1,1]`, retaining all first-near tangent data.  Its
rank-three and rank-two determinant and codimension arithmetic is checked in
`certificates/k1_work/three_singleton_first_near_local_checks.py`.
The exact separator theorem
`certificates/k1_work/root_three_separator_theorem.md` then proves that a gap
between consecutive essential centers contains exactly one `t=1` center,
of free type `(4,3,4)` or satellite type `(5,3,4)`, and classifies all
remaining chains.  The theorem
`certificates/k1_work/root_two_one_separator_theorem.md` excludes both
separator types in root `[2,1]`, including every singleton tangent and every
rank-two base-point position.  Finally,
`certificates/k1_work/root_three_free_separator_theorem.md` and
`certificates/k1_work/root_three_completion_theorem.md` exclude all root
`[3]` chains.  The last three exclusion theorems are checked by
`root_two_one_separator_local_checks.py`,
`root_three_free_separator_local_checks.py`, and
`root_three_completion_local_checks.py` in `certificates/k1_work/`; the last
rank-three gluing bound has codimension `9>8`, and the rank-two minimum is
`8>7`.  Together these theorems exclude the complete class `(1,1)` rationality
frontier for a general `X`.  This completes `k=1`
(alongside the earlier `k=0` theorem), not all degree-two classes: `(1,k)`
with `k>=2` remain open.

The earlier equigeneric/theta-characteristic attempt, its explicit
genus-four counterexample, and the determinant-fiber obstruction to that
shortcut remain recorded in
`certificates/k1_work/three_center_equigeneric_attempt.md`,
`certificates/k1_work/three_center_genus_counterexample.md`, and
`certificates/k1_work/determinant_fiber_limits.md`.  The structural precursor
`certificates/k1_work/contact_cubic_observation.md` partitions the root types,
proves the immediate `(3,4)` lemma, and produces a universal doubled-cluster
cubic; shared exceptional components explain why that observation alone was
not an exclusion theorem.  The later marked incidence proofs above close the
finite row without using the failed uniform-genus shortcut.

**L2 — superseded long-shot hunts.**
1. Direct rational-image search: maps φ = (φ_x, φ_y) : P^2 → X of small
   bidegree with image a horizontal divisor — a birational-onto-image φ
   makes S rational *by construction* (no Castelnuovo check needed). Solve
   F(φ) ≡ 0 over F_p by structured ansatze (images through known curves,
   symmetry). Expect empty by the counts; log every certified emptiness as
   L1-type output.
2. Special-branch hunt: solve for σ making B_σ = σ^T adj(A) σ have even
   components, non-negligible singularity clusters, or a square-free
   normalization of low enough complexity. Mere reducibility is insufficient:
   transverse component intersections give A_1 points and ordinary triple
   intersections give D_4 points, neither of which lowers p_g.
   `certificates/special_unirational_example.m2` supplies the positive
   calibration: a special smooth X has a constant-line branch sextic with a
   proper triple point followed by an infinitely-near triple point.  The
   corrected total branch multiplicities are (3,4), so the second center is
   non-negligible and the resulting bisection is rational.
3. a = 2 classes (base-degree 4, quadruple planes): open up only after the
   (1,k) frontier is mapped; the analysis is genuinely harder (no clean
   double-plane model) — treat via invariants (q, P_2) of explicit singular
   members produced by liaison inside |(2, b)|.

**Historical hit protocol.** Second prime → exact lift over Q → independent verification
of rationality of S (both Castelnuovo invariants and an explicit birational
parametrization if possible) → write out the dominant degree-2a map
P^2 × P^1 ⇢ X. This proves that the lifted **individual X** is unirational.
Absent the universal theorem above, resolving the general case would also
have required proving that a characteristic-zero
incidence component of rational multisections dominates the full P^59 of X's,
with rationality persisting in the family (or give a universal construction on
a dense open).  The tangent--residual construction supplies the latter
directly.  Two primes and an exact lift would not have replaced this dominance
step.

## Pitfalls

- Fact 1's parity holds for every smooth ample X by Grothendieck–Lefschetz; it
  does not require a smooth discriminant. Singular test X's can acquire extra
  Weil divisors, so always confirm X itself is smooth. Confirming that Δ is a
  smooth degree-9 curve is a separate genericity check.
- Invariant computations (q, P_2) must be on a RESOLUTION of S; M2
  computations on singular S compute the wrong thing silently. Budget for
  explicit resolution of non-ADE points/clusters or use the double-plane formulas
  (p_g, q of double planes with prescribed branch singularities are
  classical and tabulated) — cross-check both.
- Sparse-random X can accidentally have extra Noether–Lefschetz-type
  structure mod p; use dense-random X for certified runs, two primes.

## Success criteria

- The headline criterion is now met by the universal tangent--residual
  construction: it works on a dense open of the characteristic-zero
  coefficient space, its source surface is rational, and its image is
  horizontal of certified degree 20.
- The exact resultant identity, divisor class, generic birationality, and
  degree calculation must rerun from
  `certificates/tangent_residual_local_checks.py` and match its log.
- L0 and every L1 exclusion remain scoped independent results.  In particular,
  the complete `(1,1)` exclusion is compatible with the positive theorem,
  whose surface has class `(10,1)`.
- Nulls across any finite L1 range remain evidence only for the explicitly
  searched divisor classes and singularity types; they were never a global
  non-unirationality proof.

## References

- Harris notes pp. 23–24 (the three varieties; Question and refinement 11b).
- Unirationality of conic bundles: activity through 2025 —
  https://arxiv.org/pdf/2110.10057 (high-discriminant unirational families),
  https://arxiv.org/pdf/2511.17213 (discriminant degree 8, surface case).
- Mella's exact degree-9 boundary: https://arxiv.org/pdf/1403.7055.
- Del Centina--Verdi's special smooth (3,2), equivalently (2,3), unirational
  example: http://www.bdim.eu/item?fmt=pdf&id=RLINA_1980_8_69_6_338_0.
- Very general (2,n) stable irrationality:
  https://arxiv.org/pdf/1605.03029.
- Artin–Mumford (unirational, stably irrational — why stable-rationality
  obstructions are silent here).
- Classical rational double planes: Castelnuovo–Enriques; any modern survey
  of adjunction/double covers for the p_g/q formulas with branch
  singularities.
