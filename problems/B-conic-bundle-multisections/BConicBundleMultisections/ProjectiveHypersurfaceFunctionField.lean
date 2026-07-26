/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.IntegralFunctionFieldGluing
public import BConicBundleMultisections.IrreducibleProjectiveHypersurfaceIntegral
public import Mathlib.AlgebraicGeometry.Morphisms.IsIso

/-!
# Explicit chart presentations of a projective hypersurface function field

This file compares the fraction field of a retained affine hypersurface chart with the intrinsic
function field of the integral projective hypersurface.  It also records the concrete ring
equivalence between the chart quotient and regular functions on the corresponding open subset.

These maps are the bookkeeping needed to glue chartwise representatives of homogeneous rational
functions.  No choice of an affine cone, saturation, or normality hypothesis is involved.
-/

@[expose] public section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial

namespace ProjectiveSpace

variable {k : Type u} [Field k]

/-- The image open of a retained affine chart in the projective hypersurface. -/
def hypersurfaceRetainedChartOpen
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (i : NonemptyHypersurfaceChart H) :
    (projectiveZeroLocus 2 k H).Opens :=
  (hypersurfaceChartToGlobal 2 k H hH i.1).opensRange

/-- A retained chart is nonempty as an open subset of the projective hypersurface. -/
instance hypersurfaceRetainedChartOpen_nonempty
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (i : NonemptyHypersurfaceChart H) :
    Nonempty (hypersurfaceRetainedChartOpen H hH i) := by
  let U := (hypersurfaceChartIdealSheaf 2 k i.1 H).subscheme
  let A := HypersurfaceChartQuotient H i.1
  haveI : Nontrivial A := Ideal.Quotient.nontrivial_iff.mpr
    (Ideal.span_singleton_ne_top i.2)
  haveI : Nonempty (Spec (.of A)) := inferInstance
  haveI : Nonempty U := ⟨
    (hypersurfaceChartIsoSpecAffineQuotient 2 k i.1 H).inv
      (Classical.choice (inferInstance : Nonempty (Spec (.of A))))⟩
  let f := hypersurfaceChartToGlobal 2 k H hH i.1
  exact ⟨⟨f (Classical.choice (inferInstance : Nonempty U)),
    ⟨_, rfl⟩⟩⟩

/-- The explicit affine quotient is canonically the ring of regular functions on its image open
inside the projective hypersurface. -/
noncomputable def hypersurfaceChartQuotientEquivSections
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (i : NonemptyHypersurfaceChart H) :
    HypersurfaceChartQuotient H i.1 ≃+*
      Γ(projectiveZeroLocus 2 k H, hypersurfaceRetainedChartOpen H hH i) := by
  let e := hypersurfaceChartIsoSpecAffineQuotient 2 k i.1 H
  let eΓ : Γ(Spec (.of (HypersurfaceChartQuotient H i.1)), ⊤) ≅
      Γ((hypersurfaceChartIdealSheaf 2 k i.1 H).subscheme, ⊤) := {
    hom := e.hom.appTop
    inv := e.inv.appTop
    hom_inv_id := by
      rw [← Scheme.Hom.comp_appTop, e.inv_hom_id]
      rfl
    inv_hom_id := by
      rw [← Scheme.Hom.comp_appTop, e.hom_inv_id]
      rfl
    }
  let e₁ := CategoryTheory.Iso.commRingCatIsoToRingEquiv
    (Scheme.ΓSpecIso (.of (HypersurfaceChartQuotient H i.1))).symm
  let e₂ := CategoryTheory.Iso.commRingCatIsoToRingEquiv
    eΓ
  let e₃ := CategoryTheory.Iso.commRingCatIsoToRingEquiv
    (IsOpenImmersion.ΓIsoTop
      (hypersurfaceChartToGlobal 2 k H hH i.1))
  exact e₁.trans (e₂.trans e₃)

/-- Restricting a global section and applying the inverse explicit chart equivalence is the same
as pulling the section all the way back to the explicit affine spectrum. -/
theorem hypersurfaceChartQuotientEquivSections_symm_restrict
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (i : NonemptyHypersurfaceChart H)
    (s : Γ(projectiveZeroLocus 2 k H, ⊤)) :
    (hypersurfaceChartQuotientEquivSections H hH i).symm
        ((projectiveZeroLocus 2 k H).presheaf.map
          (homOfLE (show hypersurfaceRetainedChartOpen H hH i ≤
            (⊤ : (projectiveZeroLocus 2 k H).Opens) from le_top)).op s) =
      (Scheme.ΓSpecIso (.of (HypersurfaceChartQuotient H i.1))).hom
        ((hypersurfaceChartIsoSpecAffineQuotient 2 k i.1 H).inv.appTop
          ((hypersurfaceChartToGlobal 2 k H hH i.1).appTop s)) := by
  let X := projectiveZeroLocus 2 k H
  let f := hypersurfaceChartToGlobal 2 k H hH i.1
  let e := hypersurfaceChartIsoSpecAffineQuotient 2 k i.1 H
  change (Scheme.ΓSpecIso (.of (HypersurfaceChartQuotient H i.1))).hom
      (e.inv.appTop
        ((IsOpenImmersion.ΓIsoTop f).inv
          (X.presheaf.map
            (homOfLE (show f.opensRange ≤ (⊤ : X.Opens) from le_top)).op s))) =
    (Scheme.ΓSpecIso (.of (HypersurfaceChartQuotient H i.1))).hom
      (e.inv.appTop (f.appTop s))
  congr 2
  have hΓ :
      X.presheaf.map
          (homOfLE (show f.opensRange ≤ (⊤ : X.Opens) from le_top)).op ≫
        (IsOpenImmersion.ΓIsoTop f).inv = f.appTop := by
    simp only [IsOpenImmersion.ΓIsoTop, Iso.trans_inv,
      Functor.mapIso_inv, Iso.op_inv, eqToIso.inv, eqToHom_op,
      Iso.symm_inv, Scheme.Hom.appIso_hom',
      Scheme.Hom.map_appLE]
    unfold Scheme.Hom.appLE
    change f.appTop ≫ _ = f.appTop
    rw [← Category.comp_id f.appTop]
    congr 1
    rw [← (hypersurfaceChartIdealSheaf 2 k i.1 H).subscheme.presheaf.map_id]
    exact congrArg
      (hypersurfaceChartIdealSheaf 2 k i.1 H).subscheme.presheaf.map
      (Subsingleton.elim _ _)
  rw [← CommRingCat.comp_apply, hΓ]

/-- The chart quotient maps to the intrinsic function field by viewing a quotient class as a
regular function on the retained chart and taking its germ at the generic point. -/
noncomputable def hypersurfaceChartQuotientToSchemeFunctionField
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    HypersurfaceChartQuotient H i.1 →+*
      (projectiveZeroLocus 2 k H).functionField := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  exact ((projectiveZeroLocus 2 k H).germToFunctionField
    (hypersurfaceRetainedChartOpen H hH i)).hom.comp
      (hypersurfaceChartQuotientEquivSections H hH i).toRingHom

/-- The coordinate ring of every retained affine chart embeds in the intrinsic function field
of an irreducible positive-degree projective hypersurface. -/
theorem hypersurfaceChartQuotientToSchemeFunctionField_injective
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    Function.Injective
      (hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i) := by
  let X := projectiveZeroLocus 2 k H
  let U := hypersurfaceRetainedChartOpen H hH i
  let e := hypersurfaceChartQuotientEquivSections H hH i
  letI : IsIntegral X := by
    dsimp only [X]
    exact isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  change Function.Injective ((X.germToFunctionField U).hom.comp e.toRingHom)
  exact (X.germToFunctionField_injective U).comp e.injective

/-- The explicit chart fraction field is canonically isomorphic to the intrinsic function field
of the integral projective hypersurface. -/
noncomputable def hypersurfaceFunctionFieldEquivSchemeFunctionField
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    HypersurfaceFunctionField H i ≃+*
      (projectiveZeroLocus 2 k H).functionField := by
  let X := projectiveZeroLocus 2 k H
  let A := HypersurfaceChartQuotient H i.1
  let U := hypersurfaceRetainedChartOpen H hH i
  let e := hypersurfaceChartQuotientEquivSections H hH i
  letI : IsIntegral X := by
    dsimp only [X]
    exact isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  letI : Algebra A X.functionField :=
    (hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i).toAlgebra
  letI : IsAffine
      ((hypersurfaceChartIdealSheaf 2 k i.1 H).subscheme) :=
    IsAffine.of_isIso
      (hypersurfaceChartIsoSpecAffineQuotient 2 k i.1 H).hom
  haveI : IsAffineOpen U :=
    isAffineOpen_opensRange (hypersurfaceChartToGlobal 2 k H hH i.1)
  letI : IsFractionRing Γ(X, U) X.functionField :=
    functionField_isFractionRing_of_isAffineOpen X U
      (isAffineOpen_opensRange (hypersurfaceChartToGlobal 2 k H hH i.1))
  have hcompat (a : A) :
      algebraMap A X.functionField a =
        algebraMap Γ(X, U) X.functionField (e a) := by
    rfl
  letI : IsFractionRing A X.functionField :=
    IsFractionRing.of_ringEquiv_left e hcompat
  exact (FractionRing.algEquiv A X.functionField).toRingEquiv

/-- The function-field comparison extends the defining chart-quotient map. -/
theorem hypersurfaceFunctionFieldEquivSchemeFunctionField_algebraMap
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (a : HypersurfaceChartQuotient H i.1) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    hypersurfaceFunctionFieldEquivSchemeFunctionField H hH hd hHirr i
        (algebraMap (HypersurfaceChartQuotient H i.1)
          (HypersurfaceFunctionField H i) a) =
      hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i a := by
  let X := projectiveZeroLocus 2 k H
  let A := HypersurfaceChartQuotient H i.1
  let U := hypersurfaceRetainedChartOpen H hH i
  let e := hypersurfaceChartQuotientEquivSections H hH i
  letI : IsIntegral X := by
    dsimp only [X]
    exact isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  letI : Algebra A X.functionField :=
    (hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i).toAlgebra
  letI : IsAffine
      ((hypersurfaceChartIdealSheaf 2 k i.1 H).subscheme) :=
    IsAffine.of_isIso
      (hypersurfaceChartIsoSpecAffineQuotient 2 k i.1 H).hom
  haveI : IsAffineOpen U :=
    isAffineOpen_opensRange (hypersurfaceChartToGlobal 2 k H hH i.1)
  letI : IsFractionRing Γ(X, U) X.functionField :=
    functionField_isFractionRing_of_isAffineOpen X U
      (isAffineOpen_opensRange (hypersurfaceChartToGlobal 2 k H hH i.1))
  have hcompat (a : A) :
      algebraMap A X.functionField a =
        algebraMap Γ(X, U) X.functionField (e a) := by
    rfl
  letI : IsFractionRing A X.functionField :=
    IsFractionRing.of_ringEquiv_left e hcompat
  change (FractionRing.algEquiv A X.functionField)
      (algebraMap A (FractionRing A) a) = algebraMap A X.functionField a
  exact (FractionRing.algEquiv A X.functionField).commutes a

end ProjectiveSpace

end

end BConicBundleMultisections

end
