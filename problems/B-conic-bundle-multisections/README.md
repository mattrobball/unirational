# BConicBundleMultisections

Lean 4 / Mathlib workspace for an idiomatic formalization of the tangent-residual proof that
every smooth bidegree `(2, 3)` hypersurface in `ℙ² × ℙ²` over an algebraically closed field of
characteristic zero is unirational.

The faithful headline theorem is fully formalized. Its exact type is pinned by
`BConicBundleMultisections/MainTheoremGuard.lean`, and both the theorem and its existential
wrapper depend only on `propext`, `Classical.choice`, and `Quot.sound`, not `sorryAx`. Two direct
legacy `sorry` declarations remain in modules outside the headline dependency closure; see
`FORMALIZATION_STATUS.md` for the exact boundary. Separately, trusted `Statement.lean` contains
the intentional challenge placeholder that Comparator replaces with `Solution.lean`.

The comparator-facing package uses a `Statement.lean` that imports only Mathlib. Upstream
Comparator v4.32.0, retargeted to this project's exact Lean v4.32.1 toolchain, accepted the
committed statement and solution on macOS and Linux. Those runs validate theorem closure,
permitted axioms, export, and Lean default-kernel replay; they do not establish adversarial
sandboxing on either host configuration.

## Toolchain

- Lean: `v4.32.1` (from `lean-toolchain`)
- Mathlib: release `v4.32.1`, commit
  `520045ab14e26149ee970e2e617ca04b09bde5d6`, pinned by `lake-manifest.json`
- Root module: `BConicBundleMultisections`

Reproduce the main build and direct audit from this directory with:

```sh
lake -q --log-level=error build
lake env lean MainTheoremAxiomAudit.lean
lake -q --log-level=error build Statement Solution
```

The first build may compile Mathlib from source when a binary cache for this exact release is not
yet available.

## Selected files

- `Statement.lean`: trusted Mathlib-only comparator statement.
- `Solution.lean` and `Solution/Definitions.lean`: comparator proof and independently duplicated
  trusted vocabulary.
- `comparator/smooth_bidegree23_unirationality.json` and `formalization.yaml`: comparator
  configuration and provenance.
- `BConicBundleMultisections/MainTheorem.lean`, `MainTheoremGuard.lean`, and
  `MainTheoremAxiomAudit.lean`: public theorem, exact statement/no-`sorry` guards, and direct axiom
  audit.

- `BConicBundleMultisections/BigradedPolynomial.lean`: generic biprojective coordinates,
  bihomogeneity, and the two Euler identities.
- `BConicBundleMultisections/Unirationality.lean`: rational-map dominance and the
  fixed-dimensional affine-source parametrization interface.
- `BConicBundleMultisections/ProjectiveSpace.lean`, `ProjectivePlane.lean`, and
  `BiprojectiveSpaceProperties.lean`: scheme-level projective `n`-space, its relative products,
  properness, and only then the thin `(2,2)` specialization. Homogeneous coordinates are indexed
  by `Fin (n + 1)` because `n` is geometric dimension.
- `BConicBundleMultisections/BiprojectiveChart.lean`, `BiprojectiveAffineChart.lean`,
  `BiprojectiveAffineChartDegree.lean`, and `BiprojectiveAffineJacobian.lean`: generic standard
  charts, polynomial-ring coordinate equivalences, bidegree bounds after dehomogenization, and
  exact homogeneous-to-affine Jacobian formulas.
- `BConicBundleMultisections/BiprojectiveChartDimension.lean`: domain and Noetherian instances,
  chart dimensions, height-one principal equations, and the exact hypersurface quotient
  dimension over a field.
- `BConicBundleMultisections/MvPolynomialDimension.lean` and
  `ProjectiveCommonZero.lean`: maximal-ideal heights for arbitrary finite-variable polynomial
  rings and the resulting Nullstellensatz/Krull-height theorem that fewer positive-degree
  homogeneous equations than coordinates have a common nonzero zero.
- `BConicBundleMultisections/BiprojectiveOverlap.lean` and
  `BiprojectiveOverlapScheme.lean`: coordinate changes and their scheme-theoretic overlap
  comparison.
- `BConicBundleMultisections/IdealSheafDescent.lean`,
  `BiprojectiveDehomogenization.lean`, and `BiprojectiveZeroLocus.lean`: ideal-sheaf descent,
  injectivity of chart dehomogenization, and the canonical `F`-indexed global zero locus
  (bihomogeneity is a hypothesis on descent theorems, not a constructor index).
- `BConicBundleMultisections/BiprojectiveAffineZeroLocus.lean` and
  `BiprojectiveZeroLocusSmooth.lean`: affine quotient presentations and restriction of global
  smoothness to explicit affine zero-locus charts.
- `BConicBundleMultisections/SchemeFiberClosedSubscheme.lean` and
  `BiprojectiveProjectionFiber.lean`: generic fibers of composites with closed immersions,
  residue-field base changes of both biprojective projections, transported fiber ideals, and
  exact whole-fiber criteria.
- `BConicBundleMultisections/BiprojectiveFiberPolynomial.lean`: generic specialization in either
  Cox-coordinate block, homogeneous fiber equations, derivative compatibility, and exact
  projective-representative scaling.
- `BConicBundleMultisections/BiprojectiveWholeFiberGradient.lean`: the generic Euler/common-zero
  argument showing that an identically zero fiber forces a nonzero coordinate point where the
  equation and its entire homogeneous gradient vanish.
- `BConicBundleMultisections/PlaneCubicTangentForm.lean` and
  `ProjectiveTangentHyperplane.lean`, together with `BiprojectiveFiberTangent.lean` and
  `BiprojectiveFiberTangentIncidence.lean`: generic coordinate tangent forms, projective
  incidence, and tangent forms of the plane-cubic fibers.
- `BConicBundleMultisections/ProjectiveHypersurfacePoints.lean`: point-level projective
  hypersurface and coordinate-nonsingularity predicates, kept explicitly separate from the
  scheme-theoretic smoothness API.
- `BConicBundleMultisections/ProjectiveLineRestriction.lean`, `BinaryResultant.lean`,
  `BinaryCubicResidual.lean`, `BinaryCubicDiscriminant.lean`, `CubicQuadraticResultant.lean`,
  and `CoordinateLineResultant.lean`: restriction to a projective line, fixed-degree binary
  resultants and discriminants, the explicit cubic–quadratic Sylvester formula, and the
  coordinate-line first-polar resultant setup for the universal residual identity.
- `BConicBundleMultisections/Basic.lean`: compatibility import for the basic polynomial and
  unirationality vocabulary.
- `CONCEPT_LEDGER.md`: 199-item natural-language-to-Mathlib API ledger, 14 ordered work packages,
  pinned-source and Loogle audits, dependency graph, and final acceptance checklist.
- `SPEC.md`: local problem specification.
- `RESOLUTION.md`: resolved natural-language proof architecture.
- `certificates/all_smooth_tangent_residual_theorem.md`: authoritative all-smooth proof source.
