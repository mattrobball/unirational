module

public import V14Formalization.CorrectedBirationalField
public import V14Formalization.LinearNormalOrderedPresentation
public import V14Formalization.GenericCharts

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

universe u

variable {Omega : Type u} [Field Omega]

/-- The corrected ordered-coordinate field chart into the standard affine
chart of `P^(p+q+1)`.  On coordinates it sends
`u_i ↦ x_(i+1)/x_0`, `T ↦ y_0/x_0`, and
`v_j ↦ y_(j+1)/y_0`. -/
@[expose] public noncomputable def orderedCoordinateToProjectiveFunctionFieldEquiv
    (p q : ℕ) :
    orderedCoordinateField (Omega := Omega) p q ≃+*
      (ProjectiveSpace (p + q + 1) Omega).functionField :=
  (orderedNormalToAmbientFieldEquiv p q).trans
    (projectiveGeneralFunctionFieldEquiv (p + q) Omega)

theorem orderedCoordinateToProjectiveFunctionFieldEquiv_base
    (p q : ℕ) (c : Omega) :
    orderedCoordinateToProjectiveFunctionFieldEquiv p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.C c)) =
      projectiveGeneralBaseToFunctionField (p + q) Omega c := by
  change projectiveGeneralFunctionFieldEquiv (p + q) Omega
    (orderedNormalToAmbientFieldEquiv p q
      (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
        (orderedCoordinateField (Omega := Omega) p q)
        (MvPolynomial.C c))) = _
  rw [orderedNormalToAmbientFieldEquiv_C]
  rw [show algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
      (orderedCoordinateField (Omega := Omega) p q) (MvPolynomial.C c) =
    algebraMap Omega (orderedCoordinateField (Omega := Omega) p q) c by
      rw [MvPolynomial.C_eq_algebraMap,
        IsScalarTower.algebraMap_apply Omega
          (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)]]
  exact projectiveGeneralFunctionFieldEquiv_base (p + q) Omega c

theorem orderedCoordinateToProjectiveFunctionFieldEquiv_X_plus
    (p q : ℕ) (i : Fin p) :
    orderedCoordinateToProjectiveFunctionFieldEquiv
        (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedPlusIndex p q i))) =
      projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedPlusIndex p q i))) := by
  change projectiveGeneralFunctionFieldEquiv (p + q) Omega
    (orderedNormalToAmbientFieldEquiv p q _) = _
  rw [orderedNormalToAmbientFieldEquiv_X_plus]

theorem orderedCoordinateToProjectiveFunctionFieldEquiv_X_normal
    (p q : ℕ) :
    orderedCoordinateToProjectiveFunctionFieldEquiv
        (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedNormalIndex p q))) =
      projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedNormalIndex p q))) := by
  change projectiveGeneralFunctionFieldEquiv (p + q) Omega
    (orderedNormalToAmbientFieldEquiv p q _) = _
  rw [orderedNormalToAmbientFieldEquiv_X_normal]

theorem orderedCoordinateToProjectiveFunctionFieldEquiv_X_tail
    (p q : ℕ) (j : Fin q) :
    orderedCoordinateToProjectiveFunctionFieldEquiv
        (Omega := Omega) p q
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedMinusTailIndex p q j))) =
      projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
            (orderedCoordinateField (Omega := Omega) p q)
            (MvPolynomial.X (orderedMinusTailIndex p q j)) /
          algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
            (orderedCoordinateField (Omega := Omega) p q)
            (MvPolynomial.X (orderedNormalIndex p q))) := by
  change projectiveGeneralFunctionFieldEquiv (p + q) Omega
    (orderedNormalToAmbientFieldEquiv p q _) = _
  rw [orderedNormalToAmbientFieldEquiv_X_tail]

/-- The fully corrected ordered `(u,T,v)` function-field chart for
`P^(p+q+1)`.  Unlike the old `finSuccEquiv` chart, the `RatFunc.X` variable is
the normal parameter `y₀/x₀`. -/
@[expose] public noncomputable def correctedOrderedLinearNormalFunctionFieldEquiv
    (p q : ℕ) :
    LinearNormalFractionField (Nat.succ (p + q)) Omega ≃+*
      (ProjectiveSpace (p + q + 1) Omega).functionField :=
  (linearNormalToOrderedCoordinateFieldEquiv p q).trans
    (orderedCoordinateToProjectiveFunctionFieldEquiv p q)

public theorem correctedOrderedLinearNormalFunctionFieldEquiv_X
    (p q : ℕ) :
    correctedOrderedLinearNormalFunctionFieldEquiv (Omega := Omega) p q
        (RatFunc.X : LinearNormalFractionField (Nat.succ (p + q)) Omega) =
      projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedNormalIndex p q))) := by
  change orderedCoordinateToProjectiveFunctionFieldEquiv (Omega := Omega) p q
      (linearNormalToOrderedCoordinateFieldEquiv (Omega := Omega) p q
        (RatFunc.X : orderedNormalTowerField (Omega := Omega) p q)) = _
  rw [linearNormalToOrderedCoordinateFieldEquiv_X_normal,
    orderedCoordinateToProjectiveFunctionFieldEquiv_X_normal]

public theorem correctedOrderedLinearNormalFunctionFieldEquiv_C_plus
    (p q : ℕ) (i : Fin p) :
    correctedOrderedLinearNormalFunctionFieldEquiv (Omega := Omega) p q
        (RatFunc.C (residualCoordinateInField (Omega := Omega) p q
          (orderedResidualPlusIndex p q i))) =
      projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
          (orderedCoordinateField (Omega := Omega) p q)
          (MvPolynomial.X (orderedPlusIndex p q i))) := by
  change orderedCoordinateToProjectiveFunctionFieldEquiv (Omega := Omega) p q
      (linearNormalToOrderedCoordinateFieldEquiv (Omega := Omega) p q
        (RatFunc.C (residualCoordinateInField (Omega := Omega) p q
          (orderedResidualPlusIndex p q i)))) = _
  rw [linearNormalToOrderedCoordinateFieldEquiv_C_plus,
    orderedCoordinateToProjectiveFunctionFieldEquiv_X_plus]

public theorem correctedOrderedLinearNormalFunctionFieldEquiv_C_tail
    (p q : ℕ) (j : Fin q) :
    correctedOrderedLinearNormalFunctionFieldEquiv (Omega := Omega) p q
        (RatFunc.C (residualCoordinateInField (Omega := Omega) p q
          (orderedResidualMinusIndex p q j))) =
      projectiveGeneralFunctionFieldEquiv (p + q) Omega
        (algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
            (orderedCoordinateField (Omega := Omega) p q)
            (MvPolynomial.X (orderedMinusTailIndex p q j)) /
          algebraMap (orderedCoordinatePolynomial (Omega := Omega) p q)
            (orderedCoordinateField (Omega := Omega) p q)
            (MvPolynomial.X (orderedNormalIndex p q))) := by
  change orderedCoordinateToProjectiveFunctionFieldEquiv (Omega := Omega) p q
      (linearNormalToOrderedCoordinateFieldEquiv (Omega := Omega) p q
        (RatFunc.C (residualCoordinateInField (Omega := Omega) p q
          (orderedResidualMinusIndex p q j)))) = _
  rw [linearNormalToOrderedCoordinateFieldEquiv_C_tail,
    orderedCoordinateToProjectiveFunctionFieldEquiv_X_tail]

public theorem correctedOrderedLinearNormalFunctionFieldEquiv_base
    (p q : ℕ) (c : Omega) :
    correctedOrderedLinearNormalFunctionFieldEquiv (Omega := Omega) p q
        (baseToLinearNormalFractionField (Nat.succ (p + q)) Omega c) =
      functionFieldBaseRingHom Omega (ProjectiveSpace (p + q + 1) Omega)
        (ProjectiveSpace.toSpec (p + q + 1) Omega) c := by
  change orderedCoordinateToProjectiveFunctionFieldEquiv p q
      (linearNormalToOrderedCoordinateFieldEquiv p q
        (baseToLinearNormalFractionField (Nat.succ (p + q)) Omega c)) = _
  rw [linearNormalToOrderedCoordinateFieldEquiv_base,
    orderedCoordinateToProjectiveFunctionFieldEquiv_base]
  exact DFunLike.congr_fun
    (projectiveGeneralBaseToFunctionField_eq (p + q) Omega) c

/-- Any function-field chart respecting the base embedding gives the required
generic base square. -/
theorem linearChartGeneric_toBase_of_base
    (d : ℕ) (X : Scheme.{u}) [IsIntegral X]
    (f : X ⟶ Spec (.of Omega))
    (eK : LinearNormalFractionField d Omega ≃+* X.functionField)
    (hfield : eK.toRingHom.comp
        (baseToLinearNormalFractionField d Omega) =
      functionFieldBaseRingHom Omega X f) :
    Spec.map (CommRingCat.ofHom
        (linearChartGenericHom d Omega X eK)) ≫
        linearNormalValuation_toBase d Omega =
      X.fromSpecStalk _ ≫ f := by
  calc
    Spec.map (CommRingCat.ofHom (linearChartGenericHom d Omega X eK)) ≫
          linearNormalValuation_toBase d Omega =
        (Spec.map (CommRingCat.ofHom eK.toRingHom) ≫
          linearNormalValuation_generic d Omega) ≫
            linearNormalValuation_toBase d Omega := by
      simp only [linearChartGenericHom, linearNormalValuation_generic,
        ← Spec.map_comp]
      rfl
    _ = Spec.map (CommRingCat.ofHom eK.toRingHom) ≫
        (linearNormalValuation_generic d Omega ≫
          linearNormalValuation_toBase d Omega) := by simp
    _ = Spec.map (CommRingCat.ofHom eK.toRingHom) ≫
        Spec.map (CommRingCat.ofHom
          (baseToLinearNormalFractionField d Omega)) := by
      rw [linearNormalValuation_generic_toBase]
    _ = Spec.map (CommRingCat.ofHom
          (eK.toRingHom.comp
            (baseToLinearNormalFractionField d Omega))) := by
      rw [← Spec.map_comp]
      rfl
    _ = Spec.map (CommRingCat.ofHom
          (functionFieldBaseRingHom Omega X f)) := by rw [hfield]
    _ = X.fromSpecStalk _ ≫ f :=
      SpecMap_functionFieldBaseRingHom Omega X f

public theorem correctedOrderedLinearNormal_generic_toBase
    (p q : ℕ) :
    Spec.map (CommRingCat.ofHom
        (linearChartGenericHom (Nat.succ (p + q)) Omega
          (ProjectiveSpace (p + q + 1) Omega)
          (correctedOrderedLinearNormalFunctionFieldEquiv p q))) ≫
        linearNormalValuation_toBase (Nat.succ (p + q)) Omega =
      (ProjectiveSpace (p + q + 1) Omega).fromSpecStalk _ ≫
        ProjectiveSpace.toSpec (p + q + 1) Omega := by
  apply linearChartGeneric_toBase_of_base
  ext c
  rw [RingHom.comp_apply]
  exact correctedOrderedLinearNormalFunctionFieldEquiv_base p q c

end V14Formalization.SchemeGeometry
