/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.SchemeBaseChangeAction
public import V14Formalization.SchemeFixedLocus

/-!
# Fixed points of a base-changed action come from fixed points upstairs

`baseChangeAction t A` pulls an action on `Over S` back along `t : T ⟶ S`.  Its
carrier is `pullback A.V.hom t`, and the first projection intertwines the two
actions — that is the only real content here, plus its consequence for sections
of the fixed locus.

The consequence is what a base-changed no-fixed-point statement needs.  A
`T`-section of the `sigma`-fixed locus of `baseChangeAction t A`, fixed by the
centralizer of `sigma`, pushes forward along `pullback.fst` to a map
`T ⟶ A.V.left` over `t` with the same fixedness.  So "no centralizer-fixed
`T`-point of `A` over `S`" — which is how
`V14D12FixedPointExclusionOverField.no_centralizer_fixed_point_over` states
hypothesis (b) — already rules out a centralizer-fixed section of the base
change.  No new geometry: the fixed locus is an equalizer and base change is a
right adjoint, so this is bookkeeping about `pullback.lift`.
-/

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry

universe u v

variable {G : Type v} [Group G] {S T : AlgebraicGeometry.Scheme.{u}}

/-- The first projection out of the base change intertwines the two actions. -/
public theorem baseChangeAction_ρ_left_fst (t : T ⟶ S) (A : Action (Over S) G) (g : G) :
    ((baseChangeAction t A).ρ g).left ≫ pullback.fst A.V.hom t =
      pullback.fst A.V.hom t ≫ (A.ρ g).left :=
  pullback.lift_fst _ _ _

/-- Pushing a `T`-section of the base change forward along `pullback.fst` lands
in `A.V.left` and lies over `t`.  Stated on the bare pullback, which is what
`(baseChangeAction t A).V` unfolds to. -/
public theorem baseChange_section_comp_fst_over
    (t : T ⟶ S) (A : Action (Over S) G)
    (y : T ⟶ pullback A.V.hom t)
    (hy : y ≫ pullback.snd A.V.hom t = 𝟙 T) :
    (y ≫ pullback.fst A.V.hom t) ≫ A.V.hom = t := by
  have hcond : pullback.fst A.V.hom t ≫ A.V.hom = pullback.snd A.V.hom t ≫ t :=
    pullback.condition
  calc (y ≫ pullback.fst A.V.hom t) ≫ A.V.hom
      = y ≫ (pullback.fst A.V.hom t ≫ A.V.hom) := Category.assoc _ _ _
    _ = y ≫ (pullback.snd A.V.hom t ≫ t) := congrArg (y ≫ ·) hcond
    _ = (y ≫ pullback.snd A.V.hom t) ≫ t := (Category.assoc _ _ _).symm
    _ = 𝟙 T ≫ t := congrArg (· ≫ t) hy
    _ = t := Category.id_comp t

/-- **The transfer.**  A section of the `sigma`-fixed locus of
`baseChangeAction t A` that is fixed by the whole centralizer of `sigma`
produces a `T`-point of `FixedBy A sigma` lying over `t` and fixed by the whole
centralizer.

This is the direction that matters.  A no-fixed-`T`-point theorem for `A` over
`S` is not on its face a statement about the base change; this says it is one
anyway, so hypothesis (b) can be used against `actionOverBaseChange F` without
re-proving anything. -/
public theorem exists_centralizer_fixed_point_of_baseChange
    (t : T ⟶ S) (A : Action (Over S) G) (sigma : G)
    (y : T ⟶ (fixedByCentralizerAction (baseChangeAction t A) sigma).V.left)
    (hybase :
      y ≫ (fixedByCentralizerAction (baseChangeAction t A) sigma).V.hom = 𝟙 T)
    (hyfixed : ∀ n : Subgroup.centralizer ({sigma} : Set G),
      y ≫ ((fixedByCentralizerAction (baseChangeAction t A) sigma).ρ n).left = y) :
    ∃ z : T ⟶ (FixedBy A sigma).left,
      z ≫ (FixedBy A sigma).hom = t ∧
      ∀ n : Subgroup.centralizer ({sigma} : Set G),
        z ≫ (fixedByCentralizerHom A sigma n).left = z := by
  classical
  let B : Action (Over T) G := baseChangeAction t A
  -- `fixedByCentralizerAction B sigma` has `V = FixedBy B sigma` and
  -- `ρ n = fixedByCentralizerHom B sigma n` by `rfl`, and
  -- `(baseChangeAction t A).V` is the bare pullback by `rfl`.  Retyping the
  -- three inputs here is the whole of the translation; every step below is a
  -- term, so the defeq never has to be found by `rw`.
  let y' : T ⟶ (FixedBy B sigma).left := y
  have hybase' : y' ≫ (FixedBy B sigma).hom = 𝟙 T := hybase
  have hyfixed' : ∀ n : Subgroup.centralizer ({sigma} : Set G),
      y' ≫ (fixedByCentralizerHom B sigma n).left = y' := hyfixed
  let yι : T ⟶ pullback A.V.hom t := y' ≫ (fixedByι B sigma).left
  let w : T ⟶ A.V.left := yι ≫ pullback.fst A.V.hom t
  -- `w` lies over `t`
  have hover : (fixedByι B sigma).left ≫ B.V.hom = (FixedBy B sigma).hom :=
    Over.w (fixedByι B sigma)
  have hyιbase : yι ≫ pullback.snd A.V.hom t = 𝟙 T :=
    (Category.assoc y' (fixedByι B sigma).left B.V.hom).trans
      ((congrArg (y' ≫ ·) hover).trans hybase')
  have hwover : w ≫ A.V.hom = t :=
    baseChange_section_comp_fst_over t A yι hyιbase
  -- `w` is fixed by every centralizer element
  have hwfixed : ∀ n : Subgroup.centralizer ({sigma} : Set G),
      w ≫ (A.ρ n.1).left = w := by
    intro n
    have hι : (fixedByCentralizerHom B sigma n).left ≫ (fixedByι B sigma).left =
        (fixedByι B sigma).left ≫ (B.ρ n.1).left :=
      congrArg (fun h : FixedBy B sigma ⟶ B.V => h.left)
        (fixedByCentralizerHom_ι B sigma n)
    have hstep : yι ≫ (B.ρ n.1).left = yι :=
      (Category.assoc y' (fixedByι B sigma).left (B.ρ n.1).left).trans
        ((congrArg (y' ≫ ·) hι.symm).trans
          ((Category.assoc y' (fixedByCentralizerHom B sigma n).left
              (fixedByι B sigma).left).symm.trans
            (congrArg (· ≫ (fixedByι B sigma).left) (hyfixed' n))))
    calc w ≫ (A.ρ n.1).left
        = yι ≫ (pullback.fst A.V.hom t ≫ (A.ρ n.1).left) := Category.assoc _ _ _
      _ = yι ≫ ((B.ρ n.1).left ≫ pullback.fst A.V.hom t) :=
          congrArg (yι ≫ ·) (baseChangeAction_ρ_left_fst t A n.1).symm
      _ = (yι ≫ (B.ρ n.1).left) ≫ pullback.fst A.V.hom t :=
          (Category.assoc _ _ _).symm
      _ = w := congrArg (· ≫ pullback.fst A.V.hom t) hstep
  -- assemble as a morphism in `Over S` and lift into the fixed locus
  let Z : Over S := Over.mk t
  let wOver : Z ⟶ A.V := Over.homMk w hwover
  have hwOverSigma : wOver ≫ A.ρ sigma = wOver := by
    apply Over.OverMorphism.ext
    exact hwfixed (sigmaInCentralizer sigma)
  let zOver : Z ⟶ FixedBy A sigma := fixedByLift A sigma wOver hwOverSigma
  refine ⟨zOver.left, Over.w zOver, ?_⟩
  intro n
  have hz : zOver ≫ fixedByCentralizerHom A sigma n = zOver := by
    apply equalizer.hom_ext
    calc (zOver ≫ fixedByCentralizerHom A sigma n) ≫ fixedByι A sigma
        = zOver ≫ (fixedByCentralizerHom A sigma n ≫ fixedByι A sigma) :=
          Category.assoc _ _ _
      _ = zOver ≫ (fixedByι A sigma ≫ A.ρ n.1) :=
          congrArg (zOver ≫ ·) (fixedByCentralizerHom_ι A sigma n)
      _ = (zOver ≫ fixedByι A sigma) ≫ A.ρ n.1 := (Category.assoc _ _ _).symm
      _ = wOver ≫ A.ρ n.1 :=
          congrArg (· ≫ A.ρ n.1) (fixedByLift_ι A sigma wOver hwOverSigma)
      _ = wOver := by
          apply Over.OverMorphism.ext
          exact hwfixed n
      _ = zOver ≫ fixedByι A sigma := (fixedByLift_ι A sigma wOver hwOverSigma).symm
  exact congrArg (fun h : Z ⟶ FixedBy A sigma => h.left) hz

end SchemeGeometry
end V14Formalization
