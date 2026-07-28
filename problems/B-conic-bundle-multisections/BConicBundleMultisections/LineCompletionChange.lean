/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.LinePresentationPairChange

/-!
# Frame-completion invariance (Goal F-2)

`LinePresentationPairChange` (F-1) proved that `HasGoodLineSectionPartial` does not depend on the
spanning pair `(p,q)` of the multisection line `L`.  This module proves that it does not depend on
the *completion* either: for a fixed pair `(p,q)`, any transversal `r'` with
`lineFrame p q r' * N' = 1` presents the same line.

## The completion block

Two completions of the same pair differ by `r' = e•p + f•q + g•r` with `g ≠ 0`, i.e.

```
lineFrame p q r' = lineFrame p q r * E,   E = !![1,0,e; 0,1,f; 0,0,g]
```

(`lineFrame` has *columns* `(p,q,r)`), and `N' = E⁻¹ * N` with
`E⁻¹ = !![1,0,−e/g; 0,1,−f/g; 0,0,g⁻¹]`.

## Why the first three conditions are free

`HasGoodLineSectionPartial F p q r N v` is
`lineConicDiscriminant p q F ≠ 0 ∧ v ≠ 0 ∧ isotropy ∧ G4`, where `G4` is
`ResidualAvoidsConicDiscriminantOn p q r N F v`.
The first three conjuncts do not mention `(r, N)` **at all** — see `hasGoodLineSectionPartial_def`
below, which is `rfl`.  So the entire content of a completion change is condition G4.

## The transversal chain and its twist

`E` fixes the frame coordinates `(1,t,0)` of the generic point of `L` on the nose, and `E⁻¹` does
too, so the line point and the cubic fibre are literally unchanged.  Only the tangent direction
moves, and it moves by

```
E *ᵥ complementaryTangentDir (H ∘ E) (1,t,0)
  = g • complementaryTangentDir H (1,t,0) + γ • (1,t,0),   γ = (e + f·t)·(∂₁H)(1,t,0)
```

— an *exact* identity, with **no clearing denominators**: the `r ↦ g•r` generator contributes the
unit `g` and the `r ↦ r+e•p`, `r ↦ r+f•q` generators contribute only the tangential term `γ·p`,
absorbed by `residualAmbientRep_cleared_reparam` exactly as F-1's `γ·p₀` was.  Hence

| stage | twist |
|---|---|
| `frameTangentDir` | `g • qd + γ • pL` (exact, `c = 1`) |
| `residualYCoordsOn` | `C (g³) ·` (unit; no clearing factor) |
| `residualConicDiscriminantOn` | `C (g²⁷) ·` (`27 = 3·9`) |
| section `v` | **unchanged** — no section twist is forced |

The residual discriminant law is a *unit* multiple, so G4 transports in both directions.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial
open _root_.MvPolynomial
open scoped _root_.Matrix

/-! ### The completion block and its frame identities -/

section CompletionMatrix

variable {R : Type u} [CommRing R]

/-- Completion block `E = !![1,0,e; 0,1,f; 0,0,g]`.  Its columns are `p ↦ p`, `q ↦ q`,
`r ↦ e•p + f•q + g•r`, matching the *column* convention of `lineFrame`. -/
def completionMatrix3 (e f g : R) : Matrix (Fin 3) (Fin 3) R :=
  !![1, 0, e; 0, 1, f; 0, 0, g]

@[simp] theorem completionMatrix3_map {S : Type u} [CommRing S] (φ : R →+* S) (e f g : R) :
    (completionMatrix3 e f g).map φ = completionMatrix3 (φ e) (φ f) (φ g) := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [completionMatrix3]

/-- Changing the completion multiplies the frame by `E` on the right. -/
theorem lineFrame_completion (p q r : Fin 3 → R) (e f g : R) :
    lineFrame p q (fun i => e * p i + f * q i + g * r i) =
      lineFrame p q r * completionMatrix3 e f g := by
  ext i j
  fin_cases j <;>
    simp [lineFrame, completionMatrix3, Matrix.mul_apply, Fin.sum_univ_three] <;> ring

/-- **`E` fixes the frame coordinates of the generic point of `L`.**  This is the reason the
completion change touches nothing but the transversal direction. -/
@[simp] theorem completionMatrix3_mulVec_line (e f g t : R) :
    completionMatrix3 e f g *ᵥ ![1, t, (0 : R)] = ![1, t, 0] := by
  funext i
  fin_cases i <;>
    simp [completionMatrix3, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

theorem completionMatrix3_mulVec_vec (e f g x y z : R) :
    completionMatrix3 e f g *ᵥ ![x, y, z] = ![x + e * z, y + f * z, g * z] := by
  funext i
  fin_cases i <;>
    simp [completionMatrix3, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

theorem completionMatrix3_transpose_mulVec (e f g : R) (x : Fin 3 → R) :
    (completionMatrix3 e f g).transpose *ᵥ x =
      ![x 0, x 1, e * x 0 + f * x 1 + g * x 2] := by
  funext i
  fin_cases i <;>
    simp [completionMatrix3, Matrix.mulVec, Matrix.transpose, dotProduct,
      Fin.sum_univ_three]

end CompletionMatrix

section CompletionInverse

variable {k : Type u} [Field k]

/-- Inverse completion block `E⁻¹ = !![1,0,−e/g; 0,1,−f/g; 0,0,g⁻¹]`. -/
def completionInvMatrix3 (e f g : k) : Matrix (Fin 3) (Fin 3) k :=
  !![1, 0, -(e / g); 0, 1, -(f / g); 0, 0, g⁻¹]

theorem completionMatrix3_inv (e f g : k) (hg : g ≠ 0) :
    completionMatrix3 e f g * completionInvMatrix3 e f g = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [completionMatrix3, completionInvMatrix3, Matrix.mul_apply, Fin.sum_univ_three,
      hg] <;>
    field_simp <;> ring

/-- **Adjusted inverse for a completion change**: `N' = E⁻¹ * N`. -/
theorem lineFrame_mul_completion_inv
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (e f g : k) (hg : g ≠ 0)
    (hMN : lineFrame p q r * N = 1) :
    lineFrame p q (fun i => e * p i + f * q i + g * r i) *
        (completionInvMatrix3 e f g * N) = 1 := by
  rw [lineFrame_completion, mul_assoc, ← mul_assoc (completionMatrix3 e f g),
    completionMatrix3_inv e f g hg, one_mul, hMN]

end CompletionInverse

/-! ### The transversal direction under a completion change -/

section TangentDir

variable {R : Type u} [CommRing R]

/-- Any frame-transported tangent direction lies in the tangent hyperplane cone of the point.
For the coordinate frame this is `complementaryTangentDir_mem_tangentHyperplaneCone`; in general
the gradient transports by `Mᵀ` and the dot product moves across. -/
theorem frameTangentDir_mem_tangentHyperplaneCone
    (M N : Matrix (Fin 3) (Fin 3) R) (hMN : M * N = 1)
    (G : MvPolynomial (Fin 3) R) (p : Fin 3 → R) :
    frameTangentDir M N G p ∈ tangentHyperplaneCone G p := by
  have hinv : M *ᵥ (N *ᵥ p) = p := by
    rw [Matrix.mulVec_mulVec, hMN, Matrix.one_mulVec]
  have hmove : ∀ v w : Fin 3 → R, v ⬝ᵥ (M *ᵥ w) = (M.transpose *ᵥ v) ⬝ᵥ w := by
    intro v w
    simp only [dotProduct, Matrix.mulVec, Matrix.transpose_apply, Fin.sum_univ_three]
    ring
  have hgrad :
      tangentGradient ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G) (N *ᵥ p)
        = M.transpose *ᵥ tangentGradient G p := by
    rw [tangentGradient_aeval_linearSubst, hinv]
  have h0 :
      complementaryTangentDir
          ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G) (N *ᵥ p)
        ∈ tangentHyperplaneCone
            ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G) (N *ᵥ p) :=
    complementaryTangentDir_mem_tangentHyperplaneCone _ _
  rw [mem_tangentHyperplaneCone, eval_tangentForm_eq_dotProduct, hgrad] at h0
  rw [mem_tangentHyperplaneCone, eval_tangentForm_eq_dotProduct, frameTangentDir, hmove]
  exact h0

/-- **The transversal direction under a completion change — exact reparametrisation.**

With `E = completionMatrix3 e f g`, `p₀ = (1,t,0)` a point of the cubic:
```
E * complementaryTangentDir (H ∘ E) p₀
  = g • complementaryTangentDir H p₀ + γ • p₀,   γ = (e + f·t) · (∂₁H)(p₀).
```
There is **no clearing factor**: `c = 1`.  The `g` is the unit contributed by `r ↦ g•r`; the
tangential `γ·p₀` is contributed by `r ↦ r+e•p` and `r ↦ r+f•q` and is absorbed by
`residualAmbientRep_cleared_reparam`. -/
theorem complementaryTangentDir_completion_cleared
    (H : MvPolynomial (Fin 3) R) (hH : H.IsHomogeneous 3) (e f g t : R)
    (hp : eval ![1, t, (0 : R)] H = 0) :
    completionMatrix3 e f g *ᵥ
        complementaryTangentDir
          ((aeval (linearSubst 2 (completionMatrix3 e f g)) :
              MvPolynomial (Fin 3) R →ₐ[R] _) H)
          ![1, t, 0] =
      fun i => g * complementaryTangentDir H ![1, t, 0] i +
        ((e + f * t) * tangentGradient H ![1, t, (0 : R)] 1) * (![1, t, (0 : R)] i) := by
  set E := completionMatrix3 e f g with hE
  set p₀ : Fin 3 → R := ![1, t, 0] with hp₀
  set H' := (aeval (linearSubst 2 E) : MvPolynomial (Fin 3) R →ₐ[R] _) H with hH'
  set gd := tangentGradient H p₀ with hgd
  have hEp : E *ᵥ p₀ = p₀ := completionMatrix3_mulVec_line e f g t
  -- Euler at `(1,t,0)`: the gradient is orthogonal to the point.
  have hEuler : gd 0 + t * gd 1 = 0 := by
    have htf : eval p₀ (tangentForm H p₀) = 0 := eval_tangentForm_self_eq_zero hH hp
    have hdot : tangentGradient H p₀ ⬝ᵥ p₀ = 0 := by rwa [← eval_tangentForm_eq_dotProduct]
    have hsum : gd 0 * 1 + gd 1 * t + gd 2 * 0 = 0 := by
      simpa [hgd, hp₀, dotProduct, Fin.sum_univ_three] using hdot
    linear_combination hsum
  -- Chain rule: the gradient of `H ∘ E` at `p₀` is `Eᵀ · gd`.
  have hgrad : tangentGradient H' p₀ = E.transpose *ᵥ gd := by
    have h := tangentGradient_aeval_linearSubst E H p₀
    rwa [hEp] at h
  have hT : E.transpose *ᵥ gd = ![gd 0, gd 1, e * gd 0 + f * gd 1 + g * gd 2] :=
    completionMatrix3_transpose_mulVec e f g gd
  -- Expand the left-hand direction.
  have hL : E *ᵥ complementaryTangentDir H' p₀ =
      ![t * (e * gd 0 + f * gd 1 + g * gd 2) + e * (gd 1 - t * gd 0),
        -(e * gd 0 + f * gd 1 + g * gd 2) + f * (gd 1 - t * gd 0),
        g * (gd 1 - t * gd 0)] := by
    have hc : complementaryTangentDir H' p₀ = cross3 p₀ (E.transpose *ᵥ gd) := by
      simp only [complementaryTangentDir, hgrad]
    rw [hc, hT, hp₀, cross3_line_point, completionMatrix3_mulVec_vec]
    funext j
    fin_cases j <;> simp
  -- Expand the right-hand direction.
  have hR : complementaryTangentDir H p₀ = ![t * gd 2, -gd 2, gd 1 - t * gd 0] := by
    rw [hp₀, complementaryTangentDir, cross3_line_point]
  rw [hL, hR]
  funext i
  fin_cases i
  · change t * (e * gd 0 + f * gd 1 + g * gd 2) + e * (gd 1 - t * gd 0) =
      g * (t * gd 2) + (e + f * t) * gd 1 * 1
    ring
  · change -(e * gd 0 + f * gd 1 + g * gd 2) + f * (gd 1 - t * gd 0) =
      g * -gd 2 + (e + f * t) * gd 1 * t
    linear_combination (-(e : R) - f * t) * hEuler
  · change g * (gd 1 - t * gd 0) = g * (gd 1 - t * gd 0) + (e + f * t) * gd 1 * 0
    ring

/-- Existential form of the completion reparametrisation. -/
theorem complementaryTangentDir_completion_reparam
    (H : MvPolynomial (Fin 3) R) (hH : H.IsHomogeneous 3) (e f g t : R)
    (hp : eval ![1, t, (0 : R)] H = 0) :
    ∃ γ : R,
      completionMatrix3 e f g *ᵥ
          complementaryTangentDir
            ((aeval (linearSubst 2 (completionMatrix3 e f g)) :
                MvPolynomial (Fin 3) R →ₐ[R] _) H)
            ![1, t, 0] =
        fun i => g * complementaryTangentDir H ![1, t, 0] i + γ * (![1, t, (0 : R)] i) :=
  ⟨_, complementaryTangentDir_completion_cleared H hH e f g t hp⟩

/-- Substituting one linear change into another composes the matrices, on polynomials. -/
theorem aeval_linearSubst_mul (M E : Matrix (Fin 3) (Fin 3) R) (G : MvPolynomial (Fin 3) R) :
    (aeval (linearSubst 2 (M * E)) : MvPolynomial (Fin 3) R →ₐ[R] _) G =
      (aeval (linearSubst 2 E) : MvPolynomial (Fin 3) R →ₐ[R] _)
        ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G) := by
  suffices h :
      (aeval (linearSubst 2 (M * E)) : MvPolynomial (Fin 3) R →ₐ[R] _) =
        (aeval (linearSubst 2 E) : MvPolynomial (Fin 3) R →ₐ[R] _).comp
          (aeval (linearSubst 2 M)) from DFunLike.congr_fun h G
  refine MvPolynomial.algHom_ext fun j => ?_
  simp only [AlgHom.comp_apply, aeval_X]
  exact (aeval_linearSubst_linearSubst 2 E M j).symm

end TangentDir

/-! ### The residual `Y`-coordinates under a completion change -/

section ResidualY

variable {k : Type u} [Field k]

/-- Unfolded form of `residualYCoordsOn`. -/
theorem residualYCoordsOn_eq_residualAmbientRep
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k) :
    residualYCoordsOn p q r N F v =
      residualAmbientRep (affineTwoLinePoint p q)
        (frameTangentDir (affineTwoLineFrame p q r) (N.map C)
          (cubicFiberPullback F (stereoFirstCoordsOn p q F v)) (affineTwoLinePoint p q))
        (binaryLineRestriction (affineTwoLinePoint p q)
          (frameTangentDir (affineTwoLineFrame p q r) (N.map C)
            (cubicFiberPullback F (stereoFirstCoordsOn p q F v)) (affineTwoLinePoint p q))
          (cubicFiberPullback F (stereoFirstCoordsOn p q F v))) :=
  rfl

theorem affineTwoLineFrame_completion (p q r : Fin 3 → k) (e f g : k) :
    affineTwoLineFrame p q (fun i => e * p i + f * q i + g * r i) =
      affineTwoLineFrame p q r * completionMatrix3 (C e) (C f) (C g) := by
  have h : (fun i => (C (e * p i + f * q i + g * r i) : affineTwoRing k)) =
      fun i => C e * C (p i) + C f * C (q i) + C g * C (r i) := by
    funext i; simp [map_add, map_mul]
  simp only [affineTwoLineFrame, h]
  exact lineFrame_completion _ _ _ _ _ _

/-- **The transversal direction along `L` under a completion change.**

The frame coordinates of the line point are unchanged, so only the direction moves — by the unit
`C g` plus a multiple of the line point itself. -/
theorem frameTangentDir_completion
    (p q r : Fin 3 → k) (N N' : Matrix (Fin 3) (Fin 3) k) (e f g : k)
    (hMN : lineFrame p q r * N = 1)
    (hMN' : lineFrame p q (fun i => e * p i + f * q i + g * r i) * N' = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0) :
    ∃ γ : affineTwoRing k,
      frameTangentDir (affineTwoLineFrame p q (fun i => e * p i + f * q i + g * r i))
          (N'.map C) (cubicFiberPullback F (stereoFirstCoordsOn p q F v))
          (affineTwoLinePoint p q) =
        fun i => C g * frameTangentDir (affineTwoLineFrame p q r) (N.map C)
              (cubicFiberPullback F (stereoFirstCoordsOn p q F v))
              (affineTwoLinePoint p q) i +
          γ * affineTwoLinePoint p q i := by
  classical
  set r' : Fin 3 → k := fun i => e * p i + f * q i + g * r i with hr'
  set G := cubicFiberPullback F (stereoFirstCoordsOn p q F v) with hG
  set pL := affineTwoLinePoint p q with hpL
  set M := affineTwoLineFrame p q r with hM
  set E := completionMatrix3 (C e : affineTwoRing k) (C f) (C g) with hE
  have hM' : affineTwoLineFrame p q r' = M * E := affineTwoLineFrame_completion p q r e f g
  -- frame coordinates of the line point, for both completions
  have hz : (N.map (C : k →+* affineTwoRing k)) *ᵥ pL = ![1, affineTwoCoord0 k, 0] :=
    mulVec_affineTwoLinePoint p q r N hMN
  have hz' : (N'.map (C : k →+* affineTwoRing k)) *ᵥ pL = ![1, affineTwoCoord0 k, 0] :=
    mulVec_affineTwoLinePoint p q r' N' hMN'
  have hMNC : M * N.map (C : k →+* affineTwoRing k) = 1 :=
    lineFrame_map_mul_map (C : k →+* affineTwoRing k) p q r N hMN
  have hMinv : M *ᵥ ![1, affineTwoCoord0 k, (0 : affineTwoRing k)] = pL := by
    rw [← hz, Matrix.mulVec_mulVec, hMNC, Matrix.one_mulVec]
  set Gb := (aeval (linearSubst 2 M) :
    MvPolynomial (Fin 3) (affineTwoRing k) →ₐ[affineTwoRing k] _) G with hGb
  have hGhom : G.IsHomogeneous 3 := cubicFiberPullback_isHomogeneous F hF _
  have hGbhom : Gb.IsHomogeneous 3 := isHomogeneous_aeval_linearSubst M hGhom
  have hpG : eval pL G = 0 := by
    simpa [hpL, hG] using eval_cubicFiber_line_of_stereo p q F hF v hv
  have hpb : eval ![1, affineTwoCoord0 k, (0 : affineTwoRing k)] Gb = 0 := by
    rw [hGb, eval_aeval_linearSubst, hMinv]
    exact hpG
  obtain ⟨γ, hγ⟩ :=
    complementaryTangentDir_completion_reparam Gb hGbhom (C e) (C f) (C g)
      (affineTwoCoord0 k) hpb
  refine ⟨γ, ?_⟩
  have hleft :
      frameTangentDir (affineTwoLineFrame p q r') (N'.map C) G pL =
        M *ᵥ (E *ᵥ complementaryTangentDir
          ((aeval (linearSubst 2 E) :
            MvPolynomial (Fin 3) (affineTwoRing k) →ₐ[affineTwoRing k] _) Gb)
          ![1, affineTwoCoord0 k, 0]) := by
    rw [frameTangentDir, hz', hM', ← aeval_linearSubst_mul, ← hM', Matrix.mulVec_mulVec, hM']
  have hright :
      frameTangentDir M (N.map C) G pL =
        M *ᵥ complementaryTangentDir Gb ![1, affineTwoCoord0 k, 0] := by
    rw [frameTangentDir, hz, hGb]
  rw [hleft, hright, hγ]
  funext i
  simp only [Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  have h1 : (M *ᵥ ![1, affineTwoCoord0 k, (0 : affineTwoRing k)]) i = pL i := by rw [hMinv]
  simp only [Matrix.mulVec, dotProduct, Fin.sum_univ_three] at h1
  rw [← h1]
  ring

/-- **The residual `Y`-coordinates under a completion change**: multiplication by the unit
`C (g³)`.  No clearing factor appears — the completion twist is a pure unit power. -/
theorem residualYCoordsOn_completion
    (p q r : Fin 3 → k) (N N' : Matrix (Fin 3) (Fin 3) k) (e f g : k)
    (hMN : lineFrame p q r * N = 1)
    (hMN' : lineFrame p q (fun i => e * p i + f * q i + g * r i) * N' = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0) :
    residualYCoordsOn p q (fun i => e * p i + f * q i + g * r i) N' F v =
      fun i => C (g ^ 3) * residualYCoordsOn p q r N F v i := by
  classical
  set r' : Fin 3 → k := fun i => e * p i + f * q i + g * r i with hr'
  set G := cubicFiberPullback F (stereoFirstCoordsOn p q F v) with hG
  set pL := affineTwoLinePoint p q with hpL
  set M := affineTwoLineFrame p q r with hM
  set qd := frameTangentDir M (N.map C) G pL with hqd
  set qd' := frameTangentDir (affineTwoLineFrame p q r') (N'.map C) G pL with hqd'
  obtain ⟨γ, hγ⟩ := frameTangentDir_completion p q r N N' e f g hMN hMN' F hF v hv
  have hGhom : G.IsHomogeneous 3 := cubicFiberPullback_isHomogeneous F hF _
  have hpG : eval pL G = 0 := by
    simpa [hpL, hG] using eval_cubicFiber_line_of_stereo p q F hF v hv
  have hMNC : M * N.map (C : k →+* affineTwoRing k) = 1 :=
    lineFrame_map_mul_map (C : k →+* affineTwoRing k) p q r N hMN
  have hqcone : qd ∈ tangentHyperplaneCone G pL :=
    frameTangentDir_mem_tangentHyperplaneCone M (N.map C) hMNC G pL
  have hreparam : (fun i => (1 : affineTwoRing k) * qd' i) =
      fun i => C g * qd i + γ * pL i := by
    funext i
    rw [one_mul]
    exact congrFun hγ i
  have hkey :=
    residualAmbientRep_cleared_reparam pL qd qd' 1 (C g) γ G hGhom hpG hqcone hreparam
  funext i
  have h := congrFun hkey i
  simp only [one_pow, one_mul] at h
  change residualAmbientRep pL qd' (binaryLineRestriction pL qd' G) i
      = C (g ^ 3) * residualAmbientRep pL qd (binaryLineRestriction pL qd G) i
  rw [map_pow]
  exact h

end ResidualY

/-! ### Automatic G4 and the completion-change transport -/

section G4

variable {k : Type u} [Field k]

/-- **The residual conic discriminant under a completion change**: the unit `C (g²⁷)`,
`27 = 3 · 9` (residual-`Y` weight `3`, discriminant degree `9`). -/
theorem residualConicDiscriminantOn_completion
    (p q r : Fin 3 → k) (N N' : Matrix (Fin 3) (Fin 3) k) (e f g : k)
    (hMN : lineFrame p q r * N = 1)
    (hMN' : lineFrame p q (fun i => e * p i + f * q i + g * r i) * N' = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0) :
    residualConicDiscriminantOn p q (fun i => e * p i + f * q i + g * r i) N' F v =
      C (g ^ 27) * residualConicDiscriminantOn p q r N F v := by
  have hY := residualYCoordsOn_completion p q r N N' e f g hMN hMN' F hF v hv
  simp only [residualConicDiscriminantOn, hY]
  rw [aeval_sndConicDiscriminant_smul F hF (C (g ^ 3)) (residualYCoordsOn p q r N F v)]
  congr 1
  rw [← map_pow, ← pow_mul]

/-- Completion twist exponent bookkeeping: residual-`Y` weight `3`, discriminant degree `9`. -/
theorem residualY_completion_disc_exponent : (3 : ℕ) * 9 = 27 := by norm_num

/-- **G4 is invariant under a completion change** (both directions are available because the
twist is a unit). -/
theorem ResidualAvoidsConicDiscriminantOn_completion
    (p q r : Fin 3 → k) (N N' : Matrix (Fin 3) (Fin 3) k) (e f g : k) (hg : g ≠ 0)
    (hMN : lineFrame p q r * N = 1)
    (hMN' : lineFrame p q (fun i => e * p i + f * q i + g * r i) * N' = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0)
    (h : ResidualAvoidsConicDiscriminantOn p q r N F v) :
    ResidualAvoidsConicDiscriminantOn p q (fun i => e * p i + f * q i + g * r i) N' F v := by
  intro h0
  apply h
  have hcleared := residualConicDiscriminantOn_completion p q r N N' e f g hMN hMN' F hF v hv
  rw [h0] at hcleared
  have hC : (C (g ^ 27) : affineTwoRing k) ≠ 0 := by
    simp [hg]
  exact (mul_eq_zero.mp hcleared.symm).resolve_left hC

/-- The first three conjuncts of `HasGoodLineSectionPartial` do not mention the completion
`(r, N)` at all: only G4 does.  This is `rfl`. -/
theorem hasGoodLineSectionPartial_def
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (v : Fin 3 → Polynomial k) :
    HasGoodLineSectionPartial F p q r N v ↔
      (lineConicDiscriminant p q F ≠ 0 ∧ v ≠ 0 ∧
        TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p q F) v = 0) ∧
        ResidualAvoidsConicDiscriminantOn p q r N F v :=
  ⟨fun ⟨h1, h2, h3, h4⟩ => ⟨⟨h1, h2, h3⟩, h4⟩, fun ⟨⟨h1, h2, h3⟩, h4⟩ => ⟨h1, h2, h3, h4⟩⟩

/-- **F-2 endpoint: `HasGoodLineSectionPartial` is invariant under a change of completion.**

The section `v` is *unchanged*: no section twist is forced.  `N'` is only required to be *an*
inverse of the new frame — it is then automatically `E⁻¹ * N`. -/
theorem hasGoodLineSectionPartial_completion_change
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (p q r : Fin 3 → k) (N N' : Matrix (Fin 3) (Fin 3) k) (e f g : k) (hg : g ≠ 0)
    (hMN : lineFrame p q r * N = 1)
    (hMN' : lineFrame p q (fun i => e * p i + f * q i + g * r i) * N' = 1)
    (v : Fin 3 → Polynomial k)
    (h : HasGoodLineSectionPartial F p q r N v) :
    HasGoodLineSectionPartial F p q (fun i => e * p i + f * q i + g * r i) N' v := by
  obtain ⟨hdisc, hv0, hviso, hG4⟩ := h
  exact ⟨hdisc, hv0, hviso,
    ResidualAvoidsConicDiscriminantOn_completion p q r N N' e f g hg hMN hMN' F hF v hviso hG4⟩

/-- The completion change with the *canonical* adjusted inverse `N' = E⁻¹ * N`. -/
theorem hasGoodLineSectionPartial_completion_change_inv
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (e f g : k) (hg : g ≠ 0)
    (hMN : lineFrame p q r * N = 1)
    (v : Fin 3 → Polynomial k)
    (h : HasGoodLineSectionPartial F p q r N v) :
    HasGoodLineSectionPartial F p q (fun i => e * p i + f * q i + g * r i)
      (completionInvMatrix3 e f g * N) v :=
  hasGoodLineSectionPartial_completion_change F hF p q r N _ e f g hg hMN
    (lineFrame_mul_completion_inv p q r N e f g hg hMN) v h

end G4

end

end BConicBundleMultisections
