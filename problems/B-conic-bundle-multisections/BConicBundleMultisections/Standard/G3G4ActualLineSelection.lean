/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Standard.G4PointwiseLine

/-!
# The exact G3--G4 line-selection boundary

This module keeps the two proved statements and the remaining common-line certificate separate.

* Axiom-cleanly, a smooth bidegree-`(2,3)` equation has a G3 line equipped with a
  nondegenerate Tsen--stereographic section, and it has a (possibly different) pointwise-G4
  tangent line equipped with such a section.
* G3 is equivalent to the existence of one nonzero `2 x 2` coefficient minor.  This makes its
  polynomial-open nature completely explicit.
* A pointwise-G4 tangent witness gives polynomial G4 on the same line as soon as one polynomial
  Tsen section satisfies one concrete inverse-stereographic nonvanishing certificate at that
  witness.

Every declaration in this module is axiom-clean.  In particular, this module deliberately does
not import or use the `sorry`-backed residual-horizontality frontier.
-/

@[expose] public section

namespace BConicBundleMultisections.Standard

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial
open scoped Matrix

/-- The actual package requested of one framed line and one Tsen section. -/
def HasActualG3G4LineSection
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (v : Fin 3 → Polynomial k) : Prop :=
  lineFrame p q r * N = 1 ∧
    ResidualLineNonconstantOn (lineFrame p q r) N F ∧
    HasNondegenerateLineStereoSection F p q v ∧
    ResidualAvoidsConicDiscriminantOn p q r N F v

/-- The strongest currently axiom-clean unconditional selection statement.

Both lines carry all section data needed downstream, but the witnesses are deliberately kept
separate.  Identifying them requires the missing open-intersection/dominant-stereo bridge. -/
theorem exists_G3_section_and_pointwiseG4_section_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    (∃ (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
        (v : Fin 3 → Polynomial k),
      lineFrame p q r * N = 1 ∧
        ResidualLineNonconstantOn (lineFrame p q r) N F ∧
        HasNondegenerateLineStereoSection F p q v) ∧
    (∃ (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
        (v : Fin 3 → Polynomial k),
      lineFrame p q r * N = 1 ∧
        PointwiseG4TangentLine F p q ∧
        HasNondegenerateLineStereoSection F p q v) := by
  obtain ⟨p₃, q₃, r₃, N₃, hframe₃, hG3⟩ := exists_good_line F hF hF0
  obtain ⟨v₃, hv₃₀, hv₃, hv₃₂, hpolar₃⟩ :=
    exists_isotropic_line_stereoNondegenerate_of_smooth
      p₃ q₃ r₃ N₃ hframe₃ F hF hF0
  refine ⟨⟨p₃, q₃, r₃, N₃, v₃, hframe₃, hG3,
    hv₃₀, hv₃, hv₃₂, hpolar₃⟩, ?_⟩
  exact exists_pointwiseG4TangentLine_with_stereoSection_of_smooth F hF hF0

/-! ## An exact finite certificate for G3 -/

/-- Conversely to `residualLineNonconstantOn_of_coeff_minor_ne_zero`, every nonconstant residual
line has a nonzero coefficient minor.  Thus G3 is exactly a finite-dimensional rank-at-least-two
condition on the three coefficient forms. -/
theorem exists_coeff_minor_ne_zero_of_residualLineNonconstantOn
    {K : Type u} [Field K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hG3 : ResidualLineNonconstantOn M N F) :
    ∃ (a b : Fin 3) (m n : Fin 3 →₀ ℕ),
      coeff m (residualLineCoeffOn M N F a) *
          coeff n (residualLineCoeffOn M N F b) -
        coeff n (residualLineCoeffOn M N F a) *
          coeff m (residualLineCoeffOn M N F b) ≠ 0 := by
  classical
  by_contra hminor
  push Not at hminor
  apply hG3
  let qf : Fin 3 → MvPolynomial (Fin 3) K := fun a ↦ residualLineCoeffOn M N F a
  by_cases hall : ∀ a : Fin 3, qf a = 0
  · refine ⟨0, fun _ ↦ 0, ?_⟩
    intro a
    simp [qf, hall a]
  · push Not at hall
    obtain ⟨a, ha⟩ := hall
    obtain ⟨m, hm⟩ := MvPolynomial.ne_zero_iff.mp ha
    refine ⟨qf a, fun b ↦ coeff m (qf b) * (coeff m (qf a))⁻¹, ?_⟩
    intro b
    apply MvPolynomial.ext
    intro n
    rw [coeff_C_mul]
    have hab := hminor a b m n
    change coeff m (qf a) * coeff n (qf b) -
      coeff n (qf a) * coeff m (qf b) = 0 at hab
    field_simp [hm]
    linear_combination hab

/-- G3 is equivalent to one explicit nonzero coefficient minor. -/
theorem residualLineNonconstantOn_iff_exists_coeff_minor_ne_zero
    {K : Type u} [Field K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) :
    ResidualLineNonconstantOn M N F ↔
      ∃ (a b : Fin 3) (m n : Fin 3 →₀ ℕ),
        coeff m (residualLineCoeffOn M N F a) *
            coeff n (residualLineCoeffOn M N F b) -
          coeff n (residualLineCoeffOn M N F a) *
            coeff m (residualLineCoeffOn M N F b) ≠ 0 := by
  constructor
  · exact exists_coeff_minor_ne_zero_of_residualLineNonconstantOn M N F
  · rintro ⟨a, b, m, n, hminor⟩
    exact residualLineNonconstantOn_of_coeff_minor_ne_zero M N F a b m n hminor

/-! ## The exact inverse-stereographic certificate for pointwise G4 -/

/-- The denominator-free difference between a target `x` and a specialized polynomial section
`u`.  Dividing this vector by `u 2` gives the normalized difference used by the inverse-stereo
lemma, but this definition is polynomial in all of its entries. -/
def clearedStereoDifference
    {K : Type u} [Field K] (u x : Fin 3 → K) : Fin 3 → K :=
  fun i ↦ u 2 * x i - x 2 * u i

/-- A single denominator-free scalar whose nonvanishing places a target in the affine
stereographic chart of the specialized Tsen section.

Its three factors say respectively that the section has nonzero third coordinate, that its polar
pairing with the target direction is nonzero, and that the direction is not the omitted point at
infinity. -/
def pointwiseG4StereoCertificateAt
    {K : Type u} [Field K]
    (p q : Fin 3 → K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (v : Fin 3 → Polynomial K) (t : K) (x : Fin 3 → K) : K :=
  let Q := lineSpecializedConic p q F t
  let u := evalPolySection v t
  let w := clearedStereoDifference u x
  u 2 * polarEval Q u w * w 0

/-- Nonvanishing of the cleared certificate implies exactly the three affine inverse-stereo open
conditions. -/
theorem inverseStereo_open_of_pointwiseG4StereoCertificateAt_ne_zero
    {K : Type u} [Field K]
    (p q : Fin 3 → K)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial K) (t : K) (x : Fin 3 → K)
    (hcert : pointwiseG4StereoCertificateAt p q F v t x ≠ 0) :
    evalPolySection v t 2 ≠ 0 ∧
      polarEval (lineSpecializedConic p q F t) (evalPolySection v t)
        (fun i ↦ x i - (x 2 * (evalPolySection v t 2)⁻¹) *
          evalPolySection v t i) ≠ 0 ∧
      x 0 - (x 2 * (evalPolySection v t 2)⁻¹) *
        evalPolySection v t 0 ≠ 0 := by
  let Q := lineSpecializedConic p q F t
  let u := evalPolySection v t
  let w := clearedStereoDifference u x
  change u 2 * polarEval Q u w * w 0 ≠ 0 at hcert
  obtain ⟨huB, hw0⟩ := mul_ne_zero_iff.mp hcert
  obtain ⟨hu2, hB⟩ := mul_ne_zero_iff.mp huB
  have hQ : Q.IsHomogeneous 2 := lineSpecializedConic_isHomogeneous p q hF t
  have hnormalized :
      (fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i) = (u 2)⁻¹ • w := by
    funext i
    simp only [Pi.smul_apply, smul_eq_mul]
    dsimp only [w, clearedStereoDifference]
    field_simp [hu2]
  refine ⟨hu2, ?_, ?_⟩
  · rw [hnormalized, polarEval_smul_right Q hQ]
    exact mul_ne_zero (inv_ne_zero hu2) hB
  · have hw0' : ((u 2)⁻¹ • w) 0 ≠ 0 := by
      simpa only [Pi.smul_apply, smul_eq_mul] using
        mul_ne_zero (inv_ne_zero hu2) hw0
    change (fun i ↦ x i - (x 2 * (u 2)⁻¹) * u i) 0 ≠ 0
    rw [congrArg (fun z ↦ z 0) hnormalized]
    exact hw0'

/-- The exact pointwise-G4 witness augmented by the one scalar certificate needed to make that
witness accessible to the chosen polynomial Tsen section. -/
def HasStereoAccessiblePointwiseG4
    {K : Type u} [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (p q : Fin 3 → K) (v : Fin 3 → Polynomial K) : Prop :=
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
    pointwiseG4StereoCertificateAt p q F v 0 x ≠ 0

/-- Forgetting accessibility recovers the pointwise-G4 predicate. -/
theorem HasStereoAccessiblePointwiseG4.pointwiseG4TangentLine
    {K : Type u} [Field K]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K}
    {p q : Fin 3 → K} {v : Fin 3 → Polynomial K}
    (h : HasStereoAccessiblePointwiseG4 F p q v) :
    PointwiseG4TangentLine F p q := by
  obtain ⟨x, hx0, hsmooth, hp0, hp, hpq, hq, havoid, _⟩ := h
  exact ⟨x, hx0, hsmooth, hp0, hp, hpq, hq, havoid⟩

/-- The cleared inverse-stereo certificate converts a pointwise tangent-residual witness into the
actual polynomial G4 predicate for the same framed line and the same Tsen section. -/
theorem residualAvoidsConicDiscriminantOn_of_stereoAccessiblePointwiseG4
    {K : Type u} [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1)
    (v : Fin 3 → Polynomial K)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0)
    (hG4 : HasStereoAccessiblePointwiseG4 F p q v) :
    ResidualAvoidsConicDiscriminantOn p q r N F v := by
  obtain ⟨x, hx0, hsmooth, hp0, hp, hpq, hq, havoid, hcert⟩ := hG4
  obtain ⟨hv2, hB, hw0⟩ :=
    inverseStereo_open_of_pointwiseG4StereoCertificateAt_ne_zero
      p q F hF v 0 x hcert
  have hx : eval x (lineSpecializedConic p q F 0) = 0 := by
    simpa [lineSpecializedConic] using hp
  obtain ⟨s, a, ha, hstereo⟩ :=
    exists_evalAffineTwoPoint_stereoFirstCoordsOn_eq_smul
      p q F hF v hv 0 x hv2 hx hB hw0
  apply residualAvoidsConicDiscriminantOn_of_specialized_frameTangentResidual
    p q r N F v 0 s
  simp only [hstereo, linePointOf_zero]
  rw [hF.specializeFirstCoordinates_smul]
  exact eval_frameTangentResidual_C_mul_ne_zero_of_smooth_tangent
    p q r N hMN (specializeFirstCoordinates (n := 2) x F) hsmooth hp hq
    (sndConicDiscriminant F) 9 (sndConicDiscriminant_isHomogeneous F hF)
    havoid (a ^ 2) (pow_ne_zero 2 ha)

/-- Under global smoothness, accessibility at one point already upgrades an isotropic polynomial
section to the full nondegenerate-section package.  In particular, section nondegeneracy is not a
second missing input beside the cleared scalar certificate. -/
theorem hasNondegenerateLineStereoSection_of_isotropic_of_stereoAccessiblePointwiseG4
    {K : Type u} [Field K] [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (hMN : lineFrame p q r * N = 1)
    (v : Fin 3 → Polynomial K)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0)
    (hG4 : HasStereoAccessiblePointwiseG4 F p q v) :
    HasNondegenerateLineStereoSection F p q v := by
  obtain ⟨x, hx0, hsmooth, hp0, hp, hpq, hq, havoid, hcert⟩ := hG4
  have hv20 :=
    (inverseStereo_open_of_pointwiseG4StereoCertificateAt_ne_zero
      p q F hF v 0 x hcert).1
  have hv2 : v 2 ≠ 0 := by
    intro hz
    apply hv20
    simp [evalPolySection, hz]
  have hv0 : v ≠ 0 := by
    intro hz
    apply hv2
    simp [hz]
  have hdisc : lineConicDiscriminant p q F ≠ 0 :=
    lineConicDiscriminant_ne_zero_of_smooth p q r N hMN F hF hF0
  have hQhom : (lineSpecializedConicPoly p q F).IsHomogeneous 2 :=
    lineSpecializedConicPoly_isHomogeneous p q hF
  have hviso : eval v (lineSpecializedConicPoly p q F) = 0 := by
    rw [← ternaryQuadraticPoly_eval_line p q F hF]
    exact hv
  have hp := polarEval_ne_zero_of_isotropic_of_third_ne_zero
    hQhom hdisc hviso hv2
  exact ⟨hv0, hv, hv2,
    polarEval_lineStereoDir_ne_zero_of_polarEval_ne_zero p q F hF v hp⟩

/-- On a fixed framed line, G3 plus the accessible pointwise-G4 certificate gives the full package
used downstream. -/
theorem hasActualG3G4LineSection_of_stereoAccessiblePointwiseG4
    {K : Type u} [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (v : Fin 3 → Polynomial K)
    (hMN : lineFrame p q r * N = 1)
    (hG3 : ResidualLineNonconstantOn (lineFrame p q r) N F)
    (hsection : HasNondegenerateLineStereoSection F p q v)
    (hG4 : HasStereoAccessiblePointwiseG4 F p q v) :
    HasActualG3G4LineSection F p q r N v := by
  refine ⟨hMN, hG3, hsection, ?_⟩
  exact residualAvoidsConicDiscriminantOn_of_stereoAccessiblePointwiseG4
    F hF p q r N hMN v hsection.2.1 hG4

/-- Stronger smooth fixed-line endpoint: after G3, isotropy and the one cleared pointwise-G4
certificate are sufficient for the complete actual package. -/
theorem hasActualG3G4LineSection_of_isotropic_of_stereoAccessiblePointwiseG4
    {K : Type u} [Field K] [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (v : Fin 3 → Polynomial K)
    (hMN : lineFrame p q r * N = 1)
    (hG3 : ResidualLineNonconstantOn (lineFrame p q r) N F)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0)
    (hG4 : HasStereoAccessiblePointwiseG4 F p q v) :
    HasActualG3G4LineSection F p q r N v := by
  have hsection :=
    hasNondegenerateLineStereoSection_of_isotropic_of_stereoAccessiblePointwiseG4
      F hF hF0 p q r N hMN v hv hG4
  exact hasActualG3G4LineSection_of_stereoAccessiblePointwiseG4
    F hF p q r N v hMN hG3 hsection hG4

/-- Fully coefficient-certified fixed-line form.  The first nonzero scalar is one G3 coefficient
minor; `HasStereoAccessiblePointwiseG4` contains the second, the cleared inverse-stereo scalar at
one pointwise-G4 witness. -/
theorem hasActualG3G4LineSection_of_coeffMinor_of_stereoCertificate
    {K : Type u} [Field K] [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
    (v : Fin 3 → Polynomial K)
    (hMN : lineFrame p q r * N = 1)
    (a b : Fin 3) (m n : Fin 3 →₀ ℕ)
    (hminor :
      coeff m (residualLineCoeffOn (lineFrame p q r) N F a) *
          coeff n (residualLineCoeffOn (lineFrame p q r) N F b) -
        coeff n (residualLineCoeffOn (lineFrame p q r) N F a) *
          coeff m (residualLineCoeffOn (lineFrame p q r) N F b) ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0)
    (hG4 : HasStereoAccessiblePointwiseG4 F p q v) :
    HasActualG3G4LineSection F p q r N v := by
  have hG3 := residualLineNonconstantOn_of_coeff_minor_ne_zero
    (lineFrame p q r) N F a b m n hminor
  exact hasActualG3G4LineSection_of_isotropic_of_stereoAccessiblePointwiseG4
    F hF hF0 p q r N v hMN hG3 hv hG4

/-- Existential endpoint exposing the sole remaining common-line input.  Proving the displayed
accessible-witness existence (for example by a polynomial-open family or prescribed-specialization
argument) immediately gives the requested actual G3+G4 line. -/
theorem exists_actualG3G4LineSection_of_exists_stereoAccessible_goodLine
    {K : Type u} [Field K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K) (hF : IsBidegree23 F)
    (h : ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
        (v : Fin 3 → Polynomial K),
      lineFrame p q r * N = 1 ∧
      ResidualLineNonconstantOn (lineFrame p q r) N F ∧
      HasNondegenerateLineStereoSection F p q v ∧
      HasStereoAccessiblePointwiseG4 F p q v) :
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
        (v : Fin 3 → Polynomial K),
      HasActualG3G4LineSection F p q r N v := by
  obtain ⟨p, q, r, N, v, hMN, hG3, hsection, hG4⟩ := h
  exact ⟨p, q, r, N, v,
    hasActualG3G4LineSection_of_stereoAccessiblePointwiseG4
      F hF p q r N v hMN hG3 hsection hG4⟩

/-- Smooth existential endpoint with the irredundant input: a framed G3 line, an isotropic
polynomial section, and one pointwise witness where the cleared scalar certificate is nonzero. -/
theorem exists_actualG3G4LineSection_of_exists_isotropic_stereoAccessible_goodLine
    {K : Type u} [Field K] [IsAlgClosed K] [NeZero (2 : K)] [NeZero (3 : K)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)]
    (h : ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
        (v : Fin 3 → Polynomial K),
      lineFrame p q r * N = 1 ∧
      ResidualLineNonconstantOn (lineFrame p q r) N F ∧
      TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0 ∧
      HasStereoAccessiblePointwiseG4 F p q v) :
    ∃ (p q r : Fin 3 → K) (N : Matrix (Fin 3) (Fin 3) K)
        (v : Fin 3 → Polynomial K),
      HasActualG3G4LineSection F p q r N v := by
  obtain ⟨p, q, r, N, v, hMN, hG3, hv, hG4⟩ := h
  exact ⟨p, q, r, N, v,
    hasActualG3G4LineSection_of_isotropic_of_stereoAccessiblePointwiseG4
      F hF hF0 p q r N v hMN hG3 hv hG4⟩

end

end BConicBundleMultisections.Standard
