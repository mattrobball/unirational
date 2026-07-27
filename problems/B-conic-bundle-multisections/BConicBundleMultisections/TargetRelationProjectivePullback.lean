/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.TargetRelationProjectiveIntegrality
public import BConicBundleMultisections.IrreducibleProjectiveHypersurfaceIntegral
public import BConicBundleMultisections.BiprojectiveTwoEquationAffine

/-!
# The target relation as a projective pullback

For a homogeneous relation `H` in the second projective coordinates, this file identifies the
two-equation target relation `V(F, H)` with the scheme-theoretic pullback of the conic hypersurface
`V(F)` along the projective hypersurface inclusion `V(H) ⟶ ℙ²`.

The proof first computes the pullback of the projective hypersurface ideal on every standard
biprojective chart.  A general kernel formula for nested closed subschemes then turns the global
sum-of-ideals description of `V(F, H)` into the desired pullback square.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry TensorProduct

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry

attribute [local instance] MvPolynomial.gradedAlgebra

namespace BiprojectiveSpace

lemma ofIdealTop_ideal_top {X : Scheme.{u}} [IsAffine X]
    (I : Ideal Γ(X, ⊤)) :
    (Scheme.IdealSheafData.ofIdealTop I).ideal
      (⟨⊤, isAffineOpen_top X⟩ : X.affineOpens) = I := by
  simp [Scheme.IdealSheafData.ofIdealTop_ideal]

theorem comap_ofIdealTop_eq_ofIdealTop_map
    {X Y : Scheme.{u}} [IsAffine X] [IsAffine Y]
    (I : Ideal Γ(Y, ⊤)) (f : X ⟶ Y) :
    (Scheme.IdealSheafData.ofIdealTop I).comap f =
      Scheme.IdealSheafData.ofIdealTop (Ideal.map f.appTop.hom I) := by
  apply le_antisymm
  · rw [← Scheme.IdealSheafData.le_map_iff_comap_le]
    refine Scheme.IdealSheafData.le_of_isAffine (X := Y) ?_
    conv_lhs => rw [ofIdealTop_ideal_top]
    rw [Scheme.IdealSheafData.ideal_map_of_isAffineHom]
    rw [Scheme.IdealSheafData.ofIdealTop_ideal]
    rw [← Ideal.map_le_iff_le_comap, Ideal.map_map]
    apply le_of_eq
    congr 1
    apply RingHom.ext
    intro x
    have hres :
        X.presheaf.map
          (homOfLE (le_top : (f ⁻¹ᵁ (⊤ : Y.Opens)) ≤ ⊤)).op =
            𝟙 _ := by
      rw [← X.presheaf.map_id]
      exact congrArg X.presheaf.map (Subsingleton.elim _ _)
    rw [hres]
    rfl
  · refine Scheme.IdealSheafData.le_of_isAffine (X := X) ?_
    conv_lhs => rw [ofIdealTop_ideal_top]
    rw [Scheme.IdealSheafData.comap]
    change Ideal.map f.appTop.hom I ≤
      (pullback.fst f
        (Scheme.IdealSheafData.ofIdealTop I).subschemeι).ker.ideal
          (⟨⊤, isAffineOpen_top X⟩ : X.affineOpens)
    rw [Scheme.Hom.ker_apply]
    rw [Ideal.map_le_iff_le_comap]
    intro x hx
    change (pullback.fst f
      (Scheme.IdealSheafData.ofIdealTop I).subschemeι).appTop.hom
        (f.appTop.hom x) = 0
    have hxker :
        (Scheme.IdealSheafData.ofIdealTop I).subschemeι.appTop.hom x = 0 := by
      rw [← RingHom.mem_ker]
      rw [show RingHom.ker
          (Scheme.IdealSheafData.ofIdealTop I).subschemeι.appTop.hom = I by
        have hker := congrArg
          (fun K : Y.IdealSheafData =>
            K.ideal (⟨⊤, isAffineOpen_top Y⟩ : Y.affineOpens))
          (Scheme.IdealSheafData.ker_subschemeι
            (Scheme.IdealSheafData.ofIdealTop I))
        rw [Scheme.Hom.ker_apply, ofIdealTop_ideal_top] at hker
        exact hker]
      exact hx
    have hsq := pullback.condition (f := f)
      (g := (Scheme.IdealSheafData.ofIdealTop I).subschemeι)
    have happ := congrArg Scheme.Hom.appTop hsq
    simpa only [Scheme.Hom.comp_appTop, CommRingCat.hom_comp,
      RingHom.coe_comp, Function.comp_apply, hxker, map_zero] using
      congrArg (fun q => q.hom x) happ

theorem chartEquation_rename_inr_eq_includeRight
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (H : MvPolynomial (Fin (n + 1)) R) :
    chartEquation m n R i j (MvPolynomial.rename Sum.inr H) =
      Algebra.TensorProduct.includeRight
        (R := R)
        (A := ProjectiveSpace.StandardChartRing m R i)
        (B := ProjectiveSpace.StandardChartRing n R j)
        (ProjectiveSpace.hypersurfaceChartEquation n R j H) := by
  rw [chartEquation, chartEvaluation, MvPolynomial.aeval_rename]
  let f := Algebra.TensorProduct.includeRight
    (R := R)
    (A := ProjectiveSpace.StandardChartRing m R i)
    (B := ProjectiveSpace.StandardChartRing n R j)
  change MvPolynomial.aeval (fun x => f (ProjectiveSpace.normalizedCoordinate n R j x)) H =
    f (MvPolynomial.aeval (fun x => ProjectiveSpace.normalizedCoordinate n R j x) H)
  symm
  change f.toRingHom (MvPolynomial.aeval _ H) = _
  rw [MvPolynomial.map_aeval]
  rw [show f.toRingHom.comp
      (algebraMap R (ProjectiveSpace.StandardChartRing n R j)) =
      algebraMap R (StandardChartRing m n R i j) by
    ext r
    exact f.commutes r]
  rfl

@[reassoc]
theorem standardChartSnd_appTop_standardChartΓIso
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (pullback.snd
        (ProjectiveSpace.standardChartι m R i ≫ ProjectiveSpace.toSpec m R)
        (ProjectiveSpace.standardChartι n R j ≫ ProjectiveSpace.toSpec n R)).appTop ≫
      (standardChartΓIso m n R i j).hom =
    (ProjectiveSpace.hypersurfaceChartΓIso n R j).hom ≫
      CommRingCat.ofHom
        (Algebra.TensorProduct.includeRight
          (R := R)
          (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom := by
  unfold standardChartΓIso ProjectiveSpace.hypersurfaceChartΓIso
  have hinv : (standardChartIsoSpec m n R i j).inv =
      inv (standardChartIsoSpec m n R i j).hom := by
    rw [← asIso_inv]
    exact (Iso.inv_eq_inv _ _).2 rfl
  have happinv :
      (asIso (Scheme.Γ.map
        (standardChartIsoSpec m n R i j).hom.op)).inv =
        (standardChartIsoSpec m n R i j).inv.appTop := by
    rw [hinv, Scheme.Hom.inv_appTop]
    rfl
  simp only [Iso.trans_hom, Iso.symm_hom, happinv]
  let p := pullback.snd
    (ProjectiveSpace.standardChartι m R i ≫ ProjectiveSpace.toSpec m R)
    (ProjectiveSpace.standardChartι n R j ≫ ProjectiveSpace.toSpec n R)
  let e := standardChartIsoSpec m n R i j
  let φ := (Algebra.TensorProduct.includeRight
    (R := R)
    (A := ProjectiveSpace.StandardChartRing m R i)
    (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom
  calc
    p.appTop ≫ e.inv.appTop ≫
        (Scheme.ΓSpecIso (.of (StandardChartRing m n R i j))).hom =
      (e.inv ≫ p).appTop ≫
        (Scheme.ΓSpecIso (.of (StandardChartRing m n R i j))).hom := by
          rw [Scheme.Hom.comp_appTop, Category.assoc]
    _ = (Spec.map (CommRingCat.ofHom φ)).appTop ≫
        (Scheme.ΓSpecIso (.of (StandardChartRing m n R i j))).hom := by
          rw [show e.inv ≫ p = Spec.map (CommRingCat.ofHom φ) by
            exact standardChartIsoSpec_inv_snd m n R i j]
    _ = (Scheme.ΓSpecIso
          (.of (ProjectiveSpace.StandardChartRing n R j))).hom ≫
        CommRingCat.ofHom φ :=
      Scheme.ΓSpecIso_naturality (CommRingCat.ofHom φ)

theorem hypersurfaceChartIdealSheaf_comap_standardChartSnd
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (H : MvPolynomial (Fin (n + 1)) R) :
    (ProjectiveSpace.hypersurfaceChartIdealSheaf n R j H).comap
        (pullback.snd
          (ProjectiveSpace.standardChartι m R i ≫ ProjectiveSpace.toSpec m R)
          (ProjectiveSpace.standardChartι n R j ≫ ProjectiveSpace.toSpec n R)) =
      chartIdealSheaf m n R i j (MvPolynomial.rename Sum.inr H) := by
  unfold ProjectiveSpace.hypersurfaceChartIdealSheaf chartIdealSheaf
  rw [comap_ofIdealTop_eq_ofIdealTop_map]
  apply congrArg Scheme.IdealSheafData.ofIdealTop
  unfold ProjectiveSpace.hypersurfaceChartIdealTop chartIdealTop
  rw [Ideal.map_span, Set.image_singleton]
  apply congrArg Ideal.span
  apply congrArg (fun z => ({z} : Set Γ(standardChart m n R i j, ⊤)))
  apply (standardChartΓIso m n R i j).commRingCatIsoToRingEquiv.injective
  change
    ((pullback.snd
        (ProjectiveSpace.standardChartι m R i ≫ ProjectiveSpace.toSpec m R)
        (ProjectiveSpace.standardChartι n R j ≫ ProjectiveSpace.toSpec n R)).appTop ≫
      (standardChartΓIso m n R i j).hom).hom
        (ProjectiveSpace.hypersurfaceChartEquationSection n R j H) =
      (standardChartΓIso m n R i j).hom.hom
        (chartEquationSection m n R i j (MvPolynomial.rename Sum.inr H))
  have hp := congrArg
    (fun q : Γ(Spec (.of (ProjectiveSpace.StandardChartRing n R j)), ⊤) ⟶
        .of (StandardChartRing m n R i j) =>
      q.hom (ProjectiveSpace.hypersurfaceChartEquationSection n R j H))
    (standardChartSnd_appTop_standardChartΓIso m n R i j)
  simp only [CommRingCat.hom_comp, RingHom.coe_comp, Function.comp_apply] at hp ⊢
  rw [hp, ProjectiveSpace.hypersurfaceChartΓIso_hom_equationSection,
    standardChartΓIso_hom_chartEquationSection,
    chartEquation_rename_inr_eq_includeRight]
  rfl

theorem projectiveZeroLocusIdeal_comap_snd
    (m n : ℕ) (R : Type u) [CommRing R]
    (H : MvPolynomial (Fin (n + 1)) R) {d : ℕ}
    (hH : H.IsHomogeneous d) :
    (ProjectiveSpace.projectiveZeroLocusIdeal n R H).comap (snd m n R) =
      biprojectiveZeroLocusIdeal m n R (MvPolynomial.rename Sum.inr H) := by
  apply idealSheafData_eq_of_comap_standardChartι_eq m n R
  intro i j
  rw [← Scheme.IdealSheafData.comap_comp,
    standardChartι_snd,
    Scheme.IdealSheafData.comap_comp,
    ProjectiveSpace.projectiveZeroLocusIdeal_comap_standardChartι
      n R H hH j,
    hypersurfaceChartIdealSheaf_comap_standardChartSnd,
    biprojectiveZeroLocusIdeal_comap_standardChartι
      m n R (MvPolynomial.rename Sum.inr H)
        (rename_inr_isBihomogeneous hH) i j]

end BiprojectiveSpace

open BiprojectiveSpace

/-- The kernel of an inclusion of closed subschemes is the pullback of the larger ideal to the
smaller ambient subscheme. -/
theorem ker_inclusion_eq_comap
    {X : Scheme.{u}} {I J : X.IdealSheafData} (h : I ≤ J) :
    (Scheme.IdealSheafData.inclusion h).ker = J.comap I.subschemeι := by
  have hpb : IsPullback (Scheme.IdealSheafData.inclusion h) (𝟙 J.subscheme)
      I.subschemeι J.subschemeι :=
    IsPullback.of_vert_isIso_mono ⟨by simp⟩
  let e : J.subscheme ≅ pullback I.subschemeι J.subschemeι :=
    hpb.isLimit.conePointUniqueUpToIso
      (pullback.isLimit I.subschemeι J.subschemeι)
  have he_fst : e.hom ≫ pullback.fst I.subschemeι J.subschemeι =
      Scheme.IdealSheafData.inclusion h := by
    change pullback.lift (Scheme.IdealSheafData.inclusion h) (𝟙 J.subscheme) (by simp) ≫
        pullback.fst I.subschemeι J.subschemeι = Scheme.IdealSheafData.inclusion h
    exact pullback.lift_fst _ _ _
  rw [← he_fst, Scheme.Hom.ker_comp_of_isIso,
    Scheme.IdealSheafData.ker_fst_of_isClosedImmersion,
    Scheme.IdealSheafData.ker_subschemeι]

@[simp]
theorem comap_subschemeι_self_eq_bot
    {X : Scheme.{u}} (I : X.IdealSheafData) :
    I.comap I.subschemeι = ⊥ := by
  calc
    I.comap I.subschemeι = I.subschemeι.ker.comap I.subschemeι := by
      rw [Scheme.IdealSheafData.ker_subschemeι]
    _ = (pullback.fst I.subschemeι I.subschemeι).ker :=
      (Scheme.IdealSheafData.ker_fst_of_isClosedImmersion
        I.subschemeι I.subschemeι).symm
    _ = ⊥ := Scheme.Hom.ker_eq_bot_of_isIso _

/-- The canonical map from the target relation to the projective relation curve. -/
def targetRelationToProjectiveZeroLocus
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) :
    targetRelationZeroLocus F H ⟶
      ProjectiveSpace.projectiveZeroLocus 2 k H :=
  IsClosedImmersion.lift (ProjectiveSpace.projectiveZeroLocusι 2 k H)
    (targetRelationToSecond F H) (by
      rw [targetRelationToSecond, Scheme.Hom.ker_comp, ker_targetRelationι]
      rw [ProjectiveSpace.ker_projectiveZeroLocusι,
        Scheme.IdealSheafData.le_map_iff_comap_le,
        BiprojectiveSpace.projectiveZeroLocusIdeal_comap_snd 2 2 k H hH]
      exact le_sup_right)

@[reassoc]
theorem targetRelationToProjectiveZeroLocus_ι
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) :
    targetRelationToProjectiveZeroLocus F H hH ≫
        ProjectiveSpace.projectiveZeroLocusι 2 k H =
      targetRelationToSecond F H :=
  IsClosedImmersion.lift_fac _ _ _

/-- The defining square of the target relation commutes. -/
theorem targetRelation_projectiveZeroLocus_square
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) :
    targetRelationToConic F H ≫ biprojectiveZeroLocusSnd 2 2 k F =
      targetRelationToProjectiveZeroLocus F H hH ≫
        ProjectiveSpace.projectiveZeroLocusι 2 k H := by
  rw [targetRelationToConic_biprojectiveZeroLocusSnd,
    targetRelationToProjectiveZeroLocus_ι]

/-- The target relation is canonically the pullback of the conic hypersurface to the projective
relation curve. -/
theorem targetRelation_projectiveZeroLocus_isPullback
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) :
    IsPullback (targetRelationToConic F H)
      (targetRelationToProjectiveZeroLocus F H hH)
      (biprojectiveZeroLocusSnd 2 2 k F)
      (ProjectiveSpace.projectiveZeroLocusι 2 k H) := by
  letI : IsClosedImmersion (targetRelationToConic F H) := by
    unfold targetRelationToConic
    infer_instance
  apply AlgebraicGeometry.isPullback_of_isClosedImmersion
    (targetRelationToConic F H)
    (ProjectiveSpace.projectiveZeroLocusι 2 k H)
    (targetRelationToProjectiveZeroLocus F H hH)
    (biprojectiveZeroLocusSnd 2 2 k F)
    (targetRelation_projectiveZeroLocus_square F H hH)
  rw [ProjectiveSpace.ker_projectiveZeroLocusι,
    biprojectiveZeroLocusSnd,
    Scheme.IdealSheafData.comap_comp,
    BiprojectiveSpace.projectiveZeroLocusIdeal_comap_snd 2 2 k H hH,
    targetRelationToConic,
    ker_inclusion_eq_comap]
  simp only [targetRelationIdeal, Scheme.IdealSheafData.comap_sup,
    comap_subschemeι_self_eq_bot, bot_sup_eq]

end

end BConicBundleMultisections

end
