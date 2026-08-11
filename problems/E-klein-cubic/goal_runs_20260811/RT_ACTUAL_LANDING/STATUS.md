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

CONDUCTOR-GYSIN-EXCLUSION-REFUTED-RATIONALLY
GENERIC-COMMON-FACTOR-LINE-NORMAL-FORM-REFUTED
NORMAL-SURFACE-IH1-VANISHING-REFUTED

LINE-INCIDENCE-FACTOR-TWO-CONDITIONAL
GLOBAL-COVARIANT-POINTED-RATIONAL-CURVE-EXCLUSION-UNDECIDED
RESTRICTED-TRANSFER-IN-THE-COMMON-FACTOR-BRANCH-UNDECIDED
PROBLEM-E-HEADLINE-OPEN
```

Terminal verifier markers: `verify_conic_slice.py`,
`verify_landing_identity.py` and `verify_normal_surface_countermodel.py` each
print `RESULT: PASS`; `eckardt_klein.m2` prints `ideal 1`.

---

## What this packet is

An adjudicated port of external, unaudited work on restricted transfer (RT) for
**actual** landing ideals on the Klein cubic. Provenance and per-claim verdicts:
`SOURCES.md`, `ADJUDICATION.md`. The external work was right about most things,
wrong about one, and under-justified in two places where the missing proof
mattered.

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

## What remains

10. The boxed remaining theorem is a statement about the **single global
    homogeneous `G`-covariant tuple**, not about receivers in the abstract:
    classify the normalized two-dimensional slice ideals of tuples satisfying

    ```
    F(B + tC) = (F - H t)(R_0 + R_1 t - R_3 t^2),
    ```

    including all higher normal jets, and show the orbit-summed correspondences
    of the resulting pointed rational-curve families cannot realize the
    full-support endomorphism CLEAN requires. (`BOXED_GLOBAL_COVARIANT.md`.)

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
