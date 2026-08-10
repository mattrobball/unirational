import V14Formalization.GeometricV14Carrier
import V14Formalization.PSLCard
import Mathlib.GroupTheory.GroupAction.ConjAct
import Mathlib.GroupTheory.Sylow
import Mathlib.GroupTheory.PGroup
import Mathlib.GroupTheory.Coset.Card
import Mathlib.GroupTheory.Index
import Mathlib.Data.Fintype.Card
import Mathlib.Data.Set.Card
import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Algebra.Group.Subgroup.Finite

open Module LinearMap ConjClasses
open V14Formalization.GeometricV14Carrier
open V14Formalization

set_option maxHeartbeats 40000000
set_option maxRecDepth 4096
noncomputable section

/-! ## Order-3 conjugacy: χ_Λ² = 0 on all order-3 elements -/

private abbrev rGen : PSL2F11 := CentralizerN.rotGen
private abbrev sGen : PSL2F11 := CentralizerN.reflGen
private abbrev r2 : PSL2F11 := rGen ^ 2

/-! ### Basic facts -/

theorem centralizer_rotGen_le_centralizer_rotGen_pow_two :
    Subgroup.centralizer ({rGen} : Set PSL2F11) ≤
      Subgroup.centralizer ({r2} : Set PSL2F11) := by
  intro g hg
  rw [Subgroup.mem_centralizer_singleton_iff] at hg ⊢
  have : g * (rGen * rGen) = (rGen * rGen) * g := by
    calc g * (rGen * rGen)
        = (g * rGen) * rGen := by rw [mul_assoc]
      _ = (rGen * g) * rGen := by rw [hg]
      _ = rGen * (g * rGen) := by rw [mul_assoc]
      _ = rGen * (rGen * g) := by rw [hg]
      _ = (rGen * rGen) * g := by rw [mul_assoc]
  simpa [pow_two] using this

private theorem sGen_mul_self : sGen * sGen = 1 := by
  have h := pow_orderOf_eq_one sGen
  rwa [orderOf_reflGen_psl, pow_two] at h

private theorem sGen_inv : sGen⁻¹ = sGen :=
  inv_eq_of_mul_eq_one_left sGen_mul_self

private theorem sGen_conj_rGen : sGen * rGen * sGen = rGen⁻¹ :=
  congrArg Subtype.val CentralizerN.reflGen_conj_rotGen

/-- s r² s = (r²)⁻¹ -/
private theorem sGen_conj_r2 : sGen * r2 * sGen = r2⁻¹ := by
  -- Expand r2 = r*r and insert s*s = 1 in the middle
  have h : sGen * rGen * rGen * sGen = rGen⁻¹ * rGen⁻¹ := by
    have hins :
        sGen * rGen * rGen * sGen =
          sGen * rGen * sGen * sGen * rGen * sGen := by
      calc sGen * rGen * rGen * sGen
          = sGen * rGen * (1 : PSL2F11) * rGen * sGen := by
            simp only [mul_one, mul_assoc]
        _ = sGen * rGen * (sGen * sGen) * rGen * sGen := by rw [← sGen_mul_self]
        _ = sGen * rGen * sGen * sGen * rGen * sGen := by simp only [mul_assoc]
    calc sGen * rGen * rGen * sGen
        = sGen * rGen * sGen * sGen * rGen * sGen := hins
      _ = (sGen * rGen * sGen) * (sGen * rGen * sGen) := by simp only [mul_assoc]
      _ = rGen⁻¹ * rGen⁻¹ := by rw [sGen_conj_rGen]
  calc sGen * r2 * sGen
      = sGen * (rGen ^ 2) * sGen := rfl
    _ = sGen * (rGen * rGen) * sGen := by rw [pow_two]
    _ = sGen * rGen * rGen * sGen := by simp only [mul_assoc]
    _ = rGen⁻¹ * rGen⁻¹ := h
    _ = (rGen⁻¹) ^ 2 := by rw [pow_two]
    _ = (rGen ^ 2)⁻¹ := by rw [← inv_pow]
    _ = r2⁻¹ := rfl

private theorem r2_inv_eq_pow_two : r2⁻¹ = r2 ^ 2 := by
  have hord : orderOf r2 = 3 := orderOf_rotGen_pow_two
  have h3 : r2 ^ 3 = 1 := by
    have := pow_orderOf_eq_one r2
    rwa [hord] at this
  -- r2 * r2^2 = r2^3 = 1 ⇒ r2⁻¹ = r2^2
  have hmul : r2 * r2 ^ 2 = 1 := by
    calc r2 * r2 ^ 2
        = r2 ^ 1 * r2 ^ 2 := by rw [pow_one]
      _ = r2 ^ (1 + 2) := (pow_add r2 1 2).symm
      _ = r2 ^ 3 := by norm_num
      _ = 1 := h3
  exact inv_eq_of_mul_eq_one_right hmul

private theorem sGen_conj_r2_as_pow : sGen * r2 * sGen = r2 ^ 2 := by
  rw [sGen_conj_r2, r2_inv_eq_pow_two]

/-- reflGen does not centralize r². -/
theorem reflGen_not_mem_centralizer_rotGen_pow_two :
    sGen ∉ Subgroup.centralizer ({r2} : Set PSL2F11) := by
  intro h
  rw [Subgroup.mem_centralizer_singleton_iff] at h
  have hsr2 : sGen * r2 = r2⁻¹ * sGen := by
    have := congrArg (fun z => z * sGen) sGen_conj_r2
    simpa [mul_assoc, sGen_mul_self] using this
  have hcancel : r2 = r2⁻¹ := mul_right_cancel (h.symm.trans hsr2)
  have hpow : r2 ^ 2 = 1 := by
    have := congrArg (fun z => z * r2) hcancel
    -- this: r2 * r2 = r2⁻¹ * r2
    have hL : r2 * r2 = r2 ^ 2 := (pow_two r2).symm
    have hR : r2⁻¹ * r2 = 1 := inv_mul_cancel r2
    rw [hL] at this
    rwa [hR] at this
  have hdvd : orderOf r2 ∣ 2 := orderOf_dvd_of_pow_eq_one hpow
  rw [orderOf_rotGen_pow_two] at hdvd
  exact absurd hdvd (by decide : ¬(3 ∣ 2))

/-! ### C({r2}) ≤ N(⟨r2⟩) -/

private theorem centralizer_r2_le_normalizer :
    Subgroup.centralizer ({r2} : Set PSL2F11) ≤
      Subgroup.normalizer (Subgroup.zpowers r2 : Set PSL2F11) := by
  intro g hg
  rw [Subgroup.mem_centralizer_singleton_iff] at hg
  -- g * r2 = r2 * g ⇒ g * r2 * g⁻¹ = r2
  have hconj : g * r2 * g⁻¹ = r2 := by
    calc g * r2 * g⁻¹
        = (g * r2) * g⁻¹ := by rw [mul_assoc]
      _ = (r2 * g) * g⁻¹ := by rw [hg]
      _ = r2 * (g * g⁻¹) := by rw [mul_assoc]
      _ = r2 := by rw [mul_inv_cancel, mul_one]
  -- so g conjugates powers of r2 to themselves
  refine Subgroup.mem_normalizer_fintype (S := (Subgroup.zpowers r2 : Set PSL2F11)) ?_
  intro n hn
  obtain ⟨k, rfl⟩ := Subgroup.mem_zpowers_iff.mp hn
  -- g * r2^k * g⁻¹ = (g r2 g⁻¹)^k = r2^k
  have : g * (r2 ^ k) * g⁻¹ = r2 ^ k := by
    rw [← conj_zpow, hconj]
  rw [this]
  exact Subgroup.mem_zpowers_iff.mpr ⟨k, rfl⟩

/-- s normalizes ⟨r2⟩. -/
private theorem sGen_mem_normalizer_r2 :
    sGen ∈ Subgroup.normalizer (Subgroup.zpowers r2 : Set PSL2F11) := by
  refine Subgroup.mem_normalizer_fintype (S := (Subgroup.zpowers r2 : Set PSL2F11)) ?_
  intro n hn
  obtain ⟨k, rfl⟩ := Subgroup.mem_zpowers_iff.mp hn
  -- s * r2^k * s⁻¹ = (s r2 s)^k = (r2^2)^k = r2^{2k}
  have hbase : sGen * r2 * sGen⁻¹ = r2 ^ (2 : ℤ) := by
    rw [sGen_inv, sGen_conj_r2_as_pow]
    exact (zpow_natCast r2 2).symm
  have : sGen * (r2 ^ k) * sGen⁻¹ = (r2 ^ (2 : ℤ)) ^ k := by
    rw [← conj_zpow, hbase]
  rw [this, ← zpow_mul]
  exact Subgroup.mem_zpowers_iff.mpr ⟨(2 : ℤ) * k, rfl⟩

/-! ### ⟨r²⟩ is Sylow 3; n₃ = 55; |N_G(⟨r²⟩)| = 12 -/

private theorem card_G : Nat.card PSL2F11 = 660 := by
  rw [Nat.card_eq_fintype_card, card_PSL2F11]

private theorem zpowers_r2_card : Nat.card (Subgroup.zpowers r2) = 3 := by
  rw [Nat.card_zpowers, orderOf_rotGen_pow_two]

private theorem zpowers_r2_index : (Subgroup.zpowers r2).index = 220 := by
  have hmul := Subgroup.index_mul_card (Subgroup.zpowers r2)
  rw [zpowers_r2_card, card_G] at hmul
  omega

private theorem zpowers_r2_isPGroup : IsPGroup 3 (Subgroup.zpowers r2) :=
  IsPGroup.of_card (n := 1) (by rw [zpowers_r2_card]; norm_num)

private theorem zpowers_r2_not_dvd_index : ¬(3 ∣ (Subgroup.zpowers r2).index) := by
  rw [zpowers_r2_index]; decide

private noncomputable def sylow_r2 : Sylow 3 PSL2F11 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  exact zpowers_r2_isPGroup.toSylow zpowers_r2_not_dvd_index

private theorem sylow_r2_coe :
    (sylow_r2 : Subgroup PSL2F11) = Subgroup.zpowers r2 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  exact IsPGroup.toSylow_coe zpowers_r2_isPGroup zpowers_r2_not_dvd_index

private theorem card_sylow3 (Q : Sylow 3 PSL2F11) : Nat.card Q = 3 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  rw [Sylow.card_eq_multiplicity]
  have hfac : Nat.factorization (Nat.card PSL2F11) 3 = 1 := by
    rw [card_G]; native_decide
  rw [hfac]; norm_num

private theorem orderOf_ne_one_of_mem_sylow3 (Q : Sylow 3 PSL2F11)
    (y : Q) (hne : (y : PSL2F11) ≠ 1) : orderOf (y : PSL2F11) = 3 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  haveI : Fintype Q := Fintype.ofFinite _
  -- Lagrange: y^{|Q|} = 1 in the finite group Q
  have hy_card : y ^ Fintype.card Q = 1 := pow_card_eq_one
  have hcardQ : Fintype.card Q = 3 := by
    have h := card_sylow3 Q
    rwa [Nat.card_eq_fintype_card] at h
  have hy3_Q : y ^ 3 = 1 := by rwa [hcardQ] at hy_card
  have hy3 : (y : PSL2F11) ^ 3 = 1 := by
    simpa [SubmonoidClass.coe_pow] using congrArg Subtype.val hy3_Q
  exact orderOf_eq_prime hy3 hne

/-- Non-identity elements of a Sylow 3-subgroup, as ambient group elements. -/
private abbrev sylow3NonId (Q : Sylow 3 PSL2F11) : Type :=
  {g : PSL2F11 // g ∈ (Q : Set PSL2F11) ∧ g ≠ 1}

private theorem card_sylow3NonId (Q : Sylow 3 PSL2F11) : Nat.card (sylow3NonId Q) = 2 := by
  classical
  haveI : Fintype Q := Fintype.ofFinite _
  have hcardQ : Nat.card Q = 3 := card_sylow3 Q
  -- Equiv with {y : Q // y ≠ 1}
  let e : sylow3NonId Q ≃ {y : Q // y ≠ 1} := by
    refine ⟨?toFun, ?invFun, ?li, ?ri⟩
    · intro ⟨g, hg, hne⟩
      exact ⟨⟨g, hg⟩, fun h => hne (congrArg Subtype.val h)⟩
    · intro ⟨y, hyne⟩
      exact ⟨(y : PSL2F11), y.property, fun h => hyne (Subtype.ext h)⟩
    · intro ⟨g, hg, hne⟩; rfl
    · intro ⟨y, hyne⟩; rfl
  haveI : Fintype {y : Q // y ≠ 1} := Fintype.ofFinite _
  haveI : Fintype {y : Q // y = 1} := Fintype.ofFinite _
  have hne : Nat.card {y : Q // y ≠ 1} = 2 := by
    have h1 : Fintype.card {y : Q // y = 1} = 1 := by
      rw [Fintype.card_eq_one_iff]
      exact ⟨⟨1, rfl⟩, fun z => Subtype.ext z.property⟩
    have hcompl := Fintype.card_subtype_compl (fun y : Q => y = 1)
    -- hcompl: card {¬ = 1} = card Q - card {= 1}; ≠ is ¬=
    calc Nat.card {y : Q // y ≠ 1}
        = Fintype.card {y : Q // y ≠ 1} := Nat.card_eq_fintype_card
      _ = Fintype.card Q - Fintype.card {y : Q // y = 1} := hcompl
      _ = Fintype.card Q - 1 := by rw [h1]
      _ = Nat.card Q - 1 := by rw [← Nat.card_eq_fintype_card]
      _ = 3 - 1 := by rw [hcardQ]
      _ = 2 := by norm_num
  rwa [Nat.card_congr e]

private noncomputable def sylowOfOrderThree
    (x : {g : PSL2F11 // orderOf g = 3}) : Sylow 3 PSL2F11 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  have hord : orderOf x.1 = 3 := x.2
  have hc : Nat.card (Subgroup.zpowers x.1) = 3 := by rw [Nat.card_zpowers, hord]
  have hIP : IsPGroup 3 (Subgroup.zpowers x.1) :=
    IsPGroup.of_card (n := 1) (by rw [hc]; norm_num)
  have hix : (Subgroup.zpowers x.1).index = 220 := by
    have hmul := Subgroup.index_mul_card (Subgroup.zpowers x.1)
    rw [hc, card_G] at hmul
    omega
  have hnd : ¬(3 ∣ (Subgroup.zpowers x.1).index) := by rw [hix]; decide
  exact hIP.toSylow hnd

private theorem sylowOfOrderThree_coe (x : {g : PSL2F11 // orderOf g = 3}) :
    (sylowOfOrderThree x : Subgroup PSL2F11) = Subgroup.zpowers x.1 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  simp only [sylowOfOrderThree]
  exact IsPGroup.toSylow_coe _ _

private theorem card_sylow3_eq_fifty_five : Nat.card (Sylow 3 PSL2F11) = 55 := by
  classical
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  haveI : Fintype (Sylow 3 PSL2F11) := Fintype.ofFinite _
  have hcard3 : Fintype.card {x : PSL2F11 // orderOf x = 3} = 110 :=
    PSLCard.card_psl_order_three
  -- Equiv: order-3 elements ↔ Σ Q, non-id ambient elements of Q
  let e : {g : PSL2F11 // orderOf g = 3} ≃
      Σ Q : Sylow 3 PSL2F11, sylow3NonId Q := by
    refine ⟨?toFun, ?invFun, ?left_inv, ?right_inv⟩
    · intro x
      refine ⟨sylowOfOrderThree x, ⟨x.1, ?mem, ?ne⟩⟩
      · have : x.1 ∈ Subgroup.zpowers x.1 := Subgroup.mem_zpowers x.1
        rwa [← sylowOfOrderThree_coe x] at this
      · intro heq
        have hord1 : orderOf (1 : PSL2F11) = 3 := by
          convert x.2; exact heq.symm
        exact absurd hord1 (by simp)
    · intro ⟨Q, ⟨g, hg, hne⟩⟩
      exact ⟨g, orderOf_ne_one_of_mem_sylow3 Q ⟨g, hg⟩ hne⟩
    · intro x; rfl
    · intro ⟨Q, ⟨g, hg, hne⟩⟩
      have hordy : orderOf g = 3 :=
        orderOf_ne_one_of_mem_sylow3 Q ⟨g, hg⟩ hne
      have hle : Subgroup.zpowers g ≤ (Q : Subgroup PSL2F11) :=
        Subgroup.zpowers_le.mpr hg
      have hcard_z : Nat.card (Subgroup.zpowers g) = 3 := by
        rw [Nat.card_zpowers, hordy]
      have hcard_Q := card_sylow3 Q
      have heq_sub : Subgroup.zpowers g = (Q : Subgroup PSL2F11) :=
        Subgroup.eq_of_le_of_card_ge hle (by rw [hcard_Q, hcard_z])
      have hsy : (sylowOfOrderThree ⟨g, hordy⟩ : Subgroup PSL2F11) =
          (Q : Subgroup PSL2F11) := by
        rw [sylowOfOrderThree_coe, heq_sub]
      have hQeq : sylowOfOrderThree ⟨g, hordy⟩ = Q := Sylow.ext hsy
      -- Σ Q, {g : G // g ∈ Q ∧ g ≠ 1} — subtype_ext with fixed base G
      exact Sigma.subtype_ext hQeq rfl
  have hsum : Nat.card {g : PSL2F11 // orderOf g = 3} =
      Nat.card (Sylow 3 PSL2F11) * 2 := by
    have heq_card := Nat.card_congr e
    -- Each fiber is finite (card 2)
    haveI : ∀ Q : Sylow 3 PSL2F11, Finite (sylow3NonId Q) := fun Q => by
      have h := card_sylow3NonId Q
      exact Nat.finite_of_card_ne_zero (by rw [h]; norm_num)
    have hsig : Nat.card (Σ Q : Sylow 3 PSL2F11, sylow3NonId Q) =
        ∑ Q : Sylow 3 PSL2F11, Nat.card (sylow3NonId Q) :=
      Nat.card_sigma
    calc Nat.card {g : PSL2F11 // orderOf g = 3}
        = Nat.card (Σ Q : Sylow 3 PSL2F11, sylow3NonId Q) := heq_card
      _ = ∑ Q : Sylow 3 PSL2F11, Nat.card (sylow3NonId Q) := hsig
      _ = ∑ _Q : Sylow 3 PSL2F11, (2 : ℕ) :=
          Finset.sum_congr rfl fun Q _ => card_sylow3NonId Q
      _ = Fintype.card (Sylow 3 PSL2F11) * 2 := by
          rw [Finset.sum_const, Finset.card_univ, smul_eq_mul, mul_comm]
      _ = Nat.card (Sylow 3 PSL2F11) * 2 := by rw [← Nat.card_eq_fintype_card]
  have : Nat.card (Sylow 3 PSL2F11) * 2 = 110 := by
    rw [← hsum, Nat.card_eq_fintype_card, hcard3]
  omega

private theorem card_normalizer_r2 :
    Nat.card (Subgroup.normalizer (Subgroup.zpowers r2 : Set PSL2F11)) = 12 := by
  haveI : Fact (Nat.Prime 3) := ⟨by decide⟩
  have hidx : Nat.card (Sylow 3 PSL2F11) =
      (Subgroup.normalizer (sylow_r2 : Set PSL2F11)).index :=
    Sylow.card_eq_index_normalizer sylow_r2
  have hN_eq : Subgroup.normalizer (Subgroup.zpowers r2 : Set PSL2F11) =
      Subgroup.normalizer (sylow_r2 : Set PSL2F11) := by
    -- carriers of sylow_r2 and zpowers r2 agree
    have hc : (sylow_r2 : Set PSL2F11) = (Subgroup.zpowers r2 : Set PSL2F11) := by
      change ((sylow_r2 : Subgroup PSL2F11) : Set PSL2F11) =
        (Subgroup.zpowers r2 : Set PSL2F11)
      rw [sylow_r2_coe]
    rw [hc]
  rw [hN_eq]
  have hmul :=
    Subgroup.index_mul_card (Subgroup.normalizer (sylow_r2 : Set PSL2F11))
  -- hmul: index * card N = card G; index = n_3 = 55
  rw [← hidx, card_sylow3_eq_fifty_five, card_G] at hmul
  -- 55 * Nat.card N = 660
  omega

/-! ### |C_G(r²)| = 6 -/

theorem card_centralizer_rotGen_pow_two :
    Nat.card (Subgroup.centralizer ({r2} : Set PSL2F11)) = 6 := by
  classical
  set_option maxRecDepth 4096 in
  let C := Subgroup.centralizer ({r2} : Set PSL2F11)
  let Cr := Subgroup.centralizer ({rGen} : Set PSL2F11)
  let N := Subgroup.normalizer (Subgroup.zpowers r2 : Set PSL2F11)
  have hle : Cr ≤ C := centralizer_rotGen_le_centralizer_rotGen_pow_two
  have hCr : Nat.card Cr = 6 := card_centralizer_rotGen
  have hdvd6 : 6 ∣ Nat.card C := by
    have h := Subgroup.card_dvd_of_le hle
    rwa [hCr] at h
  have hC_le_N : C ≤ N := centralizer_r2_le_normalizer
  have hNG : Nat.card N = 12 := card_normalizer_r2
  have hdvd12 : Nat.card C ∣ 12 := by
    have h := Subgroup.card_dvd_of_le hC_le_N
    rwa [hNG] at h
  have hrefl_norm : sGen ∈ N := sGen_mem_normalizer_r2
  have hnot12 : Nat.card C ≠ 12 := by
    intro h12
    have hCN : C = N := by
      have hs : (C : Set PSL2F11) ⊆ (N : Set PSL2F11) :=
        SetLike.coe_subset_coe.mpr hC_le_N
      have hC : (C : Set PSL2F11).ncard = Nat.card C :=
        (Nat.card_coe_set_eq (s := (C : Set PSL2F11))).symm
      have hN : (N : Set PSL2F11).ncard = Nat.card N :=
        (Nat.card_coe_set_eq (s := (N : Set PSL2F11))).symm
      have hcard : (N : Set PSL2F11).ncard ≤ (C : Set PSL2F11).ncard := by
        rw [hC, hN, h12, hNG]
      exact SetLike.coe_injective
        (Set.eq_of_subset_of_ncard_le hs hcard (Set.toFinite _))
    have : sGen ∈ C := by rw [hCN]; exact hrefl_norm
    exact reflGen_not_mem_centralizer_rotGen_pow_two this
  have hpos : 0 < Nat.card C := Nat.card_pos
  obtain ⟨k, hk⟩ := hdvd6
  have h6k : 6 * k ∣ 12 := by rwa [hk] at hdvd12
  have hk_le : k ≤ 2 := by
    have : 6 * k ≤ 12 := Nat.le_of_dvd (by decide : 0 < 12) h6k
    omega
  have hk_pos : 0 < k := by
    have : 0 < 6 * k := by rwa [← hk]
    omega
  have hcases : Nat.card C = 6 ∨ Nat.card C = 12 := by
    have : k = 1 ∨ k = 2 := by omega
    cases this with
    | inl h1 =>
      left
      calc Nat.card C = 6 * k := hk
        _ = 6 * 1 := by rw [h1]
        _ = 6 := by norm_num
    | inr h2 =>
      right
      calc Nat.card C = 6 * k := hk
        _ = 6 * 2 := by rw [h2]
        _ = 12 := by norm_num
  cases hcases with
  | inl h => exact h
  | inr h => exact absurd h hnot12

/-! ### Class size 110, conjugacy, χ_Λ² = 0 -/

theorem card_carrier_rotGen_pow_two :
    Fintype.card (ConjClasses.mk r2).carrier = 110 := by
  classical
  set_option maxRecDepth 4096 in
  have hG : Fintype.card PSL2F11 = 660 := card_PSL2F11
  have hcent : Nat.card (Subgroup.centralizer ({r2} : Set PSL2F11)) = 6 :=
    card_centralizer_rotGen_pow_two
  have heq : Nat.card (Subgroup.centralizer ({r2} : Set PSL2F11)) =
      Nat.card (MulAction.stabilizer (ConjAct PSL2F11) r2) :=
    Subgroup.nat_card_centralizer_nat_card_stabilizer (G := PSL2F11) r2
  have hstab_nat : Nat.card (MulAction.stabilizer (ConjAct PSL2F11) r2) = 6 :=
    heq.symm.trans hcent
  haveI : Fintype (MulAction.stabilizer (ConjAct PSL2F11) r2) := inferInstance
  have hstab : Fintype.card (MulAction.stabilizer (ConjAct PSL2F11) r2) = 6 := by
    rwa [← Nat.card_eq_fintype_card]
  have h := ConjClasses.card_carrier (G := PSL2F11) r2
  calc Fintype.card (ConjClasses.mk r2).carrier
      = Fintype.card PSL2F11 /
          Fintype.card (MulAction.stabilizer (ConjAct PSL2F11) r2) := h
    _ = 660 / 6 := by rw [hG, hstab]
    _ = 110 := by decide

theorem isConj_rotGen_pow_two_of_order_three {g : PSL2F11} (hg : orderOf g = 3) :
    IsConj r2 g := by
  classical
  have hordR : orderOf r2 = 3 := orderOf_rotGen_pow_two
  have hsub : (ConjClasses.mk r2).carrier ⊆ {x : PSL2F11 | orderOf x = 3} := by
    intro x hx
    have hmk : ConjClasses.mk x = ConjClasses.mk r2 := mem_carrier_iff_mk_eq.mp hx
    have hc : IsConj r2 x := isConj_comm.mp ((mk_eq_mk_iff_isConj).mp hmk)
    obtain ⟨c, hc'⟩ := isConj_iff.mp hc
    change orderOf x = 3
    calc orderOf x
        = orderOf (c * r2 * c⁻¹) := by rw [hc']
      _ = orderOf r2 := orderOf_conj _ c
      _ = 3 := hordR
  have hcl := card_carrier_rotGen_pow_two
  have h3 : Fintype.card {x : PSL2F11 // orderOf x = 3} = 110 :=
    PSLCard.card_psl_order_three
  let ι : (ConjClasses.mk r2).carrier → {x : PSL2F11 // orderOf x = 3} :=
    fun x => ⟨x.1, hsub x.2⟩
  have hι_inj : Function.Injective ι := by
    intro a b hab
    have hval : a.val = b.val := by
      have := congrArg (fun z : {x : PSL2F11 // orderOf x = 3} => z.val) hab
      simpa [ι] using this
    exact Subtype.ext hval
  have hcard_eq : Fintype.card (ConjClasses.mk r2).carrier =
      Fintype.card {x : PSL2F11 // orderOf x = 3} := by omega
  have hι_bi : Function.Bijective ι :=
    (Fintype.bijective_iff_injective_and_card ι).2 ⟨hι_inj, hcard_eq⟩
  obtain ⟨y, hy⟩ := hι_bi.surjective ⟨g, hg⟩
  have hcar : g ∈ (ConjClasses.mk r2).carrier := by
    have : (ι y).val = g := congrArg Subtype.val hy
    convert y.property; exact this.symm
  have hmk : ConjClasses.mk g = ConjClasses.mk r2 := mem_carrier_iff_mk_eq.mp hcar
  exact isConj_comm.mp ((mk_eq_mk_iff_isConj).mp hmk)

theorem chiLambda2_eq_zero_of_order_three {g : PSL2F11} (hg : orderOf g = 3) :
    chiLambda2 g = 0 := by
  have hc := isConj_rotGen_pow_two_of_order_three hg
  have h := chiLambda2_isConj hc
  rw [← h, chiLambda2_rotGen_pow_two]

theorem sum_chi_chiLambda2_order_three :
    (∑ g : {g : PSL2F11 // orderOf g = 3}, chi10' g.1 * chiLambda2 g.1) =
      (0 : k) := by
  classical
  refine Finset.sum_eq_zero fun g _ => ?_
  have ho : orderOf g.1 = 3 := g.2
  have hc : chi10' g.1 = (1 : k) := by simp [chi10', ho]
  have hΛ : chiLambda2 g.1 = 0 := chiLambda2_eq_zero_of_order_three ho
  rw [hc, hΛ, mul_zero]

#print axioms centralizer_rotGen_le_centralizer_rotGen_pow_two
#print axioms reflGen_not_mem_centralizer_rotGen_pow_two
#print axioms card_centralizer_rotGen_pow_two
#print axioms isConj_rotGen_pow_two_of_order_three
#print axioms chiLambda2_eq_zero_of_order_three
#print axioms sum_chi_chiLambda2_order_three
