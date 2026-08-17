/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.Definitions
public import Mathlib.LinearAlgebra.Matrix.Adjugate

/-!
# Point-level fixed-locus and Segre bridges

These lemmas isolate the field-valued geometry needed after normal
specialization. They deliberately make no claim about equality of
scheme-theoretic fixed loci.
-/

noncomputable section

open Module
open scoped BigOperators LinearAlgebra.Projectivization

namespace V14Formalization

universe u v w

namespace FaithfulLinearRep

variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V]

/-- The projectivization of the `-1` eigenspace, symmetric to
`plusProjectiveStratum`. -/
@[expose] public def minusProjectiveStratum (R : FaithfulLinearRep k G V) (sigma : G) : Set (ℙ k V) :=
  { x : ℙ k V | x.submodule ≤ R.minusEigenspace sigma }

theorem mem_minusProjectiveStratum_iff
    (R : FaithfulLinearRep k G V) (sigma : G) {x : ℙ k V} :
    x ∈ R.minusProjectiveStratum sigma ↔ x.rep ∈ R.minusEigenspace sigma := by
  constructor
  · intro hx
    change x.submodule ≤ R.minusEigenspace sigma at hx
    rw [Projectivization.submodule_eq] at hx
    exact hx (Submodule.mem_span_singleton_self _)
  · intro hx
    change x.submodule ≤ R.minusEigenspace sigma
    rw [Projectivization.submodule_eq]
    exact (Submodule.span_singleton_le_iff_mem _ _).mpr hx

/-- The projective fixed points of an involution are exhausted by the
projectivizations of its `+1` and `-1` eigenspaces. This is a theorem about
`Projectivization`; it does not identify a scheme-theoretic equalizer. -/
public theorem mem_plus_or_minus_projectiveStratum_of_fixed
    (R : FaithfulLinearRep k G V) {sigma : G} (hsigma : IsInvolution sigma)
    (x : ℙ k V) (hfixed : R.projectiveSMul sigma x = x) :
    x ∈ R.plusProjectiveStratum sigma ∨ x ∈ R.minusProjectiveStratum sigma := by
  have hx : x.rep ≠ 0 := Projectivization.rep_nonzero x
  have hactne : R.act sigma x.rep ≠ 0 := by
    exact fun h => hx (R.act_injective sigma (by simpa using h))
  have hmk : Projectivization.mk k (R.act sigma x.rep) hactne =
      Projectivization.mk k x.rep hx := by
    calc
      Projectivization.mk k (R.act sigma x.rep) hactne =
          R.projectiveSMul sigma (Projectivization.mk k x.rep hx) :=
        (R.projectiveSMul_mk sigma hx).symm
      _ = R.projectiveSMul sigma x := by rw [Projectivization.mk_rep]
      _ = x := hfixed
      _ = Projectivization.mk k x.rep hx := (Projectivization.mk_rep x).symm
  obtain ⟨a, ha⟩ :=
    (Projectivization.mk_eq_mk_iff k (R.act sigma x.rep) x.rep hactne hx).mp hmk
  have hact : R.act sigma x.rep = (a : k) • x.rep := by
    simpa only [Units.smul_def] using ha.symm
  have haa : (a : k) * (a : k) = 1 := by
    apply smul_left_injective k hx
    calc
      ((a : k) * (a : k)) • x.rep = (a : k) • ((a : k) • x.rep) :=
        mul_smul _ _ _
      _ = R.act sigma ((a : k) • x.rep) := by rw [map_smul, hact]
      _ = R.act sigma (R.act sigma x.rep) := by rw [hact]
      _ = x.rep := R.act_act hsigma x.rep
      _ = (1 : k) • x.rep := (one_smul k x.rep).symm
  rcases mul_self_eq_one_iff.mp haa with ha1 | haNeg
  · left
    rw [R.mem_plusProjectiveStratum_iff, R.mem_plusEigenspace_iff]
    simp [hact, ha1]
  · right
    rw [R.mem_minusProjectiveStratum_iff, R.mem_minusEigenspace_iff]
    simp [hact, haNeg]

end FaithfulLinearRep

section Segre

variable {k : Type u} [Field k]
variable {m : Type v} {n : Type w} [Fintype m] [Fintype n]

/-- A nonzero matrix over a field whose `2 × 2` minors all vanish is a
nonzero pure tensor. No algebraic-closedness hypothesis is needed. -/
public theorem exists_pureTensor_of_twoByTwoMinors_eq_zero
    (z : Matrix m n k) (hz : z ≠ 0)
    (hminor : ∀ i i' j j', z i j * z i' j' = z i j' * z i' j) :
    ∃ (a : m → k) (b : n → k),
      a ≠ 0 ∧ b ≠ 0 ∧ ∀ i j, z i j = a i * b j := by
  classical
  have hentry : ∃ i j, z i j ≠ 0 := by
    by_contra h
    push Not at h
    apply hz
    ext i j
    exact h i j
  obtain ⟨i0, j0, hij⟩ := hentry
  let a : m → k := fun i ↦ z i j0
  let b : n → k := fun j ↦ z i0 j / z i0 j0
  have ha : a ≠ 0 := by
    intro hzero
    exact hij (congrFun hzero i0)
  have hb : b ≠ 0 := by
    intro hzero
    have h := congrFun hzero j0
    simp [b, hij] at h
  refine ⟨a, b, ha, hb, ?_⟩
  intro i j
  dsimp [a, b]
  apply mul_right_cancel₀ hij
  calc
    z i j * z i0 j0 = z i j0 * z i0 j := hminor i i0 j j0
    _ = (z i j0 * (z i0 j / z i0 j0)) * z i0 j0 := by
      rw [mul_assoc, div_mul_cancel₀ _ hij]

/-- Coefficient matrix of a system of bilinear equations after fixing the
first factor of a pure tensor. -/
@[expose] public def bilinearCoefficientMatrix
    {r : Type*} [Fintype r]
    (C : r → m → n → k) (a : m → k) : Matrix r n k :=
  fun i j ↦ ∑ t, C i t j * a t

/-- A nonzero second tensor factor in the kernel of a square bilinear
coefficient matrix forces its determinant to vanish. -/
public theorem det_bilinearCoefficientMatrix_eq_zero
    {r : Type*} [Fintype r] [DecidableEq r]
    (C : r → m → r → k) (a : m → k) (b : r → k) (hb : b ≠ 0)
    (hbilinear : ∀ i, ∑ j, (∑ t, C i t j * a t) * b j = 0) :
    Matrix.det (bilinearCoefficientMatrix C a) = 0 := by
  classical
  have hmul : Matrix.mulVec (bilinearCoefficientMatrix C a) b = 0 := by
    funext i
    change ∑ j, (∑ t, C i t j * a t) * b j = 0
    exact hbilinear i
  have hentry : ∃ i, b i ≠ 0 := by
    by_contra h
    push Not at h
    exact hb (funext h)
  obtain ⟨i, hi⟩ := hentry
  exact Matrix.det_eq_zero_of_mulVec_eq_zero_of_mem_nonZeroDivisors hmul
    (mem_nonZeroDivisors_iff_ne_zero.mpr hi)

/-- Point-level Segre-to-determinant implication. Vanishing `2 × 2` minors
write a nonzero matrix as `a ⊗ b`; square bilinear section equations then
force the determinant polynomial in `a` to vanish. -/
public theorem exists_pureTensor_and_det_eq_zero_of_linearSection
    {r : Type*} [Fintype r] [DecidableEq r]
    (C : r → m → r → k) (z : Matrix m r k) (hz : z ≠ 0)
    (hminor : ∀ i i' j j', z i j * z i' j' = z i j' * z i' j)
    (hlinear : ∀ i, ∑ j, ∑ t, C i t j * z t j = 0) :
    ∃ (a : m → k) (b : r → k),
      a ≠ 0 ∧ b ≠ 0 ∧
      (∀ i j, z i j = a i * b j) ∧
      Matrix.det (bilinearCoefficientMatrix C a) = 0 := by
  classical
  obtain ⟨a, b, ha, hb, hab⟩ :=
    exists_pureTensor_of_twoByTwoMinors_eq_zero z hz hminor
  refine ⟨a, b, ha, hb, hab, det_bilinearCoefficientMatrix_eq_zero C a b hb ?_⟩
  intro i
  calc
    ∑ j, (∑ t, C i t j * a t) * b j =
        ∑ j, ∑ t, (C i t j * a t) * b j := by
          apply Finset.sum_congr rfl
          intro j _
          rw [Finset.sum_mul]
    _ = ∑ j, ∑ t, C i t j * (a t * b j) := by
          simp only [mul_assoc]
    _ = ∑ j, ∑ t, C i t j * z t j := by
          apply Finset.sum_congr rfl
          intro j _
          apply Finset.sum_congr rfl
          intro t _
          rw [hab]
    _ = 0 := hlinear i

end Segre

end V14Formalization

