/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.ProjectiveSpaceIntrinsicAction
public import Mathlib.LinearAlgebra.SymmetricAlgebra.Basis
public import Mathlib.LinearAlgebra.Dual.Lemmas
public import BConicBundleMultisections.ProjectiveSpaceChartDominance

/-!
# `ℙ(V)` is irreducible and integral

`Proj` of a graded domain with nonzero irrelevant ideal is integral, and
`Sym (V*)` is a domain because `V*` is free over the field `k`.  The irrelevant
ideal is nonzero as soon as `V*` is, which a basis witnesses.

This is what `HasEquivariantRationalMap` requires of its source, so it is kept
in its own module: the published coordinate-free statement needs these
instances, and nothing else from the bridge.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry HomogeneousIdeal

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry Module SymmetricAlgebra

universe u

variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V] {d : ℕ}

/-! ## `ℙ(V)` is irreducible and integral

`Proj` of a graded domain with nonzero irrelevant ideal is integral, and
`Sym (V*)` is a domain because `V*` is free over the field `k`.  The irrelevant
ideal is nonzero as soon as `V*` is, which a basis witnesses. -/

public theorem irrelevant_grade_ne_bot (b : Basis (Fin (d + 1)) k V) :
    HomogeneousIdeal.irrelevant (grade k (Dual k V)) ≠ ⊥ := by
  haveI : FiniteDimensional k V := Module.Finite.of_basis b
  intro h
  have hmem : SymmetricAlgebra.ι k (Dual k V) (b.dualBasis 0) ∈
      HomogeneousIdeal.irrelevant (grade k (Dual k V)) :=
    HomogeneousIdeal.mem_irrelevant_of_mem _ Nat.one_pos
      (by simpa only [grade, pow_one] using LinearMap.mem_range_self _ (b.dualBasis 0))
  rw [h] at hmem
  have hzero : SymmetricAlgebra.ι k (Dual k V) (b.dualBasis 0) = 0 :=
    Ideal.mem_bot.mp (HomogeneousIdeal.mem_iff.mpr hmem)
  have hX := congrArg (equivMvPolynomial b.dualBasis) hzero
  rw [equivMvPolynomial_ι_apply, map_zero] at hX
  exact MvPolynomial.X_ne_zero 0 hX

public theorem projectiveSpaceOfModule_irreducibleSpace_of_basis
    (b : Basis (Fin (d + 1)) k V) :
    IrreducibleSpace (projectiveSpaceOfModule k V) :=
  BConicBundleMultisections.Proj.irreducibleSpace _ (irrelevant_grade_ne_bot b)

public theorem projectiveSpaceOfModule_isIntegral_of_basis (b : Basis (Fin (d + 1)) k V) :
    IsIntegral (projectiveSpaceOfModule k V) :=
  BConicBundleMultisections.Proj.isIntegral _ (irrelevant_grade_ne_bot b)

/-- A nontrivial finite-dimensional space has a basis indexed by `Fin (d+1)`. -/
public theorem exists_basis_fin_succ (k V : Type u) [Field k] [AddCommGroup V] [Module k V]
    [FiniteDimensional k V] [Nontrivial V] :
    ∃ d : ℕ, Nonempty (Basis (Fin (d + 1)) k V) := by
  have hpos : 0 < Module.finrank k V := Module.finrank_pos
  obtain ⟨d, hd⟩ := Nat.exists_eq_succ_of_ne_zero hpos.ne'
  exact ⟨d, ⟨(Module.finBasis k V).reindex (finCongr hd)⟩⟩

/-- `ℙ(V)` is irreducible for any nontrivial finite-dimensional `V`.  No basis
appears in the statement; the proof chooses one. -/
public instance projectiveSpaceOfModule_irreducibleSpace
    [FiniteDimensional k V] [Nontrivial V] :
    IrreducibleSpace (projectiveSpaceOfModule k V) := by
  obtain ⟨_, ⟨b⟩⟩ := exists_basis_fin_succ k V
  exact projectiveSpaceOfModule_irreducibleSpace_of_basis b

/-- `ℙ(V)` is integral for any nontrivial finite-dimensional `V`. -/
public instance projectiveSpaceOfModule_isIntegral
    [FiniteDimensional k V] [Nontrivial V] :
    IsIntegral (projectiveSpaceOfModule k V) := by
  obtain ⟨_, ⟨b⟩⟩ := exists_basis_fin_succ k V
  exact projectiveSpaceOfModule_isIntegral_of_basis b

/-! ## The same, for the carriers of the action objects

Instance search does not unfold `Action`/`Over` projections, so the instances
above have to be restated at the carrier of `ambientFree`. -/

@[expose] public instance projectiveActionOverOfRep_irreducibleSpace
    [FiniteDimensional k V] [Nontrivial V] (rho : Representation k G V) :
    IrreducibleSpace (projectiveActionOverOfRep rho).V.left := by
  change IrreducibleSpace (projectiveSpaceOfModule k V)
  infer_instance

@[expose] public instance projectiveActionOverOfRep_isIntegral
    [FiniteDimensional k V] [Nontrivial V] (rho : Representation k G V) :
    IsIntegral (projectiveActionOverOfRep rho).V.left := by
  change IsIntegral (projectiveSpaceOfModule k V)
  infer_instance

@[expose] public instance ambientFree_irreducibleSpace
    [FiniteDimensional k V] [Nontrivial V] (R : FaithfulLinearRep k G V) :
    IrreducibleSpace (ambientFree R).V.left := by
  change IrreducibleSpace (projectiveSpaceOfModule k V)
  infer_instance

@[expose] public instance ambientFree_isIntegral
    [FiniteDimensional k V] [Nontrivial V] (R : FaithfulLinearRep k G V) :
    IsIntegral (ambientFree R).V.left := by
  change IsIntegral (projectiveSpaceOfModule k V)
  infer_instance

end SchemeGeometry
end V14Formalization
