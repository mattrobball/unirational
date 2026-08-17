/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.SchemeNormalSpecialization
public import V14Formalization.SchemeFixedRationalMap

/-!
# Equivariance of proper normal specialization

The generic and residue actions of an automorphism on a stable valuation
determine the action on the proper valuative lift.  Uniqueness in the
valuative criterion then proves that specialization commutes with the target
automorphism.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry

universe u v

variable {S X E Y : Scheme.{u}}
  [X.Over S] [E.Over S] [Y.Over S]
  [IsIntegral X] [IsIntegral E]

/-- A normal valuation together with the scheme-level generic and residue
actions induced by a group action.  The last two fields identify these maps
with precomposition by the actions on `X` and `E`; no implicit function-field
functoriality is assumed. -/
public structure EquivariantNormalValuationData
    {S : Scheme.{u}} {N : Type v} [Group N]
    (X E : Action (Over S) N)
    [IsIntegral X.V.left] [IsIntegral E.V.left] where
  normal : NormalValuationData S X.V.left E.V.left
  ringAction : N → (Spec (.of normal.R) ⟶ Spec (.of normal.R))
  sourceFunctionFieldAction :
    N → (Spec (.of X.V.left.functionField) ⟶ Spec (.of X.V.left.functionField))
  exceptionalFunctionFieldAction :
    N → (Spec (.of E.V.left.functionField) ⟶ Spec (.of E.V.left.functionField))
  fraction_natural : ∀ n,
    sourceFunctionFieldAction n ≫
        Spec.map (CommRingCat.ofHom
          (algebraMap normal.R X.V.left.functionField)) =
      Spec.map (CommRingCat.ofHom
          (algebraMap normal.R X.V.left.functionField)) ≫ ringAction n
  residue_natural : ∀ n,
    exceptionalFunctionFieldAction n ≫
        Spec.map (CommRingCat.ofHom normal.residue) =
      Spec.map (CommRingCat.ofHom normal.residue) ≫ ringAction n
  ring_over : ∀ n, ringAction n ≫ normal.toBase = normal.toBase
  source_fromFunctionField : ∀ n {Z : Scheme.{u}}
      (q : X.V.left ⤏ Z),
    (actionPrecomp X n q).fromFunctionField =
      sourceFunctionFieldAction n ≫ q.fromFunctionField
  exceptional_fromFunctionField : ∀ n {Z : Scheme.{u}}
      (q : E.V.left ⤏ Z),
    (actionPrecomp E n q).fromFunctionField =
      exceptionalFunctionFieldAction n ≫ q.fromFunctionField

namespace NormalValuationData

/-- Naturality of the specialized function-field morphism under one
automorphism preserving the valuation and its residue map. -/
public theorem specialFiberMap_natural
    (D : NormalValuationData S X E)
    (f : X ⤏ Y) [f.IsOver S] [IsProper (Y ↘ S)]
    (aR : Spec (.of D.R) ⟶ Spec (.of D.R))
    (aK : Spec (.of X.functionField) ⟶ Spec (.of X.functionField))
    (aE : Spec (.of E.functionField) ⟶ Spec (.of E.functionField))
    (aY : Y ⟶ Y)
    (hfrac :
      aK ≫ Spec.map (CommRingCat.ofHom (algebraMap D.R X.functionField)) =
        Spec.map (CommRingCat.ofHom (algebraMap D.R X.functionField)) ≫ aR)
    (hresidue :
      aE ≫ Spec.map (CommRingCat.ofHom D.residue) =
        Spec.map (CommRingCat.ofHom D.residue) ≫ aR)
    (hRbase : aR ≫ D.toBase = D.toBase)
    (hYbase : aY ≫ Y ↘ S = Y ↘ S)
    (hgeneric :
      aK ≫ f.fromFunctionField = f.fromFunctionField ≫ aY) :
    aE ≫ D.specialFiberMap f = D.specialFiberMap f ≫ aY := by
  have hlift : aR ≫ D.properLift f = D.properLift f ≫ aY := by
    apply D.hom_ext_of_generic_eq
    · rw [Category.assoc, D.properLift_toBase f, hRbase]
    · rw [Category.assoc, hYbase, D.properLift_toBase f]
    · calc
        Spec.map (CommRingCat.ofHom (algebraMap D.R X.functionField)) ≫
            (aR ≫ D.properLift f) =
          (Spec.map (CommRingCat.ofHom (algebraMap D.R X.functionField)) ≫ aR) ≫
            D.properLift f := (Category.assoc _ _ _).symm
        _ = (aK ≫ Spec.map (CommRingCat.ofHom
              (algebraMap D.R X.functionField))) ≫ D.properLift f := by rw [hfrac]
        _ = aK ≫ (Spec.map (CommRingCat.ofHom
              (algebraMap D.R X.functionField)) ≫ D.properLift f) :=
          Category.assoc _ _ _
        _ = aK ≫ f.fromFunctionField := by rw [D.generic_to_properLift f]
        _ = f.fromFunctionField ≫ aY := hgeneric
        _ = (Spec.map (CommRingCat.ofHom
              (algebraMap D.R X.functionField)) ≫ D.properLift f) ≫ aY := by
          rw [D.generic_to_properLift f]
        _ = Spec.map (CommRingCat.ofHom (algebraMap D.R X.functionField)) ≫
            (D.properLift f ≫ aY) := Category.assoc _ _ _
  calc
    aE ≫ D.specialFiberMap f =
        aE ≫ (Spec.map (CommRingCat.ofHom D.residue) ≫ D.properLift f) := rfl
    _ = (aE ≫ Spec.map (CommRingCat.ofHom D.residue)) ≫ D.properLift f :=
      (Category.assoc _ _ _).symm
    _ = (Spec.map (CommRingCat.ofHom D.residue) ≫ aR) ≫ D.properLift f := by
      rw [hresidue]
    _ = Spec.map (CommRingCat.ofHom D.residue) ≫ (aR ≫ D.properLift f) :=
      Category.assoc _ _ _
    _ = Spec.map (CommRingCat.ofHom D.residue) ≫ (D.properLift f ≫ aY) := by
      rw [hlift]
    _ = D.specialFiberMap f ≫ aY := (Category.assoc _ _ _).symm

end NormalValuationData

namespace EquivariantNormalValuationData

variable {S : Scheme.{u}} {N : Type v} [Group N]
  {X E Y : Action (Over S) N}
  [IsIntegral X.V.left] [IsIntegral E.V.left]

/-- Proper specialization along an equivariantly stable normal valuation is
a genuine equivariant rational map. -/
@[expose] public noncomputable def specialize (D : EquivariantNormalValuationData X E)
    [IsProper Y.V.hom]
    (f : EquivariantRationalMap X Y) : EquivariantRationalMap E Y := by
  letI hproper : IsProper (Y.V.left ↘ S) := by
    change IsProper Y.V.hom
    infer_instance
  let q := D.normal.specialize f.map
  refine
    { map := q.1
      isOver := q.2
      equivariant := fun n => ?_ }
  apply Scheme.RationalMap.eq_of_fromFunctionField_eq
  rw [D.exceptional_fromFunctionField]
  rw [fromFunctionField_compHom]
  rw [D.normal.specialize_fromFunctionField]
  apply D.normal.specialFiberMap_natural
  · exact D.fraction_natural n
  · exact D.residue_natural n
  · exact D.ring_over n
  · exact (Y.ρ n).w
  · have h := congrArg Scheme.RationalMap.fromFunctionField (f.equivariant n)
    rw [D.source_fromFunctionField, fromFunctionField_compHom] at h
    exact h

@[expose] public noncomputable def specializeToCentralizerFixedByOfPrecomp
    {G : Type v} [Group G]
    (Y : Action (Over S) G) (sigma : G)
    {X E : Action (Over S) (Subgroup.centralizer ({sigma} : Set G))}
    [IsIntegral X.V.left] [IsIntegral E.V.left]
    (D : EquivariantNormalValuationData X E)
    [IsProper Y.V.hom]
    (q : EquivariantRationalMap E (centralizerRestriction Y sigma))
    (hpre : actionPrecomp E (sigmaInCentralizer sigma) q.map = q.map) :
    EquivariantRationalMap E (fixedByCentralizerAction Y sigma) := by
  letI hYproper : IsProper (Y.V.left ↘ S) := by
    change IsProper Y.V.hom
    infer_instance
  letI : q.map.IsOver S := q.isOver
  have hfixed : q.map.compHom (Y.ρ sigma).left = q.map := by
    calc
      q.map.compHom (Y.ρ sigma).left =
          actionPrecomp E (sigmaInCentralizer sigma) q.map := by
        simpa [centralizerRestriction, sigmaInCentralizer] using
          (q.equivariant (sigmaInCentralizer sigma)).symm
      _ = q.map := hpre
  haveI hclosed : IsClosedImmersion (fixedByι Y sigma).left := by infer_instance
  haveI hproperι : IsProper (fixedByι Y sigma).left := by infer_instance
  haveI hproperFixed : IsProper (FixedBy Y sigma).hom := by
    rw [← (fixedByι Y sigma).w]
    infer_instance
  let r := rationalMapToFixedBy Y sigma q.map hfixed
  refine
    { map := r.1
      isOver := r.2
      equivariant := fun n => ?_ }
  apply Scheme.RationalMap.eq_of_fromFunctionField_eq
  rw [D.exceptional_fromFunctionField, fromFunctionField_compHom]
  have hri : r.1.fromFunctionField ≫ (fixedByι Y sigma).left =
      q.map.fromFunctionField := by
    have h := congrArg Scheme.RationalMap.fromFunctionField
      (rationalMapToFixedBy_comp_ι Y sigma q.map hfixed)
    simpa only [fromFunctionField_compHom, r] using h
  have hq :
      D.exceptionalFunctionFieldAction n ≫ q.map.fromFunctionField =
        q.map.fromFunctionField ≫ (Y.ρ n.1).left := by
    have h := congrArg Scheme.RationalMap.fromFunctionField (q.equivariant n)
    rw [D.exceptional_fromFunctionField, fromFunctionField_compHom] at h
    change D.exceptionalFunctionFieldAction n ≫ q.map.fromFunctionField =
      q.map.fromFunctionField ≫ (Y.ρ n.1).left at h
    exact h
  apply (cancel_mono (fixedByι Y sigma).left).1
  calc
    (D.exceptionalFunctionFieldAction n ≫ r.1.fromFunctionField) ≫
        (fixedByι Y sigma).left =
      D.exceptionalFunctionFieldAction n ≫
        (r.1.fromFunctionField ≫ (fixedByι Y sigma).left) :=
      Category.assoc _ _ _
    _ = D.exceptionalFunctionFieldAction n ≫ q.map.fromFunctionField := by rw [hri]
    _ = q.map.fromFunctionField ≫ (Y.ρ n.1).left := hq
    _ = (r.1.fromFunctionField ≫ (fixedByι Y sigma).left) ≫
        (Y.ρ n.1).left := by rw [hri]
    _ = r.1.fromFunctionField ≫
        ((fixedByι Y sigma).left ≫ (Y.ρ n.1).left) :=
      Category.assoc _ _ _
    _ = r.1.fromFunctionField ≫
        ((fixedByCentralizerAction Y sigma).ρ n).left ≫
          (fixedByι Y sigma).left := by
      have hn := congrArg Over.Hom.left (fixedByCentralizerHom_ι Y sigma n)
      change (fixedByCentralizerHom Y sigma n).left ≫ (fixedByι Y sigma).left =
        (fixedByι Y sigma).left ≫ (Y.ρ n.1).left at hn
      rw [fixedByCentralizerAction_ρ, ← hn]
      rfl
    _ = (r.1.fromFunctionField ≫
        ((fixedByCentralizerAction Y sigma).ρ n).left) ≫
          (fixedByι Y sigma).left := (Category.assoc _ _ _).symm

/-- If the distinguished involution acts trivially on the exceptional
divisor, equivariant normal specialization lands equivariantly in the
scheme-theoretic fixed locus, equipped with its centralizer action. -/
@[expose] public noncomputable def specializeToCentralizerFixedBy
    {G : Type v} [Group G]
    (Y : Action (Over S) G) (sigma : G)
    {X E : Action (Over S) (Subgroup.centralizer ({sigma} : Set G))}
    [IsIntegral X.V.left] [IsIntegral E.V.left]
    (D : EquivariantNormalValuationData X E)
    [IsProper Y.V.hom]
    (f : EquivariantRationalMap X (centralizerRestriction Y sigma))
    (hsigma : E.ρ (sigmaInCentralizer sigma) = 𝟙 E.V) :
    EquivariantRationalMap E (fixedByCentralizerAction Y sigma) := by
  let q := D.specialize f
  exact specializeToCentralizerFixedByOfPrecomp Y sigma D q
    (actionPrecomp_eq_self_of_rho_eq_id E _ hsigma q.map)

/-- Function-field form of `specializeToCentralizerFixedBy`.  It is enough
that the distinguished involution act trivially on the function field of the
exceptional divisor; no equality of scheme automorphisms is required. -/
@[expose] public noncomputable def specializeToCentralizerFixedBy_of_functionField
    {G : Type v} [Group G]
    (Y : Action (Over S) G) (sigma : G)
    {X E : Action (Over S) (Subgroup.centralizer ({sigma} : Set G))}
    [IsIntegral X.V.left] [IsIntegral E.V.left]
    (D : EquivariantNormalValuationData X E)
    [IsProper Y.V.hom]
    (f : EquivariantRationalMap X (centralizerRestriction Y sigma))
    (hsigma : D.exceptionalFunctionFieldAction (sigmaInCentralizer sigma) =
      𝟙 (Spec (.of E.V.left.functionField))) :
    EquivariantRationalMap E (fixedByCentralizerAction Y sigma) := by
  let q := D.specialize f
  apply specializeToCentralizerFixedByOfPrecomp Y sigma D q
  apply Scheme.RationalMap.eq_of_fromFunctionField_eq
  rw [D.exceptional_fromFunctionField, hsigma]
  exact Category.id_comp _

/-- A centralizer-stable normal valuation turns nonexistence of equivariant
rational maps to the fixed locus into nonexistence of a rational map for the
full group.  The input rational map is unrestricted: it need not be dominant. -/
public theorem noEquivariantRationalMap_of_noFixedSpecialization
    {G : Type v} [Group G]
    (X Y : Action (Over S) G) (sigma : G)
    [IsIntegral X.V.left]
    {E : Action (Over S) (Subgroup.centralizer ({sigma} : Set G))}
    [IsIntegral E.V.left]
    (D : EquivariantNormalValuationData
      ((Action.res (Over S) (Subgroup.subtype _)).obj X) E)
    [IsProper Y.V.hom]
    (hsigma : E.ρ (sigmaInCentralizer sigma) = 𝟙 E.V)
    (hno : ¬ HasEquivariantRationalMap E
      (fixedByCentralizerAction Y sigma)) :
    ¬ HasEquivariantRationalMap X Y := by
  rintro ⟨f⟩
  apply hno
  exact ⟨D.specializeToCentralizerFixedBy Y sigma
    (f.res (Subgroup.subtype _)) hsigma⟩

/-- Function-field version of
`noEquivariantRationalMap_of_noFixedSpecialization`.  The input rational map
is unrestricted: it need not be dominant. -/
public theorem noEquivariantRationalMap_of_noFixedSpecialization_of_functionField
    {G : Type v} [Group G]
    (X Y : Action (Over S) G) (sigma : G)
    [IsIntegral X.V.left]
    {E : Action (Over S) (Subgroup.centralizer ({sigma} : Set G))}
    [IsIntegral E.V.left]
    (D : EquivariantNormalValuationData
      ((Action.res (Over S) (Subgroup.subtype _)).obj X) E)
    [IsProper Y.V.hom]
    (hsigma : D.exceptionalFunctionFieldAction (sigmaInCentralizer sigma) =
      𝟙 (Spec (.of E.V.left.functionField)))
    (hno : ¬ HasEquivariantRationalMap E
      (fixedByCentralizerAction Y sigma)) :
    ¬ HasEquivariantRationalMap X Y := by
  rintro ⟨f⟩
  apply hno
  exact ⟨D.specializeToCentralizerFixedBy_of_functionField Y sigma
    (f.res (Subgroup.subtype _)) hsigma⟩

end EquivariantNormalValuationData
end SchemeGeometry
end V14Formalization
