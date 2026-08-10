/-
Cardinality of PSL₂(F₁₁) = 660, via |GL| → |SL| → |PSL|.
Projective order profile of SL₂(F₁₁) via native enumeration, and
the character-norm identity ∑_g χ₁₀'(g)² = 660 as an integer count.
-/
import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Card
import Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup
import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
import Mathlib.LinearAlgebra.Matrix.ProjectiveSpecialLinearGroup
import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.Field.ZMod
import Mathlib.Data.Fintype.Card
import Mathlib.GroupTheory.Index
import Mathlib.Algebra.Group.Subgroup.Finite
import Mathlib.GroupTheory.SpecificGroups.Cyclic
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.RingTheory.RootsOfUnity.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Int.Basic
import Mathlib.Data.Fintype.Sigma
import Mathlib.LinearAlgebra.Matrix.Adjugate
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

open Matrix Matrix.SpecialLinearGroup BigOperators
open scoped MatrixGroups

noncomputable section

namespace V14Formalization
namespace PSLCard

abbrev F := ZMod 11
instance : Fact (Nat.Prime 11) := ⟨Nat.prime_eleven⟩
abbrev SLG := SpecialLinearGroup (Fin 2) F
abbrev PSL2F11 := PSL(2, F)

theorem card_F11 : Fintype.card F = 11 := by decide

theorem card_GL2_F11 : Nat.card (GL (Fin 2) F) = 13200 := by
  have h := card_GL_field (𝔽 := F) (n := 2)
  rw [h, card_F11]
  simp only [Fin.prod_univ_two]
  norm_num [pow_zero, pow_one]

theorem card_units_F11 : Nat.card Fˣ = 10 := by
  rw [Nat.card_eq_fintype_card, Fintype.card_units, card_F11]

theorem card_SL2_F11 : Nat.card SLG = 1320 := by
  let f : GL (Fin 2) F →* Fˣ := GeneralLinearGroup.det (R := F) (n := Fin 2)
  have hsurj : Function.Surjective f := GeneralLinearGroup.det_surjective
  have hmul : Nat.card f.ker * f.ker.index = Nat.card (GL (Fin 2) F) :=
    Subgroup.card_mul_index f.ker
  have hidx : f.ker.index = Nat.card Fˣ := by
    rw [Subgroup.index_ker f]
    have : f.range = ⊤ := MonoidHom.range_eq_top.mpr hsurj
    rw [this]
    exact Nat.card_congr (Subgroup.topEquiv (G := Fˣ)).toEquiv
  have e : f.ker ≃ SLG := by
    refine Equiv.ofBijective (fun g => ⟨g.1.val, ?_⟩) ?_
    · have hfg : f (g : GL (Fin 2) F) = 1 := g.2
      have hval : (f (g : GL (Fin 2) F)).val = 1 := by rw [hfg]; rfl
      have hdet := GeneralLinearGroup.val_det_apply (g : GL (Fin 2) F)
      change (g : GL (Fin 2) F).val.det = 1
      rwa [← hdet]
    · constructor
      · intro g1 g2 h
        apply Subtype.ext
        apply GeneralLinearGroup.ext
        intro i j
        exact congr_fun (congr_fun (congrArg Subtype.val h) i) j
      · intro s
        refine ⟨⟨toGL s, ?_⟩, Subtype.ext rfl⟩
        · change f (toGL s) = 1
          apply Units.ext
          have hdet := GeneralLinearGroup.val_det_apply (toGL s)
          rw [hdet]
          change (s : Matrix (Fin 2) (Fin 2) F).det = 1
          exact s.2
  have hker : Nat.card f.ker = Nat.card SLG := Nat.card_congr e
  rw [hidx, hker, card_units_F11, card_GL2_F11] at hmul
  omega

theorem card_rootsOfUnity_two_F : Nat.card (rootsOfUnity 2 F) = 2 := by
  have heq : (rootsOfUnity 2 F : Subgroup Fˣ) = (powMonoidHom 2).ker := by
    ext x
    simp only [mem_rootsOfUnity, MonoidHom.mem_ker, powMonoidHom_apply]
  have hker' : Nat.card (powMonoidHom 2 : Fˣ →* Fˣ).ker = (Nat.card Fˣ).gcd 2 :=
    IsCyclic.card_powMonoidHom_ker (G := Fˣ) 2
  rw [← heq] at hker'
  rw [hker', card_units_F11]
  decide

theorem card_center_SL2 : Nat.card (Subgroup.center SLG) = 2 := by
  have he : Subgroup.center SLG ≃* rootsOfUnity (Fintype.card (Fin 2)) F :=
    SpecialLinearGroup.center_equiv_rootsOfUnity' (0 : Fin 2)
  have h2 : Fintype.card (Fin 2) = 2 := by decide
  rw [Nat.card_congr he.toEquiv]
  have : rootsOfUnity (Fintype.card (Fin 2)) F = rootsOfUnity 2 F := by
    simp only [h2]
  rw [this, card_rootsOfUnity_two_F]

theorem card_PSL2_F11 : Nat.card PSL2F11 = 660 := by
  have hSL := card_SL2_F11
  have hC := card_center_SL2
  have hprod :
      Nat.card (SLG ⧸ Subgroup.center SLG) * Nat.card (Subgroup.center SLG) =
        Nat.card SLG :=
    (Subgroup.card_eq_card_quotient_mul_card_subgroup (Subgroup.center SLG)).symm
  change Nat.card PSL2F11 * Nat.card (Subgroup.center SLG) = Nat.card SLG at hprod
  rw [hC, hSL] at hprod
  omega

theorem card_PSL2_F11_fintype : Fintype.card PSL2F11 = 660 := by
  rw [← Nat.card_eq_fintype_card, card_PSL2_F11]

/-! ## Projective order profile and χ₁₀' character norm

Computable order of the image in PSL: least `n ∈ {1,2,3,5,6,11}` with
`g^n = ±I`.  Native enumeration of the SL order multiset yields
`∑_A χ(pslOrd A)² = 1320 = 2 · 660`, hence the PSL character norm is 660. -/

def negI : SLG := ⟨-1, by simp [det_neg, Fintype.card_fin, pow_two]⟩

theorem negI_mem_center : negI ∈ Subgroup.center SLG := by
  rw [SpecialLinearGroup.mem_center_iff]
  refine ⟨(-1 : F), by decide, ?_⟩
  ext i j
  simp [negI, scalar, diagonal, Matrix.one_apply, Matrix.neg_apply]
  split_ifs <;> ring

theorem mem_center_iff_one_or_negI (A : SLG) :
    A ∈ Subgroup.center SLG ↔ A = 1 ∨ A = negI := by
  constructor
  · intro hA
    obtain ⟨r, hr, hsc⟩ :=
      (SpecialLinearGroup.mem_center_iff (n := Fin 2) (R := F)).mp hA
    have hr2 : r ^ 2 = 1 := by simpa [Fintype.card_fin] using hr
    have r_cases : r = 1 ∨ r = -1 := by
      have : r * r = 1 := by simpa [pow_two] using hr2
      have hfac : (r - 1) * (r + 1) = 0 := by
        calc (r - 1) * (r + 1) = r * r - 1 := by ring
          _ = 1 - 1 := by rw [this]
          _ = 0 := by ring
      rcases mul_eq_zero.mp hfac with h | h
      · exact Or.inl (sub_eq_zero.mp h)
      · exact Or.inr (eq_neg_of_add_eq_zero_left h)
    rcases r_cases with rfl | rfl
    · left
      apply Subtype.ext
      calc (A : Matrix (Fin 2) (Fin 2) F)
          = scalar (Fin 2) (1 : F) := hsc.symm
        _ = 1 := by
          ext i j; simp [scalar, diagonal, Matrix.one_apply]
    · right
      apply Subtype.ext
      calc (A : Matrix (Fin 2) (Fin 2) F)
          = scalar (Fin 2) (-1 : F) := hsc.symm
        _ = (negI : Matrix (Fin 2) (Fin 2) F) := by
          ext i j
          by_cases hij : i = j
          · simp [scalar, diagonal, negI, hij, Matrix.one_apply]
          · simp [scalar, diagonal, negI, hij, Matrix.one_apply]
  · intro h
    rcases h with rfl | rfl
    · exact Subgroup.one_mem _
    · exact negI_mem_center

/-- Computable projective order of an SL₂ matrix (image in PSL). -/
def pslOrd (g : SLG) : ℕ :=
  if g ^ 1 = 1 ∨ g ^ 1 = negI then 1
  else if g ^ 2 = 1 ∨ g ^ 2 = negI then 2
  else if g ^ 3 = 1 ∨ g ^ 3 = negI then 3
  else if g ^ 5 = 1 ∨ g ^ 5 = negI then 5
  else if g ^ 6 = 1 ∨ g ^ 6 = negI then 6
  else if g ^ 11 = 1 ∨ g ^ 11 = negI then 11
  else 0

def slCardOrder (n : ℕ) : ℕ :=
  (Finset.univ : Finset SLG).filter (fun g => pslOrd g = n) |>.card

theorem slCardOrder_one : slCardOrder 1 = 2 := by native_decide
theorem slCardOrder_two : slCardOrder 2 = 110 := by native_decide
theorem slCardOrder_three : slCardOrder 3 = 220 := by native_decide
theorem slCardOrder_five : slCardOrder 5 = 528 := by native_decide
theorem slCardOrder_six : slCardOrder 6 = 220 := by native_decide
theorem slCardOrder_eleven : slCardOrder 11 = 240 := by native_decide
theorem slCardOrder_zero : slCardOrder 0 = 0 := by native_decide

/-- Integer character values of χ₁₀' by projective order. -/
def chi10Int (n : ℕ) : ℤ :=
  if n = 1 then 10
  else if n = 2 then 2
  else if n = 3 then 1
  else if n = 5 then 0
  else if n = 6 then -1
  else if n = 11 then -1
  else 0

/-- ∑_{A : SL} χ(pslOrd A)² = 1320, by native enumeration. -/
def slChiSumSq : ℤ :=
  ∑ A : SLG, chi10Int (pslOrd A) * chi10Int (pslOrd A)

theorem slChiSumSq_eq : slChiSumSq = 1320 := by native_decide

/-- Equivalent count via order multiset: 100·2 + 4·110 + 1·220 + 0·528 + 1·220 + 1·240. -/
theorem slChiSumSq_by_orders :
    (100 : ℤ) * slCardOrder 1 + 4 * slCardOrder 2 + slCardOrder 3 +
      slCardOrder 6 + slCardOrder 11 = 1320 := by
  rw [slCardOrder_one, slCardOrder_two, slCardOrder_three, slCardOrder_six,
    slCardOrder_eleven]
  norm_num

theorem pslOrd_eq_one_or_pow_center (g : SLG) (n : ℕ)
    (hn : pslOrd g = n) (hn0 : n ≠ 0) :
    g ^ n = 1 ∨ g ^ n = negI := by
  unfold pslOrd at hn
  split_ifs at hn with h1 h2 h3 h5 h6 h11
  · subst hn; simpa using h1
  · subst hn; simpa using h2
  · subst hn; simpa using h3
  · subst hn; simpa using h5
  · subst hn; simpa using h6
  · subst hn; simpa using h11
  · exact absurd hn (Ne.symm hn0)

theorem mk_pow_eq_one_iff_pow_mem_center (A : SLG) (n : ℕ) :
    (QuotientGroup.mk A : PSL2F11) ^ n = 1 ↔ A ^ n ∈ Subgroup.center SLG := by
  rw [← QuotientGroup.mk_pow, QuotientGroup.eq_one_iff]

theorem pslOrd_le_of_pow_center {A : SLG} {k : ℕ}
    (hk : k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 5 ∨ k = 6 ∨ k = 11)
    (hpow : A ^ k = 1 ∨ A ^ k = negI) :
    pslOrd A ≤ k := by
  unfold pslOrd
  rcases hk with rfl | rfl | rfl | rfl | rfl | rfl <;> split_ifs <;> omega

theorem pslOrd_eq_cases (A : SLG) (hA : pslOrd A ≠ 0) :
    pslOrd A = 1 ∨ pslOrd A = 2 ∨ pslOrd A = 3 ∨
      pslOrd A = 5 ∨ pslOrd A = 6 ∨ pslOrd A = 11 := by
  unfold pslOrd at hA ⊢
  split_ifs at hA ⊢
  · exact Or.inl rfl
  · exact Or.inr (Or.inl rfl)
  · exact Or.inr (Or.inr (Or.inl rfl))
  · exact Or.inr (Or.inr (Or.inr (Or.inl rfl)))
  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl rfl))))
  · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr rfl))))
  · exact absurd rfl hA

theorem not_pow_center_of_pslOrd_gt {A : SLG} {k : ℕ}
    (hk : k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 5 ∨ k = 6 ∨ k = 11)
    (hlt : k < pslOrd A) :
    ¬ (A ^ k = 1 ∨ A ^ k = negI) := fun hpow =>
  absurd (pslOrd_le_of_pow_center hk hpow) (not_le.mpr hlt)

set_option maxRecDepth 1000000 in
theorem pslOrd_ne_zero (A : SLG) : pslOrd A ≠ 0 := by
  intro h0
  have hempty :
      ((Finset.univ : Finset SLG).filter (fun g => pslOrd g = 0)) = ∅ :=
    Finset.card_eq_zero.mp slCardOrder_zero
  have hnot : ¬ A ∈ (Finset.univ : Finset SLG).filter (fun g => pslOrd g = 0) := by
    rw [hempty]; exact Finset.notMem_empty A
  exact hnot (Finset.mem_filter.mpr ⟨Finset.mem_univ A, h0⟩)

theorem pslOrd_eq_spectrum (A : SLG) :
    pslOrd A = 1 ∨ pslOrd A = 2 ∨ pslOrd A = 3 ∨
      pslOrd A = 5 ∨ pslOrd A = 6 ∨ pslOrd A = 11 := by
  have hA := pslOrd_ne_zero A
  exact pslOrd_eq_cases A hA

private theorem not_pow_one_of_pslOrd_eq {A : SLG} {n : ℕ}
    (hn : pslOrd A = n) (hne : n ≠ 1) :
    ¬ (A ^ 1 = 1 ∨ A ^ 1 = negI) := by
  intro hp
  have hle : pslOrd A ≤ 1 := pslOrd_le_of_pow_center (Or.inl rfl) hp
  have hge : 1 ≤ pslOrd A := Nat.pos_of_ne_zero (pslOrd_ne_zero A)
  have : pslOrd A = 1 := Nat.le_antisymm hle hge
  exact hne (hn.symm.trans this)

theorem orderOf_mk_eq_pslOrd (A : SLG) :
    orderOf (QuotientGroup.mk A : PSL2F11) = pslOrd A := by
  have hA := pslOrd_ne_zero A
  have hcases := pslOrd_eq_cases A hA
  have hmk_of (k : ℕ) (hk : pslOrd A = k) (hk0 : k ≠ 0) :
      (QuotientGroup.mk A : PSL2F11) ^ k = 1 := by
    rw [mk_pow_eq_one_iff_pow_mem_center, mem_center_iff_one_or_negI]
    exact pslOrd_eq_one_or_pow_center A k hk hk0
  -- Case on the six possible orders; check proper divisors only
  rcases hcases with hn | hn | hn | hn | hn | hn
  · -- order 1: A = ±I so mk A = 1
    rw [hn]
    have hpow : A ^ 1 = 1 ∨ A ^ 1 = negI :=
      pslOrd_eq_one_or_pow_center A 1 hn (by decide)
    have hmk1 : (QuotientGroup.mk A : PSL2F11) = 1 := by
      rw [show (QuotientGroup.mk A : PSL2F11) = (QuotientGroup.mk A) ^ 1 by rw [pow_one]]
      exact hmk_of 1 hn (by decide)
    rw [hmk1, orderOf_one]
  · -- order 2
    rw [hn]
    refine (orderOf_eq_iff (by decide : 0 < 2)).2 ⟨hmk_of 2 hn (by decide), ?_⟩
    intro m hm_lt hm_pos hpowm
    have hm1 : m = 1 := by omega
    subst hm1
    have hAd : A ^ 1 = 1 ∨ A ^ 1 = negI :=
      (mem_center_iff_one_or_negI _).mp
        ((mk_pow_eq_one_iff_pow_mem_center A 1).mp hpowm)
    exact not_pow_one_of_pslOrd_eq hn (by decide : (2 : ℕ) ≠ 1) hAd
  · -- order 3
    rw [hn]
    refine (orderOf_eq_iff (by decide : 0 < 3)).2 ⟨hmk_of 3 hn (by decide), ?_⟩
    intro m hm_lt hm_pos hpowm
    have hm12 : m = 1 ∨ m = 2 := by omega
    have hAd : A ^ m = 1 ∨ A ^ m = negI :=
      (mem_center_iff_one_or_negI _).mp
        ((mk_pow_eq_one_iff_pow_mem_center A m).mp hpowm)
    rcases hm12 with rfl | rfl
    · exact not_pow_one_of_pslOrd_eq hn (by decide) hAd
    · exact (not_pow_center_of_pslOrd_gt (k := 2)
        (Or.inr (Or.inl rfl)) (by omega)) hAd
  · -- order 5: proper positive divisors of 5 are only 1
    rw [hn]
    refine (orderOf_eq_iff (by decide : 0 < 5)).2 ⟨hmk_of 5 hn (by decide), ?_⟩
    intro m hm_lt hm_pos hpowm
    have hord_m := orderOf_dvd_of_pow_eq_one hpowm
    have hord_5 := orderOf_dvd_of_pow_eq_one (hmk_of 5 hn (by decide))
    have hgcd : Nat.gcd m 5 = 1 := by
      have hprime : Nat.Prime 5 := by decide
      have hg : Nat.gcd m 5 ∣ 5 := Nat.gcd_dvd_right m 5
      have hgi := (Nat.dvd_prime hprime).mp hg
      exact hgi.resolve_right (by
        have : Nat.gcd m 5 ≤ m := Nat.gcd_le_left 5 hm_pos
        omega)
    have hord1 : orderOf (QuotientGroup.mk A : PSL2F11) ∣ 1 :=
      (Nat.dvd_gcd hord_m hord_5).trans (by rw [hgcd])
    have hmk1 : (QuotientGroup.mk A : PSL2F11) = 1 :=
      orderOf_eq_one_iff.mp (Nat.dvd_one.mp hord1)
    have hAcent : A = 1 ∨ A = negI :=
      (mem_center_iff_one_or_negI A).mp ((QuotientGroup.eq_one_iff _).mp hmk1)
    exact not_pow_one_of_pslOrd_eq hn (by decide)
      (by simpa [pow_one] using hAcent)
  · -- order 6
    rw [hn]
    refine (orderOf_eq_iff (by decide : 0 < 6)).2 ⟨hmk_of 6 hn (by decide), ?_⟩
    intro m hm_lt hm_pos hpowm
    have hord_m := orderOf_dvd_of_pow_eq_one hpowm
    have hord_6 := orderOf_dvd_of_pow_eq_one (hmk_of 6 hn (by decide))
    have hdvd : orderOf (QuotientGroup.mk A : PSL2F11) ∣ Nat.gcd m 6 :=
      Nat.dvd_gcd hord_m hord_6
    set d := Nat.gcd m 6 with hd_def
    have hdpos : 0 < d := Nat.gcd_pos_of_pos_left 6 hm_pos
    have hd_le : d ≤ m := Nat.le_of_dvd hm_pos (Nat.gcd_dvd_left m 6)
    have hd_lt : d < 6 := lt_of_le_of_lt hd_le hm_lt
    have hmk_d : (QuotientGroup.mk A : PSL2F11) ^ d = 1 :=
      orderOf_dvd_iff_pow_eq_one.mp hdvd
    have hAd' : A ^ d = 1 ∨ A ^ d = negI :=
      (mem_center_iff_one_or_negI _).mp
        ((mk_pow_eq_one_iff_pow_mem_center A d).mp hmk_d)
    have hd6 : d ∣ 6 := Nat.gcd_dvd_right m 6
    have hd123 : d = 1 ∨ d = 2 ∨ d = 3 := by
      have hdle6 : d ≤ 5 := Nat.lt_succ_iff.mp hd_lt
      interval_cases d
      · exact Or.inl rfl
      · exact Or.inr (Or.inl rfl)
      · exact Or.inr (Or.inr rfl)
      · exact absurd hd6 (by decide : ¬(4 ∣ 6))
      · exact absurd hd6 (by decide : ¬(5 ∣ 6))
    rcases hd123 with hd1 | hd2 | hd3
    · have hAd1 : A ^ 1 = 1 ∨ A ^ 1 = negI := by rwa [hd1] at hAd'
      exact not_pow_one_of_pslOrd_eq hn (by decide) hAd1
    · have hAd2 : A ^ 2 = 1 ∨ A ^ 2 = negI := by rwa [hd2] at hAd'
      exact (not_pow_center_of_pslOrd_gt (k := 2)
        (Or.inr (Or.inl rfl)) (by omega)) hAd2
    · have hAd3 : A ^ 3 = 1 ∨ A ^ 3 = negI := by rwa [hd3] at hAd'
      exact (not_pow_center_of_pslOrd_gt (k := 3)
        (Or.inr (Or.inr (Or.inl rfl))) (by omega)) hAd3
  · -- order 11
    rw [hn]
    refine (orderOf_eq_iff (by decide : 0 < 11)).2 ⟨hmk_of 11 hn (by decide), ?_⟩
    intro m hm_lt hm_pos hpowm
    have hord_m := orderOf_dvd_of_pow_eq_one hpowm
    have hord_11 := orderOf_dvd_of_pow_eq_one (hmk_of 11 hn (by decide))
    have hgcd : Nat.gcd m 11 = 1 := by
      have hprime : Nat.Prime 11 := Nat.prime_eleven
      have hg : Nat.gcd m 11 ∣ 11 := Nat.gcd_dvd_right m 11
      have hgi := (Nat.dvd_prime hprime).mp hg
      exact hgi.resolve_right (by
        have : Nat.gcd m 11 ≤ m := Nat.gcd_le_left 11 hm_pos
        omega)
    have hord1 : orderOf (QuotientGroup.mk A : PSL2F11) ∣ 1 :=
      (Nat.dvd_gcd hord_m hord_11).trans (by rw [hgcd])
    have hmk1 : (QuotientGroup.mk A : PSL2F11) = 1 :=
      orderOf_eq_one_iff.mp (Nat.dvd_one.mp hord1)
    have hAcent : A = 1 ∨ A = negI :=
      (mem_center_iff_one_or_negI A).mp ((QuotientGroup.eq_one_iff _).mp hmk1)
    exact not_pow_one_of_pslOrd_eq hn (by decide)
      (by simpa [pow_one] using hAcent)

/-! ## 2-to-1 quotient sum and PSL character norm

∑_A f(mk A) = 2 • ∑_g f(g) via fiber ≃ center, hence
∑_g χ(g)² = (1/2) · ∑_A χ(pslOrd A)² = 660. -/

noncomputable def lift (g : PSL2F11) : SLG :=
  Classical.choose (QuotientGroup.mk_surjective g)

theorem lift_spec (g : PSL2F11) : QuotientGroup.mk (lift g) = g :=
  Classical.choose_spec (QuotientGroup.mk_surjective g)

/-- Fiber of `mk` over `g` is equivariant to the center. -/
noncomputable def fiberEquiv (g : PSL2F11) :
    {A : SLG // QuotientGroup.mk A = g} ≃ Subgroup.center SLG where
  toFun := fun p =>
    ⟨(lift g)⁻¹ * p.1, by
      have hmk : QuotientGroup.mk ((lift g)⁻¹ * p.1) = (1 : PSL2F11) := by
        rw [QuotientGroup.mk_mul, QuotientGroup.mk_inv, p.2, lift_spec, inv_mul_cancel]
      exact (QuotientGroup.eq_one_iff _).mp hmk⟩
  invFun := fun z =>
    ⟨lift g * (z : SLG), by
      rw [QuotientGroup.mk_mul, (QuotientGroup.eq_one_iff _).mpr z.property, mul_one,
        lift_spec]⟩
  left_inv := fun p => by
    apply Subtype.ext
    change lift g * ((lift g)⁻¹ * p.1) = p.1
    group
  right_inv := fun z => by
    apply Subtype.ext
    change (lift g)⁻¹ * (lift g * (z : SLG)) = z
    group

theorem fiber_card (g : PSL2F11) :
    Fintype.card {A : SLG // QuotientGroup.mk A = g} = 2 := by
  rw [Fintype.card_congr (fiberEquiv g), ← Nat.card_eq_fintype_card, card_center_SL2]

/-- Pullback sum: ∑_A f(mk A) = 2 • ∑_g f(g). -/
theorem sum_comp_mk {β : Type*} [AddCommMonoid β] (f : PSL2F11 → β) :
    (∑ A : SLG, f (QuotientGroup.mk A)) = 2 • (∑ g : PSL2F11, f g) := by
  classical
  let π : SLG → PSL2F11 := QuotientGroup.mk
  let e : (Σ g : PSL2F11, {A : SLG // π A = g}) ≃ SLG := Equiv.sigmaFiberEquiv π
  have h1 :
      (∑ p : (Σ g : PSL2F11, {A : SLG // π A = g}), f (π (e p))) =
        (∑ A : SLG, f (π A)) :=
    Fintype.sum_equiv e (fun p => f (π (e p))) (fun A => f (π A)) (fun _ => rfl)
  have h2 : ∀ p : (Σ g : PSL2F11, {A : SLG // π A = g}), f (π (e p)) = f p.1 := by
    intro p
    have he : e p = p.2.1 := rfl
    have hπ : π (e p) = p.1 := by rw [he]; exact p.2.2
    rw [hπ]
  have h3 :
      (∑ p : (Σ g : PSL2F11, {A : SLG // π A = g}), f (π (e p))) =
        ∑ p : (Σ g : PSL2F11, {A : SLG // π A = g}), f p.1 :=
    Fintype.sum_congr _ _ h2
  have h4 :
      (∑ p : (Σ g : PSL2F11, {A : SLG // π A = g}), f p.1) =
        ∑ g : PSL2F11, ∑ _a : {A : SLG // π A = g}, f g := by
    rw [Fintype.sum_sigma]
  have h5 : ∀ g : PSL2F11,
      (∑ _a : {A : SLG // π A = g}, f g) = (2 : ℕ) • f g := by
    intro g
    have hc : Fintype.card {A : SLG // π A = g} = 2 := fiber_card g
    simp only [Finset.sum_const]
    have hcu : (Finset.univ : Finset {A : SLG // π A = g}).card =
        Fintype.card {A : SLG // π A = g} := rfl
    rw [hcu, hc]
  calc (∑ A : SLG, f (π A))
      = ∑ p : (Σ g : PSL2F11, {A : SLG // π A = g}), f (π (e p)) := h1.symm
    _ = ∑ p : (Σ g : PSL2F11, {A : SLG // π A = g}), f p.1 := h3
    _ = ∑ g : PSL2F11, ∑ _a : {A : SLG // π A = g}, f g := h4
    _ = ∑ g : PSL2F11, (2 : ℕ) • f g := Fintype.sum_congr _ _ h5
    _ = (2 : ℕ) • ∑ g : PSL2F11, f g := by simp only [Finset.smul_sum]

/-- Integer PSL character norm: ∑_g χ(orderOf g)² = 660. -/
theorem chi10Int_sum_sq_psl :
    (∑ g : PSL2F11,
      (chi10Int (orderOf g) : ℤ) * chi10Int (orderOf g)) = 660 := by
  have hSL :
      (∑ A : SLG, (chi10Int (pslOrd A) : ℤ) * chi10Int (pslOrd A)) = 1320 := by
    simpa [slChiSumSq] using slChiSumSq_eq
  have hrew :
      (∑ A : SLG, (chi10Int (pslOrd A) : ℤ) * chi10Int (pslOrd A)) =
        (∑ A : SLG, (chi10Int (orderOf (QuotientGroup.mk A : PSL2F11)) : ℤ) *
          chi10Int (orderOf (QuotientGroup.mk A : PSL2F11))) := by
    refine Fintype.sum_congr _ _ fun A => by rw [orderOf_mk_eq_pslOrd A]
  rw [hrew] at hSL
  have hdouble :=
    sum_comp_mk (fun g : PSL2F11 =>
      (chi10Int (orderOf g) : ℤ) * chi10Int (orderOf g))
  have h2S : (2 : ℕ) • (∑ g : PSL2F11,
      (chi10Int (orderOf g) : ℤ) * chi10Int (orderOf g)) = 1320 :=
    hdouble.symm.trans hSL
  have h2S' : (2 : ℤ) * (∑ g : PSL2F11,
      (chi10Int (orderOf g) : ℤ) * chi10Int (orderOf g)) = 1320 := by
    simpa [two_nsmul, two_mul] using h2S
  linarith

/-! ## Character convolution ∑ χ(g)χ(g⁻¹k) = 66 χ(k)

Via SL double-cover: `convAt B = 132 · χ(pslOrd B)`. Sealed by a raw 4-tuple
matrix model (`M4`) whose full O(|SL|²) failure count is natively zero
(~2 min compile), then bridged back to `SpecialLinearGroup`. -/

/-- Card of PSL elements of order `n` = half the SL projective-order count. -/
theorem card_psl_order (n : ℕ) :
    Fintype.card {g : PSL2F11 // orderOf g = n} = slCardOrder n / 2 := by
  classical
  let OrderSL := {A : SLG // pslOrd A = n}
  let OrderPSL := {g : PSL2F11 // orderOf g = n}
  have hSL : Fintype.card OrderSL = slCardOrder n := by
    rw [Fintype.card_subtype]; rfl
  let e : OrderSL ≃ (Σ g : OrderPSL, {A : SLG // QuotientGroup.mk A = (g : PSL2F11)}) :=
    { toFun := fun ⟨A, hA⟩ =>
        ⟨⟨QuotientGroup.mk A, by rw [orderOf_mk_eq_pslOrd, hA]⟩, ⟨A, rfl⟩⟩
      invFun := fun ⟨⟨_g, hg⟩, ⟨A, hmk⟩⟩ =>
        ⟨A, by rw [← orderOf_mk_eq_pslOrd A, hmk, hg]⟩
      left_inv := fun ⟨A, _⟩ => rfl
      right_inv := fun ⟨⟨g, hg⟩, ⟨A, hmk⟩⟩ => by cases hmk; rfl }
  have hsig :
      Fintype.card (Σ g : OrderPSL, {A : SLG // QuotientGroup.mk A = (g : PSL2F11)}) =
        Fintype.card OrderPSL * 2 := by
    rw [Fintype.card_sigma]
    have h2 : ∀ g : OrderPSL,
        Fintype.card {A : SLG // QuotientGroup.mk A = (g : PSL2F11)} = 2 :=
      fun g => fiber_card (g : PSL2F11)
    simp only [h2]
    calc ∑ _g : OrderPSL, 2
        = (Finset.univ : Finset OrderPSL).card * 2 := by
          rw [Finset.sum_const, smul_eq_mul, mul_comm]
      _ = Fintype.card OrderPSL * 2 := rfl
  have hEq : slCardOrder n = Fintype.card {g : PSL2F11 // orderOf g = n} * 2 := by
    calc slCardOrder n
        = Fintype.card OrderSL := hSL.symm
      _ = Fintype.card (Σ g : OrderPSL, {A : SLG // QuotientGroup.mk A = (g : PSL2F11)}) :=
            Fintype.card_congr e
      _ = Fintype.card OrderPSL * 2 := hsig
  omega

theorem card_psl_order_two :
    Fintype.card {g : PSL2F11 // orderOf g = 2} = 55 := by
  rw [card_psl_order, slCardOrder_two]

theorem card_psl_order_three :
    Fintype.card {g : PSL2F11 // orderOf g = 3} = 110 := by
  rw [card_psl_order, slCardOrder_three]

theorem card_psl_order_five :
    Fintype.card {g : PSL2F11 // orderOf g = 5} = 264 := by
  rw [card_psl_order, slCardOrder_five]

theorem card_psl_order_six :
    Fintype.card {g : PSL2F11 // orderOf g = 6} = 110 := by
  rw [card_psl_order, slCardOrder_six]

theorem card_psl_order_eleven :
    Fintype.card {g : PSL2F11 // orderOf g = 11} = 120 := by
  rw [card_psl_order, slCardOrder_eleven]

/-! ### Raw M4 model (fast native convolution) -/

/-- Raw 2×2 matrix as a 4-tuple `(a,b,c,d)` meaning `!![a,b; c,d]`. -/
abbrev M4 := F × F × F × F

def det4 (m : M4) : F := m.1 * m.2.2.2 - m.2.1 * m.2.2.1

def isSL4 (m : M4) : Bool := decide (det4 m = 1)

def mul4 (A B : M4) : M4 :=
  (A.1 * B.1 + A.2.1 * B.2.2.1,
   A.1 * B.2.1 + A.2.1 * B.2.2.2,
   A.2.2.1 * B.1 + A.2.2.2 * B.2.2.1,
   A.2.2.1 * B.2.1 + A.2.2.2 * B.2.2.2)

def one4 : M4 := (1, 0, 0, 1)
def negI4 : M4 := (-1, 0, 0, -1)

def pow4 : M4 → ℕ → M4
  | _, 0 => one4
  | A, n + 1 => mul4 (pow4 A n) A

def pslOrd4 (g : M4) : ℕ :=
  if pow4 g 1 = one4 || pow4 g 1 = negI4 then 1
  else if pow4 g 2 = one4 || pow4 g 2 = negI4 then 2
  else if pow4 g 3 = one4 || pow4 g 3 = negI4 then 3
  else if pow4 g 5 = one4 || pow4 g 5 = negI4 then 5
  else if pow4 g 6 = one4 || pow4 g 6 = negI4 then 6
  else if pow4 g 11 = one4 || pow4 g 11 = negI4 then 11
  else 0

def inv4 (A : M4) : M4 := (A.2.2.2, -A.2.1, -A.2.2.1, A.1)

def allSL4 : Finset M4 :=
  (Finset.univ : Finset M4).filter (fun m => isSL4 m = true)

theorem card_allSL4 : allSL4.card = 1320 := by native_decide

/-- Raw convolution ∑_{A ∈ SL} χ(ord A)·χ(ord(A⁻¹B)). -/
def conv4 (B : M4) : ℤ :=
  allSL4.sum fun A => chi10Int (pslOrd4 A) * chi10Int (pslOrd4 (mul4 (inv4 A) B))

def expected4 (B : M4) : ℤ := 132 * chi10Int (pslOrd4 B)

/-- Number of SL matrices failing the convolution identity. -/
def conv4FailCount : ℕ :=
  (allSL4.filter (fun B => !decide (conv4 B = expected4 B))).card

/-- Full SL convolution identity on the raw model (native, ~2 min). -/
theorem conv4FailCount_eq_zero : conv4FailCount = 0 := by native_decide

theorem conv4_eq (B : M4) (hB : B ∈ allSL4) :
    conv4 B = 132 * chi10Int (pslOrd4 B) := by
  change conv4 B = expected4 B
  by_contra hne
  have hmem : B ∈ allSL4.filter (fun B' => !decide (conv4 B' = expected4 B')) := by
    refine Finset.mem_filter.mpr ⟨hB, ?_⟩
    simp only [Bool.not_eq_eq_eq_not, Bool.not_true, decide_eq_false_iff_not]
    exact hne
  have hpos : 0 < conv4FailCount :=
    Finset.card_pos.mpr ⟨B, hmem⟩
  have hzero : conv4FailCount = 0 := conv4FailCount_eq_zero
  omega

/-! ### Bridge M4 ↔ SLG -/

def toM4 (g : SLG) : M4 :=
  let M : Matrix (Fin 2) (Fin 2) F := g
  (M 0 0, M 0 1, M 1 0, M 1 1)

theorem toM4_one : toM4 1 = one4 := by
  simp [toM4, one4, Matrix.one_apply]

theorem toM4_negI : toM4 negI = negI4 := by
  simp [toM4, negI, negI4, scalar, diagonal, Matrix.one_apply]

theorem toM4_mul (A B : SLG) : toM4 (A * B) = mul4 (toM4 A) (toM4 B) := by
  ext <;> simp [toM4, mul4, Matrix.mul_apply, Fin.sum_univ_two]

theorem toM4_pow (A : SLG) (n : ℕ) : toM4 (A ^ n) = pow4 (toM4 A) n := by
  induction n with
  | zero => simp [pow_zero, toM4_one, pow4]
  | succ n ih => rw [pow_succ, toM4_mul, ih]; rfl

theorem toM4_inv (A : SLG) : toM4 A⁻¹ = inv4 (toM4 A) := by
  -- Mathlib's explicit SL₂ inverse: A⁻¹ = !![d, -b; -c, a]
  rw [Matrix.SpecialLinearGroup.SL2_inv_expl A]
  simp [toM4, inv4]

theorem toM4_mem_allSL4 (A : SLG) : toM4 A ∈ allSL4 := by
  refine Finset.mem_filter.mpr ⟨Finset.mem_univ _, ?_⟩
  have hdet : (A : Matrix (Fin 2) (Fin 2) F).det = 1 := A.prop
  have : det4 (toM4 A) = 1 := by
    dsimp [det4, toM4]
    rwa [← Matrix.det_fin_two (A : Matrix (Fin 2) (Fin 2) F)]
  simpa [isSL4] using this

theorem toM4_injective : Function.Injective toM4 := by
  intro x y hxy
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j
  · simpa [toM4] using congrArg (fun m : M4 => m.1) hxy
  · simpa [toM4] using congrArg (fun m : M4 => m.2.1) hxy
  · simpa [toM4] using congrArg (fun m : M4 => m.2.2.1) hxy
  · simpa [toM4] using congrArg (fun m : M4 => m.2.2.2) hxy

theorem eq_one_iff_toM4 (A : SLG) : A = 1 ↔ toM4 A = one4 := by
  constructor
  · intro h; rw [h, toM4_one]
  · intro h; exact toM4_injective (h.trans toM4_one.symm)

theorem eq_negI_iff_toM4 (A : SLG) : A = negI ↔ toM4 A = negI4 := by
  constructor
  · intro h; rw [h, toM4_negI]
  · intro h; exact toM4_injective (h.trans toM4_negI.symm)

theorem pow_eq_one_or_negI_iff (A : SLG) (n : ℕ) :
    (A ^ n = 1 ∨ A ^ n = negI) ↔
      (pow4 (toM4 A) n = one4 ∨ pow4 (toM4 A) n = negI4) := by
  constructor
  · intro h
    rcases h with h | h
    · left; rw [← toM4_pow, h, toM4_one]
    · right; rw [← toM4_pow, h, toM4_negI]
  · intro h
    rcases h with h | h
    · left; exact toM4_injective (by rw [toM4_pow, h, toM4_one])
    · right; exact toM4_injective (by rw [toM4_pow, h, toM4_negI])

/-- `pslOrd` agrees with the raw 4-tuple projective order. -/
theorem pslOrd_eq_pslOrd4 (A : SLG) : pslOrd A = pslOrd4 (toM4 A) := by
  -- Both definitions are the same if-chain on equivalent predicates.
  unfold pslOrd pslOrd4
  have e1 := pow_eq_one_or_negI_iff A 1
  have e2 := pow_eq_one_or_negI_iff A 2
  have e3 := pow_eq_one_or_negI_iff A 3
  have e5 := pow_eq_one_or_negI_iff A 5
  have e6 := pow_eq_one_or_negI_iff A 6
  have e11 := pow_eq_one_or_negI_iff A 11
  -- Rewrite each boolean test
  simp only [Bool.or_eq_true, decide_eq_true_eq]
  -- Case-split on the six predicates; each side picks the same branch.
  rcases em (A ^ 1 = 1 ∨ A ^ 1 = negI) with h1 | h1
  · rw [if_pos h1, if_pos (e1.mp h1)]
  · rw [if_neg h1, if_neg (fun h => h1 (e1.mpr h))]
    rcases em (A ^ 2 = 1 ∨ A ^ 2 = negI) with h2 | h2
    · rw [if_pos h2, if_pos (e2.mp h2)]
    · rw [if_neg h2, if_neg (fun h => h2 (e2.mpr h))]
      rcases em (A ^ 3 = 1 ∨ A ^ 3 = negI) with h3 | h3
      · rw [if_pos h3, if_pos (e3.mp h3)]
      · rw [if_neg h3, if_neg (fun h => h3 (e3.mpr h))]
        rcases em (A ^ 5 = 1 ∨ A ^ 5 = negI) with h5 | h5
        · rw [if_pos h5, if_pos (e5.mp h5)]
        · rw [if_neg h5, if_neg (fun h => h5 (e5.mpr h))]
          rcases em (A ^ 6 = 1 ∨ A ^ 6 = negI) with h6 | h6
          · rw [if_pos h6, if_pos (e6.mp h6)]
          · rw [if_neg h6, if_neg (fun h => h6 (e6.mpr h))]
            rcases em (A ^ 11 = 1 ∨ A ^ 11 = negI) with h11 | h11
            · rw [if_pos h11, if_pos (e11.mp h11)]
            · rw [if_neg h11, if_neg (fun h => h11 (e11.mpr h))]

/-- Convolution on SL: ∑_A χ(A)·χ(A⁻¹B). -/
def convAt (B : SLG) : ℤ :=
  ∑ A : SLG, chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * B))

/-- Reconstruct `SLG` from a raw SL 4-tuple. -/
def ofM4 (m : M4) (hm : m ∈ allSL4) : SLG :=
  ⟨!![m.1, m.2.1; m.2.2.1, m.2.2.2], by
    have hdet4 : det4 m = 1 := by
      have h := (Finset.mem_filter.mp hm).2
      simpa [isSL4, decide_eq_true_eq] using h
    -- Goal: det !![a,b;c,d] = 1, and det4 m = a*d - b*c
    rw [Matrix.det_fin_two_of]
    simpa [det4] using hdet4⟩

theorem toM4_ofM4 (m : M4) (hm : m ∈ allSL4) : toM4 (ofM4 m hm) = m := by
  simp [toM4, ofM4, Matrix.of_apply]

theorem ofM4_toM4 (A : SLG) :
    ofM4 (toM4 A) (toM4_mem_allSL4 A) = A := by
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j <;> rfl

private def term4 (B : M4) (A : M4) : ℤ :=
  chi10Int (pslOrd4 A) * chi10Int (pslOrd4 (mul4 (inv4 A) B))

theorem convAt_eq_conv4 (B : SLG) : convAt B = conv4 (toM4 B) := by
  classical
  unfold convAt conv4
  let e : SLG ≃ {m // m ∈ allSL4} :=
    { toFun := fun A => ⟨toM4 A, toM4_mem_allSL4 A⟩
      invFun := fun m => ofM4 m.1 m.2
      left_inv := fun A => ofM4_toM4 A
      right_inv := fun m => by
        apply Subtype.ext
        exact toM4_ofM4 m.1 m.2 }
  have h1 :
      (∑ A : SLG, chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * B))) =
        ∑ m : {m // m ∈ allSL4}, term4 (toM4 B) m.1 := by
    refine Fintype.sum_equiv e _ _ fun A => ?_
    dsimp [e, term4]
    have hord1 := pslOrd_eq_pslOrd4 A
    have hord2 : pslOrd (A⁻¹ * B) =
        pslOrd4 (mul4 (inv4 (toM4 A)) (toM4 B)) := by
      rw [pslOrd_eq_pslOrd4, toM4_mul, toM4_inv]
    rw [hord1, hord2]
  have h2 :
      (∑ m : {m // m ∈ allSL4}, term4 (toM4 B) m.1) =
        allSL4.sum (term4 (toM4 B)) := by
    -- `{m // m ∈ s}` Fintype sum = sum over `s.attach`
    change (∑ m ∈ allSL4.attach, term4 (toM4 B) ↑m) =
      allSL4.sum (term4 (toM4 B))
    exact Finset.sum_attach allSL4 (term4 (toM4 B))
  exact h1.trans h2

/-- Convolution identity: `convAt B = 132 · χ(pslOrd B)`. -/
theorem convAt_eq (B : SLG) : convAt B = 132 * chi10Int (pslOrd B) := by
  rw [convAt_eq_conv4, pslOrd_eq_pslOrd4]
  exact conv4_eq (toM4 B) (toM4_mem_allSL4 B)

/-- Samples of projective orders. -/
def Smat : SLG := ⟨!![0, -1; 1, 0], by simp [Matrix.det_fin_two_of]⟩
theorem pslOrd_Smat : pslOrd Smat = 2 := by native_decide

def Tmat : SLG := ⟨!![1, 1; 0, 1], by simp [Matrix.det_fin_two_of]⟩
theorem pslOrd_Tmat : pslOrd Tmat = 11 := by native_decide

def el3 : SLG := ⟨!![0, -1; 1, -1], by simp [Matrix.det_fin_two_of]⟩
theorem pslOrd_el3 : pslOrd el3 = 3 := by native_decide

def el5 : SLG := ⟨!![0, -1; 1, 3], by simp [Matrix.det_fin_two_of]⟩
theorem pslOrd_el5 : pslOrd el5 = 5 := by native_decide

/-- Order-6 sample: `!![0,1; -1, 5]`. -/
def el6 : SLG := ⟨!![0, 1; -1, 5], by simp [Matrix.det_fin_two_of]⟩
theorem pslOrd_el6 : pslOrd el6 = 6 := by native_decide

/-- Spot-check: identity convolution value. -/
theorem convAt_one : convAt 1 = 1320 := by
  have h := convAt_eq (1 : SLG)
  have ho : pslOrd (1 : SLG) = 1 := by
    unfold pslOrd; simp [pow_one]
  simp only [ho, chi10Int] at h
  -- h : convAt 1 = 132 * 10
  exact h.trans (by norm_num)

/-- PSL convolution: ∑_g χ(g)χ(g⁻¹k) = 66 χ(k). -/
theorem chi10Int_convolution (k : PSL2F11) :
    (∑ g : PSL2F11, chi10Int (orderOf g) * chi10Int (orderOf (g⁻¹ * k))) =
      66 * chi10Int (orderOf k) := by
  obtain ⟨B, rfl⟩ := QuotientGroup.mk_surjective k
  set f : PSL2F11 → ℤ := fun g =>
    chi10Int (orderOf g) * chi10Int (orderOf (g⁻¹ * QuotientGroup.mk B))
  have hterm (A : SLG) :
      chi10Int (pslOrd A) * chi10Int (pslOrd (A⁻¹ * B)) = f (QuotientGroup.mk A) := by
    dsimp [f]
    rw [orderOf_mk_eq_pslOrd A, ← QuotientGroup.mk_inv, ← QuotientGroup.mk_mul,
      orderOf_mk_eq_pslOrd]
  have hSL : convAt B = ∑ A : SLG, f (QuotientGroup.mk A) := by
    unfold convAt
    exact Fintype.sum_congr _ _ hterm
  have hdouble := sum_comp_mk f
  have hconv := convAt_eq B
  have hord : orderOf (QuotientGroup.mk B : PSL2F11) = pslOrd B :=
    orderOf_mk_eq_pslOrd B
  have h2 : (2 : ℕ) • (∑ g : PSL2F11, f g) = 132 * chi10Int (pslOrd B) := by
    calc (2 : ℕ) • (∑ g : PSL2F11, f g)
        = ∑ A : SLG, f (QuotientGroup.mk A) := hdouble.symm
      _ = convAt B := hSL.symm
      _ = 132 * chi10Int (pslOrd B) := hconv
  have h2' : (2 : ℤ) * (∑ g : PSL2F11, f g) = 132 * chi10Int (pslOrd B) := by
    simpa [two_nsmul, two_mul] using h2
  dsimp [f]
  rw [hord]
  -- ∑ f = 66 χ from 2 * ∑ f = 132 χ
  have hmul : (2 : ℤ) * (∑ g : PSL2F11,
      chi10Int (orderOf g) *
        chi10Int (orderOf (g⁻¹ * QuotientGroup.mk B))) =
      (2 : ℤ) * (66 * chi10Int (pslOrd B)) := by
    rw [show f = fun g =>
      chi10Int (orderOf g) * chi10Int (orderOf (g⁻¹ * QuotientGroup.mk B)) from rfl] at h2'
    convert h2' using 1
    ring
  exact (mul_left_cancel₀ (by decide : (2 : ℤ) ≠ 0) hmul)

#print axioms card_PSL2_F11
#print axioms orderOf_mk_eq_pslOrd
#print axioms slChiSumSq_eq
#print axioms sum_comp_mk
#print axioms chi10Int_sum_sq_psl
#print axioms card_psl_order_two
#print axioms convAt_eq
#print axioms chi10Int_convolution

end PSLCard
end V14Formalization
