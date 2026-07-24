/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineChartJacobian
public import BConicBundleMultisections.BiprojectiveAffineZeroLocus
public import BConicBundleMultisections.BiprojectiveFiberNonempty
public import BConicBundleMultisections.BiprojectiveProjectionDominant
public import BConicBundleMultisections.ProjectiveCoordinateNormalization
public import BConicBundleMultisections.ProjectiveSpaceClosedPoints

/-!
# Closed-point lifts for biprojective projections

Builds `k`-points of a smooth bidegree-`(2,3)` zero locus over closed points of the conic base,
and identifies their second projection with the reconstructed base point.  Combined with the
proper/Jacobson criterion, this yields surjectivity (and dominance) of the conic projection.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace ProjectiveSpace

attribute [local instance] MvPolynomial.gradedAlgebra

set_option backward.isDefEq.respectTransparency false

/-! ### Affine evaluation -/

def affineChartEval
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) :
    MvPolynomial (Fin m ⊕ Fin n) R →+* R :=
  MvPolynomial.eval (affineChartPoint i j x y)

theorem affineChartEval_affineChartEquation_eq_zero
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : MvPolynomial.eval (Sum.elim x y) F = 0) :
    affineChartEval m n R i j x y (affineChartEquation m n R i j F) = 0 := by
  simpa [affineChartEval] using
    (eval_affineChartEquation_affineChartPoint m n R i j x y hxi hyj F).trans hF

def affineChartQuotientEval
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : MvPolynomial.eval (Sum.elim x y) F = 0) :
    (MvPolynomial (Fin m ⊕ Fin n) R ⧸
      Ideal.span {affineChartEquation m n R i j F}) →+* R :=
  Ideal.Quotient.lift _
    (affineChartEval m n R i j x y)
    (by
      intro a ha
      obtain ⟨b, hb⟩ := Ideal.mem_span_singleton.mp ha
      rw [hb, map_mul,
        affineChartEval_affineChartEquation_eq_zero m n R i j x y hxi hyj F hF]
      ring)

def biprojectiveChartEval
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) :
    StandardChartRing m n R i j →+* R :=
  (affineChartEval m n R i j x y).comp
    (standardChartRingEquivMvPolynomial m n R i j).toRingHom

def chartZeroLocusPointOfNormalized
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : MvPolynomial.eval (Sum.elim x y) F = 0) :
    Spec (.of R) ⟶ (chartIdealSheaf m n R i j F).subscheme :=
  Spec.map (CommRingCat.ofHom
      (affineChartQuotientEval m n R i j x y hxi hyj F hF)) ≫
    (chartZeroLocusIsoSpecAffineQuotient m n R i j F).inv

def zeroLocusPointOfNormalized
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hFdeg : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : MvPolynomial.eval (Sum.elim x y) F = 0) :
    Spec (.of R) ⟶ biprojectiveZeroLocus m n R F :=
  chartZeroLocusPointOfNormalized m n R i j x y hxi hyj F hF ≫
    chartZeroLocusToGlobal m n R F hFdeg i j

def biprojectiveChartPointOfNormalized
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) :
    Spec (.of R) ⟶ standardChart m n R i j :=
  Spec.map (CommRingCat.ofHom (biprojectiveChartEval m n R i j x y)) ≫
    (standardChartIsoSpec m n R i j).inv

/-! ### Chart immersion = product-chart evaluation -/

theorem chartZeroLocusIsoSpecAffineQuotient_inv_eq
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    (chartZeroLocusIsoSpecAffineQuotient m n R i j F).inv =
      Spec.map (chartIdealQuotientEquivMvPolynomial m n R i j F).toCommRingCatIso.hom ≫
        (chartIdealSheaf m n R i j F).subschemeCover.f
          (chartTopAffineOpen m n R i j) := by
  unfold chartZeroLocusIsoSpecAffineQuotient
  simp only [Iso.trans_inv, Iso.symm_inv, asIso_hom]
  congr 1

theorem chartSubschemeCover_subschemeι_standardChartIsoSpec_hom
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    (chartIdealSheaf m n R i j F).subschemeCover.f
        (chartTopAffineOpen m n R i j) ≫
      (chartIdealSheaf m n R i j F).subschemeι ≫
      (standardChartIsoSpec m n R i j).hom =
    Spec.map
        (CommRingCat.ofHom
          ((Ideal.Quotient.mk
              ((chartIdealSheaf m n R i j F).ideal
                (chartTopAffineOpen m n R i j))).comp
            (standardChartΓIso m n R i j).inv.hom)) := by
  rw [← Category.assoc]
  rw [Scheme.IdealSheafData.subschemeCover_map_subschemeι]
  rw [Scheme.IdealSheafData.glueDataObjι_ι]
  rw [Category.assoc, chartTopAffineOpen_fromSpec_comp_standardChartIsoSpec]
  rw [← Spec.map_comp]
  congr 1

theorem chartSectionsEquivMvPolynomial_ΓIso_inv
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (z : StandardChartRing m n R i j) :
    chartSectionsEquivMvPolynomial m n R i j
        ((standardChartΓIso m n R i j).inv z) =
      standardChartRingEquivMvPolynomial m n R i j z := by
  unfold chartSectionsEquivMvPolynomial
  -- (ΓIso.equiv.trans chartRingEquiv) (ΓIso.inv z)
  -- = chartRingEquiv (ΓIso.equiv (ΓIso.inv z)) = chartRingEquiv z
  change standardChartRingEquivMvPolynomial m n R i j
      ((standardChartΓIso m n R i j).hom
        ((standardChartΓIso m n R i j).inv z)) =
    standardChartRingEquivMvPolynomial m n R i j z
  rw [Iso.inv_hom_id_apply]

theorem affineChartQuotientEval_equiv_mk_ΓIso_inv
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : MvPolynomial.eval (Sum.elim x y) F = 0)
    (z : StandardChartRing m n R i j) :
    affineChartQuotientEval m n R i j x y hxi hyj F hF
        (chartIdealQuotientEquivMvPolynomial m n R i j F
          (Ideal.Quotient.mk _
            ((standardChartΓIso m n R i j).inv z))) =
      biprojectiveChartEval m n R i j x y z := by
  have hmk :
      chartIdealQuotientEquivMvPolynomial m n R i j F
          (Ideal.Quotient.mk _
            ((standardChartΓIso m n R i j).inv z)) =
        Ideal.Quotient.mk _
          (standardChartRingEquivMvPolynomial m n R i j z) := by
    unfold chartIdealQuotientEquivMvPolynomial
    rw [Ideal.quotientEquiv_mk, chartSectionsEquivMvPolynomial_ΓIso_inv]
  rw [hmk]
  rfl

set_option maxHeartbeats 800000 in
-- Chart immersion comparison rewrites through several Spec/iso composites.
theorem chartZeroLocusPointOfNormalized_subschemeι
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : MvPolynomial.eval (Sum.elim x y) F = 0) :
    chartZeroLocusPointOfNormalized m n R i j x y hxi hyj F hF ≫
        (chartIdealSheaf m n R i j F).subschemeι =
      biprojectiveChartPointOfNormalized m n R i j x y := by
  -- Compare after composing with `standardChartIsoSpec.hom`.
  apply (cancel_mono (standardChartIsoSpec m n R i j).hom).mp
  unfold chartZeroLocusPointOfNormalized biprojectiveChartPointOfNormalized
  -- Fully reassociate both sides.
  simp only [Category.assoc]
  -- RHS: Spec.map eval ≫ inv ≫ hom = Spec.map eval
  rw [Iso.inv_hom_id (standardChartIsoSpec m n R i j), Category.comp_id]
  -- LHS: Spec.map qEval ≫ iso.inv ≫ subschemeι ≫ isoSpec.hom
  rw [chartZeroLocusIsoSpecAffineQuotient_inv_eq]
  simp only [Category.assoc]
  have hpath :=
    chartSubschemeCover_subschemeι_standardChartIsoSpec_hom m n R i j F
  rw [hpath]
  rw [← Spec.map_comp, ← Spec.map_comp]
  refine congrArg Spec.map ?_
  -- The composite is a morphism `of StandardChartRing ⟶ of R`.
  apply ConcreteCategory.ext_apply
  intro (z : StandardChartRing m n R i j)
  exact affineChartQuotientEval_equiv_mk_ΓIso_inv m n R i j x y hxi hyj F hF z

/-! ### Second-factor projection of product-chart evaluation -/

theorem biprojectiveChartEval_comp_algebraMap
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) :
    (biprojectiveChartEval m n R i j x y).comp
        (algebraMap R (StandardChartRing m n R i j)) =
      RingHom.id R := by
  ext r
  simp only [biprojectiveChartEval, RingHom.comp_apply, affineChartEval, RingHom.id_apply]
  -- The chart equivalence is an `R`-algebra map, so it sends `algebraMap r` to `C r`.
  change MvPolynomial.eval (affineChartPoint i j x y)
      (standardChartRingEquivMvPolynomial m n R i j
        (algebraMap R (StandardChartRing m n R i j) r)) = r
  rw [(standardChartRingEquivMvPolynomial m n R i j).commutes r]
  -- `algebraMap R (MvPolynomial _ R) r = C r`
  rw [MvPolynomial.algebraMap_eq, MvPolynomial.eval_C]

private theorem biprojectiveChartEval_tmul_normalizedCoordinate
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) (r : Fin n) :
    biprojectiveChartEval m n R i j x y
        (1 ⊗ₜ[R] ProjectiveSpace.normalizedCoordinate n R j (j.succAbove r)) =
      y (j.succAbove r) := by
  simp only [biprojectiveChartEval, RingHom.comp_apply, affineChartEval]
  change MvPolynomial.eval (affineChartPoint i j x y)
      (standardChartRingEquivMvPolynomial m n R i j
        (1 ⊗ₜ[R] ProjectiveSpace.normalizedCoordinate n R j (j.succAbove r))) =
    y (j.succAbove r)
  rw [standardChartRingEquivMvPolynomial_one_tmul_normalizedCoordinate]
  simp [affineChartPoint]

private theorem biprojectiveChartEval_tmul_mvPolynomialToStandardChart
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (p : MvPolynomial (Fin n) R) :
    biprojectiveChartEval m n R i j x y
        (1 ⊗ₜ[R] ProjectiveSpace.mvPolynomialToStandardChart n R j p) =
      standardChartEval n R j y
        (ProjectiveSpace.mvPolynomialToStandardChart n R j p) := by
  induction p using MvPolynomial.induction_on with
  | C a =>
      have hC :
          ProjectiveSpace.mvPolynomialToStandardChart n R j (MvPolynomial.C a) =
            algebraMap R (ProjectiveSpace.StandardChartRing n R j) a := by
        simp [ProjectiveSpace.mvPolynomialToStandardChart]
      have hright :
          standardChartEval n R j y
              (ProjectiveSpace.mvPolynomialToStandardChart n R j (MvPolynomial.C a)) = a := by
        rw [hC]
        exact DFunLike.congr_fun
          (standardChartEval_comp_standardChartRingHom n R j y) a
      have hleft :
          biprojectiveChartEval m n R i j x y
              (1 ⊗ₜ[R]
                ProjectiveSpace.mvPolynomialToStandardChart n R j (MvPolynomial.C a)) = a := by
        rw [hC]
        have halg :
            (1 : ProjectiveSpace.StandardChartRing m R i) ⊗ₜ[R]
                algebraMap R (ProjectiveSpace.StandardChartRing n R j) a =
              algebraMap R (StandardChartRing m n R i j) a := by
          -- `1 ⊗ algebraMap a = includeRight (algebraMap a) = algebraMap (A⊗B) a`
          change
              Algebra.TensorProduct.includeRight
                  (algebraMap R (ProjectiveSpace.StandardChartRing n R j) a) =
                algebraMap R (StandardChartRing m n R i j) a
          exact
            AlgHom.commutes
              (Algebra.TensorProduct.includeRight
                (R := R)
                (A := ProjectiveSpace.StandardChartRing m R i)
                (B := ProjectiveSpace.StandardChartRing n R j))
              a
        rw [halg]
        exact DFunLike.congr_fun
          (biprojectiveChartEval_comp_algebraMap m n R i j x y) a
      exact hleft.trans hright.symm
  | add p q hp hq =>
      simp [map_add, TensorProduct.tmul_add, hp, hq]
  | mul_X p r hp =>
      have hmul :
          ProjectiveSpace.mvPolynomialToStandardChart n R j (p * MvPolynomial.X r) =
            ProjectiveSpace.mvPolynomialToStandardChart n R j p *
              ProjectiveSpace.normalizedCoordinate n R j (j.succAbove r) := by
        simp [ProjectiveSpace.mvPolynomialToStandardChart]
      rw [hmul]
      have hsplit :
          (1 : ProjectiveSpace.StandardChartRing m R i) ⊗ₜ[R]
              (ProjectiveSpace.mvPolynomialToStandardChart n R j p *
                ProjectiveSpace.normalizedCoordinate n R j (j.succAbove r)) =
            (1 ⊗ₜ[R] ProjectiveSpace.mvPolynomialToStandardChart n R j p) *
              (1 ⊗ₜ[R] ProjectiveSpace.normalizedCoordinate n R j (j.succAbove r)) := by
        rw [← Algebra.TensorProduct.includeRight_apply,
          ← Algebra.TensorProduct.includeRight_apply,
          ← Algebra.TensorProduct.includeRight_apply, map_mul]
      rw [hsplit, map_mul, map_mul, hp,
        biprojectiveChartEval_tmul_normalizedCoordinate,
        standardChartEval_normalizedCoordinate_succAbove]

theorem biprojectiveChartEval_comp_includeRight
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) :
    (biprojectiveChartEval m n R i j x y).comp
        (Algebra.TensorProduct.includeRight
          (R := R)
          (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom =
      standardChartEval n R j y := by
  ext z
  have hz : z = ProjectiveSpace.mvPolynomialToStandardChart n R j
      (ProjectiveSpace.standardChartToMvPolynomial n R j z) :=
    (ProjectiveSpace.mvPolynomialToStandardChart_standardChartToMvPolynomial n R j z).symm
  change biprojectiveChartEval m n R i j x y (1 ⊗ₜ[R] z) =
    standardChartEval n R j y z
  rw [hz]
  exact biprojectiveChartEval_tmul_mvPolynomialToStandardChart m n R i j x y _

theorem biprojectiveChartPointOfNormalized_comp_standardChartι_snd
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hyj : y j = 1) :
    biprojectiveChartPointOfNormalized m n R i j x y ≫
        standardChartι m n R i j ≫ snd m n R =
      pointOfNormalizedCoordinates n R j y hyj := by
  rw [standardChartι_snd]
  unfold biprojectiveChartPointOfNormalized pointOfNormalizedCoordinates
  rw [Category.assoc, standardChartIsoSpec_inv_snd_assoc]
  rw [← Category.assoc (Spec.map _), ← Spec.map_comp]
  have hring := biprojectiveChartEval_comp_includeRight m n R i j x y
  -- `Spec.map f ≫ Spec.map g = Spec.map (g ≫ f)`, and
  -- `ofHom φ ≫ ofHom ψ = ofHom (ψ.comp φ)`.
  have hmor :
      CommRingCat.ofHom
            (Algebra.TensorProduct.includeRight
              (R := R)
              (A := ProjectiveSpace.StandardChartRing m R i)
              (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom ≫
          CommRingCat.ofHom (biprojectiveChartEval m n R i j x y) =
        CommRingCat.ofHom (standardChartEval n R j y) := by
    rw [← CommRingCat.ofHom_comp]
    exact congrArg CommRingCat.ofHom hring
  rw [congrArg Spec.map hmor]

/-! ### Main projection identity -/

theorem zeroLocusPointOfNormalized_snd
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hFdeg : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : MvPolynomial.eval (Sum.elim x y) F = 0) :
    zeroLocusPointOfNormalized m n R F hFdeg i j x y hxi hyj hF ≫
        biprojectiveZeroLocusSnd m n R F =
      pointOfNormalizedCoordinates n R j y hyj := by
  unfold zeroLocusPointOfNormalized biprojectiveZeroLocusSnd
  rw [Category.assoc, chartZeroLocusToGlobal_ι_assoc]
  -- Goal: chartPoint ≫ subschemeι ≫ standardChartι ≫ snd = pointOfNormalized
  have himm :=
    chartZeroLocusPointOfNormalized_subschemeι m n R i j x y hxi hyj F hF
  simp only [← Category.assoc] at himm ⊢
  rw [himm]
  simp only [Category.assoc]
  exact biprojectiveChartPointOfNormalized_comp_standardChartι_snd m n R i j x y hyj

/-! ### Closed-point lifts and surjectivity -/

theorem eval_normalize_first_eq_zero_of_isBihomogeneous
    {m n d e : ℕ} {K : Type u} [Field K]
    {F : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hF : IsBihomogeneousOfBidegree d e F)
    (x : Fin (m + 1) → K) (y : Fin (n + 1) → K)
    (i : Fin (m + 1)) (hx : MvPolynomial.eval (Sum.elim x y) F = 0) :
    MvPolynomial.eval (Sum.elim (normalizeCoordinateRepresentative x i) y) F = 0 := by
  have hhom :
      (specializeSecondCoordinates (m := m) y F).IsHomogeneous d :=
    hF.specializeSecondCoordinates_isHomogeneous y
  have hx' : MvPolynomial.eval x (specializeSecondCoordinates y F) = 0 := by
    rwa [eval_specializeSecondCoordinates]
  have hspec :=
    eval_normalizeCoordinateRepresentative_eq_zero hhom x i hx'
  rwa [eval_specializeSecondCoordinates] at hspec

theorem exists_normalized_lift_of_closedPoint
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (y : ProjectiveSpace 2 K) (hy : IsClosed {y}) :
    ∃ (i j : Fin 3) (x yCoords : Fin 3 → K) (hyj : y ∈ standardChart 2 K j),
      x i = 1 ∧ yCoords j = 1 ∧
        yCoords = closedPointNormalizedCoordinates 2 K y hy j hyj ∧
        MvPolynomial.eval (Sum.elim x yCoords) F = 0 := by
  obtain ⟨j, hyj⟩ := exists_mem_standardChart 2 K y
  let yCoords := closedPointNormalizedCoordinates 2 K y hy j hyj
  have hyj1 : yCoords j = 1 := closedPointNormalizedCoordinates_self 2 K y hy j hyj
  obtain ⟨x0, hx0, hxF⟩ :=
    exists_lift_secondProjection_of_smooth_bidegree23 K F hF hF0 j yCoords hyj1
  obtain ⟨i, hxi0⟩ := exists_normalizing_coordinate x0 hx0
  let x := normalizeCoordinateRepresentative x0 i
  have hxi1 : x i = 1 := normalizeCoordinateRepresentative_apply x0 i hxi0
  have hxF' : MvPolynomial.eval (Sum.elim x yCoords) F = 0 :=
    eval_normalize_first_eq_zero_of_isBihomogeneous hF x0 yCoords i hxF
  exact ⟨i, j, x, yCoords, hyj, hxi1, hyj1, rfl, hxF'⟩

theorem closedPoint_mem_range_biprojectiveZeroLocusSnd
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (y : ProjectiveSpace 2 K) (hy : IsClosed {y}) :
    y ∈ Set.range (biprojectiveZeroLocusSnd 2 2 K F) := by
  obtain ⟨i, j, x, yCoords, hyj, hxi, hyj1, hyCoords, hxF⟩ :=
    exists_normalized_lift_of_closedPoint K F hF hF0 y hy
  let pt := zeroLocusPointOfNormalized 2 2 K F hF i j x yCoords hxi hyj1 hxF
  refine ⟨pt (IsLocalRing.closedPoint K), ?_⟩
  have hcomp :=
    zeroLocusPointOfNormalized_snd 2 2 K F hF i j x yCoords hxi hyj1 hxF
  have hy_pt :
      pointOfNormalizedCoordinates 2 K j yCoords hyj1
        (IsLocalRing.closedPoint K) = y := by
    subst hyCoords
    exact closedPoint_eq_pointOfNormalizedCoordinates_apply 2 K y hy j hyj
  exact
    (congrArg (fun f : Spec (.of K) ⟶ ProjectiveSpace 2 K =>
        f (IsLocalRing.closedPoint K)) hcomp).trans hy_pt

theorem surjective_biprojectiveZeroLocusSnd_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    Surjective (biprojectiveZeroLocusSnd 2 2 K F) :=
  surjective_biprojectiveZeroLocusSnd_of_closedPoints K F fun y hy =>
    closedPoint_mem_range_biprojectiveZeroLocusSnd K F hF hF0 y hy

theorem isDominant_biprojectiveZeroLocusSnd_of_smooth_bidegree23
    (K : Type u) [Field K] [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    IsDominant (biprojectiveZeroLocusSnd 2 2 K F) := by
  haveI : Surjective (biprojectiveZeroLocusSnd 2 2 K F) :=
    surjective_biprojectiveZeroLocusSnd_of_smooth_bidegree23 K F hF hF0
  exact isDominant_biprojectiveZeroLocusSnd_of_surjective K F

end

end BConicBundleMultisections
