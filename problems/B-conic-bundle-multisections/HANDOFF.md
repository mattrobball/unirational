# Handoff — faithful main theorem formalization

Verified 2026-07-26 in
`/Users/worker/unirational/problems/B-conic-bundle-multisections`.

## Read this first

The requested headline theorem is now faithfully formalized and mechanically verified. It has no
auxiliary line, section, integrality, gluing, or residual-image hypotheses:

```lean
theorem smooth_bidegree23_hasUnirationalParametrization
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F)
```

The theorem and its existential wrapper both depend on exactly:

```text
[propext, Classical.choice, Quot.sound]
```

In particular, neither depends on `sorryAx`. The exact type and no-`sorry` status are pinned by
`BConicBundleMultisections/MainTheoremGuard.lean`.

The repository is not globally `sorry`-free: it contains exactly two direct placeholders in
legacy modules, both outside the headline dependency closure. See “Remaining source boundary”
below. This is repository cleanup, not an open boundary of the main theorem.

## Identity and verified state

| Item | Value |
|---|---|
| Publication branch | `agent/formalize-conic-bundle-and-audit-klein-cubic` |
| Base commit | `d0adc218e9116e300c4a6219df70c3995289b612` (`origin/main`) |
| Lean / Mathlib | `v4.32.1` / `v4.32.1` |
| Publication | The commit containing this handoff is pushed on the branch above |
| Final focused build | passed, 3,291 jobs |
| Umbrella build | passed, 3,305 jobs |
| Default build | passed, 3,305 jobs |
| Direct headline audit | standard three axioms only |
| `git diff --check` | passed |

The working tree was already broad and dirty. The publication commit is intentionally scoped to
the live theorem dependency closure, its axiom-audit corpus, the durable certificate scripts
referenced by that closure, and the final documentation. It also includes the sibling
`../E-klein-cubic/` research dossier and self-contained certificates while preserving its explicit
OPEN verdict; that directory's ignored `tmp/` computation tree is not part of the commit.

## Mathematical proof architecture

The live proof deliberately avoids the false fixed-coordinate-line strategy.

1. `Standard.exists_actualG3G4LineSection_via_frameIncidence` chooses one actual framed line
   carrying G3, a nondegenerate Tsen section, and G4 simultaneously. This replaces any claim that
   the hardcoded line `Y₂ = 0` must be good.

2. `targetRelationsProjectivelyIntegralAwayDiscriminant_of_smooth` proves that every retained
   target relation away from the conic discriminant is projectively integral. Its construction
   uses the retained affine-chart cover, integral chart rings, and one generic point lying in all
   retained charts.

3. Fix the first chart `a` and choose residual factors on every retained target chart `b`. For
   two target charts `b,b'`, put `T = Y_b' / Y_b` in the intrinsic function field. The formal
   transition calculation gives

   ```text
   F_b = T^3 F_b',     Q_b = T Q_b'.
   ```

   If `R_b F_b = Q_b` and `R_b' F_b' = Q_b'`, cancellation in the function field yields

   ```text
   R_b' = T^2 R_b.
   ```

   A homogeneous target quadratic satisfies `P_b = T^2 P_b'`, hence

   ```text
   P_b · coeff(R_b) = P_b' · coeff(R_b').
   ```

   This is the degree `-2` transition law in the orientation needed for gluing.

4. `targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn` constructs the full retained-
   chart family before invoking gluing. It does not promote one arbitrary local quotient to a
   global function. Same-chart uniqueness is used only to identify another factor with the
   already compatible family. Proper integral projective target curves have only scalar global
   regular functions, and the negative-twist argument forces the relevant coefficients to vanish.

5. `hasUnirationalParametrization3_biprojectiveZeroLocus` assembles line selection, target
   integrality, automatic gluing, the residual component, and the unirational component tower.
   `smooth_bidegree23_hasUnirationalParametrization` delegates to this unconditional endpoint.

An independent source-only review checked the family quantifiers, transition orientation,
factor cancellation, coefficient invariance, and lack of circularity. It found no unsound or
circular interface. The builds and axiom audits provide the separate mechanical check.

## Load-bearing files and endpoints

| Layer | File | Principal endpoint |
|---|---|---|
| Actual G3/G4 line and section | `BConicBundleMultisections/Standard/G3FrameIncidenceSelection.lean` | `Standard.exists_actualG3G4LineSection_via_frameIncidence` |
| Retained target integrality | `BConicBundleMultisections/TargetRelationTotalSpaceIntegral.lean` | `targetRelationsProjectivelyIntegralAwayDiscriminant_of_smooth` |
| Intrinsic function field | `BConicBundleMultisections/ProjectiveHypersurfaceFunctionField.lean` | explicit/intrinsic chart-field comparison |
| Homogeneous chart transition | `BConicBundleMultisections/ProjectiveHypersurfaceChartTransition.lean` | degree-`e` dehomogenization transition |
| Target equation transport | `BConicBundleMultisections/ResidualTargetNegativeTwistChartEquationTransport.lean` | `affineChartEquationOverTargetRelationBase_intrinsic_transition` |
| Factor transition | `BConicBundleMultisections/ResidualTargetNegativeTwistFactorTransition.lean` | `residualTargetNegativeTwistFactor_coeff_intrinsic_transition` |
| Automatic family and membership | `BConicBundleMultisections/ResidualTargetNegativeTwistAutomaticGluing.lean` | automatic gluing and IsIso membership endpoints |
| Unconditional assembly | `BConicBundleMultisections/MainTheoremTargetReduction.lean` | `hasUnirationalParametrization3_biprojectiveZeroLocus` |
| Public theorem | `BConicBundleMultisections/MainTheorem.lean` | `smooth_bidegree23_hasUnirationalParametrization` |
| Mechanical guards | `BConicBundleMultisections/MainTheoremGuard.lean` | exact statement and no-`sorry` guards |
| Direct audit | `MainTheoremAxiomAudit.lean` | eight `#print axioms` checks |

The major new layers have neighboring `AxiomAudit.lean` modules. Every final endpoint printed only
`propext`, `Classical.choice`, and `Quot.sound`.

## Exact verification performed

The focused command was:

```bash
lake build \
  BConicBundleMultisections.Standard.G3FrameIncidenceSelection \
  BConicBundleMultisections.Standard.G3FrameIncidenceSelectionAxiomAudit \
  BConicBundleMultisections.TargetRelationTotalSpaceIntegral \
  BConicBundleMultisections.TargetRelationTotalSpaceIntegralAxiomAudit \
  BConicBundleMultisections.ResidualTargetNegativeTwistFactorTransition \
  BConicBundleMultisections.ResidualTargetNegativeTwistFactorTransitionAxiomAudit \
  BConicBundleMultisections.ResidualTargetNegativeTwistAutomaticGluing \
  BConicBundleMultisections.ResidualTargetNegativeTwistAutomaticGluingAxiomAudit \
  BConicBundleMultisections.MainTheoremTargetReduction \
  BConicBundleMultisections.MainTheoremTargetReductionAxiomAudit \
  BConicBundleMultisections.MainTheorem \
  BConicBundleMultisections.MainTheoremGuard
```

It completed successfully with 3,291 jobs. These checks then passed:

```bash
lake env lean MainTheoremAxiomAudit.lean
lake build BConicBundleMultisections
lake build
git diff --check
```

Both whole-project builds completed successfully with 3,305 jobs. Existing style and linter
warnings remain, but there were no build errors.

## Remaining source boundary

An anchored census over every `.lean` file returns exactly:

```text
BConicBundleMultisections/ResidualHorizontalityLine.lean:299:  sorry
BConicBundleMultisections/Standard/GenericSmoothness.lean:171:  sorry
```

- `det_residualYCoordsOn_ne_zero` belongs to the obsolete determinant-backed horizontality route.
  That route remains as a conditional/legacy development but is not consumed by the headline.
- `exists_nonempty_open_smooth_restrict` is a strengthened legacy generic-smoothness interface.
  It is not consumed by the headline.

There are no source `admit`, `axiom`, `axioms`, or `opaque` declarations. Do not report the whole
repository as `sorry`-free; report the more precise verified boundary above.

`CoordinateLineCounterexample.lean` is an important regression result: it records a smooth
bidegree-`(2,3)` example whose hardcoded coordinate line has constant residual line. Do not rewire
the headline through the old fixed-line claim. Likewise, do not resurrect the full reducible
`residualImage` as the target of a dominant map from irreducible affine space; the live proof uses
the residual component reached by the construction.

The two temporary root-level probes created for the final route,
`ScratchFinalRoute.lean` and `ScratchGammaIsoTop.lean`, were removed after their results were
incorporated into checked modules.

## Safe re-entry

```bash
cd /Users/worker/unirational/problems/B-conic-bundle-multisections
git status --short --branch
git rev-parse HEAD
lake build BConicBundleMultisections.MainTheoremGuard
lake env lean MainTheoremAxiomAudit.lean
lake build BConicBundleMultisections
lake build
rg -n '^[[:space:]]*sorry\b' --glob '*.lean' .
rg -n '^[[:space:]]*(public[[:space:]]+)?(admit|axiom|axioms|opaque)[[:space:]]+[A-Za-z_]' \
  --glob '*.lean' .
git diff --check
```

No Lean build process was left running. This handoff is published with the conic-bundle
formalization and the explicitly open Klein-cubic research dossier on
`agent/formalize-conic-bundle-and-audit-klein-cubic`.
