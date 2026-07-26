# Formalization status

Current as of 26 July 2026. This file is the authoritative Lean status; it supersedes older
progress notes and historical blocker lists.

## Headline: fully proved

The faithful theorem has no auxiliary geometric hypotheses:

```lean
theorem smooth_bidegree23_hasUnirationalParametrization
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F)
```

It is proved in `BConicBundleMultisections/MainTheorem.lean`. The existential wrapper
`smooth_bidegree23_isUnirationalOver` is proved as well.

The direct audit reports:

```text
'BConicBundleMultisections.smooth_bidegree23_hasUnirationalParametrization' depends on axioms:
[propext, Classical.choice, Quot.sound]

'BConicBundleMultisections.smooth_bidegree23_isUnirationalOver' depends on axioms:
[propext, Classical.choice, Quot.sound]
```

`MainTheoremGuard.lean` pins the exact theorem type and applies `#guard_no_sorry` both to the
headline theorem and to its statement guard. Adding an auxiliary hypothesis, weakening the
dimension, changing the target, or reintroducing `sorryAx` now breaks the build.

## Verified build state

Environment:

- Lean `4.32.1`
- Mathlib `v4.32.1`
- publication target `main`, fast-forwarded from
  `agent/formalize-conic-bundle-and-audit-klein-cubic`

Checks run from this problem directory:

```text
focused final dependency-and-audit build
  Build completed successfully (3291 jobs).

lake env lean MainTheoremAxiomAudit.lean
  all eight selected endpoints: standard three axioms only

lake build BConicBundleMultisections
  Build completed successfully (3305 jobs).

lake build
  Build completed successfully (3305 jobs).
```

The build emits existing style/linter warnings, but no errors. Focused source-and-axiom-audit
builds also passed for the chart transition, factor transition, automatic gluing, projective
integrality, and final target-reduction layers.

The Mathlib-only `Statement.lean`/`Solution.lean` package was also accepted by upstream Comparator
v4.32.0 retargeted to Lean v4.32.1 on macOS and Linux. Both runs reached theorem-closure,
permitted-axiom, export, and Lean default-kernel acceptance. The macOS run used Comparator's
insecure fake-landrun shim; the Apple-container Linux kernel had Landlock disabled, so its
`--best-effort` sandbox degraded to no Landlock restrictions. This is a proof-validation result,
not an adversarial sandbox-security claim.

The commit containing this file publishes the result together with its axiom-audit corpus and the
separate, explicitly open Klein-cubic research dossier. Exploratory B-side files outside the live
theorem and audit closure remain uncommitted.

## Mathematical route formalized

The proof no longer tries to prove that one hardcoded coordinate line is good. Its live route is:

1. `Standard.exists_actualG3G4LineSection_via_frameIncidence` chooses one actual framed line that
   simultaneously carries G3, a nondegenerate Tsen section, and G4.
2. `targetRelationsProjectivelyIntegralAwayDiscriminant_of_smooth` proves the retained target
   relations projectively integral away from the conic discriminant.
3. Local residual factors are constructed on every retained target chart. For two charts, target
   bihomogeneity gives

   ```text
   F_b = T^3 F_b',    Q_b = T Q_b'.
   ```

   From `R_b F_b = Q_b` and `R_b' F_b' = Q_b'`, nonvanishing of the conic equation permits
   cancellation and yields the intrinsic degree-minus-two law

   ```text
   R_b' = T^2 R_b.
   ```

   A homogeneous target quadratic satisfies `P_b = T^2 P_b'`, so the two square laws give
   `P_b R_b = P_b' R_b'`; the product is independent of the retained chart.
4. `targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn` turns that coefficientwise
   compatibility into global regular functions on the integral projective target curve. Proper
   integral global functions are constant, and the negative-twist argument forces the residual
   relation coefficients to vanish.
5. `hasUnirationalParametrization3_biprojectiveZeroLocus` assembles the actual G3/G4 line,
   projective integrality, and automatic gluing into the residual-component/unirational-tower
   construction. `MainTheorem.smooth_bidegree23_hasUnirationalParametrization` is definitionally
   the same raw biprojective statement and delegates to this endpoint.

The main assembly lives in:

| Layer | Principal module / endpoint |
|---|---|
| Simultaneous line and section | `Standard/G3FrameIncidenceSelection.lean` / `exists_actualG3G4LineSection_via_frameIncidence` |
| Target integrality | `TargetRelationTotalSpaceIntegral.lean` / `targetRelationsProjectivelyIntegralAwayDiscriminant_of_smooth` |
| Intrinsic chart transition | `ProjectiveHypersurfaceChartTransition.lean` and `ResidualTargetNegativeTwistChartEquationTransport.lean` |
| Residual factor transition | `ResidualTargetNegativeTwistFactorTransition.lean` / `residualTargetNegativeTwistFactor_coeff_intrinsic_transition` |
| Automatic gluing | `ResidualTargetNegativeTwistAutomaticGluing.lean` / `targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn` |
| Final clean reduction | `MainTheoremTargetReduction.lean` / `hasUnirationalParametrization3_biprojectiveZeroLocus` |
| Exact public theorem | `MainTheorem.lean` / `smooth_bidegree23_hasUnirationalParametrization` |

Each new load-bearing endpoint has a neighboring `AxiomAudit.lean` file and was checked to depend
only on `propext`, `Classical.choice`, and `Quot.sound`.

## The exact remaining project-module `sorry` boundary

Excluding trusted comparator input `Statement.lean`, whose theorem body is intentionally the
challenge placeholder, an anchored source census finds exactly two direct legacy declarations in
the project modules:

| Module | Declaration | Current role |
|---|---|---|
| `Standard/GenericSmoothness.lean` | `exists_nonempty_open_smooth_restrict` | Strengthened legacy generic-smoothness interface; orphaned and unused by the headline route |
| `ResidualHorizontalityLine.lean` | `det_residualYCoordsOn_ne_zero` | Old isolated-determinant route; retained for reference and unused by the headline route |

Neither declaration is in the dependency closure of the headline theorem. This separation is
machine-checked by `#guard_no_sorry` and confirmed by the explicit axiom printout above. These are
cleanup tasks, not open boundaries of the formalized main theorem.

The old determinant-dependent chain remains available as a legacy conditional development, but
the following declarations no longer feed the headline:

- `det_residualYCoordsOn_ne_zero`
- `eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous`
- `residualYCoordsOn_ne_zero_of_good_line`
- `isDominant_residualZeroLocusPointOn_toBase`
- `isDominant_residualComponentOnToBase`
- `exists_isDominant_residualComponentOnToBase`
- `smooth_bidegree23_hasUnirationalParametrization_of_good_line_section`

## Statement fidelity and non-vacuity

`Bidegree23Example.smooth_F` gives a concrete, axiom-clean smooth bidegree-`(2,3)` example, and
`MainTheoremGuard.lean` pins it. Thus the `Smooth` hypothesis in the universal theorem is
satisfiable; the proof is not vacuous.

`CoordinateLineCounterexample.lean` records the complementary warning:
`Bidegree23Example.residualLineConstant` proves that the hardcoded coordinate line can have
constant residual line even for a smooth example. This is why the final proof uses an actual line
selected by frame incidence rather than silently normalizing an arbitrary fixed line.

The obsolete full-`residualImage` route is also not the headline route. The complete intersection
`V(F) ∩ V(q_F)` can acquire vertical components when the coefficients of `q_F` have a common
factor, so a claim of domination by irreducible affine space would be false for that full reducible
scheme. The formal proof works with the residual component actually reached by the residual map.

## Reproduction commands

```bash
cd /Users/worker/unirational/problems/B-conic-bundle-multisections
lake build BConicBundleMultisections.MainTheoremGuard
lake env lean MainTheoremAxiomAudit.lean
lake build BConicBundleMultisections
lake build
rg -n '^[[:space:]]*sorry\b' --glob '*.lean' --glob '!Statement.lean' .
rg -n '^[[:space:]]*(public[[:space:]]+)?(admit|axiom|axioms|opaque)[[:space:]]+[A-Za-z_]' \
  --glob '*.lean' .
git diff --check
```

The filtered `sorry` census should show only the two legacy declarations listed above. An
unfiltered census also shows the intentional comparator challenge hole in `Statement.lean`. The
declaration census should find no `admit` or source `axiom` declaration.
