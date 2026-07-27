/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Standard.G3G4NonsingularLineSelection

/-!
# Certificate-rich endpoint for nonsingular G3--G4 line selection

This small companion keeps the final packaging theorem separate from the shared line-selection
module.  All geometry is already isolated in
`G3FrameMeetsEveryNonemptyPrincipalOpenOnSmoothCubic`.
-/

@[expose] public section

namespace BConicBundleMultisections.Standard

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

/-- Certificate-rich common-line endpoint from the natural incidence-open principle. -/
theorem exists_actualG3G4LineSection_of_incidenceOpen
    {K : Type u} [Field K] [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (hinc : G3FrameMeetsEveryNonemptyPrincipalOpenOnSmoothCubic F) :
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
        (x : Fin 3 → K) (v : Fin 3 → Polynomial K) (u : Fin 3 → K),
      HasActualG3G4LineSection F p q r N v ∧
      TsenSectionRealizesCenterAt v 0 u ∧
      pointwiseG4StereoCertificateAt p q F v 0 x ≠ 0 ∧
      pointwiseG4StereoCertificatePoly p q F v x ≠ 0 := by
  obtain ⟨p, q, r, N, hMN, hG3, hpoint⟩ :=
    exists_G3_nonsingularFramedPointwiseG4Witness_of_incidenceOpen
      F hF hF0 hinc
  obtain ⟨x, v, u, hactual, hrealize, hcert, hcertPoly⟩ :=
    exists_actualG3G4LineSection_of_G3_of_nonsingularFramedPointwiseG4Witness
      F hF hF0 p q r N hMN hG3 hpoint
  exact ⟨p, q, r, N, x, v, u, hactual, hrealize, hcert, hcertPoly⟩

end

end BConicBundleMultisections.Standard
