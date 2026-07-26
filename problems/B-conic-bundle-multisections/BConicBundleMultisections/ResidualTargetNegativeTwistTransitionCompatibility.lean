/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveHypersurfaceNegativeTwistComparison
public import BConicBundleMultisections.ProjectiveHypersurfaceRegularRepresentatives
public import BConicBundleMultisections.ResidualTargetNegativeTwistGenericFiber

/-!
# Transition-compatible retained-chart representatives for negative twists

This module replaces the abstract global-extension hypothesis in the generic negative-twist
endpoint by explicit chart data.  A function-field element has compatible retained-chart
representatives when it is represented regularly on every nonempty standard chart of `V(H)`,
all representatives have the same image in the intrinsic function field, and the representative
on one chosen chart maps to the specified element of that chart's explicit fraction field.

For a local residual quotient, the intended representatives are the coefficients of
`P_b * R_b`, where `P` is a homogeneous target quadratic.  The bidegree transition formula
`R_b' = (Y_b' / Y_b)^2 R_b` makes those representatives compatible.  The theorems below show
that this compatibility is exactly enough to glue, extend globally, and force the quotient to
vanish.  The transition formula itself remains a separate concrete polynomial calculation.
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

/-- Explicit, anchored transition compatibility for a chart-function-field element.

The family `r` gives a regular representative on every retained chart.  The second clause says
that all representatives define the same intrinsic rational function; the first clause anchors
that common rational function to the specified element `s` in the chosen explicit fraction
field. -/
def HasCompatibleRetainedChartRepresentativesAt
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (s : HypersurfaceFunctionField H i) : Prop := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  exact ∃ r : (b : NonemptyHypersurfaceChart H) →
      HypersurfaceChartQuotient H b.1,
    hypersurfaceChartQuotientToFunctionField H hH hHirr i (r i) = s ∧
      ∀ b : NonemptyHypersurfaceChart H,
        hypersurfaceChartQuotientToSchemeFunctionField
            H hH hd hHirr b (r b) =
          hypersurfaceChartQuotientToSchemeFunctionField
            H hH hd hHirr i (r i)

/-- Anchored transition-compatible retained-chart representatives glue to a global function
whose image under the canonical explicit comparison is the specified chart-function-field
element. -/
theorem exists_globalSection_toFunctionField_eq_of_hasCompatibleRetainedChartRepresentativesAt
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (s : HypersurfaceFunctionField H i)
    (hcompat : HasCompatibleRetainedChartRepresentativesAt
      H hH hd hHirr i s) :
    ∃ t : Γ(projectiveZeroLocus 2 k H, ⊤),
      globalSectionsToHypersurfaceFunctionField H hH hHirr i t = s := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  change ∃ r : (b : NonemptyHypersurfaceChart H) →
      HypersurfaceChartQuotient H b.1,
    hypersurfaceChartQuotientToFunctionField H hH hHirr i (r i) = s ∧
      ∀ b : NonemptyHypersurfaceChart H,
        hypersurfaceChartQuotientToSchemeFunctionField
            H hH hd hHirr b (r b) =
          hypersurfaceChartQuotientToSchemeFunctionField
            H hH hd hHirr i (r i) at hcompat
  obtain ⟨r, hri, hr⟩ := hcompat
  let g := hypersurfaceChartQuotientToSchemeFunctionField
    H hH hd hHirr i (r i)
  obtain ⟨t, ht⟩ :=
    exists_globalSection_restrict_eq_of_eq_functionField_on_retainedCharts
      H hH hd hHirr r g hr
  refine ⟨t, ?_⟩
  unfold globalSectionsToHypersurfaceFunctionField
  simp only [RingHom.comp_apply]
  rw [ht i]
  have hcancel :
      (hypersurfaceChartQuotientEquivSections H hH i).symm
          (hypersurfaceChartQuotientEquivSections H hH i (r i)) = r i :=
    (hypersurfaceChartQuotientEquivSections H hH i).symm_apply_apply (r i)
  have hmapped := congrArg
    (algebraMap (HypersurfaceChartQuotient H i.1)
      (HypersurfaceFunctionField H i)) hcancel
  exact hmapped.trans hri

/-- Homogeneous quadratic multiples extend globally as soon as they have explicit compatible
retained-chart representatives. -/
theorem homogeneousQuadraticMultiplesExtendToGlobal_of_compatibleRetainedChartRepresentatives
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (s : HypersurfaceFunctionField H i)
    (hcompat : ∀ P : MvPolynomial (Fin 3) k, P.IsHomogeneous 2 →
      HasCompatibleRetainedChartRepresentativesAt H hH hd hHirr i
        (hypersurfaceHomogeneousPolynomialToFunctionField H hH hHirr i P * s)) :
    HomogeneousQuadraticMultiplesExtendToGlobal H hH hHirr i
      (canonicalGlobalSectionsToHypersurfaceFunctionFieldComparison H hH hHirr i) s := by
  intro P hP
  obtain ⟨t, ht⟩ :=
    exists_globalSection_toFunctionField_eq_of_hasCompatibleRetainedChartRepresentativesAt
      H hH hd hHirr i _ (hcompat P hP)
  exact ⟨t, ht⟩

/-- The invariant all-quadratics extension condition implies the two-monomial extension
condition used by the minimal negative-twist endpoint. -/
theorem quadraticMultiplesExtendToGlobal_of_homogeneousQuadraticMultiplesExtendToGlobal
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (comparison :
      GlobalSectionsToHypersurfaceFunctionFieldComparison H hH hHirr i)
    (s : HypersurfaceFunctionField H i)
    (hext : HomogeneousQuadraticMultiplesExtendToGlobal
      H hH hHirr i comparison s) :
    QuadraticMultiplesExtendToGlobal H hH hHirr i comparison s := by
  constructor
  · have hhom : (MvPolynomial.X i.1 ^ 2 :
        MvPolynomial (Fin 3) k).IsHomogeneous 2 := by
      simpa using (MvPolynomial.isHomogeneous_X k i.1).pow 2
    obtain ⟨t, ht⟩ := hext (MvPolynomial.X i.1 ^ 2) hhom
    refine ⟨t, ?_⟩
    simpa using ht
  · intro j _hji
    have hhom : (MvPolynomial.X i.1 * MvPolynomial.X j :
        MvPolynomial (Fin 3) k).IsHomogeneous 2 := by
      simpa using
        (MvPolynomial.isHomogeneous_X k i.1).mul
          (MvPolynomial.isHomogeneous_X k j)
    obtain ⟨t, ht⟩ := hext (MvPolynomial.X i.1 * MvPolynomial.X j) hhom
    refine ⟨t, ?_⟩
    simpa using ht

/-- Coefficientwise transition-compatible representatives of every quadratic multiple force a
polynomial over a retained chart ring to vanish.  This is the concrete projective-degree
endpoint consumed by the residual quotient. -/
theorem mvPolynomial_eq_zero_of_coeff_compatibleRetainedChartRepresentatives
    [IsAlgClosed k] {σ : Type*}
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (R : MvPolynomial σ (HypersurfaceChartQuotient H i.1))
    (hcompat : ∀ (e : σ →₀ ℕ) (P : MvPolynomial (Fin 3) k),
      P.IsHomogeneous 2 →
        HasCompatibleRetainedChartRepresentativesAt H hH hd hHirr i
          (hypersurfaceHomogeneousPolynomialToFunctionField H hH hHirr i P *
            hypersurfaceChartQuotientToFunctionField H hH hHirr i (R.coeff e))) :
    R = 0 := by
  apply mvPolynomial_eq_zero_of_coeff_homogeneousQuadraticMultiples_extendToGlobal
    H hH hd hHirr i
      (canonicalGlobalSectionsToHypersurfaceFunctionFieldComparison H hH hHirr i) R
  intro e
  exact homogeneousQuadraticMultiplesExtendToGlobal_of_compatibleRetainedChartRepresentatives
    H hH hd hHirr i _ (hcompat e)

end ProjectiveSpace

end

end BConicBundleMultisections
