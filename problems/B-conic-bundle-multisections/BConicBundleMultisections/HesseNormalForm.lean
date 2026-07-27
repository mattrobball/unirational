/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Standard.ResidualLineMapDefinitions
public import Mathlib.AlgebraicGeometry.EllipticCurve.IsomOfJ
public import Mathlib.AlgebraicGeometry.EllipticCurve.ModelsWithJ
public import Mathlib.Algebra.Polynomial.Monic

/-!
# Elementary algebra for the Hesse family of plane cubics

This file records two axiom-free pieces of the classical Hesse-normal-form argument which can be
proved using the APIs currently available in Mathlib.

* `isSmoothPlaneCubic_hesseCubic_iff` proves directly from the Jacobian criterion that
  `U³ + V³ + W³ - 3 * λ * U * V * W` is smooth exactly when `λ³ ≠ 1`.
* `exists_hesseParameter_jValue_eq` proves that the classical rational parameter
  `27 * λ³ * (λ³ + 8)³ / (λ³ - 1)³` is surjective over an algebraically closed field of
  characteristic zero, with every chosen parameter in the smooth locus.

The second statement is deliberately only a theorem about the displayed rational function.  The
pinned Mathlib revision has `WeierstrassCurve.exists_variableChange_of_j_eq`, which compares two
already-Weierstrass equations having the same `j`, but has no construction turning an arbitrary
smooth ternary cubic (with its degree-three projective embedding) into a Weierstrass model.  Thus
this file does **not** assert the missing global projective Hesse-normal-form theorem.
-/

@[expose] public section

open MvPolynomial

namespace BConicBundleMultisections.HesseNormalForm

universe u

variable {R : Type u} [CommRing R]

/-- The Hesse cubic `U³ + V³ + W³ - 3 * λ * U * V * W`. -/
noncomputable def hesseCubic (lam : R) : MvPolynomial (Fin 3) R :=
  X 0 ^ 3 + X 1 ^ 3 + X 2 ^ 3 - C (3 * lam) * X 0 * X 1 * X 2

/-- The Hesse cubic is homogeneous of degree three. -/
theorem hesseCubic_isHomogeneous (lam : R) : (hesseCubic lam).IsHomogeneous 3 := by
  unfold hesseCubic
  have h0 : (X (0 : Fin 3) ^ 3 : MvPolynomial (Fin 3) R).IsHomogeneous 3 := by
    simpa using (isHomogeneous_X R (0 : Fin 3)).pow 3
  have h1 : (X (1 : Fin 3) ^ 3 : MvPolynomial (Fin 3) R).IsHomogeneous 3 := by
    simpa using (isHomogeneous_X R (1 : Fin 3)).pow 3
  have h2 : (X (2 : Fin 3) ^ 3 : MvPolynomial (Fin 3) R).IsHomogeneous 3 := by
    simpa using (isHomogeneous_X R (2 : Fin 3)).pow 3
  have h012 :
      (C (3 * lam) * X (0 : Fin 3) * X 1 * X 2 : MvPolynomial (Fin 3) R).IsHomogeneous 3 := by
    simpa [add_assoc] using
      (((isHomogeneous_C (Fin 3) (3 * lam)).mul (isHomogeneous_X R (0 : Fin 3))).mul
        (isHomogeneous_X R (1 : Fin 3))).mul (isHomogeneous_X R (2 : Fin 3))
  exact ((h0.add h1).add h2).sub h012

/-- Evaluation of the Hesse cubic at a coordinate vector. -/
@[simp]
theorem eval_hesseCubic (lam : R) (r : Fin 3 → R) :
    eval r (hesseCubic lam) =
      r 0 ^ 3 + r 1 ^ 3 + r 2 ^ 3 - 3 * lam * r 0 * r 1 * r 2 := by
  simp [hesseCubic]

/-- The first partial derivative of the Hesse cubic. -/
@[simp]
theorem eval_pderiv_zero_hesseCubic (lam : R) (r : Fin 3 → R) :
    eval r (pderiv 0 (hesseCubic lam)) = 3 * (r 0 ^ 2 - lam * r 1 * r 2) := by
  simp [hesseCubic]
  ring

/-- The second partial derivative of the Hesse cubic. -/
@[simp]
theorem eval_pderiv_one_hesseCubic (lam : R) (r : Fin 3 → R) :
    eval r (pderiv 1 (hesseCubic lam)) = 3 * (r 1 ^ 2 - lam * r 0 * r 2) := by
  simp [hesseCubic]
  ring

/-- The third partial derivative of the Hesse cubic. -/
@[simp]
theorem eval_pderiv_two_hesseCubic (lam : R) (r : Fin 3 → R) :
    eval r (pderiv 2 (hesseCubic lam)) = 3 * (r 2 ^ 2 - lam * r 0 * r 1) := by
  simp [hesseCubic]
  ring

variable {k : Type u} [Field k] [NeZero (2 : k)] [NeZero (3 : k)]

/-- If `λ³ ≠ 1`, the Hesse cubic is smooth by the projective Jacobian criterion. -/
theorem isSmoothPlaneCubic_hesseCubic (lam : k) (hlam : lam ^ 3 ≠ 1) :
    Standard.IsSmoothPlaneCubic (hesseCubic lam) := by
  refine ⟨hesseCubic_isHomogeneous lam, ?_⟩
  intro r hr _
  by_contra hgrad
  push Not at hgrad
  have hthree : (3 : k) ≠ 0 := by norm_num
  have h0 : r 0 ^ 2 = lam * r 1 * r 2 := by
    have h := hgrad (0 : Fin 3)
    rw [eval_pderiv_zero_hesseCubic] at h
    exact sub_eq_zero.mp ((mul_eq_zero.mp h).resolve_left hthree)
  have h1 : r 1 ^ 2 = lam * r 0 * r 2 := by
    have h := hgrad (1 : Fin 3)
    rw [eval_pderiv_one_hesseCubic] at h
    exact sub_eq_zero.mp ((mul_eq_zero.mp h).resolve_left hthree)
  have h2 : r 2 ^ 2 = lam * r 0 * r 1 := by
    have h := hgrad (2 : Fin 3)
    rw [eval_pderiv_two_hesseCubic] at h
    exact sub_eq_zero.mp ((mul_eq_zero.mp h).resolve_left hthree)
  by_cases hr0 : r 0 = 0
  · have hr1 : r 1 = 0 := by
      apply (sq_eq_zero_iff).mp
      rw [h1, hr0]
      ring
    have hr2 : r 2 = 0 := by
      apply (sq_eq_zero_iff).mp
      rw [h2, hr0]
      ring
    apply hr
    funext i
    fin_cases i <;> assumption
  by_cases hr1 : r 1 = 0
  · have : r 0 ^ 2 = 0 := by rw [h0, hr1]; ring
    exact hr0 ((sq_eq_zero_iff).mp this)
  by_cases hr2 : r 2 = 0
  · have : r 0 ^ 2 = 0 := by rw [h0, hr2]; ring
    exact hr0 ((sq_eq_zero_iff).mp this)
  have hp : r 0 * r 1 * r 2 ≠ 0 := mul_ne_zero (mul_ne_zero hr0 hr1) hr2
  have hprod :
      (r 0 * r 1 * r 2) ^ 2 = lam ^ 3 * (r 0 * r 1 * r 2) ^ 2 := by
    calc
      (r 0 * r 1 * r 2) ^ 2 = r 0 ^ 2 * r 1 ^ 2 * r 2 ^ 2 := by ring
      _ = (lam * r 1 * r 2) * (lam * r 0 * r 2) * (lam * r 0 * r 1) := by
        rw [h0, h1, h2]
      _ = lam ^ 3 * (r 0 * r 1 * r 2) ^ 2 := by ring
  apply hlam
  apply mul_right_cancel₀ (pow_ne_zero 2 hp)
  calc
    lam ^ 3 * (r 0 * r 1 * r 2) ^ 2 = (r 0 * r 1 * r 2) ^ 2 := hprod.symm
    _ = 1 * (r 0 * r 1 * r 2) ^ 2 := by rw [one_mul]

/-- The point `(1 : 1 : λ²)` is singular when `λ³ = 1`. -/
theorem not_isSmoothPlaneCubic_hesseCubic_of_cube_eq_one (lam : k) (hlam : lam ^ 3 = 1) :
    ¬Standard.IsSmoothPlaneCubic (hesseCubic lam) := by
  intro hsmooth
  let r : Fin 3 → k := ![1, 1, lam ^ 2]
  have hr : r ≠ 0 := by
    intro h
    have := congrFun h (0 : Fin 3)
    simp [r] at this
  have heval : eval r (hesseCubic lam) = 0 := by
    rw [eval_hesseCubic]
    simp [r]
    calc
      1 + 1 + (lam ^ 2) ^ 3 - 3 * lam * lam ^ 2 =
          (lam ^ 3 - 1) * (lam ^ 3 - 2) := by ring
      _ = 0 := by rw [hlam]; ring
  obtain ⟨i, hi⟩ := hsmooth.2 r hr heval
  apply hi
  have hcube : lam ^ 3 - 1 = 0 := sub_eq_zero.mpr hlam
  fin_cases i
  · simp [r]
    calc
      1 - lam * lam ^ 2 = -(lam ^ 3 - 1) := by ring
      _ = 0 := by rw [hcube]; ring
  · simp [r]
    calc
      1 - lam * lam ^ 2 = -(lam ^ 3 - 1) := by ring
      _ = 0 := by rw [hcube]; ring
  · simp [r]
    calc
      (lam ^ 2) ^ 2 - lam = lam * (lam ^ 3 - 1) := by ring
      _ = 0 := by rw [hcube, mul_zero]

/-- Exact smoothness criterion for the Hesse family in characteristic zero. -/
theorem isSmoothPlaneCubic_hesseCubic_iff (lam : k) :
    Standard.IsSmoothPlaneCubic (hesseCubic lam) ↔ lam ^ 3 ≠ 1 := by
  constructor
  · intro hsmooth hlam
    exact not_isSmoothPlaneCubic_hesseCubic_of_cube_eq_one lam hlam hsmooth
  · exact isSmoothPlaneCubic_hesseCubic lam

/-! ### Surjectivity of the classical Hesse `j`-parameter -/

/-- The classical rational `j`-parameter of the Hesse family. -/
def hesseJValue (lam : k) : k :=
  27 * lam ^ 3 * (lam ^ 3 + 8) ^ 3 / (lam ^ 3 - 1) ^ 3

/-- A monic degree-four equation for `t = λ³` with prescribed Hesse `j`-value. -/
noncomputable def hesseJPolynomial (j : k) : Polynomial k :=
  Polynomial.X * (Polynomial.X + Polynomial.C 8) ^ 3 -
    Polynomial.C (j / 27) * (Polynomial.X - Polynomial.C 1) ^ 3

/-- The prescribed-`j` polynomial has degree four. -/
theorem hesseJPolynomial_degree (j : k) : (hesseJPolynomial j).degree = 4 := by
  unfold hesseJPolynomial
  compute_degree!

/-- Every scalar is represented by the classical Hesse `j`-parameter, and the representing
parameter lies in the smooth locus `λ³ ≠ 1`. -/
theorem exists_hesseParameter_jValue_eq [IsAlgClosed k] (j : k) :
    ∃ lam : k, lam ^ 3 ≠ 1 ∧ hesseJValue lam = j := by
  obtain ⟨t, ht⟩ := IsAlgClosed.exists_root (hesseJPolynomial j) (by
    rw [hesseJPolynomial_degree]
    norm_num)
  have ht' : t * (t + 8) ^ 3 - (j / 27) * (t - 1) ^ 3 = 0 := by
    simpa [hesseJPolynomial, Polynomial.IsRoot.def] using ht
  have ht_ne_one : t ≠ 1 := by
    intro ht1
    subst t
    norm_num at ht'
  obtain ⟨lam, hlam⟩ := IsAlgClosed.exists_pow_nat_eq t (by norm_num : 0 < 3)
  have hlam_ne_one : lam ^ 3 ≠ 1 := by
    intro h
    apply ht_ne_one
    rw [← hlam, h]
  refine ⟨lam, hlam_ne_one, ?_⟩
  have hbase : t * (t + 8) ^ 3 = (j / 27) * (t - 1) ^ 3 := sub_eq_zero.mp ht'
  have heq : 27 * t * (t + 8) ^ 3 = j * (t - 1) ^ 3 := by
    calc
      27 * t * (t + 8) ^ 3 = 27 * (t * (t + 8) ^ 3) := by ring
      _ = 27 * ((j / 27) * (t - 1) ^ 3) := by rw [hbase]
      _ = j * (t - 1) ^ 3 := by field_simp
  rw [hesseJValue, hlam]
  rw [div_eq_iff (pow_ne_zero 3 (sub_ne_zero.mpr ht_ne_one))]
  exact heq

/-! ### The endpoint of the current Weierstrass API -/

/-- Every elliptic Weierstrass equation over an algebraically closed characteristic-zero field is
carried by a `WeierstrassCurve.VariableChange` to Mathlib's prescribed-`j` model for a smooth
Hesse parameter.

This is the strongest direct consequence of `WeierstrassCurve.exists_variableChange_of_j_eq` and
`WeierstrassCurve.ofJ_j`.  The target `WeierstrassCurve.ofJ (hesseJValue lam)` is Mathlib's generic
prescribed-`j` equation, **not** the ternary polynomial `hesseCubic lam`; identifying their
projective plane embeddings is one of the geometric bridges still absent from Mathlib. -/
theorem exists_hesseParameter_variableChange_to_ofJ [IsAlgClosed k] [DecidableEq k]
    (E : WeierstrassCurve k) [E.IsElliptic] :
    ∃ lam : k, lam ^ 3 ≠ 1 ∧
      ∃ C : WeierstrassCurve.VariableChange k,
        C • E = WeierstrassCurve.ofJ (hesseJValue lam) := by
  classical
  obtain ⟨lam, hlam, hj⟩ := exists_hesseParameter_jValue_eq E.j
  refine ⟨lam, hlam, ?_⟩
  apply E.exists_variableChange_of_j_eq
  rw [WeierstrassCurve.ofJ_j, hj]

end BConicBundleMultisections.HesseNormalForm
