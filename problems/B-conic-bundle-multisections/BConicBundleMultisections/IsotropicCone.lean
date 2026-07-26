/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.HomogeneousQuadraticEval
public import BConicBundleMultisections.GoodLineCondition
public import BConicBundleMultisections.SpecializedConicFreeDir
public import Mathlib.Algebra.MvPolynomial.Funext
public import Mathlib.Algebra.QuadraticDiscriminant
public import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv
public import Mathlib.FieldTheory.IsAlgClosed.Basic
public import Mathlib.Tactic.LinearCombination

/-!
# Homogeneous quadratics vanishing on a nondegenerate isotropic cone

If `Q` is a nondegenerate ternary quadratic (polar determinant nonzero) and `R` is any
homogeneous ternary quadratic that vanishes on the isotropic cone of `Q`, then `R = c · Q`.

This is the field-level input to the stereo motion leaf: vanishing of `(∂_t Q)` on the stereo
image of a smooth conic forces the specialized conics along the line to be proportional.
-/

@[expose] public section

open MvPolynomial Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

variable {K : Type u} [Field K]


theorem eval_add_smul_of_isHomogeneous_two
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (z x : Fin 3 → K) (t : K) :
    eval (fun i => z i + t * x i) Q =
      eval z Q + t * polarEval Q z x + t ^ 2 * eval x Q := by
  have h := eval_linComb_of_isHomogeneous_two Q hQ (1 : K) t z x
  have hvec : (fun i => z i + t * x i) = fun i => (1 : K) * z i + t * x i := by
    ext i; ring
  rw [hvec, h]; ring

theorem polarEval_eq_dot_mulVec
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2) (z x : Fin 3 → K) :
    polarEval Q z x = ∑ a : Fin 3, (polarMatrix Q).mulVec z a * x a := by
  rw [polarEval_eq_sum_basis hQ z x]
  refine Finset.sum_congr rfl fun a _ => ?_
  rw [polarEval_basis_eq_mulVec hQ z a, mul_comm]

/-! ## 2. Square of linear has det 0 -/

theorem det_polarMatrix_sq_linear_eq_zero (L : Fin 3 → K) :
    (polarMatrix ((∑ i : Fin 3, C (L i) * X i) ^ 2)).det = 0 := by
  classical
  set ℓ : MvPolynomial (Fin 3) K := ∑ i : Fin 3, C (L i) * X i
  set Q := ℓ ^ 2
  have hlin (z : Fin 3 → K) : eval z ℓ = ∑ i, L i * z i := by
    simp [ℓ, eval_mul, eval_C, eval_X]
  have hpol (u w : Fin 3 → K) :
      polarEval Q u w = 2 * (∑ i, L i * u i) * (∑ j, L j * w j) := by
    simp only [polarEval, Q, pow_two, eval_mul]
    rw [hlin u, hlin w, hlin (fun i => u i + w i)]
    have : (∑ i, L i * (u i + w i)) =
        (∑ i, L i * u i) + (∑ i, L i * w i) := by
      simp [mul_add, Finset.sum_add_distrib]
    rw [this]; ring
  have hM (i j : Fin 3) : polarMatrix Q i j = 2 * L i * L j := by
    rw [polarMatrix_apply, hpol]
    have he (a : Fin 3) :
        (∑ i : Fin 3, L i * ((Pi.single a (1 : K) : Fin 3 → K) i)) = L a := by
      simp [Pi.single_apply]
    simp only [he]
  have hmul (v : Fin 3 → K) :
      (polarMatrix Q).mulVec v = fun i => (2 * (∑ j, L j * v j)) * L i := by
    ext i
    simp only [mulVec, dotProduct, hM]
    calc ∑ j : Fin 3, (2 * L i * L j) * v j
        = ∑ j : Fin 3, (2 * L i) * (L j * v j) := by
          refine Finset.sum_congr rfl fun j _ => by ring
      _ = (2 * L i) * ∑ j : Fin 3, L j * v j := by rw [Finset.mul_sum]
      _ = (2 * (∑ j : Fin 3, L j * v j)) * L i := by ring
  have hker : ∃ v : Fin 3 → K, v ≠ 0 ∧ (∑ j, L j * v j) = 0 := by
    by_cases h : ∃ i : Fin 3, L i = 0
    · obtain ⟨i, hi⟩ := h
      refine ⟨Pi.single i (1 : K), ?_, ?_⟩
      · intro hv
        have := congr_fun hv i
        simp [Pi.single_eq_same] at this
      · simp [Pi.single_apply, hi]
    · push Not at h
      refine ⟨![L 1, -L 0, (0 : K)], ?_, ?_⟩
      · intro hv
        have h0 := congr_fun hv 0
        simp only [Matrix.cons_val_zero] at h0
        exact h 1 h0
      · simp [Fin.sum_univ_three, Matrix.cons_val_zero, Matrix.cons_val_one,
          Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons]
        ring
  obtain ⟨v, hv0, hdot⟩ := hker
  have hMv : (polarMatrix Q).mulVec v = 0 := by
    rw [hmul, hdot]; ext i; simp
  exact exists_mulVec_eq_zero_iff.mp ⟨v, hv0, hMv⟩

/-! ## 3. Pencil discriminant poly -/

noncomputable def pencilDiscPoly (Q : MvPolynomial (Fin 3) K) (z : Fin 3 → K) :
    MvPolynomial (Fin 3) K :=
  (∑ a : Fin 3, C ((polarMatrix Q).mulVec z a) * X a) ^ 2 - C (4 * eval z Q) * Q

theorem eval_pencilDiscPoly
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2) (z x : Fin 3 → K) :
    eval x (pencilDiscPoly Q z) =
      polarEval Q z x ^ 2 - 4 * eval z Q * eval x Q := by
  have hlin : eval x (∑ a : Fin 3, C ((polarMatrix Q).mulVec z a) * X a) =
      ∑ a : Fin 3, (polarMatrix Q).mulVec z a * x a := by
    simp [eval_mul, eval_C, eval_X]
  simp only [pencilDiscPoly, eval_sub, eval_mul, eval_C, eval_pow, hlin,
    polarEval_eq_dot_mulVec Q hQ z x]

theorem pencilDiscPoly_ne_zero [CharZero K] [Infinite K]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (hdisc : (polarMatrix Q).det ≠ 0)
    (z : Fin 3 → K) (hzQ : eval z Q ≠ 0) :
    pencilDiscPoly Q z ≠ 0 := by
  classical
  intro hΔ0
  have hid (x : Fin 3 → K) :
      polarEval Q z x ^ 2 = 4 * eval z Q * eval x Q := by
    have h := congr_arg (eval x) hΔ0
    -- h : eval x (pencilDiscPoly) = eval x 0
    rw [eval_pencilDiscPoly Q hQ z x, map_zero] at h
    linear_combination h
  set c : K := (4 * eval z Q)⁻¹
  set Lvec : Fin 3 → K := (polarMatrix Q).mulVec z
  set ℓ : MvPolynomial (Fin 3) K := ∑ i : Fin 3, C (Lvec i) * X i
  have h4 : (4 : K) ≠ 0 := by norm_num
  have h4z : 4 * eval z Q ≠ 0 := mul_ne_zero h4 hzQ
  have hQeq : Q = C c * ℓ ^ 2 := by
    refine MvPolynomial.funext fun x => ?_
    have hℓ : eval x ℓ = ∑ a, Lvec a * x a := by
      simp [ℓ, Lvec, eval_mul, eval_C, eval_X]
    have hpol : polarEval Q z x = ∑ a, Lvec a * x a := by
      simpa [Lvec] using polarEval_eq_dot_mulVec Q hQ z x
    have hclear : (4 * eval z Q) * eval x Q = polarEval Q z x ^ 2 := (hid x).symm
    have hform : eval x Q = c * (eval x ℓ) ^ 2 := by
      have hdiv : eval x Q = polarEval Q z x ^ 2 / (4 * eval z Q) :=
        (eq_div_iff h4z).mpr (by convert hclear using 1; ring)
      calc eval x Q
          = polarEval Q z x ^ 2 / (4 * eval z Q) := hdiv
        _ = (4 * eval z Q)⁻¹ * polarEval Q z x ^ 2 := by rw [div_eq_inv_mul]
        _ = c * polarEval Q z x ^ 2 := rfl
        _ = c * (eval x ℓ) ^ 2 := by rw [hpol, hℓ]
    simp only [eval_mul, eval_C, eval_pow, pow_two, hform]

  have hpol_smul (u w : Fin 3 → K) :
      polarEval (C c * ℓ ^ 2) u w = c * polarEval (ℓ ^ 2) u w := by
    simp only [polarEval, eval_mul, eval_C]; ring
  have hM : polarMatrix (C c * ℓ ^ 2) = c • polarMatrix (ℓ ^ 2) := by
    ext i j
    simp only [polarMatrix_apply, Matrix.smul_apply, smul_eq_mul, hpol_smul]
  have hdet0 : (polarMatrix Q).det = 0 := by
    rw [hQeq, hM, det_smul, Fintype.card_fin, det_polarMatrix_sq_linear_eq_zero Lvec]
    ring
  exact hdisc hdet0

theorem mul_eval_eq_of_disc_ne_zero [IsAlgClosed K] [CharZero K]
    (Q R : MvPolynomial (Fin 3) K)
    (hQ : Q.IsHomogeneous 2) (hR : R.IsHomogeneous 2)
    (hcone : ∀ v : Fin 3 → K, eval v Q = 0 → eval v R = 0)
    (z x : Fin 3 → K) (_hzQ : eval z Q ≠ 0) (hxQ : eval x Q ≠ 0)
    (hdisc : polarEval Q z x ^ 2 - 4 * eval z Q * eval x Q ≠ 0) :
    eval x Q * eval z R = eval x R * eval z Q := by
  classical
  set a : K := eval x Q
  set b : K := polarEval Q z x
  set cQ : K := eval z Q
  have ha : a ≠ 0 := hxQ
  -- g(T) = cQ + b T + a T²
  let g : Polynomial K :=
    Polynomial.C cQ + Polynomial.C b * Polynomial.X + Polynomial.C a * Polynomial.X ^ 2
  have hg_eval (t : K) :
      Polynomial.eval t g = a * t ^ 2 + b * t + cQ := by
    simp [g, a, b, cQ]; ring
  have hlead : g.coeff 2 = a := by
    simp [g, Polynomial.coeff_add, Polynomial.coeff_C_mul, Polynomial.coeff_X_pow,
      Polynomial.coeff_C, Polynomial.coeff_X]
  have hg0 : g ≠ 0 := fun h => ha (by
    have := congr_arg (fun p : Polynomial K => p.coeff 2) h
    simpa [hlead] using this)
  have hdeg : g.natDegree = 2 := by
    have hne : g.coeff 2 ≠ 0 := by rwa [hlead]
    have hle : g.natDegree ≤ 2 := by
      refine (Polynomial.natDegree_add_le _ _).trans (max_le ?_ ?_)
      · refine (Polynomial.natDegree_add_le _ _).trans (max_le ?_ ?_)
        · simp [Polynomial.natDegree_C]
        · refine (Polynomial.natDegree_mul_le).trans ?_
          simp [Polynomial.natDegree_C, Polynomial.natDegree_X]
      · refine (Polynomial.natDegree_mul_le).trans ?_
        simp [Polynomial.natDegree_C, Polynomial.natDegree_X_pow]
    exact le_antisymm hle (Polynomial.le_natDegree_of_ne_zero hne)
  have hsplit : Polynomial.Splits g := IsAlgClosed.splits g
  have hcard : g.roots.card = 2 := by
    rw [← hsplit.natDegree_eq_card_roots, hdeg]
  -- disc ≠ 0 ⇒ not a unique root ⇒ roots nodup
  have hD : discrim a b cQ ≠ 0 := by
    change b ^ 2 - 4 * a * cQ ≠ 0
    convert hdisc using 1; ring
  have hnodup : g.roots.Nodup := by
    by_contra hdup
    -- card 2, not nodup ⇒ double root ⇒ unique root
    obtain ⟨r1, r2, hr⟩ := Multiset.card_eq_two.mp hcard
    have hr12 : r1 = r2 := by
      by_contra hne
      exact hdup (by simp [hr, hne])
    subst hr12
    -- unique root r1
    have huniq : ∃! t, a * (t * t) + b * t + cQ = 0 := by
      refine ⟨r1, ?_, ?_⟩
      · have : r1 ∈ g.roots := by simp [hr]
        have he := (Polynomial.mem_roots hg0).mp this
        simpa [hg_eval, pow_two] using he
      · intro y hy
        -- y is a root of g
        have : Polynomial.eval y g = 0 := by
          simpa [hg_eval, pow_two] using hy
        have hyroot : y ∈ g.roots := (Polynomial.mem_roots hg0).mpr this
        simp [hr] at hyroot
        exact hyroot
    exact hD (discrim_eq_zero_of_existsUnique ha huniq)
  -- two distinct roots as a Finset
  have hfin_card : g.roots.toFinset.card = 2 := by
    rw [Multiset.toFinset_card_of_nodup hnodup, hcard]
  -- fpoly
  set fpoly : Polynomial K :=
    Polynomial.C a *
        (Polynomial.C (eval z R) + Polynomial.C (polarEval R z x) * Polynomial.X +
          Polynomial.C (eval x R) * Polynomial.X ^ 2) -
      Polynomial.C (eval x R) *
        (Polynomial.C cQ + Polynomial.C b * Polynomial.X + Polynomial.C a * Polynomial.X ^ 2)
  have hf_eval (t : K) :
      Polynomial.eval t fpoly =
        a * eval (fun i => z i + t * x i) R -
          eval x R * eval (fun i => z i + t * x i) Q := by
    simp only [fpoly, Polynomial.eval_sub, Polynomial.eval_mul, Polynomial.eval_add,
      Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow, a, b, cQ]
    rw [eval_add_smul_of_isHomogeneous_two Q hQ z x t,
        eval_add_smul_of_isHomogeneous_two R hR z x t]
    ring
  have hroots_f (t : K) (ht : t ∈ g.roots) : Polynomial.eval t fpoly = 0 := by
    have htQ : eval (fun i => z i + t * x i) Q = 0 := by
      have heg : Polynomial.eval t g = 0 := (Polynomial.mem_roots hg0).mp ht
      have heg' : a * t ^ 2 + b * t + cQ = 0 := by
        simpa [hg_eval, pow_two] using heg
      rw [eval_add_smul_of_isHomogeneous_two Q hQ z x t]
      -- need cQ + t*b + t²*a = 0
      convert heg' using 1
      simp only [a, b, cQ]; ring
    rw [hf_eval, htQ, hcone _ htQ]; ring
  have hcoeff0 : fpoly.coeff 0 = a * eval z R - eval x R * cQ := by
    change (Polynomial.C a *
        (Polynomial.C (eval z R) + Polynomial.C (polarEval R z x) * Polynomial.X +
          Polynomial.C (eval x R) * Polynomial.X ^ 2) -
      Polynomial.C (eval x R) *
        (Polynomial.C cQ + Polynomial.C b * Polynomial.X +
          Polynomial.C a * Polynomial.X ^ 2)).coeff 0 =
      a * eval z R - eval x R * cQ
    simp [Polynomial.coeff_sub, Polynomial.coeff_C_mul, Polynomial.coeff_add,
      Polynomial.coeff_C, Polynomial.coeff_X_pow, Polynomial.coeff_X]
  have hcoeff2 : fpoly.coeff 2 = 0 := by
    change (Polynomial.C a *
        (Polynomial.C (eval z R) + Polynomial.C (polarEval R z x) * Polynomial.X +
          Polynomial.C (eval x R) * Polynomial.X ^ 2) -
      Polynomial.C (eval x R) *
        (Polynomial.C cQ + Polynomial.C b * Polynomial.X +
          Polynomial.C a * Polynomial.X ^ 2)).coeff 2 = 0
    simp [Polynomial.coeff_sub, Polynomial.coeff_C_mul, Polynomial.coeff_add,
      Polynomial.coeff_C, Polynomial.coeff_X_pow, Polynomial.coeff_X]
    ring
  have hcoeff_hi (n : ℕ) (hn : 3 ≤ n) : fpoly.coeff n = 0 := by
    change (Polynomial.C a *
        (Polynomial.C (eval z R) + Polynomial.C (polarEval R z x) * Polynomial.X +
          Polynomial.C (eval x R) * Polynomial.X ^ 2) -
      Polynomial.C (eval x R) *
        (Polynomial.C cQ + Polynomial.C b * Polynomial.X +
          Polynomial.C a * Polynomial.X ^ 2)).coeff n = 0
    have hne2 : n ≠ 2 := by omega
    have hne1 : n ≠ 1 := by omega
    have hne0 : n ≠ 0 := by omega
    have hne2' : ¬(2 = n) := hne2.symm
    have hne1' : ¬(1 = n) := hne1.symm
    have hne0' : ¬(0 = n) := hne0.symm
    simp [Polynomial.coeff_sub, Polynomial.coeff_C_mul, Polynomial.coeff_add,
      Polynomial.coeff_C, Polynomial.coeff_X_pow, Polynomial.coeff_X,
      hne0, hne1, hne2, hne0', hne1', hne2']
  have hdeg_f : fpoly.natDegree ≤ 1 := by
    rw [Polynomial.natDegree_le_iff_coeff_eq_zero]
    intro n hn
    -- hn : 1 < n
    have : 2 ≤ n := by omega
    rcases n with _ | _ | _ | n
    · omega
    · omega
    · exact hcoeff2
    · exact hcoeff_hi (n + 3) (by omega)
  have hF0 : fpoly = 0 := by
    by_cases hFne : fpoly = 0
    · exact hFne
    · exfalso
      have hsub : g.roots.toFinset ⊆ fpoly.roots.toFinset := by
        intro t ht
        have ht' : t ∈ g.roots := Multiset.mem_toFinset.mp ht
        exact Multiset.mem_toFinset.mpr
          ((Polynomial.mem_roots hFne).mpr (hroots_f t ht'))
      have hge : 2 ≤ fpoly.roots.toFinset.card :=
        hfin_card.symm.le.trans (Finset.card_le_card hsub)
      have hle : fpoly.roots.toFinset.card ≤ 1 :=
        (Multiset.toFinset_card_le _).trans
          ((Polynomial.card_roots' fpoly).trans hdeg_f)
      exact Nat.lt_le_asymm (by decide : (1:ℕ) < 2) (hge.trans hle)
  have h0 : fpoly.coeff 0 = 0 := by rw [hF0, Polynomial.coeff_zero]
  have heq : a * eval z R = eval x R * cQ := by
    have := h0
    rw [hcoeff0] at this
    linear_combination this
  simpa [a, cQ, mul_comm] using heq


/-! ## Main cone theorem -/

theorem eq_smul_of_eval_eq_zero_on_isotropic_cone
    [IsAlgClosed K] [CharZero K]
    (Q R : MvPolynomial (Fin 3) K)
    (hQ : Q.IsHomogeneous 2) (hR : R.IsHomogeneous 2)
    (hdisc : (polarMatrix Q).det ≠ 0)
    (hcone : ∀ x : Fin 3 → K, eval x Q = 0 → eval x R = 0) :
    ∃ c : K, R = C c * Q := by
  classical
  haveI : Infinite K := inferInstance
  have hQ0 : Q ≠ 0 := by
    intro h
    apply hdisc
    have : polarMatrix (0 : MvPolynomial (Fin 3) K) = 0 := by
      ext i j; simp [polarMatrix_apply, polarEval]
    simpa [h, this]
  have hnoniso : ∃ z : Fin 3 → K, eval z Q ≠ 0 := by
    by_contra h; push Not at h
    exact hQ0 (MvPolynomial.funext fun x => by simpa using h x)
  obtain ⟨z0, hz0⟩ := hnoniso
  set c : K := eval z0 R / eval z0 Q
  set P : MvPolynomial (Fin 3) K := R - C c * Q
  have hP_cone (x : Fin 3 → K) (hx : eval x Q = 0) : eval x P = 0 := by
    simp only [P, eval_sub, eval_mul, eval_C, hcone x hx, hx, mul_zero, sub_zero]
  have hP_of_disc (x : Fin 3 → K)
      (hxQ : eval x Q ≠ 0)
      (hD : polarEval Q z0 x ^ 2 - 4 * eval z0 Q * eval x Q ≠ 0) :
      eval x P = 0 := by
    have hcross := mul_eval_eq_of_disc_ne_zero Q R hQ hR hcone z0 x hz0 hxQ hD
    -- hcross : Q(x) * R(z0) = R(x) * Q(z0)
    simp only [P, eval_sub, eval_mul, eval_C, c]
    have : eval x R = (eval z0 R / eval z0 Q) * eval x Q := by
      field_simp [hz0]
      -- R(x) * Q(z0) = R(z0) * Q(x)
      linear_combination -hcross
    rw [this, sub_self]
  have hprod (x : Fin 3 → K) :
      eval x (pencilDiscPoly Q z0 * P) = 0 := by
    rw [eval_mul, eval_pencilDiscPoly Q hQ z0 x]
    by_cases hxQ : eval x Q = 0
    · rw [hP_cone x hxQ, mul_zero]
    · by_cases hD : polarEval Q z0 x ^ 2 - 4 * eval z0 Q * eval x Q = 0
      · rw [hD, zero_mul]
      · rw [hP_of_disc x hxQ hD, mul_zero]
  have hprod0 : pencilDiscPoly Q z0 * P = 0 :=
    MvPolynomial.funext fun x => by simpa using hprod x
  have hΔne := pencilDiscPoly_ne_zero Q hQ hdisc z0 hz0
  have hP0 : P = 0 := (mul_eq_zero.mp hprod0).resolve_left hΔne
  exact ⟨c, sub_eq_zero.mp hP0⟩


end

end BConicBundleMultisections
