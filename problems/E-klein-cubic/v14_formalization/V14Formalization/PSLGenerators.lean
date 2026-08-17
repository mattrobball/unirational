/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.PSLCard
public import V14Formalization.GeometricCarrier

/-!
# Two generators for `PSL₂(F₁₁)`

This file proves structurally that the images of the standard Fourier and
translation matrices generate `PSL₂(F₁₁)`.  The proof uses the two Bruhat
cells and explicit unipotent/diagonal word identities; it does not enumerate
the 660 group elements.
-/

open Matrix Matrix.SpecialLinearGroup

noncomputable section

namespace V14Formalization
namespace PSLGenerators

public abbrev F := ZMod 11
public abbrev SLG := PSLCard.SLG
public abbrev G := SLG ⧸ Subgroup.center SLG

def Nraw (t : F) : Matrix (Fin 2) (Fin 2) F := !![1, t; 0, 1]
def Wraw : Matrix (Fin 2) (Fin 2) F := !![0, -1; 1, 0]
def Draw (t : F) : Matrix (Fin 2) (Fin 2) F := !![t, 0; 0, t⁻¹]

def Nmat (t : F) : SLG :=
  ⟨Nraw t, by simp [Nraw, Matrix.det_fin_two_of]⟩

def Dmat (t : F) (ht : t ≠ 0) : SLG :=
  ⟨Draw t, by
    unfold Draw
    rw [Matrix.det_fin_two_of]
    rw [mul_inv_cancel₀ ht]
    simp⟩

theorem Nmat_eq_Tmat_pow (t : F) : Nmat t = PSLCard.Tmat ^ t.val := by
  apply Subtype.ext
  rw [show PSLCard.Tmat = GeometricCarrier.tMat by rfl]
  rw [GeometricCarrier.tMat_pow]
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Nmat, Nraw]

theorem Smat_sq : PSLCard.Smat * PSLCard.Smat = -1 := by
  apply Subtype.ext
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [PSLCard.Smat, Matrix.mul_apply, Fin.sum_univ_two, Matrix.neg_apply]

theorem neg_Dmat_word (t : F) (ht : t ≠ 0) :
    Nmat t * PSLCard.Smat * Nmat t⁻¹ * PSLCard.Smat *
        Nmat t * PSLCard.Smat = -Dmat t ht := by
  apply Subtype.ext
  change Nraw t * Wraw * Nraw t⁻¹ * Wraw * Nraw t * Wraw = -Draw t
  ext i j
  have ht' : t * t⁻¹ = 1 := mul_inv_cancel₀ ht
  have ht'' : t⁻¹ * t = 1 := inv_mul_cancel₀ ht
  fin_cases i <;> fin_cases j <;>
    simp [Nraw, Wraw, Draw, Matrix.mul_apply, Fin.sum_univ_two]
  case «0».«0» => left; rw [ht']; simp
  case «0».«1» => rw [ht']; simp
  case «1».«0» => rw [ht'']; simp

theorem Dmat_mem_closure (t : F) (ht : t ≠ 0) :
    QuotientGroup.mk (Dmat t ht) ∈
      Subgroup.closure ({QuotientGroup.mk PSLCard.Smat,
        QuotientGroup.mk PSLCard.Tmat} : Set G) := by
  let H : Subgroup G := Subgroup.closure ({QuotientGroup.mk PSLCard.Smat,
    QuotientGroup.mk PSLCard.Tmat} : Set G)
  change QuotientGroup.mk (Dmat t ht) ∈ H
  have hS : QuotientGroup.mk PSLCard.Smat ∈ H :=
    Subgroup.subset_closure (by simp)
  have hT : QuotientGroup.mk PSLCard.Tmat ∈ H :=
    Subgroup.subset_closure (by simp)
  have hN (x : F) : QuotientGroup.mk (Nmat x) ∈ H := by
    rw [Nmat_eq_Tmat_pow x, QuotientGroup.mk_pow]
    exact H.pow_mem hT x.val
  have hword : QuotientGroup.mk
      (Nmat t * PSLCard.Smat * Nmat t⁻¹ * PSLCard.Smat *
        Nmat t * PSLCard.Smat) ∈ H := by
    rw [QuotientGroup.mk_mul, QuotientGroup.mk_mul, QuotientGroup.mk_mul,
      QuotientGroup.mk_mul, QuotientGroup.mk_mul]
    exact H.mul_mem (H.mul_mem (H.mul_mem (H.mul_mem (H.mul_mem
      (hN t) hS) (hN t⁻¹)) hS) (hN t)) hS
  rw [neg_Dmat_word t ht] at hword
  have hneg : (QuotientGroup.mk (-1 : SLG) : G) = 1 := by
    rw [QuotientGroup.eq_one_iff]
    exact PSLCard.negI_mem_center
  have hmk : (QuotientGroup.mk (-Dmat t ht) : G) =
      QuotientGroup.mk (Dmat t ht) := by
    calc
      QuotientGroup.mk (-Dmat t ht) =
          QuotientGroup.mk ((-1 : SLG) * Dmat t ht) := by simp
      _ = QuotientGroup.mk (-1 : SLG) * QuotientGroup.mk (Dmat t ht) := by
        rw [QuotientGroup.mk_mul]
      _ = QuotientGroup.mk (Dmat t ht) := by rw [hneg, one_mul]
  rw [← hmk]
  exact hword

theorem gauss_of_c_ne_zero (A : SLG) (hc : A 1 0 ≠ 0) :
    A = Nmat (A 0 0 * (A 1 0)⁻¹) * PSLCard.Smat *
      Dmat (A 1 0) hc * Nmat (A 1 1 * (A 1 0)⁻¹) := by
  have hdet : A 0 0 * A 1 1 - A 0 1 * A 1 0 = 1 := by
    have h := A.property
    rw [Matrix.det_fin_two] at h
    exact h
  have hcInv : A 1 0 * (A 1 0)⁻¹ = 1 := mul_inv_cancel₀ hc
  have hcInv' : (A 1 0)⁻¹ * A 1 0 = 1 := inv_mul_cancel₀ hc
  apply Subtype.ext
  change A.1 = Nraw (A 0 0 * (A 1 0)⁻¹) * Wraw * Draw (A 1 0) *
    Nraw (A 1 1 * (A 1 0)⁻¹)
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Nraw, Wraw, Draw, Matrix.mul_apply, Fin.sum_univ_two]
  all_goals field_simp [hc]
  linear_combination -hdet

theorem gauss_of_c_eq_zero (A : SLG) (hc : A 1 0 = 0) :
    A = Dmat (A 0 0) (by
        intro ha
        have hdet : A 0 0 * A 1 1 - A 0 1 * A 1 0 = 1 := by
          have h := A.property
          rw [Matrix.det_fin_two] at h
          exact h
        rw [ha, hc] at hdet
        norm_num at hdet) *
      Nmat ((A 0 0)⁻¹ * A 0 1) := by
  have ha : A 0 0 ≠ 0 := by
    intro ha
    have hdet : A 0 0 * A 1 1 - A 0 1 * A 1 0 = 1 := by
      have h := A.property
      rw [Matrix.det_fin_two] at h
      exact h
    rw [ha, hc] at hdet
    norm_num at hdet
  have hdet : A 0 0 * A 1 1 = 1 := by
    have := A.property
    rw [Matrix.det_fin_two] at this
    simpa [hc] using this
  have haInv : A 0 0 * (A 0 0)⁻¹ = 1 := mul_inv_cancel₀ ha
  have haInv' : (A 0 0)⁻¹ * A 0 0 = 1 := inv_mul_cancel₀ ha
  apply Subtype.ext
  change A.1 = Draw (A 0 0) * Nraw ((A 0 0)⁻¹ * A 0 1)
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Nraw, Draw, Matrix.mul_apply, Fin.sum_univ_two, hc]
  all_goals field_simp [ha]
  rw [mul_comm, hdet]

theorem mk_mem_closure (A : SLG) :
    QuotientGroup.mk A ∈
      Subgroup.closure ({QuotientGroup.mk PSLCard.Smat,
        QuotientGroup.mk PSLCard.Tmat} : Set G) := by
  let H : Subgroup G := Subgroup.closure ({QuotientGroup.mk PSLCard.Smat,
    QuotientGroup.mk PSLCard.Tmat} : Set G)
  change QuotientGroup.mk A ∈ H
  have hS : QuotientGroup.mk PSLCard.Smat ∈ H :=
    Subgroup.subset_closure (by simp)
  have hT : QuotientGroup.mk PSLCard.Tmat ∈ H :=
    Subgroup.subset_closure (by simp)
  have hN (x : F) : QuotientGroup.mk (Nmat x) ∈ H := by
    rw [Nmat_eq_Tmat_pow x, QuotientGroup.mk_pow]
    exact H.pow_mem hT x.val
  by_cases hc : A 1 0 = 0
  · rw [gauss_of_c_eq_zero A hc, QuotientGroup.mk_mul]
    exact H.mul_mem (Dmat_mem_closure (A 0 0) (by
      intro ha
      have hdet : A 0 0 * A 1 1 - A 0 1 * A 1 0 = 1 := by
        have h := A.property
        rw [Matrix.det_fin_two] at h
        exact h
      rw [ha, hc] at hdet
      norm_num at hdet)) (hN _)
  · rw [gauss_of_c_ne_zero A hc, QuotientGroup.mk_mul,
      QuotientGroup.mk_mul, QuotientGroup.mk_mul]
    exact H.mul_mem (H.mul_mem (H.mul_mem (hN _) hS)
      (Dmat_mem_closure (A 1 0) hc)) (hN _)

/-- The standard Fourier and translation matrices generate `PSL₂(F₁₁)`. -/
public theorem closure_mk_Smat_Tmat :
    Subgroup.closure ({QuotientGroup.mk PSLCard.Smat,
      QuotientGroup.mk PSLCard.Tmat} : Set G) = ⊤ := by
  apply top_unique
  intro g _
  obtain ⟨A, rfl⟩ := QuotientGroup.mk_surjective g
  exact mk_mem_closure A

/-- The Fourier generator and the square of the translation generator also
generate `PSL₂(F₁₁)`.  This is the convention used by the six-dimensional
Weil matrices: `S₆` represents `-Smat` (the same PSL element), while `T₆`
represents `Tmat²`. -/
public theorem closure_mk_Smat_Tmat_pow_two :
    Subgroup.closure ({QuotientGroup.mk PSLCard.Smat,
      QuotientGroup.mk (PSLCard.Tmat ^ 2)} : Set G) = ⊤ := by
  let H : Subgroup G := Subgroup.closure ({QuotientGroup.mk PSLCard.Smat,
    QuotientGroup.mk (PSLCard.Tmat ^ 2)} : Set G)
  have hS : QuotientGroup.mk PSLCard.Smat ∈ H :=
    Subgroup.subset_closure (by simp)
  have hT2 : QuotientGroup.mk (PSLCard.Tmat ^ 2) ∈ H :=
    Subgroup.subset_closure (by simp)
  have hT : QuotientGroup.mk PSLCard.Tmat ∈ H := by
    have hp := H.pow_mem hT2 6
    rw [← QuotientGroup.mk_pow] at hp
    have heq : (PSLCard.Tmat ^ 2) ^ 6 = PSLCard.Tmat := by decide
    simpa [heq] using hp
  have hle : Subgroup.closure ({QuotientGroup.mk PSLCard.Smat,
      QuotientGroup.mk PSLCard.Tmat} : Set G) ≤ H := by
    apply (Subgroup.closure_le H).2
    intro x hx
    rcases hx with (rfl | rfl)
    · exact hS
    · exact hT
  apply top_unique
  intro g _
  apply hle
  rw [closure_mk_Smat_Tmat]
  trivial

end PSLGenerators
end V14Formalization
