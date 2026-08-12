/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.SchemeEquivariantSpecialization
import Mathlib.AlgebraicGeometry.Morphisms.Flat

/-!
# Constancy as the last geometric input to the fixed-locus obstruction

This file isolates the small categorical argument after normal specialization.
If every over-base rational map from the normal divisor to the fixed locus is
constant, equivariance turns its value into a centralizer-fixed base point.
Consequently the absence of such a point rules out the original equivariant
rational map.  No dominance hypothesis occurs.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry

universe u

variable {S : Scheme.{u}} {N : Type u} [Group N]

/-- Precomposition by an over-base action fixes a rational map induced by a
point of the base. -/
theorem actionPrecomp_constant
    (X : Action (Over S) N) [IrreducibleSpace X.V.left]
    {Z : Scheme.{u}} (n : N) (y : S ⟶ Z) :
    actionPrecomp X n (X.V.hom ≫ y).toRationalMap =
      (X.V.hom ≫ y).toRationalMap := by
  unfold actionPrecomp
  rw [Scheme.RationalMap.comp_toRationalMap]
  rw [← Scheme.RationalMap.compHom_toRationalMap]
  change (((X.ρ n).left ≫ X.V.hom ≫ y).toPartialMap).toRationalMap = _
  rw [← Category.assoc, (X.ρ n).w]

variable {k : Type u} [Field k]

/-- A rational map between schemes over the base is induced by a base-field
point of the target.  The definition is deliberately independent of any
group actions carried by the two schemes. -/
def RationalMapIsConstantOver
    {E Z : Over (Spec (.of k))}
    (q : Scheme.RationalMap E.left Z.left) : Prop :=
  ∃ y : Spec (.of k) ⟶ Z.left,
    q = (E.hom ≫ y).toRationalMap

variable {E Z : Over (Spec (.of k))}
  [IsIntegral E.left]

/-- Descent of the generic-point morphism to a base point implies constancy
of the rational map. -/
theorem rationalMapIsConstantOver_of_fromFunctionField_descends
    (q : Scheme.RationalMap E.left Z.left)
    (hdesc : ∃ y : Spec (.of k) ⟶ Z.left,
      q.fromFunctionField =
        (E.left.fromSpecStalk (genericPoint E.left) ≫ E.hom) ≫ y) :
    RationalMapIsConstantOver q := by
  obtain ⟨y, hy⟩ := hdesc
  refine ⟨y, Scheme.RationalMap.eq_of_fromFunctionField_eq _ _ ?_⟩
  rw [Scheme.RationalMap.fromFunctionField_toRationalMap]
  simpa only [Scheme.PartialMap.fromSpecStalkOfMem_toPartialMap,
    Category.assoc] using hy

variable {E Z : Action (Over (Spec (.of k))) N}
  [IsIntegral E.V.left]

/-- Constancy after the fixed-locus inclusion, with a genuinely fixed ambient
base point, implies constancy as a map to the scheme-theoretic fixed locus.
This lets the geometric input classify only the generic field-valued point;
no global decomposition theorem for the equalizer is required. -/
theorem rationalMapIsConstantOver_fixedBy_of_comp_descends
    {G : Type u} [Group G]
    (Y : Action (Over (Spec (.of k))) G) (sigma : G)
    [IsSeparated Y.V.hom]
    {E : Action (Over (Spec (.of k)))
      (Subgroup.centralizer ({sigma} : Set G))}
    [IsIntegral E.V.left]
    (q : Scheme.RationalMap E.V.left (FixedBy Y sigma).left)
    (y : Spec (.of k) ⟶ Y.V.left)
    (hybase : y ≫ Y.V.hom = 𝟙 _)
    (hyfixed : y ≫ (Y.ρ sigma).left = y)
    (hgeneric :
      q.fromFunctionField ≫ (fixedByι Y sigma).left =
        (E.V.left.fromSpecStalk (genericPoint E.V.left) ≫ E.V.hom) ≫ y) :
    RationalMapIsConstantOver (E := E.V) (Z := FixedBy Y sigma) q := by
  haveI hclosed : IsClosedImmersion (fixedByι Y sigma).left := by
    infer_instance
  let yOver : Over.mk (𝟙 (Spec (.of k))) ⟶ Y.V :=
    Over.homMk y (by
      change y ≫ Y.V.hom = 𝟙 _
      exact hybase)
  have hyfixedOver : yOver ≫ Y.ρ sigma = yOver := by
    apply Over.OverMorphism.ext
    exact hyfixed
  let zOver := fixedByLift Y sigma yOver hyfixedOver
  let z : Spec (.of k) ⟶ (FixedBy Y sigma).left := zOver.left
  have hz := congrArg Over.Hom.left (fixedByLift_ι Y sigma yOver hyfixedOver)
  change zOver.left ≫ (fixedByι Y sigma).left = y at hz
  have hz' : z ≫ (fixedByι Y sigma).left = y := by
    change zOver.left ≫ (fixedByι Y sigma).left = y
    exact hz
  have hff : q.fromFunctionField =
      (E.V.left.fromSpecStalk (genericPoint E.V.left) ≫ E.V.hom) ≫ z := by
    apply (cancel_mono (fixedByι Y sigma).left).1
    calc
      q.fromFunctionField ≫ (fixedByι Y sigma).left =
          (E.V.left.fromSpecStalk (genericPoint E.V.left) ≫ E.V.hom) ≫ y :=
        hgeneric
      _ = (E.V.left.fromSpecStalk (genericPoint E.V.left) ≫ E.V.hom) ≫
          (z ≫ (fixedByι Y sigma).left) := by rw [hz']
      _ = ((E.V.left.fromSpecStalk (genericPoint E.V.left) ≫ E.V.hom) ≫ z) ≫
          (fixedByι Y sigma).left := (Category.assoc _ _ _).symm
  unfold RationalMapIsConstantOver
  refine ⟨z, Scheme.RationalMap.eq_of_fromFunctionField_eq _ _ ?_⟩
  rw [Scheme.RationalMap.fromFunctionField_toRationalMap]
  simpa only [Scheme.PartialMap.fromSpecStalkOfMem_toPartialMap,
    Category.assoc] using hff

/-- If every over-base rational map is constant and the target has no
`N`-fixed base point, no `N`-equivariant rational map exists. -/
theorem noEquivariantRationalMap_of_constant
    (hconst : ∀ q : Scheme.RationalMap E.V.left Z.V.left,
      q.IsOver (Spec (.of k)) → RationalMapIsConstantOver q)
    (hno : ¬ ∃ y : Spec (.of k) ⟶ Z.V.left,
      ∀ n : N, y ≫ (Z.ρ n).left = y) :
    ¬ HasEquivariantRationalMap E Z := by
  rintro ⟨f⟩
  obtain ⟨y, hy⟩ := hconst f.map f.isOver
  apply hno
  refine ⟨y, fun n ↦ ?_⟩
  have heq := f.equivariant n
  rw [hy, actionPrecomp_constant] at heq
  have heqff := congrArg Scheme.RationalMap.fromFunctionField heq
  rw [fromFunctionField_compHom] at heqff
  haveI : Epi
      (E.V.left.fromSpecStalk (genericPoint E.V.left) ≫ E.V.hom) :=
    AlgebraicGeometry.Flat.epi_of_flat_of_surjective _
  apply (cancel_epi
    (E.V.left.fromSpecStalk (genericPoint E.V.left) ≫ E.V.hom)).1
  simpa only [Scheme.RationalMap.fromFunctionField_toRationalMap,
    Scheme.PartialMap.fromSpecStalkOfMem_toPartialMap,
    Category.assoc] using heqff.symm

/-- Section-valued form of `noEquivariantRationalMap_of_constant`.

The constant value of an over-base rational map is automatically a section of
the target structure morphism.  Thus applications only need to exclude honest
base-field points fixed by the action, rather than arbitrary scheme morphisms
from `Spec k`. -/
theorem noEquivariantRationalMap_of_constant_section
    [LocallyOfFiniteType Z.V.hom]
    (hconst : ∀ q : Scheme.RationalMap E.V.left Z.V.left,
      q.IsOver (Spec (.of k)) → RationalMapIsConstantOver q)
    (hno : ¬ ∃ y : Spec (.of k) ⟶ Z.V.left,
      y ≫ Z.V.hom = 𝟙 _ ∧
        ∀ n : N, y ≫ (Z.ρ n).left = y) :
    ¬ HasEquivariantRationalMap E Z := by
  rintro ⟨f⟩
  obtain ⟨y, hy⟩ := hconst f.map f.isOver
  apply hno
  have heqff : f.map.fromFunctionField =
      (E.V.hom ≫ y).toRationalMap.fromFunctionField :=
    congrArg Scheme.RationalMap.fromFunctionField hy
  rw [Scheme.RationalMap.fromFunctionField_toRationalMap] at heqff
  letI hZlft : LocallyOfFiniteType
      (Z.V.left ↘ Spec (.of k)) := by
    change LocallyOfFiniteType Z.V.hom
    infer_instance
  let qffOver :=
    (Scheme.RationalMap.equivFunctionFieldOver
      (S := Spec (.of k))).symm
      (⟨f.map, f.isOver⟩ :
        {q : Scheme.RationalMap E.V.left Z.V.left //
          q.IsOver (Spec (.of k))})
  letI : f.map.fromFunctionField.IsOver (Spec (.of k)) := qffOver.2
  have hover : f.map.fromFunctionField ≫ Z.V.hom =
      E.V.left.fromSpecStalk (genericPoint E.V.left) ≫ E.V.hom :=
    (Scheme.Hom.isOver_iff (Spec (.of k))).mp (show
      f.map.fromFunctionField.IsOver (Spec (.of k)) by infer_instance)
  let ι := E.V.left.fromSpecStalk (genericPoint E.V.left)
  haveI : Epi (ι ≫ E.V.hom) :=
    AlgebraicGeometry.Flat.epi_of_flat_of_surjective _
  have hsection : y ≫ Z.V.hom = 𝟙 _ := by
    apply (cancel_epi (ι ≫ E.V.hom)).1
    simpa only [heqff,
      Scheme.PartialMap.fromSpecStalkOfMem_toPartialMap,
      Category.assoc, Category.comp_id] using hover
  have hfixed : ∀ n : N, y ≫ (Z.ρ n).left = y := by
    intro n
    have heq := f.equivariant n
    rw [hy, actionPrecomp_constant] at heq
    have heqff' := congrArg Scheme.RationalMap.fromFunctionField heq
    rw [fromFunctionField_compHom] at heqff'
    apply (cancel_epi (ι ≫ E.V.hom)).1
    simpa only [Scheme.RationalMap.fromFunctionField_toRationalMap,
      Scheme.PartialMap.fromSpecStalkOfMem_toPartialMap,
      Category.assoc] using heqff'.symm
  exact ⟨y, hsection, hfixed⟩

namespace EquivariantNormalValuationData

variable {G : Type u} [Group G]

/-- Faithful abstract endpoint for the centralizer argument.  A stable normal
valuation, function-field triviality of the involution on the normal divisor,
constancy of rational maps into the fixed locus, and absence of a fixed base
point together exclude every equivariant rational map, dominant or not. -/
theorem noEquivariantRationalMap_of_constant_fixedSpecialization
    (X Y : Action (Over (Spec (.of k))) G) (sigma : G)
    [IsIntegral X.V.left]
    {E : Action (Over (Spec (.of k)))
      (Subgroup.centralizer ({sigma} : Set G))}
    [IsIntegral E.V.left]
    (D : EquivariantNormalValuationData
      ((Action.res (Over (Spec (.of k))) (Subgroup.subtype _)).obj X) E)
    [IsProper Y.V.hom]
    (hsigma : D.exceptionalFunctionFieldAction (sigmaInCentralizer sigma) =
      𝟙 (Spec (.of E.V.left.functionField)))
    (hconst : ∀ q : Scheme.RationalMap E.V.left
        (fixedByCentralizerAction Y sigma).V.left,
      q.IsOver (Spec (.of k)) →
        RationalMapIsConstantOver (E := E.V)
          (Z := (fixedByCentralizerAction Y sigma).V) q)
    (hno : ¬ ∃ y : Spec (.of k) ⟶
        (fixedByCentralizerAction Y sigma).V.left,
      ∀ n : Subgroup.centralizer ({sigma} : Set G),
        y ≫ ((fixedByCentralizerAction Y sigma).ρ n).left = y) :
    ¬ HasEquivariantRationalMap X Y := by
  apply D.noEquivariantRationalMap_of_noFixedSpecialization_of_functionField
    X Y sigma hsigma
  exact noEquivariantRationalMap_of_constant hconst hno

/-- Section-valued version of
`noEquivariantRationalMap_of_constant_fixedSpecialization`.  This is the
natural endpoint for a coordinate certificate excluding fixed `k`-points. -/
theorem noEquivariantRationalMap_of_constant_fixedSpecialization_section
    (X Y : Action (Over (Spec (.of k))) G) (sigma : G)
    [IsIntegral X.V.left]
    {E : Action (Over (Spec (.of k)))
      (Subgroup.centralizer ({sigma} : Set G))}
    [IsIntegral E.V.left]
    (D : EquivariantNormalValuationData
      ((Action.res (Over (Spec (.of k))) (Subgroup.subtype _)).obj X) E)
    [IsProper Y.V.hom]
    (hsigma : D.exceptionalFunctionFieldAction (sigmaInCentralizer sigma) =
      𝟙 (Spec (.of E.V.left.functionField)))
    (hconst : ∀ q : Scheme.RationalMap E.V.left
        (fixedByCentralizerAction Y sigma).V.left,
      q.IsOver (Spec (.of k)) →
        RationalMapIsConstantOver (E := E.V)
          (Z := (fixedByCentralizerAction Y sigma).V) q)
    (hno : ¬ ∃ y : Spec (.of k) ⟶
        (fixedByCentralizerAction Y sigma).V.left,
      y ≫ (fixedByCentralizerAction Y sigma).V.hom = 𝟙 _ ∧
        ∀ n : Subgroup.centralizer ({sigma} : Set G),
          y ≫ ((fixedByCentralizerAction Y sigma).ρ n).left = y) :
    ¬ HasEquivariantRationalMap X Y := by
  letI hclosed : IsClosedImmersion (fixedByι Y sigma).left := inferInstance
  letI hlftι : LocallyOfFiniteType (fixedByι Y sigma).left := inferInstance
  letI hlftFixed : LocallyOfFiniteType
      (fixedByCentralizerAction Y sigma).V.hom := by
    change LocallyOfFiniteType (FixedBy Y sigma).hom
    rw [← (fixedByι Y sigma).w]
    infer_instance
  apply D.noEquivariantRationalMap_of_noFixedSpecialization_of_functionField
    X Y sigma hsigma
  apply noEquivariantRationalMap_of_constant_section hconst hno

end EquivariantNormalValuationData
end SchemeGeometry
end V14Formalization
