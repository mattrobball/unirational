# RT for actual landing ideals — status

Exits (verbatim):

```text
ACTUAL-V-TOTAL-TRANSFER-PROVED
RT-DX0-PROVED
RETRACTION-IMPLIES-NONZERO-DX-PROVED
LEAKAGE-SUPPORT-CLASSIFICATION-PROVED
CONSTANT-QUOTIENT-COLLAPSE-PROVED
CLEAN-IMPLIES-NON-RATIONAL-SINGULAR-RECEIVER-PROVED
CLEAN-COMPONENTS-G-STABLE-FOR-k-AT-MOST-10-PROVED
KLEIN-CUBIC-NO-ECKARDT-POINTS

SLICE-PLUCKER-NORMAL-FORM-PROVED
SLICE-COMPLETE-IDEAL-CLUSTER-CLASSIFICATION-PROVED
SLICE-EXCESS-EQUALS-RATIONAL-CURVE-DEGREE-PROVED
ALL-POINTED-RATIONAL-CURVE-DEGREES-REALIZED
HIGHER-NORMAL-JET-DEPTH-UNBOUNDED
EXACT-KLEIN-CONIC-CELL-VERIFIED
LANDING-IDENTITIES-IMPOSE-NO-CURVE-TYPE-CONSTRAINT
KLEIN-INCIDENCE-MAP-FINITE
POINTED-LINE-CYLINDER-AND-GYSIN-ISOGENIES-EXIST
ORBIT-SUMMED-FULL-SUPPORT-ENDOMORPHISM-EXISTS

CONDUCTOR-GYSIN-EXCLUSION-REFUTED-RATIONALLY
GENERIC-COMMON-FACTOR-LINE-NORMAL-FORM-REFUTED
NORMAL-SURFACE-IH1-VANISHING-REFUTED
SLICE-LOCAL-POINTED-RATIONAL-CURVE-FULL-SUPPORT-EXCLUSION-REFUTED

FINITE-EQUIVARIANT-JET-DATA-ASYMPTOTICALLY-INTERPOLABLE-PROVED
FIXED-FINITE-LOCAL-DATA-NOT-AN-ALL-DEGREE-OBSTRUCTION-PROVED
DECORATED-CLUSTER-OBSTRUCTION-PROGRAM-BOTTOMED-OUT
GLOBAL-JACOBIAN-ADJUGATE-FACTORIZATION-PROVED
FORCED-DIVERGENCE-FREE-COVARIANT-DEGREE-2D-MINUS-4-PROVED
LANDING-COORDINATES-ARE-FIRST-INTEGRALS-PROVED
FORCED-FOLIATION-WITNESS-EXACT
FORCED-FOLIATION-CONDITIONS-CONSISTENT-NON-EQUIVARIANTLY
GLOBAL-JACOBIAN-COMPLEX-DEFECT-IDENTITY-PROVED
JACOBIAN-SOCLE-DEGREE-FIVE-EXACT
FIRST-ORDER-TANGENT-EXTENSION-GATE-VACUOUS-ABOVE-DEGREE-FIVE-PROVED
COVARIANT-AND-DIVERGENCE-FREE-DIMENSIONS-EXACT
LANDING-DEGREE-AT-LEAST-FOUR-PROVED
DEGREE-FOUR-DIVERGENCE-FREE-COVARIANT-EXPLICIT
BOXED-OBJECT-IS-THE-HEADLINE-OBJECT
RT-OBSTRUCTION-LADDER-CLOSED
FOLIATION-CLASSIFICATION-TARGET-REGISTERED

DEFECT-IDENTITY-IMPOSES-NO-EFFECTIVITY-CONSTRAINT

PULLED-GRADIENT-BASE-RADICAL-IDENTITY-PROVED
JACOBIAN-MAXIMAL-MINOR-PRODUCT-PROVED
BASE-POINT-JACOBIAN-RANK-AT-MOST-TWO-PROVED
KLEIN-NAMBU-WEDGE-IDENTITIES-PROVED
SATURATED-CRITICAL-DIVISOR-IS-A-DARBOUX-INVARIANT
SATURATED-FOLIATION-NEVER-NONSINGULAR-PROVED
SOURCE-TANGENCY-IS-THE-CONE-JACOBIAN-PROVED
SOURCE-TANGENCY-RAMIFICATION-FACTORIZATION-PROVED
TANGENCY-EXPONENT-IS-CODIMENSION-WEIGHT-NOT-TWO
SOURCE-TANGENCY-WITNESS-EXACT
RESTRICTED-COORDINATE-DEGREE-TWO-AND-THREE-EXCLUDED-ALL-DEGREES
NONIDENTITY-RESTRICTED-COORDINATE-DEGREE-AT-LEAST-FOUR
COMMON-FACTOR-CELLS-K-EQUALS-D-MINUS-2-AND-D-MINUS-3-EXCLUDED
D35-BRANCH-TABLE-EXACT
D35-COMMON-FACTOR-CELLS-K32-AND-K33-EXCLUDED
D35-ONE-DIMENSIONAL-RAMIFICATION-CELLS-IDENTIFIED
CODIMENSION-ONE-SMITH-DEFECT-CLASSIFICATION-PROVED
DIVISORIAL-DEFECT-LENGTHS-CANCEL-PROVED
CODIMENSION-TWO-BALANCE-COEFFICIENT-EXACT
TANGENCY-SURJECTIVITY-KILLS-THE-ISOLATED-DELTA-LANE
SATURATED-FOLIATION-INVARIANT-UNDER-POSTCOMPOSITION-PROVED
FOLIATION-QUOTIENT-CLASSIFICATION-REGISTERED
GENERIC-FIBRE-INDEX-DIVIDES-DELTA-PROVED
CLEAN-EVEN-DELTA-IS-DIVISIBLE-BY-FOUR-PROVED

LINE-INCIDENCE-FACTOR-TWO-CONDITIONAL
GLOBAL-COVARIANT-POINTED-RATIONAL-CURVE-EXCLUSION-UNDECIDED
RESTRICTED-TRANSFER-IN-THE-COMMON-FACTOR-BRANCH-UNDECIDED
PROBLEM-E-HEADLINE-OPEN
```

Terminal verifier markers: `verify_conic_slice.py`,
`verify_landing_identity.py`, `verify_normal_surface_countermodel.py`,
`verify_slice_universality.py`, `verify_forced_foliation.py`,
`verify_interpolation_scope.py`, `verify_covariant_dimensions.py`,
`verify_low_degree_covariants.py`, `verify_d4_covariant.py`,
`verify_source_tangency.py`, `verify_d35_dimensions.py`,
`verify_source_tangency.m2` and `forced_foliation_witness.m2` each print
`RESULT: PASS`; `eckardt_klein.m2` prints `ideal 1`.

**Not ported** (the external round-3 headline):
`POINTED-RATIONAL-CURVE-FULL-SUPPORT-EXCLUSION-REFUTED`. The construction that
was offered for it refutes only the slice-local version; see
`ADJUDICATION.md` item R20.

---

## What this packet is

An adjudicated port of external, unaudited work on restricted transfer (RT) for
**actual** landing ideals on the Klein cubic. Provenance and per-claim verdicts:
`SOURCES.md`, `ADJUDICATION.md`. The external work was right about most things,
wrong about one, and under-justified in two places where the missing proof
mattered.

A later external round (`[21]`, adjudicated on branch
`agent/rt-slice-classification-20260811`, verdicts `R1`–`R23`) added the slice
classification and a cylinder/Gysin automorphism of `V`. Its mathematics is
right — with several proofs supplied and one step corrected in the direction of
strength — and its **headline is overclaimed**: it refutes only the slice-local
form of the boxed exclusion, not the boxed exclusion itself, which is sharpened
rather than deleted.

A fourth external round (adjudicated on branch `agent/rt-foliation-20260811`,
verdicts `R24`–`R45`) supplied the equivariant interpolation theorem, the
forced foliation, the Chern-character defect identity and the Jacobian-socle
corollary. Its mathematics is right, with two proofs supplied, one claim
weakened (the foliation's degree is not pinned), two results deflated to
negative exits, and the interpolation theorem's **scope boundary** — which is
the part that decides what obstruction programs remain legal — supplied and
machine-checked here rather than by the source. See "What round 4 added".

A fifth external round (adjudicated on branch `agent/rt-tangency-20260811`,
verdicts `R5-1`–`R5-21`) classified the structures forced by a landing tuple.
Its one load-bearing new step — the source-tangency identity
`Delta_T|_X = c H^2 j_phi` — is stated there with a one-phrase justification;
the proof is supplied in `THEOREM_SOURCE_TANGENCY.md` and the identity comes out
**sharpened** (`c = d/d'` exactly, and the exponent is the residue weight
`n - e`, not universally `2`) and **conditioned** (it needs restricted
dominance, which the source omits and the repository proves). Its one genuine
exclusion — `d' = 2` and `d' = 3` are impossible in every ambient degree — is
confirmed and sealed in `EXCLUSION_DPRIME_2_3.md`; it removes the common-factor
cells `k = d-2, d-3` everywhere, including `k = 32, 33` at `d = 35`. Everything
numerical is recomputed exactly. No branch closes and the headline is
untouched. See "What round 5 added".

## What round 5 added

| file | content |
|---|---|
| `THEOREM_SOURCE_TANGENCY.md` | the supplied proof of `Delta_T\|_X = (d/d')H^{n-e} j_phi`, via the residue form; `Delta_T` **is** the cone Jacobian of the restricted map; exact worked instances at `w = 1,2,3` and on a genuine cubic threefold |
| `EXCLUSION_DPRIME_2_3.md` | **sealed:** `d' in {2,3}` impossible in every degree; sharpness; composition with the sealed sieve; the `d'` vs `delta` guard |
| `BASE_GRADIENT_PACKAGE.md` | socle sandwich, `I_4(J_T)=I_P I_Q`, rank `<= 2` at base points, Klein–Nambu wedges, `a_T` invariant and Darboux, `19 266 655` |
| `D35_BRANCH_TABLE.md` | the complete `d = 35` table, exact; the **two one-dimensional actionable cells** `k = 30, 31`; `ind(C) \| delta` and `4 \| delta` |
| `DEFECT_SMITH_CLASSIFICATION.md` | codim-one Smith partitions, why the divisorial lengths cancel, the `340` threshold |
| `FOLIATION_REFORMULATION.md` §§5–7 | tangency-map surjectivity (the isolated-`Delta` lane is empty), the foliation quotient, postcomposition invariance, the two scope corrections |
| `BOXED_GLOBAL_COVARIANT.md` §6 | the coupled-package form (54): the geometric alternative as one condition on one object |

## What is proved

1. **Total transfer of the actual class.** There is a `G`-equivariant
   `Theta : IC_Y^H → Rh_*IC_Γ^H[1]` in `D^b MHM(Y)` with
   `Theta_H alpha_A = i_q` on `IH^3`, and `i_q` is injective. The actual copy of
   `V = H^3(X,Q)(1)` survives restriction, dominant-component selection and
   normalization, as a Hodge substructure.
   (`THEOREM_ACTUAL_TRANSFER.md` sections 2–3.)

2. **RT in the no-common-factor branch.** If the divisorial common factor `D_X`
   of the restricted tuple vanishes, then

   ```
   u_phi = t_pi i_q|_V = 0     and     r_phi = i_q|_V != 0,
   ```

   i.e. **`D_X = 0` forces CARRIER** and the full-support correspondence of the
   graph vanishes identically. (`THEOREM_ACTUAL_TRANSFER.md` section 4.)

3. **Retraction corollary.** If the restricted map is the identity then
   `D_X != 0`, hence `D_X ∈ |kH|` with `k ≥ 5` by the sealed invariant-degree
   lemma — reproducing the repository's degree floor `d ≥ 6` for a nontrivial
   `G`-retraction from the RT side, independently of the polar-identity route.
   The two agree. (`THEOREM_ACTUAL_TRANSFER.md` section 5.)

4. **Leakage classification.** A proper ambient strict support can reach the
   restricted full-support summand only if `S ⊂ X`, `dim S = 2`, `S` a component
   of `D_X`, in perverse degree `j = 0`, through the block `IC_S(U)(-1)`; and
   only the **constant quotient** of the finite-monodromy local system `U` can
   leak. (`THEOREM_LEAKAGE_CLASSIFICATION.md` sections 1–3.)

5. **What CLEAN costs.** A common-factor surface that is smooth, or normal with
   rational singularities, cannot leak. So CLEAN forces a component that is
   nonnormal or has a non-rational singularity. In the window `5 ≤ k ≤ 10`,
   every component of `D_X` is individually `G`-stable, so CLEAN needs a single
   `G`-stable such surface whose resolved normalization carries the whole of
   `V`, hence an `E_{-11}^5`-isotypic Albanese factor.
   (`THEOREM_LEAKAGE_CLASSIFICATION.md` sections 4–5.)

6. **The Klein cubic has no Eckardt points** (exact Macaulay2 computation): no
   hyperplane section of it is a cone over a plane cubic.

## What is refuted

7. **The conductor/local-genus Gysin exclusion is false**, and by a route much
   cheaper than the external source's. The identity of `V` factors through `H^1`
   of a smooth model of a proper divisor, `G`-equivariantly, with `Q`
   coefficients, **unconditionally on every smooth cubic threefold**, by
   Bloch–Srinivas — no minimal-class input needed. Since the leakage problem is
   entirely `Q`-linear, this is the right coefficient level.
   (`REFUTATION_CONDUCTOR_GYSIN.md`.)

   Coefficient-level finding, stated plainly: the *rational* receiver exists
   unconditionally; the repository's sealed *integral non-equivariant* minimal
   class (`KLEIN-IJ-MINIMAL-CLASS-ALGEBRAIC`) is real but unnecessary here; and
   the *integral `G`-equivariant* statement is **not** available — the
   repository's own audit forces only `660 · M^{-1}`. So this refutation does
   not touch a hypothetical integral-equivariant exclusion.

8. **The line-only slice normal form is refuted** by an exact Klein-cubic
   countermodel: a tuple with base ideal `(u,v)^2` whose exceptional `P^1` maps
   isomorphically to a **smooth conic** in `X`.
   (`COUNTERMODEL_CONIC_SLICE.md`.)

9. **"`S` normal ⟹ `IH^1(S,Q) = 0`" is refuted** (an external claim that this
   adjudication had to overturn, not one the source withdrew). Exact
   countermodel: a smooth cubic threefold whose hyperplane section is a normal
   Cartier cone over a smooth plane cubic, with `H^1(S,O_S) = 0` but
   `IH^1(S,Q) = Q^2`. (`THEOREM_LEAKAGE_CLASSIFICATION.md` section 4.3.)

## What round 3 added

10. **The slice classification, and it is empty of constraint.** The normalized
    two-dimensional slice ideal is always `I = (a, fJ)` with `J` the
    gauge-invariant Plücker ideal of `(B,C)`; its integral closure is a
    Zariski–Lipman weighted cluster whose excesses are exactly the degrees of the
    rational curves the exceptional components carry. And **every** pointed
    rational curve on `X`, of every degree, occurs as such a slice satisfying the
    four landing identities — with `R_0 = 0` forced — while the jet depth is
    unbounded at fixed target degree 1. So the identities constrain the curve
    type not at all. (`SLICE_CLASSIFICATION.md`, `verify_slice_universality.py`,
    314 exact assertions.)

11. **An invertible cylinder/Gysin endomorphism of `V` built from pointed
    lines exists.** For a general smooth `D ∈ |k(a·e^*H + m·pi^*C)|` on the
    incidence threefold, the composite `V → H^1(D,Q) → V` equals
    `k m · B_C ∘ alpha_F`, an automorphism: `alpha_F` is the Clemens–Griffiths
    cylinder isomorphism and `B_C` is its Lefschetz-twisted Poincaré adjoint. It
    is `G`-equivariant, integral, and satisfies the Rosati-norm identity
    automatically, being an element of `O_{Q(sqrt(-11))}`.
    (`REFUTATION_POINTED_CURVE_EXCLUSION.md`.)

    Two by-products: the Klein cubic's *absence of Eckardt points* is exactly
    what makes `e : I → X` finite and the incidence polarization ample
    (`KLEIN-INCIDENCE-MAP-FINITE`); and the receiver `e(D) ⊂ X` is forced to be
    non-normal or to have a non-rational singularity — the construction is a
    **witness for** `CLEAN-IMPLIES-NON-RATIONAL-SINGULAR-RECEIVER-PROVED`, not a
    counterexample to it.

## What round 4 added

**(a) The box's object is the headline object.** The equivalence chain
"covariant in some degree `<=>` `G`-equivariant dominant rational map `<=>`
`X_gen(K_proj) != ∅`" is sealed in the repository
(`G2-FINITE-GENERATION-PASS` + `G3-DOMINANCE-AUTOMATIC`), and
`ed_C(PSL(2,11)) = 4 <=> ` the Klein cubic is not `G`-unirational
(`RESOLUTION.md`). So proving "no single homogeneous `G`-covariant landing
tuple" **is** proving the headline — not reducing it. One input inside that
chain is accepted rather than proved here: `ed_C(G) >= 3` (Beauville), flagged
as `ACCEPTED_INPUT` in the dominance bridge's own ledger.
(`BOXED_GLOBAL_COVARIANT.md` §3.)

**(b) The equivariant interpolation theorem, and the third lane to bottom out.**
For a *fixed* `G`-stable `Z`, every compatible invariant jet package on `Z` is
realised by a global `G`-covariant in all sufficiently large degree (Serre
vanishing + Reynolds). Hence no obstruction program built from fixed finite
local, cluster, incidence or attachment data can give all-degree nonexistence —
which is why the decorated-cluster classification came out empty. The boundary
is stated exactly and machine-checked: `d_0` depends on `Z` and is unbounded;
data that **grows with `d`** is not covered; only stabiliser-**compatible** data
is interpolable in any degree; and the theorem is blind to the nonlinear
condition `F(T) = 0`. This is the third lane to reduce to the headline itself,
after the F55 coefficient circuits and the CLEAN arithmetic sieve.
(`INTERPOLATION_THEOREM.md`.)

**(c) The forced foliation.** Every primitive landing tuple of degree `d`
forces a nonzero `G`-covariant `P_T` of degree exactly `2d-4` with
`adj(J_T) = P_T grad F(T)^t`, `J_T P_T = 0` and `div P_T = 0`, of which all five
landing coordinates are first integrals — a `G`-invariant divergence-free
rank-one algebraically integrable foliation on `P^4`. Every step is proved here,
including the two the source compresses (the content/primitivity step, and the
adjugate conjugation identity behind the character bookkeeping).
(`THEOREM_FORCED_FOLIATION.md`.)

**(d) An exact witness, and what it costs.** A smooth cubic threefold and an
explicit primitive dominant degree-7 tuple satisfy every one of those identities
symbolically over `Q`. Consequence: **no contradiction is available from the
forced structure alone** — any exclusion must consume the equivariance, the
specific `G`-module, or the Klein `F` itself. The witness also corrects the
source: `P_T` need not be primitive (here the content has degree `8` of `10`),
so the *foliation*'s degree is not pinned, only the covariant's.

**(e) Two deflations.** The `ch_2` defect identity replays exactly and
constrains nothing, because its terms carry opposite signs — recorded as a
negative exit. And the first-order tangent-extension gate of the retraction
branch is vacuous: the Klein Jacobian ring has socle degree `5`, the gate is
exactly one linear condition in degree `5`, nothing at all above it, and the
vacuity survives passage to the equivariant category — so in the surviving range
(`d >= 24`) that identity carries no information. The branch's content is
entirely the recorded `Delta = R^2 + 4S` nonsquare residual.
(`DEFECT_IDENTITY.md`.)

**(f) A new lane, with the first cases small.** Exact character arithmetic gives
`dim (Sym^k W^v ⊗ W)^G` and, via a divergence surjectivity lemma, the
divergence-free dimensions. Two consequences: every landing tuple has `d >= 4`
(from `C(2) = C(3) = 0`, with no branch hypothesis), and the divergence-free
space is **one-dimensional** for `d = 4` and for `d = 5`, then `4` and `7`. So
the bottom of the foliation lane is a finite question about one named vector
field — and that field is now written down: `D_4`, primitive, **over `Q`**,
seven terms per component, reproduced by explicit representation theory over
`Q(zeta_11)` (which independently confirms the whole dimension table for
`k <= 8`) and audited on a separate arithmetic path. Whether the foliation `D_4`
defines is realised by a landing tuple is open and untouched.
(`FOLIATION_REFORMULATION.md` §3.)

## What remains

12. The boxed remaining theorem is a statement about the **single global
    homogeneous `G`-covariant tuple**, not about receivers in the abstract, and
    it is now sharpened so that all five global data are simultaneous: global
    degree and representation, invariant degree `k >= 5`, attachment of `H` to
    `D_X`, the slice data of *that* tuple, and the incidence of *its own* curve
    families. The slice-local version — drop the tuple and ask the same question
    of any pointed rational-curve family satisfying the identities — is now
    **known false**, so no argument that forgets the tuple can work.
    (`BOXED_GLOBAL_COVARIANT.md`, section 2.3 lists what a proof must consume.)

13. After round 4 the lane's live content is **two boxed alternatives**, and
    nothing else (`BOXED_GLOBAL_COVARIANT.md` §5):

    * **(A)** prove `X_gen(K_proj) = ∅` by completing the direct arithmetic on
      the explicit normalized cubic `V(Phi)` — current state `G3D-UNDECIDED`,
      with the Clifford/spinor-discriminant and 27-line gates `*-PARTIAL`;
    * **(B)** classify the `G`-invariant divergence-free rank-one foliations of
      `FOLIATION_REFORMULATION.md` and exclude a Klein-cubic first-integral
      field.

    The obstruction ladder between the box and the headline is closed from both
    sides: forgetting the tuple gives a false statement (round 3), and fixed
    finite local data can never suffice (round 4). What survives must be global,
    or grow with `d`, or consume `F(T) = 0`.

## Structural note

This refutation has the same shape as the already-recorded `O4` witness
(`O4-EIGENPLANE-CURVES-OPEN-WITH-WITNESS`, `FRONTIER-1` "NONEMPTY"): in both
cases an exclusion was proposed at the level of "no object of this type can
exist", and the object **is realised**. What is left in both cases is a question
about the actual map and the actual tuple. `FRONTIER-2` of
`SPIN_SOURCE_NETWORK/DEPENDENCY_MAP.md` — "`s = 2`: a `G`-orbit of SURFACES in
`Bs(phi)` with `E_{-11}` in the Albanese. Status unknown." — is, up to notation,
this packet's surface receiver.

## Boundary

Nothing here claims a contradiction, an exclusion of equivariant maps, or any
progress on rationality. The CARRIER branch is not excluded by the target-side
receiver ledger, whose own scope disclaimer says it proves nothing about the
existence of equivariant maps into `X`. The CLEAN branch survives through the
channel classified above.

**Problem E headline: OPEN.** Nothing here changes it.
