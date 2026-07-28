/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.MainTheorem
public import BConicBundleMultisections.PointedSmoothConicParam
public import BConicBundleMultisections.SectionGeneralPosition
public import BConicBundleMultisections.Standard.G3FrameIncidenceSelection
public import BConicBundleMultisections.Standard.G3G4ActualLineSelection
public import BConicBundleMultisections.ResidualDiscriminantAvoidance

/-!
# Minimal-hypothesis line section (Goal D / D′)

Weakens `HasActualG3G4LineSection` by dropping stereographic polar nonvanishing from the hypothesis
surface.  Polar nonvanishing is derived from `v 2 ≠ 0` + disc.

## Scaling degrees (proved)

* **Polar form** (`lineStereoPolarForm`): degree **1** in the section.
* **Stereo first coords**: degree **1** (`stereoAlg` left-linear).
* **Residual `Y`-coordinates**: degree **8** in the section — `residualYCoordsOn_mul`
  (stereo `λ` · cubic fibre `λ²` · frame-tangent residual `μ⁴` with `μ = λ²`).
* **G4**: discriminant degree 9 ⇒ pullback scales by `λ⁷²`; invariant under nonzero scaling via
  `ResidualAvoidsConicDiscriminantOn_of_mul_section` (no residual-`Y` hypothesis).

## Residual-line upgrade for `v 2 = 0` (partial)

* Third-coordinate content of the polar-adapted residual line is a nonzero univariate
  (`stereoLineParamPoly_third_ne_zero_of_base_third_eq_zero`).
* G4 at `s = 0` (where `fam(0)` is a nonzero multiple of `v`) is the degree-8 scaling lemma.
* **Open:** residual-disc content along `fam(s)` as a nonzero univariate in the family parameter,
  for excision over `RatFunc k` jointly with the third-coordinate content.  Until that package
  exists, the final `…_of_lineSection'` (no `Infinite`, no `v 2 ≠ 0`) is not claimed; the
  `v 2 ≠ 0` path without `Infinite` is `…_of_lineSection_noInfinite`.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open Matrix AlgebraicGeometry
open _root_.MvPolynomial
open scoped Matrix

variable {k : Type u} [Field k]

/-! ### D1 — minimal predicate -/

namespace Standard

/-- Framed G3 line + smooth generic conic + bare isotropic section + G4 for **this** section. -/
def HasGoodLineWithSection
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (v : Fin 3 → Polynomial k) : Prop :=
  lineFrame p q r * N = 1 ∧
    ResidualLineNonconstantOn (lineFrame p q r) N F ∧
    lineConicDiscriminant p q F ≠ 0 ∧
    v ≠ 0 ∧
    TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0 ∧
    ResidualAvoidsConicDiscriminantOn p q r N F v

theorem HasActualG3G4LineSection.to_HasGoodLineWithSection
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (v : Fin 3 → Polynomial k)
    (h : HasActualG3G4LineSection F p q r N v)
    (hdisc : lineConicDiscriminant p q F ≠ 0) :
    HasGoodLineWithSection F p q r N v := by
  rcases h with ⟨hMN, hG3, ⟨hv0, hviso, _, _⟩, hG4⟩
  exact ⟨hMN, hG3, hdisc, hv0, hviso, hG4⟩

end Standard

/-! ### Scaling (degree 1 polar) -/

theorem stereoAlg_smul_left {R : Type u} [CommRing R]
    (Q : MvPolynomial (Fin 3) R) (hQ : Q.IsHomogeneous 2)
    (c : R) (p w : Fin 3 → R) :
    stereoAlg Q (fun i => c * p i) w = fun i => c * stereoAlg Q p w i := by
  funext i
  have hpol : polarEval Q (fun j => c * p j) w = c * polarEval Q p w := by
    simpa using polarEval_linear_left hQ c (0 : R) p (0 : Fin 3 → R) w
  simp only [stereoAlg, hpol]
  ring

theorem liftTsenSection_mul (φ : Polynomial k) (v : Fin 3 → Polynomial k) :
    liftTsenSection (fun i => φ * v i) =
      fun i => liftPolyT φ * liftTsenSection v i := by
  funext i
  simp only [liftTsenSection, liftPolyT]
  rw [← Polynomial.eval₂_mul]

theorem stereoFirstCoordsOn_mul
    (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (φ : Polynomial k) (v : Fin 3 → Polynomial k) :
    stereoFirstCoordsOn p₀ q₀ F (fun i => φ * v i) =
      fun i => liftPolyT φ * stereoFirstCoordsOn p₀ q₀ F v i := by
  have hQ : (lineSpecializedConicPullback p₀ q₀ F).IsHomogeneous 2 :=
    lineSpecializedConicPullback_isHomogeneous p₀ q₀ hF
  funext i
  simp only [stereoFirstCoordsOn, liftTsenSection_mul]
  simpa using
    congrFun
      (stereoAlg_smul_left (lineSpecializedConicPullback p₀ q₀ F) hQ
        (liftPolyT φ) (liftTsenSection v) affineTwoStereoDir) i

theorem lineStereoPolarForm_mul
    (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (φ : Polynomial k) (v : Fin 3 → Polynomial k) :
    lineStereoPolarForm p₀ q₀ F (fun i => φ * v i) =
      liftPolyT φ * lineStereoPolarForm p₀ q₀ F v := by
  have hQ : (lineSpecializedConicPullback p₀ q₀ F).IsHomogeneous 2 :=
    lineSpecializedConicPullback_isHomogeneous p₀ q₀ hF
  simp only [lineStereoPolarForm, liftTsenSection_mul]
  simpa using
    polarEval_linear_left hQ (liftPolyT φ) (0 : affineTwoRing k)
      (liftTsenSection v) (0 : Fin 3 → affineTwoRing k) affineTwoStereoDir

/-- G4 invariant when residual `Y` scales by a nonzero common factor. -/
theorem ResidualAvoidsConicDiscriminantOn_of_smul_residualY
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v v' : Fin 3 → Polynomial k) (a : affineTwoRing k) (ha : a ≠ 0)
    (hY : residualYCoordsOn p₀ q₀ r N F v' =
      fun i => a * residualYCoordsOn p₀ q₀ r N F v i)
    (h : ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v) :
    ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v' := by
  intro h0
  apply h
  have hsmul :
      residualConicDiscriminantOn p₀ q₀ r N F v' =
        a ^ 9 * residualConicDiscriminantOn p₀ q₀ r N F v := by
    simp only [residualConicDiscriminantOn, hY]
    exact aeval_sndConicDiscriminant_smul F hF a (residualYCoordsOn p₀ q₀ r N F v)
  rw [hsmul] at h0
  exact (mul_eq_zero.mp h0).resolve_left (pow_ne_zero 9 ha)

/-! ### Degree-8 residual scaling (load-bearing for family-through-`v`) -/

section ResidualYScale

variable {R : Type u} [CommRing R]

private theorem finsupp_prod_fin2_scale (α : R) (d : Fin 2 →₀ ℕ) :
    d.prod (fun i k => (![X 0, C α * X 1] : Fin 2 → MvPolynomial (Fin 2) R) i ^ k) =
      X 0 ^ d 0 * (C α * X 1) ^ d 1 := by
  classical
  simp only [Finsupp.prod]
  let g : Fin 2 → MvPolynomial (Fin 2) R := fun i =>
    (![X 0, C α * X 1] : Fin 2 → MvPolynomial (Fin 2) R) i ^ d i
  change (∏ i ∈ d.support, g i) = X 0 ^ d 0 * (C α * X 1) ^ d 1
  have hsupp : (∏ i ∈ d.support, g i) = (∏ i : Fin 2, g i) := by
    apply Finset.prod_subset (Finset.subset_univ _)
    intro i _ hi
    have hdi : d i = 0 := by
      rw [Finsupp.mem_support_iff, not_not] at hi
      exact hi
    simp only [g, hdi, pow_zero]
  rw [hsupp, Fin.prod_univ_two]
  rfl

private theorem aeval_monomial_scale_X1 (α r : R) (d : Fin 2 →₀ ℕ) :
    aeval (![X 0, C α * X 1] : Fin 2 → MvPolynomial (Fin 2) R) (monomial d r) =
      monomial d (r * α ^ (d 1)) := by
  have hde : Finsupp.single (0 : Fin 2) (d 0) + Finsupp.single (1 : Fin 2) (d 1) = d := by
    ext i; fin_cases i <;> simp
  calc
    aeval (![X 0, C α * X 1] : Fin 2 → MvPolynomial (Fin 2) R) (monomial d r)
        = C r * d.prod (fun i k => (![X 0, C α * X 1] i) ^ k) := by
          rw [aeval_monomial, algebraMap_eq]
    _ = C r * (X 0 ^ d 0 * (C α * X 1) ^ d 1) := by rw [finsupp_prod_fin2_scale]
    _ = C r * (X 0 ^ d 0 * (C (α ^ d 1) * X 1 ^ d 1)) := by rw [mul_pow, ← C_pow]
    _ = C (r * α ^ d 1) * (X 0 ^ d 0 * X 1 ^ d 1) := by simp only [C_mul]; ring
    _ = C (r * α ^ d 1) *
          monomial (Finsupp.single 0 (d 0) + Finsupp.single 1 (d 1)) 1 := by
        simp only [X_pow_eq_monomial, monomial_mul, one_mul]
    _ = monomial (Finsupp.single 0 (d 0) + Finsupp.single 1 (d 1)) (r * α ^ d 1) := by
        rw [C_mul_monomial, mul_one]
    _ = monomial d (r * α ^ d 1) := by rw [hde]

/-- Coefficient extraction for `binaryReparam α 0` (scale `X₁` by `α`). -/
theorem coeff_binaryReparam_zero_beta (α : R) (f : MvPolynomial (Fin 2) R) (n0 n1 : ℕ) :
    coeff (binaryExponent n0 n1) (binaryReparam α 0 f) =
      α ^ n1 * coeff (binaryExponent n0 n1) f := by
  classical
  have hr : binaryReparam α 0 f =
      aeval (![X 0, C α * X 1] : Fin 2 → MvPolynomial (Fin 2) R) f := by
    simp only [binaryReparam]
    congr 1
    ext i; fin_cases i <;> simp
  rw [hr]
  set target := binaryExponent n0 n1
  have hf : aeval (![X 0, C α * X 1] : Fin 2 → MvPolynomial (Fin 2) R) f =
      ∑ d ∈ f.support,
        aeval (![X 0, C α * X 1] : Fin 2 → MvPolynomial (Fin 2) R)
          (monomial d (coeff d f)) := by
    conv_lhs => rw [← support_sum_monomial_coeff f]; rw [map_sum]
  rw [hf, coeff_sum]
  have hterm (d : Fin 2 →₀ ℕ) :
      coeff target
          (aeval (![X 0, C α * X 1] : Fin 2 → MvPolynomial (Fin 2) R)
            (monomial d (coeff d f))) =
        if d = target then α ^ n1 * coeff d f else 0 := by
    rw [aeval_monomial_scale_X1, coeff_monomial]
    split_ifs with h
    · subst h
      have ht : target 1 = n1 := by simp [target, binaryExponent]
      rw [ht, mul_comm]
    · rfl
  simp_rw [hterm]
  calc
    (∑ d ∈ f.support, if d = target then α ^ n1 * coeff d f else 0)
        = α ^ n1 * ∑ d ∈ f.support, if d = target then coeff d f else 0 := by
          rw [Finset.mul_sum]
          refine Finset.sum_congr rfl fun d _ => ?_
          split_ifs <;> ring
    _ = α ^ n1 * coeff target f := by
          congr 1
          by_cases hmem : target ∈ f.support
          · rw [Finset.sum_eq_single target]
            · simp
            · intro d _ hne; simp [hne]
            · exact fun h => absurd hmem h
          · have hc0 : coeff target f = 0 := by
              have : ¬ (coeff target f ≠ 0) := by
                simpa [mem_support_iff] using hmem
              exact not_not.mp this
            rw [hc0]
            exact Finset.sum_eq_zero fun d hd => by
              split_ifs with heq
              · subst heq; exact absurd hd hmem
              · rfl

theorem residualBinaryRep_C_mul' (c : R) (f : MvPolynomial (Fin 2) R) :
    residualBinaryRep (C c * f) = fun i => c * residualBinaryRep f i := by
  funext i; fin_cases i <;> simp [residualBinaryRep, coeff_C_mul]

theorem residualAmbientRep_C_mul' {σ : Type*} (c : R) (p q : σ → R)
    (f : MvPolynomial (Fin 2) R) :
    residualAmbientRep p q (C c * f) = fun i => c * residualAmbientRep p q f i := by
  funext i; simp only [residualAmbientRep, residualBinaryRep_C_mul']; ring

/-- Direction scale (β = 0): residual ambient representative scales by `α³`. -/
theorem residualAmbientRep_smul_dir_coeff {σ : Type*} (p q : σ → R) (α : R)
    (f : MvPolynomial (Fin 2) R) :
    residualAmbientRep p (fun i => α * q i) (binaryReparam α 0 f) =
      fun i => α ^ 3 * residualAmbientRep p q f i := by
  funext i
  simp only [residualAmbientRep, residualBinaryRep, Matrix.cons_val_zero, Matrix.cons_val_one,
    coeff_binaryReparam_zero_beta]
  ring

theorem binaryLineRestriction_C_mul' {σ : Type*} (c : R) (p q : σ → R)
    (G : MvPolynomial σ R) :
    binaryLineRestriction p q (C c * G) = C c * binaryLineRestriction p q G := by
  rw [map_mul, binaryLineRestriction_C]

/-- Scaling the cubic and its direction by the same scalar multiplies the residual by `c⁴`. -/
theorem residualAmbientRep_scale_c4 {σ : Type*}
    (p q : σ → R) (c : R) (G : MvPolynomial σ R) :
    residualAmbientRep p (fun i => c * q i)
        (binaryLineRestriction p (fun i => c * q i) (C c * G)) =
      fun i => c ^ 4 * residualAmbientRep p q (binaryLineRestriction p q G) i := by
  have h1 := binaryLineRestriction_C_mul' c p (fun i => c * q i) G
  have hdir : (fun i => c * q i) = fun i => c * q i + (0 : R) * p i := by
    funext i; ring
  have h2 : binaryLineRestriction p (fun i => c * q i) G =
      binaryReparam c 0 (binaryLineRestriction p q G) := by
    rw [hdir]
    exact binaryLineRestriction_reparam p q c 0 G
  rw [h1, h2, residualAmbientRep_C_mul', residualAmbientRep_smul_dir_coeff]
  funext i; ring

/-- CommRing form of `frameTangentDir_C_mul`. -/
theorem frameTangentDir_C_mul'
    (M N : Matrix (Fin 3) (Fin 3) R)
    (G : MvPolynomial (Fin 3) R) (p : Fin 3 → R) (c : R) :
    frameTangentDir M N (C c * G) p =
      fun i => c * frameTangentDir M N G p i := by
  unfold frameTangentDir
  set Gb := (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G
  have hGb : (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) (C c * G) =
      C c * Gb := by
    simp [Gb]
  rw [hGb]
  unfold complementaryTangentDir tangentGradient
  funext i
  simp only [pderiv_mul, pderiv_C, zero_mul, zero_add, map_mul, eval_C]
  fin_cases i <;> simp [cross3, Matrix.mulVec, dotProduct, Fin.sum_univ_three] <;> ring

end ResidualYScale

theorem cubicFiberPullback_smul_coords
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (r : affineTwoRing k) (x : Fin 3 → affineTwoRing k) :
    cubicFiberPullback F (fun i => r * x i) = C (r ^ 2) * cubicFiberPullback F x := by
  have hmap : IsBidegree23 (affineTwoPullback F) :=
    hF.map_coefficients (C : k →+* affineTwoRing k)
  have hx : (fun i => r * x i) = (r • x) := by
    funext i; simp [Pi.smul_apply, smul_eq_mul]
  rw [cubicFiberPullback, cubicFiberPullback, hx]
  exact hmap.specializeFirstCoordinates_smul r x

/-- **Degree-8 homogeneity of residual `Y`-coordinates in the section.**

Stereo first coords are linear in the section; the cubic fibre is degree 2 in those; the
frame-tangent residual of a scaled cubic contributes degree 4: total degree `1·2·4 = 8`. -/
theorem residualYCoordsOn_mul
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (φ : Polynomial k) (v : Fin 3 → Polynomial k) :
    residualYCoordsOn p₀ q₀ r N F (fun i => φ * v i) =
      fun i => (liftPolyT φ) ^ 8 * residualYCoordsOn p₀ q₀ r N F v i := by
  have hL :
      residualYCoordsOn p₀ q₀ r N F (fun i => φ * v i) =
        residualAmbientRep (affineTwoLinePoint p₀ q₀)
          (frameTangentDir (affineTwoLineFrame p₀ q₀ r) (N.map C)
            (cubicFiberPullback F (stereoFirstCoordsOn p₀ q₀ F (fun i => φ * v i)))
            (affineTwoLinePoint p₀ q₀))
          (binaryLineRestriction (affineTwoLinePoint p₀ q₀)
            (frameTangentDir (affineTwoLineFrame p₀ q₀ r) (N.map C)
              (cubicFiberPullback F (stereoFirstCoordsOn p₀ q₀ F (fun i => φ * v i)))
              (affineTwoLinePoint p₀ q₀))
            (cubicFiberPullback F (stereoFirstCoordsOn p₀ q₀ F (fun i => φ * v i)))) :=
    rfl
  have hR :
      residualYCoordsOn p₀ q₀ r N F v =
        residualAmbientRep (affineTwoLinePoint p₀ q₀)
          (frameTangentDir (affineTwoLineFrame p₀ q₀ r) (N.map C)
            (cubicFiberPullback F (stereoFirstCoordsOn p₀ q₀ F v))
            (affineTwoLinePoint p₀ q₀))
          (binaryLineRestriction (affineTwoLinePoint p₀ q₀)
            (frameTangentDir (affineTwoLineFrame p₀ q₀ r) (N.map C)
              (cubicFiberPullback F (stereoFirstCoordsOn p₀ q₀ F v))
              (affineTwoLinePoint p₀ q₀))
            (cubicFiberPullback F (stereoFirstCoordsOn p₀ q₀ F v))) :=
    rfl
  rw [hL, hR, stereoFirstCoordsOn_mul p₀ q₀ F hF φ v]
  rw [cubicFiberPullback_smul_coords F hF (liftPolyT φ) (stereoFirstCoordsOn p₀ q₀ F v)]
  rw [frameTangentDir_C_mul' (affineTwoLineFrame p₀ q₀ r) (N.map C)
      (cubicFiberPullback F (stereoFirstCoordsOn p₀ q₀ F v))
      (affineTwoLinePoint p₀ q₀) (liftPolyT φ ^ 2)]
  rw [residualAmbientRep_scale_c4 (affineTwoLinePoint p₀ q₀)
      (frameTangentDir (affineTwoLineFrame p₀ q₀ r) (N.map C)
        (cubicFiberPullback F (stereoFirstCoordsOn p₀ q₀ F v)) (affineTwoLinePoint p₀ q₀))
      (liftPolyT φ ^ 2)
      (cubicFiberPullback F (stereoFirstCoordsOn p₀ q₀ F v))]
  funext i; ring

/-- G4 for a common nonzero polynomial multiple of a section: residual `Y` scales by `φ⁸`,
discriminant pullback by `φ⁷²`, and nonvanishing is preserved.  No residual-`Y` hypothesis. -/
theorem ResidualAvoidsConicDiscriminantOn_of_mul_section
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (φ : Polynomial k) (hφ : φ ≠ 0) (v : Fin 3 → Polynomial k)
    (h : ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v) :
    ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F (fun i => φ * v i) := by
  have ha : (liftPolyT φ : affineTwoRing k) ≠ 0 := liftPolyT_ne_zero φ hφ
  refine ResidualAvoidsConicDiscriminantOn_of_smul_residualY p₀ q₀ r N F hF v
    (fun i => φ * v i) ((liftPolyT φ) ^ 8) (pow_ne_zero 8 ha) ?_ h
  exact residualYCoordsOn_mul p₀ q₀ r N F hF φ v

/-! ### Upgrade -/

open Standard

/-- Easy upgrade: bare section with `v 2 ≠ 0` → full actual package. -/
theorem HasActualG3G4LineSection_of_HasGoodLineWithSection_of_third_ne_zero
    [NeZero (2 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (v : Fin 3 → Polynomial k)
    (h : HasGoodLineWithSection F p q r N v) (hv2 : v 2 ≠ 0) :
    HasActualG3G4LineSection F p q r N v := by
  rcases h with ⟨hMN, hG3, hdisc, hv0, hviso, hG4⟩
  have hQhom : (lineSpecializedConicPoly p q F).IsHomogeneous 2 :=
    lineSpecializedConicPoly_isHomogeneous p q hF
  have hviso' : eval v (lineSpecializedConicPoly p q F) = 0 := by
    rwa [← ternaryQuadraticPoly_eval_line p q F hF]
  have hpol :=
    polarEval_ne_zero_of_isotropic_of_third_ne_zero hQhom hdisc hviso' hv2
  have hpolar :
      polarEval (lineSpecializedConicPullback p q F)
        (liftTsenSection v) affineTwoStereoDir ≠ 0 :=
    polarEval_lineStereoDir_ne_zero_of_polarEval_ne_zero p q F hF v hpol
  exact ⟨hMN, hG3, ⟨hv0, hviso, hv2, hpolar⟩, hG4⟩

/-- Upgrade when general position + G4 are already available for some section. -/
theorem exists_actualG3G4LineSection_of_HasGoodLineWithSection_of_GP_G4
    [NeZero (2 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (_hF : IsBidegree23 F)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (_v : Fin 3 → Polynomial k)
    (h : HasGoodLineWithSection F p q r N _v)
    (v' : Fin 3 → Polynomial k)
    (hv'0 : v' ≠ 0)
    (hv'iso : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v' = 0)
    (hv'2 : v' 2 ≠ 0)
    (hv'polar : polarEval (lineSpecializedConicPullback p q F)
      (liftTsenSection v') affineTwoStereoDir ≠ 0)
    (hG4' : ResidualAvoidsConicDiscriminantOn p q r N F v') :
    ∃ w : Fin 3 → Polynomial k, HasActualG3G4LineSection F p q r N w :=
  ⟨v', h.1, h.2.1, ⟨hv'0, hv'iso, hv'2, hv'polar⟩, hG4'⟩

/-- Upgrade when `v 2 ≠ 0`. -/
theorem exists_actualG3G4LineSection_of_HasGoodLineWithSection
    [NeZero (2 : k)] [NeZero (3 : k)] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (v : Fin 3 → Polynomial k)
    (h : HasGoodLineWithSection F p q r N v)
    (hv2 : v 2 ≠ 0) :
    ∃ v' : Fin 3 → Polynomial k, HasActualG3G4LineSection F p q r N v' :=
  ⟨v, HasActualG3G4LineSection_of_HasGoodLineWithSection_of_third_ne_zero F hF p q r N v h hv2⟩

/-! ### D2 and D3 -/

/-- **D2.** Unirationality from framed G3, smooth generic conic, bare isotropic section with
`v 2 ≠ 0`, and G4 for that section.  The hard path (`v 2 = 0`) is residual-line family excision
(Goal D steps 1–4; residualYCoordsOn degree 8 confirmed; open when C2 loses G4). -/
theorem smooth_bidegree23_hasUnirationalParametrization_of_lineSection
    (k : Type u) [Field k] [NeZero (2 : k)] [NeZero (3 : k)] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (h : ∃ (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
      (v : Fin 3 → Polynomial k), Standard.HasGoodLineWithSection F p q r N v ∧ v 2 ≠ 0) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) := by
  obtain ⟨p, q, r, N, v, hG, hv2⟩ := h
  obtain ⟨v', hactual⟩ :=
    exists_actualG3G4LineSection_of_HasGoodLineWithSection F hF p q r N v hG hv2
  exact smooth_bidegree23_hasUnirationalParametrization_of_goodLineSection k F hF hF0
    ⟨p, q, r, N, v', hactual⟩

/-- **D3.** Over algebraically closed fields the minimal package exists via frame incidence.
Nonsingular selection already supplies `lineConicDiscriminant ≠ 0` (via smoothness).  Existing
headline proof untouched. -/
theorem smooth_bidegree23_hasUnirationalParametrization_of_lineSection_of_isAlgClosed
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) := by
  obtain ⟨p, q, r, N, _x, v, _u, hactual, _⟩ :=
    Standard.exists_actualG3G4LineSection_via_frameIncidence F hF hF0
  exact smooth_bidegree23_hasUnirationalParametrization_of_goodLineSection k F hF hF0
    ⟨p, q, r, N, v, hactual⟩


/-! ### Stereo residual-line third-coordinate content -/

/-- When the base point has third coordinate zero, the stereo residual third-coordinate
polynomial is `-B(p,w₁) · X · (C(w₀₂) + X · C(w₁₂))`. -/
theorem stereoLineParamPoly_third_eq_of_base_third_eq_zero
    {F : Type u} [Field F]
    {Q : MvPolynomial (Fin 3) F} {p w0 w1 : Fin 3 → F}
    (h : StereoLineFrame Q p w0 w1) (hp2 : p 2 = 0) :
    stereoLineParamPoly Q h.isHomogeneous p w0 w1 2 =
      -(Polynomial.C (polarEval Q p w1)) * Polynomial.X *
        (Polynomial.C (w0 2) + Polynomial.X * Polynomial.C (w1 2)) := by
  have hw0 : polarEval Q p w0 = 0 := h.polar_w0
  simp only [stereoLineParamPoly, stereoLinePolarPoly, stereoLineDirPoly, hp2, map_zero,
    mul_zero, zero_sub, hw0, zero_add]
  ring

/-- The third-coordinate content is a nonzero univariate: otherwise `w₀, w₁` and `p` all lie in
the plane `x₂ = 0`, contradicting the frame determinant. -/
theorem stereoLineParamPoly_third_ne_zero_of_base_third_eq_zero
    {F : Type u} [Field F]
    {Q : MvPolynomial (Fin 3) F} {p w0 w1 : Fin 3 → F}
    (h : StereoLineFrame Q p w0 w1) (hp2 : p 2 = 0) :
    stereoLineParamPoly Q h.isHomogeneous p w0 w1 2 ≠ 0 := by
  rw [stereoLineParamPoly_third_eq_of_base_third_eq_zero h hp2]
  intro h0
  have hprod :
      Polynomial.C (polarEval Q p w1) * Polynomial.X *
        (Polynomial.C (w0 2) + Polynomial.X * Polynomial.C (w1 2)) = 0 := by
    linear_combination -h0
  rcases mul_eq_zero.mp hprod with h1 | h2
  · rcases mul_eq_zero.mp h1 with hB | hX
    · exact h.polar_w1 ((Polynomial.C_eq_zero).mp hB)
    · exact Polynomial.X_ne_zero hX
  · have hw0 : w0 2 = 0 := by
      have := congrArg (Polynomial.eval (0 : F)) h2
      simpa using this
    have hw1 : w1 2 = 0 := by
      have hc := congrArg (fun p : Polynomial F => Polynomial.coeff p 1) h2
      simpa [Polynomial.coeff_add, Polynomial.coeff_C_mul, Polynomial.coeff_X_mul,
        Polynomial.coeff_C, Polynomial.coeff_X] using hc
    have hdet0 : (frameMatrix p w0 w1).det = 0 := by
      refine Matrix.det_eq_zero_of_row_eq_zero (i := 2) ?_
      intro j
      change frameMatrix p w0 w1 2 j = 0
      fin_cases j <;> simp [frameMatrix, Matrix.of_apply, hp2, hw0, hw1]
    exact h.frame_det hdet0

/-- Upgrade without `[Infinite k]` when third coordinate is already nonzero. -/
theorem exists_actualG3G4LineSection_of_HasGoodLineWithSection_noInfinite
    [NeZero (2 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (v : Fin 3 → Polynomial k)
    (h : HasGoodLineWithSection F p q r N v)
    (hv2 : v 2 ≠ 0) :
    ∃ v' : Fin 3 → Polynomial k, HasActualG3G4LineSection F p q r N v' :=
  ⟨v, HasActualG3G4LineSection_of_HasGoodLineWithSection_of_third_ne_zero F hF p q r N v h hv2⟩

/-- Unirationality from the minimal package with `v 2 ≠ 0`, without `[Infinite k]`.
(The older `…_of_lineSection` retains a vestigial Infinite binder.) -/
theorem smooth_bidegree23_hasUnirationalParametrization_of_lineSection_noInfinite
    (k : Type u) [Field k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (h : ∃ (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
      (v : Fin 3 → Polynomial k), Standard.HasGoodLineWithSection F p q r N v ∧ v 2 ≠ 0) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) := by
  obtain ⟨p, q, r, N, v, hG, hv2⟩ := h
  obtain ⟨v', hactual⟩ :=
    exists_actualG3G4LineSection_of_HasGoodLineWithSection_noInfinite F hF p q r N v hG hv2
  exact smooth_bidegree23_hasUnirationalParametrization_of_goodLineSection k F hF hF0
    ⟨p, q, r, N, v', hactual⟩

/-
### Obstruction note (Goal D′, residual-disc content along `fam(s)`)

The third-coordinate content is a nonzero univariate
(`stereoLineParamPoly_third_ne_zero_of_base_third_eq_zero`), and G4 is invariant under nonzero
section scaling (`ResidualAvoidsConicDiscriminantOn_of_mul_section` via degree-8
`residualYCoordsOn_mul`).  What remains for the double-miss path `v 2 = 0` is to package the
residual-disc pullback along the residual-line family
`fam(s) = stereoAlg Q P (W0 + s · W1)` (C1 frame over `RatFunc k`, common denom once) as a
**nonzero univariate in the family parameter** — nonzero because `fam(0)` is a nonzero multiple of
`v` so G4 holds at `s = 0` by degree-8 scaling — then avoid it together with the third-coordinate
content via `exists_eval_ne_zero_of_finite_ne_zero` over `RatFunc k`.

That content extraction is the remaining obstruction: residual disc is an element of
`affineTwoRing k` depending polynomially on the section, but the project does not yet have a
packaged “polynomial map `s ↦ residualConicDiscriminantOn (fam s)` as an element of
`(affineTwoRing k)[s]` with an evaluable coefficient univariate over `RatFunc k`”.  Without it the
final
`smooth_bidegree23_hasUnirationalParametrization_of_lineSection'`
(no `Infinite`, no `v 2 ≠ 0`) cannot be completed honestly.  The closed-field corollary is already
covered by the existing `…_of_lineSection_of_isAlgClosed` (selection supplies `v 2 ≠ 0`).
-/

end

end BConicBundleMultisections
