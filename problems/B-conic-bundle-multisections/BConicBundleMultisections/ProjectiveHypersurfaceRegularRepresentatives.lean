/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveHypersurfaceFunctionField

/-!
# Gluing regular representatives on retained hypersurface charts

This module packages the exact transition-compatible input needed by the residual negative-twist
argument.  A rational function on an integral projective hypersurface extends globally if it has
a regular representative on every retained standard chart and all those representatives map to
the same intrinsic function-field element.  Equality in the function field automatically gives
overlap compatibility, so no separate affine-cone saturation statement is involved.
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

/-- A rational function on the integral projective hypersurface is represented by an element of
every retained affine chart quotient, with all representatives mapping to the same intrinsic
function-field element.  This equality is the precise transition-compatibility condition. -/
def HasRegularRetainedChartRepresentatives
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    (projectiveZeroLocus 2 k H).functionField → Prop := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  exact fun g ↦
    ∃ r : (i : NonemptyHypersurfaceChart H) →
        HypersurfaceChartQuotient H i.1,
      ∀ i : NonemptyHypersurfaceChart H,
        hypersurfaceChartQuotientToSchemeFunctionField
          H hH hd hHirr i (r i) = g

set_option maxHeartbeats 800000 in
-- The lifted index type is needed because the sheaf-gluing theorem uses the scheme universe.
/-- Explicit retained-chart representatives of one intrinsic rational function glue to a global
section with the prescribed restriction on every retained chart. -/
theorem exists_globalSection_restrict_eq_of_eq_functionField_on_retainedCharts
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (r : (i : NonemptyHypersurfaceChart H) →
      HypersurfaceChartQuotient H i.1)
    (g :
      letI : IsIntegral (projectiveZeroLocus 2 k H) :=
        isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
      (projectiveZeroLocus 2 k H).functionField)
    (hr : ∀ i : NonemptyHypersurfaceChart H,
      hypersurfaceChartQuotientToSchemeFunctionField
        H hH hd hHirr i (r i) = g) :
    ∃ t : Γ(projectiveZeroLocus 2 k H, ⊤),
      ∀ i : NonemptyHypersurfaceChart H,
        (projectiveZeroLocus 2 k H).presheaf.map
            (homOfLE (show hypersurfaceRetainedChartOpen H hH i ≤
              (⊤ : (projectiveZeroLocus 2 k H).Opens) from le_top)).op t =
          hypersurfaceChartQuotientEquivSections H hH i (r i) := by
  let X := projectiveZeroLocus 2 k H
  letI : IsIntegral X := by
    dsimp only [X]
    exact isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  let ι := ULift.{u} (NonemptyHypersurfaceChart H)
  let U : ι → X.Opens :=
    fun i ↦ hypersurfaceRetainedChartOpen H hH i.down
  have hU (i : ι) : Nonempty (U i) := by
    dsimp only [U, X]
    infer_instance
  letI hUi (i : ι) : Nonempty (U i) := hU i
  let s : (i : ι) → Γ(X, U i) :=
    fun i ↦ hypersurfaceChartQuotientEquivSections H hH i.down (r i.down)
  have hs (i : ι) : X.germToFunctionField (U i) (s i) = g := by
    change hypersurfaceChartQuotientToSchemeFunctionField
      H hH hd hHirr i.down (r i.down) = g
    exact hr i.down
  have hcover : (⊤ : X.Opens) ≤ iSup U := by
    let C := nonemptyHypersurfaceOpenCover H hH
    intro x _hx
    apply Opens.mem_iSup.mpr
    refine ⟨ULift.up (C.idx x), ?_⟩
    exact C.covers x
  obtain ⟨t, ht⟩ :=
    exists_globalSection_of_eq_germToFunctionField_on_cover
      (X := X) (ι := ι) U hU hcover s g hs
  refine ⟨t, fun i ↦ ?_⟩
  simpa [U, s, X] using ht (ULift.up i)

set_option maxHeartbeats 800000 in
-- The dependent retained-chart cover and its intrinsic function fields require extra elaboration.
/-- Regular retained-chart representatives of one intrinsic rational function glue to a global
regular function whose generic germ is that rational function. -/
theorem exists_globalSection_of_hasRegularRetainedChartRepresentatives
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (g :
      letI : IsIntegral (projectiveZeroLocus 2 k H) :=
        isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
      (projectiveZeroLocus 2 k H).functionField)
    (hreg : HasRegularRetainedChartRepresentatives H hH hd hHirr g) :
    letI : IsIntegral (projectiveZeroLocus 2 k H) :=
      isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    ∃ t : Γ(projectiveZeroLocus 2 k H, ⊤),
      letI : Nonempty (⊤ : (projectiveZeroLocus 2 k H).Opens) :=
        ⟨⟨genericPoint (projectiveZeroLocus 2 k H), trivial⟩⟩
      (projectiveZeroLocus 2 k H).germToFunctionField ⊤ t = g := by
  let X := projectiveZeroLocus 2 k H
  letI : IsIntegral X := by
    dsimp only [X]
    exact isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  let ι := ULift.{u} (NonemptyHypersurfaceChart H)
  let U : ι → X.Opens :=
    fun i ↦ hypersurfaceRetainedChartOpen H hH i.down
  have hU (i : ι) : Nonempty (U i) := by
    dsimp only [U, X]
    infer_instance
  letI hUi (i : ι) : Nonempty (U i) := hU i
  letI : Nonempty (⊤ : X.Opens) := ⟨⟨genericPoint X, trivial⟩⟩
  change ∃ t : Γ(X, ⊤), X.germToFunctionField ⊤ t = g
  change ∃ r : (i : NonemptyHypersurfaceChart H) →
      HypersurfaceChartQuotient H i.1,
    ∀ i : NonemptyHypersurfaceChart H,
      hypersurfaceChartQuotientToSchemeFunctionField
        H hH hd hHirr i (r i) = g at hreg
  obtain ⟨r, hr⟩ := hreg
  let s : (i : ι) → Γ(X, U i) :=
    fun i ↦ hypersurfaceChartQuotientEquivSections H hH i.down (r i.down)
  have hs (i : ι) :
      X.germToFunctionField (U i) (s i) = g := by
    change hypersurfaceChartQuotientToSchemeFunctionField
      H hH hd hHirr i.down (r i.down) = g
    exact hr i.down
  have hcover : (⊤ : X.Opens) ≤ iSup U := by
    let C := nonemptyHypersurfaceOpenCover H hH
    intro x _hx
    apply Opens.mem_iSup.mpr
    refine ⟨ULift.up (C.idx x), ?_⟩
    exact C.covers x
  obtain ⟨t, ht⟩ :=
    exists_globalSection_of_eq_germToFunctionField_on_cover
      (X := X) (ι := ι) U hU hcover s g hs
  refine ⟨t, ?_⟩
  let i₀ : ι := ULift.up
    (Classical.choice (nonempty_nonemptyHypersurfaceChart H hH hd hHirr))
  calc
    X.germToFunctionField ⊤ t =
        X.germToFunctionField (U i₀)
          (X.presheaf.map
            (homOfLE (show U i₀ ≤ (⊤ : X.Opens) from le_top)).op t) := by
      change X.presheaf.germ ⊤ (genericPoint X) _ t =
        X.presheaf.germ (U i₀) (genericPoint X) _
          (X.presheaf.map
            (homOfLE (show U i₀ ≤ (⊤ : X.Opens) from le_top)).op t)
      rw [X.presheaf.germ_res_apply]
    _ = X.germToFunctionField (U i₀) (s i₀) := by rw [ht i₀]
    _ = g := hs i₀

end ProjectiveSpace

end

end BConicBundleMultisections
