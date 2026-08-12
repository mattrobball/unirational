/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.GeometricFanoCarrier
import V14Formalization.SchemeProjectiveAction
import Mathlib.Tactic.FinCases

/-!
# Exact Plücker coordinates for the exterior-square representation

This file fixes the coordinate order used by the finite D12 certificate:
`01,02,03,04,05,12,13,14,15,23,24,25,34,35,45`.  It then packages the
actual exterior-square representation of `PSL₂(F₁₁)` as a faithful matrix
representation in that basis.
-/

noncomputable section

open Set Matrix exteriorPower Module

namespace V14Formalization
namespace Lambda2Coordinates

open GeometricFanoCarrier SchemeGeometry

abbrev k := GeometricFanoCarrier.k
abbrev G := GeometricFanoCarrier.PSL2F11
abbrev U := GeometricFanoCarrier.U
abbrev Lambda2U := GeometricFanoCarrier.Lambda2U

/-- Evaluation at `0,...,5`, as an equivalence on the even Weil model. -/
noncomputable def evalEvenEquivCore : U ≃ₗ[k] (Fin 6 → k) := by
  apply LinearEquiv.ofBijective GeometricFanoCarrier.evalEven
  refine ⟨GeometricFanoCarrier.evalEven_injective, ?_⟩
  intro v
  refine ⟨GeometricFanoCarrier.extendEven v, ?_⟩
  simpa [LinearMap.comp_apply] using
    LinearMap.congr_fun GeometricFanoCarrier.evalEven_extendEven v

/-- The coordinate basis dual to evaluation at `0,...,5`. -/
noncomputable def uBasisCore : Basis (Fin 6) k U :=
  Basis.ofEquivFun evalEvenEquivCore

/-- The two-subset `{i,j}` with its cardinality certificate. -/
def pair (i j : Fin 6) (h : i ≠ j) : powersetCard (Fin 6) 2 :=
  ⟨{i, j}, by simp [Finset.card_pair h]⟩

/-- Lexicographic enumeration `01,02,03,04,05,12,...,45`. -/
def pairEnumeration : Fin 15 → powersetCard (Fin 6) 2 := ![
  pair 0 1 (by decide), pair 0 2 (by decide), pair 0 3 (by decide),
  pair 0 4 (by decide), pair 0 5 (by decide), pair 1 2 (by decide),
  pair 1 3 (by decide), pair 1 4 (by decide), pair 1 5 (by decide),
  pair 2 3 (by decide), pair 2 4 (by decide), pair 2 5 (by decide),
  pair 3 4 (by decide), pair 3 5 (by decide), pair 4 5 (by decide)]

theorem pairEnumeration_injective : Function.Injective pairEnumeration := by decide

theorem pairEnumeration_bijective : Function.Bijective pairEnumeration := by
  apply (Fintype.bijective_iff_injective_and_card pairEnumeration).mpr
  refine ⟨pairEnumeration_injective, ?_⟩
  rw [Fintype.card_fin, Fintype.card_eq_nat_card, powersetCard.card, Nat.card_fin]
  decide

/-- The exact Plücker coordinate order used by the sealed matrix data. -/
noncomputable def pluckerPairEquiv : powersetCard (Fin 6) 2 ≃ Fin 15 :=
  (Equiv.ofBijective pairEnumeration pairEnumeration_bijective).symm

@[simp]
theorem pluckerPairEquiv_pairEnumeration (i : Fin 15) :
    pluckerPairEquiv (pairEnumeration i) = i := by
  simpa only [pluckerPairEquiv, Equiv.ofBijective_apply] using
    (Equiv.symm_apply_apply
      (Equiv.ofBijective pairEnumeration pairEnumeration_bijective) i)

/-- Exterior-square basis in lexicographic Plücker order. -/
noncomputable def lambda2Basis : Basis (Fin 15) k Lambda2U :=
  (uBasisCore.exteriorPower 2).reindex pluckerPairEquiv

@[simp]
theorem lambda2Basis_apply (i : Fin 15) :
    lambda2Basis i =
      exteriorPower.ιMulti_family k 2 uBasisCore (pairEnumeration i) := by
  rw [lambda2Basis, Basis.reindex_apply, exteriorPower.basis_apply]
  congr 1

/-- The actual faithful `15 × 15` representation of `PSL₂(F₁₁)` in the
lexicographic Plücker basis. -/
noncomputable def lambda2MatrixRepresentation :
    FaithfulMatrixRepresentation (k := k) (G := G) 14 where
  ρ := (Matrix.GeneralLinearGroup.toLin' lambda2Basis).symm.toMonoidHom.comp
    GeometricFanoCarrier.pslLambda2Hom.toHomUnits
  faithful :=
    (Matrix.GeneralLinearGroup.toLin' lambda2Basis).symm.injective.comp
      (MonoidHom.ker_eq_bot_iff _ |>.mp (by
        rw [MonoidHom.ker_toHomUnits]
        exact (MonoidHom.ker_eq_bot_iff _).mpr
          GeometricFanoCarrier.pslLambda2Hom_injective))

/-- The matrix representation is definitionally the actual linear action in
the fixed exterior-square basis. -/
theorem lambda2MatrixRepresentation_coe (g : G) :
    (lambda2MatrixRepresentation.ρ g : Matrix (Fin 15) (Fin 15) k) =
      LinearMap.toMatrix lambda2Basis lambda2Basis
        (GeometricFanoCarrier.pslLambda2Hom g) := by
  rfl

end Lambda2Coordinates
end V14Formalization
