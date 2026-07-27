/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualComponentOnHorizontality
public import BConicBundleMultisections.ResidualPrimitiveDivisorExhaustion

/-!
# Arbitrary-line horizontality from primitive-divisor exhaustion

This file connects the source-faithful primitive-divisor interface to the existing arbitrary-line
residual-component construction.  The route deliberately does not use
`ResidualHorizontalityLine.det_residualYCoordsOn_ne_zero`: primitive-divisor exhaustion supplies
the stronger no-homogeneous-relation statement directly.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

/-- Primitive-divisor exhaustion makes the arbitrary-line residual second-coordinate triple a
genuine projective point, without passing through the Jacobian determinant frontier. -/
theorem residualYCoordsOn_ne_zero_of_sourceFaithfulGoodLine
    {k : Type u} [Field k] [IsAlgClosed k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hgood : SourceFaithfulGoodLineOn p₀ q₀ r N F v) :
    residualYCoordsOn p₀ q₀ r N F v ≠ 0 := by
  intro hzero
  have hvan : aeval (residualYCoordsOn p₀ q₀ r N F v)
      (X (0 : Fin 3) : MvPolynomial (Fin 3) k) = 0 := by
    rw [hzero]
    simp
  have hXzero := eq_zero_of_aeval_residualYCoordsOn_of_sourceFaithfulGoodLine
    p₀ q₀ r N F hF v hgood 1 (X (0 : Fin 3)) (isHomogeneous_X k 0) hvan
  exact (X_ne_zero (R := k) (0 : Fin 3)) hXzero

/-- The localized explicit arbitrary-line residual map dominates the second projective plane when
the primitive residual divisor is exhausted. -/
theorem isDominant_residualZeroLocusPointOn_toBase_of_sourceFaithfulGoodLine
    {k : Type u} [Field k] [IsAlgClosed k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hgood : SourceFaithfulGoodLineOn p₀ q₀ r N F v)
    (i j : Fin 3)
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    IsDominant
      (residualZeroLocusPointOn p₀ q₀ r N hgood.1 F hF v hv i j ≫
        biprojectiveZeroLocusSnd 2 2 k F) := by
  rw [residualZeroLocusPointOn_toBase]
  exact isDominant_pointOfNormalizedCoordinatesAlgebra 2 j _
    (ProjectiveSpace.isDominant_standardChartι 2 k j)
    (injective_standardChartEvalAlgebra_residualComponentOnYCoordsNorm
      p₀ q₀ r N F v i j hdenom
      (fun d Ψ hΨ hvan ↦
        eq_zero_of_aeval_residualYCoordsOn_of_sourceFaithfulGoodLine
          p₀ q₀ r N F hF v hgood d Ψ hΨ hvan))

/-- The scheme-theoretic arbitrary-line residual component dominates the base when the
source-faithful primitive residual divisor is exhausted. -/
theorem isDominant_residualComponentOnToBase_of_sourceFaithfulGoodLine
    {k : Type u} [Field k] [IsAlgClosed k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hgood : SourceFaithfulGoodLineOn p₀ q₀ r N F v)
    (i j : Fin 3)
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    IsDominant (residualComponentOnToBase p₀ q₀ r N hgood.1 F hF v hv i j) :=
  (isDominant_residualComponentOnToBase_iff p₀ q₀ r N hgood.1 F hF v hv i j).mpr
    (isDominant_residualZeroLocusPointOn_toBase_of_sourceFaithfulGoodLine
      p₀ q₀ r N F hF v hv hgood i j hdenom)

/-- A source-faithful good line and a nondegenerate stereographic section yield a standard chart
whose residual component dominates the conic-bundle base.  Unlike the older good-line endpoint,
this theorem needs neither the sorry-backed determinant theorem nor its auxiliary Jacobian
hypotheses. -/
theorem exists_isDominant_residualComponentOnToBase_of_sourceFaithfulGoodLine
    {k : Type u} [Field k] [IsAlgClosed k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0)
    (hgood : SourceFaithfulGoodLineOn p₀ q₀ r N F v) :
    ∃ i j : Fin 3,
      residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0 ∧
      IsDominant (residualComponentOnToBase p₀ q₀ r N hgood.1 F hF v hv i j) := by
  have hX : stereoFirstCoordsOn p₀ q₀ F v ≠ 0 :=
    stereoFirstCoordsOn_ne_zero_of_polar p₀ q₀ F hF v hv (by
      simpa [lineStereoPolarForm] using hpolar)
  have hY : residualYCoordsOn p₀ q₀ r N F v ≠ 0 :=
    residualYCoordsOn_ne_zero_of_sourceFaithfulGoodLine p₀ q₀ r N F hF v hgood
  obtain ⟨i, j, hdenom⟩ :=
    exists_residualComponentOnDenom_ne_zero p₀ q₀ r N F v hX hY
  exact ⟨i, j, hdenom,
    isDominant_residualComponentOnToBase_of_sourceFaithfulGoodLine
      p₀ q₀ r N F hF v hv hgood i j hdenom⟩

end

end BConicBundleMultisections
