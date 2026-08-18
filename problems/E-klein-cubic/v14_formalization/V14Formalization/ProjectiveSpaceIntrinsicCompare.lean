/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.ProjectiveSpaceIntrinsicBasis
public import V14Formalization.SchemeEquivariantTransport

/-!
# `ℙ(V)` and `ProjectiveSpace d k` are the same `G`-scheme over `Spec k`

The basis isomorphism of `ProjectiveSpaceIntrinsicBasis` is upgraded here to an
isomorphism in `Action (Over (Spec k)) G` between the coordinate-free
`ambientFree R` and the coordinatized `ambientProjectiveActionOver R d b`.

Two things have to be checked: that the basis isomorphism commutes with the
structure morphisms to `Spec k`, and that it intertwines the two actions.  The
second is `projOfBasisHom_intertwines`, conjugated.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry HomogeneousIdeal

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry Module SymmetricAlgebra BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

universe u

variable {k : Type u} [Field k] {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module k V] {d : ℕ}

/-! ## The basis isomorphism is a morphism over `Spec k` -/

private theorem bridgeSymm_zero_comp_algebraMap (b : Basis (Fin (d + 1)) k V) :
    (bridgeOfBasisSymm b).toGradedRingHom.gradedZeroRingHom.comp
        (algebraMap k (MvPolynomial.homogeneousSubmodule (Fin (d + 1)) k 0)) =
      algebraMap k (grade k (Dual k V) 0) := by
  apply RingHom.ext
  intro r
  apply Subtype.ext
  simp [bridgeOfBasisSymm, gradedEquivMvPolynomialSymm]
  rw [← MvPolynomial.algebraMap_eq]
  exact AlgEquiv.commutes _ r

public theorem projOfBasisInv_toSpec (b : Basis (Fin (d + 1)) k V) :
    projOfBasisInv b ≫ ProjectiveSpace.toSpec d k
      = projectiveSpaceOfModule.toSpec k V := by
  unfold projOfBasisInv ProjectiveSpace.toSpec projectiveSpaceOfModule.toSpec
    projectiveSpaceOfModule
  rw [← Category.assoc, AlgebraicGeometry.Proj.map_toSpecZero]
  rw [Category.assoc, ← Spec.map_comp]
  have hz :
      CommRingCat.ofHom
          (algebraMap k (MvPolynomial.homogeneousSubmodule (Fin (d + 1)) k 0)) ≫
        CommRingCat.ofHom (bridgeOfBasisSymm b).toGradedRingHom.gradedZeroRingHom =
      CommRingCat.ofHom (algebraMap k (grade k (Dual k V) 0)) := by
    simpa using congrArg CommRingCat.ofHom (bridgeSymm_zero_comp_algebraMap b)
  rw [hz]

/-! ## The basis isomorphism intertwines the two actions -/

public theorem projOfBasisInv_intertwines (R : FaithfulLinearRep k G V)
    (b : Basis (Fin (d + 1)) k V) (g : G) :
    projRepHom R.ρ g ≫ projOfBasisInv b
      = projOfBasisInv b ≫ projectiveActionHom (ambientMatrixRepresentation R d b) g := by
  have h : projOfBasisHom b ≫ projRepHom R.ρ g
      = projectiveActionHom (ambientMatrixRepresentation R d b) g ≫ projOfBasisHom b :=
    projOfBasisHom_intertwines b (R.ρ g) (R.ρ g⁻¹) (rep_inv_comp R.ρ g) _ _ (by simp)
      (ambientMatrixRepresentation_repr R b g)
  calc projRepHom R.ρ g ≫ projOfBasisInv b
      = (projOfBasisInv b ≫ projOfBasisHom b) ≫ projRepHom R.ρ g ≫ projOfBasisInv b := by
        rw [projOfBasis_inv_hom, Category.id_comp]
    _ = projOfBasisInv b ≫ (projOfBasisHom b ≫ projRepHom R.ρ g) ≫ projOfBasisInv b := by
        simp only [Category.assoc]
    _ = projOfBasisInv b ≫
          (projectiveActionHom (ambientMatrixRepresentation R d b) g ≫ projOfBasisHom b) ≫
            projOfBasisInv b := by rw [h]
    _ = projOfBasisInv b ≫ projectiveActionHom (ambientMatrixRepresentation R d b) g := by
        rw [Category.assoc, projOfBasis_hom_inv, Category.comp_id]

/-! ## The isomorphism of `G`-schemes over `Spec k` -/

/-- The coordinate-free ambient `G`-scheme and the coordinatized one are
isomorphic, over `Spec k` and equivariantly. -/
@[expose] public def ambientFreeIso (R : FaithfulLinearRep k G V)
    (b : Basis (Fin (d + 1)) k V) :
    ambientFree R ≅ ambientProjectiveActionOver R d b :=
  Action.mkIso (Over.isoMk (projIsoOfBasis b) (projOfBasisInv_toSpec b)) (fun g => by
    apply Over.OverMorphism.ext
    exact projOfBasisInv_intertwines R b g)

end SchemeGeometry
end V14Formalization
