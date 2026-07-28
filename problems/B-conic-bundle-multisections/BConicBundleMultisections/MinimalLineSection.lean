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
public import BConicBundleMultisections.ResidualDataBaseChange

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
* **D″1 done:** residual-disc content along a quadratic section pencil is a finite family of
  coefficient univariates (`exists_residualDiscContent_of_sectionPencil`), via universal
  `Φ ∈ (affineTwoRing k)[S]` and coefficient extraction.  Nontriviality from G4 at `s = 0`.
* **D‴:** stereo→pencil (`exists_sectionPencil_of_HasGoodLineWithSection`), double excision over
  infinite fields, `…_of_lineSection'` (requires `[Infinite k]` on the hard branch; the `v 2 ≠ 0`
  path remains Infinite-free as `…_of_lineSection_noInfinite`), closed-field corollary.
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


/-! ### D″1 — residual-disc content along a quadratic section pencil

`stereoAlg` is linear in the section point, so a quadratic pencil of sections induces a quadratic
pencil of stereo first-block points.  Running the residual pipeline over
`Polynomial (affineTwoRing k)` produces `Φ ∈ (affineTwoRing k)[S]` with
`residualConicDiscriminantOn (fam s) = Φ.eval (C s)`.  Coefficient extraction yields finitely many
univariates over `k` cutting out the residual-disc vanishing locus; G4 at `s = 0` shows they are
not all the zero polynomial.
-/

/-- Quadratic pencil of Tsen sections: `α + s β + s² γ`. -/
def sectionPencil (α β γ : Fin 3 → Polynomial k) (s : k) : Fin 3 → Polynomial k :=
  fun i => α i + Polynomial.C s * β i + Polynomial.C s ^ 2 * γ i

/-- Homogeneous combination `φ α + ψ β + ρ γ`. -/
def sectionPencilHom (α β γ : Fin 3 → Polynomial k) (φ ψ ρ : Polynomial k) :
    Fin 3 → Polynomial k :=
  fun i => φ * α i + ψ * β i + ρ * γ i

theorem sectionPencil_zero (α β γ : Fin 3 → Polynomial k) :
    sectionPencil α β γ 0 = α := by
  funext i; simp [sectionPencil]

theorem sectionPencilHom_smul_of_const
    (α β γ : Fin 3 → Polynomial k) (d : Polynomial k) (s : k) :
    sectionPencilHom α β γ (d ^ 2) (d ^ 2 * Polynomial.C s) (d ^ 2 * Polynomial.C s ^ 2) =
      fun i => d ^ 2 * sectionPencil α β γ s i := by
  funext i
  simp only [sectionPencilHom, sectionPencil, mul_add, mul_assoc]

/-- Residual `Y` from a stereo first-block point. -/
def residualYCoordsOnOfStereo (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x : Fin 3 → affineTwoRing k) : Fin 3 → affineTwoRing k :=
  let G := cubicFiberPullback F x
  let pL := affineTwoLinePoint p₀ q₀
  let qd := frameTangentDir (affineTwoLineFrame p₀ q₀ r) (N.map C) G pL
  residualAmbientRep pL qd (binaryLineRestriction pL qd G)

theorem residualYCoordsOn_eq_ofStereo
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k) :
    residualYCoordsOn p₀ q₀ r N F v =
      residualYCoordsOnOfStereo p₀ q₀ r N F (stereoFirstCoordsOn p₀ q₀ F v) :=
  rfl

/-- `stereoAlg` is linear in the base point. -/
theorem stereoAlg_linear_left {R : Type u} [CommRing R]
    (Q : MvPolynomial (Fin 3) R) (hQ : Q.IsHomogeneous 2)
    (a b : R) (p w z : Fin 3 → R) :
    stereoAlg Q (fun i => a * p i + b * w i) z =
      fun i => a * stereoAlg Q p z i + b * stereoAlg Q w z i := by
  funext i
  have hpol := polarEval_linear_left hQ a b p w z
  simp only [stereoAlg, hpol]
  ring

theorem liftPolyT_add' (p q : Polynomial k) :
    liftPolyT (p + q) = liftPolyT p + liftPolyT q := by
  simp [liftPolyT_eq_hom, map_add]

theorem liftPolyT_C_mul' (c : k) (p : Polynomial k) :
    liftPolyT (Polynomial.C c * p) = (C c : affineTwoRing k) * liftPolyT p := by
  simp only [liftPolyT_eq_hom, map_mul]
  congr 1
  simp [liftPolyTHom]

theorem liftTsenSection_sectionPencil (α β γ : Fin 3 → Polynomial k) (s : k) :
    liftTsenSection (sectionPencil α β γ s) =
      fun i =>
        liftPolyT (α i) + (C s : affineTwoRing k) * liftPolyT (β i) +
          (C s : affineTwoRing k) ^ 2 * liftPolyT (γ i) := by
  funext i
  have hcs : liftPolyT (Polynomial.C s) = (C s : affineTwoRing k) := by
    simp [liftPolyT_eq_hom, liftPolyTHom]
  have h1 : liftPolyT (Polynomial.C s * β i) = (C s : affineTwoRing k) * liftPolyT (β i) :=
    liftPolyT_C_mul' s (β i)
  have h2 :
      liftPolyT (Polynomial.C s ^ 2 * γ i) =
        (C s : affineTwoRing k) ^ 2 * liftPolyT (γ i) := by
    have : Polynomial.C s ^ 2 * γ i = Polynomial.C s * (Polynomial.C s * γ i) := by ring
    rw [this, liftPolyT_C_mul', liftPolyT_C_mul']; ring
  simp only [liftTsenSection, sectionPencil, liftPolyT_add', h1, h2]

theorem stereoFirstCoordsOn_sectionPencil
    (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (α β γ : Fin 3 → Polynomial k) (s : k) :
    stereoFirstCoordsOn p₀ q₀ F (sectionPencil α β γ s) =
      fun i =>
        stereoFirstCoordsOn p₀ q₀ F α i +
          (C s : affineTwoRing k) * stereoFirstCoordsOn p₀ q₀ F β i +
            (C s : affineTwoRing k) ^ 2 * stereoFirstCoordsOn p₀ q₀ F γ i := by
  have hQ : (lineSpecializedConicPullback p₀ q₀ F).IsHomogeneous 2 :=
    lineSpecializedConicPullback_isHomogeneous p₀ q₀ hF
  funext i
  simp only [stereoFirstCoordsOn, liftTsenSection_sectionPencil]
  set Lα := liftTsenSection α
  set Lβ := liftTsenSection β
  set Lγ := liftTsenSection γ
  set cs : affineTwoRing k := C s
  have hcomb :
      (fun j => liftPolyT (α j) + cs * liftPolyT (β j) + cs ^ 2 * liftPolyT (γ j)) =
        fun j =>
          (1 : affineTwoRing k) * Lα j +
            cs * ((1 : affineTwoRing k) * Lβ j + cs * Lγ j) := by
    funext j
    simp only [Lα, Lβ, Lγ, liftTsenSection, cs]
    ring
  rw [hcomb]
  have hlin1 :=
    congrFun
      (stereoAlg_linear_left (lineSpecializedConicPullback p₀ q₀ F) hQ
        (1 : affineTwoRing k) cs Lα
        (fun j => (1 : affineTwoRing k) * Lβ j + cs * Lγ j) affineTwoStereoDir) i
  rw [hlin1, one_mul]
  have hlin2 :=
    congrFun
      (stereoAlg_linear_left (lineSpecializedConicPullback p₀ q₀ F) hQ
        (1 : affineTwoRing k) cs Lβ Lγ affineTwoStereoDir) i
  rw [hlin2, one_mul]
  simp only [Lα, Lβ, Lγ, cs]
  ring

/-- Universal stereo first-block of a section pencil in `(affineTwoRing k)[S]`. -/
def stereoFirstCoordsOnPencilUniv
    (p₀ q₀ : Fin 3 → k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (α β γ : Fin 3 → Polynomial k) : Fin 3 → Polynomial (affineTwoRing k) :=
  fun i =>
    Polynomial.C (stereoFirstCoordsOn p₀ q₀ F α i) +
      Polynomial.X * Polynomial.C (stereoFirstCoordsOn p₀ q₀ F β i) +
        Polynomial.X ^ 2 * Polynomial.C (stereoFirstCoordsOn p₀ q₀ F γ i)

theorem eval_stereoFirstCoordsOnPencilUniv
    (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (α β γ : Fin 3 → Polynomial k) (s : k) :
    (fun i =>
        Polynomial.eval (C s : affineTwoRing k)
          (stereoFirstCoordsOnPencilUniv p₀ q₀ F α β γ i)) =
      stereoFirstCoordsOn p₀ q₀ F (sectionPencil α β γ s) := by
  funext i
  simp only [stereoFirstCoordsOnPencilUniv, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_pow, Polynomial.eval_X, Polynomial.eval_C]
  exact (congrFun (stereoFirstCoordsOn_sectionPencil p₀ q₀ F hF α β γ s) i).symm

/-- Evaluation at `S ↦ C s` on `(affineTwoRing k)[S]`. -/
def evalAtC (s : k) : Polynomial (affineTwoRing k) →+* affineTwoRing k :=
  Polynomial.evalRingHom (C s : affineTwoRing k)

/-- Universal residual `Y` for a stereo point over `(affineTwoRing k)[S]`. -/
def residualYCoordsOnOfStereoUniv (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x : Fin 3 → Polynomial (affineTwoRing k)) : Fin 3 → Polynomial (affineTwoRing k) :=
  let G :=
    specializeFirstCoordinates (n := 2) x
      (map (Polynomial.C : affineTwoRing k →+* Polynomial (affineTwoRing k))
        (affineTwoPullback F))
  let pL : Fin 3 → Polynomial (affineTwoRing k) :=
    fun i => Polynomial.C (affineTwoLinePoint p₀ q₀ i)
  let M := (affineTwoLineFrame p₀ q₀ r).map Polynomial.C
  let N' := (N.map (C : k →+* affineTwoRing k)).map Polynomial.C
  residualAmbientRep pL (frameTangentDir M N' G pL)
    (binaryLineRestriction pL (frameTangentDir M N' G pL) G)

theorem eval_residualYCoordsOnOfStereoUniv
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x : Fin 3 → Polynomial (affineTwoRing k)) (s : k) :
    (fun i => (evalAtC s) (residualYCoordsOnOfStereoUniv p₀ q₀ r N F x i)) =
      residualYCoordsOnOfStereo p₀ q₀ r N F (fun i => (evalAtC s) (x i)) := by
  let ev := evalAtC s
  have hcomp : ev.comp (Polynomial.C : affineTwoRing k →+* Polynomial (affineTwoRing k)) =
      RingHom.id (affineTwoRing k) :=
    RingHom.ext fun a => by simp [ev, evalAtC]
  have hG :
      map ev
          (specializeFirstCoordinates (n := 2) x
            (map (Polynomial.C : affineTwoRing k →+* Polynomial (affineTwoRing k))
              (affineTwoPullback F))) =
        specializeFirstCoordinates (n := 2) (fun i => ev (x i)) (affineTwoPullback F) := by
    rw [ResidualDataBaseChange.map_specializeFirstCoords ev, map_map, hcomp, map_id]
  have hp :
      (fun i => ev (Polynomial.C (affineTwoLinePoint p₀ q₀ i))) = affineTwoLinePoint p₀ q₀ := by
    funext i; simp [ev, evalAtC]
  have hM :
      ((affineTwoLineFrame p₀ q₀ r).map Polynomial.C).map ev = affineTwoLineFrame p₀ q₀ r := by
    ext i j; simp [Matrix.map_apply, ev, evalAtC]
  have hN :
      (((N.map (C : k →+* affineTwoRing k)).map Polynomial.C).map ev) =
        N.map (C : k →+* affineTwoRing k) := by
    ext i j; simp [Matrix.map_apply, ev, evalAtC]
  simp only [residualYCoordsOnOfStereoUniv, residualYCoordsOnOfStereo, cubicFiberPullback]
  rw [ResidualDataBaseChange.map_residualAmbientRepGen ev,
    ResidualDataBaseChange.map_binaryLineRestrictionFun ev,
    ResidualDataBaseChange.map_frameTangentDirGen ev, hG, hp, hM, hN]

/-- Universal residual-disc of a section pencil. -/
def residualConicDiscriminantOnPencilUniv
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (α β γ : Fin 3 → Polynomial k) : Polynomial (affineTwoRing k) :=
  let Y :=
    residualYCoordsOnOfStereoUniv p₀ q₀ r N F
      (stereoFirstCoordsOnPencilUniv p₀ q₀ F α β γ)
  eval₂ (Polynomial.C.comp (C : k →+* affineTwoRing k)) Y (sndConicDiscriminant F)

theorem residualConicDiscriminantOn_sectionPencil
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (α β γ : Fin 3 → Polynomial k) (s : k) :
    residualConicDiscriminantOn p₀ q₀ r N F (sectionPencil α β γ s) =
      (evalAtC s) (residualConicDiscriminantOnPencilUniv p₀ q₀ r N F α β γ) := by
  simp only [residualConicDiscriminantOn, residualYCoordsOn_eq_ofStereo,
    residualConicDiscriminantOnPencilUniv]
  set Yuniv :=
    residualYCoordsOnOfStereoUniv p₀ q₀ r N F
      (stereoFirstCoordsOnPencilUniv p₀ q₀ F α β γ)
  have hY :
      (fun i => (evalAtC s) (Yuniv i)) =
        residualYCoordsOnOfStereo p₀ q₀ r N F
          (stereoFirstCoordsOn p₀ q₀ F (sectionPencil α β γ s)) := by
    rw [eval_residualYCoordsOnOfStereoUniv]
    congr 1
    exact eval_stereoFirstCoordsOnPencilUniv p₀ q₀ F hF α β γ s
  have hcomm :
      (evalAtC s)
          (eval₂ (Polynomial.C.comp (C : k →+* affineTwoRing k)) Yuniv
            (sndConicDiscriminant F)) =
        aeval (fun i => (evalAtC s) (Yuniv i)) (sndConicDiscriminant F) := by
    induction sndConicDiscriminant F using MvPolynomial.induction_on with
    | C a =>
        simp only [eval₂_C, evalAtC, aeval_C, algebraMap_eq, RingHom.comp_apply]
        change Polynomial.eval (C s) (Polynomial.C (C a)) = C a
        simp
    | add f g hf hg => simp [hf, hg]
    | mul_X f i hf =>
        simp only [eval₂_mul, eval₂_X, map_mul, hf, aeval_X]
  rw [hcomm, hY]

/-- Coefficient univariate of the residual-disc pencil. -/
def residualDiscContentCoeff
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (α β γ : Fin 3 → Polynomial k) (m : ULift (Fin 2) →₀ ℕ) : Polynomial k :=
  let Φ := residualConicDiscriminantOnPencilUniv p₀ q₀ r N F α β γ
  Φ.support.sum fun n =>
    Polynomial.C (coeff m (Polynomial.coeff Φ n)) * Polynomial.X ^ n

private theorem eval_eq_sum_mul_pow
    (Φ : Polynomial (affineTwoRing k)) (s : k) :
    Polynomial.eval (C s : affineTwoRing k) Φ =
      ∑ n ∈ Φ.support, Polynomial.coeff Φ n * (C s : affineTwoRing k) ^ n := by
  rw [Polynomial.eval_eq_sum, Polynomial.sum_def]
  -- `•` is definitionally `*` on this ring, so the goal closes.

theorem eval_residualDiscContentCoeff
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (α β γ : Fin 3 → Polynomial k) (m : ULift (Fin 2) →₀ ℕ) (s : k) :
    Polynomial.eval s (residualDiscContentCoeff p₀ q₀ r N F α β γ m) =
      coeff m (residualConicDiscriminantOn p₀ q₀ r N F (sectionPencil α β γ s)) := by
  classical
  rw [residualConicDiscriminantOn_sectionPencil p₀ q₀ r N F hF α β γ s]
  simp only [residualDiscContentCoeff, evalAtC]
  set Φ := residualConicDiscriminantOnPencilUniv p₀ q₀ r N F α β γ
  -- `evalAtC s Φ = Polynomial.eval (C s) Φ`
  change
      Polynomial.eval s
          (∑ n ∈ Φ.support,
            Polynomial.C (coeff m (Polynomial.coeff Φ n)) * Polynomial.X ^ n) =
        coeff m (Polynomial.eval (C s : affineTwoRing k) Φ)
  rw [eval_eq_sum_mul_pow Φ s, coeff_sum]
  simp only [Polynomial.eval_finsetSum, Polynomial.eval_mul, Polynomial.eval_C,
    Polynomial.eval_pow, Polynomial.eval_X]
  refine Finset.sum_congr rfl fun n _ => ?_
  have hpow : (C s : affineTwoRing k) ^ n = C (s ^ n) := by simp [map_pow]
  rw [hpow, mul_comm (Polynomial.coeff Φ n), coeff_C_mul, mul_comm]

theorem residualConicDiscriminantOn_sectionPencil_eq_zero_iff
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (α β γ : Fin 3 → Polynomial k) (s : k) :
    residualConicDiscriminantOn p₀ q₀ r N F (sectionPencil α β γ s) = 0 ↔
      ∀ m, Polynomial.eval s (residualDiscContentCoeff p₀ q₀ r N F α β γ m) = 0 := by
  constructor
  · intro h m
    rw [eval_residualDiscContentCoeff p₀ q₀ r N F hF α β γ m s, h, coeff_zero]
  · intro h
    apply MvPolynomial.ext
    intro m
    have := h m
    rw [eval_residualDiscContentCoeff p₀ q₀ r N F hF α β γ m s] at this
    simpa using this

/-- Residual-disc pencil universal polynomial is nonzero when G4 holds at `s = 0`. -/
theorem residualConicDiscriminantOnPencilUniv_ne_zero_of_G4_zero
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (α β γ : Fin 3 → Polynomial k)
    (h0 : ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F (sectionPencil α β γ 0)) :
    residualConicDiscriminantOnPencilUniv p₀ q₀ r N F α β γ ≠ 0 := by
  intro hΦ
  apply h0
  have h := residualConicDiscriminantOn_sectionPencil p₀ q₀ r N F hF α β γ 0
  rw [h, hΦ]
  exact map_zero (evalAtC (0 : k))

/-- Finite residual-disc content for a quadratic section pencil.

The set `{s | residualConicDiscriminantOn (fam s) = 0}` is the common zero locus of finitely many
univariates (the nonzero coefficient univariates of `Φ`).  Nontriviality follows from G4 at
`s = 0`. -/
theorem exists_residualDiscContent_of_sectionPencil
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (α β γ : Fin 3 → Polynomial k)
    (h0 : ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F (sectionPencil α β γ 0)) :
    ∃ (ι : Type) (_ : Fintype ι) (f : ι → Polynomial k),
      (∀ i, f i ≠ 0) ∧
        (∀ s : k,
          residualConicDiscriminantOn p₀ q₀ r N F (sectionPencil α β γ s) = 0 →
            ∃ i, Polynomial.eval s (f i) = 0) := by
  classical
  set Φ := residualConicDiscriminantOnPencilUniv p₀ q₀ r N F α β γ
  have hΦ0 := residualConicDiscriminantOnPencilUniv_ne_zero_of_G4_zero p₀ q₀ r N F hF α β γ h0
  -- Pick any multiindex appearing in a nonzero coefficient of Φ.
  obtain ⟨n, hn⟩ : ∃ n, Polynomial.coeff Φ n ≠ 0 := by
    by_contra h
    push Not at h
    exact hΦ0 (Polynomial.ext fun n => h n)
  obtain ⟨m, hm⟩ : ∃ m, coeff m (Polynomial.coeff Φ n) ≠ 0 := by
    by_contra h
    push Not at h
    have hzero : Polynomial.coeff Φ n = 0 := by
      apply MvPolynomial.ext
      intro m
      exact h m
    exact hn hzero
  have hcontent_ne :
      residualDiscContentCoeff p₀ q₀ r N F α β γ m ≠ 0 := by
    intro hf0
    have hcn :
        Polynomial.coeff (residualDiscContentCoeff p₀ q₀ r N F α β γ m) n = 0 := by
      rw [hf0, Polynomial.coeff_zero]
    have hcn' :
        Polynomial.coeff (residualDiscContentCoeff p₀ q₀ r N F α β γ m) n =
          coeff m (Polynomial.coeff Φ n) := by
      -- `residualDiscContentCoeff` is a support-sum of monomials `C a * X^j`.
      simp only [residualDiscContentCoeff]
      rw [Polynomial.finsetSum_coeff]
      simp only [Polynomial.coeff_C_mul, Polynomial.coeff_X_pow]
      have hsum :
          (∑ j ∈ Φ.support,
              if n = j then coeff m (Polynomial.coeff Φ j) else 0) =
            coeff m (Polynomial.coeff Φ n) := by
        by_cases hmem : n ∈ Φ.support
        · rw [Finset.sum_eq_single n]
          · simp
          · intro j _ hjne; simp [Ne.symm hjne]
          · exact fun h => absurd hmem h
        · -- If n not in support, both sides vanish.
          have hcz : Polynomial.coeff Φ n = 0 :=
            (Polynomial.mem_support_iff).not.mp hmem |> not_not.mp
          simp only [hcz]
          refine Finset.sum_eq_zero fun j hj => ?_
          split_ifs with hnj
          · subst hnj; exact absurd hj hmem
          · rfl
      -- Identify the finset sum with the if-form above.
      convert hsum using 1
      refine Finset.sum_congr rfl fun j _ => ?_
      split_ifs <;> ring
    exact hm (hcn'.symm ▸ hcn)
  refine ⟨Unit, inferInstance, fun _ => residualDiscContentCoeff p₀ q₀ r N F α β γ m, ?_, ?_⟩
  · intro; exact hcontent_ne
  · intro s hs
    refine ⟨(), ?_⟩
    have hforall :=
      (residualConicDiscriminantOn_sectionPencil_eq_zero_iff p₀ q₀ r N F hF α β γ s).mp hs
    exact hforall m

/-- G4 for a pencil member from a nonvanishing content coefficient. -/
theorem ResidualAvoidsConicDiscriminantOn_of_content_eval
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (α β γ : Fin 3 → Polynomial k) (s : k)
    (h : ∃ m, Polynomial.eval s (residualDiscContentCoeff p₀ q₀ r N F α β γ m) ≠ 0) :
    ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F (sectionPencil α β γ s) := by
  intro h0
  obtain ⟨m, hm⟩ := h
  exact hm
    ((residualConicDiscriminantOn_sectionPencil_eq_zero_iff p₀ q₀ r N F hF α β γ s).mp h0 m)

/-! ### D‴ — stereo→pencil, double excision, assembly

Clear `stereoLineParamPoly` over `RatFunc k` once to a polynomial pencil through a nonzero
polynomial multiple of the given section.  Jointly excise residual-disc content and
third-coordinate content over infinite fields (constant parameter).  The easy branch
`v 2 ≠ 0` remains Infinite-free.
-/

open Standard

theorem eval_eq_quad_coeffs {R : Type*} [CommRing R] (f : Polynomial R)
    (hf : f.natDegree ≤ 2) (s : R) :
    Polynomial.eval s f =
      Polynomial.coeff f 0 + s * Polynomial.coeff f 1 + s ^ 2 * Polynomial.coeff f 2 := by
  have hexpand := Polynomial.eval_eq_sum_range' (p := f) (n := 3) (by omega)
  simp only [hexpand, Finset.sum_range_succ, Finset.sum_range_zero, zero_add, pow_zero, pow_one,
    pow_two]
  ring

theorem exists_sectionPencil_of_HasGoodLineWithSection
    [NeZero (2 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (v : Fin 3 → Polynomial k)
    (h : HasGoodLineWithSection F p q r N v) :
    ∃ (α β γ : Fin 3 → Polynomial k) (φ : Polynomial k),
      φ ≠ 0 ∧
        (∀ i, α i = φ * v i) ∧
          (∀ s : k,
            TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F)
              (sectionPencil α β γ s) = 0) ∧
            ResidualAvoidsConicDiscriminantOn p q r N F (sectionPencil α β γ 0) ∧
              (α 2 ≠ 0 ∨ β 2 ≠ 0 ∨ γ 2 ≠ 0) := by
  classical
  rcases h with ⟨_hMN, _hG3, hdisc, hv0, hviso, hG4⟩
  set p_rf : Fin 3 → RatFunc k := fun i => algebraMap (Polynomial k) (RatFunc k) (v i)
  have hp0 : p_rf ≠ 0 := (isotropic_ratFunc_of_poly (lineTernaryQuadraticPoly p q F) v hv0 hviso).1
  have hpiso := (isotropic_ratFunc_of_poly (lineTernaryQuadraticPoly p q F) v hv0 hviso).2
  obtain ⟨w0, w1, hframe⟩ :=
    exists_stereoLineFrame_ratFunc p q F hF hdisc p_rf hp0 hpiso
  set Q : MvPolynomial (Fin 3) (RatFunc k) :=
    MvPolynomial.map (algebraMap (Polynomial k) (RatFunc k)) (lineSpecializedConicPoly p q F)
  have hQ : Q.IsHomogeneous 2 := hframe.isHomogeneous
  set μ : RatFunc k := eval w0 Q
  have hμ : μ ≠ 0 := hframe.free_not_isotropic
  set α_rf : Fin 3 → RatFunc k :=
    fun i => Polynomial.coeff (stereoLineParamPoly Q hQ p_rf w0 w1 i) 0
  set β_rf : Fin 3 → RatFunc k :=
    fun i => Polynomial.coeff (stereoLineParamPoly Q hQ p_rf w0 w1 i) 1
  set γ_rf : Fin 3 → RatFunc k :=
    fun i => Polynomial.coeff (stereoLineParamPoly Q hQ p_rf w0 w1 i) 2
  have hα_rf (i : Fin 3) : α_rf i = μ * p_rf i := by
    have he := eval_stereoLineParamPoly Q hQ p_rf w0 w1 (0 : RatFunc k) i
    have hp := congr_fun (hframe.param_eq (0 : RatFunc k)) i
    simp only [zero_mul, add_zero, sub_zero] at hp
    have hpow : (0 : RatFunc k) ^ 2 = 0 := by ring
    simp only [hpow, zero_mul, add_zero, sub_zero] at hp
    have hce : Polynomial.coeff (stereoLineParamPoly Q hQ p_rf w0 w1 i) 0 =
        Polynomial.eval 0 (stereoLineParamPoly Q hQ p_rf w0 w1 i) :=
      (stereoLineParamPoly Q hQ p_rf w0 w1 i).coeff_zero_eq_eval_zero
    change Polynomial.coeff (stereoLineParamPoly Q hQ p_rf w0 w1 i) 0 = μ * p_rf i
    rw [hce, he, hp]
  have hparam (s : RatFunc k) (i : Fin 3) :
      Polynomial.eval s (stereoLineParamPoly Q hQ p_rf w0 w1 i) =
        α_rf i + s * β_rf i + s ^ 2 * γ_rf i :=
    eval_eq_quad_coeffs _ (natDegree_stereoLineParamPoly_le Q hQ p_rf w0 w1 i) s
  obtain ⟨μn, μd, hμdmem, hμeq⟩ :=
    IsFractionRing.div_surjective (K := RatFunc k) (A := Polynomial k) μ
  have hμd : μd ≠ 0 := nonZeroDivisors.ne_zero hμdmem
  have hμn : μn ≠ 0 := by
    intro hz; apply hμ; rw [← hμeq, hz, map_zero, zero_div]
  obtain ⟨dβ, hdβ, β0, hβ0⟩ := exists_common_denom_smul β_rf
  obtain ⟨dγ, hdγ, γ0, hγ0⟩ := exists_common_denom_smul γ_rf
  let φ : Polynomial k := μn * dβ * dγ
  let α : Fin 3 → Polynomial k := fun i => φ * v i
  let β : Fin 3 → Polynomial k := fun i => μd * dγ * β0 i
  let γ : Fin 3 → Polynomial k := fun i => μd * dβ * γ0 i
  let D : Polynomial k := μd * dβ * dγ
  have hD0 : D ≠ 0 := mul_ne_zero (mul_ne_zero hμd hdβ) hdγ
  have hφ0 : φ ≠ 0 := mul_ne_zero (mul_ne_zero hμn hdβ) hdγ
  have hμ_scale :
      algebraMap (Polynomial k) (RatFunc k) μn =
        algebraMap (Polynomial k) (RatFunc k) μd * μ := by
    have hφμ : algebraMap (Polynomial k) (RatFunc k) μd ≠ 0 :=
      (map_ne_zero_iff _ (IsFractionRing.injective (Polynomial k) (RatFunc k))).mpr hμd
    calc
      algebraMap (Polynomial k) (RatFunc k) μn =
          (algebraMap (Polynomial k) (RatFunc k) μn /
            algebraMap (Polynomial k) (RatFunc k) μd) *
            algebraMap (Polynomial k) (RatFunc k) μd := by field_simp [hφμ]
      _ = μ * algebraMap (Polynomial k) (RatFunc k) μd := by rw [hμeq]
      _ = algebraMap (Polynomial k) (RatFunc k) μd * μ := by ring
  have hαD (i : Fin 3) :
      algebraMap (Polynomial k) (RatFunc k) (α i) =
        algebraMap (Polynomial k) (RatFunc k) D * α_rf i := by
    rw [hα_rf i]
    dsimp [α, φ, D, p_rf]
    calc
      algebraMap (Polynomial k) (RatFunc k) (μn * dβ * dγ * v i) =
          algebraMap _ _ μn * algebraMap _ _ dβ * algebraMap _ _ dγ * algebraMap _ _ (v i) := by
        simp [map_mul]
      _ = (algebraMap _ _ μd * μ) * algebraMap _ _ dβ * algebraMap _ _ dγ *
            algebraMap _ _ (v i) := by rw [hμ_scale]
      _ = algebraMap _ _ (μd * dβ * dγ) * (μ * algebraMap _ _ (v i)) := by
          simp only [map_mul]; ring
  have hβD (i : Fin 3) :
      algebraMap (Polynomial k) (RatFunc k) (β i) =
        algebraMap (Polynomial k) (RatFunc k) D * β_rf i := by
    dsimp [β, D]; simp only [map_mul, hβ0]; ring
  have hγD (i : Fin 3) :
      algebraMap (Polynomial k) (RatFunc k) (γ i) =
        algebraMap (Polynomial k) (RatFunc k) D * γ_rf i := by
    dsimp [γ, D]; simp only [map_mul, hγ0]; ring
  have hfam (s : k) (i : Fin 3) :
      algebraMap (Polynomial k) (RatFunc k) (sectionPencil α β γ s i) =
        algebraMap (Polynomial k) (RatFunc k) D *
          stereoLineParam Q p_rf w0 w1 (algebraMap k (RatFunc k) s) i := by
    dsimp only [sectionPencil]
    simp only [map_add, map_mul, map_pow, hαD, hβD, hγD]
    have hCs : algebraMap (Polynomial k) (RatFunc k) (Polynomial.C s) =
        algebraMap k (RatFunc k) s := rfl
    rw [hCs]
    trans algebraMap (Polynomial k) (RatFunc k) D *
        (α_rf i + algebraMap k (RatFunc k) s * β_rf i +
          (algebraMap k (RatFunc k) s) ^ 2 * γ_rf i)
    · ring
    · rw [← hparam (algebraMap k (RatFunc k) s) i, eval_stereoLineParamPoly]
  have hiso_s (s : k) :
      TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F)
        (sectionPencil α β γ s) = 0 := by
    refine (IsFractionRing.injective (Polynomial k) (RatFunc k)).eq_iff.mp ?_
    rw [← TernaryQuadraticPoly.evalRatFunc_algebraMap, map_zero]
    have hx :
        (fun i => algebraMap (Polynomial k) (RatFunc k) (sectionPencil α β γ s i)) =
          fun i => algebraMap _ _ D *
            stereoLineParam Q p_rf w0 w1 (algebraMap k (RatFunc k) s) i :=
      funext (hfam s)
    rw [hx, TernaryQuadraticPoly.evalRatFunc_smul]
    have hQiso := stereoLineParam_isotropic Q hQ p_rf w0 w1 hframe.isotropic
      (algebraMap k (RatFunc k) s)
    have hsum := eval_eq_ternaryQuadraticCoeff_sum hQ
      (stereoLineParam Q p_rf w0 w1 (algebraMap k (RatFunc k) s))
    have hcoeff (i j : Fin 3) :
        ternaryQuadraticCoeff Q i j =
          algebraMap (Polynomial k) (RatFunc k)
            (ternaryQuadraticCoeff (lineSpecializedConicPoly p q F) i j) := by
      simp only [ternaryQuadraticCoeff, Q, MvPolynomial.coeff_map]
      split_ifs <;> simp
    have hiso_param :
        TernaryQuadraticPoly.evalRatFunc (lineTernaryQuadraticPoly p q F)
          (stereoLineParam Q p_rf w0 w1 (algebraMap k (RatFunc k) s)) = 0 := by
      calc
        TernaryQuadraticPoly.evalRatFunc (lineTernaryQuadraticPoly p q F)
              (stereoLineParam Q p_rf w0 w1 (algebraMap k (RatFunc k) s)) =
            ∑ i, ∑ j,
              algebraMap (Polynomial k) (RatFunc k)
                  (ternaryQuadraticCoeff (lineSpecializedConicPoly p q F) i j) *
                stereoLineParam Q p_rf w0 w1 (algebraMap k (RatFunc k) s) i *
                  stereoLineParam Q p_rf w0 w1 (algebraMap k (RatFunc k) s) j := by
          simp only [TernaryQuadraticPoly.evalRatFunc, ternaryQuadraticPolyRatFunc,
            lineTernaryQuadraticPoly]
        _ = eval (stereoLineParam Q p_rf w0 w1 (algebraMap k (RatFunc k) s)) Q := by
          rw [hsum]
          refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
          rw [hcoeff]
        _ = 0 := hQiso
    rw [hiso_param]
    ring
  have hG4z : ResidualAvoidsConicDiscriminantOn p q r N F (sectionPencil α β γ 0) := by
    rw [sectionPencil_zero]
    change ResidualAvoidsConicDiscriminantOn p q r N F (fun i => φ * v i)
    exact ResidualAvoidsConicDiscriminantOn_of_mul_section p q r N F hF φ hφ0 v hG4
  have hthird : α 2 ≠ 0 ∨ β 2 ≠ 0 ∨ γ 2 ≠ 0 := by
    by_cases hv2 : v 2 ≠ 0
    · exact Or.inl (mul_ne_zero hφ0 hv2)
    · push Not at hv2
      have hp2 : p_rf 2 = 0 := by simp [p_rf, hv2]
      have hne := stereoLineParamPoly_third_ne_zero_of_base_third_eq_zero hframe hp2
      have hrf : α_rf 2 ≠ 0 ∨ β_rf 2 ≠ 0 ∨ γ_rf 2 ≠ 0 := by
        by_contra hall
        push Not at hall
        obtain ⟨ha, hb, hc⟩ := hall
        apply hne
        refine Polynomial.ext fun m => ?_
        match m with
        | 0 => simpa [α_rf] using ha
        | 1 => simpa [β_rf] using hb
        | 2 => simpa [γ_rf] using hc
        | m + 3 =>
          exact Polynomial.coeff_eq_zero_of_natDegree_lt
            (lt_of_le_of_lt (natDegree_stereoLineParamPoly_le Q hQ p_rf w0 w1 2) (by omega))
      have hDm : algebraMap (Polynomial k) (RatFunc k) D ≠ 0 :=
        (map_ne_zero_iff _ (IsFractionRing.injective (Polynomial k) (RatFunc k))).mpr hD0
      rcases hrf with ha | hb | hc
      · refine Or.inl fun h0 => ha ?_
        have := hαD 2
        rw [h0, map_zero] at this
        exact (mul_eq_zero.mp this.symm).resolve_left hDm
      · refine Or.inr (Or.inl fun h0 => hb ?_)
        have := hβD 2
        rw [h0, map_zero] at this
        exact (mul_eq_zero.mp this.symm).resolve_left hDm
      · refine Or.inr (Or.inr fun h0 => hc ?_)
        have := hγD 2
        rw [h0, map_zero] at this
        exact (mul_eq_zero.mp this.symm).resolve_left hDm
  exact ⟨α, β, γ, φ, hφ0, fun _ => rfl, hiso_s, hG4z, hthird⟩

def sectionPencilThirdContent (α β γ : Fin 3 → Polynomial k) (n : ℕ) : Polynomial k :=
  Polynomial.C (Polynomial.coeff (α 2) n) +
    Polynomial.X * Polynomial.C (Polynomial.coeff (β 2) n) +
      Polynomial.X ^ 2 * Polynomial.C (Polynomial.coeff (γ 2) n)

theorem eval_sectionPencilThirdContent
    (α β γ : Fin 3 → Polynomial k) (n : ℕ) (s : k) :
    Polynomial.eval s (sectionPencilThirdContent α β γ n) =
      Polynomial.coeff (sectionPencil α β γ s 2) n := by
  simp only [sectionPencilThirdContent, sectionPencil, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_pow, Polynomial.eval_X, Polynomial.eval_C]
  rw [show Polynomial.C s ^ 2 = Polynomial.C (s ^ 2) from
    (map_pow (Polynomial.C : k →+* Polynomial k) s 2).symm]
  simp only [Polynomial.coeff_add, Polynomial.coeff_C_mul]

theorem coeff0_thirdContent (α β γ : Fin 3 → Polynomial k) (n : ℕ) :
    Polynomial.coeff (sectionPencilThirdContent α β γ n) 0 = Polynomial.coeff (α 2) n := by
  simp [sectionPencilThirdContent]

theorem coeff1_thirdContent (α β γ : Fin 3 → Polynomial k) (n : ℕ) :
    Polynomial.coeff (sectionPencilThirdContent α β γ n) 1 = Polynomial.coeff (β 2) n := by
  simp [sectionPencilThirdContent]

theorem coeff2_thirdContent (α β γ : Fin 3 → Polynomial k) (n : ℕ) :
    Polynomial.coeff (sectionPencilThirdContent α β γ n) 2 = Polynomial.coeff (γ 2) n := by
  simp [sectionPencilThirdContent]

theorem sectionPencil_third_eq_zero_iff
    (α β γ : Fin 3 → Polynomial k) (s : k) :
    sectionPencil α β γ s 2 = 0 ↔
      ∀ n, Polynomial.eval s (sectionPencilThirdContent α β γ n) = 0 := by
  constructor
  · intro h n
    rw [eval_sectionPencilThirdContent, h, Polynomial.coeff_zero]
  · intro h
    refine Polynomial.ext fun n => ?_
    rw [← eval_sectionPencilThirdContent α β γ n s, h n, Polynomial.coeff_zero]

theorem exists_sectionPencilThirdContent_ne_zero
    (α β γ : Fin 3 → Polynomial k)
    (h : α 2 ≠ 0 ∨ β 2 ≠ 0 ∨ γ 2 ≠ 0) :
    ∃ n, sectionPencilThirdContent α β γ n ≠ 0 := by
  classical
  by_contra hall
  replace hall : ∀ n, sectionPencilThirdContent α β γ n = 0 := by
    intro n; exact of_not_not (hall ⟨n, ·⟩)
  have hα : α 2 = 0 := by
    refine Polynomial.ext fun n => ?_
    have := congrArg (fun p => Polynomial.coeff p 0) (hall n)
    rw [Polynomial.coeff_zero, coeff0_thirdContent] at this; exact this
  have hβ : β 2 = 0 := by
    refine Polynomial.ext fun n => ?_
    have := congrArg (fun p => Polynomial.coeff p 1) (hall n)
    rw [Polynomial.coeff_zero, coeff1_thirdContent] at this; exact this
  have hγ : γ 2 = 0 := by
    refine Polynomial.ext fun n => ?_
    have := congrArg (fun p => Polynomial.coeff p 2) (hall n)
    rw [Polynomial.coeff_zero, coeff2_thirdContent] at this; exact this
  rcases h with h | h | h <;> exact h (by assumption)

theorem exists_actualG3G4LineSection_of_HasGoodLineWithSection'
    [NeZero (2 : k)] [NeZero (3 : k)] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (v : Fin 3 → Polynomial k)
    (h : HasGoodLineWithSection F p q r N v) :
    ∃ v' : Fin 3 → Polynomial k, HasActualG3G4LineSection F p q r N v' := by
  classical
  by_cases hv2 : v 2 ≠ 0
  · exact exists_actualG3G4LineSection_of_HasGoodLineWithSection_noInfinite F hF p q r N v h hv2
  · obtain ⟨α, β, γ, _φ, _hφ, _hα, hiso, hG4_0, hthird⟩ :=
      exists_sectionPencil_of_HasGoodLineWithSection F hF p q r N v h
    obtain ⟨ι, _, fdisc, hfdisc, hdisc_zero⟩ :=
      exists_residualDiscContent_of_sectionPencil p q r N F hF α β γ hG4_0
    obtain ⟨n0, hn0⟩ := exists_sectionPencilThirdContent_ne_zero α β γ hthird
    let ι' : Type := Option ι
    let f : ι' → Polynomial k := fun
      | some i => fdisc i
      | none => sectionPencilThirdContent α β γ n0
    have hf : ∀ i, f i ≠ 0 := by
      intro i; cases i with
      | some i => exact hfdisc i
      | none => exact hn0
    obtain ⟨s0, hs0⟩ := exists_eval_ne_zero_of_finite_ne_zero f hf
    have hthird_s : sectionPencil α β γ s0 2 ≠ 0 := by
      intro h0
      exact hs0 none ((sectionPencil_third_eq_zero_iff α β γ s0).mp h0 n0)
    have hG4_s : ResidualAvoidsConicDiscriminantOn p q r N F (sectionPencil α β γ s0) := by
      refine ResidualAvoidsConicDiscriminantOn_of_content_eval p q r N F hF α β γ s0 ?_
      by_contra hall
      push Not at hall
      have hvan : residualConicDiscriminantOn p q r N F (sectionPencil α β γ s0) = 0 := by
        apply MvPolynomial.ext
        intro m
        have := hall m
        rw [eval_residualDiscContentCoeff p q r N F hF α β γ m s0] at this
        simpa using this
      obtain ⟨i, hi⟩ := hdisc_zero s0 hvan
      exact hs0 (some i) hi
    have hv0_s : sectionPencil α β γ s0 ≠ 0 := fun h0 => hthird_s (by rw [h0]; rfl)
    have hQhom : (lineSpecializedConicPoly p q F).IsHomogeneous 2 :=
      lineSpecializedConicPoly_isHomogeneous p q hF
    have hviso' : eval (sectionPencil α β γ s0) (lineSpecializedConicPoly p q F) = 0 := by
      rw [← ternaryQuadraticPoly_eval_line p q F hF]
      exact hiso s0
    have hdisc' : lineConicDiscriminant p q F ≠ 0 := h.2.2.1
    have hpol :=
      polarEval_ne_zero_of_isotropic_of_third_ne_zero hQhom hdisc' hviso' hthird_s
    have hpolar :=
      polarEval_lineStereoDir_ne_zero_of_polarEval_ne_zero p q F hF
        (sectionPencil α β γ s0) hpol
    exact exists_actualG3G4LineSection_of_HasGoodLineWithSection_of_GP_G4 F hF p q r N v h
      (sectionPencil α β γ s0) hv0_s (hiso s0) hthird_s hpolar hG4_s

theorem smooth_bidegree23_hasUnirationalParametrization_of_lineSection'
    (k : Type u) [Field k] [NeZero (2 : k)] [NeZero (3 : k)] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (h : ∃ (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
      (v : Fin 3 → Polynomial k), Standard.HasGoodLineWithSection F p q r N v) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) := by
  obtain ⟨p, q, r, N, v, hG⟩ := h
  obtain ⟨v', hactual⟩ :=
    exists_actualG3G4LineSection_of_HasGoodLineWithSection' F hF p q r N v hG
  exact smooth_bidegree23_hasUnirationalParametrization_of_goodLineSection k F hF hF0
    ⟨p, q, r, N, v', hactual⟩

theorem smooth_bidegree23_hasUnirationalParametrization_of_lineSection'_of_isAlgClosed
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) := by
  obtain ⟨p, q, r, N, _x, v, _u, hactual, _⟩ :=
    Standard.exists_actualG3G4LineSection_via_frameIncidence F hF hF0
  have hdisc : lineConicDiscriminant p q F ≠ 0 :=
    lineConicDiscriminant_ne_zero_of_smooth p q r N hactual.1 F hF hF0
  exact smooth_bidegree23_hasUnirationalParametrization_of_lineSection' k F hF hF0
    ⟨p, q, r, N, v, hactual.to_HasGoodLineWithSection F p q r N v hdisc⟩


end

end BConicBundleMultisections
