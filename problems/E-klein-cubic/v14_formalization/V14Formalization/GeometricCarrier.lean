/-
Geometric Cor 6.1 carrier: left cosets G / C₁₁ with C₁₁ = ⟨t⟩ (t unipotent order 11).

Non-free G-set (point stabilizers order 11). Hyp (a)(b) without freeness of whole G:
* (a) Y^σ = ∅ (involution has no fixed coset)
* (b) Y^N = ∅ because |N| = 12 does not divide |C₁₁| = 11

N ≃ D₁₂ from `CentralizerN`. Dirac projective embedding of the finite coset space.
-/
import V14Formalization.CentralizerD12
import V14Formalization.Definitions
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.GroupTheory.GroupAction.Quotient
import Mathlib.GroupTheory.Coset.Card
import Mathlib.Algebra.Group.Subgroup.Finite
import Mathlib.Data.Fintype.BigOperators
import Mathlib.LinearAlgebra.Projectivization.Basic
import Mathlib.LinearAlgebra.FreeModule.Finite.Basic
import Mathlib.Algebra.Module.Pi
import Mathlib.Data.Int.ModEq

open scoped MatrixGroups LinearAlgebra.Projectivization
open Matrix Matrix.SpecialLinearGroup
open V14Formalization.CentralizerN

noncomputable section

namespace V14Formalization
namespace GeometricCarrier

set_option maxHeartbeats 8000000

/-! ## Unipotent generator of order 11 -/

def tMat : SLG := ⟨!![1, 1; 0, 1], by simp [Matrix.det_fin_two_of]⟩
def t : PSL2F11 := QuotientGroup.mk tMat

lemma tMat_pow (n : ℕ) : (tMat ^ n).1 = !![(1 : F), (n : F); 0, 1] := by
  induction n with
  | zero =>
    ext i j; fin_cases i <;> fin_cases j <;> simp [pow_zero]
  | succ n ih =>
    change ((tMat ^ n * tMat : SLG) : Matrix (Fin 2) (Fin 2) F) =
      !![(1 : F), ((n + 1 : ℕ) : F); 0, 1]
    have hmul : ((tMat ^ n * tMat : SLG) : Matrix (Fin 2) (Fin 2) F) =
        (tMat ^ n : Matrix (Fin 2) (Fin 2) F) * (tMat : Matrix (Fin 2) (Fin 2) F) := rfl
    rw [hmul, show (tMat ^ n : Matrix (Fin 2) (Fin 2) F) = !![(1 : F), (n : F); 0, 1] from ih]
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [tMat, Matrix.mul_apply, Fin.sum_univ_two, Nat.cast_succ]
    all_goals ring

lemma tMat_pow_eleven : tMat ^ 11 = 1 := by
  apply Subtype.ext
  rw [tMat_pow]
  ext i j; fin_cases i <;> fin_cases j <;> simp
  decide

lemma t_pow_eleven : t ^ 11 = 1 := by
  change (QuotientGroup.mk tMat : PSL2F11) ^ 11 = 1
  rw [← QuotientGroup.mk_pow, tMat_pow_eleven, QuotientGroup.mk_one]

lemma t_pow_ne_one (m : ℕ) (hm0 : 0 < m) (hm11 : m < 11) : t ^ m ≠ 1 := by
  intro h
  have hmk : (QuotientGroup.mk (tMat ^ m) : PSL2F11) = 1 := by
    rwa [show t = QuotientGroup.mk tMat from rfl, ← QuotientGroup.mk_pow] at h
  have hz : tMat ^ m ∈ Subgroup.center SLG := (QuotientGroup.eq_one_iff _).mp hmk
  rcases center_eq_one_or_negI _ hz with h1 | hneg
  · have h01 : (tMat ^ m).1 0 1 = 0 := by rw [h1]; simp
    have h01' : (m : F) = 0 := by rw [tMat_pow] at h01; simpa using h01
    have : 11 ∣ m := (ZMod.natCast_eq_zero_iff m 11).mp h01'
    exact absurd (Nat.eq_zero_of_dvd_of_lt this hm11) (Nat.pos_iff_ne_zero.mp hm0)
  · have h00 : (tMat ^ m).1 0 0 = -1 := by rw [hneg]; simp [negI]
    have : (1 : F) = -1 := by rw [tMat_pow] at h00; simpa using h00
    exact absurd this (by decide)

theorem orderOf_t : orderOf t = 11 :=
  (orderOf_eq_iff (by decide : 0 < 11)).2 ⟨t_pow_eleven,
    fun m hm11 hm0 h => t_pow_ne_one m hm0 hm11 h⟩

/-! ## C₁₁ and coset space -/

def C11 : Subgroup PSL2F11 := Subgroup.zpowers t
instance : DecidablePred (· ∈ C11) := by classical exact inferInstance
instance : Fintype C11 := Subtype.fintype _

lemma card_C11 : Fintype.card C11 = 11 := by
  classical
  change Fintype.card (Subgroup.zpowers t) = 11
  rw [Fintype.card_zpowers, orderOf_t]

abbrev P1geom := PSL2F11 ⧸ C11
instance : MulAction PSL2F11 P1geom := inferInstance
instance : Fintype P1geom := QuotientGroup.fintype _
instance : DecidableEq P1geom := Quotient.decidableEq

/-! ## Involution σ -/

lemma sigma_mul_self : sigma * sigma = 1 := by
  have hmem : Smat ^ 2 ∈ Subgroup.center SLG := by
    rw [Matrix.SpecialLinearGroup.mem_center_iff]
    refine ⟨(-1 : F), by decide, ?_⟩
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [Smat, pow_two, Matrix.mul_apply, Fin.sum_univ_two, scalar, diagonal]
  change (QuotientGroup.mk Smat : PSL2F11) * QuotientGroup.mk Smat = 1
  rw [← QuotientGroup.mk_mul, ← pow_two]
  exact (QuotientGroup.eq_one_iff _).mpr hmem

lemma sigma_ne_one : sigma ≠ 1 := by
  intro h1
  have hc : Smat ∈ Subgroup.center SLG := (QuotientGroup.eq_one_iff _).mp h1
  rcases center_eq_one_or_negI _ hc with h1' | hneg
  · have : (0 : F) = 1 := by
      simpa [Smat] using congrArg (fun M : SLG => M.1 0 0) h1'
    exact absurd this (by decide)
  · have : (0 : F) = -1 := by
      simpa [Smat, negI] using congrArg (fun M : SLG => M.1 0 0) hneg
    exact absurd this (by decide)

theorem sigma_isInvolution : IsInvolution sigma :=
  ⟨by simpa [pow_two] using sigma_mul_self, sigma_ne_one⟩

lemma C11_no_order_two {g : PSL2F11} (hg : g ∈ C11) (h2 : g * g = 1) : g = 1 := by
  have hord : orderOf (⟨g, hg⟩ : C11) ∣ 11 := by
    have := orderOf_dvd_card (x := (⟨g, hg⟩ : C11))
    rwa [card_C11] at this
  have hord2 : orderOf (⟨g, hg⟩ : C11) ∣ 2 :=
    orderOf_dvd_of_pow_eq_one (by exact Subtype.ext (by simpa [pow_two] using h2))
  have hdiv1 : orderOf (⟨g, hg⟩ : C11) ∣ 1 := by
    have := Nat.dvd_gcd hord hord2; simpa using this
  have hsub : (⟨g, hg⟩ : C11) = 1 := orderOf_eq_one_iff.mp (Nat.dvd_one.mp hdiv1)
  exact congrArg Subtype.val hsub

/-! ## Fixed-locus inputs -/

theorem sigma_no_fixed_coset (x : P1geom) : sigma • x ≠ x := by
  intro hx
  obtain ⟨g, rfl⟩ := Quotient.exists_rep x
  have heq : (QuotientGroup.mk g : P1geom) = QuotientGroup.mk (sigma * g) := by
    simpa [MulAction.Quotient.smul_mk, smul_eq_mul] using hx.symm
  have hmem0 : g⁻¹ * (sigma * g) ∈ C11 := (QuotientGroup.eq).mp heq
  have hmem : g⁻¹ * sigma * g ∈ C11 := by simpa [mul_assoc] using hmem0
  have h2 : (g⁻¹ * sigma * g) * (g⁻¹ * sigma * g) = 1 := by
    calc g⁻¹ * sigma * g * (g⁻¹ * sigma * g)
        = g⁻¹ * sigma * (g * g⁻¹) * sigma * g := by simp [mul_assoc]
      _ = g⁻¹ * sigma * sigma * g := by simp
      _ = g⁻¹ * (sigma * sigma) * g := by simp [mul_assoc]
      _ = g⁻¹ * 1 * g := by rw [sigma_mul_self]
      _ = 1 := by simp
  have heq1 : g⁻¹ * sigma * g = 1 := C11_no_order_two hmem h2
  have : sigma = 1 := by
    calc sigma = g * (g⁻¹ * sigma * g) * g⁻¹ := by simp [mul_assoc]
      _ = g * 1 * g⁻¹ := by rw [heq1]
      _ = 1 := by simp
  exact sigma_ne_one this

theorem N_no_fixed_coset :
    ¬ ∃ x : P1geom, ∀ n : Subgroup.centralizer ({sigma} : Set PSL2F11),
      (n : PSL2F11) • x = x := by
  intro ⟨x, hx⟩
  obtain ⟨g, rfl⟩ := Quotient.exists_rep x
  -- Build the conjugation monoid hom N → C11
  let toC11 (n : Subgroup.centralizer ({sigma} : Set PSL2F11)) : C11 :=
    ⟨g⁻¹ * (n : PSL2F11) * g, by
      have h : (n : PSL2F11) • (QuotientGroup.mk g : P1geom) =
          (QuotientGroup.mk g : P1geom) := hx n
      have hmk : (n : PSL2F11) • (QuotientGroup.mk g : P1geom) =
          QuotientGroup.mk ((n : PSL2F11) * g) := by
        simpa [smul_eq_mul] using
          (MulAction.Quotient.smul_mk (H := C11) (n : PSL2F11) g)
      have hsmul : (QuotientGroup.mk ((n : PSL2F11) * g) : P1geom) =
          (QuotientGroup.mk g : P1geom) := (hmk.symm.trans h)
      have heq : (QuotientGroup.mk g : P1geom) =
          (QuotientGroup.mk ((n : PSL2F11) * g) : P1geom) := hsmul.symm
      have hmem : g⁻¹ * ((n : PSL2F11) * g) ∈ C11 := (QuotientGroup.eq).mp heq
      simpa [mul_assoc] using hmem⟩
  let φ : Subgroup.centralizer ({sigma} : Set PSL2F11) →* C11 :=
    { toFun := toC11
      map_one' := by ext; simp [toC11]
      map_mul' := fun a b => by ext; simp [toC11, mul_assoc] }
  have hinj : Function.Injective φ := by
    intro a b heq
    apply Subtype.ext
    have hval : g⁻¹ * (a : PSL2F11) * g = g⁻¹ * (b : PSL2F11) * g :=
      congrArg Subtype.val heq
    calc (a : PSL2F11)
        = g * (g⁻¹ * (a : PSL2F11) * g) * g⁻¹ := by simp [mul_assoc]
      _ = g * (g⁻¹ * (b : PSL2F11) * g) * g⁻¹ := by rw [hval]
      _ = (b : PSL2F11) := by simp [mul_assoc]
  have hdiv : Nat.card (Subgroup.centralizer ({sigma} : Set PSL2F11)) ∣ Nat.card C11 :=
    Subgroup.card_dvd_of_injective φ hinj
  have hdiv' : Fintype.card (Subgroup.centralizer ({sigma} : Set PSL2F11)) ∣
      Fintype.card C11 := by simpa [Nat.card_eq_fintype_card] using hdiv
  rw [centralizer_sigma_card, card_C11] at hdiv'
  exact absurd hdiv' (by decide : ¬(12 ∣ 11))

/-! ## Faithfulness: normalCore C₁₁ = ⊥ -/

def tLowerMat : SLG := ⟨!![1, 0; -1, 1], by simp [Matrix.det_fin_two_of]⟩

lemma Smat_inv : Smat⁻¹ = negI * Smat := by
  apply inv_eq_of_mul_eq_one_left
  apply Subtype.ext
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Smat, negI, SpecialLinearGroup.coe_mul, Matrix.mul_apply,
      Fin.sum_univ_two, Matrix.neg_apply]

lemma conj_sigma_t_mat : Smat * tMat * Smat⁻¹ = tLowerMat := by
  rw [Smat_inv]
  apply Subtype.ext
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Smat, tMat, tLowerMat, negI, SpecialLinearGroup.coe_mul,
      Matrix.mul_apply, Fin.sum_univ_two, Matrix.neg_apply]

lemma conj_sigma_t : sigma * t * sigma⁻¹ = QuotientGroup.mk tLowerMat := by
  have hmk : QuotientGroup.mk (Smat * tMat * Smat⁻¹) =
      (QuotientGroup.mk Smat : PSL2F11) * QuotientGroup.mk tMat *
        (QuotientGroup.mk Smat)⁻¹ := by
    simp [QuotientGroup.mk_mul, QuotientGroup.mk_inv, mul_assoc]
  rw [conj_sigma_t_mat] at hmk
  simpa [sigma, t, mul_assoc] using hmk.symm

lemma mem_C11_exists_nat_pow {g : PSL2F11} (hg : g ∈ C11) :
    ∃ n : ℕ, n < 11 ∧ g = t ^ n := by
  obtain ⟨k, hk⟩ := (Subgroup.mem_zpowers_iff).mp hg
  have hmod : t ^ (k % (11 : ℤ)) = t ^ k := by
    have := zpow_mod_orderOf t k
    rwa [orderOf_t] at this
  have hnn : (0 : ℤ) ≤ k % 11 := Int.emod_nonneg _ (by decide : (11 : ℤ) ≠ 0)
  have hlt : (k % 11).toNat < 11 := by
    have hbound : k % 11 < 11 := Int.emod_lt_of_pos _ (by decide : (0 : ℤ) < 11)
    exact (Int.toNat_lt hnn).mpr hbound
  refine ⟨(k % 11).toNat, hlt, ?_⟩
  calc g = t ^ k := hk.symm
    _ = t ^ (k % (11 : ℤ)) := hmod.symm
    _ = t ^ ((k % 11).toNat : ℕ) := by
        rw [← zpow_natCast]; congr 1; exact (Int.toNat_of_nonneg hnn).symm

lemma t_pow_eq_mk (n : ℕ) : t ^ n = QuotientGroup.mk (tMat ^ n) := by
  simp [t, QuotientGroup.mk_pow]

lemma mk_tLower_not_mem_C11 :
    (QuotientGroup.mk tLowerMat : PSL2F11) ∉ C11 := by
  intro hmem
  obtain ⟨n, _, heq⟩ := mem_C11_exists_nat_pow hmem
  have heq' : (QuotientGroup.mk tLowerMat : PSL2F11) =
      QuotientGroup.mk (tMat ^ n) := by rwa [t_pow_eq_mk n] at heq
  have hcent : tLowerMat⁻¹ * tMat ^ n ∈ Subgroup.center SLG :=
    (QuotientGroup.eq).mp heq'
  rcases center_eq_one_or_negI _ hcent with h1 | hneg
  · have heqMat : tLowerMat = tMat ^ n := by
      have := congrArg (fun z => tLowerMat * z) h1
      simpa using this.symm
    have h10 := congrArg (fun M : SLG => M.1 1 0) heqMat
    rw [tMat_pow] at h10
    -- h10 : -1 = 0 after simp
    have h10' : (-1 : F) = 0 := by simpa [tLowerMat] using h10
    exact absurd h10' (by decide)
  · have heqMat : tMat ^ n = tLowerMat * negI := by
      have := congrArg (fun z => tLowerMat * z) hneg
      simpa using this
    have hL : (tMat ^ n).1 0 0 = (1 : F) := by rw [tMat_pow]; simp
    have hR : (tLowerMat * negI).1 0 0 = (-1 : F) := by
      change (tLowerMat.1 * negI.1) 0 0 = -1
      simp [tLowerMat, negI, Matrix.mul_apply, Fin.sum_univ_two, Matrix.neg_apply]
    have : (1 : F) = -1 :=
      hL.symm.trans ((congrArg (fun M : SLG => M.1 0 0) heqMat).trans hR)
    exact absurd this (by decide)

lemma C11_not_normal : ¬ C11.Normal := by
  intro hN
  have hconj : sigma * t * sigma⁻¹ ∈ C11 :=
    hN.conj_mem t (Subgroup.mem_zpowers t) sigma
  rw [conj_sigma_t] at hconj
  exact mk_tLower_not_mem_C11 hconj

lemma normalCore_C11_eq_bot : C11.normalCore = ⊥ := by
  by_contra hne
  have hle : C11.normalCore ≤ C11 := Subgroup.normalCore_le _
  have hcard_dvd : Nat.card C11.normalCore ∣ Nat.card C11 :=
    Subgroup.card_dvd_of_le hle
  have hcard_dvd' : Nat.card C11.normalCore ∣ 11 := by
    simpa [Nat.card_eq_fintype_card, card_C11] using hcard_dvd
  have hne1 : Nat.card C11.normalCore ≠ 1 := by
    intro h1
    exact hne ((Subgroup.card_eq_one).mp h1)
  have hcard11 : Nat.card C11.normalCore = 11 := by
    rcases (Nat.dvd_prime (by decide : Nat.Prime 11)).mp hcard_dvd' with h1 | h11
    · exact (hne1 h1).elim
    · exact h11
  haveI : Finite (C11 : Subgroup PSL2F11) := inferInstance
  have heq : C11.normalCore = C11 :=
    Subgroup.eq_of_le_of_card_ge (H := C11.normalCore) (K := C11) hle (by
      rw [hcard11, Nat.card_eq_fintype_card, card_C11])
  have hNorm : C11.Normal := by
    have : (C11.normalCore).Normal := Subgroup.normalCore_normal (H := C11)
    rwa [heq] at this
  exact C11_not_normal hNorm

theorem coset_action_faithful (g : PSL2F11)
    (hg : ∀ x : P1geom, g • x = x) : g = 1 := by
  have hgker : g ∈ (MulAction.toPermHom PSL2F11 P1geom).ker := by
    rw [MonoidHom.mem_ker]; ext x; exact hg x
  have hgcore : g ∈ C11.normalCore := by rwa [Subgroup.normalCore_eq_ker]
  have : g ∈ (⊥ : Subgroup PSL2F11) := by rwa [normalCore_C11_eq_bot] at hgcore
  exact Subgroup.mem_bot.mp this

/-! ## Dirac projective embedding -/

abbrev k := ℚ
abbrev CosetMod := P1geom → k

instance : AddCommGroup CosetMod := inferInstance
instance : Module k CosetMod := inferInstance
instance : Module.Free k CosetMod := inferInstance
instance : FiniteDimensional k CosetMod :=
  Module.Finite.equiv (Finsupp.linearEquivFunOnFinite k k P1geom)

def diracCoset (x : P1geom) : CosetMod := fun y => if y = x then (1 : k) else 0

lemma diracCoset_ne (x : P1geom) : diracCoset x ≠ 0 := by
  intro h
  have : (diracCoset x) x = 0 := by rw [h]; rfl
  simp [diracCoset] at this

def cosetEmbed : P1geom ↪ ℙ k CosetMod where
  toFun x := Projectivization.mk k (diracCoset x) (diracCoset_ne x)
  inj' := by
    intro x y heq
    rw [Projectivization.mk_eq_mk_iff] at heq
    obtain ⟨μ, hμ⟩ := heq
    have hxx : diracCoset x x = (1 : k) := by simp [diracCoset]
    have hval0 : ((μ : k) • diracCoset y) x = diracCoset x x :=
      congrArg (fun f : CosetMod => f x) hμ
    have hval : (μ : k) * diracCoset y x = (1 : k) := by
      calc (μ : k) * diracCoset y x = ((μ : k) • diracCoset y) x := by
            rw [Pi.smul_apply, smul_eq_mul]
        _ = diracCoset x x := hval0
        _ = 1 := hxx
    by_cases hxy : x = y
    · exact hxy
    · have hz : diracCoset y x = 0 := by simp [diracCoset, hxy]
      rw [hz, mul_zero] at hval
      exact absurd hval (by norm_num)

/-! ## Smooth projective G-variety on G/C₁₁ (linear-projective data) -/

/-- Linear G-action on Dirac ambient `CosetMod = P1geom → k`. -/
def cosetAmbientAct (g : PSL2F11) : CosetMod →ₗ[k] CosetMod where
  toFun := fun f x => f (g⁻¹ • x)
  map_add' := fun _ _ => funext fun _ => rfl
  map_smul' := fun _ _ => funext fun _ => rfl

lemma cosetAmbientAct_one : cosetAmbientAct 1 = LinearMap.id := by
  apply LinearMap.ext; intro f; funext x
  simp [cosetAmbientAct]

lemma cosetAmbientAct_mul (g h : PSL2F11) :
    cosetAmbientAct (g * h) = cosetAmbientAct g ∘ₗ cosetAmbientAct h := by
  apply LinearMap.ext; intro f; funext x
  simp only [cosetAmbientAct, LinearMap.comp_apply, LinearMap.coe_mk, AddHom.coe_mk]
  rw [_root_.mul_inv_rev, mul_smul]

lemma cosetAmbientAct_injective (g : PSL2F11) :
    Function.Injective (cosetAmbientAct g) := by
  intro a b hab
  funext y
  have h' := congr_fun hab (g • y)
  simp only [cosetAmbientAct, LinearMap.coe_mk, AddHom.coe_mk, inv_smul_smul] at h'
  exact h'

lemma diracCoset_smul (g : PSL2F11) (x : P1geom) :
    cosetAmbientAct g (diracCoset x) = diracCoset (g • x) := by
  funext y
  simp only [cosetAmbientAct, diracCoset, LinearMap.coe_mk, AddHom.coe_mk]
  by_cases hy : y = g • x
  · subst hy; simp [inv_smul_smul]
  · have hne : g⁻¹ • y ≠ x := fun he => hy (by rw [← he, smul_inv_smul])
    simp [hy, hne]

lemma cosetEmbed_smul (g : PSL2F11) (x : P1geom) :
    cosetEmbed (g • x) =
      Projectivization.map (cosetAmbientAct g) (cosetAmbientAct_injective g)
        (cosetEmbed x) := by
  dsimp [cosetEmbed]
  have hmap :=
    (Projectivization.map_mk (σ := RingHom.id k) (cosetAmbientAct g)
      (cosetAmbientAct_injective g) (diracCoset x) (diracCoset_ne x))
  rw [hmap]
  apply Projectivization.submodule_injective
  simp only [Projectivization.submodule_mk]
  rw [diracCoset_smul]

def V14Variety : SmoothProjectiveGVariety k PSL2F11 where
  X := P1geom
  ambient := CosetMod
  ambientAdd := inferInstance
  ambientModule := inferInstance
  ambientFree := inferInstance
  ambientFD := inferInstance
  embed := cosetEmbed
  smul := fun g x => g • x
  one_smul' := fun x => one_smul _ x
  mul_smul' := fun g h x => mul_smul g h x
  faithful := coset_action_faithful
  ambientAct := cosetAmbientAct
  ambientAct_one := cosetAmbientAct_one
  ambientAct_mul := cosetAmbientAct_mul
  embed_smul := cosetEmbed_smul

/-! ## Hyp (a)(b) without freeness of G -/

theorem V14_hypothesisB : HypothesisB V14Variety (centralizer sigma) := by
  change V14Variety.fixedBy (centralizer sigma) = ∅
  apply Set.eq_empty_iff_forall_notMem.mpr
  intro y hy
  apply N_no_fixed_coset
  refine ⟨y, fun n => ?_⟩
  -- fixedBy uses structure smul = ambient coset smul
  have h := hy n
  -- h : V14Variety.smul ↑n y = y
  change (n : PSL2F11) • (y : P1geom) = y
  exact h

theorem V14_hypothesisA : HypothesisA k V14Variety sigma := by
  intro S hS hRCC
  have hempty : V14Variety.fixedByElement sigma = ∅ := by
    apply Set.eq_empty_iff_forall_notMem.mpr
    intro y hy
    have hy' : V14Variety.smul sigma y = y := hy
    have hy'' : sigma • (y : P1geom) = y := hy'
    exact (sigma_no_fixed_coset y hy'').elim
  -- S ⊆ ∅ from hempty and hS
  have hSempty : S = ∅ := by
    ext x
    constructor
    · intro hx; exact (hempty ▸ hS) hx
    · intro hx; exact hx.elim
  -- but IsRCC with finrank ≥ 1 forces embed '' S nonempty, so S nonempty
  rcases hRCC with ⟨W, hdim, hSeq⟩
  have hneW : W ≠ ⊥ := by
    intro hbot
    have : Module.finrank k W = 0 := by rw [hbot, finrank_bot]
    omega
  obtain ⟨v, hv, hvne⟩ := Submodule.exists_mem_ne_zero_of_ne_bot hneW
  have : (V14Variety.embed '' S).Nonempty := by
    rw [hSeq]
    refine ⟨Projectivization.mk k v hvne, ?_⟩
    change (k ∙ v : Submodule k CosetMod) ≤ W
    exact (Submodule.span_singleton_le_iff_mem _ _).mpr hv
  rcases this with ⟨_, ⟨x, hxS, _⟩⟩
  have : x ∈ (∅ : Set P1geom) := by rwa [hSempty] at hxS
  exact this.elim

#print axioms orderOf_t
#print axioms sigma_no_fixed_coset
#print axioms N_no_fixed_coset
#print axioms coset_action_faithful
#print axioms V14_hypothesisA
#print axioms V14_hypothesisB

end GeometricCarrier
end V14Formalization
