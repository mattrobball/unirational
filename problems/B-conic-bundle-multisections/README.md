# BConicBundleMultisections

Lean 4 / Mathlib workspace for an idiomatic formalization of the tangent-residual proof that
every smooth bidegree `(2, 3)` hypersurface in `ℙ² × ℙ²` over an algebraically closed field of
characteristic zero is unirational.

This initial milestone supplies a reproducible project and an API-by-API formalization ledger;
it does **not** claim that the unirationality theorem has already been formalized.

## Toolchain

- Lean: `v4.32.1` (from `lean-toolchain`)
- Mathlib: release `v4.32.1`, commit
  `520045ab14e26149ee970e2e617ca04b09bde5d6`, pinned by `lake-manifest.json`
- Root module: `BConicBundleMultisections`

Build and lint from this directory with:

```sh
lake --wfail build
lake lint
```

The first build may compile Mathlib from source when a binary cache for this exact release is
not yet available.  The lint command is wired to the same Batteries lint driver used by Mathlib.

## Files

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
  injectivity of chart dehomogenization, and the canonical `F hF`-indexed global zero locus.
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
- `BConicBundleMultisections/ProjectiveLineRestriction.lean`, `BinaryResultant.lean`, and
  `BinaryCubicResidual.lean`: restriction to a projective line, fixed-degree binary resultants,
  and exact cubic tangent-residual polynomial identities.
- `BConicBundleMultisections/Basic.lean`: compatibility import for the basic polynomial and
  unirationality vocabulary.
- `CONCEPT_LEDGER.md`: 199-item natural-language-to-Mathlib API ledger, 14 ordered work packages,
  pinned-source and Loogle audits, dependency graph, and final acceptance checklist.
- `SPEC.md`: local problem specification.
- `RESOLUTION.md`: resolved natural-language proof architecture.
- `certificates/all_smooth_tangent_residual_theorem.md`: authoritative all-smooth proof source.
