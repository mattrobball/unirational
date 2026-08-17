/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.SchemeEquivariant

/-!
# Function-field pullback and rational-map precomposition

A dominant scheme morphism induces the expected pullback on generic stalks,
and taking the function-field representative of a rational map commutes with
precomposition. Action automorphisms provide dominance automatically.
-/

open CategoryTheory TopologicalSpace
open AlgebraicGeometry

universe u v

namespace AlgebraicGeometry.Scheme

variable {X Y Z : Scheme.{u}}

public lemma Hom.map_genericPoint_of_isDominant
    [IrreducibleSpace X] [IrreducibleSpace Y]
    (f : X ⟶ Y) [IsDominant f] :
    f (genericPoint X) = genericPoint Y := by
  symm
  apply (genericPoint_spec Y).eq
  convert (genericPoint_spec X).image f.continuous using 1
  rw [Set.image_univ]
  exact (Set.eq_univ_of_forall f.denseRange).symm

/-- The pullback on function fields induced by a dominant morphism. -/
@[expose] public noncomputable def Hom.functionFieldMap
    [IrreducibleSpace X] [IrreducibleSpace Y]
    (f : X ⟶ Y) [IsDominant f] :
    Y.functionField ⟶ X.functionField := by
  let h := f.map_genericPoint_of_isDominant
  exact (Y.presheaf.stalkCongr (.of_eq h)).inv ≫ f.stalkMap (genericPoint X)

@[reassoc]
public lemma Spec_map_functionFieldMap_fromSpecStalk
    [IrreducibleSpace X] [IrreducibleSpace Y]
    (f : X ⟶ Y) [IsDominant f] :
    Spec.map f.functionFieldMap ≫ Y.fromSpecStalk (genericPoint Y) =
      X.fromSpecStalk (genericPoint X) ≫ f := by
  let h := f.map_genericPoint_of_isDominant
  change Spec.map ((Y.presheaf.stalkCongr (.of_eq h)).inv ≫
      f.stalkMap (genericPoint X)) ≫ Y.fromSpecStalk (genericPoint Y) = _
  rw [TopCat.Presheaf.stalkCongr_inv, Spec.map_comp, Category.assoc,
    Scheme.SpecMap_stalkSpecializes_fromSpecStalk (Inseparable.of_eq h).specializes,
    Scheme.SpecMap_stalkMap_fromSpecStalk]

lemma Spec_map_functionFieldMap_fromSpecStalkOfMem
    [IrreducibleSpace X] [IrreducibleSpace Y]
    (f : X ⟶ Y) [IsDominant f] (U : Y.Opens)
    (hU : genericPoint Y ∈ U) :
    Spec.map f.functionFieldMap ≫ U.fromSpecStalkOfMem (genericPoint Y) hU =
      (f ⁻¹ᵁ U).fromSpecStalkOfMem (genericPoint X) (by
        change f (genericPoint X) ∈ U
        rw [f.map_genericPoint_of_isDominant]
        exact hU) ≫ f ∣_ U := by
  rw [← cancel_mono U.ι]
  simp only [Category.assoc, Opens.fromSpecStalkOfMem_ι,
    Opens.fromSpecStalkOfMem_ι_assoc, morphismRestrict_ι]
  exact Spec_map_functionFieldMap_fromSpecStalk f

theorem PartialMap.fromFunctionField_comp_toPartialMap
    [IrreducibleSpace X] [IrreducibleSpace Y]
    (f : X ⟶ Y) [IsDominant f] (q : Y.PartialMap Z) :
    (f.toPartialMap.comp q).fromFunctionField =
      Spec.map f.functionFieldMap ≫ q.fromFunctionField := by
  let p := f.toPartialMap
  have hp : genericPoint X ∈ p.domain :=
    (genericPoint_specializes _).mem_open p.domain.2 p.dense_domain.nonempty.choose_spec
  change (p.comp q).fromFunctionField = _
  dsimp only [PartialMap.fromFunctionField, PartialMap.fromSpecStalkOfMem,
    PartialMap.comp]
  simp only [← Category.assoc]
  change (_ : Spec X.functionField ⟶ q.domain) ≫ q.hom =
    (_ : Spec X.functionField ⟶ q.domain) ≫ q.hom
  congr 1
  rw [← cancel_mono q.domain.ι]
  simp only [Category.assoc, morphismRestrict_ι,
    Opens.fromSpecStalkOfMem_ι]
  have hrestrict (hD' : genericPoint X ∈
      p.domain.ι ''ᵁ p.hom ⁻¹ᵁ q.domain) :
      (p.domain.ι ''ᵁ p.hom ⁻¹ᵁ q.domain).fromSpecStalkOfMem
          (genericPoint X) hD' ≫
            (p.domain.ι.isoImage (p.hom ⁻¹ᵁ q.domain)).inv ≫
              (p.hom ⁻¹ᵁ q.domain).ι =
        p.domain.fromSpecStalkOfMem (genericPoint X) hp := by
    rw [← cancel_mono p.domain.ι]
    simp only [Category.assoc, Scheme.Hom.isoImage_inv_ι,
      Opens.fromSpecStalkOfMem_ι]
  have hD' : genericPoint X ∈ p.domain.ι ''ᵁ p.hom ⁻¹ᵁ q.domain := by
    change genericPoint X ∈ (p.comp q).domain
    exact (genericPoint_specializes _).mem_open (p.comp q).domain.2
      (p.comp q).dense_domain.nonempty.choose_spec
  have hrestrict_assoc := congrArg (fun k ↦ k ≫ p.hom) (hrestrict hD')
  simp only [Category.assoc] at hrestrict_assoc ⊢
  rw [hrestrict_assoc]
  change p.fromSpecStalkOfMem hp = _
  change f.toPartialMap.fromSpecStalkOfMem hp = _
  rw [PartialMap.fromSpecStalkOfMem_toPartialMap]
  exact (Spec_map_functionFieldMap_fromSpecStalk f).symm

public theorem RationalMap.fromFunctionField_comp_toRationalMap
    [IrreducibleSpace X] [IrreducibleSpace Y]
    (f : X ⟶ Y) [IsDominant f] (q : Y.RationalMap Z) :
    (f.toRationalMap.comp q).fromFunctionField =
      Spec.map f.functionFieldMap ≫ q.fromFunctionField := by
  obtain ⟨q, rfl⟩ := q.exists_rep
  rw [RationalMap.toRationalMap_comp]
  exact q.fromFunctionField_comp_toPartialMap f

theorem RationalMap.fromFunctionField_comp_toRationalMap_of_isIso
    [IrreducibleSpace X] (f : X ⟶ X) [IsIso f] (q : X.RationalMap Z) :
    (f.toRationalMap.comp q).fromFunctionField =
      Spec.map f.functionFieldMap ≫ q.fromFunctionField :=
  q.fromFunctionField_comp_toRationalMap f

@[expose] public noncomputable def actionFunctionFieldMap
    {S : Scheme.{u}} {G : Type v} [Group G]
    (X : Action (Over S) G) [IrreducibleSpace X.V.left]
    (g : G) : X.V.left.functionField ⟶ X.V.left.functionField := by
  let e : X.V.left ≅ X.V.left := (Over.forget S).mapIso (X.ρAut g)
  letI : IsIso (X.ρ g).left := by
    change IsIso e.hom
    infer_instance
  letI : IsDominant (X.ρ g).left := inferInstance
  exact (X.ρ g).left.functionFieldMap

public theorem actionPrecomp_fromFunctionField_generic
    {S : Scheme.{u}} {G : Type v} [Group G]
    (X : Action (Over S) G) [IrreducibleSpace X.V.left]
    {W : Scheme.{u}} (g : G) (q : X.V.left.RationalMap W) :
    (V14Formalization.SchemeGeometry.actionPrecomp X g q).fromFunctionField =
      Spec.map (actionFunctionFieldMap X g) ≫ q.fromFunctionField := by
  let e : X.V.left ≅ X.V.left := (Over.forget S).mapIso (X.ρAut g)
  letI : IsIso (X.ρ g).left := by
    change IsIso e.hom
    infer_instance
  letI : IsDominant (X.ρ g).left := inferInstance
  change (((X.ρ g).left.toRationalMap.comp q).fromFunctionField = _)
  change _ = Spec.map ((X.ρ g).left.functionFieldMap) ≫ q.fromFunctionField
  exact q.fromFunctionField_comp_toRationalMap (X.ρ g).left

