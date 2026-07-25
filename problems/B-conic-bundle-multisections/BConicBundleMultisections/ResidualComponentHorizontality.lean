/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveSpaceAlgebraPoint
public import BConicBundleMultisections.ProjectiveSpaceChartDominance
public import BConicBundleMultisections.ResidualComponent
public import BConicBundleMultisections.ResidualYFormVanishing

/-!
# Obligation 2: the residual surface is not contained in a fibre

One of the four outstanding obligations of the unirationality proof; see
`ResidualComponentAssembly.lean` for the inventory and `PLAN.md` WP-B for the work package.

Everything downstream of this obligation is proved: `isDominant_residualComponentToBase_iff`
turns it into horizontality of the residual component, and
`isDominant_residualComponentMultisection_baseChangeFst` turns that into dominance of
`baseChangeFst`, which is what the multisection principle consumes.

## State of the reduction

The obligation is now assembled from exactly two statements, both isolated below:

* `ProjectiveSpace.isDominant_standardChartι` — the standard chart is a dense open of `ℙ²_k`.
  Topology plumbing; belongs to the `ℙⁿ` chart-cover work package, not to this one.
* `eq_zero_of_aeval_residualYCoords_of_isHomogeneous` — **the content**: no nonzero form in the
  three `Y`-variables vanishes on the residual `Y`-coordinates in `k[t,s]`.

Everything between them is proved: `ChartHomogenization` turns "no nonzero form vanishes" into
injectivity of `aeval` at the affine coordinate ratios, and `ResidualYFormVanishing` transports
that across the chart normalization and the Away localization.

## A discrepancy with the source that this obligation inherits

The natural-language proof (`certificates/all_smooth_tangent_residual_theorem.md` §3–§4,
`RESOLUTION.md` lines 214–239) proves horizontality **for a chosen line `L`**: §3 produces a
constant line whose residual line `δ_C(L)` is nonconstant, and §4 concludes "…forcing
`δ_C(L) = M`, contrary to the choice of `L`.  Thus `T_L` is horizontal."  This development
hardcodes `L = {Y₂ = 0}` and quantifies over all smooth `F`, so the statement below is *not* the
one the source establishes; see `PLAN.md` WP-G, whose table currently records the nonconstancy
condition as "unnecessary — verified" on the strength of §5 line 323, which is a *restatement* of
horizontality, not a proof of it.  No hypothesis has been added here — the discrepancy is recorded,
not patched.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace ProjectiveSpace ResidualDivisor

attribute [local instance] MvPolynomial.gradedAlgebra
open _root_.MvPolynomial

/-! ### Bridging lemmas: the composite in coordinates

Both are exact algebra-valued analogues of proved statements, and both are mechanical.  They are
the last thing standing between obligation 2 and the concrete injectivity core.
-/

/--
**Bridging lemma (mechanical).**  The algebra-valued biprojective chart evaluation restricts along
the right tensor factor to the algebra-valued projective chart evaluation.

Analogue of `biprojectiveChartEval_comp_includeRight`
(`BiprojectiveZeroLocusClosedPoints.lean:327`).  That proof reduces to
`biprojectiveChartEval_tmul_mvPolynomialToStandardChart` (`:259`), which is **`private`**, so the
algebra version cannot reuse it — it needs its own induction on the polynomial, mirroring the
original.  No mathematics, but not a one-liner. -/
theorem biprojectiveChartEvalAlgebra_comp_includeRight
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S) :
    (biprojectiveChartEvalAlgebra (R := R) m n i j x y).comp
        (Algebra.TensorProduct.includeRight
          (R := R)
          (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom =
      ProjectiveSpace.standardChartEvalAlgebra (R := R) n j y := by
  have hX : ∀ r : Fin n,
      (ProjectiveSpace.standardChartRingEquivMvPolynomial n R j).symm (MvPolynomial.X r)
        = ProjectiveSpace.normalizedCoordinate n R j (j.succAbove r) := by
    intro r
    rw [AlgEquiv.symm_apply_eq]
    exact (ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove
      n R j r).symm
  have key : ∀ p : MvPolynomial (Fin n) R,
      biprojectiveChartEvalAlgebra (R := R) m n i j x y
          (1 ⊗ₜ[R] (ProjectiveSpace.standardChartRingEquivMvPolynomial n R j).symm p)
        = ProjectiveSpace.standardChartEvalAlgebra (R := R) n j y
            ((ProjectiveSpace.standardChartRingEquivMvPolynomial n R j).symm p) := by
    intro p
    induction p using MvPolynomial.induction_on with
    | C a =>
        have h1 : (ProjectiveSpace.standardChartRingEquivMvPolynomial n R j).symm
            (MvPolynomial.C a) = algebraMap R (ProjectiveSpace.StandardChartRing n R j) a := by
          rw [AlgEquiv.symm_apply_eq]; simp
        have h2 : (1 : ProjectiveSpace.StandardChartRing m R i) ⊗ₜ[R]
            algebraMap R (ProjectiveSpace.StandardChartRing n R j) a
            = algebraMap R (BiprojectiveSpace.StandardChartRing m n R i j) a :=
          AlgHom.commutes (Algebra.TensorProduct.includeRight
            (R := R) (A := ProjectiveSpace.StandardChartRing m R i)
            (B := ProjectiveSpace.StandardChartRing n R j)) a
        rw [h1, h2]
        have hL : biprojectiveChartEvalAlgebra (R := R) m n i j x y
            (algebraMap R (BiprojectiveSpace.StandardChartRing m n R i j) a)
              = algebraMap R S a :=
          DFunLike.congr_fun
            (biprojectiveChartEvalAlgebra_comp_algebraMap (R := R) m n i j x y) a
        rw [hL]
        simp [ProjectiveSpace.standardChartEvalAlgebra, MvPolynomial.algebraMap_eq]
    | add p q hp hq =>
        simp only [map_add, TensorProduct.tmul_add, hp, hq]
    | mul_X p r hp =>
        rw [map_mul, hX r]
        rw [show (1 : ProjectiveSpace.StandardChartRing m R i) ⊗ₜ[R]
            ((ProjectiveSpace.standardChartRingEquivMvPolynomial n R j).symm p *
              ProjectiveSpace.normalizedCoordinate n R j (j.succAbove r))
            = ((1 : ProjectiveSpace.StandardChartRing m R i) ⊗ₜ[R]
                (ProjectiveSpace.standardChartRingEquivMvPolynomial n R j).symm p) *
              ((1 : ProjectiveSpace.StandardChartRing m R i) ⊗ₜ[R]
                ProjectiveSpace.normalizedCoordinate n R j (j.succAbove r)) by
          rw [Algebra.TensorProduct.tmul_mul_tmul, one_mul]]
        rw [map_mul, map_mul, hp]
        congr 1
        simp [biprojectiveChartEvalAlgebra, affineChartPoint,
          ProjectiveSpace.standardChartEvalAlgebra, ProjectiveSpace.affineCoordinates]
  ext z
  have hz := key ((ProjectiveSpace.standardChartRingEquivMvPolynomial n R j) z)
  simp only [AlgEquiv.symm_apply_apply] at hz
  exact hz

/--
**Bridging lemma (mechanical).**  Going to `ℙⁿ_R` through the biprojective chart agrees with the
algebra-valued projective point of the second block of coordinates.

Analogue of `biprojectiveChartPointOfNormalized_comp_standardChartι_snd`
(`BiprojectiveZeroLocusClosedPoints.lean:346`); the original proof is four rewrites
(`standardChartι_snd`, `standardChartIsoSpec_inv_snd_assoc`, `← Spec.map_comp`, then the ring
identity above) and transcribes directly once the previous lemma is available. -/
theorem biprojectiveChartPointOfNormalizedAlgebra_comp_standardChartι_snd
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S) :
    biprojectiveChartPointOfNormalizedAlgebra (R := R) m n i j x y ≫
        standardChartι m n R i j ≫ snd m n R =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := R) n j y := by
  rw [standardChartι_snd]
  unfold biprojectiveChartPointOfNormalizedAlgebra
    ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
  rw [Category.assoc, standardChartIsoSpec_inv_snd_assoc]
  rw [← Category.assoc (Spec.map _), ← Spec.map_comp]
  have hring := biprojectiveChartEvalAlgebra_comp_includeRight (R := R) m n i j x y
  have hmor :
      CommRingCat.ofHom
            (Algebra.TensorProduct.includeRight
              (R := R)
              (A := ProjectiveSpace.StandardChartRing m R i)
              (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom ≫
          CommRingCat.ofHom (biprojectiveChartEvalAlgebra (R := R) m n i j x y) =
        CommRingCat.ofHom (ProjectiveSpace.standardChartEvalAlgebra (R := R) n j y) := by
    rw [← CommRingCat.ofHom_comp]
    exact congrArg CommRingCat.ofHom hring
  rw [congrArg Spec.map hmor]

/-- **The composite to the conic-bundle base, in coordinates.**

Algebra-valued analogue of `residualImagePointOfNormalized_toBase`
(`ResidualMultisectionDominant.lean:507`): going from an algebra-valued residual-image point down
to `ℙ²_y` is exactly the projective point of its `y`-coordinates.

This is the step that turns obligation 2 from a statement about a scheme-theoretic map into a
statement about an explicit ring homomorphism. -/
theorem residualImagePointOfNormalizedAlgebra_toBase
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (i j : Fin 3) (x y : Fin 3 → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : aeval (Sum.elim x y) F = 0)
    (hRes : aeval (Sum.elim x y) (residualEquation F) = 0) :
    residualImagePointOfNormalizedAlgebra F i j x y hxi hyj hF hRes ≫ residualImageToBase F =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := R) 2 j y := by
  unfold residualImageToBase
  rw [← Category.assoc, residualImagePointOfNormalizedAlgebra_ι]
  exact biprojectiveChartPointOfNormalizedAlgebra_comp_standardChartι_snd
    (R := R) (S := S) 2 2 i j x y

/-- The localized residual chart map, composed down to `ℙ²_y`, is the projective point of the
normalized residual `Y`-coordinates.

With this, obligation 2 is exactly a dominance statement about
`ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra` — see its docstring. -/
theorem residualImagePointOfNormalizedLoc_toBase
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    residualImagePointOfNormalizedLoc F hF v hv i j ≫ residualImageToBase F =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 2 j
        (residualYCoordsNorm F v i j) :=
  residualImagePointOfNormalizedAlgebra_toBase F i j _ _ _ _ _ _

/-! ### Reducing dominance to a ring-map injectivity -/

/-- `Spec.map` of an injective ring map is dominant: the kernel is `⊥`, hence contained in the
nilradical, and `PrimeSpectrum.denseRange_comap_iff_ker_le_nilRadical` applies. -/
theorem isDominant_Spec_map_of_injective {R S : CommRingCat.{u}} (φ : R ⟶ S)
    (h : Function.Injective φ.hom) : IsDominant (Spec.map φ) := by
  rw [isDominant_iff]
  refine (PrimeSpectrum.denseRange_comap_iff_ker_le_nilRadical (f := φ.hom)).mpr ?_
  intro a ha
  simp only [RingHom.mem_ker] at ha
  have : a = 0 := h (by simpa using ha)
  simp [this]

/-- **The algebra-valued projective point is dominant as soon as its chart evaluation is
injective** (and the chart itself is dominant).

`pointOfNormalizedCoordinatesAlgebra` is by definition `Spec.map (chart evaluation)` followed by
the chart immersion, so this is just the two factors. -/
theorem isDominant_pointOfNormalizedCoordinatesAlgebra
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (n : ℕ) (j : Fin (n + 1)) (y : Fin (n + 1) → S)
    (hchart : IsDominant (ProjectiveSpace.standardChartι n R j))
    (hinj : Function.Injective (ProjectiveSpace.standardChartEvalAlgebra (R := R) n j y)) :
    IsDominant (ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := R) n j y) := by
  unfold ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
  haveI := hchart
  haveI : IsDominant (Spec.map (CommRingCat.ofHom
      (ProjectiveSpace.standardChartEvalAlgebra (R := R) n j y))) :=
    isDominant_Spec_map_of_injective _ hinj
  infer_instance

/-- **Obligation 2, reduced.**  Horizontality follows from two inputs: that the standard chart of
`ℙ²_y` is dominant, and that the chart evaluation at the normalized residual `Y`-coordinates is
injective.

The second is the whole content — unfolding `standardChartEvalAlgebra`, it says no nonzero
polynomial vanishes on the residual `Y`-coordinate ratios, i.e. those ratios are algebraically
independent over `k` in `k(t,s)`.  That is the concrete statement the source proof's Picard
argument was a proxy for. -/
theorem isDominant_residualImagePointOfNormalizedLoc_toBase_of_injective
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hchart : IsDominant (ProjectiveSpace.standardChartι 2 k j))
    (hinj : Function.Injective
      (ProjectiveSpace.standardChartEvalAlgebra (R := k) 2 j (residualYCoordsNorm F v i j))) :
    IsDominant (residualImagePointOfNormalizedLoc F hF v hv i j ≫ residualImageToBase F) := by
  rw [residualImagePointOfNormalizedLoc_toBase]
  exact isDominant_pointOfNormalizedCoordinatesAlgebra 2 j _ hchart hinj

/-! ### The two remaining inputs -/

/--
**No nonzero form vanishes on the residual `Y`-coordinates.**

*What it says.*  `residualYCoords F v : Fin 3 → k[t,s]` are the homogeneous coordinates of the
tangent-residual point of the plane cubic fibre, as a function of the two parameters `(t, s)` of
the vertical surface `S_L`: `t` runs along the coordinate line `L = {Y₂ = 0}` and `s` along the
stereographic parametrization of the conic over it.  The statement is that these three polynomials
satisfy no homogeneous relation over `k`, in any degree — equivalently that the two ratios
`Y_a / Y_j` are algebraically independent in `k(t,s)`, equivalently that the residual surface `T_L`
is not contained in a curve of `ℙ²_y`.  This is the concrete content of horizontality; the degree
`d = 1` case alone is obligation 1's conclusion `residualYCoords_ne_zero_of_smooth`, strengthened
from "not all zero" to "linearly independent".

*Why it is expected to be true.*  Source
`certificates/all_smooth_tangent_residual_theorem.md` §4, last paragraph: the image of `T_L` in
`ℙ²_y` is not a point because the fibres of `X → ℙ²_y` are one-dimensional while `T_L` is a
surface, and it is not a curve because `Pic X = ℤH_x ⊕ ℤH_y` would then force `[T_L] = H_y`, hence
`T_L` the preimage of a constant line `M ⊂ ℙ²_y`, hence `δ_C(L) = M` constant.

*What is missing, precisely.*  Two things, and they are different in kind.

1. *A proof technique.*  In characteristic zero the Jacobian criterion turns algebraic independence
   of two elements of `k(t,s)` into nonvanishing of a single explicit determinant — which is why
   `CharZero` is carried.  Mathlib has no such criterion at the pinned revision
   (`RingTheory/AlgebraicIndependent/` has nothing Jacobian, and
   `PreSubmersivePresentation.jacobian` is a different notion), so it must be built, or preimages
   constructed directly.  The `X`-side analogue
   `eq_zero_of_aeval_residualImageXCoords_eq_zero_of_isHomogeneous_two_of_three_roots`
   (`SpecializedConicFreeDir.lean:3823`) does the same job in degree `2` only, by exploiting that a
   conic parametrization is quadratic in `s`; that structure does not survive to arbitrary degree.

2. *A hypothesis the source has and this statement does not.*  §3–§4 of the source **choose** the
   line `L` so that `δ_C(L)` is nonconstant, and §4 derives horizontality from that choice.  Here
   `L` is hardcoded as `{Y₂ = 0}` and `F` is arbitrary among smooth bidegree-`(2,3)` equations.  So
   the source does not prove this statement, and it may need the good line of `PLAN.md` WP-G — as a
   `PGL₃` normalization of `F`, not as a hypothesis on this declaration, whose shape is fixed by
   the pinned main theorem.  Two natural degenerations were checked and do not produce a
   counterexample: if `L` met every fibre cubic in a triple point, or were tangent to every fibre
   cubic at a constant point, then some point of `ℙ²_y` would have all of `ℙ²_x` as its fibre, and
   smooth `F` has no whole fibre (`BiprojectiveNoWholeFiber`).  That is evidence, not a proof.

*Form of the statement.*  Chart-free and localization-free on purpose: `i`, `j` and `hdenom` play
no part, and the shape matches the proved `X`-side analogue so that a method found for one
transfers to the other.  Given `hdenom` it is *equivalent* to the obligation below, so stating it
this way weakens nothing.
-/
theorem eq_zero_of_aeval_residualYCoords_of_isHomogeneous
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (d : ℕ) (Ψ : MvPolynomial (Fin 3) k) (hΨ : Ψ.IsHomogeneous d)
    (hvan : aeval (residualYCoords F v) Ψ = 0) :
    Ψ = 0 :=
  sorry

/-! ### The obligation -/

/--
**Obligation 2.**  The localized residual chart map dominates the conic-bundle base `ℙ²_y`.

*Status.* This says the residual surface is not contained in a fibre of the conic bundle —
equivalently, that the residual points move in `ℙ²_y` as the chart parameters vary.  It is what the
source concludes, but for a **chosen** line `L`, whereas `L` is fixed here; see the module header
and `eq_zero_of_aeval_residualYCoords_of_isHomogeneous`.  No counterexample is known and the two
obvious degenerations are excluded by smoothness, but the source does not prove it in this
generality.

*What it buys.*  By `isDominant_residualComponentToBase_iff` this concrete coordinate statement is
*equivalent* to horizontality of the residual component, with no scheme-theoretic image left in
it; and `isDominant_residualComponentMultisection_baseChangeFst` then upgrades horizontality to
dominance of `baseChangeFst`.  That upgrade is proved (properness plus dominance gives
surjectivity, which is stable under base change), so no flatness hypothesis on the conic bundle is
needed anywhere.

*Route: built.*  The whole chain is proved; the obligation is now a two-line assembly of the two
inputs isolated above, and nothing else about schemes, localizations or chart rings remains.

`residualImagePointOfNormalizedLoc_toBase` computes the composite in coordinates;
`isDominant_residualImagePointOfNormalizedLoc_toBase_of_injective` reduces to chart dominance plus
injectivity of the chart evaluation; `injective_standardChartEvalAlgebra_residualYCoordsNorm`
(`ResidualYFormVanishing`) reduces that injectivity, via `ChartHomogenization`, to
`eq_zero_of_aeval_residualYCoords_of_isHomogeneous`.  So what is owed is:

1. `ProjectiveSpace.isDominant_standardChartι` — topology, scoped elsewhere.
2. `eq_zero_of_aeval_residualYCoords_of_isHomogeneous` — the content; see its docstring for what is
   missing, including the good-line discrepancy with the source recorded in this module's header.

*Not needed.*  Picard groups, Grothendieck–Lefschetz, biduality, Lattès maps — the source uses them
only to reach "the image is not a curve" while computing a divisor class for a degree bound this
development does not claim.  What is *not* dispensable is the source's **choice of `L`** (§3–§4),
which this development replaced by the fixed coordinate line; see the module header.

`CharZero` is carried because the intended proof of the algebraic independence is the Jacobian
criterion applied to the two ratios as functions of `(t, s)`.  Mathlib has no such criterion at
the pinned revision; the fallback is to construct preimages explicitly.
-/
theorem isDominant_residualImagePointOfNormalizedLoc_toBase
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0) :
    IsDominant (residualImagePointOfNormalizedLoc F hF v hv i j ≫ residualImageToBase F) :=
  isDominant_residualImagePointOfNormalizedLoc_toBase_of_injective F hF v hv i j
    (ProjectiveSpace.isDominant_standardChartι 2 k j)
    (injective_standardChartEvalAlgebra_residualYCoordsNorm F v i j hdenom
      fun d Ψ hΨ hvan =>
        eq_zero_of_aeval_residualYCoords_of_isHomogeneous F hF hF0 v hv0 hv d Ψ hΨ hvan)

end

end BConicBundleMultisections
