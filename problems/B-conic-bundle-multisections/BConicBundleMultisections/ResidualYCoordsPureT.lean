/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.SpecializedConicFreeDir
public import BConicBundleMultisections.MvPolynomialHomogeneousEvaluation

/-!
# Residual Y nonvanishing: pure-`t` L-branch

Thin wrapper assembling pure-`t` residual denseness
(`eq_zero_of_aeval_residualImageXCoords_eq_zero_of_isHomogeneous_two_of_pureT`)
with L-branch geometry.

The key algebraic input is L-vanishing over an **integral domain** (not a field):
`affineTwoRing k = MvPolynomial _ k` is a domain but not a field, so the Field-based
`eval_on_L_eq_zero_of_residual_binary_eq_zero_of_q_two_grad2_ne` cannot be specialized
directly. Clearing denominators via homogeneity yields an `IsDomain` version that applies.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u
open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

/-- Residual stereo cubic of a Tsen section. -/
def residualStereoCubic {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) : MvPolynomial (Fin 3) (affineTwoRing k) :=
  cubicFiberPullback F (residualImageXCoords F v)

/-- Complementary residual tangent direction at the coordinate line. -/
def residualComplementaryDir {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) : Fin 3 → affineTwoRing k :=
  complementaryTangentDir (residualStereoCubic F v) (affineTwoCoordinateLineY k)

/-- Residual binary line restriction along the residual tangent line. -/
def residualBinaryLine {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) : MvPolynomial (Fin 2) (affineTwoRing k) :=
  binaryLineRestriction (affineTwoCoordinateLineY k) (residualComplementaryDir F v)
    (residualStereoCubic F v)

/-- Evaluation of `X₂ · Q` at `e₀ = (1,0,0)` is zero. -/
theorem eval_e0_eq_zero_of_X2_mul
    {R : Type u} [CommRing R] (Q : MvPolynomial (Fin 3) R) :
    eval ![1, 0, (0 : R)] (X (2 : Fin 3) * Q) = 0 := by
  rw [eval_mul, eval_X]
  simp

/-- L-branch binary restriction zero forces vanishing on `L = {X₂ = 0}`, over an integral
domain. Clears denominators via homogeneity instead of inverting `1+t²` and `g₂`. -/
theorem eval_on_L_eq_zero_of_residual_binary_eq_zero_of_q_two_grad2_ne_domain
    {K : Type u} [CommRing K] [IsDomain K]
    (G : MvPolynomial (Fin 3) K) (hG : G.IsHomogeneous 3)
    (p : Fin 3 → K) (hp0 : p 0 = 1) (hp2 : p 2 = 0)
    (ht : 1 + p 1 ^ 2 ≠ 0) (_hpG : eval p G = 0)
    (hq2 : complementaryTangentDir G p 2 = 0)
    (hg2 : eval p (pderiv 2 G) ≠ 0)
    (hf : binaryLineRestriction p (complementaryTangentDir G p) G = 0) :
    ∀ a b : K, eval ![a, b, (0 : K)] G = 0 := by
  classical
  set q := complementaryTangentDir G p
  set t := p 1
  set g2 := eval p (pderiv 2 G)
  have hq0 : q 0 = t * g2 := by
    simp [q, complementaryTangentDir, cross3, tangentGradient, hp2, t, g2]
  have hq1 : q 1 = -g2 := by
    simp [q, complementaryTangentDir, cross3, tangentGradient, hp0, hp2, g2]
  have hq_smul0 : q 0 = g2 * t := by rw [hq0]; ring
  have hq_smul1 : q 1 = g2 * (-1) := by rw [hq1]; ring
  have hq_smul2 : q 2 = g2 * (0 : K) := by simp [hq2]
  intro a b
  set D : K := 1 + t ^ 2
  have hD : D ≠ 0 := by simpa [D, t] using ht
  set α0 : K := a + b * t
  set β0 : K := α0 * t - b * D
  have h0 : D * a = α0 * p 0 + β0 * t := by
    simp only [hp0, α0, β0, D]
    ring
  have h1 : D * b = α0 * p 1 + β0 * (-1) := by
    have hp1 : p 1 = t := rfl
    simp only [hp1, α0, β0, D]
    ring
  have h0q : (D * g2) * a = (α0 * g2) * p 0 + β0 * q 0 := by
    calc
      (D * g2) * a = g2 * (D * a) := by ring
      _ = g2 * (α0 * p 0 + β0 * t) := by rw [h0]
      _ = (α0 * g2) * p 0 + β0 * (g2 * t) := by ring
      _ = (α0 * g2) * p 0 + β0 * q 0 := by rw [hq_smul0]
  have h1q : (D * g2) * b = (α0 * g2) * p 1 + β0 * q 1 := by
    calc
      (D * g2) * b = g2 * (D * b) := by ring
      _ = g2 * (α0 * p 1 + β0 * (-1)) := by rw [h1]
      _ = (α0 * g2) * p 1 + β0 * (g2 * (-1)) := by ring
      _ = (α0 * g2) * p 1 + β0 * q 1 := by rw [hq_smul1]
  have h2q : (D * g2) * (0 : K) = (α0 * g2) * p 2 + β0 * q 2 := by
    simp [hp2, hq_smul2]
  have hspanq :
      (fun i : Fin 3 => (D * g2) * (![a, b, (0 : K)] i)) =
        fun i => (α0 * g2) * p i + β0 * q i := by
    funext i
    fin_cases i
    · simpa using h0q
    · simpa using h1q
    · simpa using h2q
  have hline :
      eval (fun i => (α0 * g2) * p i + β0 * q i) G = 0 := by
    have h := congrArg (eval ![α0 * g2, β0]) hf
    have hcomm :
        (fun i => p i * (α0 * g2) + q i * β0) =
          fun i => (α0 * g2) * p i + β0 * q i := by
      funext i; ring
    simpa [eval_binaryLineRestriction, hcomm] using h
  have hsmul :
      eval (fun i => (D * g2) * (![a, b, (0 : K)] i)) G =
        (D * g2) ^ 3 * eval ![a, b, (0 : K)] G :=
    eval_smul_point_of_isHomogeneous hG (D * g2) ![a, b, (0 : K)]
  have hprod : (D * g2) ^ 3 * eval ![a, b, (0 : K)] G = 0 := by
    calc
      (D * g2) ^ 3 * eval ![a, b, (0 : K)] G
          = eval (fun i => (D * g2) * (![a, b, (0 : K)] i)) G := hsmul.symm
      _ = eval (fun i => (α0 * g2) * p i + β0 * q i) G := by rw [hspanq]
      _ = 0 := hline
  have hDg2 : D * g2 ≠ 0 := mul_ne_zero hD hg2
  have hpow : (D * g2) ^ 3 ≠ 0 := pow_ne_zero 3 hDg2
  exact (mul_eq_zero.mp hprod).resolve_left hpow

set_option maxHeartbeats 2000000 in
-- Denseness application through residual stereo types is elaborator-heavy.
/-- Under pure-`t` denseness, residual vanishing of `map C (specializeSecond e0 F)` is absurd. -/
theorem specializeSecond_e0_eq_zero_of_residual_vanishes_pureT
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hst2 : residualImageXCoords F v 2 ≠ 0)
    (hpure : freeDirPureT F)
    (hdeg : (freeDirCoeffT F 0 0).natDegree ≠ 0)
    (ht0 : ∃ t : k, Polynomial.eval t (freeDirCoeffT F 0 0) = 0 ∧
      Polynomial.eval t (v 2) ≠ 0)
    (hvan :
      eval (residualImageXCoords F v)
        (map (C : k →+* affineTwoRing k)
          (specializeSecondCoordinates (m := 2) (![1, 0, (0 : k)]) F)) = 0) :
    False := by
  set H : MvPolynomial (Fin 3) k :=
    specializeSecondCoordinates (m := 2) (![1, 0, (0 : k)]) F
  have hHhom : H.IsHomogeneous 2 :=
    hF.specializeSecondCoordinates_isHomogeneous _
  have hH0 : H = 0 :=
    eq_zero_of_aeval_residualImageXCoords_eq_zero_of_isHomogeneous_two_of_pureT
      F hF hF0 v hv H hHhom hst2 hvan hpure hdeg ht0
  exact (specializeSecond_e0_ne_zero_of_smooth_bidegree23 F hF hF0) hH0

set_option maxHeartbeats 2000000 in
-- Connects stereo L-vanishing to denseness input via map-C specializeSecond.
/-- If the residual stereo cubic vanishes on `L`, residual evaluation of
`map C (specializeSecond e0 F)` is zero. -/
theorem residual_map_C_specializeSecond_e0_eq_zero_of_eval_on_L
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hvan : ∀ a b : affineTwoRing k,
      eval ![a, b, (0 : affineTwoRing k)] (residualStereoCubic F v) = 0) :
    eval (residualImageXCoords F v)
      (map (C : k →+* affineTwoRing k)
        (specializeSecondCoordinates (m := 2) (![1, 0, (0 : k)]) F)) = 0 := by
  have hvan' : ∀ a b : affineTwoRing k,
      eval ![a, b, (0 : affineTwoRing k)]
        (cubicFiberPullback F (residualImageXCoords F v)) = 0 := by
    intro a b
    simpa [residualStereoCubic] using hvan a b
  obtain ⟨Q, hGQ⟩ := cubicFiberPullback_stereo_eq_X2_mul_of_eval_on_L F hF v hvan'
  have he0 :
      eval ![1, 0, (0 : affineTwoRing k)]
        (cubicFiberPullback F (residualImageXCoords F v)) = 0 := by
    rw [hGQ]
    exact eval_e0_eq_zero_of_X2_mul Q
  exact (eval_residual_map_C_specializeSecond_e0 F v).trans he0

set_option maxHeartbeats 2000000 in
-- Uses IsDomain L-vanishing over affineTwoRing, then residual map-C bridge.
/-- L-branch residual binary restriction zero forces denseness vanishing of
`specializeSecond e0` at residual stereo. -/
theorem residual_map_C_specializeSecond_e0_eq_zero_of_L_branch_binary_zero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hq2 : residualComplementaryDir F v 2 = 0)
    (hg2 : eval (affineTwoCoordinateLineY k) (pderiv 2 (residualStereoCubic F v)) ≠ 0)
    (hf : residualBinaryLine F v = 0) :
    eval (residualImageXCoords F v)
      (map (C : k →+* affineTwoRing k)
        (specializeSecondCoordinates (m := 2) (![1, 0, (0 : k)]) F)) = 0 := by
  set G := residualStereoCubic F v
  set p := affineTwoCoordinateLineY k
  haveI : IsDomain (affineTwoRing k) := inferInstance
  have hGhom : G.IsHomogeneous 3 := by
    dsimp only [G, residualStereoCubic]
    exact cubicFiberPullback_isHomogeneous F hF _
  have hpG : eval p G = 0 := by
    dsimp only [G, residualStereoCubic, p]
    exact eval_cubicFiber_coordinateLine_of_stereo F hF v hv
  have ht : 1 + p 1 ^ 2 ≠ 0 := by
    simpa [p, affineTwoCoordinateLineY] using one_add_affineTwoCoord0_sq_ne_zero k
  have hp0 : p 0 = 1 := by simp [p, affineTwoCoordinateLineY]
  have hp2p : p 2 = 0 := by simp [p, affineTwoCoordinateLineY]
  have hq2' : complementaryTangentDir G p 2 = 0 := by
    simpa [G, p, residualComplementaryDir] using hq2
  have hg2' : eval p (pderiv 2 G) ≠ 0 := hg2
  have hf' : binaryLineRestriction p (complementaryTangentDir G p) G = 0 := by
    simpa [G, p, residualBinaryLine, residualComplementaryDir] using hf
  have hvanL :
      ∀ a b : affineTwoRing k, eval ![a, b, (0 : affineTwoRing k)] G = 0 :=
    eval_on_L_eq_zero_of_residual_binary_eq_zero_of_q_two_grad2_ne_domain
      G hGhom p hp0 hp2p ht hpG hq2' hg2' hf'
  exact residual_map_C_specializeSecond_e0_eq_zero_of_eval_on_L F hF v hvanL

set_option maxHeartbeats 2000000 in
-- Final pure-t denseness contradiction for residual binary restriction.
/-- Under pure-`t` freeDir denseness, residual binary line restriction is nonzero on the
L-branch with nonzero vertical gradient. -/
theorem binaryLineRestriction_ne_zero_of_L_branch_pureT
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hst2 : residualImageXCoords F v 2 ≠ 0)
    (hpure : freeDirPureT F)
    (hdeg : (freeDirCoeffT F 0 0).natDegree ≠ 0)
    (ht0 : ∃ t : k, Polynomial.eval t (freeDirCoeffT F 0 0) = 0 ∧
      Polynomial.eval t (v 2) ≠ 0)
    (hq2 : residualComplementaryDir F v 2 = 0)
    (hg2 : eval (affineTwoCoordinateLineY k) (pderiv 2 (residualStereoCubic F v)) ≠ 0) :
    residualBinaryLine F v ≠ 0 := by
  intro hf
  exact specializeSecond_e0_eq_zero_of_residual_vanishes_pureT
    F hF hF0 v hv hst2 hpure hdeg ht0
    (residual_map_C_specializeSecond_e0_eq_zero_of_L_branch_binary_zero
      F hF v hv hq2 hg2 hf)

set_option maxHeartbeats 2000000 in
-- Package residual binary ≠ 0 as residualY ≠ 0.
/-- Residual Y-coordinates are nonzero on the pure-`t` L-branch under residual denseness. -/
theorem residualYCoords_ne_zero_of_smooth_L_branch_pureT
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (_hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hst2 : residualImageXCoords F v 2 ≠ 0)
    (hpure : freeDirPureT F)
    (hdeg : (freeDirCoeffT F 0 0).natDegree ≠ 0)
    (ht0 : ∃ t : k, Polynomial.eval t (freeDirCoeffT F 0 0) = 0 ∧
      Polynomial.eval t (v 2) ≠ 0)
    (hq2 : residualComplementaryDir F v 2 = 0)
    (hg2 : eval (affineTwoCoordinateLineY k) (pderiv 2 (residualStereoCubic F v)) ≠ 0) :
    residualYCoords F v ≠ 0 := by
  refine residualYCoords_ne_zero_of_binaryLineRestriction_ne_zero F hF v hv ?_
  -- residualBinaryLine unfolds to the expected residual binary restriction.
  change residualBinaryLine F v ≠ 0
  exact binaryLineRestriction_ne_zero_of_L_branch_pureT F hF hF0 v hv hst2 hpure hdeg ht0
    hq2 hg2

/-! ### Wire pure-`t` residual X/Y into residual-image unirationality packaging -/

/-- Residual X ≠ 0 is free on smooth equations; residual Y ≠ 0 on pure-`t` L-branch.
Dominance of localized residual points remains the ofhom-dom input. -/
theorem hasResidualImageUnirationalParametrization2_of_smooth_L_branch_pureT
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hst2 : residualImageXCoords F v 2 ≠ 0)
    (hpure : freeDirPureT F)
    (hdeg : (freeDirCoeffT F 0 0).natDegree ≠ 0)
    (ht0 : ∃ t : k, Polynomial.eval t (freeDirCoeffT F 0 0) = 0 ∧
      Polynomial.eval t (v 2) ≠ 0)
    (hq2 : residualComplementaryDir F v 2 = 0)
    (hg2 : eval (affineTwoCoordinateLineY k) (pderiv 2 (residualStereoCubic F v)) ≠ 0)
    (hdom :
      ∀ (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0),
        IsDominant (residualImagePointOfNormalizedLoc F hF v hv i j)) :
    HasResidualImageUnirationalParametrization2 F :=
  hasResidualImageUnirationalParametrization2_of_smooth_of_y_and_dominant
    F hF hF0 v hv0 hv
    (residualYCoords_ne_zero_of_smooth_L_branch_pureT F hF hF0 v hv0 hv hst2 hpure hdeg ht0
      hq2 hg2)
    hdom

/-- Same packaging with affine residual rational map dominance as input (ofhom-dom form). -/
theorem hasResidualImageUnirationalParametrization2_of_smooth_L_branch_pureT_of_affine_dominant
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hst2 : residualImageXCoords F v 2 ≠ 0)
    (hpure : freeDirPureT F)
    (hdeg : (freeDirCoeffT F 0 0).natDegree ≠ 0)
    (ht0 : ∃ t : k, Polynomial.eval t (freeDirCoeffT F 0 0) = 0 ∧
      Polynomial.eval t (v 2) ≠ 0)
    (hq2 : residualComplementaryDir F v 2 = 0)
    (hg2 : eval (affineTwoCoordinateLineY k) (pderiv 2 (residualStereoCubic F v)) ≠ 0)
    (hdom :
      ∀ (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0),
        (residualImageRationalMapAffine F hF v hv i j hdenom).IsDominant) :
    HasResidualImageUnirationalParametrization2 F := by
  have hY :=
    residualYCoords_ne_zero_of_smooth_L_branch_pureT F hF hF0 v hv0 hv hst2 hpure hdeg ht0
      hq2 hg2
  have hX := residualImageXCoords_ne_zero_of_smooth F hF hF0 v hv0 hv
  exact exists_hasResidualImageUnirationalParametrization2_of_ne_zero_coords
    F hF v hv hX hY hdom

end

end BConicBundleMultisections
