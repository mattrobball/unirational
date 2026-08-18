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

/-! ## The intertwining

The bridge carries the intrinsic action of a linear endomorphism into the
matrix substitution action, provided the matrix is the one of the endomorphism
in the basis `b`.  This is the identity that makes the two actions the same
action. -/

/-- The graded intertwining identity.  Both sides are algebra maps out of
`Sym (V*)`, so it is enough to check them on `ι` of a dual basis vector, where
one side is a row of `M` and the other is the corresponding linear form. -/
public theorem bridge_intertwines (b : Basis (Fin (d + 1)) k V) (f : V →ₗ[k] V)
    (M : Matrix (Fin (d + 1)) (Fin (d + 1)) k)
    (hM : ∀ i j, M i j = b.repr (f (b j)) i) :
    (bridgeOfBasis b).toGradedRingHom.comp (dualGradedMap f).toGradedRingHom
      = (linearSubstGradedRingHom d M).comp (bridgeOfBasis b).toGradedRingHom := by
  haveI : FiniteDimensional k V := Module.Finite.of_basis b
  have key :
      (equivMvPolynomial b.dualBasis).toAlgHom.comp
          (SymmetricAlgebra.map (Module.Dual.transpose (R := k) f))
        = (MvPolynomial.aeval (linearSubst d M)).comp
          (equivMvPolynomial b.dualBasis).toAlgHom := by
    apply SymmetricAlgebra.algHom_ext
    apply Basis.ext b.dualBasis
    intro i
    show (equivMvPolynomial b.dualBasis)
        (SymmetricAlgebra.map (Module.Dual.transpose (R := k) f)
          (SymmetricAlgebra.ι k (Dual k V) (b.dualBasis i)))
      = MvPolynomial.aeval (linearSubst d M)
          ((equivMvPolynomial b.dualBasis) (SymmetricAlgebra.ι k (Dual k V) (b.dualBasis i)))
    rw [SymmetricAlgebra.map_ι, equivMvPolynomial_ι_apply]
    rw [show (equivMvPolynomial b.dualBasis)
          (SymmetricAlgebra.ι k (Dual k V) (Module.Dual.transpose (R := k) f (b.dualBasis i)))
        = Basis.constr b.dualBasis k (MvPolynomial.X : Fin (d + 1) → MvPolynomial (Fin (d + 1)) k)
            (Module.Dual.transpose (R := k) f (b.dualBasis i)) from
        congr($(equivMvPolynomial_comp_ι b.dualBasis) _)]
    rw [Basis.constr_apply_fintype, MvPolynomial.aeval_X, linearSubst]
    refine Finset.sum_congr rfl fun j _ => ?_
    rw [MvPolynomial.smul_eq_C_mul]
    congr 1
    rw [hM i j]
    simp [Basis.equivFun_apply, Module.Dual.transpose_apply, Basis.dualBasis_apply]
  apply GradedRingHom.ext
  intro x
  exact congr($key x)

/-- The intertwining at the level of `Proj`: the basis map carries the matrix
substitution automorphism of `ProjectiveSpace d k` to the intrinsic
automorphism of `ℙ(V)`. -/
public theorem projOfBasisHom_intertwines (b : Basis (Fin (d + 1)) k V)
    (f finv : V →ₗ[k] V) (hf : finv ∘ₗ f = LinearMap.id)
    (M N : Matrix (Fin (d + 1)) (Fin (d + 1)) k) (hMN : N * M = 1)
    (hM : ∀ i j, M i j = b.repr (f (b j)) i) :
    projOfBasisHom b ≫ projMapDual f finv hf
      = mapLinearSubst d M N hMN ≫ projOfBasisHom b := by
  have hL : projOfBasisHom b ≫ projMapDual f finv hf
      = AlgebraicGeometry.Proj.map
          ((bridgeOfBasis b).toGradedRingHom.comp (dualGradedMap f).toGradedRingHom)
          (HomogeneousIdeal.irrelevant_le_map_comp
            (irrelevant_le_dualGradedMap f finv hf) (irrelevant_le_bridgeOfBasis b)) :=
    (AlgebraicGeometry.Proj.map_comp _ _ _ _).symm
  have hR : mapLinearSubst d M N hMN ≫ projOfBasisHom b
      = AlgebraicGeometry.Proj.map
          ((linearSubstGradedRingHom d M).comp (bridgeOfBasis b).toGradedRingHom)
          (HomogeneousIdeal.irrelevant_le_map_comp
            (irrelevant_le_bridgeOfBasis b) (irrelevant_le_map_linearSubst d M N hMN)) :=
    (AlgebraicGeometry.Proj.map_comp _ _ _ _).symm
  rw [hL, hR]
  exact AlgebraicGeometry.Proj.map_congr (bridge_intertwines b f M hM) _ _

/-! ## The matrix of the representation is the matrix of the basis

`ambientMatrixRepresentation` packages `R.ρ g` into `GL` through
`Matrix.GeneralLinearGroup.toLin' b`.  Mathlib has no `toLin'_symm_apply`, so
the entry convention is extracted here from `toLin'_apply`. -/

public theorem toLin'_symm_repr (b : Basis (Fin (d + 1)) k V)
    (u : LinearMap.GeneralLinearGroup k V) (i j : Fin (d + 1)) :
    (↑((Matrix.GeneralLinearGroup.toLin' b).symm u) :
        Matrix (Fin (d + 1)) (Fin (d + 1)) k) i j
      = b.repr (u.toLinearEquiv (b j)) i := by
  classical
  have h := Matrix.GeneralLinearGroup.toLin'_apply b
    ((Matrix.GeneralLinearGroup.toLin' b).symm u) (b j)
  rw [MulEquiv.apply_symm_apply] at h
  have hcol : Matrix.mulVec
      (↑((Matrix.GeneralLinearGroup.toLin' b).symm u) :
        Matrix (Fin (d + 1)) (Fin (d + 1)) k) ⇑(b.repr (b j))
      = fun i => (↑((Matrix.GeneralLinearGroup.toLin' b).symm u) :
        Matrix (Fin (d + 1)) (Fin (d + 1)) k) i j := by
    funext i
    simp [Matrix.mulVec, dotProduct, b.repr_self_apply, Finsupp.single_apply,
      mul_ite, mul_one, mul_zero, Finset.sum_ite_eq]
  rw [hcol, Fintype.linearCombination_apply] at h
  rw [h, Basis.repr_sum_self]

/-- The matrix of `ambientMatrixRepresentation` in the basis `b` is the matrix
of `R.ρ g` in the basis `b`. -/
public theorem ambientMatrixRepresentation_repr {G : Type u} [Group G]
    (R : FaithfulLinearRep k G V) (b : Basis (Fin (d + 1)) k V) (g : G) (i j : Fin (d + 1)) :
    (↑(ambientMatrixRepresentation R d b g) :
        Matrix (Fin (d + 1)) (Fin (d + 1)) k) i j
      = b.repr (R.ρ g (b j)) i :=
  toLin'_symm_repr b (R.ρ.toHomUnits g) i j

end SchemeGeometry
end V14Formalization
