/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.IrreducibleHomogeneousChart
public import BConicBundleMultisections.ResidualDiscriminantGenericConic

/-!
# The generic conic over a projective target-relation chart

Let `H` be an irreducible homogeneous equation in the second projective coordinates.  On a
nonempty standard chart `Y_j ≠ 0`, its dehomogenization is irreducible and the chart coordinate
ring is a domain.  If `H` does not divide the second-conic discriminant, dehomogenization preserves
that nondivisibility, so the discriminant remains nonzero in the chart ring.  The conic over the
fraction field of the chart ring is therefore nonsingular.

Unlike the affine-cone formulation, this chart formulation has removed the cone vertex.  It is
the direct algebraic input for identifying the generic fibre of the projective base change
`V(F) ×_{ℙ²_y} V(H)`.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open _root_.MvPolynomial

/-- The affine coordinate ring of the `j`-th standard chart of the projective hypersurface
`V(H)`. -/
abbrev targetRelationChartRing
    {k : Type u} [Field k] (j : Fin 3) (H : MvPolynomial (Fin 3) k) :=
  MvPolynomial (Fin 2) k ⧸
    Ideal.span {ProjectiveSpace.chartDehomogenization 2 k j H}

/-- The normalized homogeneous coordinates on a target-relation chart. -/
def targetRelationChartCoordinates
    {k : Type u} [Field k] (j : Fin 3) (H : MvPolynomial (Fin 3) k) :
    Fin 3 → targetRelationChartRing j H :=
  fun l ↦ Ideal.Quotient.mk
    (Ideal.span {ProjectiveSpace.chartDehomogenization 2 k j H})
      (ProjectiveSpace.chartDehomogenization 2 k j (MvPolynomial.X l))

/-- Evaluation at the normalized chart coordinates is dehomogenization followed by the quotient
map. -/
theorem aeval_targetRelationChartCoordinates
    {k : Type u} [Field k] (j : Fin 3) (H : MvPolynomial (Fin 3) k) :
    aeval (targetRelationChartCoordinates j H) =
      (Ideal.Quotient.mkₐ k
        (Ideal.span {ProjectiveSpace.chartDehomogenization 2 k j H})).comp
          (ProjectiveSpace.chartDehomogenization 2 k j) := by
  apply MvPolynomial.algHom_ext
  intro l
  simp [targetRelationChartCoordinates]

/-- Pointwise form of `aeval_targetRelationChartCoordinates`. -/
theorem aeval_targetRelationChartCoordinates_apply
    {k : Type u} [Field k] (j : Fin 3) (H P : MvPolynomial (Fin 3) k) :
    aeval (targetRelationChartCoordinates j H) P =
      Ideal.Quotient.mk
        (Ideal.span {ProjectiveSpace.chartDehomogenization 2 k j H})
          (ProjectiveSpace.chartDehomogenization 2 k j P) := by
  rw [aeval_targetRelationChartCoordinates]
  rfl

/-- On a nonempty target chart, avoidance of the homogeneous discriminant remains visible after
passing to the chart coordinate ring. -/
theorem sndConicDiscriminant_targetRelationChart_ne_zero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hHhom : H.IsHomogeneous d) (hHirr : Irreducible H)
    (j : Fin 3)
    (hnonempty :
      ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 k j H))
    (hdisc : ¬ H ∣ sndConicDiscriminant F) :
    aeval (targetRelationChartCoordinates j H) (sndConicDiscriminant F) ≠ 0 := by
  rw [aeval_targetRelationChartCoordinates_apply]
  exact ProjectiveSpace.quotient_mk_chartDehomogenization_ne_zero_of_not_dvd
    j H (sndConicDiscriminant F) hHhom hHirr
      (sndConicDiscriminant_isHomogeneous F hF) hnonempty hdisc

/-- The conic over the fraction field of every nonempty target-relation chart is nonsingular. -/
theorem sndConicAt_targetRelationChart_fraction_nonsingular
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hHhom : H.IsHomogeneous d) (hHirr : Irreducible H)
    (j : Fin 3)
    (hnonempty :
      ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 k j H))
    (hdisc : ¬ H ∣ sndConicDiscriminant F) :
    let A := targetRelationChartRing j H
    let y : Fin 3 → A := targetRelationChartCoordinates j H
    let Q : MvPolynomial (Fin 3) (FractionRing A) :=
      MvPolynomial.map (algebraMap A (FractionRing A)) (sndConicAt F y)
    Q.IsHomogeneous 2 ∧ Q ≠ 0 ∧
      ∀ x : Fin 3 → FractionRing A, x ≠ 0 → MvPolynomial.eval x Q = 0 →
        ∃ i, MvPolynomial.eval x (MvPolynomial.pderiv i Q) ≠ 0 := by
  dsimp only
  let A := targetRelationChartRing j H
  letI : IsDomain A :=
    ProjectiveSpace.isDomain_chartDehomogenization_quotient_of_irreducible
      j H hHhom hHirr hnonempty
  exact sndConicAt_fraction_nonsingular_of_discriminant_ne_zero F hF
    (targetRelationChartCoordinates j H)
      (sndConicDiscriminant_targetRelationChart_ne_zero
        F hF H hHhom hHirr j hnonempty hdisc)

end

end BConicBundleMultisections
