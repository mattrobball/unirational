/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualHorizontalityLineAudit
public import BConicBundleMultisections.ResidualYNonvanishing

/-!
# Residual-coordinate nonvanishing along an arbitrary line

The arbitrary-line residual point is the coordinate-line residual point for the equation carried
into the line frame, carried back by that frame.  This elementary transport separates the mere
existence of a residual projective point from the substantially deeper horizontality assertion.

In particular, choosing a nonzero chart denominator does not require the open projective-Jacobian
theorem `det_residualYCoordsOn_ne_zero`.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial
open scoped Matrix

/-! ### Coefficient change commutes with a second-block substitution -/

theorem map_secondBlockSubst_eq
    {R S : Type u} [CommRing R] [CommRing S] (f : R →+* S)
    (M : Matrix (Fin 3) (Fin 3) R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    map f (secondBlockSubst M F) = secondBlockSubst (M.map f) (map f F) := by
  induction F using MvPolynomial.induction_on with
  | C a => simp [secondBlockSubst]
  | add P Q hP hQ => simp [map_add, hP, hQ]
  | mul_X P z hP =>
      cases z with
      | inl i => simp [map_mul, hP]
      | inr j =>
          simp only [map_mul, hP, secondBlockSubst_X_inr, map_sum, map_C, map_X,
            Matrix.map_apply]

/-- Pulling coefficients to the affine parameter plane commutes with carrying the second block
into a line frame. -/
theorem affineTwoPullback_secondBlockSubst
    {k : Type u} [CommRing k]
    (M : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    affineTwoPullback (secondBlockSubst M F) =
      secondBlockSubst (M.map (C : k →+* affineTwoRing k)) (affineTwoPullback F) := by
  exact map_secondBlockSubst_eq (C : k →+* affineTwoRing k) M F

/-- The cubic fibre for the transported equation is the original cubic fibre written in the
transported second-block coordinates. -/
theorem cubicFiberPullback_secondBlockSubst
    {k : Type u} [CommRing k]
    (M : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x : Fin 3 → affineTwoRing k) :
    cubicFiberPullback (secondBlockSubst M F) x =
      (aeval (linearSubst 2 (M.map (C : k →+* affineTwoRing k))) :
        MvPolynomial (Fin 3) (affineTwoRing k) →ₐ[affineTwoRing k] _)
        (cubicFiberPullback F x) := by
  unfold cubicFiberPullback
  rw [affineTwoPullback_secondBlockSubst,
    specializeFirstCoordinates_secondBlockSubst]

/-- The generic point of a framed line is the image of `(1,t,0)` under its frame. -/
theorem affineTwoLineFrame_mulVec_coordinateLine
    {k : Type u} [CommRing k] (p₀ q₀ r : Fin 3 → k) :
    affineTwoLineFrame p₀ q₀ r *ᵥ affineTwoCoordinateLineY k =
      affineTwoLinePoint p₀ q₀ := by
  funext i
  simp [affineTwoLineFrame, affineTwoCoordinateLineY, affineTwoLinePoint,
    lineFrame, linePointOf, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  ring

/-! ### Transport of the residual representative -/

/-- The arbitrary-line residual representative is the coordinate-line representative for the
transported equation, carried back by the line frame. -/
theorem residualYCoordsOn_eq_mulVec_residualYCoords_secondBlockSubst
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) :
    residualYCoordsOn p₀ q₀ r N F v =
      affineTwoLineFrame p₀ q₀ r *ᵥ
        residualYCoords (secondBlockSubst (lineFrame p₀ q₀ r) F) v := by
  let M₀ := lineFrame p₀ q₀ r
  let M := affineTwoLineFrame p₀ q₀ r
  let N' := N.map (C : k →+* affineTwoRing k)
  let F' := secondBlockSubst M₀ F
  let x := stereoFirstCoordsOn p₀ q₀ F v
  let p := affineTwoLinePoint p₀ q₀
  let z := affineTwoCoordinateLineY k
  let G := cubicFiberPullback F x
  let Gb := cubicFiberPullback F' x
  have hMN' : M * N' = 1 := by
    exact lineFrame_map_mul_map (C : k →+* affineTwoRing k) p₀ q₀ r N hMN
  have hNM' : N' * M = 1 := mul_eq_one_comm.mp hMN'
  have hp : M *ᵥ z = p := by
    exact affineTwoLineFrame_mulVec_coordinateLine p₀ q₀ r
  have hz : N' *ᵥ p = z := by
    rw [← hp, Matrix.mulVec_mulVec, hNM', Matrix.one_mulVec]
  have hx : stereoFirstCoords F' v = x := by
    exact (stereoFirstCoordsOn_eq_stereoFirstCoords_secondBlockSubst p₀ q₀ r F v).symm
  have hMmap : M₀.map (C : k →+* affineTwoRing k) = M := by
    exact lineFrame_map (C : k →+* affineTwoRing k) p₀ q₀ r
  have hGb : Gb =
      (aeval (linearSubst 2 M) :
        MvPolynomial (Fin 3) (affineTwoRing k) →ₐ[affineTwoRing k] _) G := by
    have ht := cubicFiberPullback_secondBlockSubst M₀ F x
    rw [hMmap] at ht
    simpa [F', G, Gb] using ht
  let qb := complementaryTangentDir Gb z
  let q := M *ᵥ qb
  have hq : frameTangentDir M N' G p = q := by
    simp only [frameTangentDir, q, qb]
    rw [hz, ← hGb]
  have hrestr : binaryLineRestriction p q G = binaryLineRestriction z qb Gb := by
    dsimp only [q]
    rw [← hp, ← binaryLineRestriction_aeval_linearSubst 2 M z qb G, ← hGb]
  change residualAmbientRep p (frameTangentDir M N' G p)
      (binaryLineRestriction p (frameTangentDir M N' G p) G) = _
  rw [hq, hrestr]
  change residualAmbientRep p q (binaryLineRestriction z qb Gb) =
    M *ᵥ residualAmbientRep z
      (complementaryTangentDir (cubicFiberPullback F' (stereoFirstCoords F' v)) z)
      (binaryLineRestriction z
        (complementaryTangentDir (cubicFiberPullback F' (stereoFirstCoords F' v)) z)
        (cubicFiberPullback F' (stereoFirstCoords F' v)))
  rw [hx]
  change residualAmbientRep p q (binaryLineRestriction z qb Gb) =
    M *ᵥ residualAmbientRep z qb (binaryLineRestriction z qb Gb)
  rw [mulVec_residualAmbientRep, hp]

/-! ### Nonvanishing, independent of residual horizontality -/

/-- A nondegenerate arbitrary-line stereo construction has a genuine residual point.  This is the
coordinate-line nonvanishing theorem transported through the line frame; no moving-residual-line
or horizontality hypothesis is involved. -/
theorem residualYCoordsOn_ne_zero_of_smooth_transport
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0) :
    residualYCoordsOn p₀ q₀ r N F v ≠ 0 := by
  let M₀ := lineFrame p₀ q₀ r
  let M := affineTwoLineFrame p₀ q₀ r
  let N' := N.map (C : k →+* affineTwoRing k)
  let F' := secondBlockSubst M₀ F
  have hF' : IsBidegree23 F' := isBidegree23_secondBlockSubst M₀ hF
  have hF'0 : F' ≠ 0 := secondBlockSubst_ne_zero_of_inverse M₀ N hMN hF0
  letI : Smooth (biprojectiveZeroLocusToSpec 2 2 k F') :=
    smooth_secondBlockSubst_of_smooth M₀ N hMN F hF hF0
  have hQ : coordinateLineTernaryQuadraticPoly F' =
      lineTernaryQuadraticPoly p₀ q₀ F := by
    funext i j
    simp only [coordinateLineTernaryQuadraticPoly, lineTernaryQuadraticPoly, F']
    rw [← lineSpecializedConicPoly_eq_coordinateLine_secondBlockSubst p₀ q₀ r F]
  have hv' : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F') v = 0 := by
    rw [hQ]
    exact hv
  have hpolar' : StereoNondegenerate F' v := by
    change polarEval (specializedConicPullback F')
      (liftTsenSection v) affineTwoStereoDir ≠ 0
    rw [← lineSpecializedConicPullback_eq_specializedConicPullback_secondBlockSubst p₀ q₀ r F]
    exact hpolar
  have hy : residualYCoords F' v ≠ 0 :=
    residualYCoords_ne_zero_of_smooth F' hF' hF'0 v hv0 hv' hv2 hpolar'
  intro hzero
  have htransport :=
    residualYCoordsOn_eq_mulVec_residualYCoords_secondBlockSubst p₀ q₀ r N hMN F v
  rw [hzero] at htransport
  have hMN' : M * N' = 1 := by
    exact lineFrame_map_mul_map (C : k →+* affineTwoRing k) p₀ q₀ r N hMN
  have hzero' := congrArg (fun w => N' *ᵥ w) htransport.symm
  apply hy
  have hNM' : N' * M = 1 := mul_eq_one_comm.mp hMN'
  rw [Matrix.mulVec_mulVec, Matrix.mulVec_zero] at hzero'
  change (N' * M) *ᵥ residualYCoords F' v = 0 at hzero'
  rw [hNM', Matrix.one_mulVec] at hzero'
  exact hzero'

end

end BConicBundleMultisections
