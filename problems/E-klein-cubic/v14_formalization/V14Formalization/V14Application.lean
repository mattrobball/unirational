/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.

# V14 application — PSL(2,F₁₁), Cor 6.1 shape

Zero project axioms / zero `sorry` tokens.

* Centerless PSL(2,F₁₁) and involution σ: proved below.
* N = C_G(σ) ≃ D₁₂: proved in `CentralizerN`.
* Operational carrier `V14Variety`: **non-free** geometric coset space
  G/C₁₁ (C₁₁ = ⟨t⟩ unipotent order 11), projectively Dirac-embedded.
  Hyp (a)(b) proved without freeness of G (σ has no fixed coset; |N|=12 ∤ 11).
  See `GeometricCarrier.lean` and FAITHFULNESS_CHECK.md.
-/
import V14Formalization.CentralizerObstruction
import V14Formalization.CentralizerD12
import V14Formalization.GeometricCarrier
import Mathlib.GroupTheory.SpecificGroups.Dihedral
import Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup
import Mathlib.LinearAlgebra.Matrix.ProjectiveSpecialLinearGroup
import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.Field.ZMod
import Mathlib.Data.Nat.Prime.Defs
import Mathlib.GroupTheory.Subgroup.Center
import Mathlib.RepresentationTheory.Basic
import Mathlib.LinearAlgebra.FreeModule.Finite.Basic
import Mathlib.Algebra.Module.Pi
import Mathlib.LinearAlgebra.Projectivization.Basic

noncomputable section

open scoped MatrixGroups LinearAlgebra.Projectivization
open Matrix Matrix.SpecialLinearGroup

namespace V14Formalization
namespace V14App

/-! ## Field F₁₁ -/

instance fact_prime_eleven : Fact (Nat.Prime 11) := ⟨Nat.prime_eleven⟩

abbrev F := ZMod 11
abbrev SLG := SpecialLinearGroup (Fin 2) F
abbrev PSL2F11 : Type := PSL(2, F)

instance : Group PSL2F11 := inferInstance
instance : Fintype PSL2F11 := QuotientGroup.fintype _

private lemma F_two_ne : (2 : F) ≠ 0 := by decide
private lemma F_zero_ne_one : (0 : F) ≠ 1 := by decide

/-! ## Centerlessness of PSL(2, F₁₁) via elementary matrix calc -/

def Tmat : SLG := ⟨!![1, 1; 0, 1], by simp [Matrix.det_fin_two_of]⟩
def Umat : SLG := ⟨!![1, 0; 1, 1], by simp [Matrix.det_fin_two_of]⟩

lemma Tmat_val : Tmat.1 = !![1, 1; 0, 1] := rfl
lemma Umat_val : Umat.1 = !![1, 0; 1, 1] := rfl

/-- Central in PSL ⇒ commutator with every SL lift is central in SL. -/
lemma central_psl_comm_in_center (A : SLG)
    (hA : (QuotientGroup.mk A : PSL2F11) ∈ Subgroup.center PSL2F11) (B : SLG) :
    A * B * A⁻¹ * B⁻¹ ∈ Subgroup.center SLG := by
  have hcomm := Subgroup.mem_center_iff.mp hA (QuotientGroup.mk B)
  have heq : (QuotientGroup.mk (B * A) : PSL2F11) = QuotientGroup.mk (A * B) := by
    simpa only [QuotientGroup.mk_mul] using hcomm
  have hcent : A * B * (B * A)⁻¹ ∈ Subgroup.center SLG := by
    have : (QuotientGroup.mk (A * B * (B * A)⁻¹) : PSL2F11) = 1 := by
      rw [QuotientGroup.mk_mul, QuotientGroup.mk_inv, heq.symm, mul_inv_cancel]
    exact (QuotientGroup.eq_one_iff _).mp this
  convert hcent using 1
  simp [mul_assoc, _root_.mul_inv_rev]

/-- Commutator central ⇒ A B = (scalar r) B A with r² = 1. -/
lemma exists_r_comm (A B : SLG)
    (h : A * B * A⁻¹ * B⁻¹ ∈ Subgroup.center SLG) :
    ∃ r : F, r ^ (2 : ℕ) = 1 ∧ A.1 * B.1 = scalar (Fin 2) r * B.1 * A.1 := by
  obtain ⟨r, hr, hsc⟩ := (Matrix.SpecialLinearGroup.mem_center_iff (n := Fin 2) (R := F)).mp h
  refine ⟨r, by simpa [Fintype.card_fin] using hr, ?_⟩
  have heq : A * B = (A * B * A⁻¹ * B⁻¹) * B * A := by simp [mul_assoc]
  have heq1 : (A * B).1 = ((A * B * A⁻¹ * B⁻¹) * B * A).1 := congrArg (·.1) heq
  change A.1 * B.1 = (A * B * A⁻¹ * B⁻¹).1 * B.1 * A.1 at heq1
  rwa [hsc.symm] at heq1

private lemma sq_eq_one_cases (r : F) (hr : r ^ 2 = 1) : r = 1 ∨ r = -1 := by
  have hfac : (r - 1) * (r + 1) = 0 := by
    have h1 : r ^ 2 - 1 = 0 := by rw [hr, sub_self]
    convert h1 using 1; ring
  rcases mul_eq_zero.mp hfac with h | h
  · left; exact sub_eq_zero.mp h
  · right; exact eq_neg_of_add_eq_zero_left h

private lemma eq_zero_of_eq_neg (x : F) (h : x = -x) : x = 0 := by
  have h2x : (2 : F) * x = 0 := by
    have hx : x + x = x + (-x) := congrArg (fun t => x + t) h
    have hx0 : x + x = 0 := hx.trans (add_neg_cancel x)
    rwa [← two_mul] at hx0
  exact (mul_eq_zero.mp h2x).resolve_left F_two_ne

private lemma entry00 (M N : Matrix (Fin 2) (Fin 2) F) (h : M = N) :
    M 0 0 = N 0 0 := by rw [h]
private lemma entry01 (M N : Matrix (Fin 2) (Fin 2) F) (h : M = N) :
    M 0 1 = N 0 1 := by rw [h]
private lemma entry10 (M N : Matrix (Fin 2) (Fin 2) F) (h : M = N) :
    M 1 0 = N 1 0 := by rw [h]
private lemma entry11 (M N : Matrix (Fin 2) (Fin 2) F) (h : M = N) :
    M 1 1 = N 1 1 := by rw [h]

theorem mk_eq_one_of_mem_center (A : SLG)
    (hA : (QuotientGroup.mk A : PSL2F11) ∈ Subgroup.center PSL2F11) :
    (QuotientGroup.mk A : PSL2F11) = 1 := by
  obtain ⟨r, hr, hcommT⟩ :=
    exists_r_comm A Tmat (central_psl_comm_in_center A hA Tmat)
  have hL : A.1 * Tmat.1 =
      !![A.1 0 0, A.1 0 0 + A.1 0 1; A.1 1 0, A.1 1 0 + A.1 1 1] := by
    rw [Tmat_val]; ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two]
  have hR : scalar (Fin 2) r * Tmat.1 * A.1 =
      !![r * (A.1 0 0 + A.1 1 0), r * (A.1 0 1 + A.1 1 1);
         r * A.1 1 0, r * A.1 1 1] := by
    have hTM : Tmat.1 * A.1 =
        !![A.1 0 0 + A.1 1 0, A.1 0 1 + A.1 1 1; A.1 1 0, A.1 1 1] := by
      rw [Tmat_val]; ext i j; fin_cases i <;> fin_cases j <;>
        simp [Matrix.mul_apply, Fin.sum_univ_two]
    have hsc : scalar (Fin 2) r * (Tmat.1 * A.1) =
        !![r * (A.1 0 0 + A.1 1 0), r * (A.1 0 1 + A.1 1 1);
           r * A.1 1 0, r * A.1 1 1] := by
      rw [hTM]; ext i j; fin_cases i <;> fin_cases j <;>
        simp [scalar, diagonal, Matrix.mul_apply, Fin.sum_univ_two]
    calc scalar (Fin 2) r * Tmat.1 * A.1
        = scalar (Fin 2) r * (Tmat.1 * A.1) := by rw [mul_assoc]
      _ = _ := hsc
  have heq : A.1 * Tmat.1 = scalar (Fin 2) r * Tmat.1 * A.1 := hcommT
  rw [hL, hR] at heq
  have e00 := entry00 _ _ heq
  have e01 := entry01 _ _ heq
  have e10 := entry10 _ _ heq
  have e11 := entry11 _ _ heq
  change A.1 0 0 = r * (A.1 0 0 + A.1 1 0) at e00
  change A.1 0 0 + A.1 0 1 = r * (A.1 0 1 + A.1 1 1) at e01
  change A.1 1 0 = r * A.1 1 0 at e10
  change A.1 1 0 + A.1 1 1 = r * A.1 1 1 at e11
  rcases sq_eq_one_cases r hr with rfl | rfl
  · -- r = 1
    simp only [one_mul] at e00 e01 e10 e11
    have hc0 : A.1 1 0 = 0 := add_eq_left.mp e00.symm
    have had : A.1 0 0 = A.1 1 1 := by
      have e01' : A.1 0 0 + A.1 0 1 = A.1 1 1 + A.1 0 1 := by
        rw [e01, add_comm]
      exact add_right_cancel e01'
    have hdet : A.1.det = 1 := A.property
    have ha2 : A.1 0 0 * A.1 0 0 = 1 := by
      rw [Matrix.det_fin_two] at hdet
      simp only [hc0, mul_zero, sub_zero] at hdet
      calc A.1 0 0 * A.1 0 0 = A.1 0 0 * A.1 1 1 := by rw [had]
        _ = 1 := hdet
    obtain ⟨s, hs, hcommU⟩ :=
      exists_r_comm A Umat (central_psl_comm_in_center A hA Umat)
    have hL2 : A.1 * Umat.1 =
        !![A.1 0 0 + A.1 0 1, A.1 0 1; A.1 0 0, A.1 0 0] := by
      rw [Umat_val]
      ext i j; fin_cases i <;> fin_cases j <;>
        simp [Matrix.mul_apply, Fin.sum_univ_two, hc0, had]
    have hR2 : scalar (Fin 2) s * Umat.1 * A.1 =
        !![s * A.1 0 0, s * A.1 0 1; s * A.1 0 0, s * (A.1 0 0 + A.1 0 1)] := by
      have hUM : Umat.1 * A.1 =
          !![A.1 0 0, A.1 0 1; A.1 0 0, A.1 0 0 + A.1 0 1] := by
        rw [Umat_val]
        ext i j
        fin_cases i <;> fin_cases j <;>
          simp [Matrix.mul_apply, Fin.sum_univ_two, hc0, had, add_comm]
      have hsc : scalar (Fin 2) s * (Umat.1 * A.1) =
          !![s * A.1 0 0, s * A.1 0 1; s * A.1 0 0, s * (A.1 0 0 + A.1 0 1)] := by
        rw [hUM]; ext i j; fin_cases i <;> fin_cases j <;>
          simp [scalar, diagonal, Matrix.mul_apply, Fin.sum_univ_two]
      calc scalar (Fin 2) s * Umat.1 * A.1
          = scalar (Fin 2) s * (Umat.1 * A.1) := by rw [mul_assoc]
        _ = _ := hsc
    have heqU : A.1 * Umat.1 = scalar (Fin 2) s * Umat.1 * A.1 := hcommU
    rw [hL2, hR2] at heqU
    have f00 := entry00 _ _ heqU
    have f10 := entry10 _ _ heqU
    change A.1 0 0 + A.1 0 1 = s * A.1 0 0 at f00
    change A.1 0 0 = s * A.1 0 0 at f10
    rcases sq_eq_one_cases s hs with rfl | rfl
    · simp only [one_mul] at f00 f10
      have hb0 : A.1 0 1 = 0 := add_eq_left.mp f00
      have hAscal : A.1 = scalar (Fin 2) (A.1 0 0) := by
        ext i j; fin_cases i <;> fin_cases j <;>
          simp [scalar, diagonal, hc0, had, hb0]
      have hAc : A ∈ Subgroup.center SLG := by
        rw [Matrix.SpecialLinearGroup.mem_center_iff]
        refine ⟨A.1 0 0, ?_, hAscal.symm⟩
        simpa [Fintype.card_fin, pow_two] using ha2
      exact (QuotientGroup.eq_one_iff _).mpr hAc
    · have : A.1 0 0 = -A.1 0 0 := by simpa [neg_one_mul] using f10
      have a0 := eq_zero_of_eq_neg _ this
      exact absurd (by simpa [a0] using ha2) F_zero_ne_one
  · -- r = -1
    have hc0 : A.1 1 0 = 0 := by
      have : A.1 1 0 = -A.1 1 0 := by simpa [neg_one_mul] using e10
      exact eq_zero_of_eq_neg _ this
    have ha0 : A.1 0 0 = 0 := by
      have : A.1 0 0 = -(A.1 0 0 + A.1 1 0) := by simpa [neg_one_mul] using e00
      rw [hc0, add_zero] at this
      exact eq_zero_of_eq_neg _ this
    have hd0 : A.1 1 1 = 0 := by
      have : A.1 1 0 + A.1 1 1 = -A.1 1 1 := by simpa [neg_one_mul] using e11
      rw [hc0, zero_add] at this
      exact eq_zero_of_eq_neg _ this
    have hdet : A.1.det = 1 := A.property
    rw [Matrix.det_fin_two] at hdet
    simp only [ha0, hd0, hc0, mul_zero, sub_zero] at hdet
    exact absurd hdet F_zero_ne_one

theorem PSL2F11_isCenterless : IsCenterless PSL2F11 := by
  ext g
  constructor
  · intro hg
    obtain ⟨A, rfl⟩ := QuotientGroup.mk_surjective g
    simpa [Subgroup.mem_bot] using mk_eq_one_of_mem_center A hg
  · intro hg
    simp only [Subgroup.mem_bot] at hg
    subst g
    exact Subgroup.one_mem _

/-! ## Involution σ = image of S = [[0,-1],[1,0]] -/

def sigmaLift : SLG := ⟨!![0, -1; 1, 0], by simp [Matrix.det_fin_two_of]⟩

def sigma : PSL2F11 := QuotientGroup.mk sigmaLift

theorem sigma_isInvolution : IsInvolution sigma := by
  constructor
  · -- σ² = 1 in PSL because S² = -I ∈ Z(SL)
    have hmem : sigmaLift ^ 2 ∈ Subgroup.center SLG := by
      rw [Matrix.SpecialLinearGroup.mem_center_iff]
      refine ⟨(-1 : F), by decide, ?_⟩
      ext i j
      fin_cases i <;> fin_cases j <;>
        simp [sigmaLift, pow_two, Matrix.mul_apply, Fin.sum_univ_two, scalar, diagonal]
    change (QuotientGroup.mk sigmaLift : PSL2F11) ^ 2 = 1
    rw [← QuotientGroup.mk_pow]
    exact (QuotientGroup.eq_one_iff _).mpr hmem
  · intro h1
    have hc : sigmaLift ∈ Subgroup.center SLG :=
      (QuotientGroup.eq_one_iff _).mp h1
    rw [Matrix.SpecialLinearGroup.mem_center_iff] at hc
    obtain ⟨r, hr, heq⟩ := hc
    -- (0,0) entry of scalar r equals sigmaLift 0 0 = 0
    have hr0 : r = 0 := by
      have := congr_fun (congr_fun heq 0) 0
      simpa [sigmaLift, scalar, diagonal] using this
    have : (0 : F) ^ 2 = 1 := by
      simpa [hr0, Fintype.card_fin, pow_two] using hr
    exact absurd this (by decide : ¬(0 : F) ^ 2 = 1)

/-! ## Faithful regular representation over ℚ -/

abbrev k := ℚ
abbrev Reg := PSL2F11 → k

instance : AddCommGroup Reg := inferInstance
instance : Module k Reg := inferInstance
instance : Module.Free k Reg := inferInstance
instance : FiniteDimensional k Reg :=
  Module.Finite.equiv (Finsupp.linearEquivFunOnFinite k k PSL2F11)

def regularRep : FaithfulLinearRep k PSL2F11 Reg where
  ρ := {
    toFun := fun g => {
      toFun := fun f x => f (g⁻¹ * x)
      map_add' := fun _ _ => funext fun _ => rfl
      map_smul' := fun _ _ => funext fun _ => rfl
    }
    map_one' := by ext f x; simp
    map_mul' := fun g h => by ext f x; simp [mul_assoc]
  }
  finiteDimensional := inferInstance
  faithful := by
    intro g h heq
    -- ρ(g)=ρ(h) ⇒ for all x, g⁻¹*x = h⁻¹*x, via Dirac test functions
    have hpts : ∀ x, g⁻¹ * x = h⁻¹ * x := by
      intro x
      classical
      let f : Reg := fun z => if z = g⁻¹ * x then (1 : k) else 0
      have hf : f (g⁻¹ * x) = f (h⁻¹ * x) :=
        congr_fun (LinearMap.congr_fun heq f) x
      have hL : f (g⁻¹ * x) = 1 := by simp [f]
      have hR : f (h⁻¹ * x) = 1 := by rw [← hf, hL]
      -- f (h⁻¹ * x) = 1 ⇒ h⁻¹ * x = g⁻¹ * x
      dsimp [f] at hR
      split_ifs at hR with hmem
      · exact hmem.symm
      · exact absurd hR (by norm_num)
    -- specialize at x = 1: g⁻¹ = h⁻¹
    have : g⁻¹ = h⁻¹ := by simpa using hpts 1
    exact inv_injective this

/-! ## Geometric non-free carrier: G/C₁₁

Re-export the coset carrier from `GeometricCarrier`.  Point stabilizers have
order 11 (not free).  Hyp (a)(b) proved via fixed-locus emptiness of σ and N,
using |N|=12 ∤ 11 — not freeness of the G-action. -/

/-- Operational V14 carrier: left cosets of the order-11 unipotent C₁₁. -/
def V14Variety : SmoothProjectiveGVariety k PSL2F11 :=
  GeometricCarrier.V14Variety

theorem V14_hypothesisB : HypothesisB V14Variety (centralizer sigma) :=
  GeometricCarrier.V14_hypothesisB

theorem V14_hypothesisA : HypothesisA k V14Variety sigma :=
  GeometricCarrier.V14_hypothesisA

/-! ## Cor 6.1: centralizer obstruction on geometric non-free carrier -/

theorem V14_no_equivariant_map_from_faithful_rep :
    ∀ (V : Type) [AddCommGroup V] [Module k V] [Module.Free k V]
      (R : FaithfulLinearRep k PSL2F11 V),
      ¬ ReceivesFromRep V14Variety PSL2F11_isCenterless R :=
  centralizerObstruction (k := k) (G := PSL2F11)
    V14Variety sigma sigma_isInvolution PSL2F11_isCenterless
    V14_hypothesisA V14_hypothesisB

theorem V14_not_weakly_versal :
    NotWeaklyVersal V14Variety PSL2F11_isCenterless :=
  notWeaklyVersal_of_centralizerObstruction (k := k) (G := PSL2F11)
    V14Variety sigma sigma_isInvolution PSL2F11_isCenterless
    V14_hypothesisA V14_hypothesisB regularRep

theorem V14_not_GUnirational :
    ¬ IsGUnirational V14Variety PSL2F11_isCenterless :=
  not_GUnirational_of_centralizerObstruction (k := k) (G := PSL2F11)
    V14Variety sigma sigma_isInvolution PSL2F11_isCenterless
    V14_hypothesisA V14_hypothesisB

end V14App

/-! ## Writeup Input 1: N ≃ D₁₂ (proved in CentralizerN) -/

theorem V14_N_card_eq_12 :
    Fintype.card
      (Subgroup.centralizer ({CentralizerN.sigma} : Set CentralizerN.PSL2F11)) = 12 :=
  CentralizerN.centralizer_sigma_card

theorem V14_N_mulEquiv_dihedral :
    Nonempty
      (Subgroup.centralizer ({CentralizerN.sigma} : Set CentralizerN.PSL2F11) ≃*
        DihedralGroup 6) :=
  CentralizerN.centralizer_sigma_mulEquiv_dihedral

end V14Formalization
