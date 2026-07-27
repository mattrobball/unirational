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
# Minimal-hypothesis line section (Goal D)

Weakens `HasActualG3G4LineSection` by dropping `v 2 ≠ 0` and stereographic polar nonvanishing.

## Scaling degrees (computed)

* **Polar form** (`lineStereoPolarForm`): degree **1** in the section.
* **Stereo first coords**: degree **1** (`stereoAlg` left-linear).
* **Residual `Y`-coordinates**: degree **8** in the section
  (stereo `λ` · cubic fibre `λ²` · frame-tangent residual `μ⁴` with `μ = λ²`).
* **G4**: discriminant degree 9 ⇒ pullback scales by `λ⁷²`; invariant under nonzero scaling.

**Design confirmation:** `residualYCoordsOn` **is** homogeneous of degree 8 in the section.

## Residual-line upgrade for `v 2 = 0` (open formalisation)

When C2 / stereoAlg produce general position but lose G4, repair by polar-adapted residual-line
family through `v` (C1 over `RatFunc k`, common denom, content univariates, Infinite excision).
G4 at `s = 0` by residual Y degree-8 scaling.  Content-poly extraction for residual disc along
`fam(s)` is the remaining Goal D step.  D3 never needs it (selection supplies third ≠ 0 and G4).
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

end

end BConicBundleMultisections
