/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.G4ProperPoint
public import BConicBundleMultisections.Standard.G3G4LineSelection

/-!
# A constant tangent line witnessing pointwise G4

The global open-intersection theorem in `G4ProperPoint` supplies a point `y` outside the
second-conic discriminant on a smooth first-projection cubic.  Tangent-residual surjectivity turns
that point into a constant tangent line.  This closes the pointwise geometric part of G4 without
any generic-factor or descent hypothesis.

The last theorem records the exact remaining link to the polynomial G4 predicate used by the
residual surface: it is enough that one specialization of `residualYCoordsOn` realize the
pointwise residual up to nonzero projective scale.  Homogeneity then proves that the pulled-back
degree-nine discriminant polynomial is nonzero.
-/

@[expose] public section

namespace BConicBundleMultisections.Standard

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial
open scoped Matrix

/-- A constant line is pointwise G4 when it is tangent to some smooth first-projection cubic and
its tangent residual avoids the second-conic discriminant. -/
def PointwiseG4TangentLine
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (p q : Fin 3 → k) : Prop :=
  ∃ x : Fin 3 → k,
    x ≠ 0 ∧
    IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F) ∧
    p ≠ 0 ∧
    eval p (specializeFirstCoordinates (n := 2) x F) = 0 ∧
    LinearIndependent k ![p, q] ∧
    q ∈ tangentHyperplaneCone (specializeFirstCoordinates (n := 2) x F) p ∧
    eval
        (residualAmbientRep p q
          (binaryLineRestriction p q
            (specializeFirstCoordinates (n := 2) x F)))
        (sndConicDiscriminant F) ≠ 0

/-- The standard isotropic/nondegenerate data required of the polynomial Tsen section along a
framed line. -/
def HasNondegenerateLineStereoSection
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (p q : Fin 3 → k) (v : Fin 3 → Polynomial k) : Prop :=
  v ≠ 0 ∧
  TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0 ∧
  v 2 ≠ 0 ∧
  polarEval (lineSpecializedConicPullback p q F)
    (liftTsenSection v) affineTwoStereoDir ≠ 0

/-! ## Specialization algebra for the residual witness -/

/-- The ambient residual representative commutes with coefficient maps. -/
theorem map_residualAmbientRep
    {R S : Type u} [CommRing R] [CommRing S]
    (f : R →+* S) {sigma : Type*}
    (p q : sigma → R) (g : MvPolynomial (Fin 2) R) :
    f ∘ residualAmbientRep p q g =
      residualAmbientRep (f ∘ p) (f ∘ q) (MvPolynomial.map f g) := by
  funext i
  simp [residualAmbientRep, residualBinaryRep, MvPolynomial.coeff_map]

/-- Linear substitution commutes with changing coefficients. -/
theorem map_aeval_linearSubst
    {R S : Type u} [CommRing R] [CommRing S]
    (f : R →+* S) (n : ℕ)
    (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (G : MvPolynomial (Fin (n + 1)) R) :
    MvPolynomial.map f
        ((aeval (linearSubst n M) :
          MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G) =
      (aeval (linearSubst n (M.map f)) :
        MvPolynomial (Fin (n + 1)) S →ₐ[S] _) (MvPolynomial.map f G) := by
  induction G using MvPolynomial.induction_on with
  | C a => simp
  | add P Q hP hQ =>
      simpa only [map_add] using congrArg₂ (fun A B => A + B) hP hQ
  | mul_X P i hP =>
      simp only [map_mul, aeval_X, hP]
      congr 1
      simp [linearSubst, map_sum, Matrix.map_apply]

/-- The frame-defined tangent direction commutes with coefficient specialization. -/
theorem map_frameTangentDir
    {R S : Type u} [CommRing R] [CommRing S]
    (f : R →+* S)
    (M N : Matrix (Fin 3) (Fin 3) R)
    (G : MvPolynomial (Fin 3) R) (p : Fin 3 → R) :
    f ∘ frameTangentDir M N G p =
      frameTangentDir (M.map f) (N.map f) (MvPolynomial.map f G) (f ∘ p) := by
  let G' := (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G
  let p' := Matrix.mulVec N p
  have hG : MvPolynomial.map f G' =
      (aeval (linearSubst 2 (M.map f)) :
        MvPolynomial (Fin 3) S →ₐ[S] _) (MvPolynomial.map f G) :=
    map_aeval_linearSubst f 2 M G
  have hp : f ∘ p' = Matrix.mulVec (N.map f) (f ∘ p) := by
    funext i
    exact RingHom.map_mulVec f N p i
  have hdir := map_complementaryTangentDir f G' p'
  rw [hG, hp] at hdir
  funext i
  change f ((Matrix.mulVec M (complementaryTangentDir G' p')) i) = _
  rw [RingHom.map_mulVec]
  exact congrFun (congrArg (fun z => Matrix.mulVec (M.map f) z) hdir) i

/-- The complete frame-tangent residual construction commutes with coefficient specialization. -/
theorem map_frameTangentResidual
    {R S : Type u} [CommRing R] [CommRing S]
    (f : R →+* S)
    (M N : Matrix (Fin 3) (Fin 3) R)
    (G : MvPolynomial (Fin 3) R) (p : Fin 3 → R) :
    f ∘ residualAmbientRep p (frameTangentDir M N G p)
        (binaryLineRestriction p (frameTangentDir M N G p) G) =
      residualAmbientRep (f ∘ p)
        (frameTangentDir (M.map f) (N.map f) (MvPolynomial.map f G) (f ∘ p))
        (binaryLineRestriction (f ∘ p)
          (frameTangentDir (M.map f) (N.map f) (MvPolynomial.map f G) (f ∘ p))
          (MvPolynomial.map f G)) := by
  rw [map_residualAmbientRep, map_binaryLineRestriction, map_frameTangentDir]

/-- On a smooth cubic, the frame-defined tangent direction at the base point of a tangent line is
a nonzero multiple of that line's chosen direction. -/
theorem frameTangentDir_eq_smul_lineDir_of_smooth_tangent
    {k : Type u} [Field k]
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p q r * N = 1)
    (G : MvPolynomial (Fin 3) k) (hsmooth : IsSmoothPlaneCubic G)
    (hp : eval p G = 0)
    (hq : q ∈ tangentHyperplaneCone G p) :
    ∃ a : k, a ≠ 0 ∧
      frameTangentDir (lineFrame p q r) N G p = a • q := by
  classical
  let M := lineFrame p q r
  let z : Fin 3 → k := ![1, 0, 0]
  let Gb :=
    (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) G
  have hNp : Matrix.mulVec N p = z := by
    simpa [z] using mulVec_inverse_linePointOf p q r N hMN 0
  have hMz : Matrix.mulVec M z = p := by
    simp [M, z]
  have hGbHom : Gb.IsHomogeneous 3 := by
    exact isHomogeneous_aeval_linearSubst M hsmooth.1
  have hGb0 : eval z Gb = 0 := by
    change eval z
      ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) G) = 0
    rw [eval_aeval_linearSubst, hMz, hp]
  have hg0 : eval z (pderiv (0 : Fin 3) Gb) = 0 := by
    have heuler := eval_tangentForm_self_eq_zero hGbHom hGb0
    simpa [eval_tangentForm, tangentGradient, z, Fin.sum_univ_three] using heuler
  have hg1 : eval z (pderiv (1 : Fin 3) Gb) = 0 := by
    change eval z
      (pderiv (1 : Fin 3)
        ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) G)) = 0
    rw [eval_pderiv_aeval_linearSubst, hMz]
    have hq' : eval q (tangentForm G p) = 0 := hq
    simpa [M, lineFrame, eval_tangentForm, tangentGradient,
      Fin.sum_univ_three, mul_comm] using hq'
  have hns := nonsingular_aeval_linearSubst_of_nonsingular
    2 M N hMN G hsmooth.2
  obtain ⟨i, hi⟩ := hns z (by simp [z]) hGb0
  have hg2 : eval z (pderiv (2 : Fin 3) Gb) ≠ 0 := by
    intro hg2
    fin_cases i <;> contradiction
  let a := -eval z (pderiv (2 : Fin 3) Gb)
  have ha : a ≠ 0 := neg_ne_zero.mpr hg2
  have hdir : complementaryTangentDir Gb z = a • (![0, 1, (0 : k)]) := by
    funext i
    fin_cases i <;>
      simp [complementaryTangentDir, cross3, tangentGradient, z, a, hg0, hg1,
        Pi.smul_apply, smul_eq_mul]
  refine ⟨a, ha, ?_⟩
  change Matrix.mulVec M (complementaryTangentDir Gb (Matrix.mulVec N p)) = a • q
  rw [hNp, hdir, Matrix.mulVec_smul, lineFrame_mulVec_dir]

/-- Avoidance by a tangent residual is unchanged when the chosen tangent direction is replaced by
the frame-defined one. -/
theorem eval_frameTangentResidual_ne_zero_of_smooth_tangent
    {k : Type u} [Field k]
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p q r * N = 1)
    (G : MvPolynomial (Fin 3) k) (hsmooth : IsSmoothPlaneCubic G)
    (hp : eval p G = 0) (hq : q ∈ tangentHyperplaneCone G p)
    (H : MvPolynomial (Fin 3) k) (d : ℕ) (hH : H.IsHomogeneous d)
    (havoid : eval
      (residualAmbientRep p q (binaryLineRestriction p q G)) H ≠ 0) :
    eval
      (residualAmbientRep p (frameTangentDir (lineFrame p q r) N G p)
        (binaryLineRestriction p (frameTangentDir (lineFrame p q r) N G p) G)) H ≠ 0 := by
  obtain ⟨a, ha, hdir⟩ :=
    frameTangentDir_eq_smul_lineDir_of_smooth_tangent p q r N hMN G hsmooth hp hq
  let f := binaryLineRestriction p q G
  have hfhom : f.IsHomogeneous 3 :=
    binaryLineRestriction_isHomogeneous hsmooth.1 p q
  obtain ⟨h30, h21⟩ :=
    coeff_binaryLineRestriction_double_contact G hsmooth.1 p q hp hq
  have hdir' : frameTangentDir (lineFrame p q r) N G p =
      fun i ↦ a * q i + 0 * p i := by
    rw [hdir]
    funext i
    simp [Pi.smul_apply, smul_eq_mul]
  have hres :
      residualAmbientRep p (frameTangentDir (lineFrame p q r) N G p)
          (binaryLineRestriction p (frameTangentDir (lineFrame p q r) N G p) G) =
        fun i ↦ a ^ 3 * residualAmbientRep p q f i := by
    rw [hdir', binaryLineRestriction_reparam]
    exact residualAmbientRep_reparam p q a 0 f hfhom h30 h21
  rw [hres, eval_smul_point_of_isHomogeneous hH]
  exact mul_ne_zero (pow_ne_zero d (pow_ne_zero 3 ha)) havoid

/-- Multiplying a smooth cubic equation by a nonzero scalar preserves the packaged smoothness
predicate. -/
theorem isSmoothPlaneCubic_C_mul
    {k : Type u} [Field k]
    (G : MvPolynomial (Fin 3) k) (hsmooth : IsSmoothPlaneCubic G)
    (c : k) (hc : c ≠ 0) :
    IsSmoothPlaneCubic (C c * G) := by
  refine ⟨hsmooth.1.C_mul c, ?_⟩
  intro x hx0 hxG
  have hxG' : eval x G = 0 := by
    have : c * eval x G = 0 := by
      simpa only [eval_mul, eval_C] using hxG
    exact (mul_eq_zero.mp this).resolve_left hc
  obtain ⟨i, hi⟩ := hsmooth.2 x hx0 hxG'
  refine ⟨i, ?_⟩
  rw [pderiv_C_mul, eval_mul, eval_C]
  exact mul_ne_zero hc hi

/-- The frame-tangent residual remains outside a homogeneous target after multiplying the cubic
equation by a nonzero scalar. -/
theorem eval_frameTangentResidual_C_mul_ne_zero_of_smooth_tangent
    {k : Type u} [Field k]
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p q r * N = 1)
    (G : MvPolynomial (Fin 3) k) (hsmooth : IsSmoothPlaneCubic G)
    (hp : eval p G = 0) (hq : q ∈ tangentHyperplaneCone G p)
    (H : MvPolynomial (Fin 3) k) (d : ℕ) (hH : H.IsHomogeneous d)
    (havoid : eval
      (residualAmbientRep p q (binaryLineRestriction p q G)) H ≠ 0)
    (c : k) (hc : c ≠ 0) :
    eval
      (residualAmbientRep p
        (frameTangentDir (lineFrame p q r) N (C c * G) p)
        (binaryLineRestriction p
          (frameTangentDir (lineFrame p q r) N (C c * G) p) (C c * G))) H ≠ 0 := by
  have hsmoothC := isSmoothPlaneCubic_C_mul G hsmooth c hc
  have hpC : eval p (C c * G) = 0 := by
    rw [eval_mul, eval_C, hp, mul_zero]
  have hqC : q ∈ tangentHyperplaneCone (C c * G) p := by
    change eval q (tangentForm (C c * G) p) = 0
    rw [tangentForm_C_mul, eval_mul, eval_C]
    have hq' : eval q (tangentForm G p) = 0 := hq
    rw [hq', mul_zero]
  have hresC :
      residualAmbientRep p q (binaryLineRestriction p q (C c * G)) =
        fun i ↦ c * residualAmbientRep p q (binaryLineRestriction p q G) i := by
    rw [binaryLineRestriction_C_mul, residualAmbientRep_C_mul]
  have havoidC :
      eval (residualAmbientRep p q (binaryLineRestriction p q (C c * G))) H ≠ 0 := by
    rw [hresC, eval_smul_point_of_isHomogeneous hH]
    exact mul_ne_zero (pow_ne_zero d hc) havoid
  exact eval_frameTangentResidual_ne_zero_of_smooth_tangent
    p q r N hMN (C c * G) hsmoothC hpC hqC H d hH havoidC

/-- Specializing the generic point of a constant line sends it to the point with the same line
parameter over the base ring. -/
theorem evalAffineTwoPoint_affineTwoLinePoint
    {k : Type u} [CommRing k]
    (p q : Fin 3 → k) (t s : k) :
    (evalAffineTwoPoint t s) ∘ affineTwoLinePoint p q = linePointOf p q t := by
  funext i
  simp [affineTwoLinePoint, linePointOf, evalAffineTwoPoint, affineTwoCoord0]

/-- Specializing the constant line frame recovers its frame over the base ring. -/
theorem map_affineTwoLineFrame_evalAffineTwoPoint
    {k : Type u} [CommRing k]
    (p q r : Fin 3 → k) (t s : k) :
    (affineTwoLineFrame p q r).map (evalAffineTwoPoint t s) = lineFrame p q r := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [affineTwoLineFrame, lineFrame, evalAffineTwoPoint]

/-- Specializing a constant matrix first embedded into the affine two-ring recovers that matrix. -/
theorem map_map_C_evalAffineTwoPoint
    {k : Type u} [CommRing k]
    (N : Matrix (Fin 3) (Fin 3) k) (t s : k) :
    (N.map (C : k →+* affineTwoRing k)).map (evalAffineTwoPoint t s) = N := by
  ext i j
  simp [Matrix.map_apply, evalAffineTwoPoint]

/-- Evaluating the affine-plane conic along a constant line gives the numerical conic over the
corresponding point of that line. -/
theorem map_evalAffineTwoPoint_lineSpecializedConicPullback
    {k : Type u} [Field k]
    (p q : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (t s : k) :
    map (evalAffineTwoPoint t s) (lineSpecializedConicPullback p q F) =
      lineSpecializedConic p q F t := by
  rw [lineSpecializedConicPullback_eq_map, MvPolynomial.map_map]
  have hcomp :
      (evalAffineTwoPoint t s).comp (liftPolyTHom (k := k)) =
        Polynomial.evalRingHom t := by
    apply DFunLike.ext _ _
    intro a
    exact evalAffineTwoPoint_liftPolyT a t s
  rw [hcomp, map_eval_lineSpecializedConicPoly]

/-- The linewise stereo coordinates specialize to the ordinary stereographic construction on the
numerical conic over `p + t q`. -/
theorem evalAffineTwoPoint_stereoFirstCoordsOn_eq_stereoAlg
    {k : Type u} [Field k]
    (p q : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (t s : k) :
    (fun i ↦ evalAffineTwoPoint t s (stereoFirstCoordsOn p q F v i)) =
      stereoAlg (lineSpecializedConic p q F t)
        (evalPolySection v t) (stereographicDirection s) := by
  set phi := evalAffineTwoPoint t s
  set Q := lineSpecializedConicPullback p q F
  set psec := liftTsenSection v
  set w := affineTwoStereoDir (k := k)
  have hmap := map_stereoAlg phi Q psec w
  have hp : (fun j ↦ phi (psec j)) = evalPolySection v t := by
    funext j
    simp [psec, liftTsenSection, evalPolySection, phi,
      evalAffineTwoPoint_liftPolyT]
  have hw : (fun j ↦ phi (w j)) = stereographicDirection s := by
    funext j
    fin_cases j <;>
      simp [w, affineTwoStereoDir, affineTwoCoord1, phi, evalAffineTwoPoint,
        stereographicDirection, eval_X]
  have hQ : map phi Q = lineSpecializedConic p q F t := by
    exact map_evalAffineTwoPoint_lineSpecializedConicPullback p q F t s
  calc
    (fun i ↦ phi (stereoFirstCoordsOn p q F v i)) =
        (fun i ↦ phi (stereoAlg Q psec w i)) := by
          funext i
          simp only [stereoFirstCoordsOn, Q, psec, w]
    _ = stereoAlg (map phi Q) (fun j ↦ phi (psec j))
          (fun j ↦ phi (w j)) := hmap
    _ = stereoAlg (lineSpecializedConic p q F t)
          (evalPolySection v t) (stereographicDirection s) := by
          rw [hQ, hp, hw]

/-- Projective covering of an isotropic point by the affine stereographic directions, with the
single point at infinity displayed explicitly.

The hypotheses are exactly those used in the elementary inverse-stereographic calculation: the
chosen isotropic center has nonzero third coordinate and the polar pairing with the target's
third-coordinate-normalized difference is nonzero. -/
theorem exists_affine_or_infinity_stereoAlg_eq_smul
    {K : Type u} [Field K]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (p x : Fin 3 → K)
    (hp : eval p Q = 0) (hp2 : p 2 ≠ 0) (hx : eval x Q = 0)
    (hB : polarEval Q p
      (fun i ↦ x i - (x 2 * (p 2)⁻¹) * p i) ≠ 0) :
    ∃ a : K, a ≠ 0 ∧
      ((∃ s : K, stereoAlg Q p (stereographicDirection s) = a • x) ∨
        (x 0 - (x 2 * (p 2)⁻¹) * p 0 = 0 ∧
          stereoAlg Q p (![0, 1, (0 : K)]) = a • x)) := by
  classical
  let lam := x 2 * (p 2)⁻¹
  let w : Fin 3 → K := fun i ↦ x i - lam * p i
  have hw2 : w 2 = 0 := by
    simp [w, lam]
    field_simp [hp2]
    ring
  have hxw : x = fun i ↦ lam * p i + w i := by
    funext i
    simp [w]
  have hst := stereoAlg_eq_neg_polar_smul_of_isotropic
    Q hQ p x hp hx lam w hxw
  have hB' : polarEval Q p w ≠ 0 := by
    simpa only [w, lam] using hB
  obtain ⟨c, s, hws | hwinf⟩ :=
    exists_smul_stereographicDirection_of_third_eq_zero w hw2
  · have hc : c ≠ 0 := by
      intro hc
      subst c
      have hw0 : w = 0 := by simpa using hws
      apply hB'
      rw [hw0]
      simpa using
        (polarEval_smul_right Q hQ p (stereographicDirection s) 0)
    let a := (-polarEval Q p w) * (c * c)⁻¹
    have ha : a ≠ 0 := by
      exact mul_ne_zero (neg_ne_zero.mpr hB')
        (inv_ne_zero (mul_ne_zero hc hc))
    refine ⟨a, ha, Or.inl ⟨s, ?_⟩⟩
    have heq : (c * c) • stereoAlg Q p (stereographicDirection s) =
        (-polarEval Q p w) • x := by
      calc
        (c * c) • stereoAlg Q p (stereographicDirection s) =
            stereoAlg Q p (c • stereographicDirection s) :=
              (stereoAlg_smul_right Q hQ p (stereographicDirection s) c).symm
        _ = stereoAlg Q p w := by rw [hws]
        _ = (-polarEval Q p w) • x := hst
    funext i
    have hi := congrFun heq i
    simp only [Pi.smul_apply, smul_eq_mul] at hi ⊢
    dsimp [a]
    field_simp [hc]
    linear_combination hi
  · have hc : c ≠ 0 := by
      intro hc
      subst c
      have hw0 : w = 0 := by simpa using hwinf
      apply hB'
      rw [hw0]
      simpa using
        (polarEval_smul_right Q hQ p (![0, 1, (0 : K)]) 0)
    let a := (-polarEval Q p w) * (c * c)⁻¹
    have ha : a ≠ 0 := by
      exact mul_ne_zero (neg_ne_zero.mpr hB')
        (inv_ne_zero (mul_ne_zero hc hc))
    refine ⟨a, ha, Or.inr ⟨?_, ?_⟩⟩
    · have hw0 : w 0 = 0 := by
        rw [hwinf]
        simp [Pi.smul_apply, smul_eq_mul]
      simpa only [w, lam] using hw0
    have heq : (c * c) • stereoAlg Q p (![0, 1, (0 : K)]) =
        (-polarEval Q p w) • x := by
      calc
        (c * c) • stereoAlg Q p (![0, 1, (0 : K)]) =
            stereoAlg Q p (c • (![0, 1, (0 : K)])) :=
              (stereoAlg_smul_right Q hQ p (![0, 1, (0 : K)]) c).symm
        _ = stereoAlg Q p w := by rw [hwinf]
        _ = (-polarEval Q p w) • x := hst
    funext i
    have hi := congrFun heq i
    simp only [Pi.smul_apply, smul_eq_mul] at hi ⊢
    dsimp [a]
    field_simp [hc]
    linear_combination hi

/-- Away from the displayed infinity condition, the affine stereographic chart itself realizes
the isotropic target projectively. -/
theorem exists_affine_stereoAlg_eq_smul
    {K : Type u} [Field K]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (p x : Fin 3 → K)
    (hp : eval p Q = 0) (hp2 : p 2 ≠ 0) (hx : eval x Q = 0)
    (hB : polarEval Q p
      (fun i ↦ x i - (x 2 * (p 2)⁻¹) * p i) ≠ 0)
    (hw0 : x 0 - (x 2 * (p 2)⁻¹) * p 0 ≠ 0) :
    ∃ (s a : K), a ≠ 0 ∧
      stereoAlg Q p (stereographicDirection s) = a • x := by
  obtain ⟨a, ha, hs | ⟨hinf, _⟩⟩ :=
    exists_affine_or_infinity_stereoAlg_eq_smul Q hQ p x hp hp2 hx hB
  · obtain ⟨s, hs⟩ := hs
    exact ⟨s, a, ha, hs⟩
  · exact absurd hinf hw0

/-- Concrete linewise realization theorem.  At a numerical line parameter `t`, every isotropic
target satisfying the inverse-stereo open conditions is a nonzero projective multiple of a
specialization of `stereoFirstCoordsOn` at some affine free parameter `s`. -/
theorem exists_evalAffineTwoPoint_stereoFirstCoordsOn_eq_smul
    {k : Type u} [Field k]
    (p q : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0)
    (t : k) (x : Fin 3 → k)
    (hp2 : evalPolySection v t 2 ≠ 0)
    (hx : eval x (lineSpecializedConic p q F t) = 0)
    (hB : polarEval (lineSpecializedConic p q F t) (evalPolySection v t)
      (fun i ↦ x i - (x 2 * (evalPolySection v t 2)⁻¹) *
        evalPolySection v t i) ≠ 0)
    (hw0 : x 0 - (x 2 * (evalPolySection v t 2)⁻¹) *
      evalPolySection v t 0 ≠ 0) :
    ∃ (s a : k), a ≠ 0 ∧
      (fun i ↦ evalAffineTwoPoint t s (stereoFirstCoordsOn p q F v i)) = a • x := by
  have hQ := lineSpecializedConic_isHomogeneous p q hF t
  have hp := evalPolySection_isotropic_lineSpecializedConic p q F hF v hv t
  obtain ⟨s, a, ha, hst⟩ := exists_affine_stereoAlg_eq_smul
    (lineSpecializedConic p q F t) hQ (evalPolySection v t) x hp hp2 hx hB hw0
  refine ⟨s, a, ha, ?_⟩
  rw [evalAffineTwoPoint_stereoFirstCoordsOn_eq_stereoAlg]
  exact hst

/-- Full specialization formula for the linewise tangent-residual family.

After evaluating the two affine parameters at `(t,s)`, `residualYCoordsOn` is exactly the
frame-defined tangent residual of the specialized cubic fibre at the specialized point
`p + t q`.  Thus the passage from polynomial G4 to a pointwise witness has no remaining
coefficient-map compatibility assumption; only the geometric realization of a suitable
specialized fibre and tangent residual remains. -/
theorem evalAffineTwoPoint_residualYCoordsOn_eq_frameTangentResidual
    {k : Type u} [Field k]
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (t s : k) :
    (evalAffineTwoPoint t s) ∘ residualYCoordsOn p q r N F v =
      let x := fun i ↦ evalAffineTwoPoint t s (stereoFirstCoordsOn p q F v i)
      let G := specializeFirstCoordinates (n := 2) x F
      let pL := linePointOf p q t
      let qd := frameTangentDir (lineFrame p q r) N G pL
      residualAmbientRep pL qd (binaryLineRestriction pL qd G) := by
  let phi := evalAffineTwoPoint t s
  let G := cubicFiberPullback F (stereoFirstCoordsOn p q F v)
  let pL := affineTwoLinePoint p q
  have h := map_frameTangentResidual phi
    (affineTwoLineFrame p q r) (N.map C) G pL
  change phi ∘ residualAmbientRep pL
      (frameTangentDir (affineTwoLineFrame p q r) (N.map C) G pL)
      (binaryLineRestriction pL
        (frameTangentDir (affineTwoLineFrame p q r) (N.map C) G pL) G) = _
  simpa only [phi, G, pL,
    evalAffineTwoPoint_affineTwoLinePoint,
    map_affineTwoLineFrame_evalAffineTwoPoint,
    map_map_C_evalAffineTwoPoint,
    map_cubicFiberPullback_eq_specializeFirst] using h

/-- A smooth nonzero bidegree-`(2,3)` hypersurface admits a constant, invertibly framed tangent
line on one smooth first-projection cubic whose tangent residual avoids the actual conic
discriminant.

This is pointwise G4.  It does not claim yet that the particular Tsen--stereographic residual
surface attached to this line passes through the witness; that realization statement is isolated
below. -/
theorem exists_framed_tangentResidual_avoids_sndConicDiscriminant_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∃ (x p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k),
      x ≠ 0 ∧
      IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F) ∧
      lineFrame p q r * N = 1 ∧
      p ≠ 0 ∧
      eval p (specializeFirstCoordinates (n := 2) x F) = 0 ∧
      LinearIndependent k ![p, q] ∧
      q ∈ tangentHyperplaneCone (specializeFirstCoordinates (n := 2) x F) p ∧
      eval
          (residualAmbientRep p q
            (binaryLineRestriction p q
              (specializeFirstCoordinates (n := 2) x F)))
          (sndConicDiscriminant F) ≠ 0 := by
  obtain ⟨x, y, hx0, hy0, hsmooth, hycurve, hyavoid⟩ :=
    exists_smoothCubicFiber_point_avoids_sndConicDiscriminant F hF hF0
  obtain ⟨p, q, hp0, hpcurve, hpq, hqtangent, hresavoid⟩ :=
    exists_tangentResidualRep_avoids_homogeneous_target_of_isSmoothPlaneCubic
      (specializeFirstCoordinates (n := 2) x F) hsmooth
      (sndConicDiscriminant F) (sndConicDiscriminant_isHomogeneous F hF)
      ⟨y, hy0, hycurve, hyavoid⟩
  obtain ⟨r, N, hMN⟩ := exists_lineFrame_inverse_of_pair_linearIndependent p q hpq
  exact ⟨x, p, q, r, N, hx0, hsmooth, hMN, hp0, hpcurve, hpq, hqtangent, hresavoid⟩

/-- Pointwise G4 is nonempty on the space of framed lines. -/
theorem exists_pointwiseG4TangentLine_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∃ (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k),
      lineFrame p q r * N = 1 ∧ PointwiseG4TangentLine F p q := by
  obtain ⟨x, p, q, r, N, hx0, hsmooth, hMN, hp0, hpcurve, hpq, hqtangent, havoid⟩ :=
    exists_framed_tangentResidual_avoids_sndConicDiscriminant_of_smooth F hF hF0
  exact ⟨p, q, r, N, hMN,
    x, hx0, hsmooth, hp0, hpcurve, hpq, hqtangent, havoid⟩

/-- The pointwise-G4 tangent line can simultaneously be equipped with the usual nondegenerate
Tsen--stereographic section.  Consequently, neither existence of a suitable constant tangent
line nor existence/nondegeneracy of its conic section remains in the G4 bridge. -/
theorem exists_pointwiseG4TangentLine_with_stereoSection_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∃ (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
        (v : Fin 3 → Polynomial k),
      lineFrame p q r * N = 1 ∧
      PointwiseG4TangentLine F p q ∧
      HasNondegenerateLineStereoSection F p q v := by
  obtain ⟨p, q, r, N, hMN, hG4⟩ :=
    exists_pointwiseG4TangentLine_of_smooth F hF hF0
  obtain ⟨v, hv0, hv, hv2, hpolar⟩ :=
    exists_isotropic_line_stereoNondegenerate_of_smooth
      p q r N hMN F hF hF0
  exact ⟨p, q, r, N, v, hMN, hG4, hv0, hv, hv2, hpolar⟩

/-- The proven G3 and pointwise-G4 loci are separately nonempty.

The two existential witnesses are deliberately not identified.  Upgrading this conjunction to
one common line is exactly the open-intersection/interpolation step, not a consequence of the two
nonemptiness theorems alone. -/
theorem exists_G3_line_and_pointwiseG4_line_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    (∃ (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k),
      lineFrame p q r * N = 1 ∧
        ResidualLineNonconstantOn (lineFrame p q r) N F) ∧
    (∃ (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k),
      lineFrame p q r * N = 1 ∧ PointwiseG4TangentLine F p q) := by
  exact ⟨exists_good_line F hF hF0,
    exists_pointwiseG4TangentLine_of_smooth F hF hF0⟩

/-- One specialization of the residual family outside the discriminant proves polynomial G4.
The point may be represented only up to a nonzero common scalar, as is natural projectively. -/
theorem residualAvoidsConicDiscriminantOn_of_eval_eq_smul_off_discriminant
    {k : Type u} [Field k]
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (t s a : k) (ha : a ≠ 0) (y : Fin 3 → k)
    (hy : eval y (sndConicDiscriminant F) ≠ 0)
    (hrealize :
      (fun i ↦ evalAffineTwoPoint t s (residualYCoordsOn p q r N F v i)) =
        fun i ↦ a * y i) :
    ResidualAvoidsConicDiscriminantOn p q r N F v := by
  apply residualAvoidsConicDiscriminantOn_of_exists_eval_ne_zero
  refine ⟨t, s, ?_⟩
  rw [hrealize, eval_smul_point_of_isHomogeneous
    (sndConicDiscriminant_isHomogeneous F hF)]
  exact mul_ne_zero (pow_ne_zero 9 ha) hy

/-- Exact consumer of the specialization formula above.  If the directly specialized
frame-tangent residual avoids the conic discriminant at one affine parameter pair, then the
polynomial G4 predicate follows. -/
theorem residualAvoidsConicDiscriminantOn_of_specialized_frameTangentResidual
    {k : Type u} [Field k]
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (t s : k)
    (hpoint :
      eval
        (let x := fun i ↦ evalAffineTwoPoint t s (stereoFirstCoordsOn p q F v i)
         let G := specializeFirstCoordinates (n := 2) x F
         let pL := linePointOf p q t
         let qd := frameTangentDir (lineFrame p q r) N G pL
         residualAmbientRep pL qd (binaryLineRestriction pL qd G))
        (sndConicDiscriminant F) ≠ 0) :
    ResidualAvoidsConicDiscriminantOn p q r N F v := by
  apply residualAvoidsConicDiscriminantOn_of_exists_eval_ne_zero
  refine ⟨t, s, ?_⟩
  change eval
      ((evalAffineTwoPoint t s) ∘ residualYCoordsOn p q r N F v)
      (sndConicDiscriminant F) ≠ 0
  rw [evalAffineTwoPoint_residualYCoordsOn_eq_frameTangentResidual]
  exact hpoint

/-- Main pointwise-to-polynomial G4 bridge on the affine inverse-stereographic open.

Suppose `x` is the smooth cubic fibre on which the constant line is tangent and its pointwise
tangent residual avoids the conic discriminant.  If the chosen Tsen section at the tangent point
has nonzero third coordinate, and `x` satisfies the two explicit inverse-stereo open conditions,
then `x` is realized projectively by `stereoFirstCoordsOn`.  Bidegree-`(2,3)` homogeneity and
tangent-direction reparameterization then transport pointwise avoidance to the exact specialized
frame residual, and hence to polynomial G4. -/
theorem residualAvoidsConicDiscriminantOn_of_pointwise_tangent_and_inverseStereo
    {k : Type u} [Field k]
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p q r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (x : Fin 3 → k)
    (hsmooth : IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F))
    (hp : eval p (specializeFirstCoordinates (n := 2) x F) = 0)
    (hq : q ∈ tangentHyperplaneCone (specializeFirstCoordinates (n := 2) x F) p)
    (havoid : eval
      (residualAmbientRep p q
        (binaryLineRestriction p q (specializeFirstCoordinates (n := 2) x F)))
      (sndConicDiscriminant F) ≠ 0)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0)
    (hp2 : evalPolySection v 0 2 ≠ 0)
    (hB : polarEval (lineSpecializedConic p q F 0) (evalPolySection v 0)
      (fun i ↦ x i - (x 2 * (evalPolySection v 0 2)⁻¹) *
        evalPolySection v 0 i) ≠ 0)
    (hw0 : x 0 - (x 2 * (evalPolySection v 0 2)⁻¹) *
      evalPolySection v 0 0 ≠ 0) :
    ResidualAvoidsConicDiscriminantOn p q r N F v := by
  let G := specializeFirstCoordinates (n := 2) x F
  have hxQ : eval x (lineSpecializedConic p q F 0) = 0 := by
    rw [lineSpecializedConic, eval_specializeSecondCoordinates]
    have hp' := hp
    rw [eval_specializeFirstCoordinates] at hp'
    simpa [linePointOf] using hp'
  obtain ⟨s, a, ha, hstereo⟩ :=
    exists_evalAffineTwoPoint_stereoFirstCoordsOn_eq_smul
      p q F hF v hv 0 x hp2 hxQ hB hw0
  have hframe :
      eval
        (residualAmbientRep p
          (frameTangentDir (lineFrame p q r) N (C (a ^ 2) * G) p)
          (binaryLineRestriction p
            (frameTangentDir (lineFrame p q r) N (C (a ^ 2) * G) p)
            (C (a ^ 2) * G)))
        (sndConicDiscriminant F) ≠ 0 := by
    exact eval_frameTangentResidual_C_mul_ne_zero_of_smooth_tangent
      p q r N hMN G hsmooth hp hq
      (sndConicDiscriminant F) 9 (sndConicDiscriminant_isHomogeneous F hF)
      havoid (a ^ 2) (pow_ne_zero 2 ha)
  apply residualAvoidsConicDiscriminantOn_of_specialized_frameTangentResidual
    p q r N F v 0 s
  dsimp only
  rw [linePointOf_zero, hstereo, hF.specializeFirstCoordinates_smul]
  exact hframe

/-- Consumer form specialized to a tangent-residual witness.  Once a specialization of
`residualYCoordsOn` is projectively equal to that pointwise tangent residual, G4 follows with no
additional polynomial argument. -/
theorem residualAvoidsConicDiscriminantOn_of_realizes_tangentResidual
    {k : Type u} [Field k]
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (g : MvPolynomial (Fin 3) k)
    (v : Fin 3 → Polynomial k)
    (hpoint : eval
      (residualAmbientRep p q (binaryLineRestriction p q g))
      (sndConicDiscriminant F) ≠ 0)
    (t s a : k) (ha : a ≠ 0)
    (hrealize :
      (fun i ↦ evalAffineTwoPoint t s (residualYCoordsOn p q r N F v i)) =
        fun i ↦ a *
          residualAmbientRep p q (binaryLineRestriction p q g) i) :
    ResidualAvoidsConicDiscriminantOn p q r N F v := by
  exact residualAvoidsConicDiscriminantOn_of_eval_eq_smul_off_discriminant
    p q r N F hF v t s a ha
    (residualAmbientRep p q (binaryLineRestriction p q g)) hpoint hrealize

end

end BConicBundleMultisections.Standard
