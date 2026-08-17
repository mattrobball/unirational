module

public import V14Formalization.SchemeFunctionFieldPrecomp

open CategoryTheory TopologicalSpace
open AlgebraicGeometry

universe u

namespace AlgebraicGeometry.Scheme

variable {X Y Z : Scheme.{u}}

/-- Function-field pullback is independent of the displayed representative
of an equal dominant scheme morphism.  Naming this proof avoids dependent
typeclass transport when a geometric commutative square is used below. -/
public theorem Hom.functionFieldMap_congr
    [IsIntegral X] [IsIntegral Y]
    (f g : X ⟶ Y) [IsDominant f] [IsDominant g] (h : f = g) :
    f.functionFieldMap = g.functionFieldMap := by
  subst g
  rfl

/-- Function-field pullback reverses composition, with the explicit order
used by the scheme action conventions in this project. -/
public theorem Hom.functionFieldMap_comp
    [IsIntegral X] [IsIntegral Y] [IsIntegral Z]
    (f : X ⟶ Y) (g : Y ⟶ Z) [IsDominant f] [IsDominant g]
    [IsDominant (f ≫ g)] :
    (f ≫ g).functionFieldMap =
      g.functionFieldMap ≫ f.functionFieldMap := by
  apply Spec.map_injective
  rw [Spec.map_comp]
  rw [← cancel_mono (Z.fromSpecStalk (genericPoint Z))]
  rw [Category.assoc, Spec_map_functionFieldMap_fromSpecStalk]
  rw [Spec_map_functionFieldMap_fromSpecStalk]
  simpa only [Category.assoc] using congrArg (fun h => h ≫ g)
    (Spec_map_functionFieldMap_fromSpecStalk f).symm

public theorem Hom.functionFieldMap_germToFunctionField
    [IsIntegral X] [IsIntegral Y]
    (f : X ⟶ Y) [IsDominant f]
    (U : Y.Opens) [Nonempty U] (s : Γ(Y, U)) :
    f.functionFieldMap (Y.germToFunctionField U s) =
      X.presheaf.germ (f ⁻¹ᵁ U) (genericPoint X)
        (by
          change f (genericPoint X) ∈ U
          rw [f.map_genericPoint_of_isDominant]
          exact ((genericPoint_spec Y).mem_open_set_iff U.isOpen).mpr
            (by simpa using (inferInstance : Nonempty U)))
        (f.app U s) := by
  let h := f.map_genericPoint_of_isDominant
  change f.stalkMap (genericPoint X)
      ((Y.presheaf.stalkCongr (.of_eq h)).inv
        (Y.germToFunctionField U s)) = _
  simp only [TopCat.Presheaf.stalkCongr_inv]
  change ((Y.germToFunctionField U ≫
      Y.presheaf.stalkSpecializes (Inseparable.of_eq h).le ≫
      f.stalkMap (genericPoint X)).hom) s = _
  rw [Y.presheaf.germ_stalkSpecializes_assoc]
  exact f.germ_stalkMap_apply U (genericPoint X) _ s

end AlgebraicGeometry.Scheme
