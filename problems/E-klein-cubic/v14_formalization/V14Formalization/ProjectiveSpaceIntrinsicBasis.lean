/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.ProjectiveSpaceIntrinsicAction
public import V14Formalization.UniversalNormalDivisor
public import Mathlib.LinearAlgebra.Dual.Lemmas

/-!
# The basis isomorphism `ℙ(V) ≅ ProjectiveSpace d k`

A basis `b` of `V` gives a dual basis of `V*`, hence — through the bridge of
`SymmetricAlgebraFunctor` — a graded isomorphism
`Sym (V*) ≅ MvPolynomial (Fin (d+1)) k`, hence an isomorphism of schemes
`ℙ(V) ≅ ProjectiveSpace d k`.

This is what connects the coordinate-free statements to the existing V14
proofs, all of which live on the `MvPolynomial` side.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry HomogeneousIdeal

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry Module SymmetricAlgebra BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

universe u

variable {k : Type u} [Field k] {V : Type u} [AddCommGroup V] [Module k V] {d : ℕ}

/-! ## The graded isomorphism -/

/-- The bridge for the dual basis of `b`: a graded algebra map from the
symmetric algebra on `V*` to the homogeneous polynomials. -/
@[expose] public def bridgeOfBasis (b : Basis (Fin (d + 1)) k V) :
    grade k (Dual k V) →ₐᵍ[k] MvPolynomial.homogeneousSubmodule (Fin (d + 1)) k :=
  haveI : FiniteDimensional k V := Module.Finite.of_basis b
  gradedEquivMvPolynomial b.dualBasis

/-- The inverse bridge. -/
@[expose] public def bridgeOfBasisSymm (b : Basis (Fin (d + 1)) k V) :
    MvPolynomial.homogeneousSubmodule (Fin (d + 1)) k →ₐᵍ[k] grade k (Dual k V) :=
  haveI : FiniteDimensional k V := Module.Finite.of_basis b
  gradedEquivMvPolynomialSymm b.dualBasis

public theorem bridgeOfBasis_leftInverse (b : Basis (Fin (d + 1)) k V)
    (x : SymmetricAlgebra k (Dual k V)) :
    bridgeOfBasisSymm b (bridgeOfBasis b x) = x := by
  haveI : FiniteDimensional k V := Module.Finite.of_basis b
  exact gradedEquivMvPolynomial_leftInverse b.dualBasis x

public theorem bridgeOfBasis_rightInverse (b : Basis (Fin (d + 1)) k V)
    (y : MvPolynomial (Fin (d + 1)) k) :
    bridgeOfBasis b (bridgeOfBasisSymm b y) = y := by
  haveI : FiniteDimensional k V := Module.Finite.of_basis b
  exact gradedEquivMvPolynomial_rightInverse b.dualBasis y

public theorem irrelevant_le_bridgeOfBasis (b : Basis (Fin (d + 1)) k V) :
    (MvPolynomial.homogeneousSubmodule (Fin (d + 1)) k)₊ ≤
      ((grade k (Dual k V))₊).map (bridgeOfBasis b).toGradedRingHom :=
  irrelevant_le_map_of_rightInverse _ _ (bridgeOfBasis_rightInverse b)

public theorem irrelevant_le_bridgeOfBasisSymm (b : Basis (Fin (d + 1)) k V) :
    (grade k (Dual k V))₊ ≤
      ((MvPolynomial.homogeneousSubmodule (Fin (d + 1)) k)₊).map
        (bridgeOfBasisSymm b).toGradedRingHom :=
  irrelevant_le_map_of_rightInverse _ _ (bridgeOfBasis_leftInverse b)

/-! ## The isomorphism of schemes -/

/-- `ProjectiveSpace d k ⟶ ℙ(V)`, from a basis. -/
@[expose] public def projOfBasisHom (b : Basis (Fin (d + 1)) k V) :
    ProjectiveSpace d k ⟶ projectiveSpaceOfModule k V :=
  Proj.map (bridgeOfBasis b).toGradedRingHom (irrelevant_le_bridgeOfBasis b)

/-- `ℙ(V) ⟶ ProjectiveSpace d k`, from a basis. -/
@[expose] public def projOfBasisInv (b : Basis (Fin (d + 1)) k V) :
    projectiveSpaceOfModule k V ⟶ ProjectiveSpace d k :=
  Proj.map (bridgeOfBasisSymm b).toGradedRingHom (irrelevant_le_bridgeOfBasisSymm b)

public theorem projOfBasis_hom_inv (b : Basis (Fin (d + 1)) k V) :
    projOfBasisHom b ≫ projOfBasisInv b = 𝟙 _ := by
  have hc : (bridgeOfBasis b).toGradedRingHom.comp (bridgeOfBasisSymm b).toGradedRingHom
      = GradedRingHom.id (MvPolynomial.homogeneousSubmodule (Fin (d + 1)) k) := by
    apply GradedRingHom.ext
    intro y
    exact bridgeOfBasis_rightInverse b y
  refine Eq.trans (AlgebraicGeometry.Proj.map_comp _ _ _ _).symm ?_
  exact (AlgebraicGeometry.Proj.map_congr hc _ (by simp)).trans AlgebraicGeometry.Proj.map_id

public theorem projOfBasis_inv_hom (b : Basis (Fin (d + 1)) k V) :
    projOfBasisInv b ≫ projOfBasisHom b = 𝟙 _ := by
  have hc : (bridgeOfBasisSymm b).toGradedRingHom.comp (bridgeOfBasis b).toGradedRingHom
      = GradedRingHom.id (grade k (Dual k V)) := by
    apply GradedRingHom.ext
    intro x
    exact bridgeOfBasis_leftInverse b x
  refine Eq.trans (AlgebraicGeometry.Proj.map_comp _ _ _ _).symm ?_
  exact (AlgebraicGeometry.Proj.map_congr hc _ (by simp)).trans AlgebraicGeometry.Proj.map_id

/-- The isomorphism of schemes `ℙ(V) ≅ ProjectiveSpace d k` determined by a
basis of `V`. -/
@[expose] public def projIsoOfBasis (b : Basis (Fin (d + 1)) k V) :
    projectiveSpaceOfModule k V ≅ ProjectiveSpace d k where
  hom := projOfBasisInv b
  inv := projOfBasisHom b
  hom_inv_id := projOfBasis_inv_hom b
  inv_hom_id := projOfBasis_hom_inv b

end SchemeGeometry
end V14Formalization
