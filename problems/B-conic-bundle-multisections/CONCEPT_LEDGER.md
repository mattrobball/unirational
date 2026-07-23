# Formalization ledger: unirationality of smooth `(2,3)` threefolds

This is the entry ledger for a complete, Mathlib-idiomatic formalization of the theorem in
[`certificates/all_smooth_tangent_residual_theorem.md`](certificates/all_smooth_tangent_residual_theorem.md):

> If `k` is algebraically closed of characteristic zero and
> `X ⊂ ℙ²_x ×_k ℙ²_y` is a smooth hypersurface of bidegree `(2,3)`, then `X` is unirational.
> More precisely, the tangent-residual construction produces a rational horizontal surface of
> class `a H_x + H_y`, with `1 ≤ a ≤ 10`, and hence a dominant rational parametrization of
> degree `2a ≤ 20`.  For a general equation, `a = 10`.

The natural-language proof source is authoritative for the mathematical route.  This ledger is
authoritative for what the pinned Mathlib revision can already express, what needs only a thin
local definition, and what genuinely remains to be formalized.  It does **not** replace a missing
geometric construction by an axiom.

## 0. Reproducible audit boundary

| Item | Pinned value |
|---|---|
| Lean | `leanprover/lean4:v4.32.1` in [`lean-toolchain`](lean-toolchain) |
| Mathlib release | `v4.32.1` in [`lakefile.toml`](lakefile.toml) |
| Mathlib commit | `520045ab14e26149ee970e2e617ca04b09bde5d6` in [`lake-manifest.json`](lake-manifest.json) |
| Project imports | explicit `public import`s in [`BConicBundleMultisections/Basic.lean`](BConicBundleMultisections/Basic.lean) and [`ProjectivePlane.lean`](BConicBundleMultisections/ProjectivePlane.lean) |
| Mathematical sources | [`SPEC.md`](SPEC.md), [`RESOLUTION.md`](RESOLUTION.md), [all-smooth theorem](certificates/all_smooth_tangent_residual_theorem.md), and [generic resultant theorem](certificates/tangent_residual_theorem.md) |

Pinned source links below use this base URL:

`https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/`

Status codes:

- **R** — reuse a precise Mathlib definition or theorem directly.
- **W** — a thin project-local wrapper/notation or a routine bridge around existing Mathlib APIs.
- **M** — missing substantive algebraic-geometry API or theorem; must be proved locally or
  upstreamed.
- **P** — already defined and compile-checked in this project.

The audit used exact-source search, declaration-shape search, and a Loogle index built from the
pinned `.olean` files.  In each row, backticked fully qualified names (or an explicitly displayed
type) are the precise formal instantiations; the pinned source links are module entry points, not
substitutes for those declaration names.  Negative findings mean “no matching high-level
declaration in the pinned checkout”; they do not mean that lower-level ingredients are absent.

## 1. Exact target interface

The canonical zero-locus constructor now exists.  The final theorem's exact intended shape is:

```lean
universe u

open CategoryTheory
open scoped AlgebraicGeometry
open AlgebraicGeometry

theorem smooth_bidegree23_hasUnirationalParametrization
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (BiprojectiveSpace.biprojectiveZeroLocusToSpec 2 2 k F hF)] :
    HasUnirationalParametrization 3
      (BiprojectiveSpace.biprojectiveZeroLocusToSpec 2 2 k F hF) := by
  ...

theorem smooth_bidegree23_isUnirational
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (BiprojectiveSpace.biprojectiveZeroLocusToSpec 2 2 k F hF)] :
    IsUnirationalOver
      (BiprojectiveSpace.biprojectiveZeroLocusToSpec 2 2 k F hF) :=
  (smooth_bidegree23_hasUnirationalParametrization k F hF hF0).isUnirationalOver
```

Here `biprojectiveZeroLocus` is the constructed canonical closed subscheme, not an assumed
parameter. Its ideal, subscheme, immersion, projections, and structure morphism are indexed by
both `F` and `hF`. The proof is a semantic guard: it prevents the public projective-zero-locus
API from accepting a non-bihomogeneous equation even though the underlying chartwise ideal
construction does not inspect the proof term. The embedding-indexed property
`IsBiprojectiveZeroLocus m n R F hF ι` is an explicit structure, not a typeclass; it identifies
any chosen presentation with the canonical one and supplies the flexible companion form of the
theorem.
The public theorem may use a bundled `Bidegree23Hypersurface`; the unbundled equation-level
fixed-dimension statement above is the acceptance test; `IsUnirationalOver` is its
dimension-forgetting corollary.  A companion theorem should expose the stronger output
`∃ a, 1 ≤ a ∧ a ≤ 10 ∧ ... degree = 2*a`; “general equation implies `a = 10`” is a separate
theorem and must not be folded into the all-smooth result.

## 2. Foundations and scheme language

The source links in this section are the precise Mathlib instantiations:
[schemes](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Scheme.lean),
[over-schemes](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Over.lean),
[properties](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Properties.lean),
[smooth morphisms](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Morphisms/Smooth.lean),
[geometric integrality](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Geometrically/Integral.lean), and
[closed points over algebraically closed fields](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/AlgClosed/Basic.lean).

| ID | Natural-language concept | Precise Lean realization | Status and use |
|---|---|---|---|
| F01 | Ground field | `(k : Type u) [Field k]` | **R** |
| F02 | Algebraically closed | `[IsAlgClosed k]` | **R**; do not specialize the main theorem to `ℂ`. |
| F03 | Characteristic zero | `[CharZero k]` | **R** |
| F04 | Perfect ground field | `PerfectField k`, inferred from `CharZero k` | **R**; needed by generic-smoothness results. |
| F05 | Infinite ground field | `Infinite k`, inferred from `IsAlgClosed k` in the nontrivial field case | **R**; used to choose a constant line outside finitely many proper loci. |
| F06 | Base scheme | `AlgebraicGeometry.Spec (CommRingCat.of k)`; usually `Spec (.of k)` | **R** |
| F07 | Scheme and morphism | `AlgebraicGeometry.Scheme.{u}` and `X ⟶ Y` | **R** |
| F08 | Scheme over a base | `Scheme.Over S`; structure map notation `X ↘ S`; `Scheme.Hom.IsOver` | **R** |
| F09 | Fiber product/base change | `CategoryTheory.Limits.pullback`, `pullback.fst`, `pullback.snd`, `pullback.lift` | **R** |
| F10 | Open/dense locus | `Scheme.Opens`, `Dense`, `IsOpen`, `Scheme.Opens.toScheme` | **R** |
| F11 | Generic point | `genericPoint X` under `IrreducibleSpace X` | **R** |
| F12 | Reduced/integral scheme | `AlgebraicGeometry.IsReduced X`, `AlgebraicGeometry.IsIntegral X` | **R** |
| F13 | Irreducibility | typeclasses `[PreirreducibleSpace X]`, `[IrreducibleSpace X]`; set predicates `IsPreirreducible s`, `IsIrreducible s` | **R**; do not interchange the typeclasses with the predicates. |
| F14 | Locally finite type/presentation | `LocallyOfFiniteType f`, `LocallyOfFinitePresentation f` | **R** |
| F15 | Proper/separated | `IsProper f`, `IsSeparated f` | **R** |
| F16 | Smooth morphism | `AlgebraicGeometry.Smooth f` | **R**; this is the current name (`IsSmooth` is deprecated). |
| F17 | Smooth relative dimension | `SmoothOfRelativeDimension n f` | **R**; use for the verified threefold dimension after the hypersurface dimension theorem. |
| F18 | Smooth locus | `Scheme.Hom.smoothLocus` | **R** |
| F19 | Generic smoothness currently available | `Scheme.Hom.genericPoint_mem_smoothLocus_of_perfectField` and `Scheme.Hom.dense_smoothLocus_of_perfectField` | **R/M**; the existing result is useful but does not by itself package the general dominant-family generic-fiber theorem needed here. |
| F20 | Dimension | `topologicalKrullDim`, `Module.support`, local/stalk Krull dimension APIs | **R/M**; no turnkey theorem currently proves that this bihomogeneous smooth zero locus has relative dimension `3`. |
| F21 | Finite-type morphism | the pair `[LocallyOfFiniteType f] [QuasiCompact f]`; Mathlib has no scheme-morphism class named `FiniteType` | **R/W** |
| F22 | Geometrically integral fibers | `AlgebraicGeometry.GeometricallyIntegral f` | **R** |
| F23 | Closed points as `k`-points | `residueFieldIsoBase`, `pointOfClosedPoint`, `pointEquivClosedPoint` for locally finite-type schemes over algebraically closed `k` | **R** |

## 3. `ℙ² × ℙ²` and the `(2,3)` hypersurface

Relevant exact sources are
[Proj scheme](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Scheme.lean),
[Proj structure map/charts](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean),
[Proj properness](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Proper.lean),
[weighted homogeneous polynomials](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/RingTheory/MvPolynomial/WeightedHomogeneous.lean), and
[subschemes](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/IdealSheaf/Subscheme.lean).
The point-level rows additionally use
[multivariable polynomial equivalences](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/Algebra/MvPolynomial/Equiv.lean),
[projective subspaces](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/LinearAlgebra/Projectivization/Subspace.lean),
[collinearity](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/LinearAlgebra/Projectivization/Collinear.lean), and
[three-dimensional constructions](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/LinearAlgebra/Projectivization/Constructions.lean).

| ID | Natural-language concept | Precise Lean realization | Status and use |
|---|---|---|---|
| G01 | Cox variables in two blocks | `BiprojectiveCoordinate m n := Sum (Fin (m + 1)) (Fin (n + 1))`; the `(2,2)` specialization has six variables | **P** |
| G02 | Bigrading | `bidegreeWeight : BiprojectiveCoordinate m n → ℕ × ℕ`, left variables ↦ `(1,0)`, right variables ↦ `(0,1)` | **P** |
| G03 | Bihomogeneous degree `(a,b)` | `MvPolynomial.IsWeightedHomogeneous bidegreeWeight F (a,b)` | **R/P** via `IsBihomogeneousOfBidegree`. |
| G04 | Bidegree `(2,3)` | `IsBidegree23 F` | **P** |
| G05 | Homogeneous pieces | `MvPolynomial.weightedHomogeneousSubmodule` and `weightedHomogeneousComponent` | **R** |
| G06 | Split two variable blocks | `MvPolynomial.sumRingEquiv` / `sumAlgEquiv` | **R** |
| G07 | Partial derivatives | `MvPolynomial.pderiv` | **R** |
| G08 | Euler identity | `MvPolynomial.IsWeightedHomogeneous.sum_weight_X_mul_pderiv` | **R** |
| G09 | Point-level projective `n`-space | `Projectivization k (Fin (n + 1) → k)` (notation `ℙ k V`); specialize to `n = 2` | **R**, but only for linear/projective incidence at the point level. |
| G10 | Projective lines, collinearity | `Projectivization.Subspace`, `Projectivization.Subspace.span`, `Projectivization.IsCollinear`, `Projectivization.line_unique`; `cross` constructions for dimension three | **R** |
| G11 | Scheme-level `Proj` | `AlgebraicGeometry.Proj 𝒜` | **R** |
| G12 | Scheme `ℙⁿ_R` | `ProjectiveSpace n R := Proj (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)`; `ProjectivePlane R := ProjectiveSpace 2 R` | **P/R**; defined over an arbitrary commutative ring. |
| G13 | Structure map of `ℙⁿ_R` | `ProjectiveSpace.toSpec n R`, built from `Proj.toSpecZero` followed by `Spec.map` of `algebraMap R (𝒜 0)` | **P/R**; the canonical degree-zero equivalence `(𝒜 0) ≃+* R` remains useful for transporting affine-chart and morphism properties cleanly. |
| G14 | Standard affine charts of `Proj` | `Proj.basicOpen`, `Proj.basicOpenIsoSpec`, `Proj.awayι`, `Proj.affineOpenCover`; project-local equivalences identify `ProjectiveSpace.StandardChartRing n R i` with `MvPolynomial (Fin n) R` and product charts with `MvPolynomial (Fin m ⊕ Fin n) R` | **P/R** |
| G15 | Properness of projective and biprojective space | `ProjectiveSpace.toSpec n R`, `BiprojectiveSpace.fst`, `.snd`, and `.toSpec` have `IsProper` instances for arbitrary dimensions over a commutative ring | **P/R** |
| G16 | Scheme-level projective-space API | no `AlgebraicGeometry.ProjectiveSpace` declaration in the pinned checkout; the project defines the thin local wrapper `ProjectiveSpace n R` and its standard charts | **P/R** |
| G17 | `ℙᵐ_R ×_R ℙⁿ_R` | `BiprojectiveSpace m n R := pullback (ProjectiveSpace.toSpec m R) (ProjectiveSpace.toSpec n R)`, with `BiprojectiveSpace.fst`, `.snd`, and `.toSpec`; specialize to `(2,2)` | **P/R** |
| G18 | Bihomogeneous polynomial as a global section of `O(a,b)` | no scheme line-bundle/global-section bridge from the Cox polynomial | **M** |
| G19 | Its vanishing ideal sheaf | `biprojectiveZeroLocusIdeal m n R F hF`, the finite infimum of the chart ideals extended by `IdealSheafData.map`; the explicit bihomogeneity proof is the semantic guard, and transition units prove the chart restrictions agree | **P/R** |
| G20 | Closed subscheme/hypersurface | `biprojectiveZeroLocus m n R F hF`, its canonical closed immersion `biprojectiveZeroLocusι m n R F hF`, and the explicit embedding-indexed structure `IsBiprojectiveZeroLocus m n R F hF ι`; every presentation is canonically isomorphic over `Spec R` to the constructed subscheme | **P/R** |
| G21 | Base-change compatibility of zero locus | `IdealSheafData.comap`, `comapIso`; prove polynomial zero-locus compatibility | **R/M** |
| G22 | Jacobian criterion for this zero locus | commutative-algebra Jacobian pieces exist, but no turnkey projective bihomogeneous smoothness criterion | **M** |
| G23 | Relative dimension `3` | ambient relative dimension `4` minus an effective Cartier divisor | **M**; neither the needed scheme line-bundle/effective-Cartier-divisor layer nor the final dimension theorem is packaged. |
| G24 | The two projections `ρ` and `π` | `biprojectiveZeroLocusFst m n R F hF` and `biprojectiveZeroLocusSnd m n R F hF`; both have `IsProper` instances | **P/R** |
| G25 | `ρ` as cubic fibration and `π` as conic bundle | prove by chartwise base change and the `(2,3)` support equation | **M** |
| G26 | Discriminant `det A(y)` of degree `9` | `Matrix.det` and homogeneous polynomial APIs | **R/W**; the symmetric-matrix presentation and scheme discriminant locus need local definitions. |
| G27 | Nonempty integral hypersurface | prove `Nonempty X_F`, connectedness/irreducibility, and `AlgebraicGeometry.IsIntegral X_F`; smoothness alone gives reduced regular components, not their connectedness | **M**; required before `genericPoint`, `functionField`, and generic-degree APIs. |
| G28 | Dominance of both projections | prove `Surjective ρ`, `Surjective π`, hence `IsDominant ρ` and `IsDominant π`; use nonemptiness of projective conics/cubics over `k` plus treatment of identically zero fibers | **M**; a bidegree label alone does not install these instances. |
| G29 | Flat, quasi-compact conic projection | prove `Flat π` and `QuasiCompact π` from the fixed relative degree/no-whole-fiber package (or a relative Cartier-divisor flatness theorem) | **M**; `IsSchemeTheoreticallyDominant.pullbackSnd` needs these hypotheses in U09. |

**Hard representation boundary.** `Projectivization k V` and scheme `Proj` are different APIs with
no verified equivalence in Mathlib.  Point-level tangent calculations may use the former, but the
main theorem, fibers, smoothness, rational maps, and dominance must use the latter.  An informal
identification between them is not an acceptable proof step.

The Mathlib-native WP1–WP2 construction route is concrete:

1. Define `ProjectiveSpace n k := Proj (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)`
   with the local `MvPolynomial.gradedAlgebra` instance, and introduce `ProjectivePlane k` only
   as the specialization `n = 2`.
2. Define its map to `Spec k` by `Proj.toSpecZero` followed by `Spec.map (algebraMap k _)`, and
   prove the degree-zero piece is canonically `k` using `homogeneousSubmodule_zero`.
3. Identify each `Proj.basicOpen (X i)` with affine `n`-space (affine two-space after specializing
   to `n = 2`).  Mathlib supplies `basicOpenIsoSpec`; the final
   homogeneous-localization-to-polynomial-ring equivalence is local.
4. Form the generic relative product by `pullback`.  On the nine charts of its `(2,2)`
   specialization reuse
   `pullbackSpecIso` and `MvPolynomial.tensorEquivSum`.
5. Dehomogenize `F` on chart `(i,j)` by dividing by `x_i^2 y_j^3`; the implemented transition-unit
   theorem proves the nine principal ideals agree after localization on overlaps.
6. For general `m` and `n`, assemble
   `I_F : (BiprojectiveSpace m n k).IdealSheafData` as the finite infimum of the local ideals
   extended by `IdealSheafData.map`, prove its restriction to every chart, and set
   `X_F := I_F.subscheme`; this is implemented by `biprojectiveZeroLocusIdeal` and
   `biprojectiveZeroLocus`.  The `(m,n) = (2,2)` specialization has nine standard charts.
7. Reuse the automatic closed-immersion instance for `I_F.subschemeι`; separately prove base
   change, properness, integrality, smoothness, and relative dimension.

## 4. Fibers, rational maps, rationality, and normalization

Exact sources:
[fibers](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Fiber.lean),
[residue fields](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/ResidueField.lean),
[function fields](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/FunctionField.lean),
[rational maps](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Birational/RationalMap.lean),
[dominance](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Birational/Dominant.lean),
[composition](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Birational/Composition.lean),
[birationality](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Birational/Birational.lean), and
[normalization](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Normalization.lean), together with
[finite-flat rank](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Morphisms/FlatRank.lean) and
[scheme-theoretic dominance](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Morphisms/SchemeTheoreticallyDominant.lean).

| ID | Natural-language concept | Precise Lean realization | Status and use |
|---|---|---|---|
| R01 | Scheme-theoretic fiber | `Scheme.Hom.fiber f y := pullback f (Y.fromSpecResidueField y)` | **R** |
| R02 | Fiber inclusion/base field | `f.fiberι y`, `f.fiberToSpecResidueField y`, `f.fiberOverSpecResidueField y` | **R** |
| R03 | Generic fiber | choose either `f.fiber (genericPoint Y)` or an explicit pullback to `Spec Y.functionField` | **R/W**; no named `genericFiber`, and the two models require R32 before they may be interchanged. |
| R04 | Function field | `Scheme.functionField X`; it is a `Field` under `[AlgebraicGeometry.IsIntegral X]` | **R** |
| R05 | Rational map | `Scheme.RationalMap X Y`, notation `X ⤏ Y` | **R** |
| R06 | Representative partial map/domain | `Scheme.PartialMap`, `RationalMap.representative`, `RationalMap.domain`; `RationalMap.toPartialMap` under `[IsReduced X] [Y.IsSeparated]` | **R**; the canonical maximal-domain representative has genuine prerequisites. |
| R07 | Morphism as rational map | `Scheme.Hom.toRationalMap` | **R** |
| R08 | Rational map over a base | `RationalMap.IsOver S f`, equivalently `f.compHom (Y ↘ S) = (X ↘ S).toRationalMap` when over-structures are installed | **R** |
| R09 | Dominant morphism | `AlgebraicGeometry.IsDominant f` | **R** |
| R10 | Dominant rational map | protected class `Scheme.RationalMap.IsDominant f` | **R** |
| R11 | Composition | `RationalMap.comp` under `[PreirreducibleSpace X] [Nonempty Y]` and dominance of the left map; `RationalMap.compHom` for a morphism on the right | **R** |
| R12 | Birational map | `Scheme.PartialIso X Y`; propositions `Scheme.Birational X Y` and `Scheme.BirationalOver sX sY` | **R** |
| R13 | Rational over `S` | `Scheme.IsRationalOver sX`, birational over `S` to some `𝔸(n; S)` | **R** |
| R14 | Unirational over `S` | `BConicBundleMultisections.IsUnirationalOver sX` | **P**; the existential wrapper `∃ n : ℕ, HasUnirationalParametrization n sX`. |
| R15 | Affine space | `AlgebraicGeometry.AffineSpace n S`, notation `𝔸(n; S)` | **R** |
| R16 | Rational maps from function-field maps | `RationalMap.ofFunctionField`, `fromFunctionField`, `equivFunctionField`, `equivFunctionFieldOver` | **R** |
| R17 | Birationality via function fields | use `PartialIso`/`Birational` and the above equivalences; prove project-specific field isomorphisms | **R/W** |
| R18 | Relative normalization | for qcqs `f : X ⟶ Y`, `f.normalization`, `f.toNormalization`, `f.fromNormalization` and universal factorization | **R** |
| R19 | Normalization of an integral surface | specialize the relative normalization API and prove the expected absolute/function-field properties | **R/W**; not a single prepackaged `X.normalization`. |
| R20 | Image of a rational map | restrict a representative to its domain and use `Scheme.Hom.image`/kernel ideal | **R/W**; prove independence from representative on the relevant integral component. |
| R21 | Generically finite rational map | no high-level predicate/degree API found | **M** |
| R22 | Degree of a finite flat morphism | `Scheme.Hom.finrank f y` in `Morphisms.FlatRank` | **R**, but it is not automatically the degree of a generically finite rational map. |
| R23 | Residue-field degree | `Scheme.Hom.residueDegree f x` | **R**, pointwise only. |
| R24 | Degree `2a` of the multisection | define generic field-extension degree or restrict to a finite-flat dense open, then relate to intersection number | **M** |

The local API deliberately separates data from properties.  An
`UnirationalParametrization n sX` contains the complete rational map from relative affine
`n`-space, its dominance proof, and its over-base equation;
`HasUnirationalParametrization n sX` is the fixed-dimensional existence proposition; and
`IsUnirationalOver sX` forgets the finite dimension existentially.  A total dominant morphism
`𝔸ⁿ_S ⟶ X` is promoted by `UnirationalParametrization.ofHom`, while rational maps remain the core
notion because the tangent-residual construction has an indeterminacy locus.  Mathlib's
`IsRationalOver` permits an arbitrary coordinate type; that is appropriate for its general API
but is too weak as the public definition of finite-type geometric unirationality.

Additional bridges to build early:

| ID | Bridge | Exact starting point | Status |
|---|---|---|---|
| R25 | Rational section of `p : X ⟶ B` | `∃ σ : B ⤏ X, σ.compHom p = RationalMap.id B`; this is `σ.IsOver B` after installing `X.Over B` | **W** |
| R26 | Tautological section after base change | `pullback.lift r (𝟙 T)`, `pullback.lift_snd`, from `r ≫ p = q` | **R/W** |
| R27 | Scheme-theoretic dominance | `IsSchemeTheoreticallyDominant`; `of_isDominant` for reduced target and flat pullback lemmas | **R**; use when topological dominance must survive flat base change. |
| R28 | Field map induced by dominant rational map | desired `f.functionFieldMap : Y.functionField ⟶ X.functionField` | **M**, highest-value generic-degree bridge. |
| R29 | Finite extension degree | `Module.Finite K L`, `Module.finrank K L` once R28 exists | **R/W** |
| R30 | Projective versus affine source for unirationality | prove `ℙ³` birational to `𝔸³` using a dense standard chart | **M** until the local projective-space chart wrapper is complete. |
| R31 | `K`-rational point of a scheme | `Scheme.SpecToEquivOfField K X : (Spec (.of K) ⟶ X) ≃ Σ x, X.residueField x ⟶ .of K` | **R** |
| R32 | Generic residue field versus function field | construct the canonical `CommRingCat` isomorphism `Y.residueField (genericPoint Y) ≅ Y.functionField` for integral `Y`, or define every generic fiber directly over `Spec Y.functionField` | **M/W**; Mathlib defines the function field as the generic stalk but does not package this residue-field identification. |
| R33 | Birational map is dominant | prove `PartialIso.toRationalMap` has `RationalMap.IsDominant` from its dense target open (and package the over-base version) | **W**; needed before feeding a rational parametrization into `RationalMap.comp`. |
| R34 | Chosen fixed-dimensional parametrization | `UnirationalParametrization n sX`, with fields `map`, `isDominant`, and `isOver` | **P**; this is the whole map-and-proofs object constructed by the final argument. |
| R35 | Fixed-dimensional existence | `HasUnirationalParametrization n sX := Nonempty (UnirationalParametrization n sX)` | **P**; an opaque project definition, unlike R14 it retains the exact source dimension. |
| R36 | Total affine-space parametrization | `UnirationalParametrization.ofHom (f : 𝔸(ULift (Fin n); S) ⟶ X) hf` under `[IsDominant f]` and `hf : f ≫ sX = 𝔸(ULift (Fin n); S) ↘ S` | **P/R**; converts a whole morphism to the rational-map data without losing its dominance or base equation. |

## 5. Generic plane cubic and tangent residuals

Relevant exact reuse comes from
[elliptic Weierstrass curves](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/EllipticCurve/Weierstrass.lean),
[affine point formulas](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/EllipticCurve/Affine/Point.lean),
[affine line formulas](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/EllipticCurve/Affine/Formula.lean),
[projective elliptic points](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/EllipticCurve/Projective/Point.lean),
[projective formulas](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/EllipticCurve/Projective/Formula.lean), and
[division polynomials](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/EllipticCurve/DivisionPolynomial/Degree.lean).

| ID | Proof concept | Precise reuse or required formal statement | Status |
|---|---|---|---|
| C01 | `K = k(ℙ²_x)` | `P2.functionField` after integrality; prove an isomorphism with a two-variable rational function field | **R/M** |
| C02 | Generic cubic `C = X_K` | base change `ρ` along `Spec K ⟶ P2`; alternatively `ρ.fiber (genericPoint P2)` | **R/W** |
| C03 | It is a plane cubic | base-change compatibility of G25 and the `(0,3)` specialized equation | **M** |
| C04 | Generic cubic is smooth | prove the required generic-smoothness theorem for `ρ`, then identify the generic fiber | **M**; the ground-field smooth-locus lemmas alone are not this statement. |
| C05 | No whole `ℙ²_y` fiber | coordinate lemma: two independent `x`-derivative cubics have a common projective zero over an algebraically closed field, producing a singular point | **M** |
| C06 | Generic embedded cubic is nonconstant | coefficient comparison: `F = Q(x) f₀(y)` would be reducible and singular | **M**, polynomial/UFD ingredients reusable. |
| C07 | General smooth plane cubic object | bundle homogeneous cubic, nonzero discriminant/smoothness, and its closed subscheme | **M** |
| C08 | Flex and Weierstrass presentation after geometric base change | over an algebraic closure `K̄`, choose a flex and convert the embedded smooth cubic to `WeierstrassCurve` with `WeierstrassCurve.IsElliptic` | **R/M**; the generic cubic need not have a `K`-rational flex, so this is not directly a model over `K`. |
| C09 | Group law on geometric points | `WeierstrassCurve.Projective.Point` has an `AddCommGroup` instance after C08 and a chosen origin over `K̄` | **R**; any result used over `K` must pass through C29. |
| C10 | Coordinate tangent line | `MvPolynomial.pderiv`; define `∑ i, C (eval p (pderiv i f)) * X i`; use Euler identity for incidence/scaling | **R/W** |
| C11 | Third tangent intersection | Weierstrass `Affine.linePolynomial`, `addPolynomial_slope`, and `Affine.Point.add_self_of_Y_ne'` cover the main affine formula | **R/M**; extend uniformly to vertical tangents/infinity and arbitrary plane cubics. |
| C12 | Tangent residual is `-2p` | short group calculation after C11 | **R/W** |
| C13 | Scheme morphism `g = [-2] : C ⟶ C` | point formulas/division polynomials exist, but not this scheme morphism | **M** |
| C14 | `g` finite étale of degree `4` | `WeierstrassCurve.Φ`, `Ψ`, `natDegree_Φ`; no scheme-theoretic degree theorem | **M** |
| C15 | Two-torsion | `WeierstrassCurve.twoTorsionPolynomial` and discriminant theorem | **R/M**; prove geometric four-point/nonzero-three-point statements. |
| C16 | Three points of a line section sum to zero | chord-and-tangent group law, including multiplicities | **M** |
| C17 | Residual points are collinear | combine C12 and C16: `-2p + -2q + -2r = 0` | **W/M** |
| C18 | Dual plane | point-level `ℙ K (Module.Dual K (Fin 3 → K))`; scheme-level dual `P2` is another local `Proj` wrapper | **R/W** |
| C19 | Full residual-line map `δ_C : (ℙ²)∨ ⟶ (ℙ²)∨` | construct from symmetric line sections and C17, including nonreduced sections | **M** |
| C20 | Degree-four Lattès morphism | prove coordinate homogeneity/no base points or descend `[-2]²` through the quotient | **M** |
| C21 | `C²/S₃` model for the line-section plane | finite group actions/quotients exist abstractly, but no adequate algebraic-geometry scheme quotient here | **M** |
| C22 | Ramification reflection curves of the quotient | no packaged scheme ramification-divisor API | **M** |
| C23 | `π ∘ [-2]² = δ_C ∘ π` | theorem after C19–C21 | **M** |
| C24 | Ramification formula `π*R_δ = μ*R_π - R_π` | no scheme ramification divisor/formula | **M** |
| C25 | Critical-value curve of `δ_C` is `C∨` | ring-theoretic `unramifiedLocus`/`etaleLocus` are only local substrate | **M** |
| C26 | Dual sextic of a smooth cubic | no dual-variety/Gauss-map/degree theorem | **M** |
| C27 | Projective biduality `(C∨)∨ = C` | `Module.evalEquiv` gives vector-space biduality only, not variety biduality | **M** |
| C28 | `δ_C` determines the embedded cubic | C25 plus C27 | **M** |
| C29 | Origin-free genus-one bridge and descent | either construct tangent residuals, symmetric-cube/Lattès data, and critical values intrinsically over `K`, or prove the constructions over `K̄` are independent of the chosen flex and descend Galois-equivariantly to `K` | **M**; a silent choice of a `K`-rational flex would invalidate the proof. |

The existing Weierstrass code is valuable and must be reused: it avoids reproving the coordinate
group law and much of the tangent calculation after geometric base change.  It does **not**
justify treating arbitrary plane cubics as Weierstrass curves over `K`, choosing a rational flex,
or treating point formulas as a descended scheme morphism without C29.

## 6. Constant-values descent and choice of a good line

Exact algebraic substrates are
`Derivation k A M` from
[derivations](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/RingTheory/Derivation/Basic.lean),
polynomial derivations from
[multivariable derivations](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/Algebra/MvPolynomial/Derivation.lean),
and rational-function infrastructure from
[fraction rings](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/RingTheory/Localization/FractionRing.lean) and the
[multivariable rational-function rank theorem](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/FieldTheory/MvRatFunc/Rank.lean).

| ID | Proof concept | Precise reuse or required formal statement | Status |
|---|---|---|---|
| D01 | Purely transcendental field `k(s,t)` | `FractionRing (MvPolynomial (Fin 2) k)`; identify it with `P2.functionField` | **R/M**; `MvRatFunc` is only a theorem namespace in this revision, not a bundled type. |
| D02 | The two coordinate derivations | `Derivation` and `MvPolynomial` derivations; extend uniquely to the fraction field | **R/W** |
| D03 | Common constants of those derivations | theorem: constants in `k(s,t)(z₁,…,zₙ)` equal `k(z₁,…,zₙ)` | **M** |
| D04 | Rational function vanishing on dense constants | polynomial clearing-denominators plus Zariski-density over infinite `k` | **M** |
| D05 | Constant-values descent lemma | if `φ : ℙⁿ_K ⟶ ℙᵐ_K` maps a Zariski-dense set of `k`-points to `k`-points, descend `φ` to `k` | **M** |
| D06 | Descended coordinate forms have no common zero | faithful base change/descent of the base-point-free condition | **M** |
| D07 | `δ_C` is not defined over `k` | after the descent/choice-independence theorem C29, otherwise C25–C28 make `C` constant, contradicting C06 | **M** |
| D08 | Constant lines with constant image lie in a proper closed subset | apply D05 contrapositive and construct the closure | **M** |
| D09 | Constant point avoids a proper `K`-closed locus | expand finitely many `K`-coefficients in a `k`-linearly independent family; use `Infinite k` | **M** |
| D10 | Reduced line section | avoid the dual curve; express as a nonempty open condition | **M** |
| D11 | `[-2]` injective on the three section points | avoid the Galois-invariant union of chord curves indexed by the three nonzero geometric two-torsion points | **M** |
| D12 | Smooth integral generic conic for `S_L` | first rule out a whole `ℙ²_x` fiber using the two `y`-derivative quadrics, then avoid the conic discriminant and prove no vertical surface component | **M** |
| D13 | Simultaneous good constant line `L` | intersection of the finitely many nonempty opens and complement from D08–D12 | **M** |

## 7. Rationality of the vertical surface `S_L`

Mathlib has exact quadratic-form algebra in
[quadratic forms](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/LinearAlgebra/QuadraticForm/Basic.lean) and
[algebraically closed forms](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/LinearAlgebra/QuadraticForm/AlgClosed.lean), with
[`QuadraticMap.Nondegenerate`](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/LinearAlgebra/QuadraticForm/Radical.lean), but no high-level conic geometry.

| ID | Proof concept | Precise reuse or required formal statement | Status |
|---|---|---|---|
| S01 | Constant line `L ⊂ ℙ²_y` | nonzero dual vector, its projective kernel, and scheme closed immersion `P1 ⟶ P2` | **R/M** |
| S02 | `S_L = X ×_{ℙ²_y} L` | `pullback π lineInclusion`; identify it with the scheme intersection | **R/W** |
| S03 | Projection `S_L ⟶ L` | `pullback.snd` | **R** |
| S04 | Generic fiber is a smooth plane conic | G25, base change, and the good-line condition D12 | **M** |
| S05 | Quadratic-form representation | `QuadraticForm k (Fin 3 → k)`, `Matrix.toQuadraticForm'`, `QuadraticMap.Nondegenerate` | **R/W** |
| S06 | `C₁` field predicate | no declaration found | **M** |
| S07 | Tsen theorem | `k` algebraically closed ⇒ `k(t)` is `C₁` | **M** |
| S08 | Smooth conic over `k(t)` has a point | apply S07 to the ternary quadratic | **M** |
| S09 | Pointed smooth conic is rational | projection from the point; birational to `ℙ¹` | **M** |
| S10 | Function field of `S_L` | prove `k(S_L) ≃ k(t)(z)` from S08–S09 | **M** |
| S11 | `S_L` rational surface | `BirationalOver (S_L ↘ Spec k) (𝔸(ULift (Fin 2); Spec k) ↘ Spec k)` | **R/M** |

There is no `Conic`, `ConicBundle`, `C1Field`, Tsen theorem, or “conic with a point is rational”
declaration in the pinned checkout.  These are substantive formalization packages, not naming
gaps.

## 8. The residual image and birationality

The reusable image and rational-map layers are
[scheme-theoretic images](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/IdealSheaf/Subscheme.lean),
[rational maps](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Birational/RationalMap.lean), and
[birationality](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Birational/Birational.lean).

| ID | Proof concept | Precise reuse or required formal statement | Status |
|---|---|---|---|
| T01 | Fiberwise tangent-residual rational map `τ_L : S_L ⤏ X` | assemble C10–C13 over the smooth generic locus and use `PartialMap.toRationalMap` | **R/M** |
| T02 | Scheme-theoretic image `T_L` | restrict the representative and use `Scheme.Hom.image`/kernel ideal | **R/W** |
| T03 | Irreducibility of `T_L` | image of integral dense domain, with the image/reduction bridge proved | **M** |
| T04 | Generic fiber contains three residual points | C19 specialized at `L` | **M** |
| T05 | Generic injectivity | good-line condition D11 | **M** |
| T06 | `S_L ⤏ T_L` birational | upgrade generic three-point bijection/field isomorphism to `PartialIso` | **M** |
| T07 | `T_L` has rational normalization | preferably transport rationality through T06; avoid normalization machinery unless needed | **R/M** |
| T08 | `T_L ⟶ ℙ²_x` has generic degree `3` | build R21/R28 and compute the three-point generic fiber | **M** |

## 9. Divisor classes, horizontality, and degree

Existing but insufficient pieces are
[algebraic cycles](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/AlgebraicCycle/Basic.lean),
[orders of vanishing](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/OrderOfVanishing.lean), and affine
[Picard groups](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/RingTheory/PicardGroup.lean).

| ID | Proof concept | Precise reuse or required formal statement | Status |
|---|---|---|---|
| V01 | Codimension-one prime cycle | `AlgebraicGeometry.AlgebraicCycle X ℤ`, `Scheme.ord` | **R/W** |
| V02 | Cartier/Weil divisor and linear equivalence | no scheme-level API found | **M** |
| V03 | Line bundle `O_X(a,b)` | locally free sheaf substrate exists; no scheme line-bundle tensor/Picard package | **M** |
| V04 | Hyperplane classes `H_x,H_y` | pullbacks of coordinate hyperplane ideal sheaves/cycles | **M** |
| V05 | `Pic(X) ≅ ℤ H_x ⊕ ℤ H_y` | Grothendieck–Lefschetz for the smooth ample divisor | **M** |
| V06 | Every surface is a divisor | noetherian integral regular threefold codimension-one argument | **M** |
| V07 | Class decomposition `[T_L] = aH_x+bH_y` | V02–V05 | **M** |
| V08 | Intersection product | no Chow ring/intersection product/projective Bézout API found | **M** |
| V09 | Fiber intersections `H_x·c_y=2`, `H_y·c_y=0` | explicit polynomial/fiber calculation or V08 | **M** |
| V10 | Cubic-fiber intersections `H_x·c_x=0`, `H_y·c_x=3` | explicit polynomial/fiber calculation or V08 | **M** |
| V11 | Image cannot be a point in `ℙ²_y` | dimension/fiber theorem | **M** |
| V12 | If image is a curve then `a=0,b=1` | V07 plus V09–V10 and degree `3` | **M** |
| V13 | Restriction of sections of `O(0,1)` | restriction sequence and `H¹(ℙ²×ℙ²,O(-2,-2))=0` | **M**; sheaf cohomology/Künneth computation is not turnkey here. |
| V14 | A class-`H_y` prime is inverse image of a constant line | V03, V13, divisor of a section | **M** |
| V15 | Horizontality of `T_L` | V12–V14 contradict nonconstant `δ_C(L)` from D13 | **M** |
| V16 | Effective-cone nonnegativity | effective prime class `aH_x+bH_y` has `a,b ≥ 0`, via general fibers | **M** |
| V17 | Multisection degree `2a` | V09 plus generic finite-degree bridge R21/R24 | **M** |

Mathlib's `CommRing.Pic` is the Picard group of invertible modules over one commutative ring; it
is not `Pic(X)` for a nonaffine scheme.  Likewise `AlgebraicCycle.map` is not an intersection
product.  These must not be cited as if they supplied the missing divisor calculation.

## 10. Universal resultant and the bound `a ≤ 10`

Exact reusable algebra is in
[polynomial homogenization](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/Algebra/Polynomial/Homogenize.lean),
[resultants](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/RingTheory/Polynomial/Resultant/Basic.lean), and
[cubic discriminants](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/Algebra/CubicDiscriminant.lean).

| ID | Proof concept | Precise reuse or required formal statement | Status |
|---|---|---|---|
| Q01 | Binary forms | `MvPolynomial (Fin 2) R` plus `IsHomogeneous d` | **W**; Mathlib has no bundled `BinaryForm`. |
| Q02 | Homogenize/dehomogenize | `Polynomial.homogenize`, `homogenize_eq_of_isHomogeneous`, evaluation lemmas | **R/W** |
| Q03 | Fixed-degree binary resultant | dehomogenize and use the explicit-degree `Polynomial.resultant`/Sylvester determinant | **R/W**; fixed degrees avoid specialization bugs. |
| Q04 | Resultant identities | `resultant_map_map`, `resultant_add_mul_left/right`, `resultant_mul_left/right`, `resultant_eq_zero_iff` | **R** |
| Q05 | Cubic discriminant | `Cubic.discr`, `Cubic.discr_ne_zero_iff_roots_ne`, or `Polynomial.discr` | **R** |
| Q06 | Universal cubic split by `L={W=0}` | `f = g(U,V)+W h(U,V)+W²(iU+jV)+kW³` in a universal coefficient ring | **W** |
| Q07 | Tangent polynomial `P_{U,V,W}(u,v)` | `pderiv`, evaluation, and C10 | **R/W** |
| Q08 | Core identity | `Res(g,P) + Δ(g) f = W² q_f` | **M**; formalize the universal coefficient-ring determinant identity. |
| Q09 | `q_f` linear in `U,V,W` | coefficient/support computation from Q08 | **M** |
| Q10 | Coefficients of `q_f` have coefficient-degree `5` | multigraded homogeneity of the fixed `5×5` Sylvester determinant | **M** |
| Q11 | Substitution into `F(x,-)` | `MvPolynomial.eval₂`/`bind₁`; cubic coefficients are quadratic in `x` by G03/G06 | **R/W** |
| Q12 | Residual coefficients have `x`-degree `10` | Q10 plus Q11 and weighted-homogeneous composition | **M** |
| Q13 | Factor `W²` is exactly doubled original section | restrict Q08 to `X`, prove scheme/cycle multiplicity two | **M** |
| Q14 | Common factor `h = gcd(q_U,q_V,q_W)` | multivariate polynomial gcd/UFD associates and homogeneous divisibility | **R/M** |
| Q15 | Primitive residual equation has class `(10-e,1)` | direct bihomogeneous bookkeeping, ideally avoiding a general divisor package | **M** |
| Q16 | Unique component dominating `ℙ²_x` | compare its generic fiber to the three residual points | **M** |
| Q17 | Other effective components have nonnegative bidegrees | V16 or a direct chart/fiber degree theorem | **M** |
| Q18 | `1 ≤ a ≤ 10-e ≤ 10` | horizontality V15 plus Q15–Q17 | **M** |
| Q19 | General coefficients are coprime | exhibit one specialization/nonvanishing resultant, then openness in parameter space | **M** |
| Q20 | General member has `a=10`, degree `20` | Q19 and V17 | **M**, separate from all-smooth theorem. |

`Resultant/Basic.lean` itself lists binary-form resultants as unfinished work.  The local wrapper
should therefore be small and fixed-degree, while the universal identity remains project-specific
mathematics checked first over `ℤ` in the universal coefficient ring.

## 11. Multisection principle and final dominant map

Exact reusable substrates are
[pullbacks](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Pullbacks.lean),
[function fields](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/FunctionField.lean),
[rational-map composition](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Birational/Composition.lean), and
[finite-flat rank](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Morphisms/FlatRank.lean).

| ID | Proof concept | Precise reuse or required formal statement | Status |
|---|---|---|---|
| U01 | Rational horizontal multisection | integral surface `T ⟶ X` with dominant generically finite composite `T ⟶ ℙ²_y`, plus `IsRationalOver (T ↘ Spec k)` | **W/M** |
| U02 | Rational normalization/source | use the birational source `S_L` from T06 when possible; otherwise R18–R19 | **R/M** |
| U03 | Base-changed conic bundle | `pullback π (T ⟶ ℙ²_y)` | **R** |
| U04 | Tautological point/section | diagonal lift `pullback.lift (T ⟶ X) (𝟙 T)` and `pullback.lift_snd` | **R/W** |
| U05 | Generic conic now has a rational point | pass U04 to `Spec T.functionField` using `equivFunctionFieldOver` | **R/W** |
| U06 | Pointed conic bundle is birational to `T × ℙ¹` | fiberwise projection from the section, on a dense open | **M** |
| U07 | Product of rational `T` with `ℙ¹` is rational | construct dense affine charts and compose `BirationalOver` | **M** |
| U08 | Rational threefold source | identify with `𝔸³` (or first `ℙ³`) over `k` | **M** |
| U09 | Projection back to `X` is dominant | use G29 and `IsSchemeTheoreticallyDominant.pullbackSnd` (which requires flat base change and quasi-compactness), or give a separate generic-point proof | **R/M**; the bare pullback square does not preserve dominance automatically. |
| U10 | Degree is multisection degree `2a` | finite-flat shrinking and `finrank_pullback_*`, or function-field `Module.finrank` | **R/M** |
| U11 | Compose parametrization with projection | `RationalMap.comp` and its dominance instance | **R** |
| U12 | Main conclusion | construct `HasUnirationalParametrization 3 (X ↘ Spec k)`, then apply `.isUnirationalOver` | **P/R/M**; the data/property API exists, while the parametrization proof awaits preceding packages. |
| U13 | Converse multisection criterion | image of a general plane under `ℙ³ ⤏ X` | **M**, useful but not needed for the forward theorem. |

## 12. Ordered work packages and dependency graph

The proof is not one monolith.  The following packages give independent, reviewable acceptance
boundaries and maximize upstream reuse.

| WP | Deliverable | Depends on | Completion test |
|---|---|---|---|
| WP0 | Project/tooling and vocabulary | — | warning-free `lake build`; no `sorry`/`axiom`; exact pin and Loogle audit recorded. |
| WP1 | Local scheme `P2`, standard charts, `P2×P2` | G11–G17 | nine product charts identified with four-variable affine polynomial rings. |
| WP2 | Biprojective zero locus `X_F` and projections | WP1, G18–G29 | chartwise zero locus, dimension, integrality, projection dominance, and conic-projection flatness. |
| WP3 | Rational-map/function-field bridges | R05–R36 | induced function-field map, generic-model comparison, generic finite degree, dominance of birational maps, and the fixed-dimensional parametrization wrapper. |
| WP4 | Fixed-degree binary resultant | Q01–Q05 | specialization-safe binary resultant and root criterion. |
| WP5 | Universal residual identity | WP4, C10 | Q08–Q12 over the universal coefficient ring. |
| WP6 | Plane cubic tangent residual | WP2, Weierstrass API | C07–C20 and C29: origin-free/descent bridge, `[-2]`, collinearity, global `δ_C`. |
| WP7 | Lattès critical values and biduality | WP6 | C21–C29, entirely algebraic over characteristic zero. |
| WP8 | Constant-values descent/good line | WP1, WP7 | D01–D13. |
| WP9 | Tsen and conic rationality | WP1, WP3 | S06–S11 and pointed-conic-bundle theorem U06. |
| WP10 | Residual image/birationality | WP2, WP6, WP8 | T01–T08. |
| WP11 | Divisor/class/horizontality package | WP2, WP5, WP10 | V01–V17 and Q13–Q18. Prefer explicit bidegree bookkeeping where it avoids a general Chow theory. |
| WP12 | Multisection principle and final theorem | WP3, WP9, WP11 | U01–U12; all-smooth degree bound `≤20`. |
| WP13 | Generic degree-20 refinement | WP5, WP11 | Q19–Q20 under a precisely formalized dense-open/general hypothesis. |

Current implementation boundary (2026-07-23): WP0 and WP1 pass their completion tests. WP2 has
the canonical chartwise/global zero locus, proper projections, explicit residue-field
base-changed fibers and whole-fiber criteria, nonzero affine chart equations, the exact
homogeneous-to-affine Jacobian comparison, the Nullstellensatz/Krull-height common-zero theorem,
the polynomial whole-fiber-to-zero-gradient implication, conditional chart quotient dimensions,
and smoothness restriction to affine charts. Global relative dimension, integrality, the final
scheme-theoretic smoothness contradiction excluding whole fibers, projection
surjectivity/dominance, and conic-projection flatness remain open and are not assumed through
wrapper fields.

```text
WP1 projective model ──> WP2 hypersurface ───────────────┐
       │                    │                            │
       │                    ├─> WP6 cubic ─> WP7 Lattès ─> WP8 good line ─┐
       │                    │                         │                    │
       ├─> WP9 Tsen/conics ─┤                         └─> WP10 image ─────┤
       │                    │                                              │
WP3 rational maps/degrees ─┴──────────────────────────────────────────────┤
WP4 binary resultant ─> WP5 identity ───────────────> WP11 classes ──────┤
                                                                            v
                                                                     WP12 theorem
```

This order permits WP4, WP7, and WP9 to be developed and reviewed independently.  It also makes
the precise blockers visible: the final theorem cannot close merely by finishing the resultant
calculation; both the all-smooth Lattès step and the conic-rationality step are load-bearing.

## 13. Negative API ledger at the pinned revision

Exact source and declaration-shape searches found no suitable high-level declaration for:

- scheme `ProjectiveSpace`, `MultiProj`, bihomogeneous `Hypersurface`, or a line-bundle section
  zero-locus constructor;
- scheme line bundles/Picard group, Cartier or Weil divisors, divisor linear equivalence,
  intersection products, rational equivalence, Chow groups/rings, or projective Bézout;
- general plane cubic/conic scheme objects, tangent hyperplanes, Gauss maps, dual varieties,
  dual curves, or projective biduality;
- algebraic-geometry ramification/branch/critical-value divisors and the ramification formula;
- scheme multiplication-by-`n` on an elliptic curve, its degree, or the geometric cardinality of
  two-torsion;
- `C₁`/quasi-algebraically-closed fields, Tsen, pointed-conic rationality, or conic-bundle
  rationality;
- scheme unirationality, generic finiteness/degree of a rational map, induced maps on function
  fields, absolute scheme normalization/`IsNormal`, or product/base-change theorems for rational
  schemes.

These negatives route work; they are not invitations to duplicate Mathlib's lower-level
polynomial, scheme, Proj, rational-map, smoothness, and Weierstrass infrastructure.

## 14. Exact distinctions that the formalization must preserve

1. **All smooth vs. general.** `1 ≤ a ≤ 10` is the all-smooth theorem; `a=10` is only the
   general-coefficient refinement.
2. **Algebraically closed characteristic zero vs. complex numbers.** The theorem source states
   the former.  `ℂ` is a corollary, not the main signature.
3. **Bihomogeneous equation vs. hypersurface scheme.** `IsBidegree23 F` alone does not construct
   `X_F`; WP2 is mandatory.
4. **Point projectivization vs. scheme Proj.** Incidence calculations on `ℙ k V` do not directly
   prove scheme smoothness, dominance, or birationality.
5. **Smooth vs. smooth of relative dimension three.** The latter contains additional dimension
   data and is not currently inferred automatically for this zero locus.
6. **Rational vs. fixed-dimensional vs. existential unirationality.** `IsRationalOver` is
   birationality; `HasUnirationalParametrization n` records existence of a dominant rational map
   from a specified `𝔸ⁿ`; `IsUnirationalOver` existentially forgets `n`.
7. **Rational image vs. rational normalization.** A birational source proves the normalization's
   function field is rational; it does not make a singular image scheme isomorphic to affine
   space.
8. **Dominant vs. surjective.** A rational map is defined only on a dense open; use
   `RationalMap.IsDominant`, not a total-map surjectivity claim.
9. **Finite-flat rank vs. generic rational-map degree.** `Scheme.Hom.finrank` applies after a
   finite-flat model is constructed; R21/R28 must prove independence and connect it to `2a`.
10. **Polynomial degree identity vs. divisor equality.** Q08–Q12 do not by themselves prove
    cycle multiplicities, component uniqueness, or `[T_L]=aH_x+H_y`.
11. **Vector-space duality vs. projective biduality.** `Module.evalEquiv` is not `(C∨)∨=C`.
12. **Point group law vs. scheme Lattès morphism.** an `AddCommGroup` on Weierstrass points is not
    the finite morphism `[-2]` or its ramification theory.
13. **Numerical/computational certificate vs. formal proof.** the existing Python/SymPy checks
    guide WP5 but do not enter the trusted Lean theorem.
14. **Unirational vs. rational/stably rational.** the target theorem says nothing positive about
    ordinary or stable rationality.
15. **Smooth/reduced vs. integral.** smoothness does not by itself prove that `X_F` is nonempty or
    connected; G27 must install the integral hypotheses used by generic points and function fields.
16. **Geometric Weierstrass model vs. a model over `K`.** a flex chosen over `K̄` does not supply a
    `K`-rational origin.  Only the intrinsic/descent bridge C29 permits the Weierstrass results to
    feed the `K`-defined residual map.
17. **Fiber at the generic point vs. pullback to the function field.** these are related only after
    R32; they are not definitionally the same scheme.
18. **Dominance vs. dominance after pullback.** the scheme-theoretic pullback lemmas used here need
    flatness and quasi-compactness; G29 is load-bearing, not implicit in the phrase “conic bundle.”

## 15. Reproducible Loogle audit

Loogle source commit `e668239956d4d85547e1f6393fbf923a2d47ade7` was rebuilt with
`leanprover/lean4:v4.32.1`.  The generated 357 MiB index lives at the ignored path
`.lake/mathlib-v4.32.1.loogle-index` and was built from this project's complete `lake env` search
path, including the pinned Mathlib `.olean` tree.  The reproducible command shape is:

```sh
lake env /Users/worker/lean/loogle/.lake/build/bin/loogle \
  --module Mathlib \
  --index-file .lake/mathlib-v4.32.1.loogle-index \
  --index-mode read --json --max-results 10 \
  'AlgebraicGeometry.Scheme.IsRationalOver'
```

Use `--index-mode write` in the same command to force a rebuild after changing the Mathlib pin;
`read` intentionally refuses a missing or stale index.

Exact positive queries returned the following primary declarations and also exposed their real
hypotheses:

| Query | Pinned declaration | Loogle result relevant here |
|---|---|---|
| `AlgebraicGeometry.Scheme.IsRationalOver` | [`Scheme.IsRationalOver`](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Birational/Birational.lean#L231) | 7 mentions; primary type `{S X : Scheme} (sX : X ⟶ S) : Prop`. |
| `AlgebraicGeometry.Scheme.RationalMap.IsDominant` | [`RationalMap.IsDominant`](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Birational/Dominant.lean#L73) | 14 mentions; [`RationalMap.comp`](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Birational/Composition.lean#L151) shows the `PreirreducibleSpace`, `Nonempty`, and dominance hypotheses recorded in R11. |
| `MvPolynomial.IsWeightedHomogeneous` | [`MvPolynomial.IsWeightedHomogeneous`](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/RingTheory/MvPolynomial/WeightedHomogeneous.lean#L128) | 26 mentions; exact type `(w : σ → M) (φ : MvPolynomial σ R) (m : M) : Prop`. |
| `"toPartialMap"` | [`RationalMap.toPartialMap`](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Birational/RationalMap.lean#L590) | 16 name hits; canonical rational-map conversion requires `[IsReduced X] [Y.IsSeparated]`. |
| `"Scheme.Hom.normalization"` | [`Scheme.Hom.normalization`](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Normalization.lean#L127) | 17 name hits; it is relative normalization and requires `QuasiCompact` and `QuasiSeparated`. |
| `AlgebraicGeometry.Scheme.Hom.finrank` | [`Scheme.Hom.finrank`](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Morphisms/FlatRank.lean#L89) | 12 mentions; pointwise rank `(f : X ⟶ S) (s : S) : ℕ`, not generic rational-map degree. |
| `"Projectivization.IsCollinear"` | [`Projectivization.IsCollinear`](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/LinearAlgebra/Projectivization/Collinear.lean#L42) | 9 name hits; confirms the point-level API and its separation from scheme `Proj`. |
| `"PartialIso.toRationalMap"` | [`PartialIso.toRationalMap`](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Birational/Birational.lean#L165) | One declaration, only the underlying rational map; no accompanying dominance result, hence R33. |
| `AlgebraicGeometry.IsSchemeTheoreticallyDominant.pullbackSnd` | [`IsSchemeTheoreticallyDominant.pullbackSnd`](https://github.com/leanprover-community/mathlib4/blob/520045ab14e26149ee970e2e617ca04b09bde5d6/Mathlib/AlgebraicGeometry/Morphisms/SchemeTheoreticallyDominant.lean#L94) | Exact hypotheses include scheme-theoretic dominance and quasi-compactness of `f`, and flatness of `g`; this is G29/U09. |

Exact negative name queries gave zero hits for `IsUnirational`, `CartierDivisor`,
`AlgebraicGeometry.ProjectiveSpace`, `MultiProj`, `dualCurve`, `C1Field`, and `ConicBundle`.
The exact identifier query `AlgebraicGeometry.Tsen` was unknown.  A broad quoted `"Tsen"` query
did return ten lexical false positives such as `getSendChan` and `equivUnitsEnd`; none is a Tsen
theorem.  These results corroborate §13 but do not replace the semantic source audit.

## 16. Acceptance checklist for the complete formalization

- [ ] The public theorem quantifies over `[Field k] [IsAlgClosed k] [CharZero k]`.
- [ ] `F ≠ 0` and exact weighted bidegree `(2,3)` are explicit.
- [ ] `X_F` is constructed from `F` and proved to be the intended closed subscheme.
- [ ] Smoothness is a hypothesis on the constructed structure morphism; relative dimension `3`
      is proved.
- [ ] `X_F` is nonempty and integral; both projections are dominant, and `π` has the flatness and
      quasi-compactness used by the base-change argument.
- [ ] Both projections and both generic fibers are constructed by pullback; R32 identifies any
      generic-point and function-field models that are interchanged.
- [ ] The plane-cubic argument does not assume a `K`-rational flex; C29 proves intrinsic
      construction or geometric choice-independence and descent.
- [ ] The all-smooth argument proves existence of a good **constant** line.
- [ ] Tsen and pointed-conic rationality are formal theorems, not assumptions.
- [ ] The residual map, its image, birationality, horizontality, and `1≤a≤10` are proved at scheme
      or function-field level.
- [ ] The final dominant rational map is explicitly composed using Mathlib's rational-map API
      and packaged as `HasUnirationalParametrization 3`; the `IsUnirationalOver` theorem is the
      dimension-forgetting corollary.
- [ ] Its optional degree theorem is connected to a proved generic degree notion.
- [ ] The general `a=10` theorem has an explicit dense-open/general hypothesis.
- [ ] No `axiom`, `sorry`, `admit`, placeholder declaration, or unchecked external CAS result is
      used in the trusted chain.
- [ ] `lake build` and project linting pass at the pinned revision.
- [ ] The Loogle index is regenerated when the Mathlib pin changes, and positive/negative API
      claims are re-audited rather than copied forward.
