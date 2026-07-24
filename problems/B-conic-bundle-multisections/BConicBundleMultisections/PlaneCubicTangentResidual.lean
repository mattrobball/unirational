/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveResidualPoint
public import Mathlib.LinearAlgebra.Dual.Lemmas
public import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

/-!
# Tangent residual points of plane cubics

For a homogeneous plane cubic `F` and a nonsingular point `p` on `{F = 0}`, the tangent line
`T_p` meets the cubic as `2p + g(p)`.  This file packages the residual point `g(p)` via the
existing binary double-contact residual, and proves existence of a complementary tangent
direction at every nonsingular cubic point.

These are point-level polynomial constructions.  They do not produce a scheme morphism
`[-2] : C → C` or identify `g` with multiplication by `-2` on a Weierstrass model.
-/

@[expose] public section

open MvPolynomial
open scoped LinearAlgebra.Projectivization

namespace BConicBundleMultisections

noncomputable section

universe u

variable {K : Type u} [Field K]

/-! ### Dual of a coordinate covector -/

/-- Dual functional associated with a coordinate covector via the standard dual basis. -/
def coordDual (g : Fin 3 → K) : Module.Dual K (Fin 3 → K) :=
  ∑ i : Fin 3, g i • LinearMap.proj (R := K) (φ := fun _ : Fin 3 ↦ K) i

theorem coordDual_apply (g q : Fin 3 → K) : coordDual g q = g ⬝ᵥ q := by
  classical
  simp [coordDual, dotProduct, LinearMap.sum_apply, LinearMap.smul_apply, LinearMap.proj_apply]

theorem coordDual_eq_zero_iff (g : Fin 3 → K) :
    coordDual g = 0 ↔ g = 0 := by
  constructor
  · intro h
    funext i
    have hdot : g ⬝ᵥ Pi.single i (1 : K) = 0 := by
      have : coordDual g (Pi.single i (1 : K)) = 0 := by
        rw [h, LinearMap.zero_apply]
      rwa [coordDual_apply] at this
    -- `g ⬝ᵥ eᵢ = g i`
    have hsum : g ⬝ᵥ Pi.single i (1 : K) = g i := by
      classical
      simp [dotProduct_single]
    change g i = 0
    rwa [← hsum]
  · intro hg
    apply LinearMap.ext
    intro q
    rw [coordDual_apply, hg, LinearMap.zero_apply]
    simp [dotProduct]

theorem coordDual_eq_eval_tangentForm
    (F : MvPolynomial (Fin 3) K) (p q : Fin 3 → K) :
    coordDual (tangentGradient F p) q = eval q (tangentForm F p) := by
  rw [coordDual_apply, eval_tangentForm_eq_dotProduct]

theorem mem_tangentHyperplaneCone_iff_coordDual
    (F : MvPolynomial (Fin 3) K) (p q : Fin 3 → K) :
    q ∈ tangentHyperplaneCone F p ↔ coordDual (tangentGradient F p) q = 0 := by
  rw [mem_tangentHyperplaneCone, ← coordDual_eq_eval_tangentForm]

/-! ### Complementary tangent directions -/

/-- A nonsingular cubic point has a complementary direction spanning its tangent line. -/
theorem exists_complementary_tangent_direction
    (F : MvPolynomial (Fin 3) K) (hF : F.IsHomogeneous 3)
    (p : Fin 3 → K) (hp0 : p ≠ 0) (hp : eval p F = 0)
    (hgrad : tangentGradient F p ≠ 0) :
    ∃ q : Fin 3 → K,
      LinearIndependent K ![p, q] ∧ q ∈ tangentHyperplaneCone F p := by
  classical
  let g := tangentGradient F p
  let φ : Module.Dual K (Fin 3 → K) := coordDual g
  have hφ : φ ≠ 0 := by
    intro h0
    exact hgrad ((coordDual_eq_zero_iff g).1 h0)
  have hpker : p ∈ LinearMap.ker φ := by
    change φ p = 0
    rw [coordDual_eq_eval_tangentForm]
    exact eval_tangentForm_self_eq_zero hF hp
  have hfin : Module.finrank K (LinearMap.ker φ) = 2 := by
    have h := Module.Dual.finrank_ker_add_one_of_ne_zero hφ
    have hV : Module.finrank K (Fin 3 → K) = 3 := Module.finrank_fintype_fun_eq_card K
    omega
  have hp_ne : (⟨p, hpker⟩ : LinearMap.ker φ) ≠ 0 := by
    intro h
    exact hp0 (congrArg Subtype.val h)
  have hlt :
      Module.finrank K (K ∙ (⟨p, hpker⟩ : LinearMap.ker φ)) <
        Module.finrank K (LinearMap.ker φ) := by
    rw [finrank_span_singleton hp_ne, hfin]
    norm_num
  obtain ⟨qker, hqker⟩ :=
    Submodule.exists_of_finrank_lt (K ∙ (⟨p, hpker⟩ : LinearMap.ker φ)) hlt
  refine ⟨(qker : Fin 3 → K), ?_, ?_⟩
  · rw [LinearIndependent.pair_iff]
    intro a b hab
    have habker :
        a • (⟨p, hpker⟩ : LinearMap.ker φ) + b • qker = 0 :=
      Subtype.ext (by simpa using hab)
    by_cases hb : b = 0
    · subst hb
      simp only [zero_smul, add_zero] at habker
      have ha : a = 0 := by
        have hval := congrArg Subtype.val habker
        change a • p = 0 at hval
        exact (smul_eq_zero.mp hval).resolve_right hp0
      exact ⟨ha, rfl⟩
    · have hba : b • qker = -(a • (⟨p, hpker⟩ : LinearMap.ker φ)) :=
        eq_neg_of_add_eq_zero_right habker
      have hmem : qker ∈ K ∙ (⟨p, hpker⟩ : LinearMap.ker φ) := by
        have hsol : qker = (b⁻¹ * -a) • (⟨p, hpker⟩ : LinearMap.ker φ) := by
          apply (smul_right_injective (LinearMap.ker φ) hb).eq_iff.1
          calc
            b • qker = -(a • (⟨p, hpker⟩ : LinearMap.ker φ)) := hba
            _ = (-a) • (⟨p, hpker⟩ : LinearMap.ker φ) := by rw [neg_smul]
            _ = (b * (b⁻¹ * -a)) • (⟨p, hpker⟩ : LinearMap.ker φ) := by field_simp [hb]
            _ = b • ((b⁻¹ * -a) • (⟨p, hpker⟩ : LinearMap.ker φ)) := by rw [smul_smul]
        rw [hsol]
        exact Submodule.smul_mem _ _ (Submodule.mem_span_singleton_self _)
      exact absurd (by simpa using hmem) (hqker (1 : K) one_ne_zero)
  · rw [mem_tangentHyperplaneCone_iff_coordDual]
    exact LinearMap.mem_ker.1 qker.property

/-! ### Residual point package -/

/-- Residual projective point of a plane cubic at a nonsingular point along a complementary
tangent direction. -/
def planeCubicTangentResidualPoint
    (F : MvPolynomial (Fin 3) K) (hF : F.IsHomogeneous 3)
    (p q : Fin 3 → K) (hpq : LinearIndependent K ![p, q])
    (hp : eval p F = 0) (hq : q ∈ tangentHyperplaneCone F p)
    (hrestriction : binaryLineRestriction p q F ≠ 0) :
    ℙ K (Fin 3 → K) :=
  tangentResidualProjectivePoint F hF p q hpq hp hq hrestriction

/-- The residual representative lies on the cubic. -/
theorem eval_planeCubicTangentResidualRepresentative
    (F : MvPolynomial (Fin 3) K) (hF : F.IsHomogeneous 3)
    (p q : Fin 3 → K) (hp : eval p F = 0) (hq : q ∈ tangentHyperplaneCone F p) :
    eval (tangentResidualPointRepresentative F p q) F = 0 :=
  eval_tangentResidualPointRepresentative F hF p q hp hq

/-- The residual representative lies in the span of the base point and the chosen tangent
direction (hence on the projective tangent line). -/
theorem tangentResidualPointRepresentative_mem_span
    (F : MvPolynomial (Fin 3) K) (p q : Fin 3 → K) :
    tangentResidualPointRepresentative F p q ∈
      Submodule.span K ({p, q} : Set (Fin 3 → K)) := by
  simp only [tangentResidualPointRepresentative, binarySpanLinearMap_apply]
  exact Submodule.add_mem _
    (Submodule.smul_mem _ _ (Submodule.subset_span (Set.mem_insert _ _)))
    (Submodule.smul_mem _ _
      (Submodule.subset_span (Set.mem_insert_of_mem _ (Set.mem_singleton _))))

/-- The residual projective point is represented by `tangentResidualPointRepresentative`. -/
theorem planeCubicTangentResidualPoint_eq_mk
    (F : MvPolynomial (Fin 3) K) (hF : F.IsHomogeneous 3)
    (p q : Fin 3 → K) (hpq : LinearIndependent K ![p, q])
    (hp : eval p F = 0) (hq : q ∈ tangentHyperplaneCone F p)
    (hrestriction : binaryLineRestriction p q F ≠ 0) :
    planeCubicTangentResidualPoint F hF p q hpq hp hq hrestriction =
      Projectivization.mk K (tangentResidualPointRepresentative F p q)
        (tangentResidualPointRepresentative_ne_zero F hF p q hpq hp hq hrestriction) :=
  tangentResidualProjectivePoint_eq_mk F hF p q hpq hp hq hrestriction

/-- Linear independence of `p` and `α p + β q` when `p, q` are independent and `β ≠ 0`. -/
theorem linearIndependent_pair_endpoint_reparam
    {V : Type*} [AddCommGroup V] [Module K V]
    {p q : V} (hpq : LinearIndependent K ![p, q]) (α : K) (β : Kˣ) :
    LinearIndependent K ![p, α • p + (β : K) • q] := by
  rw [LinearIndependent.pair_iff]
  intro a b hab
  have hcomb : (a + b * α) • p + (b * (β : K)) • q = 0 := by
    calc
      (a + b * α) • p + (b * (β : K)) • q
          = a • p + (b * α) • p + (b * (β : K)) • q := by rw [add_smul]
      _ = a • p + b • (α • p) + b • ((β : K) • q) := by simp only [mul_smul]
      _ = a • p + (b • (α • p) + b • ((β : K) • q)) := by abel
      _ = a • p + b • (α • p + (β : K) • q) := by rw [← smul_add]
      _ = 0 := hab
  obtain ⟨h1, h2⟩ := (LinearIndependent.pair_iff.1 hpq) (a + b * α) (b * (β : K)) hcomb
  have hb : b = 0 := (mul_eq_zero.mp h2).resolve_right β.ne_zero
  exact ⟨by simpa [hb] using h1, hb⟩

/-- Scaling the second endpoint inside the tangent hyperplane preserves membership. -/
theorem smul_add_mem_tangentHyperplaneCone
    (F : MvPolynomial (Fin 3) K) (hF : F.IsHomogeneous 3)
    (p q : Fin 3 → K) (α β : K)
    (hp : eval p F = 0) (hq : q ∈ tangentHyperplaneCone F p) :
    (fun i ↦ α * p i + β * q i) ∈ tangentHyperplaneCone F p := by
  have hp_tan : eval p (tangentForm F p) = 0 := eval_tangentForm_self_eq_zero hF hp
  simp only [mem_tangentHyperplaneCone] at hq ⊢
  calc
    eval (fun i ↦ α * p i + β * q i) (tangentForm F p)
        = ∑ i : Fin 3, eval p (pderiv i F) * (α * p i + β * q i) := by
            simp [eval_tangentForm]
    _ = ∑ i : Fin 3, (eval p (pderiv i F) * (α * p i) +
          eval p (pderiv i F) * (β * q i)) := by
            simp only [mul_add]
    _ = ∑ i : Fin 3, eval p (pderiv i F) * (α * p i) +
          ∑ i : Fin 3, eval p (pderiv i F) * (β * q i) := by
            rw [Finset.sum_add_distrib]
    _ = α * ∑ i : Fin 3, eval p (pderiv i F) * p i +
          β * ∑ i : Fin 3, eval p (pderiv i F) * q i := by
            congr 1
            · rw [Finset.mul_sum]; exact Finset.sum_congr rfl fun _ _ ↦ by ring
            · rw [Finset.mul_sum]; exact Finset.sum_congr rfl fun _ _ ↦ by ring
    _ = α * eval p (tangentForm F p) + β * eval q (tangentForm F p) := by
            simp [eval_tangentForm]
    _ = 0 := by simp [hp_tan, hq]

end

end BConicBundleMultisections
