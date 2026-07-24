/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.LinearAlgebra.QuadraticForm.Basic
public import Mathlib.LinearAlgebra.Projectivization.Basic

/-!
# Pointed plane conics: stereographic projection and the model Veronese map

Classical algebra for a pointed plane conic:

1. **Stereographic second-intersection.**  Given a quadratic form `Q` and an isotropic vector
   `p`, the map `w ↦ Q(w) • p - polar(Q)(p,w) • w` is homogeneous of degree two in `w` and lands
   on the isotropic cone of `Q`.  On the cone itself it recovers scalar multiples of the free
   vector.  This is the algebraic content of projection from a rational point.

2. **Model conic `X Z = Y²`.**  The Veronese map `(s,t) ↦ (s², s t, t²)` bijects (up to scale)
   nonzero pairs `(s,t)` with nonzero isotropic vectors of `X₀ X₂ − X₁²`.  Projectivizing gives
   the classical isomorphism `ℙ¹ ≅ {XZ = Y²} ⊂ ℙ²` on points.

Scheme-level `BirationalOver` / `IsPointedConicRationalOver` packages remain the bridge from this
algebra to `MultisectionPrinciple`.  Completing an arbitrary nondegenerate pointed ternary form
to the model form (Witt / hyperbolic completion) is recorded as a remaining gap.
-/

@[expose] public section

open QuadraticMap
open scoped LinearAlgebra.Projectivization

namespace BConicBundleMultisections

noncomputable section

variable {K : Type*} {V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-! ### Stereographic second-intersection map -/

/--
Second intersection of the line through an isotropic point `p` and a free vector `w` with the
quadric `Q = 0`.

If `Q(p) = 0`, then `Q(p + t • w) = t • polar(Q)(p,w) + t² • Q(w)`, so a homogeneous
representative of the second intersection is `Q(w) • p - polar(Q)(p,w) • w`.
-/
def conicParametrization (Q : QuadraticForm K V) (p w : V) : V :=
  Q w • p - polar Q p w • w

/-- Homogeneity in the free vector. -/
theorem conicParametrization_smul_right (Q : QuadraticForm K V) (p w : V) (c : K) :
    conicParametrization Q p (c • w) = (c * c) • conicParametrization Q p w := by
  dsimp [conicParametrization]
  rw [Q.map_smul, polar_smul_right]
  simp only [smul_sub, smul_smul, smul_eq_mul]
  ring_nf

/-- Homogeneity in the base point. -/
theorem conicParametrization_smul_left (Q : QuadraticForm K V) (p w : V) (c : K) :
    conicParametrization Q (c • p) w = c • conicParametrization Q p w := by
  dsimp [conicParametrization]
  rw [polar_smul_left]
  simp only [smul_sub, smul_smul, smul_eq_mul]
  ring_nf

/-- The stereographic image is isotropic whenever the base point `p` is. -/
theorem conicParametrization_is_isotropic (Q : QuadraticForm K V) {p w : V}
    (hp : Q p = 0) :
    Q (conicParametrization Q p w) = 0 := by
  -- Set a = Q(w) • p, b = polar(p,w) • w, expand Q(a - b).
  set a := Q w • p
  set b := polar Q p w • w
  change Q (a - b) = 0
  have hQa : Q a = Q w * Q w * Q p := by
    dsimp [a]
    rw [Q.map_smul]
    simp [smul_eq_mul, mul_assoc]
  have hQb : Q b = polar Q p w * polar Q p w * Q w := by
    dsimp [b]
    rw [Q.map_smul]
    simp [smul_eq_mul, mul_assoc]
  have hpol : polar Q a b = Q w * polar Q p w * polar Q p w := by
    dsimp [a, b]
    rw [polar_smul_left, polar_smul_right]
    simp [smul_eq_mul, mul_assoc]
  have hQneg : Q (-b) = Q b := by
    calc
      Q (-b) = Q ((-(1 : K)) • b) := by rw [neg_one_smul]
      _ = ((-(1 : K)) * (-(1 : K))) • Q b := Q.map_smul _ _
      _ = Q b := by simp
  have hsub : Q (a - b) = Q a + Q b - polar Q a b := by
    have hadd := QuadraticMap.map_add Q a (-b)
    rw [sub_eq_add_neg, hadd, hQneg, polar_neg_right]
    ring
  rw [hsub, hQa, hQb, hpol, hp]
  ring

/-- On the isotropic cone, stereographic projection recovers a scalar multiple of the free
vector. -/
theorem conicParametrization_apply_self (Q : QuadraticForm K V) {p q : V}
    (hq : Q q = 0) :
    conicParametrization Q p q = -(polar Q p q) • q := by
  dsimp [conicParametrization]
  rw [hq, zero_smul, zero_sub, neg_smul]

/-- Parametrizing along the base point itself yields zero (base locus). -/
theorem conicParametrization_apply_base (Q : QuadraticForm K V) {p : V} (hp : Q p = 0) (c : K) :
    conicParametrization Q p (c • p) = 0 := by
  dsimp [conicParametrization]
  rw [Q.map_smul, polar_smul_right, polar_self Q p, hp]
  simp

/--
Line-through-base expansion used by stereographic projection:
`Q(p + t • w) = t * polar(Q)(p,w) + t² * Q(w)` when `Q(p) = 0`.
-/
theorem quadratic_line_expansion (Q : QuadraticForm K V) {p w : V} (hp : Q p = 0) (t : K) :
    Q (p + t • w) = t * polar Q p w + t * t * Q w := by
  have h := QuadraticMap.map_add Q p (t • w)
  rw [h, hp, zero_add, polar_smul_right, Q.map_smul]
  simp [smul_eq_mul, mul_assoc, add_comm]

/-! ### Model conic `X Z − Y²` and the Veronese map -/

/-- The model binary form `X₀ X₂ − X₁²` evaluating on `K³`. -/
def modelConicEval (v : Fin 3 → K) : K :=
  v 0 * v 2 - v 1 * v 1

/-- The degree-two Veronese embedding on affine coordinates: `(s,t) ↦ (s², s t, t²)`. -/
def veroneseConic (s t : K) : Fin 3 → K :=
  ![s * s, s * t, t * t]

@[simp]
theorem modelConicEval_veronese (s t : K) :
    modelConicEval (veroneseConic s t) = 0 := by
  simp only [modelConicEval, veroneseConic, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons]
  ring

theorem veroneseConic_eq_zero_iff (s t : K) :
    veroneseConic s t = 0 ↔ s = 0 ∧ t = 0 := by
  constructor
  · intro h
    have hs : s * s = 0 := by
      simpa [veroneseConic] using congr_fun h 0
    have ht : t * t = 0 := by
      simpa [veroneseConic] using congr_fun h 2
    exact ⟨mul_self_eq_zero.mp hs, mul_self_eq_zero.mp ht⟩
  · rintro ⟨rfl, rfl⟩
    ext i
    fin_cases i <;> simp [veroneseConic]

/--
**Every isotropic vector of the model conic is a Veronese image (up to scale).**

Projectivizing yields the classical bijection `ℙ¹(K) ↔ {XZ = Y²}(K)`.
-/
theorem exists_veronese_of_model_isotropic (v : Fin 3 → K) (hv0 : v ≠ 0)
    (hv : modelConicEval v = 0) :
    ∃ s t : K, ¬(s = 0 ∧ t = 0) ∧ ∃ c : K, c ≠ 0 ∧ v = c • veroneseConic s t := by
  by_cases h0 : v 0 = 0
  · have h1 : v 1 = 0 := by
      dsimp [modelConicEval] at hv
      simp only [h0, zero_mul, zero_sub, neg_eq_zero] at hv
      exact mul_self_eq_zero.mp hv
    have h2 : v 2 ≠ 0 := by
      intro h2
      apply hv0
      ext i
      fin_cases i <;> simp [h0, h1, h2]
    refine ⟨0, 1, by simp, v 2, h2, ?_⟩
    ext i
    fin_cases i <;> simp [h0, h1, veroneseConic, Pi.smul_apply, smul_eq_mul]
  · refine ⟨v 0, v 1, by simp [h0], (v 0)⁻¹, inv_ne_zero h0, ?_⟩
    have hv2 : v 2 = (v 0)⁻¹ * (v 1 * v 1) := by
      dsimp [modelConicEval] at hv
      have h := eq_of_sub_eq_zero hv
      calc
        v 2 = (v 0)⁻¹ * (v 0 * v 2) := by field_simp [h0]
        _ = (v 0)⁻¹ * (v 1 * v 1) := by rw [h]
    ext i
    fin_cases i
    · -- v 0 = (v 0)⁻¹ * (v 0 * v 0)
      simp [veroneseConic, Pi.smul_apply, smul_eq_mul]
      field_simp [h0]
    · -- v 1 = (v 0)⁻¹ * (v 0 * v 1)
      simp [veroneseConic, Pi.smul_apply, smul_eq_mul]
      field_simp [h0]
    · -- v 2 = (v 0)⁻¹ * (v 1 * v 1)
      simp [veroneseConic, Pi.smul_apply, smul_eq_mul, hv2]

/-- Projective form: every model-conic point equals a Veronese image in `ℙ²`. -/
theorem model_conic_eq_veronese_image (v : Fin 3 → K) (hv0 : v ≠ 0)
    (hv : modelConicEval v = 0) :
    ∃ s t : K, ∃ (hs : ¬(s = 0 ∧ t = 0)),
      Projectivization.mk K v hv0 =
        Projectivization.mk K (veroneseConic s t)
          (by
            intro h
            exact hs ((veroneseConic_eq_zero_iff s t).mp h)) := by
  obtain ⟨s, t, hst, c, hc, rfl⟩ := exists_veronese_of_model_isotropic v hv0 hv
  refine ⟨s, t, hst, ?_⟩
  rw [Projectivization.mk_eq_mk_iff]
  refine ⟨Units.mk0 c hc, ?_⟩
  simp [Units.smul_def]

/--
**Summary (point-level pointed model-conic rationality).**

The Veronese map realises a bijection, on `K`-points, between `ℙ¹` and the smooth model plane
conic `XZ = Y²`.  Stereographic projection supplies the same parametrization for a general pointed
quadric once reduced to this model (hyperbolic completion; remaining gap).
-/
theorem pointed_model_conic_rational_points :
    (∀ s t : K, modelConicEval (veroneseConic s t) = 0) ∧
      ∀ v : Fin 3 → K, v ≠ 0 → modelConicEval v = 0 →
        ∃ s t : K, ¬(s = 0 ∧ t = 0) ∧ ∃ c : K, c ≠ 0 ∧ v = c • veroneseConic s t :=
  ⟨modelConicEval_veronese, fun _ hv0 hv => exists_veronese_of_model_isotropic _ hv0 hv⟩

end

end BConicBundleMultisections
