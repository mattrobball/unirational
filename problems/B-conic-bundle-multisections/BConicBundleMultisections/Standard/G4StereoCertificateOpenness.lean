/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Standard.G3G4ActualLineSelection

/-!
# Polynomial openness of the inverse-stereographic G4 certificate

`pointwiseG4StereoCertificateAt` is written after numerical specialization.  This file packages
the same expression before specialization as one polynomial in the line parameter.  Consequently
its nonvanishing is a genuine principal open, and over an infinite field it is nonempty exactly
when that certificate polynomial is nonzero.

This does not assert that a fixed target lies on every member of the moving conic.  Its role is to
remove all topology/set-theoretic ambiguity from the three local inverse-stereo conditions: their
simultaneous line-parameter nonemptiness is reduced to one explicit polynomial nonvanishing.
-/

@[expose] public section

namespace BConicBundleMultisections.Standard

noncomputable section

universe u

open MvPolynomial
open _root_.MvPolynomial

/-- Denominator-free inverse-stereo difference before specializing the line parameter. -/
def clearedStereoDifferencePoly
    {K : Type u} [Field K]
    (v : Fin 3 → Polynomial K) (x : Fin 3 → K) : Fin 3 → Polynomial K :=
  fun i ↦ v 2 * Polynomial.C (x i) - Polynomial.C (x 2) * v i

/-- The product of the three inverse-stereo open conditions as a polynomial in the line
parameter. -/
def pointwiseG4StereoCertificatePoly
    {K : Type u} [Field K]
    (p q : Fin 3 → K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K) (x : Fin 3 → K) : Polynomial K :=
  let Q := lineSpecializedConicPoly p q F
  let w := clearedStereoDifferencePoly v x
  v 2 * polarEval Q v w * w 0

/-- Specializing the certificate polynomial gives the numerical cleared certificate. -/
theorem eval_pointwiseG4StereoCertificatePoly
    {K : Type u} [Field K]
    (p q : Fin 3 → K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K) (x : Fin 3 → K) (t : K) :
    Polynomial.eval t (pointwiseG4StereoCertificatePoly p q F v x) =
      pointwiseG4StereoCertificateAt p q F v t x := by
  let phi := Polynomial.evalRingHom t
  let Q := lineSpecializedConicPoly p q F
  let w := clearedStereoDifferencePoly v x
  have hQ : map phi Q = lineSpecializedConic p q F t :=
    map_eval_lineSpecializedConicPoly p q F t
  have hv : (fun i ↦ phi (v i)) = evalPolySection v t := by
    rfl
  have hw : (fun i ↦ phi (w i)) =
      clearedStereoDifference (evalPolySection v t) x := by
    funext i
    simp [w, clearedStereoDifferencePoly, clearedStereoDifference,
      evalPolySection, phi]
  have hpolar := polarEval_map phi Q v w
  rw [hQ, hv, hw] at hpolar
  change phi (v 2 * polarEval Q v w * w 0) = _
  rw [map_mul, map_mul, ← hpolar, congrFun hv 2, congrFun hw 0]
  rfl

/-- Nonzero certificate polynomial gives a principal-open certificate for simultaneous local
inverse-stereo accessibility. -/
theorem hasPolynomialOpenCertificate_pointwiseG4StereoCertificateAt
    {K : Type u} [Field K]
    (p q : Fin 3 → K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K) (x : Fin 3 → K)
    (hcert : pointwiseG4StereoCertificatePoly p q F v x ≠ 0) :
    HasPolynomialOpenCertificate
      (fun t ↦ pointwiseG4StereoCertificateAt p q F v t x ≠ 0) := by
  refine ⟨pointwiseG4StereoCertificatePoly p q F v x, hcert, ?_⟩
  intro t ht
  rwa [eval_pointwiseG4StereoCertificatePoly] at ht

/-- Over an infinite field, a nonzero certificate polynomial has a specialization at which all
three inverse-stereo open conditions hold. -/
theorem exists_inverseStereo_open_of_certificatePoly_ne_zero
    {K : Type u} [Field K] [Infinite K]
    (p q : Fin 3 → K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial K) (x : Fin 3 → K)
    (hcert : pointwiseG4StereoCertificatePoly p q F v x ≠ 0) :
    ∃ t : K,
      evalPolySection v t 2 ≠ 0 ∧
      polarEval (lineSpecializedConic p q F t) (evalPolySection v t)
        (fun i ↦ x i - (x 2 * (evalPolySection v t 2)⁻¹) *
          evalPolySection v t i) ≠ 0 ∧
      x 0 - (x 2 * (evalPolySection v t 2)⁻¹) *
        evalPolySection v t 0 ≠ 0 := by
  let f := pointwiseG4StereoCertificatePoly p q F v x
  have hcard : f.natDegree < Cardinal.mk K :=
    Cardinal.natCast_lt_aleph0.trans_le (Cardinal.aleph0_le_mk K)
  obtain ⟨t, ht⟩ := f.exists_eval_ne_zero_of_natDegree_lt_card hcert hcard
  have hpoint : pointwiseG4StereoCertificateAt p q F v t x ≠ 0 := by
    rw [eval_pointwiseG4StereoCertificatePoly] at ht
    exact ht
  exact ⟨t, inverseStereo_open_of_pointwiseG4StereoCertificateAt_ne_zero
    p q F hF v t x hpoint⟩

/-- The three normalized inverse-stereo conditions are also sufficient for nonvanishing of the
denominator-free certificate. -/
theorem pointwiseG4StereoCertificateAt_ne_zero_of_inverseStereo_open
    {K : Type u} [Field K]
    (p q : Fin 3 → K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial K) (t : K) (x : Fin 3 → K)
    (hu2 : evalPolySection v t 2 ≠ 0)
    (hB : polarEval (lineSpecializedConic p q F t) (evalPolySection v t)
      (fun i ↦ x i - (x 2 * (evalPolySection v t 2)⁻¹) *
        evalPolySection v t i) ≠ 0)
    (hw0 : x 0 - (x 2 * (evalPolySection v t 2)⁻¹) *
      evalPolySection v t 0 ≠ 0) :
    pointwiseG4StereoCertificateAt p q F v t x ≠ 0 := by
  let Q := lineSpecializedConic p q F t
  let u := evalPolySection v t
  let w := clearedStereoDifference u x
  have hu2' : u 2 ≠ 0 := hu2
  have hQ : Q.IsHomogeneous 2 := lineSpecializedConic_isHomogeneous p q hF t
  have hnormalized :
      (fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i) = (u 2)⁻¹ • w := by
    funext i
    simp only [Pi.smul_apply, smul_eq_mul]
    dsimp only [w, clearedStereoDifference]
    field_simp [hu2']
  have hBw : polarEval Q u w ≠ 0 := by
    have hscaled : (u 2)⁻¹ * polarEval Q u w ≠ 0 := by
      rw [← polarEval_smul_right Q hQ, ← hnormalized]
      exact hB
    exact (mul_ne_zero_iff.mp hscaled).2
  have hw : w 0 ≠ 0 := by
    have hscaled : (u 2)⁻¹ * w 0 ≠ 0 := by
      have hcoord := congrArg (fun z ↦ z 0) hnormalized
      simp only [Pi.smul_apply, smul_eq_mul] at hcoord
      rw [← hcoord]
      exact hw0
    exact (mul_ne_zero_iff.mp hscaled).2
  change u 2 * polarEval Q u w * w 0 ≠ 0
  exact mul_ne_zero (mul_ne_zero hu2 hBw) hw

/-- A polynomial Tsen section realizes a numerical conic center projectively at `t`. -/
def TsenSectionRealizesCenterAt
    {K : Type u} [Field K]
    (v : Fin 3 → Polynomial K) (t : K) (u : Fin 3 → K) : Prop :=
  ∃ c : K, c ≠ 0 ∧ evalPolySection v t = c • u

/-- A nonzero polynomial isotropic vector can be divided by its common power of `X` until its
specialization at `0` is nonzero.  This is the elementary normalization needed before changing
the specialized conic center by a stereographic second-intersection construction. -/
theorem exists_isotropic_section_nonzero_at_zero
    {K : Type u} [Field K]
    (Q : MvPolynomial (Fin 3) (Polynomial K)) (hQ : Q.IsHomogeneous 2)
    (v₀ : Fin 3 → Polynomial K) (hv₀0 : v₀ ≠ 0) (hv₀ : eval v₀ Q = 0) :
    ∃ v : Fin 3 → Polynomial K,
      v ≠ 0 ∧ eval v Q = 0 ∧ evalPolySection v 0 ≠ 0 := by
  classical
  have descend : ∀ n : ℕ, ∀ (v : Fin 3 → Polynomial K) (i : Fin 3),
      v i ≠ 0 → (v i).natDegree = n → eval v Q = 0 →
        ∃ w : Fin 3 → Polynomial K,
          w ≠ 0 ∧ eval w Q = 0 ∧ evalPolySection w 0 ≠ 0 := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
        intro v i hi hdegree hviso
        by_cases hvalue : evalPolySection v 0 ≠ 0
        · exact ⟨v, fun hz ↦ hi (congrFun hz i), hviso, hvalue⟩
        · have hcoeff (j : Fin 3) : (v j).coeff 0 = 0 := by
            have hj := congrFun (not_ne_iff.mp hvalue) j
            rw [Polynomial.coeff_zero_eq_eval_zero]
            simpa [evalPolySection] using hj
          choose w hw using fun j ↦ Polynomial.X_dvd_iff.mpr (hcoeff j)
          have hvw : v = fun j ↦ Polynomial.X * w j := by
            funext j
            exact hw j
          have hwi : w i ≠ 0 := by
            intro hzero
            apply hi
            simp [hvw, hzero]
          have hwiso : eval w Q = 0 := by
            have hscaled := eval_smul_point_of_isHomogeneous hQ Polynomial.X w
            rw [← hvw, hviso] at hscaled
            have hX2 : (Polynomial.X : Polynomial K) ^ 2 ≠ 0 := pow_ne_zero 2 Polynomial.X_ne_zero
            exact (mul_eq_zero.mp hscaled.symm).resolve_left hX2
          have hlt : (w i).natDegree < n := by
            have hnat := Polynomial.natDegree_mul
              (show (Polynomial.X : Polynomial K) ≠ 0 from Polynomial.X_ne_zero) hwi
            rw [← hw i, Polynomial.natDegree_X, hdegree] at hnat
            omega
          exact ih (w i).natDegree hlt w i hwi rfl hwiso
  obtain ⟨i, hi⟩ : ∃ i : Fin 3, v₀ i ≠ 0 := by
    by_contra hall
    push Not at hall
    exact hv₀0 (funext hall)
  exact descend (v₀ i).natDegree v₀ i hi rfl hv₀

/-- Realizing any locally good center projectively forces the certificate specialization, and
hence the certificate polynomial, to be nonzero.  This isolates the remaining interpolation
problem as construction of a global isotropic polynomial section with prescribed projective value
on one fibre. -/
theorem pointwiseG4StereoCertificateAt_ne_zero_of_realizes_center
    {K : Type u} [Field K]
    (p q : Fin 3 → K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial K) (t : K) (x u : Fin 3 → K)
    (hu2 : u 2 ≠ 0)
    (hB : polarEval (lineSpecializedConic p q F t) u
      (fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i) ≠ 0)
    (hw0 : x 0 - (x 2 * (u 2)⁻¹) * u 0 ≠ 0)
    (hrealize : TsenSectionRealizesCenterAt v t u) :
    pointwiseG4StereoCertificateAt p q F v t x ≠ 0 := by
  obtain ⟨c, hc, hvalue⟩ := hrealize
  let Q := lineSpecializedConic p q F t
  let u' := evalPolySection v t
  have hu' : u' = c • u := hvalue
  have hu'2 : u' 2 ≠ 0 := by
    rw [hu']
    simpa only [Pi.smul_apply, smul_eq_mul] using mul_ne_zero hc hu2
  have hnorm :
      (fun i ↦ x i - (x 2 * (u' 2)⁻¹) * u' i) =
        fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i := by
    funext i
    rw [hu']
    simp only [Pi.smul_apply, smul_eq_mul]
    field_simp [hc, hu2]
  have hQ : Q.IsHomogeneous 2 := lineSpecializedConic_isHomogeneous p q hF t
  have hB' : polarEval Q u'
      (fun i ↦ x i - (x 2 * (u' 2)⁻¹) * u' i) ≠ 0 := by
    rw [hnorm, hu', polarEval_comm, polarEval_smul_right Q hQ, polarEval_comm]
    exact mul_ne_zero hc hB
  have hw0' : x 0 - (x 2 * (u' 2)⁻¹) * u' 0 ≠ 0 := by
    change (fun i ↦ x i - (x 2 * (u' 2)⁻¹) * u' i) 0 ≠ 0
    rw [congrArg (fun z ↦ z 0) hnorm]
    exact hw0
  exact pointwiseG4StereoCertificateAt_ne_zero_of_inverseStereo_open
    p q F hF v t x hu'2 hB' hw0'

/-- Realizing a locally good center also forces the global certificate polynomial to be nonzero,
because its value at the realization parameter is the nonzero numerical certificate. -/
theorem pointwiseG4StereoCertificatePoly_ne_zero_of_realizes_center
    {K : Type u} [Field K]
    (p q : Fin 3 → K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial K) (t : K) (x u : Fin 3 → K)
    (hu2 : u 2 ≠ 0)
    (hB : polarEval (lineSpecializedConic p q F t) u
      (fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i) ≠ 0)
    (hw0 : x 0 - (x 2 * (u 2)⁻¹) * u 0 ≠ 0)
    (hrealize : TsenSectionRealizesCenterAt v t u) :
    pointwiseG4StereoCertificatePoly p q F v x ≠ 0 := by
  have hpoint := pointwiseG4StereoCertificateAt_ne_zero_of_realizes_center
    p q F hF v t x u hu2 hB hw0 hrealize
  intro hzero
  apply hpoint
  rw [← eval_pointwiseG4StereoCertificatePoly, hzero, Polynomial.eval_zero]

/-! ## Local nonemptiness on a smooth conic fibre -/

/-- On a nonsingular projective conic, the three inverse-stereo conditions have a simultaneous
center, provided the target is not the fixed omitted coordinate point `[0:1:0]`.

The proof removes the union of three lines from the conic: `u₂ = 0`, the tangent line at the
target, and `u₂ x₀ - x₂ u₀ = 0`.  Irreducibility of a nonsingular ternary quadratic and
the affine Nullstellensatz produce a projective point outside their product. -/
theorem exists_inverseStereo_center_open_of_nonsingular_conic
    {K : Type u} [Field K] [IsAlgClosed K]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (hnonsing : ∀ y : Fin 3 → K, y ≠ 0 → eval y Q = 0 →
      ∃ i : Fin 3, eval y (pderiv i Q) ≠ 0)
    (x : Fin 3 → K) (hx0 : x ≠ 0) (hx : eval x Q = 0)
    (hxcoord : x 0 ≠ 0 ∨ x 2 ≠ 0) :
    ∃ u : Fin 3 → K,
      u ≠ 0 ∧ eval u Q = 0 ∧ u 2 ≠ 0 ∧
      polarEval Q u
        (fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i) ≠ 0 ∧
      x 0 - (x 2 * (u 2)⁻¹) * u 0 ≠ 0 := by
  classical
  let L2 : MvPolynomial (Fin 3) K := X 2
  let Lx : MvPolynomial (Fin 3) K := tangentForm Q x
  let L02 : MvPolynomial (Fin 3) K := C (x 0) * X 2 - C (x 2) * X 0
  let H := L2 * Lx * L02
  have hQ0 : Q ≠ 0 := by
    intro hzero
    obtain ⟨i, hi⟩ := hnonsing x hx0 hx
    rw [hzero] at hi
    simp at hi
  have hL2hom : L2.IsHomogeneous 1 := by
    exact isHomogeneous_X K (2 : Fin 3)
  have hLxhom : Lx.IsHomogeneous 1 := by
    exact tangentForm_isHomogeneous Q x
  have hL02hom : L02.IsHomogeneous 1 := by
    exact (isHomogeneous_C_mul_X (x 0) 2).sub
      (isHomogeneous_C_mul_X (x 2) 0)
  have hL20 : L2 ≠ 0 := by
    exact X_ne_zero (R := K) (2 : Fin 3)
  have hLx0 : Lx ≠ 0 := by
    have hgrad : tangentGradient Q x ≠ 0 := by
      obtain ⟨i, hi⟩ := hnonsing x hx0 hx
      intro hzero
      exact hi (by simpa [tangentGradient] using congrFun hzero i)
    exact (tangentGradient_ne_zero_iff Q x).mp hgrad
  have hL020 : L02 ≠ 0 := by
    rcases hxcoord with hx0c | hx2c
    · intro hzero
      apply hx0c
      have h := congrArg (eval (![0, 0, (1 : K)])) hzero
      simpa [L02] using h
    · intro hzero
      apply hx2c
      have h := congrArg (eval (![1, 0, (0 : K)])) hzero
      simpa [L02] using h
  have hHhom : H.IsHomogeneous 3 := by
    simpa [H] using (hL2hom.mul hLxhom).mul hL02hom
  have hH0 : H ≠ 0 := mul_ne_zero (mul_ne_zero hL20 hLx0) hL020
  have hnotDvdLinear (L : MvPolynomial (Fin 3) K)
      (hLhom : L.IsHomogeneous 1) (hL0 : L ≠ 0) : ¬ Q ∣ L := by
    intro hdvd
    have hle := totalDegree_le_of_dvd_of_isDomain hdvd hL0
    rw [hQ.totalDegree hQ0, hLhom.totalDegree hL0] at hle
    omega
  have hirr :=
    BConicBundleMultisections.TernaryQuadratic.irreducible_of_isHomogeneous_two_of_nonsingular
      Q hQ hQ0 hnonsing
  have hnotdvd : ¬ Q ∣ H := by
    intro hdvd
    rcases hirr.prime.dvd_mul.mp hdvd with hdvd | hdvd
    · rcases hirr.prime.dvd_mul.mp hdvd with hdvd | hdvd
      · exact hnotDvdLinear L2 hL2hom hL20 hdvd
      · exact hnotDvdLinear Lx hLxhom hLx0 hdvd
    · exact hnotDvdLinear L02 hL02hom hL020 hdvd
  have hprime : (Ideal.span ({Q} : Set (MvPolynomial (Fin 3) K))).IsPrime :=
    (Ideal.span_singleton_prime hQ0).mpr hirr.prime
  have hnotrad : H ∉ (Ideal.span ({Q} : Set (MvPolynomial (Fin 3) K))).radical := by
    rw [hprime.radical]
    intro hmem
    exact hnotdvd (Ideal.mem_span_singleton.mp hmem)
  obtain ⟨u, hu0, huQ, huH⟩ :=
    exists_projective_point_off_target_of_not_mem_radical
      Q H hHhom (by norm_num) hnotrad
  have huH' : u 2 * eval u Lx * (x 0 * u 2 - x 2 * u 0) ≠ 0 := by
    simpa [H, L2, L02] using huH
  obtain ⟨huLx, hdet⟩ := mul_ne_zero_iff.mp huH'
  obtain ⟨hu2, huLx⟩ := mul_ne_zero_iff.mp huLx
  have hBux : polarEval Q u x ≠ 0 := by
    rw [polarEval_comm]
    have heq : polarEval Q x u = eval u Lx := by
      simp [Lx, polarEval_eq_sum_pderiv hQ, eval_tangentForm, mul_comm]
    rw [heq]
    exact huLx
  let w := clearedStereoDifference u x
  have hwform : w = fun i ↦ u 2 * x i + (-x 2) * u i := by
    funext i
    simp [w, clearedStereoDifference]
    ring
  have hBw : polarEval Q u w = u 2 * polarEval Q u x := by
    rw [hwform, polarEval_linear_right hQ, polarEval_self hQ, huQ]
    ring
  have hBw0 : polarEval Q u w ≠ 0 := by
    rw [hBw]
    exact mul_ne_zero hu2 hBux
  have hw0 : w 0 ≠ 0 := by
    simpa [w, clearedStereoDifference, mul_comm] using hdet
  have hnormalized :
      (fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i) = (u 2)⁻¹ • w := by
    funext i
    simp only [Pi.smul_apply, smul_eq_mul]
    dsimp only [w, clearedStereoDifference]
    field_simp [hu2]
  refine ⟨u, hu0, huQ, hu2, ?_, ?_⟩
  · rw [hnormalized, polarEval_smul_right Q hQ]
    exact mul_ne_zero (inv_ne_zero hu2) hBw0
  · have hw0' : (((u 2)⁻¹ • w) : Fin 3 → K) 0 ≠ 0 := by
      simpa only [Pi.smul_apply, smul_eq_mul] using
        mul_ne_zero (inv_ne_zero hu2) hw0
    change (fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i) 0 ≠ 0
    rw [congrArg (fun z ↦ z 0) hnormalized]
    exact hw0'

/-- The local center may simultaneously be chosen off the tangent line of any fixed nonzero
isotropic base center.  This extra open is what makes the desired local center realizable by a
single global stereographic transform of a normalized Tsen section. -/
theorem exists_inverseStereo_center_open_avoiding_base_of_nonsingular_conic
    {K : Type u} [Field K] [IsAlgClosed K]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (hnonsing : ∀ y : Fin 3 → K, y ≠ 0 → eval y Q = 0 →
      ∃ i : Fin 3, eval y (pderiv i Q) ≠ 0)
    (x : Fin 3 → K) (hx0 : x ≠ 0) (hx : eval x Q = 0)
    (hxcoord : x 0 ≠ 0 ∨ x 2 ≠ 0)
    (u₀ : Fin 3 → K) (hu₀0 : u₀ ≠ 0) (hu₀ : eval u₀ Q = 0) :
    ∃ u : Fin 3 → K,
      u ≠ 0 ∧ eval u Q = 0 ∧ u 2 ≠ 0 ∧
      polarEval Q u
        (fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i) ≠ 0 ∧
      x 0 - (x 2 * (u 2)⁻¹) * u 0 ≠ 0 ∧
      polarEval Q u₀ u ≠ 0 := by
  classical
  let L2 : MvPolynomial (Fin 3) K := X 2
  let Lx : MvPolynomial (Fin 3) K := tangentForm Q x
  let L02 : MvPolynomial (Fin 3) K := C (x 0) * X 2 - C (x 2) * X 0
  let Lbase : MvPolynomial (Fin 3) K := tangentForm Q u₀
  let H := L2 * Lx * L02 * Lbase
  have hQ0 : Q ≠ 0 := by
    intro hzero
    obtain ⟨i, hi⟩ := hnonsing x hx0 hx
    rw [hzero] at hi
    simp at hi
  have hL2hom : L2.IsHomogeneous 1 := isHomogeneous_X K (2 : Fin 3)
  have hLxhom : Lx.IsHomogeneous 1 := tangentForm_isHomogeneous Q x
  have hL02hom : L02.IsHomogeneous 1 := by
    exact (isHomogeneous_C_mul_X (x 0) 2).sub
      (isHomogeneous_C_mul_X (x 2) 0)
  have hLbasehom : Lbase.IsHomogeneous 1 := tangentForm_isHomogeneous Q u₀
  have hL20 : L2 ≠ 0 := X_ne_zero (R := K) (2 : Fin 3)
  have hLx0 : Lx ≠ 0 := by
    have hgrad : tangentGradient Q x ≠ 0 := by
      obtain ⟨i, hi⟩ := hnonsing x hx0 hx
      intro hzero
      exact hi (by simpa [tangentGradient] using congrFun hzero i)
    exact (tangentGradient_ne_zero_iff Q x).mp hgrad
  have hL020 : L02 ≠ 0 := by
    rcases hxcoord with hx0c | hx2c
    · intro hzero
      apply hx0c
      have h := congrArg (eval (![0, 0, (1 : K)])) hzero
      simpa [L02] using h
    · intro hzero
      apply hx2c
      have h := congrArg (eval (![1, 0, (0 : K)])) hzero
      simpa [L02] using h
  have hLbase0 : Lbase ≠ 0 := by
    have hgrad : tangentGradient Q u₀ ≠ 0 := by
      obtain ⟨i, hi⟩ := hnonsing u₀ hu₀0 hu₀
      intro hzero
      exact hi (by simpa [tangentGradient] using congrFun hzero i)
    exact (tangentGradient_ne_zero_iff Q u₀).mp hgrad
  have hHhom : H.IsHomogeneous 4 := by
    simpa [H] using ((hL2hom.mul hLxhom).mul hL02hom).mul hLbasehom
  have hH0 : H ≠ 0 :=
    mul_ne_zero (mul_ne_zero (mul_ne_zero hL20 hLx0) hL020) hLbase0
  have hnotDvdLinear (L : MvPolynomial (Fin 3) K)
      (hLhom : L.IsHomogeneous 1) (hL0 : L ≠ 0) : ¬ Q ∣ L := by
    intro hdvd
    have hle := totalDegree_le_of_dvd_of_isDomain hdvd hL0
    rw [hQ.totalDegree hQ0, hLhom.totalDegree hL0] at hle
    omega
  have hirr :=
    BConicBundleMultisections.TernaryQuadratic.irreducible_of_isHomogeneous_two_of_nonsingular
      Q hQ hQ0 hnonsing
  have hnotdvd : ¬ Q ∣ H := by
    intro hdvd
    rcases hirr.prime.dvd_mul.mp hdvd with hdvd | hdvd
    · rcases hirr.prime.dvd_mul.mp hdvd with hdvd | hdvd
      · rcases hirr.prime.dvd_mul.mp hdvd with hdvd | hdvd
        · exact hnotDvdLinear L2 hL2hom hL20 hdvd
        · exact hnotDvdLinear Lx hLxhom hLx0 hdvd
      · exact hnotDvdLinear L02 hL02hom hL020 hdvd
    · exact hnotDvdLinear Lbase hLbasehom hLbase0 hdvd
  have hprime : (Ideal.span ({Q} : Set (MvPolynomial (Fin 3) K))).IsPrime :=
    (Ideal.span_singleton_prime hQ0).mpr hirr.prime
  have hnotrad : H ∉ (Ideal.span ({Q} : Set (MvPolynomial (Fin 3) K))).radical := by
    rw [hprime.radical]
    intro hmem
    exact hnotdvd (Ideal.mem_span_singleton.mp hmem)
  obtain ⟨u, hu0, huQ, huH⟩ :=
    exists_projective_point_off_target_of_not_mem_radical
      Q H hHhom (by norm_num) hnotrad
  have huH' :
      u 2 * eval u Lx * (x 0 * u 2 - x 2 * u 0) * eval u Lbase ≠ 0 := by
    simpa [H, L2, L02] using huH
  obtain ⟨hfirst, huLbase⟩ := mul_ne_zero_iff.mp huH'
  obtain ⟨huLx, hdet⟩ := mul_ne_zero_iff.mp hfirst
  obtain ⟨hu2, huLx⟩ := mul_ne_zero_iff.mp huLx
  have hBux : polarEval Q u x ≠ 0 := by
    rw [polarEval_comm]
    have heq : polarEval Q x u = eval u Lx := by
      simp [Lx, polarEval_eq_sum_pderiv hQ, eval_tangentForm, mul_comm]
    rw [heq]
    exact huLx
  have hBu₀u : polarEval Q u₀ u ≠ 0 := by
    have heq : polarEval Q u₀ u = eval u Lbase := by
      simp [Lbase, polarEval_eq_sum_pderiv hQ, eval_tangentForm, mul_comm]
    rw [heq]
    exact huLbase
  let w := clearedStereoDifference u x
  have hwform : w = fun i ↦ u 2 * x i + (-x 2) * u i := by
    funext i
    simp [w, clearedStereoDifference]
    ring
  have hBw : polarEval Q u w = u 2 * polarEval Q u x := by
    rw [hwform, polarEval_linear_right hQ, polarEval_self hQ, huQ]
    ring
  have hBw0 : polarEval Q u w ≠ 0 := by
    rw [hBw]
    exact mul_ne_zero hu2 hBux
  have hw0 : w 0 ≠ 0 := by
    simpa [w, clearedStereoDifference, mul_comm] using hdet
  have hnormalized :
      (fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i) = (u 2)⁻¹ • w := by
    funext i
    simp only [Pi.smul_apply, smul_eq_mul]
    dsimp only [w, clearedStereoDifference]
    field_simp [hu2]
  refine ⟨u, hu0, huQ, hu2, ?_, ?_, hBu₀u⟩
  · rw [hnormalized, polarEval_smul_right Q hQ]
    exact mul_ne_zero (inv_ne_zero hu2) hBw0
  · have hw0' : (((u 2)⁻¹ • w) : Fin 3 → K) 0 ≠ 0 := by
      simpa only [Pi.smul_apply, smul_eq_mul] using
        mul_ne_zero (inv_ne_zero hu2) hw0
    change (fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i) 0 ≠ 0
    rw [congrArg (fun z ↦ z 0) hnormalized]
    exact hw0'

/-- A normalized Tsen section plus nonsingularity of one fibre already gives the required
prescribed-specialization statement: choose a locally good center off the tangent of the old
center, then apply the global ring-level stereographic formula with that center as constant
direction.  Thus no separate weak-approximation axiom is needed for a single prescribed fibre. -/
theorem exists_isotropic_section_realizing_inverseStereo_center_at_zero
    {K : Type u} [Field K] [IsAlgClosed K]
    (Q : MvPolynomial (Fin 3) (Polynomial K)) (hQ : Q.IsHomogeneous 2)
    (v₀ : Fin 3 → Polynomial K) (hv₀0 : v₀ ≠ 0) (hv₀ : eval v₀ Q = 0)
    (hnonsing : ∀ y : Fin 3 → K, y ≠ 0 →
      eval y (map (Polynomial.evalRingHom 0) Q) = 0 →
      ∃ i : Fin 3, eval y (pderiv i (map (Polynomial.evalRingHom 0) Q)) ≠ 0)
    (x : Fin 3 → K) (hx0 : x ≠ 0)
    (hx : eval x (map (Polynomial.evalRingHom 0) Q) = 0)
    (hxcoord : x 0 ≠ 0 ∨ x 2 ≠ 0) :
    ∃ (v : Fin 3 → Polynomial K) (u : Fin 3 → K),
      v ≠ 0 ∧ eval v Q = 0 ∧
      u ≠ 0 ∧ eval u (map (Polynomial.evalRingHom 0) Q) = 0 ∧ u 2 ≠ 0 ∧
      polarEval (map (Polynomial.evalRingHom 0) Q) u
        (fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i) ≠ 0 ∧
      x 0 - (x 2 * (u 2)⁻¹) * u 0 ≠ 0 ∧
      TsenSectionRealizesCenterAt v 0 u := by
  classical
  let phi := Polynomial.evalRingHom (0 : K)
  let Q₀ := map phi Q
  obtain ⟨vbase, hvbase0, hvbase, hvaluebase⟩ :=
    exists_isotropic_section_nonzero_at_zero Q hQ v₀ hv₀0 hv₀
  let u₀ := evalPolySection vbase 0
  have hu₀0 : u₀ ≠ 0 := hvaluebase
  have hu₀ : eval u₀ Q₀ = 0 := by
    have hmap := map_eval phi vbase Q
    rw [hvbase, map_zero] at hmap
    exact hmap.symm
  obtain ⟨u, hu0, hu, hu2, hB, hw0, hbase⟩ :=
    exists_inverseStereo_center_open_avoiding_base_of_nonsingular_conic
      Q₀ (hQ.map phi) hnonsing x hx0 hx hxcoord u₀ hu₀0 hu₀
  let w : Fin 3 → Polynomial K := fun i ↦ Polynomial.C (u i)
  let v := stereoAlg Q vbase w
  have hviso : eval v Q = 0 :=
    stereoAlg_isotropic Q hQ vbase w hvbase
  have hspecialize : evalPolySection v 0 = stereoAlg Q₀ u₀ u := by
    have hmap := map_stereoAlg phi Q vbase w
    have hleft : (fun i ↦ phi (stereoAlg Q vbase w i)) = evalPolySection v 0 := by
      rfl
    have hbaseeval : (fun i ↦ phi (vbase i)) = u₀ := by
      rfl
    have hweval : (fun i ↦ phi (w i)) = u := by
      funext i
      simp [w, phi]
    rw [hleft, hbaseeval, hweval] at hmap
    exact hmap
  let c := -polarEval Q₀ u₀ u
  have hc : c ≠ 0 := neg_ne_zero.mpr hbase
  have hrealize_value : evalPolySection v 0 = c • u := by
    rw [hspecialize]
    funext i
    simp only [stereoAlg, hu, zero_mul, zero_sub, Pi.smul_apply, smul_eq_mul, c]
    ring
  have hrealize : TsenSectionRealizesCenterAt v 0 u :=
    ⟨c, hc, hrealize_value⟩
  have hv0 : v ≠ 0 := by
    intro hzero
    have hcu : c • u = 0 := by
      rw [← hrealize_value, hzero]
      funext i
      change Polynomial.eval 0 ((0 : Fin 3 → Polynomial K) i) = 0
      simp
    exact hu0 ((smul_eq_zero.mp hcu).resolve_left hc)
  exact ⟨v, u, hv0, hviso, hu0, hu, hu2, hB, hw0, hrealize⟩

/-! ## One-line G3--G4 selection under an explicit nonsingular-fibre hypothesis -/

/-- The pointwise tangent-residual witness strengthened only by the two hypotheses needed for the
local center construction: nonsingularity of the first-block conic over `p`, and exclusion of the
fixed omitted point `[0:1:0]` for the target `x`. -/
def HasNonsingularPointwiseG4Witness
    {K : Type u} [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (p q : Fin 3 → K) : Prop :=
  ∃ x : Fin 3 → K,
    x ≠ 0 ∧
    IsSmoothPlaneCubic (specializeFirstCoordinates (n := 2) x F) ∧
    p ≠ 0 ∧
    eval p (specializeFirstCoordinates (n := 2) x F) = 0 ∧
    LinearIndependent K ![p, q] ∧
    q ∈ tangentHyperplaneCone (specializeFirstCoordinates (n := 2) x F) p ∧
    eval
        (residualAmbientRep p q
          (binaryLineRestriction p q
            (specializeFirstCoordinates (n := 2) x F)))
        (sndConicDiscriminant F) ≠ 0 ∧
    (∀ y : Fin 3 → K, y ≠ 0 → eval y (lineSpecializedConic p q F 0) = 0 →
      ∃ i : Fin 3, eval y (pderiv i (lineSpecializedConic p q F 0)) ≠ 0) ∧
    (x 0 ≠ 0 ∨ x 2 ≠ 0)

/-- A chosen framed G3 line carrying a nonsingular pointwise-G4 witness admits a polynomial Tsen
section that realizes a locally good conic center at `t = 0`.  The resulting cleared certificate
is nonzero at `0`, so the same line satisfies the actual polynomial G4 predicate.

This is the strongest direct one-line bridge: its remaining geometric input is exactly existence
of a G3 line with `HasNonsingularPointwiseG4Witness`; there is no additional section-interpolation
or weak-approximation assumption. -/
theorem exists_actualG3G4LineSection_of_G3_of_nonsingularPointwiseG4Witness
    {K : Type u} [Field K] [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [AlgebraicGeometry.Smooth
      (BiprojectiveSpace.biprojectiveZeroLocusToSpec 2 2 K F)]
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1)
    (hG3 : ResidualLineNonconstantOn (lineFrame p q r) N F)
    (hpoint : HasNonsingularPointwiseG4Witness F p q) :
    ∃ (x : Fin 3 → K) (v : Fin 3 → Polynomial K) (u : Fin 3 → K),
      HasActualG3G4LineSection F p q r N v ∧
      TsenSectionRealizesCenterAt v 0 u ∧
      pointwiseG4StereoCertificateAt p q F v 0 x ≠ 0 ∧
      pointwiseG4StereoCertificatePoly p q F v x ≠ 0 := by
  classical
  obtain ⟨x, hx0, hsmooth, hp0, hp, hpq, hq, havoid, hnonsing, hxcoord⟩ := hpoint
  obtain ⟨v₀, hv₀0, hv₀⟩ := exists_isotropic_line_conic K p q F
  have hQhom : (lineSpecializedConicPoly p q F).IsHomogeneous 2 :=
    lineSpecializedConicPoly_isHomogeneous p q hF
  have hv₀' : eval v₀ (lineSpecializedConicPoly p q F) = 0 := by
    rw [← ternaryQuadraticPoly_eval_line p q F hF]
    exact hv₀
  have hnonsing' : ∀ y : Fin 3 → K, y ≠ 0 →
      eval y (map (Polynomial.evalRingHom 0) (lineSpecializedConicPoly p q F)) = 0 →
      ∃ i : Fin 3,
        eval y (pderiv i
          (map (Polynomial.evalRingHom 0) (lineSpecializedConicPoly p q F))) ≠ 0 := by
    simpa only [map_eval_lineSpecializedConicPoly] using hnonsing
  have hx : eval x
      (map (Polynomial.evalRingHom 0) (lineSpecializedConicPoly p q F)) = 0 := by
    rw [map_eval_lineSpecializedConicPoly]
    simpa [lineSpecializedConic] using hp
  obtain ⟨v, u, hv0, hviso, hu0, hu, hu2, hB, hw0, hrealize⟩ :=
    exists_isotropic_section_realizing_inverseStereo_center_at_zero
      (lineSpecializedConicPoly p q F) hQhom v₀ hv₀0 hv₀'
      hnonsing' x hx0 hx hxcoord
  have hviso' : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0 := by
    rw [ternaryQuadraticPoly_eval_line p q F hF]
    exact hviso
  have hB' : polarEval (lineSpecializedConic p q F 0) u
      (fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i) ≠ 0 := by
    simpa only [map_eval_lineSpecializedConicPoly] using hB
  have hcert : pointwiseG4StereoCertificateAt p q F v 0 x ≠ 0 :=
    pointwiseG4StereoCertificateAt_ne_zero_of_realizes_center
      p q F hF v 0 x u hu2 hB' hw0 hrealize
  have haccessible : HasStereoAccessiblePointwiseG4 F p q v :=
    ⟨x, hx0, hsmooth, hp0, hp, hpq, hq, havoid, hcert⟩
  have hactual : HasActualG3G4LineSection F p q r N v :=
    hasActualG3G4LineSection_of_isotropic_of_stereoAccessiblePointwiseG4
      F hF hF0 p q r N v hMN hG3 hviso' haccessible
  have hcertPoly : pointwiseG4StereoCertificatePoly p q F v x ≠ 0 :=
    pointwiseG4StereoCertificatePoly_ne_zero_of_realizes_center
      p q F hF v 0 x u hu2 hB' hw0 hrealize
  exact ⟨x, v, u, hactual, hrealize, hcert, hcertPoly⟩

/-- Existential line-selection interface exposing the sole remaining geometric task.  Any family
argument that produces one framed G3 line with `HasNonsingularPointwiseG4Witness` immediately
produces the actual G3--G4 line and Tsen section required downstream. -/
theorem exists_actualG3G4LineSection_of_exists_G3_nonsingularPointwiseG4Witness
    {K : Type u} [Field K] [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [AlgebraicGeometry.Smooth
      (BiprojectiveSpace.biprojectiveZeroLocusToSpec 2 2 K F)]
    (h : ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K),
      lineFrame p q r * N = 1 ∧
      ResidualLineNonconstantOn (lineFrame p q r) N F ∧
      HasNonsingularPointwiseG4Witness F p q) :
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
        (v : Fin 3 → Polynomial K),
      HasActualG3G4LineSection F p q r N v := by
  obtain ⟨p, q, r, N, hMN, hG3, hpoint⟩ := h
  obtain ⟨x, v, u, hactual, _⟩ :=
    exists_actualG3G4LineSection_of_G3_of_nonsingularPointwiseG4Witness
      F hF hF0 p q r N hMN hG3 hpoint
  exact ⟨p, q, r, N, v, hactual⟩

end

end BConicBundleMultisections.Standard
