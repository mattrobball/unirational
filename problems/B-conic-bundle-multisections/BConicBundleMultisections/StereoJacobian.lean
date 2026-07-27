/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.AlgebraicIndependenceJacobian
public import BConicBundleMultisections.JacobianCriterionCharFree
public import BConicBundleMultisections.CubicFiberSingularLocus
public import BConicBundleMultisections.FirstProjectionJacobian
public import BConicBundleMultisections.FirstProjectionSmoothFiber
public import BConicBundleMultisections.GoodLineCondition
public import BConicBundleMultisections.IsotropicCone
public import BConicBundleMultisections.ProjectiveSpaceChartDominance
public import BConicBundleMultisections.ResidualYCoordsPureT
public import Mathlib.LinearAlgebra.BilinearForm.Orthogonal
public import Mathlib.LinearAlgebra.Matrix.BilinearForm
public import Mathlib.LinearAlgebra.Dimension.Finrank
public import Mathlib.LinearAlgebra.Dimension.Constructions
public import Mathlib.LinearAlgebra.FiniteDimensional.Basic
public import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
public import Mathlib.RingTheory.Localization.FractionRing
public import BConicBundleMultisections.NeZeroTwoThree

/-!
# The stereographic family sweeps a surface

Input (ii) of the split of obligation 1 — *some stereo parameter has a nonsingular cubic fibre* —
is assembled from two inputs:

* **coordinate algebraic Sard** for the first projection;
* **the stereo Jacobian is nonzero**.

## Reduction of the Jacobian (Gram identity)

With `Q(Y) = 0` one has `B(Y,Y) = B(Y, ∂Y/∂s) = 0` and `B(Y, ∂Y/∂t) = −(∂_t Q)(Y)`.  The polar
Gram identity then gives

```
det Gram(Y, ∂Y/∂t, ∂Y/∂s) = det(polarMatrix Q) · det[Y, ∂Y/∂t, ∂Y/∂s]²
                          = −B(Y, ∂Y/∂t)² · B(∂Y/∂s, ∂Y/∂s).
```

Nonvanishing of the stereo Jacobian therefore follows from three conic-level facts: smoothness of
the generic conic (proved below by transport from
`coordinateLineConicDiscriminant_ne_zero_of_smooth`), immersion (`B(∂Y/∂s, ∂Y/∂s) ≠ 0`), and
motion of the family (`B(Y, ∂Y/∂t) ≠ 0`).
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace Matrix
open _root_.MvPolynomial
open Module Submodule
open LinearMap (BilinForm)

/-- Specializing parameters commutes with pullback along the stereo family. -/
theorem evalAffineTwoPoint_aeval {k : Type u} [CommRing k] (t s : k)
    (x : Fin 3 → affineTwoRing k) (Δ : MvPolynomial (Fin 3) k) :
    evalAffineTwoPoint t s ((aeval x : MvPolynomial (Fin 3) k →ₐ[k] affineTwoRing k) Δ)
      = eval (fun i => evalAffineTwoPoint t s (x i)) Δ := by
  induction Δ using MvPolynomial.induction_on with
  | C a => simp [evalAffineTwoPoint, MvPolynomial.algebraMap_eq]
  | add p q hp hq => simp only [map_add, hp, hq]
  | mul_X p j hp => simp only [map_mul, aeval_X, eval_X, hp]

/-- The Jacobian determinant of the stereographic family. -/
def stereoJacobianDet {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k) :
    affineTwoRing k :=
  (Matrix.of ![residualImageXCoords F v,
    fun a => pderiv (ULift.up 0) (residualImageXCoords F v a),
    fun a => pderiv (ULift.up 1) (residualImageXCoords F v a)]).det

/-! ### Lift injectivity and pure-`t` derivatives -/

/-- `liftPolyTHom` is injective: evaluate `X₀ ↦ X`, `X₁ ↦ 0` to recover the univariate. -/
theorem liftPolyTHom_injective {k : Type u} [Field k] :
    Function.Injective (liftPolyTHom (k := k)) := by
  intro p q h
  let φ : affineTwoRing k →ₐ[k] Polynomial k :=
    aeval (fun i : ULift (Fin 2) => if i.down = 0 then (Polynomial.X : Polynomial k) else 0)
  have hret (r : Polynomial k) : φ (liftPolyTHom r) = r := by
    have hC : φ.toRingHom.comp MvPolynomial.C = Polynomial.C := by
      ext a; simp [φ, Polynomial.algebraMap_eq]
    have ht : φ.toRingHom (affineTwoCoord0 k) = Polynomial.X := by
      simp [φ, affineTwoCoord0, aeval_X]
    have h3 :=
      Polynomial.hom_eval₂ r (f := MvPolynomial.C) (g := φ.toRingHom) (x := affineTwoCoord0 k)
    rw [hC, ht, Polynomial.eval₂_C_X] at h3
    simpa [liftPolyTHom] using h3
  have : φ (liftPolyTHom p) = φ (liftPolyTHom q) := by rw [h]
  simpa [hret] using this

theorem liftPolyT_ne_zero {k : Type u} [Field k] (p : Polynomial k) (hp : p ≠ 0) :
    liftPolyT p ≠ 0 := by
  intro h
  rw [liftPolyT_eq_hom] at h
  have : liftPolyTHom p = liftPolyTHom 0 := by rw [h, map_zero]
  exact hp (liftPolyTHom_injective this)

theorem liftTsenSection_two_ne_zero {k : Type u} [Field k]
    (v : Fin 3 → Polynomial k) (hv2 : v 2 ≠ 0) :
    liftTsenSection v 2 ≠ 0 :=
  liftPolyT_ne_zero (v 2) hv2

/-- Polynomials in `t` alone have vanishing `s`-derivative after lift to `k[t,s]`. -/
theorem pderiv_s_liftPolyT {k : Type u} [CommRing k] (p : Polynomial k) :
    pderiv (ULift.up 1) (liftPolyT p) = 0 := by
  simp only [liftPolyT]
  refine p.induction_on ?_ ?_ ?_
  · intro a; simp [Polynomial.eval₂_C]
  · intro f g hf hg; simp [Polynomial.eval₂_add, hf, hg]
  · intro n a ih
    have hpow : (Polynomial.C a * Polynomial.X ^ (n + 1) : Polynomial k) =
        (Polynomial.C a * Polynomial.X ^ n) * Polynomial.X := by
      rw [pow_succ, mul_assoc]
    rw [hpow, Polynomial.eval₂_mul, Polynomial.eval₂_X]
    have ht : pderiv (ULift.up 1) (affineTwoCoord0 k) = 0 := by
      simp [affineTwoCoord0, pderiv_X]
    rw [Derivation.leibniz, ih, ht]
    simp [smul_eq_mul]

/-- `t`-derivative of a pure-`t` lift is the lift of the univariate derivative. -/
theorem pderiv_t_liftPolyT {k : Type u} [CommRing k] (p : Polynomial k) :
    pderiv (ULift.up 0) (liftPolyT p) = liftPolyT (Polynomial.derivative p) := by
  simp only [liftPolyT]
  refine p.induction_on ?_ ?_ ?_
  · intro a
    simp [Polynomial.eval₂_C, Polynomial.derivative_C]
  · intro f g hf hg
    simp [Polynomial.eval₂_add, Polynomial.derivative_add, hf, hg]
  · intro n a ih
    set t := affineTwoCoord0 k
    set f : Polynomial k := Polynomial.C a * Polynomial.X ^ n
    have hdecomp : Polynomial.C a * Polynomial.X ^ (n + 1) = f * Polynomial.X := by
      simp only [f, pow_succ, mul_assoc]
    have ht : pderiv (ULift.up 0) t = (1 : affineTwoRing k) := by
      simp [t, affineTwoCoord0, pderiv_X]
    have hL :
        pderiv (ULift.up 0)
            ((Polynomial.C a * Polynomial.X ^ (n + 1)).eval₂ (C : k →+* affineTwoRing k) t) =
          (Polynomial.derivative f).eval₂ (C : k →+* affineTwoRing k) t * t +
            f.eval₂ (C : k →+* affineTwoRing k) t := by
      have ih' : pderiv (ULift.up 0) (f.eval₂ (C : k →+* affineTwoRing k) t) =
          (Polynomial.derivative f).eval₂ (C : k →+* affineTwoRing k) t := by
        simpa [f] using ih
      rw [hdecomp, Polynomial.eval₂_mul, Polynomial.eval₂_X, Derivation.leibniz, ih', ht]
      simp only [smul_eq_mul, mul_one]
      ring
    have hR :
        (Polynomial.derivative (Polynomial.C a * Polynomial.X ^ (n + 1))).eval₂
            (C : k →+* affineTwoRing k) t =
          (Polynomial.derivative f).eval₂ (C : k →+* affineTwoRing k) t * t +
            f.eval₂ (C : k →+* affineTwoRing k) t := by
      have hder : Polynomial.derivative (Polynomial.C a * Polynomial.X ^ (n + 1)) =
          Polynomial.derivative f * Polynomial.X + f := by
        rw [hdecomp, Polynomial.derivative_mul, Polynomial.derivative_X, mul_one]
      rw [hder, Polynomial.eval₂_add, Polynomial.eval₂_mul, Polynomial.eval₂_X]
    exact hL.trans hR.symm

theorem pderiv_s_liftTsenSection {k : Type u} [CommRing k]
    (v : Fin 3 → Polynomial k) (a : Fin 3) :
    pderiv (ULift.up 1) (liftTsenSection v a) = 0 :=
  pderiv_s_liftPolyT (v a)

/-- Free direction `e₁ = (0,1,0)`. -/
def stereoE1 (R : Type u) [CommRing R] : Fin 3 → R := ![0, 1, 0]

theorem pderiv_s_affineTwoStereoDir {k : Type u} [CommRing k] (a : Fin 3) :
    pderiv (ULift.up 1) (affineTwoStereoDir (k := k) a) =
      stereoE1 (affineTwoRing k) a := by
  fin_cases a <;> simp [affineTwoStereoDir, stereoE1, affineTwoCoord1, pderiv_X, pderiv_C]

/-! ### Polar discriminant transport -/

/-- Polar matrix of the specialized conic is the coefficient-wise lift of the polynomial one. -/
theorem polarMatrix_specializedConicPullback {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    polarMatrix (specializedConicPullback F) =
      (polarMatrix (coordinateLineSpecializedConicPoly F)).map liftPolyTHom := by
  refine Matrix.ext fun i j => ?_
  simp only [polarMatrix_apply, Matrix.map_apply]
  let pi : Fin 3 → Polynomial k := fun b => if b = i then (1 : Polynomial k) else 0
  let pj : Fin 3 → Polynomial k := fun b => if b = j then (1 : Polynomial k) else 0
  let qi : Fin 3 → affineTwoRing k := fun b => if b = i then (1 : affineTwoRing k) else 0
  let qj : Fin 3 → affineTwoRing k := fun b => if b = j then (1 : affineTwoRing k) else 0
  have hqi : qi = fun b => liftPolyTHom (pi b) := by
    funext b; by_cases h : b = i <;> simp [qi, pi, h, map_one, map_zero]
  have hqj : qj = fun b => liftPolyTHom (pj b) := by
    funext b; by_cases h : b = j <;> simp [qj, pj, h, map_one, map_zero]
  have hpi : pi = Pi.single i (1 : Polynomial k) := by
    funext b; by_cases h : b = i
    · simp [pi, h, Pi.single_eq_same]
    · simp [pi, h, Pi.single_eq_of_ne (Ne.symm h)]
  have hpj : pj = Pi.single j (1 : Polynomial k) := by
    funext b; by_cases h : b = j
    · simp [pj, h, Pi.single_eq_same]
    · simp [pj, h, Pi.single_eq_of_ne (Ne.symm h)]
  have hqi' : qi = Pi.single i (1 : affineTwoRing k) := by
    funext b; by_cases h : b = i
    · simp [qi, h, Pi.single_eq_same]
    · simp [qi, h, Pi.single_eq_of_ne (Ne.symm h)]
  have hqj' : qj = Pi.single j (1 : affineTwoRing k) := by
    funext b; by_cases h : b = j
    · simp [qj, h, Pi.single_eq_same]
    · simp [qj, h, Pi.single_eq_of_ne (Ne.symm h)]
  have hmap := polarEval_map liftPolyTHom (coordinateLineSpecializedConicPoly F) pi pj
  rw [← specializedConicPullback_eq_map_eval₂, ← hqi', ← hqj', hqi, hqj, hmap, hpi, hpj]

theorem det_polarMatrix_specializedConicPullback {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    (polarMatrix (specializedConicPullback F)).det =
      liftPolyTHom (coordinateLineConicDiscriminant F) := by
  rw [polarMatrix_specializedConicPullback]
  have hmap :
      (polarMatrix (coordinateLineSpecializedConicPoly F)).map liftPolyTHom =
        liftPolyTHom.mapMatrix (polarMatrix (coordinateLineSpecializedConicPoly F)) := by
    ext; rfl
  rw [hmap, ← RingHom.map_det, coordinateLineConicDiscriminant]

/-- Smoothness forces the specialized polar discriminant to be nonzero in `k[t,s]`. -/
theorem det_polarMatrix_specializedConicPullback_ne_zero_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    (polarMatrix (specializedConicPullback F)).det ≠ 0 := by
  rw [det_polarMatrix_specializedConicPullback]
  intro h
  exact coordinateLineConicDiscriminant_ne_zero_of_smooth F hF hF0
    (liftPolyTHom_injective (by simpa using h))

/-! ### Gram identity -/

/-- `det(V M Vᵀ) = det(M) · det(V)²`. -/
theorem det_mul_mul_transpose_fin3 {R : Type u} [CommRing R]
    (M V : Matrix (Fin 3) (Fin 3) R) :
    (V * M * V.transpose).det = M.det * V.det ^ 2 := by
  calc (V * M * V.transpose).det
      = V.det * M.det * V.transpose.det := by rw [Matrix.det_mul, Matrix.det_mul]
    _ = V.det * M.det * V.det := by rw [Matrix.det_transpose]
    _ = M.det * V.det ^ 2 := by ring

/-- The polar matrix is symmetric. -/
theorem polarMatrix_isSymm {R : Type u} [CommRing R] (Q : MvPolynomial (Fin 3) R) :
    (polarMatrix Q).IsSymm := by
  ext i j
  simp only [Matrix.IsSymm, polarMatrix_apply, Matrix.transpose_apply]
  exact polarEval_comm Q _ _

/-- Polar Gram matrix of the three rows of `V` equals `V * polarMatrix Q * Vᵀ`.

This is the matrix form of bilinearity of the polar form: `B(u,w) = uᵀ M w` with
`M = polarMatrix Q` (symmetric by `polarMatrix_isSymm`). -/
theorem polar_gram_matrix_eq {R : Type u} [CommRing R]
    (Q : MvPolynomial (Fin 3) R) (hQ : Q.IsHomogeneous 2)
    (V : Matrix (Fin 3) (Fin 3) R) :
    Matrix.of (fun i j : Fin 3 => polarEval Q (fun a => V i a) (fun a => V j a)) =
      V * polarMatrix Q * V.transpose := by
  ext i j
  have hbasis (u w : Fin 3 → R) :
      polarEval Q u w = ∑ b : Fin 3, w b * (polarMatrix Q).mulVec u b := by
    rw [polarEval_eq_sum_basis hQ u w]
    exact Finset.sum_congr rfl fun b _ => by rw [polarEval_basis_eq_mulVec hQ u b]
  have hsym (a b : Fin 3) : polarMatrix Q a b = polarMatrix Q b a := by
    simpa [polarMatrix_apply] using polarEval_comm Q (Pi.single a 1) (Pi.single b 1)
  have hL :
      polarEval Q (fun a => V i a) (fun a => V j a) =
        ∑ b : Fin 3, ∑ a : Fin 3, V i a * polarMatrix Q b a * V j b := by
    rw [hbasis]
    simp only [Matrix.mulVec, dotProduct, Finset.mul_sum, mul_assoc]
    refine Finset.sum_congr rfl fun b _ => Finset.sum_congr rfl fun a _ => ?_
    ring
  have hR :
      (V * polarMatrix Q * V.transpose) i j =
        ∑ b : Fin 3, ∑ a : Fin 3, V i a * polarMatrix Q b a * V j b := by
    calc (V * polarMatrix Q * V.transpose) i j
        = ∑ k : Fin 3, (∑ l : Fin 3, V i l * polarMatrix Q l k) * V j k := by
            simp only [Matrix.mul_apply, Matrix.transpose_apply]
      _ = ∑ k : Fin 3, ∑ l : Fin 3, V i l * polarMatrix Q l k * V j k := by
            simp only [Finset.sum_mul, mul_assoc]
      _ = ∑ k : Fin 3, ∑ l : Fin 3, V i l * polarMatrix Q k l * V j k := by
            refine Finset.sum_congr rfl fun k _ => Finset.sum_congr rfl fun l _ => ?_
            rw [hsym]
      _ = ∑ b : Fin 3, ∑ a : Fin 3, V i a * polarMatrix Q b a * V j b := rfl
  rw [Matrix.of_apply, hL, hR]

/-- 3×3 determinant with zeros at `(0,0)`, `(0,2)`, `(2,0)` and `G 1 0 = G 0 1`. -/
theorem det_fin_three_gram_pattern {R : Type u} [CommRing R]
    (G : Matrix (Fin 3) (Fin 3) R)
    (h00 : G 0 0 = 0) (h02 : G 0 2 = 0) (h20 : G 2 0 = 0) (h10 : G 1 0 = G 0 1) :
    G.det = -(G 0 1) ^ 2 * G 2 2 := by
  simp [Matrix.det_fin_three, h00, h02, h20, h10]
  ring

/-- Differentiating `Q(Y)=0` in `s` yields `B(Y, ∂Y/∂s)=0` (coefficients ignore `s`). -/
theorem polarEval_stereo_pderiv_s_eq_zero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    polarEval (specializedConicPullback F) (stereoFirstCoords F v)
      (fun a => pderiv (ULift.up 1) (stereoFirstCoords F v a)) = 0 := by
  set Q := specializedConicPullback F
  set Y := stereoFirstCoords F v
  set Ys : Fin 3 → affineTwoRing k := fun a => pderiv (ULift.up 1) (Y a)
  have hQ : Q.IsHomogeneous 2 := specializedConicPullback_isHomogeneous F hF
  have hY0 : eval Y Q = 0 := eval_stereoFirstCoords_specializedConic F hF v hv
  have hcoeff (i j : Fin 3) :
      pderiv (ULift.up 1) (ternaryQuadraticCoeff Q i j) = 0 := by
    rw [ternaryQuadraticCoeff_specializedConicPullback]
    exact pderiv_s_liftPolyT _
  have heval := eval_eq_ternaryQuadraticCoeff_sum hQ Y
  have hder :
      pderiv (ULift.up 1) (eval Y Q) =
        ∑ i : Fin 3, ∑ j : Fin 3,
          ternaryQuadraticCoeff Q i j * (Ys i * Y j + Y i * Ys j) := by
    rw [heval]
    simp only [map_sum, Derivation.leibniz, smul_eq_mul]
    refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
    have hc := hcoeff i j
    simp only [hc, zero_mul, zero_add, Ys]
    ring
  have hpol := polarEval_eq_coeff_sum Q hQ Y Ys
  have hzero : pderiv (ULift.up 1) (eval Y Q) = 0 := by simp [hY0]
  convert hzero
  rw [hpol, hder]
  refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
  ring

/-- If `∂Y/∂s = μ · Y` then the polar of the Tsen section against the stereo direction vanishes. -/
theorem false_of_pderiv_s_eq_smul
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (_hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv2 : v 2 ≠ 0)
    (hnd : polarEval (specializedConicPullback F) (liftTsenSection v) affineTwoStereoDir ≠ 0)
    (μ : affineTwoRing k)
    (hμ : (fun a => pderiv (ULift.up 1) (stereoFirstCoords F v a)) =
        fun a => μ * stereoFirstCoords F v a) :
    False := by
  let Q := specializedConicPullback F
  let p := liftTsenSection v
  let w := affineTwoStereoDir (k := k)
  let α := eval w Q
  let β := polarEval Q p w
  let Y := stereoFirstCoords F v
  have hβne : β ≠ 0 := hnd
  have hp2 : p 2 ≠ 0 := liftTsenSection_two_ne_zero v hv2
  have hY' (a : Fin 3) : Y a = α * p a - β * w a := by
    simp only [Y, α, β, p, w, Q, stereoFirstCoords, stereoAlg]
  have hYs (a : Fin 3) :
      pderiv (ULift.up 1) (Y a) =
        pderiv (ULift.up 1) α * p a - pderiv (ULift.up 1) β * w a
          - β * stereoE1 (affineTwoRing k) a := by
    rw [hY' a, map_sub]
    have hp0 : pderiv (ULift.up 1) (p a) = 0 := pderiv_s_liftTsenSection v a
    have hw0 : pderiv (ULift.up 1) (w a) = stereoE1 (affineTwoRing k) a :=
      pderiv_s_affineTwoStereoDir a
    rw [Derivation.leibniz, Derivation.leibniz, hp0, hw0]
    simp only [smul_eq_mul, mul_zero, add_zero]
    ring
  let A := pderiv (ULift.up 1) α - μ * α
  let B' := -(pderiv (ULift.up 1) β) + μ * β
  have hspan (a : Fin 3) :
      β * stereoE1 (affineTwoRing k) a = A * p a + B' * w a := by
    have hi : pderiv (ULift.up 1) (Y a) = μ * Y a := congr_fun hμ a
    rw [hYs a, hY' a] at hi
    have hre :
        β * stereoE1 (affineTwoRing k) a =
          pderiv (ULift.up 1) α * p a - pderiv (ULift.up 1) β * w a
            - μ * (α * p a - β * w a) := by
      linear_combination -hi
    convert hre using 1
    change _ = pderiv (ULift.up 1) α * p a - pderiv (ULift.up 1) β * w a
        - μ * (α * p a - β * w a)
    simp only [A, B']; ring
  have hA : A = 0 := by
    have h2 := hspan 2
    have he2 : stereoE1 (affineTwoRing k) 2 = 0 := by simp [stereoE1]
    have hw2 : w 2 = 0 := by simp [w, affineTwoStereoDir]
    rw [he2, hw2, mul_zero, mul_zero, add_zero] at h2
    exact (mul_eq_zero.mp h2.symm).resolve_right hp2
  have hB : B' = 0 := by
    have h0 := hspan 0
    have he0 : stereoE1 (affineTwoRing k) 0 = 0 := by simp [stereoE1]
    have hw0 : w 0 = 1 := by simp [w, affineTwoStereoDir]
    rw [he0, hw0, hA, mul_zero, zero_mul, zero_add] at h0
    simpa using h0.symm
  have hβ0 : β = 0 := by
    have h1 := hspan 1
    have he1 : stereoE1 (affineTwoRing k) 1 = 1 := by simp [stereoE1]
    rw [he1, hA, hB, mul_one, zero_mul] at h1
    simpa [zero_add, mul_zero] using h1
  exact hβne hβ0

/-! ### Null-cone and immersion -/

/-- Polar evaluation agrees with the matrix bilinear form `toBilin'`. -/
theorem polarEval_eq_toBilin' {R : Type u} [Field R]
    (Q : MvPolynomial (Fin 3) R) (hQ : Q.IsHomogeneous 2) (u w : Fin 3 → R) :
    polarEval Q u w = (polarMatrix Q).toBilin' u w := by
  have hsym (a b : Fin 3) : polarMatrix Q a b = polarMatrix Q b a := by
    simpa [polarMatrix_apply] using polarEval_comm Q (Pi.single a 1) (Pi.single b 1)
  have h1 : polarEval Q u w =
      ∑ b : Fin 3, (polarMatrix Q).mulVec u b * w b := by
    rw [polarEval_eq_sum_basis hQ u w]
    exact Finset.sum_congr rfl fun b _ => by
      rw [polarEval_basis_eq_mulVec hQ u b, mul_comm]
  rw [h1, Matrix.toBilin'_apply']
  simp only [dotProduct, mulVec, Finset.sum_mul, Finset.mul_sum, mul_assoc]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
  rw [hsym j i]
  ring

/-- Null-cone: two isotropic conjugate vectors for a rank-3 nondegenerate form are proportional. -/
theorem exists_smul_of_totally_isotropic {R : Type u} [Field R]
    (Q : MvPolynomial (Fin 3) R) (hQ : Q.IsHomogeneous 2)
    (hdisc : (polarMatrix Q).det ≠ 0)
    (Y Z : Fin 3 → R)
    (hYY : polarEval Q Y Y = 0)
    (hYZ : polarEval Q Y Z = 0)
    (hZZ : polarEval Q Z Z = 0)
    (hY0 : Y ≠ 0) :
    ∃ μ : R, Z = fun i => μ * Y i := by
  classical
  let Bform : BilinForm R (Fin 3 → R) := (polarMatrix Q).toBilin'
  have hBeq (u w : Fin 3 → R) : Bform u w = polarEval Q u w :=
    (polarEval_eq_toBilin' Q hQ u w).symm
  have hBnd : Bform.Nondegenerate := by
    rw [Matrix.nondegenerate_toBilin'_iff, Matrix.nondegenerate_iff_det_ne_zero]
    exact hdisc
  let W : Submodule R (Fin 3 → R) := span R ({Y, Z} : Set (Fin 3 → R))
  have hY_orth : Y ∈ Bform.orthogonal W := by
    rw [BilinForm.mem_orthogonal_iff]
    intro n hn
    induction hn using span_induction with
    | mem v hv =>
      simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hv
      rcases hv with (rfl | rfl)
      · rw [hBeq]; exact hYY
      · rw [hBeq, polarEval_comm]; exact hYZ
    | zero => simp
    | add a b _ _ ha hb => simp [map_add, ha, hb]
    | smul c a _ ha => simp [map_smul, ha]
  have hZ_orth : Z ∈ Bform.orthogonal W := by
    rw [BilinForm.mem_orthogonal_iff]
    intro n hn
    induction hn using span_induction with
    | mem v hv =>
      simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hv
      rcases hv with (rfl | rfl)
      · rw [hBeq]; exact hYZ
      · rw [hBeq]; exact hZZ
    | zero => simp
    | add a b _ _ ha hb => simp [map_add, ha, hb]
    | smul c a _ ha => simp [map_smul, ha]
  have htot : W ≤ Bform.orthogonal W := by
    intro x hx
    induction hx using span_induction with
    | mem v hv =>
      simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hv
      rcases hv with (rfl | rfl)
      · exact hY_orth
      · exact hZ_orth
    | zero => exact zero_mem _
    | add a b _ _ ha hb => exact add_mem ha hb
    | smul c a _ ha => exact smul_mem _ c ha
  haveI : FiniteDimensional R (Fin 3 → R) := inferInstance
  have hfin := BilinForm.finrank_orthogonal hBnd W
  have hle : finrank R W ≤ finrank R (Bform.orthogonal W) := finrank_mono htot
  have h3 : finrank R (Fin 3 → R) = 3 := by
    rw [finrank_fintype_fun_eq_card, Fintype.card_fin]
  have hbound : finrank R W ≤ 3 - finrank R W := by
    rwa [hfin, h3] at hle
  have hdim : finrank R W ≤ 1 := by omega
  have hYmem : Y ∈ W := subset_span (by simp)
  have hZmem : Z ∈ W := subset_span (by simp)
  have hge : 1 ≤ finrank R W := by
    refine finrank_pos_iff_exists_ne_zero.mpr ?_
    refine ⟨⟨Y, hYmem⟩, ?_⟩
    intro h
    exact hY0 (congrArg Subtype.val h)
  have h1 : finrank R W = 1 := le_antisymm hdim hge
  have hW : W = R ∙ Y := by
    have hYle : (R ∙ Y) ≤ W := (span_singleton_le_iff_mem Y W).mpr hYmem
    have hranks : finrank R (R ∙ Y) = finrank R W := by
      rw [finrank_span_singleton hY0, h1]
    exact (eq_of_le_of_finrank_eq hYle hranks).symm
  have hZspan : Z ∈ R ∙ Y := by rw [← hW]; exact hZmem
  obtain ⟨μ, hμ⟩ := mem_span_singleton.mp hZspan
  refine ⟨μ, ?_⟩
  ext i
  simpa [Pi.smul_apply, smul_eq_mul] using (congr_fun hμ i).symm

/-- Polar matrix commutes with coefficient ring maps (same universe). -/
theorem polarMatrix_map {R S : Type u} [CommRing R] [CommRing S]
    (φ : R →+* S) (Q : MvPolynomial (Fin 3) R) :
    polarMatrix (map φ Q) = (polarMatrix Q).map φ := by
  ext i j
  simp only [polarMatrix_apply, Matrix.map_apply]
  have hsingle (a : Fin 3) :
      (fun b : Fin 3 => φ ((Pi.single a (1 : R) : Fin 3 → R) b)) =
        (Pi.single a (1 : S) : Fin 3 → S) := by
    ext b
    by_cases h : b = a
    · subst h; simp [Pi.single_eq_same, map_one]
    · simp [Pi.single_eq_of_ne h, map_zero]
  rw [← hsingle i, ← hsingle j]
  exact polarEval_map φ Q (Pi.single i (1 : R)) (Pi.single j (1 : R))

/-- Scaled form of `false_of_pderiv_s_eq_smul`: `d · Ys = n · Y` with `d ≠ 0` is impossible. -/
theorem false_of_pderiv_s_eq_smul_div {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (_hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv2 : v 2 ≠ 0)
    (hnd : polarEval (specializedConicPullback F) (liftTsenSection v) affineTwoStereoDir ≠ 0)
    (d n : affineTwoRing k) (hd : d ≠ 0)
    (hμ : (fun a => d * pderiv (ULift.up 1) (stereoFirstCoords F v a)) =
        fun a => n * stereoFirstCoords F v a) :
    False := by
  let Q := specializedConicPullback F
  let p := liftTsenSection v
  let w := affineTwoStereoDir (k := k)
  let α := eval w Q
  let β := polarEval Q p w
  let Y := stereoFirstCoords F v
  have hβne : β ≠ 0 := hnd
  have hp2 : p 2 ≠ 0 := liftTsenSection_two_ne_zero v hv2
  have hY' (a : Fin 3) : Y a = α * p a - β * w a := by
    simp only [Y, α, β, p, w, Q, stereoFirstCoords, stereoAlg]
  have hYs (a : Fin 3) :
      pderiv (ULift.up 1) (Y a) =
        pderiv (ULift.up 1) α * p a - pderiv (ULift.up 1) β * w a
          - β * stereoE1 (affineTwoRing k) a := by
    rw [hY' a, map_sub]
    have hp0 : pderiv (ULift.up 1) (p a) = 0 := pderiv_s_liftTsenSection v a
    have hw0 : pderiv (ULift.up 1) (w a) = stereoE1 (affineTwoRing k) a :=
      pderiv_s_affineTwoStereoDir a
    rw [Derivation.leibniz, Derivation.leibniz, hp0, hw0]
    simp only [smul_eq_mul, mul_zero, add_zero]
    ring
  let A := d * pderiv (ULift.up 1) α - n * α
  let B' := -(d * pderiv (ULift.up 1) β) + n * β
  have hspan (a : Fin 3) :
      d * β * stereoE1 (affineTwoRing k) a = A * p a + B' * w a := by
    have hi : d * pderiv (ULift.up 1) (Y a) = n * Y a := congr_fun hμ a
    rw [hYs a, hY' a] at hi
    have hre :
        d * β * stereoE1 (affineTwoRing k) a =
          d * pderiv (ULift.up 1) α * p a - d * pderiv (ULift.up 1) β * w a
            - n * (α * p a - β * w a) := by
      linear_combination -hi
    convert hre using 1
    simp only [A, B']; ring
  have hA : A = 0 := by
    have h2 := hspan 2
    have he2 : stereoE1 (affineTwoRing k) 2 = 0 := by simp [stereoE1]
    have hw2 : w 2 = 0 := by simp [w, affineTwoStereoDir]
    rw [he2, hw2, mul_zero, mul_zero, add_zero] at h2
    exact (mul_eq_zero.mp h2.symm).resolve_right hp2
  have hB : B' = 0 := by
    have h0 := hspan 0
    have he0 : stereoE1 (affineTwoRing k) 0 = 0 := by simp [stereoE1]
    have hw0 : w 0 = 1 := by simp [w, affineTwoStereoDir]
    rw [he0, hw0, hA, mul_zero, zero_mul, zero_add] at h0
    simpa using h0.symm
  have : d * β = 0 := by
    have h1 := hspan 1
    have he1 : stereoE1 (affineTwoRing k) 1 = 1 := by simp [stereoE1]
    rw [he1, hA, hB, mul_one, zero_mul] at h1
    simpa [zero_add, mul_zero] using h1
  rcases mul_eq_zero.mp this with hd0 | hβ0
  · exact hd hd0
  · exact hβne hβ0

/-- Stereographic first coordinates are nonzero under nondegeneracy. -/
theorem stereoFirstCoords_ne_zero {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (_hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k) (hv2 : v 2 ≠ 0)
    (hnd : polarEval (specializedConicPullback F) (liftTsenSection v) affineTwoStereoDir ≠ 0) :
    stereoFirstCoords F v ≠ 0 := by
  intro hY0
  let Q := specializedConicPullback F
  let p := liftTsenSection v
  let w := affineTwoStereoDir (k := k)
  let α := eval w Q
  let β := polarEval Q p w
  have hY' (a : Fin 3) : stereoFirstCoords F v a = α * p a - β * w a := by
    simp only [α, β, p, w, Q, stereoFirstCoords, stereoAlg]
  have hp2 : p 2 ≠ 0 := liftTsenSection_two_ne_zero v hv2
  have h2 : α * p 2 = 0 := by
    have := congr_fun hY0 2
    simp only [Pi.zero_apply] at this
    rw [hY' 2] at this
    have hw2 : w 2 = 0 := by simp [w, affineTwoStereoDir]
    simpa [hw2, mul_zero, sub_zero] using this
  have hα : α = 0 := (mul_eq_zero.mp h2).resolve_right hp2
  have hβ : β = 0 := by
    have := congr_fun hY0 0
    simp only [Pi.zero_apply] at this
    rw [hY' 0, hα] at this
    have hw0 : w 0 = 1 := by simp [w, affineTwoStereoDir]
    simpa [zero_mul, hw0, zero_sub, neg_eq_zero] using this
  exact hnd hβ

/-! ### Motion: chain rule and nonvanishing of `B(Y, ∂Y/∂t)` -/

/-- Coefficient-wise `t`-derivative of the specialized conic, as a ternary quadratic. -/
noncomputable def specializedConicPullback_dt {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial (Fin 3) (affineTwoRing k) :=
  ∑ i : Fin 3, ∑ j : Fin 3,
    C (pderiv (ULift.up 0) (ternaryQuadraticCoeff (specializedConicPullback F) i j)) *
      (X i * X j)

theorem eval_specializedConicPullback_dt {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (y : Fin 3 → affineTwoRing k) :
    eval y (specializedConicPullback_dt F) =
      ∑ i : Fin 3, ∑ j : Fin 3,
        pderiv (ULift.up 0) (ternaryQuadraticCoeff (specializedConicPullback F) i j) *
          y i * y j := by
  simp only [specializedConicPullback_dt, eval_sum, eval_mul, eval_C, eval_X]
  refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
  ring

/-- Chain rule: differentiating `Q(Y)=0` in `t` yields `B(Y,Yt) = -(∂t Q)(Y)`. -/
theorem polarEval_stereo_pderiv_t_eq_neg_eval_dt {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) :
    polarEval (specializedConicPullback F) (stereoFirstCoords F v)
        (fun a => pderiv (ULift.up 0) (stereoFirstCoords F v a)) =
      -eval (stereoFirstCoords F v) (specializedConicPullback_dt F) := by
  set Q := specializedConicPullback F
  set Y := stereoFirstCoords F v
  set Yt : Fin 3 → affineTwoRing k := fun a => pderiv (ULift.up 0) (Y a)
  have hQ : Q.IsHomogeneous 2 := specializedConicPullback_isHomogeneous F hF
  have hY0 : eval Y Q = 0 := eval_stereoFirstCoords_specializedConic F hF v hv
  have heval := eval_eq_ternaryQuadraticCoeff_sum hQ Y
  have hder :
      pderiv (ULift.up 0) (eval Y Q) =
        ∑ i : Fin 3, ∑ j : Fin 3,
            pderiv (ULift.up 0) (ternaryQuadraticCoeff Q i j) * Y i * Y j +
          ∑ i : Fin 3, ∑ j : Fin 3,
            ternaryQuadraticCoeff Q i j * (Yt i * Y j + Y i * Yt j) := by
    rw [heval]
    simp only [map_sum, Derivation.leibniz, smul_eq_mul]
    have hterm (i j : Fin 3) :
        ternaryQuadraticCoeff Q i j * Y i * pderiv (ULift.up 0) (Y j) +
            Y j * (ternaryQuadraticCoeff Q i j * pderiv (ULift.up 0) (Y i) +
              Y i * pderiv (ULift.up 0) (ternaryQuadraticCoeff Q i j)) =
          pderiv (ULift.up 0) (ternaryQuadraticCoeff Q i j) * Y i * Y j +
            ternaryQuadraticCoeff Q i j * (Yt i * Y j + Y i * Yt j) := by
      simp only [Yt]
      ring
    rw [Finset.sum_congr rfl (fun i _ => Finset.sum_congr rfl fun j _ => hterm i j)]
    simp only [Finset.sum_add_distrib]
  have hpol := polarEval_eq_coeff_sum Q hQ Y Yt
  have hedt : eval Y (specializedConicPullback_dt F) =
      ∑ i : Fin 3, ∑ j : Fin 3,
        pderiv (ULift.up 0) (ternaryQuadraticCoeff Q i j) * Y i * Y j := by
    simpa [Q] using eval_specializedConicPullback_dt F Y
  have hpol' :
      polarEval Q Y Yt =
        ∑ i : Fin 3, ∑ j : Fin 3,
          ternaryQuadraticCoeff Q i j * (Yt i * Y j + Y i * Yt j) := by
    convert hpol using 1
    refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
    ring
  have hzero : pderiv (ULift.up 0) (eval Y Q) = 0 := by simp [hY0]
  have hadd :
      eval Y (specializedConicPullback_dt F) + polarEval Q Y Yt = 0 := by
    rw [hedt, hpol', ← hder, hzero]
  rw [eq_neg_iff_add_eq_zero, add_comm]
  exact hadd

/-- Ternary quadratic over `k[t]` with coefficient-wise derivative of the specialized conic. -/
noncomputable def coordinateLineSpecializedConicPoly_dt {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial (Fin 3) (Polynomial k) :=
  ∑ i : Fin 3, ∑ j : Fin 3,
    C (Polynomial.derivative (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j)) *
      (X i * X j)

/-- The `t`-derivative form on the affine plane is the pure-`t` lift of the univariate derivative
form. -/
theorem specializedConicPullback_dt_eq_map
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    specializedConicPullback_dt F =
      map (liftPolyTHom (k := k)) (coordinateLineSpecializedConicPoly_dt F) := by
  have hc (i j : Fin 3) :
      pderiv (ULift.up 0) (ternaryQuadraticCoeff (specializedConicPullback F) i j) =
        liftPolyTHom (Polynomial.derivative
          (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j)) := by
    rw [ternaryQuadraticCoeff_specializedConicPullback, pderiv_t_liftPolyT, liftPolyT_eq_hom]
  simp only [specializedConicPullback_dt, coordinateLineSpecializedConicPoly_dt, map_sum, map_mul,
    map_C, map_X]
  refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
  rw [hc]

/-! ### Motion packaging helpers -/

/-- Specialized `t`-derivative of the coordinate-line conic, as a form over `k`. -/
noncomputable def coordinateLineSpecializedConic_dt {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (t : k) :
    MvPolynomial (Fin 3) k :=
  ∑ i : Fin 3, ∑ j : Fin 3,
    C (Polynomial.eval t
      (Polynomial.derivative
        (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j))) *
      (X i * X j)

theorem coordinateLineSpecializedConic_dt_isHomogeneous {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (t : k) :
    (coordinateLineSpecializedConic_dt F t).IsHomogeneous 2 := by
  refine IsHomogeneous.sum _ _ _ fun i _ => IsHomogeneous.sum _ _ _ fun j _ => ?_
  exact (isHomogeneous_C _ _).mul ((isHomogeneous_X _ i).mul (isHomogeneous_X _ j))

theorem map_evalAffineTwoPoint_specializedConicPullback_dt {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (t s : k) :
    map (evalAffineTwoPoint t s) (specializedConicPullback_dt F) =
      coordinateLineSpecializedConic_dt F t := by
  rw [specializedConicPullback_dt_eq_map]
  simp only [coordinateLineSpecializedConic_dt, coordinateLineSpecializedConicPoly_dt,
    map_sum, map_mul, map_C, map_X]
  refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
  congr 1
  change C (evalAffineTwoPoint t s
      (liftPolyTHom (Polynomial.derivative
        (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j)))) =
    C (Polynomial.eval t
      (Polynomial.derivative
        (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j)))
  congr 1
  simpa [liftPolyT_eq_hom] using
    evalAffineTwoPoint_liftPolyT
      (Polynomial.derivative
        (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j)) t s

/-- Ring-hom commutes past evaluation (same pattern as `map_stereoAlg`). -/
theorem eval_comp_map {R S : Type u} [CommRing R] [CommRing S] (φ : R →+* S)
    (z : Fin 3 → R) (Q : MvPolynomial (Fin 3) R) :
    φ (eval z Q) = eval (fun j => φ (z j)) (map φ Q) := by
  rw [eval_map]
  convert (eval₂_comp φ z Q)
  rfl

/-- Bivariate `Qt(Y)=0` specializes to classical stereo vanishing of `Qt(t)`. -/
theorem eval_stereoAlg_dt_eq_zero_of_eval_Qt_Y {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k)
    (hQtY : eval (stereoFirstCoords F v) (specializedConicPullback_dt F) = 0)
    (t s : k) :
    eval (stereoAlg (coordinateLineSpecializedConic F t)
        (evalPolySection v t) (stereographicDirection s))
      (coordinateLineSpecializedConic_dt F t) = 0 := by
  have h0 : evalAffineTwoPoint t s
      (eval (stereoFirstCoords F v) (specializedConicPullback_dt F)) = 0 := by
    rw [hQtY, map_zero]
  have hcomm := eval_comp_map (evalAffineTwoPoint t s)
    (stereoFirstCoords F v) (specializedConicPullback_dt F)
  have h0' :
      eval (fun i => evalAffineTwoPoint t s (stereoFirstCoords F v i))
        (map (evalAffineTwoPoint t s) (specializedConicPullback_dt F)) = 0 := by
    rwa [← hcomm]
  rw [map_evalAffineTwoPoint_specializedConicPullback_dt] at h0'
  have hY : (fun i => evalAffineTwoPoint t s (stereoFirstCoords F v i)) =
      stereoAlg (coordinateLineSpecializedConic F t)
        (evalPolySection v t) (stereographicDirection s) := by
    simpa [residualImageXCoords] using
      evalAffineTwoPoint_residualImageXCoords_eq_stereoAlg F v t s
  rwa [hY] at h0'

theorem eval_stereoAlg_inf_eq_zero {k : Type u} [Field k] [Infinite k]
    (Q R : MvPolynomial (Fin 3) k) (hQ : Q.IsHomogeneous 2) (hR : R.IsHomogeneous 2)
    (p : Fin 3 → k)
    (hst : ∀ s : k, eval (stereoAlg Q p (stereographicDirection s)) R = 0) :
    eval (stereoAlg Q p ![0, 1, (0 : k)]) R = 0 := by
  classical
  have hid (c : k) (hc : c ≠ 0) :
      eval (stereoAlg Q p ![c, 1, (0 : k)]) R = 0 := by
    have hw : (![c, 1, (0 : k)] : Fin 3 → k) = c • stereographicDirection (c⁻¹) := by
      funext i; fin_cases i <;> simp [stereographicDirection, Pi.smul_apply, smul_eq_mul, hc]
    rw [hw, stereoAlg_smul_right Q hQ p (stereographicDirection c⁻¹) c,
      eval_smul_of_isHomogeneous_two' R hR]
    simp only [hst c⁻¹, mul_zero]
  let Q' : MvPolynomial (Fin 3) (Polynomial k) :=
    map (Polynomial.C : k →+* Polynomial k) Q
  let R' : MvPolynomial (Fin 3) (Polynomial k) :=
    map (Polynomial.C : k →+* Polynomial k) R
  let p' : Fin 3 → Polynomial k := fun i => Polynomial.C (p i)
  let w' : Fin 3 → Polynomial k := ![Polynomial.X, 1, 0]
  let univ : Polynomial k := eval (stereoAlg Q' p' w') R'
  have heval (c : k) :
      Polynomial.eval c univ = eval (stereoAlg Q p ![c, 1, (0 : k)]) R := by
    have hcomm :=
      eval_comp_map (Polynomial.evalRingHom c) (stereoAlg Q' p' w') R'
    have hL : Polynomial.eval c univ =
        eval (fun i => Polynomial.eval c (stereoAlg Q' p' w' i))
          (map (Polynomial.evalRingHom c) R') := by
      simpa [Polynomial.coe_evalRingHom] using hcomm
    rw [hL]
    have hRmap : map (Polynomial.evalRingHom c) R' = R := by
      dsimp [R']
      rw [MvPolynomial.map_map]
      have hc : (Polynomial.evalRingHom c).comp (Polynomial.C : k →+* Polynomial k) =
          RingHom.id k := by
        ext a; simp
      rw [hc, MvPolynomial.map_id]
    rw [hRmap]
    have hst' :
        (fun i => Polynomial.eval c (stereoAlg Q' p' w' i)) =
          stereoAlg Q p ![c, 1, (0 : k)] := by
      have h := map_stereoAlg (Polynomial.evalRingHom c) Q' p' w'
      have h' :
          (fun i => Polynomial.eval c (stereoAlg Q' p' w' i)) =
            stereoAlg (map (Polynomial.evalRingHom c) Q')
              (fun j => Polynomial.eval c (p' j))
              (fun j => Polynomial.eval c (w' j)) := by
        simpa [Polynomial.coe_evalRingHom] using h
      have hQmap : map (Polynomial.evalRingHom c) Q' = Q := by
        dsimp [Q']
        rw [MvPolynomial.map_map]
        have hc : (Polynomial.evalRingHom c).comp (Polynomial.C : k →+* Polynomial k) =
            RingHom.id k := by
          ext a; simp
        rw [hc, MvPolynomial.map_id]
      have hp : (fun i => Polynomial.eval c (p' i)) = p := by
        funext i; simp [p']
      have hw : (fun i => Polynomial.eval c (w' i)) =
          (![c, 1, (0 : k)] : Fin 3 → k) := by
        funext i; fin_cases i <;> simp [w']
      simpa [hQmap, hp, hw] using h'
    rw [hst']
  have huniv0 : univ = 0 := by
    by_contra hne
    have hfin : Set.Finite {c : k | univ.IsRoot c} := by
      have heq : {c : k | univ.IsRoot c} = (univ.roots.toFinset : Set k) := by
        ext c
        constructor
        · intro hc
          exact Multiset.mem_toFinset.mpr ((Polynomial.mem_roots hne).mpr hc)
        · intro hc
          exact (Polynomial.mem_roots hne).mp (Multiset.mem_toFinset.mp hc)
      rw [heq]; exact Finset.finite_toSet _
    have hsub : {c : k | c ≠ 0} ⊆ {c : k | univ.IsRoot c} := by
      intro c hc
      show univ.IsRoot c
      rw [Polynomial.IsRoot, heval]
      exact hid c hc
    have hine : Set.Infinite ({c : k | c ≠ 0} : Set k) := by
      refine Set.infinite_of_finite_compl ?_
      have : ({c : k | c ≠ 0} : Set k)ᶜ = {0} := by
        ext c; simp
      rw [this]
      exact Set.finite_singleton 0
    exact hine.not_finite (hfin.subset hsub)
  exact (heval 0).symm.trans (by simp [huniv0])



/-- Specialized disc is evaluation of the discriminant polynomial. -/
theorem det_polarMatrix_coordinateLineSpecializedConic {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (t : k) :
    (polarMatrix (coordinateLineSpecializedConic F t)).det =
      Polynomial.eval t (coordinateLineConicDiscriminant F) := by
  have hmap := map_eval_coordinateLineSpecializedConicPoly F t
  have hpol := polarMatrix_map (Polynomial.evalRingHom t)
    (coordinateLineSpecializedConicPoly F)
  rw [← hmap, hpol]
  -- `Matrix.map` agrees with `RingHom.mapMatrix` on determinants
  change ((Polynomial.evalRingHom t).mapMatrix
      (polarMatrix (coordinateLineSpecializedConicPoly F))).det =
    Polynomial.eval t (coordinateLineConicDiscriminant F)
  rw [← RingHom.map_det]
  rfl

/-- `R(p)=0` when free polar of `p` is non-constant (has a root). -/
theorem eval_eq_zero_of_free_polar_root {k : Type u} [Field k] [IsAlgClosed k]
    (Q R : MvPolynomial (Fin 3) k) (hQ : Q.IsHomogeneous 2) (hR : R.IsHomogeneous 2)
    (hdisc : (polarMatrix Q).det ≠ 0)
    (p : Fin 3 → k) (hp : eval p Q = 0) (hp2 : p 2 ≠ 0) (hp0 : p ≠ 0)
    (hst : ∀ s : k, eval (stereoAlg Q p (stereographicDirection s)) R = 0)
    (B1_ne : polarEval Q p (![0, 1, (0 : k)]) ≠ 0) :
    eval p R = 0 := by
  classical
  set B0 := polarEval Q p (![1, 0, (0 : k)])
  set B1 := polarEval Q p (![0, 1, (0 : k)])
  have hB1 : B1 ≠ 0 := B1_ne
  have hBlin (s : k) :
      polarEval Q p (stereographicDirection s) = B0 + s * B1 := by
    have hw : stereographicDirection s =
        fun i => (1 : k) * (![1, 0, (0 : k)] i) + s * (![0, 1, (0 : k)] i) := by
      funext i; fin_cases i <;> simp [stereographicDirection]
    rw [hw, polarEval_linear_right hQ]; simp [B0, B1]
  set s0 := -B0 * B1⁻¹
  have hBs0 : polarEval Q p (stereographicDirection s0) = 0 := by
    rw [hBlin s0]
    have : B0 + (-B0 * B1⁻¹) * B1 = 0 := by
      field_simp [hB1]
      ring
    simpa [s0] using this
  have hpp : polarEval Q p p = 0 := by rw [polarEval_self hQ p, hp, mul_zero]
  have hQw0 : eval (stereographicDirection s0) Q ≠ 0 := by
    intro hQ0s
    have hww0 : polarEval Q (stereographicDirection s0) (stereographicDirection s0) = 0 := by
      rw [polarEval_self hQ, hQ0s, mul_zero]
    obtain ⟨ν, hν⟩ := exists_smul_of_totally_isotropic Q hQ hdisc p
      (stereographicDirection s0) hpp hBs0 hww0 hp0
    have h2 := congr_fun hν 2
    -- stereographicDirection s0 2 = 0 = ν * p 2
    have hmul : ν * p 2 = 0 := by
      simpa [stereographicDirection] using h2.symm
    have hν0 : ν = 0 := (mul_eq_zero.mp hmul).resolve_right hp2
    have hdir0 := congr_fun hν 0
    -- stereographicDirection s0 0 = 1 and ν * p 0 = 0
    have : (1 : k) = 0 := by
      simpa [stereographicDirection, hν0] using hdir0
    exact one_ne_zero this
  have hα := hst s0
  have hvec : stereoAlg Q p (stereographicDirection s0) =
      fun i => eval (stereographicDirection s0) Q * p i := by
    funext i; simp [stereoAlg, hBs0]
  have hsm : (fun i => eval (stereographicDirection s0) Q * p i) =
      (eval (stereographicDirection s0) Q) • p := by
    funext i; simp [Pi.smul_apply, smul_eq_mul]
  rw [hvec, hsm, eval_smul_of_isHomogeneous_two' R hR] at hα
  have : (eval (stereographicDirection s0) Q) ^ 2 * eval p R = 0 := by
    convert hα using 1; ring
  exact (mul_eq_zero.mp this).resolve_left (pow_ne_zero 2 hQw0)

/-- At good `t`, `Qt(t)` vanishes on the full isotropic cone of `Q(t)`. -/
theorem eval_dt_eq_zero_of_isotropic {k : Type u} [Field k] [IsAlgClosed k]
    [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hQtY : eval (stereoFirstCoords F v) (specializedConicPullback_dt F) = 0)
    (t : k)
    (hdisc : (polarMatrix (coordinateLineSpecializedConic F t)).det ≠ 0)
    (hp2 : evalPolySection v t 2 ≠ 0)
    (x : Fin 3 → k) (hx : eval x (coordinateLineSpecializedConic F t) = 0) :
    eval x (coordinateLineSpecializedConic_dt F t) = 0 := by
  classical
  set Q0 := coordinateLineSpecializedConic F t
  set R0 := coordinateLineSpecializedConic_dt F t
  set p0 := evalPolySection v t
  have hQhom : Q0.IsHomogeneous 2 := coordinateLineSpecializedConic_isHomogeneous hF t
  have hRhom : R0.IsHomogeneous 2 := coordinateLineSpecializedConic_dt_isHomogeneous F t
  have hp : eval p0 Q0 = 0 :=
    evalPolySection_isotropic_coordinateLineSpecializedConic F hF v hv t
  have hst : ∀ s : k, eval (stereoAlg Q0 p0 (stereographicDirection s)) R0 = 0 :=
    fun s => eval_stereoAlg_dt_eq_zero_of_eval_Qt_Y F v hQtY t s
  have hinf : eval (stereoAlg Q0 p0 ![0, 1, (0 : k)]) R0 = 0 :=
    eval_stereoAlg_inf_eq_zero Q0 R0 hQhom hRhom p0 hst
  by_cases hB : polarEval Q0 p0 (fun i => x i - (x 2 * (p0 2)⁻¹) * p0 i) ≠ 0
  · exact eval_eq_zero_of_eval_stereo_of_polar_ne Q0 R0 hQhom hRhom p0 hp hp2 hst hinf x hx hB
  · push Not at hB
    set lam := x 2 * (p0 2)⁻¹
    set w : Fin 3 → k := fun i => x i - lam * p0 i
    have hw2 : w 2 = 0 := by simp only [w, lam]; field_simp [hp2]; ring
    have hxw : x = fun i => lam * p0 i + w i := by funext i; simp [w]
    have hpw : polarEval Q0 p0 w = 0 := hB
    have hpp : polarEval Q0 p0 p0 = 0 := by rw [polarEval_self hQhom p0, hp, mul_zero]
    have hQw : eval w Q0 = 0 := by
      have hexp := eval_linComb_of_isHomogeneous_two Q0 hQhom lam 1 p0 w
      simp only [one_mul, mul_one] at hexp
      have hx' : eval (fun i => lam * p0 i + w i) Q0 = 0 := by
        simpa [hxw] using hx
      have hxexp : lam * lam * eval p0 Q0 + lam * polarEval Q0 p0 w + eval w Q0 = 0 := by
        rwa [← hexp]
      simpa [hp, hpw, mul_zero, zero_add] using hxexp
    have hww : polarEval Q0 w w = 0 := by rw [polarEval_self hQhom w, hQw, mul_zero]
    have hp0ne : p0 ≠ 0 := fun h => hp2 (by simp [h])
    obtain ⟨μ, hμ⟩ :=
      exists_smul_of_totally_isotropic Q0 hQhom hdisc p0 w hpp hpw hww hp0ne
    have hμ0 : μ = 0 := by
      have h2 := congr_fun hμ 2
      -- w 2 = μ * p0 2
      have : μ * p0 2 = 0 := by simpa [hw2] using h2.symm
      exact (mul_eq_zero.mp this).resolve_right hp2
    have hw0 : w = 0 := by
      funext i
      have hi := congr_fun hμ i
      simpa [hμ0] using hi
    have hsmul : x = lam • p0 := by
      funext i
      simp only [Pi.smul_apply, smul_eq_mul, hxw, hw0, Pi.zero_apply, add_zero]
    -- Goal becomes λ² R(p)=0; prove R(p)=0.
    have hRp : eval p0 R0 = 0 := by
      set B1 := polarEval Q0 p0 (![0, 1, (0 : k)])
      by_cases hB1 : B1 ≠ 0
      · exact eval_eq_zero_of_free_polar_root Q0 R0 hQhom hRhom hdisc p0 hp hp2 hp0ne hst hB1
      · push Not at hB1
        set B0 := polarEval Q0 p0 (![1, 0, (0 : k)])
        by_cases hB0 : B0 = 0
        · -- B0 = B1 = 0 ⇒ radical nontrivial ⇒ det = 0.
          have hbasis (a : Fin 3) : polarEval Q0 p0 (Pi.single a 1) = 0 := by
            fin_cases a
            · have : (Pi.single 0 (1 : k) : Fin 3 → k) = ![1, 0, 0] := by
                funext i; fin_cases i <;> simp [Pi.single_apply]
              simpa [this, B0] using hB0
            · have : (Pi.single 1 (1 : k) : Fin 3 → k) = ![0, 1, 0] := by
                funext i; fin_cases i <;> simp [Pi.single_apply]
              simpa [this, B1] using hB1
            · have hsum :
                  ∑ a : Fin 3, p0 a * polarEval Q0 p0 (Pi.single a 1) = 0 := by
                have h := polarEval_eq_sum_basis hQhom p0 p0
                -- h : polarEval p p = sum ...
                rw [hpp] at h
                exact h.symm
              have he0 : polarEval Q0 p0 (Pi.single 0 (1 : k)) = 0 := by
                have : (Pi.single 0 (1 : k) : Fin 3 → k) = ![1, 0, 0] := by
                  funext i; fin_cases i <;> simp [Pi.single_apply]
                simpa [this, B0] using hB0
              have he1 : polarEval Q0 p0 (Pi.single 1 (1 : k)) = 0 := by
                have : (Pi.single 1 (1 : k) : Fin 3 → k) = ![0, 1, 0] := by
                  funext i; fin_cases i <;> simp [Pi.single_apply]
                simpa [this, B1] using hB1
              simp only [Fin.sum_univ_three, he0, he1, mul_zero, zero_add, add_zero] at hsum
              exact (mul_eq_zero.mp hsum).resolve_left hp2
          exact False.elim (hdisc (det_polarMatrix_eq_zero_of_polarEval_eq_zero hQhom
            hp0ne hbasis))
        · -- B0 ≠ 0, B1 = 0: use infinity free direction e₁.
          set e1 : Fin 3 → k := ![0, 1, 0]
          have hB1e : polarEval Q0 p0 e1 = 0 := hB1
          by_cases hQe1 : eval e1 Q0 ≠ 0
          · have hvec : stereoAlg Q0 p0 e1 = fun i => eval e1 Q0 * p0 i := by
              funext i; simp [stereoAlg, hB1e]
            have hsm : (fun i => eval e1 Q0 * p0 i) = (eval e1 Q0) • p0 := by
              funext i; simp [Pi.smul_apply, smul_eq_mul]
            have hinf' : eval (stereoAlg Q0 p0 e1) R0 = 0 := hinf
            rw [hvec, hsm, eval_smul_of_isHomogeneous_two' R0 hRhom] at hinf'
            have hmul : (eval e1 Q0) ^ 2 * eval p0 R0 = 0 := by
              convert hinf' using 1; ring
            exact (mul_eq_zero.mp hmul).resolve_left (pow_ne_zero 2 hQe1)
          · push Not at hQe1
            have he1ne : e1 ≠ 0 := by
              intro h; have := congr_fun h 1; simp [e1] at this
            have h11 : polarEval Q0 e1 e1 = 0 := by
              rw [polarEval_self hQhom e1, hQe1, mul_zero]
            obtain ⟨ν, hν⟩ :=
              exists_smul_of_totally_isotropic Q0 hQhom hdisc p0 e1 hpp hB1e h11 hp0ne
            have hν0 : ν = 0 := by
              have h2 := congr_fun hν 2
              have : ν * p0 2 = 0 := by
                simpa [e1, Matrix.cons_val_two, Matrix.tail_cons, Matrix.head_cons] using h2.symm
              exact (mul_eq_zero.mp this).resolve_right hp2
            have he1_0 : e1 = 0 := by
              funext i
              have hi := congr_fun hν i
              simpa [hν0] using hi
            exact (he1ne he1_0).elim
    rw [hsmul, eval_smul_of_isHomogeneous_two' R0 hRhom, hRp, mul_zero]


/-! ### Wronskian of coefficient polynomials (pure-`t` proportionality) -/

/-- Wronskian of two univariate polynomials. -/
noncomputable def polyWronskian {k : Type u} [CommRing k]
    (f g : Polynomial k) : Polynomial k :=
  Polynomial.derivative f * g - Polynomial.derivative g * f

/-- If `f'g = g'f` and `g ≠ 0`, then `f = c · g` for some constant `c`. -/
theorem exists_C_mul_of_wronskian_eq_zero {k : Type u} [Field k] [CharZero k]
    (f g : Polynomial k) (hg : g ≠ 0)
    (hw : Polynomial.derivative f * g = Polynomial.derivative g * f) :
    ∃ c : k, f = Polynomial.C c * g := by
  classical
  by_cases hf0 : f = 0
  · exact ⟨0, by simp [hf0]⟩
  let d : Polynomial k := gcd f g
  have hgd : d ≠ 0 := by
    intro h
    have := (gcd_eq_zero_iff f g).1 h
    exact hg this.2
  obtain ⟨f1, hf1⟩ : ∃ f1, f = d * f1 := by
    obtain ⟨f1, h⟩ := exists_eq_mul_right_of_dvd (gcd_dvd_left f g)
    exact ⟨f1, h⟩
  obtain ⟨g1, hg1⟩ : ∃ g1, g = d * g1 := by
    obtain ⟨g1, h⟩ := exists_eq_mul_right_of_dvd (gcd_dvd_right f g)
    exact ⟨g1, h⟩
  have hg1_ne : g1 ≠ 0 := fun h => hg (by rw [hg1, h, mul_zero])
  have hcop : IsCoprime f1 g1 := by
    have hf1' : f1 = f / d := by
      calc f1 = d * f1 / d := (mul_div_cancel_left₀ f1 hgd).symm
        _ = f / d := by rw [← hf1]
    have hg1' : g1 = g / d := by
      calc g1 = d * g1 / d := (mul_div_cancel_left₀ g1 hgd).symm
        _ = g / d := by rw [← hg1]
    have : IsCoprime (f / gcd f g) (g / gcd f g) := isCoprime_div_gcd_div_gcd hg
    simpa [hf1', hg1', d] using this
  have hf' : Polynomial.derivative f =
      Polynomial.derivative d * f1 + d * Polynomial.derivative f1 := by
    rw [hf1, Polynomial.derivative_mul]
  have hg' : Polynomial.derivative g =
      Polynomial.derivative d * g1 + d * Polynomial.derivative g1 := by
    rw [hg1, Polynomial.derivative_mul]
  have hderiv1 : Polynomial.derivative f1 * g1 = Polynomial.derivative g1 * f1 := by
    have h0 : Polynomial.derivative f * g - Polynomial.derivative g * f = 0 := by
      rw [hw, sub_self]
    have h0' :
        (Polynomial.derivative d * f1 + d * Polynomial.derivative f1) * (d * g1) -
          (Polynomial.derivative d * g1 + d * Polynomial.derivative g1) * (d * f1) = 0 := by
      rw [hf', hg', hf1, hg1] at h0
      exact h0
    have hfactor :
        (Polynomial.derivative d * f1 + d * Polynomial.derivative f1) * (d * g1) -
          (Polynomial.derivative d * g1 + d * Polynomial.derivative g1) * (d * f1) =
        (d * d) * (Polynomial.derivative f1 * g1 - Polynomial.derivative g1 * f1) := by
      ring
    rw [hfactor] at h0'
    exact sub_eq_zero.mp ((mul_eq_zero.mp h0').resolve_left (mul_ne_zero hgd hgd))
  have hg1'0 : Polynomial.derivative g1 = 0 := by
    have hmul : g1 ∣ Polynomial.derivative f1 * g1 := dvd_mul_left _ _
    have hmul' : g1 ∣ Polynomial.derivative g1 * f1 := by rwa [hderiv1] at hmul
    exact Polynomial.dvd_derivative_iff.mp (IsCoprime.dvd_of_dvd_mul_right hcop.symm hmul')
  set bg : k := Polynomial.coeff g1 0
  have hg1C : g1 = Polynomial.C bg := Polynomial.eq_C_of_derivative_eq_zero hg1'0
  have hb : bg ≠ 0 := fun h => hg1_ne (by rw [hg1C, h, map_zero])
  have hf1'0 : Polynomial.derivative f1 = 0 := by
    by_cases h : f1 = 0
    · simp [h]
    · have hmul : f1 ∣ Polynomial.derivative g1 * f1 := dvd_mul_left _ _
      have hmul' : f1 ∣ Polynomial.derivative f1 * g1 := by rwa [← hderiv1] at hmul
      exact Polynomial.dvd_derivative_iff.mp (IsCoprime.dvd_of_dvd_mul_right hcop hmul')
  set bf : k := Polynomial.coeff f1 0
  have hf1C : f1 = Polynomial.C bf := Polynomial.eq_C_of_derivative_eq_zero hf1'0
  set c : k := bf * bg⁻¹
  refine ⟨c, ?_⟩
  have hL : f = d * Polynomial.C bf := hf1.trans (congrArg (fun p => d * p) hf1C)
  have hgC : g = d * Polynomial.C bg := hg1.trans (congrArg (fun p => d * p) hg1C)
  have hR : Polynomial.C c * g = d * Polynomial.C bf := by
    rw [hgC, show c = bf * bg⁻¹ from rfl]
    have hC : Polynomial.C (bf * bg⁻¹) * Polynomial.C bg = Polynomial.C bf := by
      rw [← Polynomial.C_mul]; congr 1; rw [mul_assoc, inv_mul_cancel₀ hb, mul_one]
    calc Polynomial.C (bf * bg⁻¹) * (d * Polynomial.C bg)
        = Polynomial.C (bf * bg⁻¹) * d * Polynomial.C bg := by rw [← mul_assoc]
      _ = d * Polynomial.C (bf * bg⁻¹) * Polynomial.C bg := by
          rw [mul_comm (Polynomial.C (bf * bg⁻¹)) d]
      _ = d * (Polynomial.C (bf * bg⁻¹) * Polynomial.C bg) := by rw [mul_assoc]
      _ = d * Polynomial.C bf := by rw [hC]
  exact hL.trans hR.symm

/-- Pointwise proportionality at a good specialization. -/
theorem exists_smul_dt_of_good_t {k : Type u} [Field k] [IsAlgClosed k]
    [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hQtY : eval (stereoFirstCoords F v) (specializedConicPullback_dt F) = 0)
    (t : k)
    (ht : Polynomial.eval t (coordinateLineConicDiscriminant F) ≠ 0)
    (hp2 : evalPolySection v t 2 ≠ 0) :
    ∃ c : k, coordinateLineSpecializedConic_dt F t =
      C c * coordinateLineSpecializedConic F t := by
  have hQhom := coordinateLineSpecializedConic_isHomogeneous hF t
  have hRhom := coordinateLineSpecializedConic_dt_isHomogeneous F t
  have hdisc : (polarMatrix (coordinateLineSpecializedConic F t)).det ≠ 0 := by
    rwa [det_polarMatrix_coordinateLineSpecializedConic]
  refine eq_smul_of_eval_eq_zero_on_isotropic_cone
    (coordinateLineSpecializedConic F t) (coordinateLineSpecializedConic_dt F t)
    hQhom hRhom hdisc ?_
  intro x hx
  exact eval_dt_eq_zero_of_isotropic F hF v hv hQtY t hdisc hp2 x hx


/-! ### Pure-`t` coefficient packaging for the motion leaf -/

section PureTMotion
variable {k : Type u} [Field k]

theorem ternaryQuadraticCoeff_C_mul (c : k) (Q : MvPolynomial (Fin 3) k) (i j : Fin 3) :
    ternaryQuadraticCoeff (MvPolynomial.C c * Q) i j =
      c * ternaryQuadraticCoeff Q i j := by
  simp only [ternaryQuadraticCoeff]
  split_ifs <;> simp [MvPolynomial.coeff_C_mul]

theorem eval_coordinateLineSpecializedConic_dt
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (t : k) (x : Fin 3 → k) :
    MvPolynomial.eval x (coordinateLineSpecializedConic_dt F t) =
      ∑ i : Fin 3, ∑ j : Fin 3,
        Polynomial.eval t
            (Polynomial.derivative
              (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j)) *
          (x i * x j) := by
  simp only [coordinateLineSpecializedConic_dt, MvPolynomial.eval_sum, MvPolynomial.eval_mul,
    MvPolynomial.eval_C, MvPolynomial.eval_X]

theorem eval_coordinateLineSpecializedConic_eq_coeff_sum
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (t : k) (x : Fin 3 → k) :
    MvPolynomial.eval x (coordinateLineSpecializedConic F t) =
      ∑ i : Fin 3, ∑ j : Fin 3,
        Polynomial.eval t (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j) *
          (x i * x j) := by
  have hmap := map_eval_coordinateLineSpecializedConicPoly F t
  have hsum := eval_eq_ternaryQuadraticCoeff_sum
    (coordinateLineSpecializedConic_isHomogeneous hF t) x
  rw [hsum]
  refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
  have hte := ternaryQuadraticCoeff_map_eval (coordinateLineSpecializedConicPoly F) t i j
  rw [hmap] at hte
  rw [← hte, mul_assoc]

def eVec (r : Fin 3) : Fin 3 → k := fun s => if s = r then (1 : k) else 0

theorem eval_quad_form_eVec (a : Fin 3 → Fin 3 → k) (r : Fin 3) :
    (∑ i : Fin 3, ∑ j : Fin 3, a i j * (eVec r i * eVec r j)) = a r r := by
  simp only [eVec, Fin.sum_univ_three]
  fin_cases r <;> simp [Fin.sum_univ_three]

theorem eval_quad_form_e0_e1 (a : Fin 3 → Fin 3 → k)
    (ha : ∀ i j : Fin 3, j < i → a i j = 0) :
    (∑ i : Fin 3, ∑ j : Fin 3,
        a i j * ((eVec 0 i + eVec 1 i) * (eVec 0 j + eVec 1 j))) -
      a 0 0 - a 1 1 = a 0 1 := by
  have h10 : a 1 0 = 0 := ha 1 0 (by decide)
  have h20 : a 2 0 = 0 := ha 2 0 (by decide)
  have h21 : a 2 1 = 0 := ha 2 1 (by decide)
  simp only [eVec, Fin.sum_univ_three, Fin.isValue]
  simp [h10, h20, h21]
  ring

theorem eval_quad_form_e0_e2 (a : Fin 3 → Fin 3 → k)
    (ha : ∀ i j : Fin 3, j < i → a i j = 0) :
    (∑ i : Fin 3, ∑ j : Fin 3,
        a i j * ((eVec 0 i + eVec 2 i) * (eVec 0 j + eVec 2 j))) -
      a 0 0 - a 2 2 = a 0 2 := by
  have h10 : a 1 0 = 0 := ha 1 0 (by decide)
  have h20 : a 2 0 = 0 := ha 2 0 (by decide)
  have h21 : a 2 1 = 0 := ha 2 1 (by decide)
  simp only [eVec, Fin.sum_univ_three, Fin.isValue]
  simp [h10, h20, h21]
  ring

theorem eval_quad_form_e1_e2 (a : Fin 3 → Fin 3 → k)
    (ha : ∀ i j : Fin 3, j < i → a i j = 0) :
    (∑ i : Fin 3, ∑ j : Fin 3,
        a i j * ((eVec 1 i + eVec 2 i) * (eVec 1 j + eVec 2 j))) -
      a 1 1 - a 2 2 = a 1 2 := by
  have h10 : a 1 0 = 0 := ha 1 0 (by decide)
  have h20 : a 2 0 = 0 := ha 2 0 (by decide)
  have h21 : a 2 1 = 0 := ha 2 1 (by decide)
  simp only [eVec, Fin.sum_univ_three, Fin.isValue]
  simp [h10, h20, h21]
  ring

theorem ternaryQuadraticCoeff_lower_eq_zero
    {R : Type*} [CommRing R] (Q : MvPolynomial (Fin 3) R) (i j : Fin 3) (h : j < i) :
    ternaryQuadraticCoeff Q i j = 0 := by
  simp only [ternaryQuadraticCoeff]
  have hne : i ≠ j := ne_of_gt h
  have hlt : ¬ i < j := not_lt_of_gt h
  simp [hne, hlt]

/-- At good `t`, every pure-`t` coefficient satisfies the scalar relation. -/
theorem exists_smul_all_coeffs_dt_of_good_t
    [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hQtY : MvPolynomial.eval (stereoFirstCoords F v) (specializedConicPullback_dt F) = 0)
    (t : k)
    (ht : Polynomial.eval t (coordinateLineConicDiscriminant F) ≠ 0)
    (hp2 : evalPolySection v t 2 ≠ 0) :
    ∃ c : k, ∀ i j : Fin 3,
      Polynomial.eval t
          (Polynomial.derivative
            (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j)) =
        c * Polynomial.eval t
          (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j) := by
  classical
  obtain ⟨c, hc⟩ := exists_smul_dt_of_good_t F hF v hv hQtY t ht hp2
  refine ⟨c, fun i j => ?_⟩
  set q : Fin 3 → Fin 3 → Polynomial k := fun i j =>
    ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j
  set a : Fin 3 → Fin 3 → k := fun i j =>
    Polynomial.eval t (Polynomial.derivative (q i j))
  set b : Fin 3 → Fin 3 → k := fun i j => Polynomial.eval t (q i j)
  change a i j = c * b i j
  have hQt_eval (x : Fin 3 → k) :
      MvPolynomial.eval x (coordinateLineSpecializedConic_dt F t) =
        ∑ i : Fin 3, ∑ j : Fin 3, a i j * (x i * x j) := by
    simpa [a, q] using eval_coordinateLineSpecializedConic_dt F t x
  have hQ_eval (x : Fin 3 → k) :
      MvPolynomial.eval x (coordinateLineSpecializedConic F t) =
        ∑ i : Fin 3, ∑ j : Fin 3, b i j * (x i * x j) := by
    simpa [b, q] using eval_coordinateLineSpecializedConic_eq_coeff_sum F hF t x
  have hprop (x : Fin 3 → k) :
      MvPolynomial.eval x (coordinateLineSpecializedConic_dt F t) =
        c * MvPolynomial.eval x (coordinateLineSpecializedConic F t) := by
    rw [hc, MvPolynomial.eval_mul, MvPolynomial.eval_C]
  have ha_gt (i' j' : Fin 3) (h : j' < i') : a i' j' = 0 := by
    have hq0 : q i' j' = 0 := by
      simp only [q]
      exact ternaryQuadraticCoeff_lower_eq_zero (coordinateLineSpecializedConicPoly F) i' j' h
    simp only [a, hq0, Polynomial.derivative_zero, Polynomial.eval_zero]
  have hb_gt (i' j' : Fin 3) (h : j' < i') : b i' j' = 0 := by
    have hq0 : q i' j' = 0 := by
      simp only [q]
      exact ternaryQuadraticCoeff_lower_eq_zero (coordinateLineSpecializedConicPoly F) i' j' h
    simp only [b, hq0, Polynomial.eval_zero]
  have hdiag (r : Fin 3) : a r r = c * b r r := by
    have hA : MvPolynomial.eval (eVec r) (coordinateLineSpecializedConic_dt F t) = a r r := by
      rw [hQt_eval]; exact eval_quad_form_eVec a r
    have hB : MvPolynomial.eval (eVec r) (coordinateLineSpecializedConic F t) = b r r := by
      rw [hQ_eval]; exact eval_quad_form_eVec b r
    have hpr := hprop (eVec r)
    rwa [hA, hB] at hpr
  -- Helper for off-diagonal i < j
  have hoff (i j : Fin 3) (hij : i < j)
      (hA : MvPolynomial.eval (fun s => eVec i s + eVec j s)
          (coordinateLineSpecializedConic_dt F t) - a i i - a j j = a i j)
      (hB : MvPolynomial.eval (fun s => eVec i s + eVec j s)
          (coordinateLineSpecializedConic F t) - b i i - b j j = b i j) :
      a i j = c * b i j := by
    have hsum := hprop (fun s => eVec i s + eVec j s)
    calc a i j
        = MvPolynomial.eval (fun s => eVec i s + eVec j s)
            (coordinateLineSpecializedConic_dt F t) - a i i - a j j := hA.symm
      _ = c * MvPolynomial.eval (fun s => eVec i s + eVec j s)
            (coordinateLineSpecializedConic F t) - c * b i i - c * b j j := by
          rw [hsum, hdiag i, hdiag j]
      _ = c * (MvPolynomial.eval (fun s => eVec i s + eVec j s)
            (coordinateLineSpecializedConic F t) - b i i - b j j) := by ring
      _ = c * b i j := by rw [hB]
  -- Case on (i, j) via values
  have hi : i = 0 ∨ i = 1 ∨ i = 2 := by
    rcases i with ⟨v, hv⟩; interval_cases v <;> simp
  have hj : j = 0 ∨ j = 1 ∨ j = 2 := by
    rcases j with ⟨v, hv⟩; interval_cases v <;> simp
  rcases hi with rfl | rfl | rfl <;> rcases hj with rfl | rfl | rfl
  · exact hdiag 0
  · exact hoff 0 1 (by decide)
      (by rw [hQt_eval]; exact eval_quad_form_e0_e1 a ha_gt)
      (by rw [hQ_eval]; exact eval_quad_form_e0_e1 b hb_gt)
  · exact hoff 0 2 (by decide)
      (by rw [hQt_eval]; exact eval_quad_form_e0_e2 a ha_gt)
      (by rw [hQ_eval]; exact eval_quad_form_e0_e2 b hb_gt)
  · have ha0 := ha_gt 1 0 (by decide); have hb0 := hb_gt 1 0 (by decide); simp [ha0, hb0]
  · exact hdiag 1
  · exact hoff 1 2 (by decide)
      (by rw [hQt_eval]; exact eval_quad_form_e1_e2 a ha_gt)
      (by rw [hQ_eval]; exact eval_quad_form_e1_e2 b hb_gt)
  · have ha0 := ha_gt 2 0 (by decide); have hb0 := hb_gt 2 0 (by decide); simp [ha0, hb0]
  · have ha0 := ha_gt 2 1 (by decide); have hb0 := hb_gt 2 1 (by decide); simp [ha0, hb0]
  · exact hdiag 2

end PureTMotion

/-- **Motion leaf.** `B(Y, ∂Y/∂t) ≠ 0`.

If the polar vanished then `Qt(Y)=0` by the chain rule. At good specialisations of `t` the
form `Qt(t)` vanishes on the isotropic cone of `Q(t)`, hence `Qt(t)=c(t)·Q(t)`. Coefficient
minors therefore vanish identically, so `Q` is a pure-`t` scalar times a constant form; that
scalar either has a root (whole second fibre, contradicting smoothness) or is constant, in
which case the degree-3 line restriction vanishes at `(0:1:0)` (again a whole fibre). -/
theorem polarEval_stereo_pderiv_t_ne_zero
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (_hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hnd : polarEval (specializedConicPullback F) (liftTsenSection v) affineTwoStereoDir ≠ 0) :
    polarEval (specializedConicPullback F) (stereoFirstCoords F v)
      (fun a => pderiv (ULift.up 0) (stereoFirstCoords F v a)) ≠ 0 := by
  intro hB
  set Q := specializedConicPullback F
  set Y := stereoFirstCoords F v
  set Qt := specializedConicPullback_dt F
  have hchain := polarEval_stereo_pderiv_t_eq_neg_eval_dt F hF v hv
  have hQtY : eval Y Qt = 0 := by
    have : polarEval Q Y (fun a => pderiv (ULift.up 0) (Y a)) = -eval Y Qt := by
      simpa [Q, Y, Qt] using hchain
    have hB' : polarEval Q Y (fun a => pderiv (ULift.up 0) (Y a)) = 0 := by
      simpa [Q, Y] using hB
    rw [hB'] at this
    exact neg_eq_zero.mp this.symm
  classical
  set q : Fin 3 → Fin 3 → Polynomial k := fun i j =>
    ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j
  have hdisc_poly := coordinateLineConicDiscriminant_ne_zero_of_smooth F hF hF0
  -- Wronskians vanish: on the cofinite good set, coeffs are proportional under differentiation
  have hwronsk (i j i' j' : Fin 3) :
      Polynomial.derivative (q i j) * q i' j' -
        Polynomial.derivative (q i' j') * q i j = 0 := by
    let wron :=
      Polynomial.derivative (q i j) * q i' j' - Polynomial.derivative (q i' j') * q i j
    refine Polynomial.eq_zero_of_infinite_isRoot wron ?_
    -- bad set = roots of disc · v₂
    let bad : Set k :=
      {t | Polynomial.eval t (coordinateLineConicDiscriminant F) = 0} ∪
        {t | Polynomial.eval t (v 2) = 0}
    have hbad_fin : bad.Finite := by
      have h1 : ({t : k | Polynomial.eval t (coordinateLineConicDiscriminant F) = 0}).Finite := by
        by_cases h0 : coordinateLineConicDiscriminant F = 0
        · exact absurd h0 hdisc_poly
        · have heq : {t : k | Polynomial.eval t (coordinateLineConicDiscriminant F) = 0} =
              ((coordinateLineConicDiscriminant F).roots.toFinset : Set k) := by
            ext t
            constructor
            · intro ht
              exact Multiset.mem_toFinset.mpr
                ((Polynomial.mem_roots h0).mpr (Polynomial.IsRoot.def.mpr ht))
            · intro ht
              exact Polynomial.IsRoot.def.mp
                ((Polynomial.mem_roots h0).mp (Multiset.mem_toFinset.mp ht))
          rw [heq]
          exact Finset.finite_toSet _
      have h2 : ({t : k | Polynomial.eval t (v 2) = 0}).Finite := by
        by_cases h0 : v 2 = 0
        · exact absurd h0 hv2
        · have heq : {t : k | Polynomial.eval t (v 2) = 0} =
              ((v 2).roots.toFinset : Set k) := by
            ext t
            constructor
            · intro ht
              exact Multiset.mem_toFinset.mpr
                ((Polynomial.mem_roots h0).mpr (Polynomial.IsRoot.def.mpr ht))
            · intro ht
              exact Polynomial.IsRoot.def.mp
                ((Polynomial.mem_roots h0).mp (Multiset.mem_toFinset.mp ht))
          rw [heq]
          exact Finset.finite_toSet _
      exact h1.union h2
    have hgood_inf : Set.Infinite (badᶜ) := hbad_fin.infinite_compl
    refine hgood_inf.mono ?_
    intro t ht
    have ht' : t ∉ bad := ht
    simp only [bad, Set.mem_union, Set.mem_setOf_eq, not_or] at ht'
    obtain ⟨c, hc⟩ :=
      exists_smul_all_coeffs_dt_of_good_t F hF v hv hQtY t ht'.1
        (by change Polynomial.eval t (v 2) ≠ 0; exact ht'.2)
    change wron.IsRoot t
    simp only [Polynomial.IsRoot.def, wron, Polynomial.eval_sub, Polynomial.eval_mul]
    rw [hc i j, hc i' j']
    ring
  -- Some coefficient poly is nonzero
  have hQpoly_ne : ∃ i j : Fin 3, q i j ≠ 0 := by
    by_contra h
    push Not at h
    have hzero (t : k) : coordinateLineSpecializedConic F t = 0 := by
      refine MvPolynomial.funext fun x => ?_
      rw [eval_coordinateLineSpecializedConic_eq_coeff_sum F hF t x]
      simp [q, h]
    exact coordinateLineSpecializedConic_ne_zero_of_smooth k F hF hF0 0 (hzero 0)
  obtain ⟨i0, j0, hf0⟩ := hQpoly_ne
  set f := q i0 j0
  have hf_ne : f ≠ 0 := hf0
  have hprop_coeff (i j : Fin 3) : ∃ c : k, q i j = Polynomial.C c * f := by
    have hw := hwronsk i j i0 j0
    have hmul : Polynomial.derivative (q i j) * f = Polynomial.derivative f * q i j := by
      simpa [f, sub_eq_zero] using hw
    exact exists_C_mul_of_wronskian_eq_zero (q i j) f hf_ne hmul
  choose c_ij hc_ij using hprop_coeff
  set Q0 : MvPolynomial (Fin 3) k :=
    ∑ i : Fin 3, ∑ j : Fin 3,
      MvPolynomial.C (c_ij i j) * MvPolynomial.X i * MvPolynomial.X j
  have hQ_smul (t : k) :
      coordinateLineSpecializedConic F t =
        MvPolynomial.C (Polynomial.eval t f) * Q0 := by
    refine MvPolynomial.funext fun x => ?_
    have hL := eval_coordinateLineSpecializedConic_eq_coeff_sum F hF t x
    -- Prove both sides equal ∑∑ (c_ij * f(t)) * (xi * xj)
    have hLeft :
        MvPolynomial.eval x (coordinateLineSpecializedConic F t) =
          ∑ i : Fin 3, ∑ j : Fin 3,
            (c_ij i j * Polynomial.eval t f) * (x i * x j) := by
      rw [hL]
      refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
      have heq :
          Polynomial.eval t
              (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) i j) =
            c_ij i j * Polynomial.eval t f := by
        simpa [q, Polynomial.eval_mul, Polynomial.eval_C] using
          congrArg (Polynomial.eval t) (hc_ij i j)
      rw [heq]
    have hRight :
        MvPolynomial.eval x (MvPolynomial.C (Polynomial.eval t f) * Q0) =
          ∑ i : Fin 3, ∑ j : Fin 3,
            (c_ij i j * Polynomial.eval t f) * (x i * x j) := by
      -- Direct expansion without Finset.mul_sum
      dsimp only [Q0]
      rw [MvPolynomial.eval_mul, MvPolynomial.eval_C, MvPolynomial.eval_sum]
      -- f * ∑_i (∑_j eval (C c * X i * X j))
      rw [Finset.mul_sum]
      refine Finset.sum_congr rfl fun i _ => ?_
      rw [MvPolynomial.eval_sum, Finset.mul_sum]
      refine Finset.sum_congr rfl fun j _ => ?_
      simp only [MvPolynomial.eval_mul, MvPolynomial.eval_C, MvPolynomial.eval_X]
      ring
    exact hLeft.trans hRight.symm
  -- Root of f ⇒ whole fibre
  by_cases hroot : ∃ t0 : k, Polynomial.eval t0 f = 0
  · obtain ⟨t0, ht0⟩ := hroot
    have : coordinateLineSpecializedConic F t0 = 0 := by
      rw [hQ_smul, ht0, map_zero, zero_mul]
    exact coordinateLineSpecializedConic_ne_zero_of_smooth k F hF hF0 t0 this
  · -- Constant family case: pure-t coeffs constant ⇒ F vanishes on the fibre over (0:1:0)
    push Not at hroot
    have hdeg0 : f.natDegree = 0 := by
      by_contra hpos
      have hdeg_ne : f.degree ≠ 0 := by
        intro hdeg0'
        apply hpos
        rw [Polynomial.natDegree, hdeg0']
        simp
      obtain ⟨t0, ht0⟩ := IsAlgClosed.exists_root f hdeg_ne
      exact hroot t0 ht0
    have hfC : f = Polynomial.C (f.coeff 0) := Polynomial.eq_C_of_natDegree_eq_zero hdeg0
    -- Remaining pure-t packaging at infinity
    have hinf : specializeSecondCoordinates (m := 2) (![0, 1, (0 : k)]) F = 0 := by
      -- All q_ij are constant (proportional to constant f), so the specialized conic
      -- is independent of t. The degree-3 coefficient of the bihomogeneous path poly
      -- along the coordinate line is then 0, and by
      -- `coeff_bihomogeneous_coordinateLine_eval` equals F(x,(0,1,0)).
      refine MvPolynomial.funext fun x => ?_
      let n : Fin 3 → Polynomial k := fun i => Polynomial.C (x i)
      have hn_deg : ∀ i, (n i).natDegree ≤ 0 := fun i => by simp [n]
      have hlead :=
        coeff_bihomogeneous_coordinateLine_eval (d := 2) (e := 3) F hF n 0 hn_deg
      -- path poly constant
      have hpath :
          MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
              (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) F) =
            Polynomial.C (f.coeff 0 * MvPolynomial.eval x Q0) := by
        refine Polynomial.funext fun t => ?_
        have hspec :
            MvPolynomial.eval (Sum.elim x (coordinateLinePoint k t)) F =
              MvPolynomial.eval x (coordinateLineSpecializedConic F t) := by
          simp [coordinateLineSpecializedConic, eval_specializeSecondCoordinates]
        -- path specialization identity (same as GoodLineCondition.eval_t_map_path)
        have hcomm :
            Polynomial.eval t
                (MvPolynomial.eval
                  (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
                  (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) F)) =
              MvPolynomial.eval (Sum.elim x (coordinateLinePoint k t)) F := by
          have hcoords :
              (fun z : BiprojectiveCoordinate 2 2 =>
                  Polynomial.eval t
                    (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X) z)) =
                Sum.elim x (coordinateLinePoint k t) := by
            funext z
            match z with
            | Sum.inl i => simp [n, Polynomial.eval_C]
            | Sum.inr j =>
                fin_cases j <;>
                  simp [coordinateLinePoint, Polynomial.eval_C, Polynomial.eval_X]
          -- Standard path specialization (ConicDiscriminantAssembly.eval_eval_map_C)
          simpa [hcoords, n] using
            (eval_eval_map_C (σ := BiprojectiveCoordinate 2 2) (R := k) F
              (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X)) t)
        rw [hcomm, hspec, hQ_smul t, hfC]
        simp [MvPolynomial.eval_mul, MvPolynomial.eval_C, mul_comm]
      have hcoeff3 :
          (MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
              (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) F)).coeff 3 = 0 := by
        rw [hpath]; simp
      -- hlead: coeff (2*0+3) path = F(n.coeff 0, (0,1,0))
      have := hlead
      simp only [mul_zero, zero_add] at this
      rw [hcoeff3] at this
      have hrhs :
          MvPolynomial.eval (Sum.elim (fun i => (n i).coeff 0) ![0, 1, 0]) F =
            MvPolynomial.eval (Sum.elim x ![0, 1, 0]) F := by
        refine congrArg (fun z => MvPolynomial.eval z F) ?_
        funext z
        match z with
        | Sum.inl i => simp [n]
        | Sum.inr _ => rfl
      rw [hrhs] at this
      simpa [eval_specializeSecondCoordinates] using this.symm
    exact BiprojectiveSpace.not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23
      k F hF hF0 1 (![0, 1, (0 : k)]) (by simp) hinf


/-- **Immersion leaf.** `B(∂Y/∂s, ∂Y/∂s) ≠ 0`.

On a smooth conic the only null direction in `Y^⊥` is `span{Y}`.  Combined with
`false_of_pderiv_s_eq_smul_div`, the stereo `s`-derivative is not null. -/
theorem polarEval_stereo_pderiv_s_self_ne_zero
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (_hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hnd : polarEval (specializedConicPullback F) (liftTsenSection v) affineTwoStereoDir ≠ 0) :
    polarEval (specializedConicPullback F)
      (fun a => pderiv (ULift.up 1) (stereoFirstCoords F v a))
      (fun a => pderiv (ULift.up 1) (stereoFirstCoords F v a)) ≠ 0 := by
  classical
  set Q := specializedConicPullback F
  set Y := stereoFirstCoords F v
  set Z : Fin 3 → affineTwoRing k := fun a => pderiv (ULift.up 1) (Y a)
  intro hZZ
  have hQ : Q.IsHomogeneous 2 := specializedConicPullback_isHomogeneous F hF
  have hYY : polarEval Q Y Y = 0 := by
    have hYQ : eval Y Q = 0 := eval_stereoFirstCoords_specializedConic F hF v hv
    rw [polarEval_self hQ Y, hYQ, mul_zero]
  have hYZ : polarEval Q Y Z = 0 := by
    simpa [Y, Z] using polarEval_stereo_pderiv_s_eq_zero F hF v hv
  have hY0 : Y ≠ 0 := stereoFirstCoords_ne_zero F hF v hv2 hnd
  have hdisc : (polarMatrix Q).det ≠ 0 :=
    det_polarMatrix_specializedConicPullback_ne_zero_of_smooth F hF hF0
  let K := FractionRing (affineTwoRing k)
  let φ : affineTwoRing k →+* K := algebraMap (affineTwoRing k) K
  haveI : IsDomain (affineTwoRing k) := inferInstance
  have hφ_inj : Function.Injective φ := IsFractionRing.injective (affineTwoRing k) K
  set QK : MvPolynomial (Fin 3) K := map φ Q
  set YK : Fin 3 → K := fun i => φ (Y i)
  set ZK : Fin 3 → K := fun i => φ (Z i)
  have hQK : QK.IsHomogeneous 2 := hQ.map φ
  have hdiscK : (polarMatrix QK).det ≠ 0 := by
    have hmat : polarMatrix QK = (polarMatrix Q).map φ := by
      simpa [QK] using polarMatrix_map φ Q
    have hdet : ((polarMatrix Q).map φ).det = φ ((polarMatrix Q).det) := by
      change (φ.mapMatrix (polarMatrix Q)).det = φ ((polarMatrix Q).det)
      exact (RingHom.map_det φ (polarMatrix Q)).symm
    rw [hmat, hdet]
    intro h
    exact hdisc (hφ_inj (by simpa using h))
  have hYYK : polarEval QK YK YK = 0 := by
    have := congrArg φ hYY
    rwa [← polarEval_map φ Q Y Y, map_zero] at this
  have hYZK : polarEval QK YK ZK = 0 := by
    have := congrArg φ hYZ
    rwa [← polarEval_map φ Q Y Z, map_zero] at this
  have hZZK : polarEval QK ZK ZK = 0 := by
    have := congrArg φ hZZ
    rwa [← polarEval_map φ Q Z Z, map_zero] at this
  have hY0K : YK ≠ 0 := by
    intro h
    apply hY0
    funext i
    have hi : φ (Y i) = 0 := by simpa [YK] using congr_fun h i
    exact hφ_inj (by
      change φ (Y i) = φ (0 : affineTwoRing k)
      rwa [map_zero])
  obtain ⟨μ, hμ⟩ :=
    exists_smul_of_totally_isotropic (R := K) QK hQK hdiscK YK ZK hYYK hYZK hZZK hY0K
  obtain ⟨n, d, hdNZ, rfl⟩ := IsFractionRing.div_surjective (A := affineTwoRing k) μ
  have hd0 : d ≠ 0 := nonZeroDivisors.ne_zero hdNZ
  have hprop : ∀ a, φ d * ZK a = φ n * YK a := by
    intro a
    have ha := congr_fun hμ a
    have hφd : φ d ≠ 0 := by
      intro h; exact hd0 (hφ_inj (by rw [map_zero]; exact h))
    calc φ d * ZK a
        = φ d * ((φ n / φ d) * YK a) := by rw [ha]
      _ = φ n * YK a := by
          rw [← mul_assoc, mul_div_cancel₀ _ hφd]
  have hμpoly : (fun a => d * Z a) = fun a => n * Y a :=
    funext fun a =>
      hφ_inj (by simpa [map_mul, YK, ZK] using hprop a)
  exact false_of_pderiv_s_eq_smul_div F hF v hv2 hnd d n hd0 (by simpa [Y, Z] using hμpoly)

/--
**The stereographic family sweeps a surface.**

Assembled from the polar Gram identity:
`det Gram = det(polarMatrix) · det(V)² = −B(Y,∂Y/∂t)² · B(∂Y/∂s, ∂Y/∂s)`,
with the three factors on the right nonzero by smoothness of the generic conic, motion of the family,
and immersion of the stereo parameterisation.
-/
theorem stereoJacobianDet_ne_zero_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hnd : polarEval (specializedConicPullback F) (liftTsenSection v) affineTwoStereoDir ≠ 0) :
    stereoJacobianDet F v ≠ 0 := by
  classical
  set Q := specializedConicPullback F
  set Y := residualImageXCoords F v
  set Yt : Fin 3 → affineTwoRing k := fun a => pderiv (ULift.up 0) (Y a)
  set Ys : Fin 3 → affineTwoRing k := fun a => pderiv (ULift.up 1) (Y a)
  set V : Matrix (Fin 3) (Fin 3) (affineTwoRing k) := Matrix.of ![Y, Yt, Ys]
  have hQ : Q.IsHomogeneous 2 := specializedConicPullback_isHomogeneous F hF
  have hdisc : (polarMatrix Q).det ≠ 0 :=
    det_polarMatrix_specializedConicPullback_ne_zero_of_smooth F hF hF0
  set G : Matrix (Fin 3) (Fin 3) (affineTwoRing k) :=
    Matrix.of fun i j => polarEval Q (fun a => V i a) (fun a => V j a)
  have hGeq : G = V * polarMatrix Q * V.transpose := by
    simpa [G] using polar_gram_matrix_eq Q hQ V
  have hGram : G.det = (polarMatrix Q).det * V.det ^ 2 := by
    rw [hGeq, det_mul_mul_transpose_fin3]
  have hVdet : stereoJacobianDet F v = V.det := by
    simp only [stereoJacobianDet, V, Y, Yt, Ys]
  rw [hVdet]
  intro hV0
  have hG0 : G.det = 0 := by simp [hGram, hV0]
  -- Vanishing pattern
  have hYY : polarEval Q Y Y = 0 := by
    have hYQ : eval Y Q = 0 := by
      simpa [Y, residualImageXCoords, Q] using
        eval_stereoFirstCoords_specializedConic F hF v hv
    rw [polarEval_self hQ Y, hYQ, mul_zero]
  have hYYs : polarEval Q Y Ys = 0 := by
    simpa [Y, Ys, residualImageXCoords, Q] using polarEval_stereo_pderiv_s_eq_zero F hF v hv
  have hYsY : polarEval Q Ys Y = 0 := by rw [polarEval_comm]; exact hYYs
  have hG00 : G 0 0 = 0 := by simp [G, V, hYY]
  have hG02 : G 0 2 = 0 := by simp [G, V, hYYs]
  have hG20 : G 2 0 = 0 := by simp [G, V, hYsY]
  have hG10 : G 1 0 = G 0 1 := by
    simp only [G, V, Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]
    exact polarEval_comm Q _ _
  have hdetG : G.det = -(polarEval Q Y Yt) ^ 2 * polarEval Q Ys Ys := by
    have h := det_fin_three_gram_pattern G hG00 hG02 hG20 hG10
    simpa [G, V, Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons] using h
  have hYYt : polarEval Q Y Yt ≠ 0 := by
    change polarEval (specializedConicPullback F) (stereoFirstCoords F v)
        (fun a => pderiv (ULift.up 0) (stereoFirstCoords F v a)) ≠ 0
    exact polarEval_stereo_pderiv_t_ne_zero F hF hF0 v hv0 hv hv2 hnd
  have hYsYs : polarEval Q Ys Ys ≠ 0 := by
    change polarEval (specializedConicPullback F)
        (fun a => pderiv (ULift.up 1) (stereoFirstCoords F v a))
        (fun a => pderiv (ULift.up 1) (stereoFirstCoords F v a)) ≠ 0
    exact polarEval_stereo_pderiv_s_self_ne_zero F hF hF0 v hv0 hv hv2 hnd
  have hGne : G.det ≠ 0 := by
    rw [hdetG]
    intro h
    have h' : (polarEval Q Y Yt) ^ 2 * polarEval Q Ys Ys = 0 := by
      have : -(polarEval Q Y Yt) ^ 2 * polarEval Q Ys Ys = 0 := h
      simpa [neg_mul, neg_eq_zero] using this
    rcases mul_eq_zero.mp h' with h1 | h2
    · exact hYYt (sq_eq_zero_iff.mp h1)
    · exact hYsYs h2
  exact hGne hG0

/--
**A nonsingular cubic fibre, in pointwise form.**

This is the coordinate algebraic-Sard theorem from `FirstProjectionSmoothFiber`: if every fibre
were singular, elimination over the generic parameter point and extended coordinate derivations
would produce a common zero of the total equation and all six partial derivatives, contradicting
smoothness of the total hypersurface.
-/
theorem exists_nonsingularCubicFiber_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∃ x : Fin 3 → k, ∀ r : Fin 3 → k, r ≠ 0 →
      eval r (specializeFirstCoordinates (n := 2) x F) = 0 →
        ∃ i : Fin 3, eval r (pderiv i (specializeFirstCoordinates (n := 2) x F)) ≠ 0 :=
  exists_nonsingularCubicFiber_of_smooth_coordinate F hF hF0

/-- **Input (ii), derived.** -/
theorem exists_stereo_param_nonsingular_cubicFiber
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hgen : ∃ x : Fin 3 → k, ∀ r : Fin 3 → k, r ≠ 0 →
      eval r (specializeFirstCoordinates (n := 2) x F) = 0 →
        ∃ i : Fin 3, eval r (pderiv i (specializeFirstCoordinates (n := 2) x F)) ≠ 0)
    (hjac : stereoJacobianDet F v ≠ 0) :
    ∃ t s : k, ∀ r : Fin 3 → k, r ≠ 0 →
      eval r (specializeFirstCoordinates (n := 2)
          (fun i => evalAffineTwoPoint t s (residualImageXCoords F v i)) F) = 0 →
        ∃ i : Fin 3, eval r (pderiv i (specializeFirstCoordinates (n := 2)
          (fun i => evalAffineTwoPoint t s (residualImageXCoords F v i)) F)) ≠ 0 := by
  classical
  obtain ⟨S, hhom, hS⟩ := exists_defining_set_nonsingular_cubicFiber_of_bidegree23 F hF
  obtain ⟨x₀, hx₀⟩ := hgen
  obtain ⟨Δ, hΔS, hΔ⟩ := (hS x₀).mpr hx₀
  obtain ⟨n, hn⟩ := hhom Δ hΔS
  have hΔ0 : Δ ≠ 0 := by
    intro h
    rw [h] at hΔ
    exact hΔ (map_zero _)
  have hpull : (aeval (residualImageXCoords F v) :
      MvPolynomial (Fin 3) k →ₐ[k] affineTwoRing k) Δ ≠ 0 := by
    intro hzero
    exact hΔ0 (eq_zero_of_isHomogeneous_of_aeval_eq_zero_of_perfectField (residualImageXCoords F v)
      (ULift.up 0) (ULift.up 1) hjac n Δ hn hzero)
  obtain ⟨t, s, hts⟩ := exists_eval_ne_zero_affineTwoRing _ hpull
  refine ⟨t, s, (hS _).mp ⟨Δ, hΔS, ?_⟩⟩
  rw [← evalAffineTwoPoint_aeval]
  exact hts

end

end BConicBundleMultisections
