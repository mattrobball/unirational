/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualDiscriminantAvoidance
public import BConicBundleMultisections.ResidualTargetRelationConstantLine

/-!
# Horizontality from target-relation membership away from the discriminant

Let `H` be an irreducible homogeneous relation on the residual target coordinates.  If the
residual surface meets the complement of the conic discriminant, then `H` does not divide that
discriminant.  The geometric complete-intersection argument is therefore needed only for such
`H`: it must show that the residual equation belongs to `(F,H(y))`.  Once this membership is
known, bidegree forces the residual line to be constant, contradicting G3.

The predicate below is the exact algebraic output expected from the target-relation integrality
and generic-fibre-exhaustion argument.  It does not hide those geometric inputs.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open _root_.MvPolynomial

universe u

/-- The exact target-relation membership supplied by the complete-intersection exhaustion
argument, restricted to irreducible homogeneous relations not dividing the conic discriminant. -/
def ResidualTargetRelationMembershipAwayDiscriminantOn
    {K : Type u} [Field K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K) : Prop :=
  ∀ (H : MvPolynomial (Fin 3) K) (d : ℕ),
    Irreducible H → H.IsHomogeneous d → 0 < d →
      aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0 →
        ¬ H ∣ sndConicDiscriminant F →
        residualEquationOn (lineFrame p₀ q₀ r) N F ∈
          Ideal.span {F, MvPolynomial.rename Sum.inr H}

/-- G3, discriminant avoidance, and target-relation membership exclude every nonzero
homogeneous relation on the residual target coordinates. -/
theorem eq_zero_of_aeval_residualYCoordsOn_of_membershipAwayDiscriminant
    {K : Type u} [Field K] [Infinite K]
    (p₀ q₀ r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial K)
    (hgood : ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F)
    (havoid : ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v)
    (hmembership :
      ResidualTargetRelationMembershipAwayDiscriminantOn p₀ q₀ r N F v)
    (d : ℕ) (Psi : MvPolynomial (Fin 3) K) (hPsi : Psi.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) Psi = 0) :
    Psi = 0 := by
  rcases Nat.eq_zero_or_pos d with rfl | hd
  · rw [← totalDegree_zero_iff_isHomogeneous, totalDegree_eq_zero_iff_eq_C] at hPsi
    rw [hPsi] at hvan ⊢
    simpa using hvan
  · by_contra hPsi0
    obtain ⟨H, e, hHirr, hHhom, he, _hHdPsi, hHvan⟩ :=
      MvPolynomial.exists_irreducible_isHomogeneous_dvd_aeval_eq_zero
        hPsi hPsi0 hd (residualYCoordsOn p₀ q₀ r N F v) hvan
    have hHdisc : ¬ H ∣ sndConicDiscriminant F :=
      not_dvd_sndConicDiscriminant_of_aeval_residualYCoordsOn_eq_zero
        p₀ q₀ r N F v H hHvan havoid
    have hmem := hmembership H e hHirr hHhom he hHvan hHdisc
    apply hgood
    exact residualLineConstantOn_of_mem_targetRelation
      (lineFrame p₀ q₀ r) N hF
      (ResidualPrimitiveEquation.residualEquationOn_ne_zero_of_nonconstant
        (lineFrame p₀ q₀ r) N F hgood)
      hHhom he hmem

end

end BConicBundleMultisections
