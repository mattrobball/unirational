/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.PluckerNaturality
public import V14Formalization.IntrinsicV14

/-!
# The Plücker identity on an abstract six-space

`PluckerNaturality.lex4_repr_gMul_self` says that on `Fin 6 → R`, the lex `Λ⁴`
coordinates of `ω ∧ ω` are twice the Plücker quadrics of the lex `Λ²`
coordinates of `ω`.  This file transports that statement along a basis, so that
it applies to the abstract `U` of the Weil representation:

    (lex4 c).repr (ω ∧ ω) t = 2 * eval ((lex2 c).equivFun ω) (pluckerQuadric k t)

for any basis `c : Basis (Fin 6) k U`.  `lex2 c` and `lex4 c` are the
lexicographically ordered exterior-power bases; at `c = uBasisCore`, `lex2 c` is
`Lambda2Coordinates.lambda2Basis` on the nose.

Everything is `exteriorPower.map` of the coordinate isomorphism `c.equivFun`
carrying one lex basis to the other, plus `IntrinsicV14.wedgePairing_map`.
-/

set_option linter.unusedSectionVars false

noncomputable section

open Module exteriorPower

namespace V14Formalization
namespace Lambda4Coordinates

open PluckerNaturality

universe u

variable {k : Type u} [Field k] {U : Type u} [AddCommGroup U] [Module k U]

/-- The lexicographic `Λ²` basis attached to a basis of a six-dimensional
space.  At `c = uBasisCore` this is `Lambda2Coordinates.lambda2Basis`. -/
@[expose] public def lex2 (c : Basis (Fin 6) k U) : Basis (Fin 15) k ↥(⋀[k]^2 U) :=
  (c.exteriorPower 2).reindex Lambda2Coordinates.pluckerPairEquiv

/-- The lexicographic `Λ⁴` basis attached to a basis of a six-dimensional
space, in the order matching `pluckerRelation`. -/
@[expose] public def lex4 (c : Basis (Fin 6) k U) : Basis (Fin 15) k ↥(⋀[k]^4 U) :=
  (c.exteriorPower 4).reindex fourEquiv.symm

/-- Transport of `repr` along a linear map that matches two bases. -/
public theorem repr_of_map_basis {W₁ W₂ : Type*} [AddCommGroup W₁] [Module k W₁]
    [AddCommGroup W₂] [Module k W₂] {ι : Type*} (B₁ : Basis ι k W₁) (B₂ : Basis ι k W₂)
    (L : W₁ →ₗ[k] W₂) (h : ∀ i, L (B₁ i) = B₂ i) (z : W₁) :
    B₂.repr (L z) = B₁.repr z := by
  have key : (B₂.repr.toLinearMap.comp L) = B₁.repr.toLinearMap := by
    apply B₁.ext
    intro i
    simp [h i]
  exact DFunLike.congr_fun key z

private theorem equivFun_basis (c : Basis (Fin 6) k U) (i : Fin 6) :
    c.equivFun (c i) = (b6 (R := k)) i := by
  funext j
  simp [Basis.equivFun_apply, Finsupp.single_apply, Pi.basisFun_apply, Pi.single_apply,
    eq_comm]

private theorem comp_equivFun_basis (c : Basis (Fin 6) k U) :
    (c.equivFun : U →ₗ[k] (Fin 6 → k)) ∘ (c : Fin 6 → U) = (b6 (R := k) : Fin 6 → (Fin 6 → k)) := by
  funext i
  exact equivFun_basis c i

public theorem map_lex2 (c : Basis (Fin 6) k U) (i : Fin 15) :
    exteriorPower.map 2 (c.equivFun : U →ₗ[k] (Fin 6 → k)) (lex2 c i) = lex2Basis (R := k) i := by
  rw [lex2, Basis.reindex_apply, exteriorPower.basis_apply,
    exteriorPower.map_apply_ιMulti_family, lex2Basis_apply, exteriorPower.basis_apply,
    comp_equivFun_basis]
  rfl

public theorem map_lex4 (c : Basis (Fin 6) k U) (t : Fin 15) :
    exteriorPower.map 4 (c.equivFun : U →ₗ[k] (Fin 6 → k)) (lex4 c t) = lex4Basis (R := k) t := by
  rw [lex4, Basis.reindex_apply, exteriorPower.basis_apply,
    exteriorPower.map_apply_ιMulti_family, lex4Basis_apply, exteriorPower.basis_apply,
    comp_equivFun_basis]
  rfl

variable [FiniteDimensional k U] [Module.Free k U]

/-- **The Plücker identity on an abstract six-space.** -/
public theorem lex4_repr_wedge_self (c : Basis (Fin 6) k U) (u : ↥(⋀[k]^2 U)) (t : Fin 15) :
    (lex4 c).repr (IntrinsicV14.wedgePairing k U u u) t =
      2 * MvPolynomial.eval ((lex2 c).equivFun u)
        (V14Formalization.SchemeGeometry.pluckerQuadric k t) := by
  have h4 := repr_of_map_basis (lex4 c) (lex4Basis (R := k))
    (exteriorPower.map 4 (c.equivFun : U →ₗ[k] (Fin 6 → k))) (map_lex4 c)
    (IntrinsicV14.wedgePairing k U u u)
  rw [← h4, ← IntrinsicV14.wedgePairing_map k U (c.equivFun : U →ₗ[k] (Fin 6 → k)) u u]
  have hgm : IntrinsicV14.wedgePairing k (Fin 6 → k)
        (exteriorPower.map 2 (c.equivFun : U →ₗ[k] (Fin 6 → k)) u)
        (exteriorPower.map 2 (c.equivFun : U →ₗ[k] (Fin 6 → k)) u) =
      DirectSum.gMulLHom k (fun m ↦ ⋀[k]^m (Fin 6 → k))
        (exteriorPower.map 2 (c.equivFun : U →ₗ[k] (Fin 6 → k)) u)
        (exteriorPower.map 2 (c.equivFun : U →ₗ[k] (Fin 6 → k)) u) := rfl
  rw [hgm, PluckerNaturality.lex4_repr_gMul_self]
  have h2 := repr_of_map_basis (lex2 c) (lex2Basis (R := k))
    (exteriorPower.map 2 (c.equivFun : U →ₗ[k] (Fin 6 → k))) (map_lex2 c) u
  have harg : (lex2Basis (R := k)).equivFun
      (exteriorPower.map 2 (c.equivFun : U →ₗ[k] (Fin 6 → k)) u) = (lex2 c).equivFun u := by
    funext j
    simp only [Basis.equivFun_apply, h2]
  rw [harg]

end Lambda4Coordinates
end V14Formalization
