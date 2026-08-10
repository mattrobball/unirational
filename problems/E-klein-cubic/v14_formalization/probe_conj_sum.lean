import V14Formalization.GeometricV14Carrier
import V14Formalization.PSLCard
import Mathlib.GroupTheory.GroupAction.ConjAct
import Mathlib.GroupTheory.Coset.Card
import Mathlib.Data.Fintype.Card

open Module LinearMap ConjClasses
open V14Formalization.GeometricV14Carrier
open V14Formalization

set_option maxHeartbeats 32000000
noncomputable section

/-! ## |C_G(rotGen)| = 6 → conjugacy of order-6 → χ_Λ² = 0 -/

theorem mem_centralizer_sigma_of_mem_centralizer_rotGen
    {g : PSL2F11}
    (h : g ∈ Subgroup.centralizer ({(CentralizerN.rotGen : PSL2F11)} : Set PSL2F11)) :
    g ∈ Subgroup.centralizer ({sigma} : Set PSL2F11) := by
  rw [Subgroup.mem_centralizer_singleton_iff] at h ⊢
  have hr3 : (CentralizerN.rotGen : PSL2F11) ^ 3 = sigma := rotGen_pow_three_eq_sigma
  have hcomm (n : ℕ) :
      g * (CentralizerN.rotGen : PSL2F11) ^ n =
        (CentralizerN.rotGen : PSL2F11) ^ n * g := by
    induction n with
    | zero => simp
    | succ n ih =>
      calc g * ((CentralizerN.rotGen : PSL2F11) ^ n * CentralizerN.rotGen)
          = (g * (CentralizerN.rotGen : PSL2F11) ^ n) * CentralizerN.rotGen := by
            rw [← mul_assoc]
        _ = ((CentralizerN.rotGen : PSL2F11) ^ n * g) * CentralizerN.rotGen := by rw [ih]
        _ = (CentralizerN.rotGen : PSL2F11) ^ n * (g * CentralizerN.rotGen) := by
            rw [mul_assoc]
        _ = (CentralizerN.rotGen : PSL2F11) ^ n * (CentralizerN.rotGen * g) := by rw [h]
        _ = ((CentralizerN.rotGen : PSL2F11) ^ n * CentralizerN.rotGen) * g := by
            rw [mul_assoc]
  have hpow : g * (CentralizerN.rotGen : PSL2F11) ^ 3 =
      (CentralizerN.rotGen : PSL2F11) ^ 3 * g := by
    simpa only [← pow_succ'] using hcomm 3
  rwa [hr3] at hpow

theorem centralizer_rotGen_le_centralizer_sigma :
    Subgroup.centralizer ({(CentralizerN.rotGen : PSL2F11)} : Set PSL2F11) ≤
      Subgroup.centralizer ({sigma} : Set PSL2F11) :=
  fun _ hx => mem_centralizer_sigma_of_mem_centralizer_rotGen hx

theorem reflGen_not_mem_centralizer_rotGen :
    (CentralizerN.reflGen : PSL2F11) ∉
      Subgroup.centralizer ({(CentralizerN.rotGen : PSL2F11)} : Set PSL2F11) := by
  intro h
  rw [Subgroup.mem_centralizer_singleton_iff] at h
  have hmr : (CentralizerN.rotGen : PSL2F11) * CentralizerN.reflGen =
      CentralizerN.reflGen * ((CentralizerN.rotGen : PSL2F11)⁻¹) :=
    congrArg Subtype.val CentralizerN.rotGen_mul_reflGen
  have heq : (CentralizerN.reflGen : PSL2F11) * CentralizerN.rotGen =
      CentralizerN.reflGen * ((CentralizerN.rotGen : PSL2F11)⁻¹) := by
    calc (CentralizerN.reflGen : PSL2F11) * CentralizerN.rotGen
        = CentralizerN.rotGen * CentralizerN.reflGen := h
      _ = CentralizerN.reflGen * ((CentralizerN.rotGen : PSL2F11)⁻¹) := hmr
  have hcancel : (CentralizerN.rotGen : PSL2F11) =
      (CentralizerN.rotGen : PSL2F11)⁻¹ := mul_left_cancel heq
  have hpow2 : (CentralizerN.rotGen : PSL2F11) ^ 2 = 1 := by
    have h1 : (CentralizerN.rotGen : PSL2F11) * CentralizerN.rotGen =
        (CentralizerN.rotGen : PSL2F11) *
          ((CentralizerN.rotGen : PSL2F11)⁻¹) := by
      exact congrArg (fun z => (CentralizerN.rotGen : PSL2F11) * z) hcancel
    rw [pow_two, h1]
    exact mul_inv_cancel (CentralizerN.rotGen : PSL2F11)
  have : orderOf (CentralizerN.rotGen : PSL2F11) ∣ 2 :=
    orderOf_dvd_of_pow_eq_one hpow2
  rw [orderOf_rotGen_psl] at this
  exact absurd this (by decide : ¬(6 ∣ 2))

theorem card_centralizer_rotGen :
    Nat.card (Subgroup.centralizer
      ({(CentralizerN.rotGen : PSL2F11)} : Set PSL2F11)) = 6 := by
  classical
  let C : Subgroup PSL2F11 :=
    Subgroup.centralizer ({(CentralizerN.rotGen : PSL2F11)} : Set PSL2F11)
  -- Use CentralizerN.sigma so Fintype instance from CentralizerD12 applies
  let N : Subgroup PSL2F11 :=
    Subgroup.centralizer ({CentralizerN.sigma} : Set PSL2F11)
  have hle : C ≤ N := by
    intro g hg
    have : g ∈ Subgroup.centralizer ({sigma} : Set PSL2F11) :=
      mem_centralizer_sigma_of_mem_centralizer_rotGen hg
    rwa [show sigma = CentralizerN.sigma from sigma_eq_CentralizerN_sigma] at this
  have hNcard : Nat.card N = 12 := by
    rw [Nat.card_eq_fintype_card]
    exact CentralizerN.centralizer_sigma_card
  have hrot_mem : (CentralizerN.rotGen : PSL2F11) ∈ C := by
    rw [Subgroup.mem_centralizer_singleton_iff]
  haveI : Fintype N := inferInstance
  haveI : Fintype C :=
    Fintype.ofInjective (Subgroup.inclusion hle) (Subgroup.inclusion_injective hle)
  have hdvd6 : 6 ∣ Nat.card C := by
    let x : C := ⟨CentralizerN.rotGen, hrot_mem⟩
    have hord : orderOf x = 6 := by
      rw [Subgroup.orderOf_mk, orderOf_rotGen_psl]
    have h := orderOf_dvd_card (x := x)
    rwa [hord, ← Nat.card_eq_fintype_card] at h
  have hdvd12 : Nat.card C ∣ 12 := by
    have h := Subgroup.card_dvd_of_le hle
    rwa [hNcard] at h
  have hCneN : C ≠ N := by
    intro hCN
    have hmem : (CentralizerN.reflGen : PSL2F11) ∈ N :=
      CentralizerN.reflGen.property
    have hmemC : (CentralizerN.reflGen : PSL2F11) ∈ C := hCN ▸ hmem
    exact reflGen_not_mem_centralizer_rotGen hmemC
  have hnot12 : Nat.card C ≠ 12 := by
    intro h12
    have hCN : C = N := by
      have hs : (C : Set PSL2F11) ⊆ (N : Set PSL2F11) := SetLike.coe_subset_coe.mpr hle
      have hC : (C : Set PSL2F11).ncard = Nat.card C :=
        (Nat.card_coe_set_eq (s := (C : Set PSL2F11))).symm
      have hN : (N : Set PSL2F11).ncard = Nat.card N :=
        (Nat.card_coe_set_eq (s := (N : Set PSL2F11))).symm
      have hcard : (N : Set PSL2F11).ncard ≤ (C : Set PSL2F11).ncard := by
        rw [hC, hN, h12, hNcard]
      have heq : (C : Set PSL2F11) = (N : Set PSL2F11) :=
        Set.eq_of_subset_of_ncard_le hs hcard (Set.toFinite _)
      exact SetLike.coe_injective heq
    exact hCneN hCN
  -- 6 | n, n | 12, n > 0 ⇒ n = 6 or 12
  have hpos : 0 < Nat.card C := Nat.card_pos
  obtain ⟨k, hk⟩ := hdvd6
  have h6k : 6 * k ∣ 12 := by
    rwa [hk] at hdvd12
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

theorem card_carrier_rotGen :
    Fintype.card (ConjClasses.mk (CentralizerN.rotGen : PSL2F11)).carrier = 110 := by
  classical
  set_option maxRecDepth 4096 in
  have hG : Fintype.card PSL2F11 = 660 := card_PSL2F11
  let g0 : PSL2F11 := CentralizerN.rotGen
  have hcent : Nat.card (Subgroup.centralizer ({g0} : Set PSL2F11)) = 6 := by
    change Nat.card (Subgroup.centralizer
      ({(CentralizerN.rotGen : PSL2F11)} : Set PSL2F11)) = 6
    exact card_centralizer_rotGen
  have heq : Nat.card (Subgroup.centralizer ({g0} : Set PSL2F11)) =
      Nat.card (MulAction.stabilizer (ConjAct PSL2F11) g0) :=
    Subgroup.nat_card_centralizer_nat_card_stabilizer (G := PSL2F11) g0
  have hstab_nat : Nat.card (MulAction.stabilizer (ConjAct PSL2F11) g0) = 6 :=
    heq.symm.trans hcent
  haveI : Fintype (MulAction.stabilizer (ConjAct PSL2F11) g0) :=
    inferInstance
  have hstab : Fintype.card (MulAction.stabilizer (ConjAct PSL2F11) g0) = 6 := by
    rwa [← Nat.card_eq_fintype_card]
  have h := ConjClasses.card_carrier (G := PSL2F11) g0
  change Fintype.card (ConjClasses.mk g0).carrier = 110
  calc Fintype.card (ConjClasses.mk g0).carrier
      = Fintype.card PSL2F11 /
          Fintype.card (MulAction.stabilizer (ConjAct PSL2F11) g0) := h
    _ = 660 / 6 := by rw [hG, hstab]
    _ = 110 := by decide

theorem isConj_rotGen_of_order_six {g : PSL2F11} (hg : orderOf g = 6) :
    IsConj (CentralizerN.rotGen : PSL2F11) g := by
  classical
  have hordR : orderOf (CentralizerN.rotGen : PSL2F11) = 6 := orderOf_rotGen_psl
  have hsub : (ConjClasses.mk (CentralizerN.rotGen : PSL2F11)).carrier ⊆
      {x : PSL2F11 | orderOf x = 6} := by
    intro x hx
    have hmk : ConjClasses.mk x = ConjClasses.mk (CentralizerN.rotGen : PSL2F11) :=
      mem_carrier_iff_mk_eq.mp hx
    have hc : IsConj (CentralizerN.rotGen : PSL2F11) x :=
      isConj_comm.mp ((mk_eq_mk_iff_isConj).mp hmk)
    obtain ⟨c, hc'⟩ := isConj_iff.mp hc
    change orderOf x = 6
    calc orderOf x
        = orderOf (c * CentralizerN.rotGen * c⁻¹) := by rw [hc']
      _ = orderOf (CentralizerN.rotGen : PSL2F11) := orderOf_conj _ c
      _ = 6 := hordR
  have hcl := card_carrier_rotGen
  have h6 : Fintype.card {x : PSL2F11 // orderOf x = 6} = 110 :=
    PSLCard.card_psl_order_six
  let ι : (ConjClasses.mk (CentralizerN.rotGen : PSL2F11)).carrier →
      {x : PSL2F11 // orderOf x = 6} := fun x => ⟨x.1, hsub x.2⟩
  have hι_inj : Function.Injective ι := by
    intro a b hab
    have hval : a.val = b.val := by
      have := congrArg (fun z : {x : PSL2F11 // orderOf x = 6} => z.val) hab
      simpa [ι] using this
    exact Subtype.ext hval
  have hcard_eq : Fintype.card (ConjClasses.mk (CentralizerN.rotGen : PSL2F11)).carrier =
      Fintype.card {x : PSL2F11 // orderOf x = 6} := by omega
  have hι_bi : Function.Bijective ι :=
    (Fintype.bijective_iff_injective_and_card ι).2 ⟨hι_inj, hcard_eq⟩
  obtain ⟨y, hy⟩ := hι_bi.surjective ⟨g, hg⟩
  have hcar : g ∈ (ConjClasses.mk (CentralizerN.rotGen : PSL2F11)).carrier := by
    have : (ι y).val = g := congrArg Subtype.val hy
    convert y.property; exact this.symm
  have hmk : ConjClasses.mk g = ConjClasses.mk (CentralizerN.rotGen : PSL2F11) :=
    mem_carrier_iff_mk_eq.mp hcar
  exact isConj_comm.mp ((mk_eq_mk_iff_isConj).mp hmk)

theorem chiLambda2_eq_zero_of_order_six {g : PSL2F11} (hg : orderOf g = 6) :
    chiLambda2 g = 0 := by
  have hc := isConj_rotGen_of_order_six hg
  have h := chiLambda2_isConj hc
  rw [← h, chiLambda2_rotGen]

theorem sum_chi_chiLambda2_order_six :
    (∑ g : {g : PSL2F11 // orderOf g = 6}, chi10' g.1 * chiLambda2 g.1) =
      (0 : k) := by
  classical
  refine Finset.sum_eq_zero fun g _ => ?_
  have ho : orderOf g.1 = 6 := g.2
  have hc : chi10' g.1 = (-1 : k) := by simp [chi10', ho]
  have hΛ : chiLambda2 g.1 = 0 := chiLambda2_eq_zero_of_order_six ho
  rw [hc, hΛ, mul_zero]

#print axioms mem_centralizer_sigma_of_mem_centralizer_rotGen
#print axioms reflGen_not_mem_centralizer_rotGen
#print axioms card_centralizer_rotGen
#print axioms card_carrier_rotGen
#print axioms isConj_rotGen_of_order_six
#print axioms chiLambda2_eq_zero_of_order_six
#print axioms sum_chi_chiLambda2_order_six
