/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveHypersurfaceFunctionField
public import BConicBundleMultisections.ProjectiveHypersurfaceNegativeTwist

/-!
# Canonical transition identities in a projective hypersurface function field

This file compares dehomogenizations on two retained standard charts of an irreducible
projective plane hypersurface.  The comparison takes place in the intrinsic function field,
so it does not depend on a chosen affine-cone presentation.
-/

@[expose] public section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial

namespace ProjectiveSpace

attribute [local instance] MvPolynomial.gradedAlgebra

variable {k : Type u} [Field k]

private theorem specMap_ΓIsoTop_hom_fromSpec
    {X Y : Scheme.{u}} [IsAffine X] (f : X ⟶ Y) [IsOpenImmersion f] :
    Spec.map (IsOpenImmersion.ΓIsoTop f).hom ≫
        (isAffineOpen_top X).fromSpec ≫ f =
      (isAffineOpen_opensRange f).fromSpec := by
  let hU : IsAffineOpen f.opensRange := isAffineOpen_opensRange f
  let hV : IsAffineOpen (⊤ : X.Opens) := isAffineOpen_top X
  have hpre : (⊤ : X.Opens) ≤ f ⁻¹ᵁ f.opensRange := by
    rw [f.preimage_opensRange]
  have h := IsAffineOpen.SpecMap_appLE_fromSpec f hU hV hpre
  have hinv :
      (IsOpenImmersion.ΓIsoTop f).inv = f.appLE f.opensRange ⊤ hpre := by
    unfold IsOpenImmersion.ΓIsoTop
    simp only [Iso.trans_inv, Functor.mapIso_inv, Iso.op_inv, eqToIso.inv,
      eqToHom_op, Iso.symm_inv, Scheme.Hom.appIso_hom', Scheme.Hom.map_appLE]
  rw [← h]
  rw [← Category.assoc, ← Spec.map_comp]
  rw [← hinv]
  simp

set_option backward.isDefEq.respectTransparency false in
/-- The spectrum map induced by a retained chart quotient's inclusion in the intrinsic
function field is the canonical generic-point morphism, expressed through that chart. -/
theorem specMap_hypersurfaceChartQuotientToSchemeFunctionField_comp_chart
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    Spec.map (CommRingCat.ofHom
        (hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i)) ≫
      (hypersurfaceChartIsoSpecAffineQuotient 2 k i.1 H).inv ≫
      hypersurfaceChartToGlobal 2 k H hH i.1 =
        (projectiveZeroLocus 2 k H).fromSpecStalk
          (_root_.genericPoint (projectiveZeroLocus 2 k H)) := by
  let X := projectiveZeroLocus 2 k H
  let C := (hypersurfaceChartIdealSheaf 2 k i.1 H).subscheme
  let A := HypersurfaceChartQuotient H i.1
  let U := hypersurfaceRetainedChartOpen H hH i
  let e := hypersurfaceChartIsoSpecAffineQuotient 2 k i.1 H
  let f := hypersurfaceChartToGlobal 2 k H hH i.1
  letI : IsIntegral X := by
    dsimp only [X]
    exact isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  letI : IsAffine C := IsAffine.of_isIso e.hom
  let η := _root_.genericPoint X
  have hηU : η ∈ U :=
    ((genericPoint_spec X).mem_open_set_iff U.isOpen).mpr
      (by simpa [U] using
        (inferInstance : Nonempty (hypersurfaceRetainedChartOpen H hH i)))
  change Spec.map (CommRingCat.ofHom
      ((X.germToFunctionField U).hom.comp
        (hypersurfaceChartQuotientEquivSections H hH i).toRingHom)) ≫
    e.inv ≫ f = X.fromSpecStalk η
  have hsections :
      Spec.map (CommRingCat.ofHom
          (hypersurfaceChartQuotientEquivSections H hH i).toRingHom) ≫
        e.inv =
      Spec.map (IsOpenImmersion.ΓIsoTop f).hom ≫
        (isAffineOpen_top C).fromSpec := by
    let r₁ : CommRingCat.of A ⟶ Γ(Spec (.of A), ⊤) :=
      (Scheme.ΓSpecIso (.of A)).inv
    let r₂ : Γ(Spec (.of A), ⊤) ⟶ Γ(C, ⊤) := e.hom.appTop
    let r₃ : Γ(C, ⊤) ⟶ Γ(X, U) :=
      (IsOpenImmersion.ΓIsoTop f).hom
    have hring :
        CommRingCat.ofHom
            (hypersurfaceChartQuotientEquivSections H hH i).toRingHom =
          r₁ ≫ r₂ ≫ r₃ := by
      rfl
    have hmap :
        Spec.map (CommRingCat.ofHom
            (hypersurfaceChartQuotientEquivSections H hH i).toRingHom) =
          Spec.map r₃ ≫ Spec.map r₂ ≫ Spec.map r₁ := by
      rw [hring]
      calc
        Spec.map (r₁ ≫ r₂ ≫ r₃) =
            Spec.map r₃ ≫ Spec.map (r₁ ≫ r₂) :=
          Spec.map_comp (r₁ ≫ r₂) r₃
        _ = Spec.map r₃ ≫ (Spec.map r₂ ≫ Spec.map r₁) :=
          congrArg (fun z ↦ Spec.map r₃ ≫ z) (Spec.map_comp r₁ r₂)
        _ = Spec.map r₃ ≫ Spec.map r₂ ≫ Spec.map r₁ := by
          rfl
    calc
      Spec.map (CommRingCat.ofHom
            (hypersurfaceChartQuotientEquivSections H hH i).toRingHom) ≫
          e.inv =
        Spec.map (IsOpenImmersion.ΓIsoTop f).hom ≫
          Spec.map e.hom.appTop ≫
          Spec.map (Scheme.ΓSpecIso (.of A)).inv ≫ e.inv := by
            rw [hmap]
            rfl
      _ = Spec.map (IsOpenImmersion.ΓIsoTop f).hom ≫
          (isAffineOpen_top C).fromSpec := by
        dsimp only [A]
        rw [← Scheme.isoSpec_Spec_inv]
        have hnat := Scheme.isoSpec_inv_naturality e.hom
        have hnat' := congrArg
          (fun z ↦ Spec.map (IsOpenImmersion.ΓIsoTop f).hom ≫ z ≫ e.inv) hnat
        calc
          Spec.map (IsOpenImmersion.ΓIsoTop f).hom ≫
              Spec.map e.hom.appTop ≫ (Spec (.of A)).isoSpec.inv ≫ e.inv =
            Spec.map (IsOpenImmersion.ΓIsoTop f).hom ≫
              (C.isoSpec.inv ≫ e.hom) ≫ e.inv := by
                simpa only [Category.assoc] using hnat'
          _ = Spec.map (IsOpenImmersion.ΓIsoTop f).hom ≫
              C.isoSpec.inv := by simp only [Category.assoc, Iso.hom_inv_id,
                Category.comp_id]
          _ = Spec.map (IsOpenImmersion.ΓIsoTop f).hom ≫
              (isAffineOpen_top C).fromSpec := by
                rw [IsAffineOpen.fromSpec_top]
  have hopen := specMap_ΓIsoTop_hom_fromSpec f
  have hfactor :
      Spec.map (CommRingCat.ofHom
        ((X.germToFunctionField U).hom.comp
          (hypersurfaceChartQuotientEquivSections H hH i).toRingHom)) =
        Spec.map (X.germToFunctionField U) ≫
          Spec.map (CommRingCat.ofHom
            (hypersurfaceChartQuotientEquivSections H hH i).toRingHom) := by
    rw [← Spec.map_comp]
    rfl
  rw [hfactor]
  have hsections' := congrArg
    (fun z ↦ Spec.map (X.germToFunctionField U) ≫ z ≫ f) hsections
  have hrewrite :
      (Spec.map (X.germToFunctionField U) ≫
          Spec.map (CommRingCat.ofHom
            (hypersurfaceChartQuotientEquivSections H hH i).toRingHom)) ≫
        e.inv ≫ f =
      Spec.map (X.germToFunctionField U) ≫
        (Spec.map (IsOpenImmersion.ΓIsoTop f).hom ≫
          (isAffineOpen_top C).fromSpec) ≫ f := by
    simpa only [Category.assoc] using hsections'
  rw [hrewrite]
  rw [Category.assoc, hopen]
  change (isAffineOpen_opensRange f).fromSpecStalk hηU = X.fromSpecStalk η
  exact IsAffineOpen.fromSpecStalk_eq_fromSpecStalk _ hηU

/-- A chart equation becomes the ordinary dehomogenization under the standard-chart
coordinate equivalence. -/
theorem standardChartRingEquivMvPolynomial_hypersurfaceChartEquation
    (i : Fin 3) (P : MvPolynomial (Fin 3) k) :
    standardChartRingEquivMvPolynomial 2 k i
        (hypersurfaceChartEquation 2 k i P) =
      chartDehomogenization 2 k i P := by
  change standardChartToMvPolynomial 2 k i
      (MvPolynomial.aeval (fun l ↦ normalizedCoordinate 2 k i l) P) = _
  calc
    _ = standardChartToMvPolynomial 2 k i
        (mvPolynomialToStandardChart 2 k i
          (chartDehomogenization 2 k i P)) := by
      congr 1
      exact (DFunLike.congr_fun
        (mvPolynomialToStandardChart_comp_chartDehomogenization 2 k i) P).symm
    _ = chartDehomogenization 2 k i P := by
      exact DFunLike.congr_fun
        (standardChartToMvPolynomial_comp_mvPolynomialToStandardChart 2 k i)
        (chartDehomogenization 2 k i P)

/-- The ambient standard-chart equation maps to the class of the ordinary
dehomogenization in the affine hypersurface quotient. -/
@[simp]
theorem hypersurfaceAffineChartQuotientMap_chartEquation
    (H P : MvPolynomial (Fin 3) k) (i : Fin 3) :
    hypersurfaceAffineChartQuotientMap 2 k i H
        (hypersurfaceChartEquation 2 k i P) =
      Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k i H})
        (chartDehomogenization 2 k i P) := by
  unfold hypersurfaceAffineChartQuotientMap
  change Ideal.Quotient.mk _
      (standardChartRingEquivMvPolynomial 2 k i
        (hypersurfaceChartEquation 2 k i P)) = _
  rw [standardChartRingEquivMvPolynomial_hypersurfaceChartEquation]

/-- The canonical map from an ambient standard-chart ring to the intrinsic function field
of an irreducible projective hypersurface. -/
noncomputable def hypersurfaceStandardChartToSchemeFunctionField
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    StandardChartRing 2 k i.1 →+*
      (projectiveZeroLocus 2 k H).functionField := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  exact (hypersurfaceChartQuotientToSchemeFunctionField
    H hH hd hHirr i).comp
      (hypersurfaceAffineChartQuotientMap 2 k i.1 H)

set_option backward.isDefEq.respectTransparency false in
/-- The standard-chart map induced by the intrinsic function field represents the canonical
generic-point morphism after inclusion into projective space. -/
theorem specMap_hypersurfaceStandardChartToSchemeFunctionField_comp_standardChartι
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    Spec.map (CommRingCat.ofHom
        (hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i)) ≫
      standardChartι 2 k i.1 =
        (projectiveZeroLocus 2 k H).fromSpecStalk
            (_root_.genericPoint (projectiveZeroLocus 2 k H)) ≫
          projectiveZeroLocusι 2 k H := by
  let X := projectiveZeroLocus 2 k H
  let A := HypersurfaceChartQuotient H i.1
  let e := hypersurfaceChartIsoSpecAffineQuotient 2 k i.1 H
  let f := hypersurfaceChartToGlobal 2 k H hH i.1
  let q := hypersurfaceAffineChartQuotientMap 2 k i.1 H
  let φ := hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i
  letI : IsIntegral X := by
    dsimp only [X]
    exact isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  have heq : Spec.map (CommRingCat.ofHom q) =
      e.inv ≫ (hypersurfaceChartIdealSheaf 2 k i.1 H).subschemeι := by
    have heq' :=
      hypersurfaceChartIsoSpecAffineQuotient_hom_subschemeι 2 k i.1 H
    rw [← heq']
    simp
    rfl
  have hgeneric :=
    specMap_hypersurfaceChartQuotientToSchemeFunctionField_comp_chart
      H hH hd hHirr i
  have hchart := hypersurfaceChartToGlobal_ι 2 k H hH i.1
  change Spec.map (CommRingCat.ofHom (φ.comp q)) ≫
      standardChartι 2 k i.1 =
    X.fromSpecStalk (_root_.genericPoint X) ≫ projectiveZeroLocusι 2 k H
  calc
    Spec.map (CommRingCat.ofHom (φ.comp q)) ≫
          standardChartι 2 k i.1 =
        Spec.map (CommRingCat.ofHom φ) ≫
          Spec.map (CommRingCat.ofHom q) ≫ standardChartι 2 k i.1 := by
      have hcomp := Spec.map_comp
        (CommRingCat.ofHom q) (CommRingCat.ofHom φ)
      have hcomp' := congrArg
        (fun z ↦ z ≫ standardChartι 2 k i.1) hcomp
      rw [show CommRingCat.ofHom (φ.comp q) =
        CommRingCat.ofHom q ≫ CommRingCat.ofHom φ by rfl]
      simpa only [Category.assoc] using hcomp'
    _ = Spec.map (CommRingCat.ofHom φ) ≫ e.inv ≫
          (hypersurfaceChartIdealSheaf 2 k i.1 H).subschemeι ≫
            standardChartι 2 k i.1 := by
      have heq' := congrArg
        (fun z ↦ Spec.map (CommRingCat.ofHom φ) ≫ z ≫
          standardChartι 2 k i.1) heq
      simpa only [Category.assoc] using heq'
    _ = Spec.map (CommRingCat.ofHom φ) ≫ e.inv ≫ f ≫
          projectiveZeroLocusι 2 k H := by
      have hchart' := congrArg
        (fun z ↦ Spec.map (CommRingCat.ofHom φ) ≫ e.inv ≫ z) hchart.symm
      simpa only [Category.assoc] using hchart'
    _ = X.fromSpecStalk (_root_.genericPoint X) ≫
          projectiveZeroLocusι 2 k H := by
      have hgeneric' := congrArg
        (fun z ↦ z ≫ projectiveZeroLocusι 2 k H) hgeneric
      simpa only [φ, e, f, X, Category.assoc] using hgeneric'

/-- The generic point of an irreducible hypersurface, lifted to the explicit overlap of two
retained standard charts. -/
noncomputable def hypersurfaceGenericOverlapLift
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i i' : NonemptyHypersurfaceChart H) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    Spec (.of (projectiveZeroLocus 2 k H).functionField) ⟶
      Spec (.of (OverlapRing 2 k i.1 i'.1)) := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  apply (overlap_isPullback 2 k i.1 i'.1).lift
    (Spec.map (CommRingCat.ofHom
      (hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i)))
    (Spec.map (CommRingCat.ofHom
      (hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i')))
  rw [specMap_hypersurfaceStandardChartToSchemeFunctionField_comp_standardChartι,
    specMap_hypersurfaceStandardChartToSchemeFunctionField_comp_standardChartι]

/-- The common restriction of two retained standard-chart coordinate rings to the intrinsic
hypersurface function field. -/
noncomputable def hypersurfaceOverlapToSchemeFunctionField
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i i' : NonemptyHypersurfaceChart H) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    OverlapRing 2 k i.1 i'.1 →+*
      (projectiveZeroLocus 2 k H).functionField := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  exact (Spec.preimage
    (hypersurfaceGenericOverlapLift H hH hd hHirr i i')).hom

/-- The common overlap map restricts to the intrinsic function-field map on the first chart. -/
theorem hypersurfaceOverlapToSchemeFunctionField_comp_toOverlap
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i i' : NonemptyHypersurfaceChart H) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    (hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i i').comp
        (toOverlap 2 k i.1 i'.1) =
      hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  have hcat : CommRingCat.ofHom
      ((hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i i').comp
        (toOverlap 2 k i.1 i'.1)) =
      CommRingCat.ofHom
        (hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i) := by
    apply Spec.map_injective
    rw [show CommRingCat.ofHom
        ((hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i i').comp
          (toOverlap 2 k i.1 i'.1)) =
        CommRingCat.ofHom (toOverlap 2 k i.1 i'.1) ≫
          CommRingCat.ofHom
            (hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i i') by rfl]
    rw [Spec.map_comp]
    rw [show CommRingCat.ofHom
        (hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i i') =
        Spec.preimage (hypersurfaceGenericOverlapLift H hH hd hHirr i i') by rfl]
    rw [Spec.map_preimage]
    exact (overlap_isPullback 2 k i.1 i'.1).lift_fst _ _ _
  exact congrArg CommRingCat.Hom.hom hcat

/-- The common overlap map restricts to the intrinsic function-field map on the second chart. -/
theorem hypersurfaceOverlapToSchemeFunctionField_comp_fromOtherToOverlap
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i i' : NonemptyHypersurfaceChart H) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    (hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i i').comp
        (fromOtherToOverlap 2 k i.1 i'.1) =
      hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i' := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  have hcat : CommRingCat.ofHom
      ((hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i i').comp
        (fromOtherToOverlap 2 k i.1 i'.1)) =
      CommRingCat.ofHom
        (hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i') := by
    apply Spec.map_injective
    rw [show CommRingCat.ofHom
        ((hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i i').comp
          (fromOtherToOverlap 2 k i.1 i'.1)) =
        CommRingCat.ofHom (fromOtherToOverlap 2 k i.1 i'.1) ≫
          CommRingCat.ofHom
            (hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i i') by rfl]
    rw [Spec.map_comp]
    rw [show CommRingCat.ofHom
        (hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i i') =
        Spec.preimage (hypersurfaceGenericOverlapLift H hH hd hHirr i i') by rfl]
    rw [Spec.map_preimage]
    exact (overlap_isPullback 2 k i.1 i'.1).lift_snd _ _ _
  exact congrArg CommRingCat.Hom.hom hcat

/-- The transition coordinate `Yᵢ′ / Yᵢ`, viewed in the intrinsic function field through the
common overlap of two retained charts. -/
noncomputable def hypersurfaceTransitionInSchemeFunctionField
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i i' : NonemptyHypersurfaceChart H) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    (projectiveZeroLocus 2 k H).functionField := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  exact hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i i'
    (hypersurfaceTransition 2 k i.1 i'.1)

/-- Normalized homogeneous coordinates on two retained charts differ by the intrinsic
transition coordinate. -/
theorem hypersurfaceStandardChartToSchemeFunctionField_normalizedCoordinate_transition
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i i' : NonemptyHypersurfaceChart H) (l : Fin 3) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i
        (normalizedCoordinate 2 k i.1 l) =
      hypersurfaceTransitionInSchemeFunctionField H hH hd hHirr i i' *
        hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i'
          (normalizedCoordinate 2 k i'.1 l) := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  let ψ := hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i i'
  have hcoord := congrArg ψ
    (toOverlap_normalizedCoordinate 2 k i.1 i'.1 l)
  rw [map_mul] at hcoord
  change ψ (toOverlap 2 k i.1 i'.1
      (normalizedCoordinate 2 k i.1 l)) =
    ψ (toOverlap 2 k i.1 i'.1
      (normalizedCoordinate 2 k i.1 i'.1)) *
      ψ (fromOtherToOverlap 2 k i.1 i'.1
        (normalizedCoordinate 2 k i'.1 l)) at hcoord
  have hfirst := DFunLike.congr_fun
    (hypersurfaceOverlapToSchemeFunctionField_comp_toOverlap
      H hH hd hHirr i i') (normalizedCoordinate 2 k i.1 l)
  have htransition : ψ (toOverlap 2 k i.1 i'.1
      (normalizedCoordinate 2 k i.1 i'.1)) =
      hypersurfaceTransitionInSchemeFunctionField H hH hd hHirr i i' := by
    rfl
  have hsecond := DFunLike.congr_fun
    (hypersurfaceOverlapToSchemeFunctionField_comp_fromOtherToOverlap
      H hH hd hHirr i i') (normalizedCoordinate 2 k i'.1 l)
  rw [RingHom.comp_apply] at hfirst hsecond
  exact hfirst.symm.trans (hcoord.trans (congrArg₂ (· * ·)
    htransition hsecond))

/-- The intrinsic transition coordinate is nonzero (indeed, it is the image of a unit on the
chart overlap). -/
theorem hypersurfaceTransitionInSchemeFunctionField_ne_zero
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i i' : NonemptyHypersurfaceChart H) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    hypersurfaceTransitionInSchemeFunctionField H hH hd hHirr i i' ≠ 0 := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  apply IsUnit.ne_zero
  exact (isUnit_hypersurfaceTransition 2 k i.1 i'.1).map
    (hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i i')

/-- A homogeneous polynomial evaluated on two retained charts scales by the corresponding
power of the intrinsic transition coordinate. -/
theorem hypersurfaceStandardChartToSchemeFunctionField_chartEquation_transition
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i i' : NonemptyHypersurfaceChart H)
    {e : ℕ} (P : MvPolynomial (Fin 3) k) (hP : P.IsHomogeneous e) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i
        (hypersurfaceChartEquation 2 k i.1 P) =
      hypersurfaceTransitionInSchemeFunctionField H hH hd hHirr i i' ^ e *
        hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i'
          (hypersurfaceChartEquation 2 k i'.1 P) := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  let ψ := hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i i'
  have heq := congrArg ψ
    (hypersurfaceChartEquation_overlap 2 k i.1 i'.1 P hP)
  rw [map_mul, map_pow] at heq
  have hfirst := DFunLike.congr_fun
    (hypersurfaceOverlapToSchemeFunctionField_comp_toOverlap
      H hH hd hHirr i i') (hypersurfaceChartEquation 2 k i.1 P)
  have hsecond := DFunLike.congr_fun
    (hypersurfaceOverlapToSchemeFunctionField_comp_fromOtherToOverlap
      H hH hd hHirr i i') (hypersurfaceChartEquation 2 k i'.1 P)
  rw [RingHom.comp_apply] at hfirst hsecond
  have htransition : ψ (hypersurfaceTransition 2 k i.1 i'.1) =
      hypersurfaceTransitionInSchemeFunctionField H hH hd hHirr i i' := by
    rfl
  exact hfirst.symm.trans (heq.trans (congrArg₂ (· * ·)
    (congrArg (· ^ e) htransition) hsecond))

/-- Quotient classes of two dehomogenizations of a homogeneous polynomial obey the same
intrinsic transition formula. -/
theorem hypersurfaceChartQuotientToSchemeFunctionField_chartDehomogenization_transition
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i i' : NonemptyHypersurfaceChart H)
    {e : ℕ} (P : MvPolynomial (Fin 3) k) (hP : P.IsHomogeneous e) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i
        (Ideal.Quotient.mk
          (Ideal.span {chartDehomogenization 2 k i.1 H})
          (chartDehomogenization 2 k i.1 P)) =
      hypersurfaceTransitionInSchemeFunctionField H hH hd hHirr i i' ^ e *
        hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i'
          (Ideal.Quotient.mk
            (Ideal.span {chartDehomogenization 2 k i'.1 H})
            (chartDehomogenization 2 k i'.1 P)) := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  have h :=
    hypersurfaceStandardChartToSchemeFunctionField_chartEquation_transition
      H hH hd hHirr i i' P hP
  change hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i
        (hypersurfaceAffineChartQuotientMap 2 k i.1 H
          (hypersurfaceChartEquation 2 k i.1 P)) =
      hypersurfaceTransitionInSchemeFunctionField H hH hd hHirr i i' ^ e *
        hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i'
          (hypersurfaceAffineChartQuotientMap 2 k i'.1 H
            (hypersurfaceChartEquation 2 k i'.1 P)) at h
  simpa only [hypersurfaceAffineChartQuotientMap_chartEquation] using h

/-- The intrinsic standard-chart map sends a chart equation to the quotient class of its
ordinary dehomogenization. -/
@[simp]
theorem hypersurfaceStandardChartToSchemeFunctionField_chartEquation
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) (P : MvPolynomial (Fin 3) k) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i
        (hypersurfaceChartEquation 2 k i.1 P) =
      hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i
        (Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k i.1 H})
          (chartDehomogenization 2 k i.1 P)) := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  unfold hypersurfaceStandardChartToSchemeFunctionField
  simp only [RingHom.comp_apply,
    hypersurfaceAffineChartQuotientMap_chartEquation]

/-- The intrinsic standard-chart map sends a normalized homogeneous coordinate to its
ordinary dehomogenized quotient class. -/
@[simp]
theorem hypersurfaceStandardChartToSchemeFunctionField_normalizedCoordinate
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) (l : Fin 3) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i
        (normalizedCoordinate 2 k i.1 l) =
      hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i
        (Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k i.1 H})
          (chartDehomogenization 2 k i.1 (MvPolynomial.X l))) := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  unfold hypersurfaceStandardChartToSchemeFunctionField
  unfold hypersurfaceAffineChartQuotientMap
  simp only [RingHom.comp_apply]
  congr 2
  exact standardChartRingEquivMvPolynomial_normalizedCoordinate_eq_chartDehomogenization_X
    2 k i.1 l

/-- Homogeneous chart equations satisfy their canonical scaling law in the intrinsic
hypersurface function field. -/
theorem hypersurfaceStandardChartEquation_intrinsic_transition
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i b : NonemptyHypersurfaceChart H) {e : ℕ}
    (P : MvPolynomial (Fin 3) k) (hP : P.IsHomogeneous e) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i
        (hypersurfaceChartEquation 2 k i.1 P) =
      hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i
          (normalizedCoordinate 2 k i.1 b.1) ^ e *
        hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr b
          (hypersurfaceChartEquation 2 k b.1 P) := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  let ψ := hypersurfaceOverlapToSchemeFunctionField H hH hd hHirr i b
  have hover := hypersurfaceChartEquation_overlap 2 k i.1 b.1 P hP
  have hmapped := congrArg ψ hover
  simp only [map_mul, map_pow] at hmapped
  change (ψ.comp (toOverlap 2 k i.1 b.1))
      (hypersurfaceChartEquation 2 k i.1 P) =
    (ψ.comp (toOverlap 2 k i.1 b.1))
        (normalizedCoordinate 2 k i.1 b.1) ^ e *
      (ψ.comp (fromOtherToOverlap 2 k i.1 b.1))
        (hypersurfaceChartEquation 2 k b.1 P) at hmapped
  rw [hypersurfaceOverlapToSchemeFunctionField_comp_toOverlap
    H hH hd hHirr i b] at hmapped
  rw [hypersurfaceOverlapToSchemeFunctionField_comp_fromOtherToOverlap
    H hH hd hHirr i b] at hmapped
  exact hmapped

/-- Canonical cross-chart identity for dehomogenizations of a homogeneous polynomial.

Writing `z = X_b / X_i` in the intrinsic function field, this is
`P_i = z ^ e * P_b`. -/
theorem hypersurfaceChartDehomogenization_intrinsic_transition_mul
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i b : NonemptyHypersurfaceChart H) {e : ℕ}
    (P : MvPolynomial (Fin 3) k) (hP : P.IsHomogeneous e) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i
        (Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k i.1 H})
          (chartDehomogenization 2 k i.1 P)) =
      hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i
          (Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k i.1 H})
            (chartDehomogenization 2 k i.1 (MvPolynomial.X b.1))) ^ e *
        hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr b
          (Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k b.1 H})
            (chartDehomogenization 2 k b.1 P)) := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  simpa only [hypersurfaceStandardChartToSchemeFunctionField_chartEquation,
    hypersurfaceStandardChartToSchemeFunctionField_normalizedCoordinate] using
    hypersurfaceStandardChartEquation_intrinsic_transition
      H hH hd hHirr i b P hP

/-- The normalized coordinate in the explicit chart fraction field maps to the canonical
normalized coordinate in the intrinsic function field. -/
theorem hypersurfaceFunctionFieldEquivSchemeFunctionField_normalizedCoordinate
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) (l : Fin 3) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    hypersurfaceFunctionFieldEquivSchemeFunctionField H hH hd hHirr i
        (hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i l) =
      hypersurfaceStandardChartToSchemeFunctionField H hH hd hHirr i
        (normalizedCoordinate 2 k i.1 l) := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  rw [hypersurfaceNormalizedCoordinateInFunctionField_eq_algebraMap
    H hH hHirr i l]
  rw [hypersurfaceFunctionFieldEquivSchemeFunctionField_algebraMap
    H hH hd hHirr i]
  exact (hypersurfaceStandardChartToSchemeFunctionField_normalizedCoordinate
    H hH hd hHirr i l).symm

/-- Coordinate-normalized form of the intrinsic transition identity.

The factor is the image of `X_b / X_i` under the canonical equivalence from the anchor
chart's fraction field to the intrinsic function field. -/
theorem hypersurfaceChartDehomogenization_intrinsic_transition
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i b : NonemptyHypersurfaceChart H) {e : ℕ}
    (P : MvPolynomial (Fin 3) k) (hP : P.IsHomogeneous e) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i
        (Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k i.1 H})
          (chartDehomogenization 2 k i.1 P)) =
      (hypersurfaceFunctionFieldEquivSchemeFunctionField H hH hd hHirr i
          (hypersurfaceNormalizedCoordinateInFunctionField
            H hH hHirr i b.1)) ^ e *
        hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr b
          (Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k b.1 H})
            (chartDehomogenization 2 k b.1 P)) := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  have htransition := hypersurfaceChartDehomogenization_intrinsic_transition_mul
    H hH hd hHirr i b P hP
  have hz := hypersurfaceFunctionFieldEquivSchemeFunctionField_normalizedCoordinate
    H hH hd hHirr i b.1
  rw [hypersurfaceStandardChartToSchemeFunctionField_normalizedCoordinate]
    at hz
  rw [← hz] at htransition
  exact htransition

/-- Solved cross-chart transition identity.

Equivalently, the chart-`b` dehomogenization is obtained from the chart-`i`
dehomogenization by multiplying by `(X_b / X_i)⁻¹` to the homogeneous degree. -/
theorem hypersurfaceChartDehomogenization_intrinsic_transition_inv
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i b : NonemptyHypersurfaceChart H) {e : ℕ}
    (P : MvPolynomial (Fin 3) k) (hP : P.IsHomogeneous e) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr b
        (Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k b.1 H})
          (chartDehomogenization 2 k b.1 P)) =
      (hypersurfaceFunctionFieldEquivSchemeFunctionField H hH hd hHirr i
          (hypersurfaceNormalizedCoordinateInFunctionField
            H hH hHirr i b.1))⁻¹ ^ e *
        hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i
          (Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k i.1 H})
            (chartDehomogenization 2 k i.1 P)) := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  letI : IsDomain (HypersurfaceChartQuotient H i.1) :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  let z := hypersurfaceFunctionFieldEquivSchemeFunctionField H hH hd hHirr i
    (hypersurfaceNormalizedCoordinateInFunctionField H hH hHirr i b.1)
  let Pi := hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i
    (Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k i.1 H})
      (chartDehomogenization 2 k i.1 P))
  let Pb := hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr b
    (Ideal.Quotient.mk (Ideal.span {chartDehomogenization 2 k b.1 H})
      (chartDehomogenization 2 k b.1 P))
  have hz0 : z ≠ 0 := by
    dsimp only [z]
    exact (map_ne_zero
      (hypersurfaceFunctionFieldEquivSchemeFunctionField H hH hd hHirr i)).mpr
        (hypersurfaceNormalizedCoordinateInFunctionField_ne_zero
          H hH hHirr i b)
  have htransition : Pi = z ^ e * Pb := by
    exact hypersurfaceChartDehomogenization_intrinsic_transition
      H hH hd hHirr i b P hP
  have hzpow : z ^ e ≠ 0 := pow_ne_zero e hz0
  calc
    Pb = 1 * Pb := (one_mul Pb).symm
    _ = (z ^ e)⁻¹ * (z ^ e) * Pb := by
      rw [inv_mul_cancel₀ hzpow]
    _ = z⁻¹ ^ e * (z ^ e * Pb) := by
      rw [inv_pow, mul_assoc]
    _ = z⁻¹ ^ e * Pi := by rw [← htransition]

end ProjectiveSpace

end

end BConicBundleMultisections

end
