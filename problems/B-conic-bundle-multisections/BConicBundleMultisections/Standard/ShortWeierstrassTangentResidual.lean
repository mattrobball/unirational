/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PlaneCubicTangentResidual
public import BConicBundleMultisections.BinaryCubicLineCoeff
public import BConicBundleMultisections.ShortWeierstrassNormalForm
public import Mathlib.AlgebraicGeometry.EllipticCurve.Projective.Basic
public import Mathlib.FieldTheory.IsAlgClosed.Basic

/-!
# Tangent-residual surjectivity in short Weierstrass coordinates

This module proves the explicit algebraic core of the tangent-residual avoidance argument.  On

`E : Y^2 Z = X^3 + A X Z^2 + B Z^3`

the third point cut out by the tangent at `P` is `-2P`.  Rather than importing that statement from
the elliptic-curve group law, we construct a half of a prescribed affine target and check the
residual representative directly.

Write the three roots of `T^3 + A T + B` as `e1,e2,e3`.  For a target
`Q = (a,b,1)`, choose square roots

```
u^2 = a-e1,  v^2 = a-e2,  w^2 = a-e3,  u*v*w = b.
```

Then, with `s1=u+v+w` and `s2=uv+uw+vw`, the point

```
P = (a+s2, b-s1*s2, 1)
```

has tangent residual `Q`.  All identities below are polynomial identities; algebraic closure is
used only later to choose the roots and square roots.
-/

@[expose] public section

namespace BConicBundleMultisections.Standard

noncomputable section

universe u

open _root_.MvPolynomial

variable {k : Type u} [Field k] [CharZero k]

/-- The homogeneous short Weierstrass cubic. -/
def shortWeierstrassCubic (A B : k) : MvPolynomial (Fin 3) k :=
  ShortWeierstrassNormalForm.shortWeierstrassCubic A B

/-- Evaluation of the short Weierstrass cubic. -/
theorem eval_shortWeierstrassCubic (A B : k) (p : Fin 3 → k) :
    eval p (shortWeierstrassCubic A B) =
      p 1 ^ 2 * p 2 - (p 0 ^ 3 + A * p 0 * p 2 ^ 2 + B * p 2 ^ 3) := by
  rw [shortWeierstrassCubic,
    ShortWeierstrassNormalForm.eval_shortWeierstrassCubic]
  ring

/-- The short Weierstrass equation is a ternary cubic. -/
theorem shortWeierstrassCubic_isHomogeneous (A B : k) :
    (shortWeierstrassCubic A B).IsHomogeneous 3 := by
  exact ShortWeierstrassNormalForm.shortWeierstrassCubic_isHomogeneous A B

/-- The standard affine tangent direction `(2y, 3x^2+A, 0)`. -/
def shortWeierstrassTangentDir (A x y : k) : Fin 3 → k :=
  ![2 * y, 3 * x ^ 2 + A, 0]

/-- The tangent-residual representative obtained from the standard affine tangent direction. -/
def shortWeierstrassResidualRep (A B x y : k) : Fin 3 → k :=
  let p : Fin 3 → k := ![x, y, 1]
  let q := shortWeierstrassTangentDir A x y
  residualAmbientRep p q (binaryLineRestriction p q (shortWeierstrassCubic A B))

/-- The standard affine direction is tangent at an affine point of the short Weierstrass cubic. -/
theorem shortWeierstrassTangentDir_mem_tangentHyperplaneCone
    (A B x y : k) :
    shortWeierstrassTangentDir A x y ∈
      tangentHyperplaneCone (shortWeierstrassCubic A B) ![x, y, 1] := by
  simp only [mem_tangentHyperplaneCone, eval_tangentForm_eq_dotProduct, dotProduct,
    tangentGradient, Fin.sum_univ_three, shortWeierstrassTangentDir,
    shortWeierstrassCubic]
  simp only [ShortWeierstrassNormalForm.eval_pderiv_zero_shortWeierstrassCubic,
    ShortWeierstrassNormalForm.eval_pderiv_one_shortWeierstrassCubic,
    ShortWeierstrassNormalForm.eval_pderiv_two_shortWeierstrassCubic,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons]
  ring

/-! ## Direct residual calculation -/

private theorem shortWeierstrassResidualBinaryRep_zero (A B x y : k) :
    residualBinaryRep
        (binaryLineRestriction ![x, y, 1] (shortWeierstrassTangentDir A x y)
          (shortWeierstrassCubic A B)) 0 = 8 * y ^ 3 := by
  simp only [residualBinaryRep, Matrix.cons_val_zero]
  rw [coeff03_of_binaryLineRestriction _ (shortWeierstrassCubic_isHomogeneous A B)]
  rw [eval_shortWeierstrassCubic]
  simp [shortWeierstrassTangentDir]
  ring

private theorem shortWeierstrassResidualBinaryRep_one (A B x y : k) :
    residualBinaryRep
        (binaryLineRestriction ![x, y, 1] (shortWeierstrassTangentDir A x y)
          (shortWeierstrassCubic A B)) 1 =
      (3 * x ^ 2 + A) ^ 2 - 12 * x * y ^ 2 := by
  simp only [residualBinaryRep, Matrix.cons_val_one, Matrix.head_cons]
  rw [coeff12_of_binaryLineRestriction _ (shortWeierstrassCubic_isHomogeneous A B)]
  simp only [Fin.sum_univ_three, shortWeierstrassTangentDir,
    shortWeierstrassCubic,
    ShortWeierstrassNormalForm.eval_pderiv_zero_shortWeierstrassCubic,
    ShortWeierstrassNormalForm.eval_pderiv_one_shortWeierstrassCubic,
    ShortWeierstrassNormalForm.eval_pderiv_two_shortWeierstrassCubic,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
    Matrix.tail_cons]
  ring

/-- First coordinate of the residual representative, reduced using the curve equation. -/
theorem shortWeierstrassResidualRep_zero
    (A B x y : k) (hy : y ^ 2 = x ^ 3 + A * x + B) :
    shortWeierstrassResidualRep A B x y 0 =
      2 * y * (A ^ 2 - 2 * A * x ^ 2 - 8 * B * x + x ^ 4) := by
  change
    residualBinaryRep
          (binaryLineRestriction ![x, y, 1] (shortWeierstrassTangentDir A x y)
            (shortWeierstrassCubic A B)) 0 * x +
        residualBinaryRep
          (binaryLineRestriction ![x, y, 1] (shortWeierstrassTangentDir A x y)
            (shortWeierstrassCubic A B)) 1 * (2 * y) = _
  rw [shortWeierstrassResidualBinaryRep_zero,
    shortWeierstrassResidualBinaryRep_one]
  linear_combination -16 * x * y * hy

/-- Second coordinate of the residual representative, reduced using the curve equation. -/
theorem shortWeierstrassResidualRep_one
    (A B x y : k) (hy : y ^ 2 = x ^ 3 + A * x + B) :
    shortWeierstrassResidualRep A B x y 1 =
      A ^ 3 + 5 * A ^ 2 * x ^ 2 + 4 * A * B * x - 5 * A * x ^ 4 +
        8 * B ^ 2 - 20 * B * x ^ 3 - x ^ 6 := by
  change
    residualBinaryRep
          (binaryLineRestriction ![x, y, 1] (shortWeierstrassTangentDir A x y)
            (shortWeierstrassCubic A B)) 0 * y +
        residualBinaryRep
          (binaryLineRestriction ![x, y, 1] (shortWeierstrassTangentDir A x y)
            (shortWeierstrassCubic A B)) 1 * (3 * x ^ 2 + A) = _
  rw [shortWeierstrassResidualBinaryRep_zero,
    shortWeierstrassResidualBinaryRep_one]
  linear_combination -4 * (A * x - 2 * B + 7 * x ^ 3 - 2 * y ^ 2) * hy

/-- Third coordinate of the residual representative. -/
theorem shortWeierstrassResidualRep_two
    (A B x y : k) :
    shortWeierstrassResidualRep A B x y 2 = 8 * y ^ 3 := by
  simpa [shortWeierstrassResidualRep, residualAmbientRep,
    shortWeierstrassTangentDir] using
      shortWeierstrassResidualBinaryRep_zero A B x y

/-! ## The polynomial half-point identity -/

/-- Coordinate data used by the explicit half-point formula. -/
def shortHalfPoint (a b u v w : k) : Fin 3 → k :=
  let s1 := u + v + w
  let s2 := u * v + u * w + v * w
  ![a + s2, b - s1 * s2, 1]

/-- The half-point lies on the short Weierstrass cubic. -/
theorem eval_shortWeierstrassCubic_shortHalfPoint
    (A B a b e1 e2 e3 u v w : k)
    (hsum : e1 + e2 + e3 = 0)
    (hpair : e1 * e2 + e1 * e3 + e2 * e3 = A)
    (hprod : e1 * e2 * e3 = -B)
    (hu : u ^ 2 = a - e1) (hv : v ^ 2 = a - e2) (hw : w ^ 2 = a - e3)
    (huvw : u * v * w = b) :
    eval (shortHalfPoint a b u v w) (shortWeierstrassCubic A B) = 0 := by
  rw [eval_shortWeierstrassCubic]
  simp only [shortHalfPoint, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
    Matrix.cons_val_two, Matrix.tail_cons, one_pow, mul_one]
  have he1 : e1 = a - u ^ 2 := by linear_combination hu
  have he2 : e2 = a - v ^ 2 := by linear_combination hv
  have he3 : e3 = a - w ^ 2 := by linear_combination hw
  have ha : a = (u ^ 2 + v ^ 2 + w ^ 2) / 3 := by
    rw [he1, he2, he3] at hsum
    linear_combination (1 / 3) * hsum
  have hA : A = (a - u ^ 2) * (a - v ^ 2) +
      (a - u ^ 2) * (a - w ^ 2) + (a - v ^ 2) * (a - w ^ 2) := by
    rw [← hpair, he1, he2, he3]
  have hB : B = -((a - u ^ 2) * (a - v ^ 2) * (a - w ^ 2)) := by
    rw [← neg_eq_iff_eq_neg, ← hprod, he1, he2, he3]
  rw [← huvw, hA, hB, ha]
  ring

/-- The explicit tangent residual of the half-point is the prescribed target, up to `8*y^3`. -/
theorem shortWeierstrassResidualRep_shortHalfPoint
    (A B a b e1 e2 e3 u v w : k)
    (hsum : e1 + e2 + e3 = 0)
    (hpair : e1 * e2 + e1 * e3 + e2 * e3 = A)
    (hprod : e1 * e2 * e3 = -B)
    (hu : u ^ 2 = a - e1) (hv : v ^ 2 = a - e2) (hw : w ^ 2 = a - e3)
    (huvw : u * v * w = b) :
    let p := shortHalfPoint a b u v w
    shortWeierstrassResidualRep A B (p 0) (p 1) =
      fun i => (8 * (p 1) ^ 3) * ![a, b, 1] i := by
  let p := shortHalfPoint a b u v w
  have hp : (p 1) ^ 2 = (p 0) ^ 3 + A * p 0 + B := by
    have hcurve := eval_shortWeierstrassCubic_shortHalfPoint A B a b e1 e2 e3 u v w
      hsum hpair hprod hu hv hw huvw
    rw [eval_shortWeierstrassCubic] at hcurve
    simpa [p, shortHalfPoint, sub_eq_zero] using hcurve
  have he1 : e1 = a - u ^ 2 := by linear_combination hu
  have he2 : e2 = a - v ^ 2 := by linear_combination hv
  have he3 : e3 = a - w ^ 2 := by linear_combination hw
  have ha : a = (u ^ 2 + v ^ 2 + w ^ 2) / 3 := by
    have hsum' := hsum
    rw [he1, he2, he3] at hsum'
    linear_combination (1 / 3) * hsum'
  have hA : A = (a - u ^ 2) * (a - v ^ 2) +
      (a - u ^ 2) * (a - w ^ 2) + (a - v ^ 2) * (a - w ^ 2) := by
    rw [← hpair, he1, he2, he3]
  have hB : B = -((a - u ^ 2) * (a - v ^ 2) * (a - w ^ 2)) := by
    rw [← neg_eq_iff_eq_neg, ← hprod, he1, he2, he3]
  have hres0 : shortWeierstrassResidualRep A B (p 0) (p 1) 0 =
      (8 * (p 1) ^ 3) * a := by
    rw [shortWeierstrassResidualRep_zero A B (p 0) (p 1) hp]
    simp only [p, shortHalfPoint, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.head_cons]
    rw [← huvw, hA, hB, ha]
    ring
  have hres1 : shortWeierstrassResidualRep A B (p 0) (p 1) 1 =
      (8 * (p 1) ^ 3) * b := by
    rw [shortWeierstrassResidualRep_one A B (p 0) (p 1) hp]
    simp only [p, shortHalfPoint, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.head_cons]
    rw [← huvw, hA, hB, ha]
    ring
  have hres2 : shortWeierstrassResidualRep A B (p 0) (p 1) 2 =
      (8 * (p 1) ^ 3) * 1 := by
    rw [shortWeierstrassResidualRep_two]
    ring
  funext i
  fin_cases i
  · simpa using hres0
  · simpa using hres1
  · simpa using hres2

/-! ## Choosing the half-point over an algebraically closed field -/

private theorem exists_root_quadratic [IsAlgClosed k] (a b c : k) (ha : a ≠ 0) :
    ∃ r : k, a * r ^ 2 + b * r + c = 0 := by
  obtain ⟨r, hr⟩ := IsAlgClosed.exists_root
    (Polynomial.C a * Polynomial.X ^ 2 + Polynomial.C b * Polynomial.X + Polynomial.C c)
    (by rw [Polynomial.degree_quadratic ha]; decide)
  exact ⟨r, by simpa using hr⟩

private theorem exists_root_cubic [IsAlgClosed k] (a b c d : k) (ha : a ≠ 0) :
    ∃ r : k, a * r ^ 3 + b * r ^ 2 + c * r + d = 0 := by
  obtain ⟨r, hr⟩ := IsAlgClosed.exists_root
    (Polynomial.C a * Polynomial.X ^ 3 + Polynomial.C b * Polynomial.X ^ 2 +
      Polynomial.C c * Polynomial.X + Polynomial.C d)
    (by rw [Polynomial.degree_cubic ha]; decide)
  exact ⟨r, by simpa using hr⟩

/-- A depressed cubic splits into three roots with its elementary symmetric functions. -/
theorem exists_depressedCubic_roots [IsAlgClosed k] (A B : k) :
    ∃ e1 e2 e3 : k,
      e1 + e2 + e3 = 0 ∧
      e1 * e2 + e1 * e3 + e2 * e3 = A ∧
      e1 * e2 * e3 = -B := by
  obtain ⟨e1, he1⟩ := exists_root_cubic (1 : k) 0 A B one_ne_zero
  obtain ⟨e2, he2⟩ := exists_root_quadratic (1 : k) e1 (A + e1 ^ 2) one_ne_zero
  let e3 : k := -e1 - e2
  refine ⟨e1, e2, e3, by simp [e3], ?_, ?_⟩
  · dsimp only [e3]
    linear_combination -he2
  · dsimp only [e3]
    linear_combination -e1 * he2 + he1

/-- Algebraic closure supplies all root data required by the explicit half-point formula. -/
theorem exists_shortHalfPoint_data [IsAlgClosed k]
    (A B a b : k) (hQ : b ^ 2 = a ^ 3 + A * a + B) :
    ∃ e1 e2 e3 u v w : k,
      e1 + e2 + e3 = 0 ∧
      e1 * e2 + e1 * e3 + e2 * e3 = A ∧
      e1 * e2 * e3 = -B ∧
      u ^ 2 = a - e1 ∧ v ^ 2 = a - e2 ∧ w ^ 2 = a - e3 ∧
      u * v * w = b := by
  obtain ⟨e1, e2, e3, hsum, hpair, hprod⟩ := exists_depressedCubic_roots A B
  obtain ⟨u, hu⟩ := IsAlgClosed.exists_pow_nat_eq (a - e1) (by norm_num : 0 < 2)
  obtain ⟨v, hv⟩ := IsAlgClosed.exists_pow_nat_eq (a - e2) (by norm_num : 0 < 2)
  obtain ⟨w, hw⟩ := IsAlgClosed.exists_pow_nat_eq (a - e3) (by norm_num : 0 < 2)
  have hB : B = -(e1 * e2 * e3) := by linear_combination hprod
  have hfactor : (a - e1) * (a - e2) * (a - e3) = a ^ 3 + A * a + B := by
    rw [← hpair, hB]
    linear_combination -a ^ 2 * hsum
  have hsquare : (u * v * w) ^ 2 = b ^ 2 := by
    calc
      (u * v * w) ^ 2 = u ^ 2 * v ^ 2 * w ^ 2 := by ring
      _ = (a - e1) * (a - e2) * (a - e3) := by rw [hu, hv, hw]
      _ = b ^ 2 := by rw [hfactor, ← hQ]
  have hsign : (u * v * w - b) * (u * v * w + b) = 0 := by
    linear_combination hsquare
  rcases mul_eq_zero.mp hsign with hpos | hneg
  · refine ⟨e1, e2, e3, u, v, w, hsum, hpair, hprod, hu, hv, hw, ?_⟩
    exact sub_eq_zero.mp hpos
  · refine ⟨e1, e2, e3, -u, v, w, hsum, hpair, hprod, ?_, hv, hw, ?_⟩
    · simpa using hu
    · have hneg' : u * v * w = -b := by linear_combination hneg
      linear_combination -hneg'

/-! ## Surjectivity on affine points -/

/-- **Every affine point of a smooth short Weierstrass cubic is a tangent residual.**

The output includes concrete affine tangent-line data.  The residual representative is a nonzero
scalar multiple of the prescribed target, so this is genuine projective surjectivity rather than
only an equality after allowing the zero vector. -/
theorem exists_tangentResidualRep_eq_smul_affineTarget [IsAlgClosed k]
    (A B a b : k)
    (hdisc : WeierstrassResidualInfinitesimalCertificate.discr A B ≠ 0)
    (hQ : b ^ 2 = a ^ 3 + A * a + B) :
    ∃ (p q : Fin 3 → k) (c : k),
      p ≠ 0 ∧
      eval p (shortWeierstrassCubic A B) = 0 ∧
      LinearIndependent k ![p, q] ∧
      q ∈ tangentHyperplaneCone (shortWeierstrassCubic A B) p ∧
      c ≠ 0 ∧
      residualAmbientRep p q (binaryLineRestriction p q (shortWeierstrassCubic A B)) =
        fun i => c * ![a, b, 1] i := by
  obtain ⟨e1, e2, e3, u, v, w, hsum, hpair, hprod, hu, hv, hw, huvw⟩ :=
    exists_shortHalfPoint_data A B a b hQ
  let p : Fin 3 → k := shortHalfPoint a b u v w
  let q : Fin 3 → k := shortWeierstrassTangentDir A (p 0) (p 1)
  let c : k := 8 * (p 1) ^ 3
  have hpcurve : eval p (shortWeierstrassCubic A B) = 0 := by
    exact eval_shortWeierstrassCubic_shortHalfPoint A B a b e1 e2 e3 u v w
      hsum hpair hprod hu hv hw huvw
  have hpeq : (p 1) ^ 2 = (p 0) ^ 3 + A * p 0 + B := by
    rw [eval_shortWeierstrassCubic] at hpcurve
    simpa [p, shortHalfPoint, sub_eq_zero] using hpcurve
  have hres : shortWeierstrassResidualRep A B (p 0) (p 1) =
      fun i => c * ![a, b, 1] i := by
    simpa [c] using shortWeierstrassResidualRep_shortHalfPoint
      A B a b e1 e2 e3 u v w hsum hpair hprod hu hv hw huvw
  have hp1 : p 1 ≠ 0 := by
    intro hp1zero
    have hcoord : shortWeierstrassResidualRep A B (p 0) (p 1) 1 =
        8 * (p 1) ^ 3 * p 1 +
          ((3 * (p 0) ^ 2 + A) ^ 2 - 12 * p 0 * (p 1) ^ 2) *
            (3 * (p 0) ^ 2 + A) := by
      change
        residualBinaryRep
              (binaryLineRestriction ![p 0, p 1, 1]
                (shortWeierstrassTangentDir A (p 0) (p 1))
                (shortWeierstrassCubic A B)) 0 * p 1 +
            residualBinaryRep
              (binaryLineRestriction ![p 0, p 1, 1]
                (shortWeierstrassTangentDir A (p 0) (p 1))
                (shortWeierstrassCubic A B)) 1 * (3 * (p 0) ^ 2 + A) = _
      rw [shortWeierstrassResidualBinaryRep_zero,
        shortWeierstrassResidualBinaryRep_one]
    have hr1 := congrFun hres (1 : Fin 3)
    rw [hcoord] at hr1
    simp only [c, hp1zero, zero_pow (by norm_num : 3 ≠ 0), mul_zero, zero_add,
      zero_pow (by norm_num : 2 ≠ 0), Matrix.cons_val_one, Matrix.head_cons] at hr1
    have hder : 3 * (p 0) ^ 2 + A = 0 := by
      have hcubed : (3 * (p 0) ^ 2 + A) ^ 3 = 0 := by
        linear_combination hr1
      exact (pow_eq_zero_iff (by norm_num : 3 ≠ 0)).mp hcubed
    have hcurve : (p 0) ^ 3 + A * p 0 + B = 0 := by
      rw [hp1zero, zero_pow (by norm_num : 2 ≠ 0)] at hpeq
      exact hpeq.symm
    have hA : A = -3 * (p 0) ^ 2 := by linear_combination hder
    have hB : B = 2 * (p 0) ^ 3 := by
      rw [hA] at hcurve
      have hBzero : B - 2 * (p 0) ^ 3 = 0 := by
        linear_combination hcurve
      exact sub_eq_zero.mp hBzero
    apply hdisc
    simp only [WeierstrassResidualInfinitesimalCertificate.discr, hA, hB]
    ring
  have hp0 : p ≠ 0 := by
    intro hpzero
    have := congrFun hpzero (2 : Fin 3)
    simp [p, shortHalfPoint] at this
  have hq0 : q 0 ≠ 0 := by
    simp only [q, shortWeierstrassTangentDir, Matrix.cons_val_zero]
    exact mul_ne_zero (by norm_num) hp1
  have hpq : LinearIndependent k ![p, q] := by
    rw [LinearIndependent.pair_iff]
    intro s t hst
    have htwo := congrFun hst (2 : Fin 3)
    have hs : s = 0 := by
      simpa [p, q, shortHalfPoint, shortWeierstrassTangentDir, Pi.smul_apply] using htwo
    have hzero := congrFun hst (0 : Fin 3)
    rw [hs] at hzero
    have ht : t = 0 := by
      simp only [zero_smul, zero_add, Pi.smul_apply] at hzero
      exact (mul_eq_zero.mp hzero).resolve_right hq0
    exact ⟨hs, ht⟩
  have hqT : q ∈ tangentHyperplaneCone (shortWeierstrassCubic A B) p := by
    exact shortWeierstrassTangentDir_mem_tangentHyperplaneCone A B (p 0) (p 1)
  have hc0 : c ≠ 0 := by
    exact mul_ne_zero (by norm_num) (pow_ne_zero 3 hp1)
  refine ⟨p, q, c, hp0, hpcurve, hpq, hqT, hc0, ?_⟩
  change shortWeierstrassResidualRep A B (p 0) (p 1) = _
  exact hres

/-! ## The point at infinity and projective surjectivity -/

/-- The point at infinity of the short Weierstrass model. -/
def shortWeierstrassInfinity (k : Type u) [Field k] : Fin 3 → k := ![0, 1, 0]

/-- A direction spanning the tangent line at infinity. -/
def shortWeierstrassInfinityTangentDir (k : Type u) [Field k] : Fin 3 → k := ![1, 0, 0]

/-- The point at infinity is a flex, hence is its own tangent residual. -/
theorem tangentResidualRep_at_shortWeierstrassInfinity (A B : k) :
    let p := shortWeierstrassInfinity k
    let q := shortWeierstrassInfinityTangentDir k
    eval p (shortWeierstrassCubic A B) = 0 ∧
    LinearIndependent k ![p, q] ∧
    q ∈ tangentHyperplaneCone (shortWeierstrassCubic A B) p ∧
    residualAmbientRep p q (binaryLineRestriction p q (shortWeierstrassCubic A B)) = p := by
  let p := shortWeierstrassInfinity k
  let q := shortWeierstrassInfinityTangentDir k
  have hp : eval p (shortWeierstrassCubic A B) = 0 := by
    rw [eval_shortWeierstrassCubic]
    simp [p, shortWeierstrassInfinity]
  have hpq : LinearIndependent k ![p, q] := by
    rw [LinearIndependent.pair_iff]
    intro s t hst
    have h1 := congrFun hst (1 : Fin 3)
    have h0 := congrFun hst (0 : Fin 3)
    have hs : s = 0 := by
      simpa [p, q, shortWeierstrassInfinity, shortWeierstrassInfinityTangentDir,
        Pi.smul_apply] using h1
    have ht : t = 0 := by
      rw [hs] at h0
      simpa [p, q, shortWeierstrassInfinity, shortWeierstrassInfinityTangentDir,
        Pi.smul_apply] using h0
    exact ⟨hs, ht⟩
  have hq : q ∈ tangentHyperplaneCone (shortWeierstrassCubic A B) p := by
    simp only [mem_tangentHyperplaneCone, eval_tangentForm_eq_dotProduct, dotProduct,
      tangentGradient, Fin.sum_univ_three, p, q, shortWeierstrassInfinity,
      shortWeierstrassInfinityTangentDir, shortWeierstrassCubic,
      ShortWeierstrassNormalForm.eval_pderiv_zero_shortWeierstrassCubic,
      ShortWeierstrassNormalForm.eval_pderiv_one_shortWeierstrassCubic,
      ShortWeierstrassNormalForm.eval_pderiv_two_shortWeierstrassCubic,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
      Matrix.tail_cons]
    ring
  have hzero : residualBinaryRep
      (binaryLineRestriction p q (shortWeierstrassCubic A B)) 0 = 1 := by
    simp only [residualBinaryRep, Matrix.cons_val_zero]
    rw [coeff03_of_binaryLineRestriction _ (shortWeierstrassCubic_isHomogeneous A B)]
    rw [eval_shortWeierstrassCubic]
    simp [q, shortWeierstrassInfinityTangentDir]
  have hone : residualBinaryRep
      (binaryLineRestriction p q (shortWeierstrassCubic A B)) 1 = 0 := by
    simp only [residualBinaryRep, Matrix.cons_val_one, Matrix.head_cons]
    rw [coeff12_of_binaryLineRestriction _ (shortWeierstrassCubic_isHomogeneous A B)]
    simp only [Fin.sum_univ_three, p, q, shortWeierstrassInfinity,
      shortWeierstrassInfinityTangentDir, shortWeierstrassCubic,
      ShortWeierstrassNormalForm.eval_pderiv_zero_shortWeierstrassCubic,
      ShortWeierstrassNormalForm.eval_pderiv_one_shortWeierstrassCubic,
      ShortWeierstrassNormalForm.eval_pderiv_two_shortWeierstrassCubic,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val_two,
      Matrix.tail_cons]
    ring
  refine ⟨hp, hpq, hq, ?_⟩
  change residualAmbientRep p q (binaryLineRestriction p q (shortWeierstrassCubic A B)) = p
  funext i
  simp only [residualAmbientRep, hzero, hone, one_mul, zero_mul, add_zero]

/-- **The tangent-residual map of a smooth short Weierstrass cubic is projectively surjective.**

This includes the point at infinity.  On the affine chart it is the explicit half-point theorem;
at infinity it is the flex calculation above. -/
theorem exists_tangentResidualRep_eq_smul_target [IsAlgClosed k]
    (A B : k)
    (hdisc : WeierstrassResidualInfinitesimalCertificate.discr A B ≠ 0)
    (y : Fin 3 → k) (hy0 : y ≠ 0)
    (hy : eval y (shortWeierstrassCubic A B) = 0) :
    ∃ (p q : Fin 3 → k) (c : k),
      p ≠ 0 ∧
      eval p (shortWeierstrassCubic A B) = 0 ∧
      LinearIndependent k ![p, q] ∧
      q ∈ tangentHyperplaneCone (shortWeierstrassCubic A B) p ∧
      c ≠ 0 ∧
      residualAmbientRep p q (binaryLineRestriction p q (shortWeierstrassCubic A B)) =
        fun i => c * y i := by
  by_cases hy2 : y 2 = 0
  · have hy0coord : y 0 = 0 := by
      rw [eval_shortWeierstrassCubic] at hy
      rw [hy2] at hy
      simp only [zero_pow (by norm_num : 2 ≠ 0), mul_zero,
        zero_pow (by norm_num : 3 ≠ 0), add_zero, sub_eq_zero] at hy
      exact (pow_eq_zero_iff (by norm_num : 3 ≠ 0)).mp hy.symm
    have hy1 : y 1 ≠ 0 := by
      intro hy1
      apply hy0
      funext i
      fin_cases i <;> simp [hy0coord, hy1, hy2]
    let p := shortWeierstrassInfinity k
    let q := shortWeierstrassInfinityTangentDir k
    let c := (y 1)⁻¹
    obtain ⟨hp, hpq, hq, hres⟩ := tangentResidualRep_at_shortWeierstrassInfinity A B
    have hp0 : p ≠ 0 := by
      intro hpzero
      have := congrFun hpzero (1 : Fin 3)
      simp [p, shortWeierstrassInfinity] at this
    have hc : c ≠ 0 := inv_ne_zero hy1
    refine ⟨p, q, c, hp0, hp, hpq, hq, hc, ?_⟩
    rw [hres]
    funext i
    fin_cases i
    · simp [p, c, shortWeierstrassInfinity, hy0coord]
    · simp [p, c, shortWeierstrassInfinity, hy1]
    · simp [p, c, shortWeierstrassInfinity, hy2]
  · let a : k := y 0 / y 2
    let b : k := y 1 / y 2
    have hQ : b ^ 2 = a ^ 3 + A * a + B := by
      rw [eval_shortWeierstrassCubic] at hy
      dsimp only [a, b]
      field_simp [hy2]
      linear_combination hy
    obtain ⟨p, q, d, hp0, hp, hpq, hq, hd, hres⟩ :=
      exists_tangentResidualRep_eq_smul_affineTarget A B a b hdisc hQ
    let c : k := d * (y 2)⁻¹
    have hc : c ≠ 0 := mul_ne_zero hd (inv_ne_zero hy2)
    refine ⟨p, q, c, hp0, hp, hpq, hq, hc, ?_⟩
    rw [hres]
    have hnorm (i : Fin 3) : ![a, b, 1] i = (y 2)⁻¹ * y i := by
      fin_cases i <;> simp [a, b, hy2, div_eq_mul_inv, mul_comm]
    funext i
    rw [hnorm]
    simp only [c]
    ring

/-! ## Avoiding an arbitrary homogeneous target -/

/-- **A proper homogeneous target is avoided by some tangent residual.**

`hproper` is the exact pointwise meaning needed here: the target hypersurface does not contain the
short Weierstrass cubic.  The theorem works in every target degree, including the degree-nine conic
discriminant occurring in G4. -/
theorem exists_tangentResidualRep_avoids_homogeneous_target [IsAlgClosed k]
    (A B : k)
    (hdisc : WeierstrassResidualInfinitesimalCertificate.discr A B ≠ 0)
    (H : MvPolynomial (Fin 3) k) {d : ℕ} (hH : H.IsHomogeneous d)
    (hproper : ∃ y : Fin 3 → k,
      y ≠ 0 ∧ eval y (shortWeierstrassCubic A B) = 0 ∧ eval y H ≠ 0) :
    ∃ p q : Fin 3 → k,
      p ≠ 0 ∧
      eval p (shortWeierstrassCubic A B) = 0 ∧
      LinearIndependent k ![p, q] ∧
      q ∈ tangentHyperplaneCone (shortWeierstrassCubic A B) p ∧
      eval (residualAmbientRep p q
        (binaryLineRestriction p q (shortWeierstrassCubic A B))) H ≠ 0 := by
  obtain ⟨y, hy0, hycurve, hyH⟩ := hproper
  obtain ⟨p, q, c, hp0, hpcurve, hpq, hq, hc, hres⟩ :=
    exists_tangentResidualRep_eq_smul_target A B hdisc y hy0 hycurve
  refine ⟨p, q, hp0, hpcurve, hpq, hq, ?_⟩
  rw [hres, eval_smul_point_of_isHomogeneous hH]
  exact mul_ne_zero (pow_ne_zero d hc) hyH

end

end BConicBundleMultisections.Standard
