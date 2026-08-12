/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.SchemeEquivariant
import Mathlib.AlgebraicGeometry.Limits
import Mathlib.AlgebraicGeometry.Morphisms.Separated
import Mathlib.CategoryTheory.Limits.Shapes.Equalizers

/-!
# Fixed loci of automorphisms of schemes

For an action on a scheme over `S`, the fixed locus of one group element is
the categorical equalizer of the identity and that element's automorphism.
Thus this is the scheme-theoretic fixed locus, with its full universal
property, rather than merely a predicate on rational points.
-/

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

universe u v w

open AlgebraicGeometry

variable {S : Scheme.{u}} {G : Type v} [Group G]

/-! ## Absolute fixed loci -/

/-- Fixed locus of one automorphism in the category of schemes. -/
abbrev AbsoluteFixedBy (X : Action Scheme G) (g : G) : Scheme :=
  equalizer (𝟙 X.V) (X.ρ g)

/-- Inclusion of an absolute fixed locus. -/
abbrev absoluteFixedByι (X : Action Scheme G) (g : G) :
    AbsoluteFixedBy X g ⟶ X.V :=
  equalizer.ι (𝟙 X.V) (X.ρ g)

@[reassoc]
theorem absoluteFixedByι_comp_action (X : Action Scheme G) (g : G) :
    absoluteFixedByι X g ≫ X.ρ g = absoluteFixedByι X g := by
  simpa only [absoluteFixedByι, Category.comp_id] using
    (equalizer.condition (𝟙 X.V) (X.ρ g)).symm

/-- Scheme-theoretic intersection of two absolute fixed loci. -/
abbrev AbsoluteFixedByPair (X : Action Scheme G) (g h : G) : Scheme :=
  pullback (absoluteFixedByι X g) (absoluteFixedByι X h)

/-- Inclusion of the absolute simultaneous fixed locus. -/
abbrev absoluteFixedByPairι (X : Action Scheme G) (g h : G) :
    AbsoluteFixedByPair X g h ⟶ X.V :=
  pullback.fst (absoluteFixedByι X g) (absoluteFixedByι X h) ≫
    absoluteFixedByι X g

theorem absoluteFixedByPairι_eq_snd (X : Action Scheme G) (g h : G) :
    absoluteFixedByPairι X g h =
      pullback.snd (absoluteFixedByι X g) (absoluteFixedByι X h) ≫
        absoluteFixedByι X h :=
  pullback.condition

@[reassoc]
theorem absoluteFixedByPairι_comp_leftAction
    (X : Action Scheme G) (g h : G) :
    absoluteFixedByPairι X g h ≫ X.ρ g = absoluteFixedByPairι X g h := by
  simp only [absoluteFixedByPairι, Category.assoc, absoluteFixedByι_comp_action]

@[reassoc]
theorem absoluteFixedByPairι_comp_rightAction
    (X : Action Scheme G) (g h : G) :
    absoluteFixedByPairι X g h ≫ X.ρ h = absoluteFixedByPairι X g h := by
  rw [absoluteFixedByPairι_eq_snd]
  simp only [Category.assoc, absoluteFixedByι_comp_action]

/-- The scheme-theoretic fixed locus of `g`, formed in schemes over `S`. -/
abbrev FixedBy (X : Action (Over S) G) (g : G) : Over S :=
  equalizer (𝟙 X.V) (X.ρ g)

/-- The canonical inclusion of the fixed locus into the original scheme. -/
abbrev fixedByι (X : Action (Over S) G) (g : G) : FixedBy X g ⟶ X.V :=
  equalizer.ι (𝟙 X.V) (X.ρ g)

@[reassoc]
theorem fixedByι_comp_action (X : Action (Over S) G) (g : G) :
    fixedByι X g ≫ X.ρ g = fixedByι X g := by
  simpa only [fixedByι, Category.comp_id] using
    (equalizer.condition (𝟙 X.V) (X.ρ g)).symm

/-- A map whose image is fixed by `g` factors through the fixed subscheme. -/
noncomputable def fixedByLift {Z : Over S} (X : Action (Over S) G) (g : G)
    (p : Z ⟶ X.V) (hp : p ≫ X.ρ g = p) : Z ⟶ FixedBy X g :=
  equalizer.lift p (by simpa only [Category.comp_id] using hp.symm)

@[reassoc (attr := simp)]
theorem fixedByLift_ι {Z : Over S} (X : Action (Over S) G) (g : G)
    (p : Z ⟶ X.V) (hp : p ≫ X.ρ g = p) :
    fixedByLift X g p hp ≫ fixedByι X g = p :=
  equalizer.lift_ι _ _

/-- The fixed-locus factorization is unique. -/
theorem fixedBy_hom_ext {Z : Over S} (X : Action (Over S) G) (g : G)
    {a b : Z ⟶ FixedBy X g}
    (h : a ≫ fixedByι X g = b ≫ fixedByι X g) : a = b := by
  exact equalizer.hom_ext h

/-! ## The centralizer action on a fixed locus -/

/-- The distinguished element as an element of its own centralizer. -/
def sigmaInCentralizer (sigma : G) :
    Subgroup.centralizer ({sigma} : Set G) :=
  ⟨sigma, by
    rw [Subgroup.mem_centralizer_iff]
    intro h hh
    rw [Set.mem_singleton_iff] at hh
    subst h
    rfl⟩

@[simp]
theorem sigmaInCentralizer_coe (sigma : G) :
    (sigmaInCentralizer sigma : G) = sigma := rfl

/-- Restrict an action to the centralizer of `sigma`. -/
abbrev centralizerRestriction (X : Action (Over S) G) (sigma : G) :
    Action (Over S) (Subgroup.centralizer ({sigma} : Set G)) where
  V := X.V
  ρ := X.ρ.comp (Subgroup.subtype _)

/-- An element centralizing `sigma` restricts to an automorphism of the
scheme-theoretic `sigma`-fixed locus. -/
noncomputable def fixedByCentralizerHom (X : Action (Over S) G) (sigma : G)
    (n : Subgroup.centralizer ({sigma} : Set G)) :
    FixedBy X sigma ⟶ FixedBy X sigma :=
  fixedByLift X sigma (fixedByι X sigma ≫ X.ρ n.1) (by
    have hn : n.1 * sigma = sigma * n.1 :=
      (Subgroup.mem_centralizer_iff.mp n.2 sigma (by simp)).symm
    have hsigma_n := X.ρ.map_mul sigma n.1
    change X.ρ (sigma * n.1) = X.ρ n.1 ≫ X.ρ sigma at hsigma_n
    have hn_sigma := X.ρ.map_mul n.1 sigma
    change X.ρ (n.1 * sigma) = X.ρ sigma ≫ X.ρ n.1 at hn_sigma
    calc
      (fixedByι X sigma ≫ X.ρ n.1) ≫ X.ρ sigma =
          fixedByι X sigma ≫ (X.ρ n.1 ≫ X.ρ sigma) := Category.assoc _ _ _
      _ = fixedByι X sigma ≫ X.ρ (sigma * n.1) := by rw [hsigma_n]
      _ = fixedByι X sigma ≫ X.ρ (n.1 * sigma) := by rw [hn]
      _ = fixedByι X sigma ≫ (X.ρ sigma ≫ X.ρ n.1) := by rw [hn_sigma]
      _ = (fixedByι X sigma ≫ X.ρ sigma) ≫ X.ρ n.1 :=
        (Category.assoc _ _ _).symm
      _ = fixedByι X sigma ≫ X.ρ n.1 := by rw [fixedByι_comp_action])

@[reassoc (attr := simp)]
theorem fixedByCentralizerHom_ι (X : Action (Over S) G) (sigma : G)
    (n : Subgroup.centralizer ({sigma} : Set G)) :
    fixedByCentralizerHom X sigma n ≫ fixedByι X sigma =
      fixedByι X sigma ≫ X.ρ n.1 :=
  fixedByLift_ι _ _ _ _

@[simp]
theorem fixedByCentralizerHom_one (X : Action (Over S) G) (sigma : G) :
    fixedByCentralizerHom X sigma 1 = 𝟙 _ := by
  apply fixedBy_hom_ext X sigma
  simp

theorem fixedByCentralizerHom_mul (X : Action (Over S) G) (sigma : G)
    (n m : Subgroup.centralizer ({sigma} : Set G)) :
    fixedByCentralizerHom X sigma (n * m) =
      fixedByCentralizerHom X sigma m ≫ fixedByCentralizerHom X sigma n := by
  apply fixedBy_hom_ext X sigma
  have hmul := X.ρ.map_mul n.1 m.1
  change X.ρ (n.1 * m.1) = X.ρ m.1 ≫ X.ρ n.1 at hmul
  calc
    fixedByCentralizerHom X sigma (n * m) ≫ fixedByι X sigma =
        fixedByι X sigma ≫ X.ρ (n * m).1 := fixedByCentralizerHom_ι _ _ _
    _ = fixedByι X sigma ≫ X.ρ (n.1 * m.1) := rfl
    _ = fixedByι X sigma ≫ (X.ρ m.1 ≫ X.ρ n.1) := by rw [hmul]
    _ = (fixedByι X sigma ≫ X.ρ m.1) ≫ X.ρ n.1 :=
      (Category.assoc _ _ _).symm
    _ = (fixedByCentralizerHom X sigma m ≫ fixedByι X sigma) ≫ X.ρ n.1 := by
      rw [fixedByCentralizerHom_ι]
    _ = fixedByCentralizerHom X sigma m ≫
        (fixedByι X sigma ≫ X.ρ n.1) := Category.assoc _ _ _
    _ = fixedByCentralizerHom X sigma m ≫
        (fixedByCentralizerHom X sigma n ≫ fixedByι X sigma) := by
      rw [fixedByCentralizerHom_ι]
    _ = (fixedByCentralizerHom X sigma m ≫ fixedByCentralizerHom X sigma n) ≫
        fixedByι X sigma := (Category.assoc _ _ _).symm

/-- The centralizer of `sigma` acts canonically on the scheme-theoretic
`sigma`-fixed locus. -/
noncomputable def fixedByCentralizerAction (X : Action (Over S) G) (sigma : G) :
    Action (Over S) (Subgroup.centralizer ({sigma} : Set G)) where
  V := FixedBy X sigma
  ρ :=
    { toFun := fixedByCentralizerHom X sigma
      map_one' := fixedByCentralizerHom_one X sigma
      map_mul' := fixedByCentralizerHom_mul X sigma }

@[simp]
theorem fixedByCentralizerAction_ρ (X : Action (Over S) G) (sigma : G)
    (n : Subgroup.centralizer ({sigma} : Set G)) :
    (fixedByCentralizerAction X sigma).ρ n = fixedByCentralizerHom X sigma n :=
  rfl

/-! ## Simultaneous fixed loci -/

/-- The scheme-theoretic intersection of the fixed loci of `g` and `h`. -/
abbrev FixedByPair (X : Action (Over S) G) (g h : G) : Over S :=
  pullback (fixedByι X g) (fixedByι X h)

/-- The simultaneous fixed-locus inclusion into the original scheme. -/
abbrev fixedByPairι (X : Action (Over S) G) (g h : G) :
    FixedByPair X g h ⟶ X.V :=
  pullback.fst (fixedByι X g) (fixedByι X h) ≫ fixedByι X g

theorem fixedByPairι_eq_snd (X : Action (Over S) G) (g h : G) :
    fixedByPairι X g h =
      pullback.snd (fixedByι X g) (fixedByι X h) ≫ fixedByι X h :=
  pullback.condition

@[reassoc]
theorem fixedByPairι_comp_leftAction (X : Action (Over S) G) (g h : G) :
    fixedByPairι X g h ≫ X.ρ g = fixedByPairι X g h := by
  simp only [fixedByPairι, Category.assoc, fixedByι_comp_action]

@[reassoc]
theorem fixedByPairι_comp_rightAction (X : Action (Over S) G) (g h : G) :
    fixedByPairι X g h ≫ X.ρ h = fixedByPairι X g h := by
  rw [fixedByPairι_eq_snd]
  simp only [Category.assoc, fixedByι_comp_action]

/-- A map fixed by both `g` and `h` factors through their simultaneous fixed
locus. -/
noncomputable def fixedByPairLift {Z : Over S} (X : Action (Over S) G) (g h : G)
    (p : Z ⟶ X.V) (hg : p ≫ X.ρ g = p) (hh : p ≫ X.ρ h = p) :
    Z ⟶ FixedByPair X g h :=
  pullback.lift (fixedByLift X g p hg) (fixedByLift X h p hh) (by simp)

@[reassoc (attr := simp)]
theorem fixedByPairLift_ι {Z : Over S} (X : Action (Over S) G) (g h : G)
    (p : Z ⟶ X.V) (hg : p ≫ X.ρ g = p) (hh : p ≫ X.ρ h = p) :
    fixedByPairLift X g h p hg hh ≫ fixedByPairι X g h = p := by
  change pullback.lift (fixedByLift X g p hg) (fixedByLift X h p hh) _ ≫
      pullback.fst (fixedByι X g) (fixedByι X h) ≫ fixedByι X g = p
  rw [← Category.assoc, pullback.lift_fst, fixedByLift_ι]

/-- Maps into the simultaneous fixed locus are determined by their composite
with its inclusion. -/
theorem fixedByPair_hom_ext {Z : Over S} (X : Action (Over S) G) (g h : G)
    {a b : Z ⟶ FixedByPair X g h}
    (H : a ≫ fixedByPairι X g h = b ≫ fixedByPairι X g h) : a = b := by
  apply pullback.hom_ext
  · apply fixedBy_hom_ext X g
    simpa only [fixedByPairι, Category.assoc] using H
  · apply fixedBy_hom_ext X h
    simpa only [Category.assoc, ← fixedByPairι_eq_snd] using H

/-- If the target scheme is separated over `S`, its fixed locus is a closed
subscheme. -/
instance fixedByι_isClosedImmersion (X : Action (Over S) G) (g : G)
    [IsSeparated X.V.hom] : IsClosedImmersion (fixedByι X g).left := by
  infer_instance

/-- A simultaneous fixed locus is a closed subscheme when the acted scheme is
separated over the base. -/
instance fixedByPairι_isClosedImmersion (X : Action (Over S) G) (g h : G)
    [IsSeparated X.V.hom] : IsClosedImmersion (fixedByPairι X g h).left := by
  let f := fixedByι X g
  let k := fixedByι X h
  have hsquare : IsPullback
      (pullback.fst f k).left (pullback.snd f k).left f.left k.left :=
    (Over.forget S).map_isPullback (IsPullback.of_hasPullback f k)
  haveI : IsClosedImmersion (pullback.fst f k).left :=
    MorphismProperty.of_isPullback hsquare.flip inferInstance
  change IsClosedImmersion ((pullback.fst f k).left ≫ f.left)
  infer_instance

end SchemeGeometry
end V14Formalization
