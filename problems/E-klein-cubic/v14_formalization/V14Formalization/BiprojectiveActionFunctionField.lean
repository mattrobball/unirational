import V14Formalization.BiprojectiveFunctionFieldProjection

noncomputable section

open CategoryTheory CategoryTheory.Limits TopologicalSpace
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections Module

universe u

variable {Omega : Type u} [Field Omega]

local instance diagonalPullbackActionHom_isIso
    {N : Type u} [Group N] {S : Scheme.{u}}
    (A B : Action (Over S) N) (n : N) :
    IsIso (diagonalPullbackActionHom A B n) := by
  change IsIso ((diagonalPullbackActionOver A B).ρ n).left
  let e : (diagonalPullbackActionOver A B).V.left ≅
      (diagonalPullbackActionOver A B).V.left :=
    (Over.forget S).mapIso ((diagonalPullbackActionOver A B).ρAut n)
  change IsIso e.hom
  infer_instance

/-- Function-field pullback by a diagonal action commutes with the first
projection.  This is the contravariant function-field form of
`diagonalPullbackActionHom_fst`. -/
theorem diagonalPullbackAction_functionFieldMap_fst
    {N : Type u} [Group N] {S : Scheme.{u}}
    (A B : Action (Over S) N)
    [IsIntegral A.V.left] [IsIntegral B.V.left]
    [IsIntegral (pullback A.V.hom B.V.hom)]
    [IsDominant (pullback.fst A.V.hom B.V.hom)]
    (n : N) (x : A.V.left.functionField) :
    (diagonalPullbackActionHom A B n).functionFieldMap
        ((pullback.fst A.V.hom B.V.hom).functionFieldMap x) =
      (pullback.fst A.V.hom B.V.hom).functionFieldMap
        ((Scheme.actionFunctionFieldMap A n).hom x) := by
  let f := diagonalPullbackActionHom A B n
  let pr := pullback.fst A.V.hom B.V.hom
  let a := (A.ρ n).left
  let ea : A.V.left ≅ A.V.left :=
    (Over.forget S).mapIso (A.ρAut n)
  letI : IsIso f := inferInstance
  letI : IsDominant f := inferInstance
  letI : IsDominant pr := by
    dsimp only [pr]
    infer_instance
  letI : IsIso a := by
    change IsIso ea.hom
    infer_instance
  letI : IsDominant a := inferInstance
  have hgeom : f ≫ pr = pr ≫ a :=
    diagonalPullbackActionHom_fst A B n
  have hff : pr.functionFieldMap ≫ f.functionFieldMap =
      a.functionFieldMap ≫ pr.functionFieldMap := by
    calc
      pr.functionFieldMap ≫ f.functionFieldMap =
          (f ≫ pr).functionFieldMap :=
        (Scheme.Hom.functionFieldMap_comp f pr).symm
      _ = (pr ≫ a).functionFieldMap :=
        Scheme.Hom.functionFieldMap_congr (f ≫ pr) (pr ≫ a) hgeom
      _ = a.functionFieldMap ≫ pr.functionFieldMap :=
        Scheme.Hom.functionFieldMap_comp pr a
  exact congrArg (fun h => h.hom x) hff

/-- Function-field pullback by a diagonal action commutes with the second
projection. -/
theorem diagonalPullbackAction_functionFieldMap_snd
    {N : Type u} [Group N] {S : Scheme.{u}}
    (A B : Action (Over S) N)
    [IsIntegral A.V.left] [IsIntegral B.V.left]
    [IsIntegral (pullback A.V.hom B.V.hom)]
    [IsDominant (pullback.snd A.V.hom B.V.hom)]
    (n : N) (x : B.V.left.functionField) :
    (diagonalPullbackActionHom A B n).functionFieldMap
        ((pullback.snd A.V.hom B.V.hom).functionFieldMap x) =
      (pullback.snd A.V.hom B.V.hom).functionFieldMap
        ((Scheme.actionFunctionFieldMap B n).hom x) := by
  let f := diagonalPullbackActionHom A B n
  let pr := pullback.snd A.V.hom B.V.hom
  let b := (B.ρ n).left
  let eb : B.V.left ≅ B.V.left :=
    (Over.forget S).mapIso (B.ρAut n)
  letI : IsIso f := inferInstance
  letI : IsDominant f := inferInstance
  letI : IsDominant pr := by
    dsimp only [pr]
    infer_instance
  letI : IsIso b := by
    change IsIso eb.hom
    infer_instance
  letI : IsDominant b := inferInstance
  have hgeom : f ≫ pr = pr ≫ b :=
    diagonalPullbackActionHom_snd A B n
  have hff : pr.functionFieldMap ≫ f.functionFieldMap =
      b.functionFieldMap ≫ pr.functionFieldMap := by
    calc
      pr.functionFieldMap ≫ f.functionFieldMap =
          (f ≫ pr).functionFieldMap :=
        (Scheme.Hom.functionFieldMap_comp f pr).symm
      _ = (pr ≫ b).functionFieldMap :=
        Scheme.Hom.functionFieldMap_congr (f ≫ pr) (pr ≫ b) hgeom
      _ = b.functionFieldMap ≫ pr.functionFieldMap :=
        Scheme.Hom.functionFieldMap_comp pr b
  exact congrArg (fun h => h.hom x) hff

/-- A dominant morphism over a field preserves the canonical ground-field
embeddings in function fields. -/
theorem functionFieldMap_comp_functionFieldBaseRingHom
    {X Y : Scheme.{u}} [IsIntegral X] [IsIntegral Y]
    (f : X ⟶ Y) [IsDominant f]
    (qX : X ⟶ Spec (.of Omega)) (qY : Y ⟶ Spec (.of Omega))
    (hbase : f ≫ qY = qX) :
    f.functionFieldMap.hom.comp (functionFieldBaseRingHom Omega Y qY) =
      functionFieldBaseRingHom Omega X qX := by
  have h : CommRingCat.ofHom
      (f.functionFieldMap.hom.comp (functionFieldBaseRingHom Omega Y qY)) =
      CommRingCat.ofHom (functionFieldBaseRingHom Omega X qX) := by
    rw [← Spec.map_injective.eq_iff]
    change Spec.map (CommRingCat.ofHom (functionFieldBaseRingHom Omega Y qY) ≫
        f.functionFieldMap) = _
    rw [Spec.map_comp]
    rw [SpecMap_functionFieldBaseRingHom Omega Y qY]
    rw [← Category.assoc, Scheme.Spec_map_functionFieldMap_fromSpecStalk]
    rw [Category.assoc, hbase]
    exact (SpecMap_functionFieldBaseRingHom Omega X qX).symm
  exact congrArg CommRingCat.Hom.hom h

theorem biprojective_fst_functionFieldMap_base
    (p q : ℕ) (c : Omega) :
    (BiprojectiveSpace.fst p q Omega).functionFieldMap
        (functionFieldBaseRingHom Omega (ProjectiveSpace p Omega)
          (ProjectiveSpace.toSpec p Omega) c) =
      functionFieldBaseRingHom Omega (BiprojectiveSpace p q Omega)
        (BiprojectiveSpace.toSpec p q Omega) c := by
  have h := functionFieldMap_comp_functionFieldBaseRingHom
    (BiprojectiveSpace.fst p q Omega)
    (BiprojectiveSpace.toSpec p q Omega)
    (ProjectiveSpace.toSpec p Omega) (by rfl)
  exact DFunLike.congr_fun h c

theorem biprojective_snd_functionFieldMap_base
    (p q : ℕ) (c : Omega) :
    (BiprojectiveSpace.snd p q Omega).functionFieldMap
        (functionFieldBaseRingHom Omega (ProjectiveSpace q Omega)
          (ProjectiveSpace.toSpec q Omega) c) =
      functionFieldBaseRingHom Omega (BiprojectiveSpace p q Omega)
        (BiprojectiveSpace.toSpec p q Omega) c := by
  have h := functionFieldMap_comp_functionFieldBaseRingHom
    (BiprojectiveSpace.snd p q Omega)
    (BiprojectiveSpace.toSpec p q Omega)
    (ProjectiveSpace.toSpec q Omega)
    (BiprojectiveSpace.snd_toSpec p q Omega)
  exact DFunLike.congr_fun h c

end V14Formalization.SchemeGeometry
