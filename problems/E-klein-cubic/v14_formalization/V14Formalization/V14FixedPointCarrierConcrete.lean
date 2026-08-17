/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12SigmaCarrierConcrete
public import V14Formalization.V14FixedPointCarrierDimensionFactorization

/-!
# Concrete carrier factorization of V14 fixed field points

This specializes the scheme-theoretic fixed-point reduction to the generated,
kernel-checked six- and four-dimensional sigma carriers.
-/

noncomputable section

open CategoryTheory Matrix
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections
open GeometricV14Carrier Lambda2Coordinates D12SigmaCarrier

/-- Every field-valued point of the actual V14 sigma-fixed scheme has
normalized ambient coordinates in one of the two concrete sigma carriers. -/
public theorem exists_normalizedCoordinates_v14FixedBy_concrete_plus_or_minus_carrier
    (L : Type) [Field L] [Algebra V14SchemeModel.k L] [NeZero (2 : L)]
    (p : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma) :
    ∃ (j : Fin 15) (x : Fin 15 → L) (a : L),
      x j = 1 ∧
      ambientPointOfV14FixedBy L p =
        ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
          (R := V14SchemeModel.k) 14 j x ∧
      (V14SchemeModel.projectorMatrix.map
        (algebraMap V14SchemeModel.k L)).mulVec x = x ∧
      (∀ q : Fin 15,
        MvPolynomial.eval x
          (MvPolynomial.map (algebraMap V14SchemeModel.k L)
            (pluckerQuadric V14SchemeModel.k q)) = 0) ∧
      a ≠ 0 ∧
      ((∃ u : Fin 6 → L, u ≠ 0 ∧
          x = ((D12SigmaCarrierConcrete.core.Bplus).map
            (algebraMap V14SchemeModel.k L)).mulVec u ∧
          a = 1) ∨
        (∃ v : Fin 4 → L, v ≠ 0 ∧
          x = ((D12SigmaCarrierConcrete.core.Bminus).map
            (algebraMap V14SchemeModel.k L)).mulVec v ∧
          a = -1)) := by
  let C := D12SigmaCarrierConcrete.core
  exact exists_normalizedCoordinates_v14FixedBy_plus_or_minus_carrier_of_dimension
    L p C.Bplus C.Lplus C.Bminus C.Lminus
      C.left_inverse_plus C.left_inverse_minus
      C.ambient_factor_plus C.ambient_factor_minus
      C.sigma_eigen_plus C.sigma_eigen_minus

end V14Formalization.SchemeGeometry
