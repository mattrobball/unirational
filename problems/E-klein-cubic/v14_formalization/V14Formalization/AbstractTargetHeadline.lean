/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.BlockNormalSigma
public import V14Formalization.CentralizerObstruction
public import V14Formalization.ProjectiveSpaceIntrinsicCompare
public import V14Formalization.ProjectiveSpaceIntrinsicIrreducible
public import V14Formalization.SchemeEquivariantTransport
public import V14Formalization.SchemeRationalConstancy

/-!
# The scheme-level centralizer obstruction, over an abstract target

`FaithfulHeadline` proves that there is no `G`-equivariant rational map from
`ℙ(V)` to the *coordinate* V14.  This file records what the proof actually uses
about that target, and states the theorem over any target with those
properties.

The interface is three items, and nothing else:

1. `[IsProper Y.V.hom]` — the valuative criterion extends the generic point of
   the exceptional divisor across the normal valuation
   (`SchemeNormalSpecialization.properLiftStruct`);
2. `TargetHypothesisA` — every rational map over the base from a biprojective
   space to the `σ`-fixed locus of `Y` is constant;
3. `TargetHypothesisB` — the `σ`-fixed locus of `Y` has no base-field section
   fixed by the whole centralizer of `σ`.

Everything else the argument needs — separatedness, finite type, the closed
immersion `Y^σ ↪ Y` — is *derived* from properness, not assumed:
`SchemeFixedLocus.fixedByι_isClosedImmersion` needs `IsSeparated Y.V.hom`, and
`SchemeRationalConstancy.noEquivariantRationalMap_of_constant_section` needs
`LocallyOfFiniteType`, both of which `IsProper` supplies.  No irreducibility,
no closed immersion into a numbered `ℙⁿ`, no `ProjectiveGVariety` bundling, and
no smoothness is used anywhere.

This is the scheme-theoretic counterpart of `CentralizerObstruction`'s
Theorem 3.1 (`centralizerObstruction_one_rep`), which states the same
obstruction for `SmoothProjectiveGVariety` and resolved morphisms; the argument
parameters are spelled the same way (`σ`, `hσ`, `hG`, `ha`, `hb`) so the two
can be read side by side.

## What is *not* in the statement

No `projectorMatrix`, no `grassmannianLinearSection`, no `Λ²U`, no Weil
representation, and no cyclotomic field: the base field is an arbitrary
characteristic-zero field.  The primitive 11th root of unity that
`BaseFieldCriteria` records as a criterion is a requirement of the *coordinate
V14 model*, not of this argument; once the target is a parameter it disappears,
and `[CharZero F]` — needed to split the `σ`-eigenspaces, i.e. for `1/2` — is
all that remains.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections Module

universe u

variable (F : Type u) [Field F] {G : Type u} [Group G]

/-- **Hypothesis (a) for a target.**  Every rational map over `Spec F` from a
biprojective space to the scheme-theoretic `σ`-fixed locus of `Y` is constant.

Geometrically: the positive-dimensional part of `Y^σ` contains no rational
curve, so the exceptional divisor of the blow-up along `ℙ(V₊)` cannot map to it
non-constantly.  The biprojective space is the exceptional divisor of that
blow-up, in the chart the normal valuation uses; `p` and `q` are the projective
dimensions of the two `σ`-eigenspaces, which are not known in advance, hence
the quantifier over both. -/
@[expose] public def TargetHypothesisA
    (Y : Action (Over (Spec (.of F))) G) (σ : G) : Prop :=
  ∀ (p q : ℕ) (z : Scheme.RationalMap (BiprojectiveSpace p q F)
      (fixedByCentralizerAction Y σ).V.left),
    z.IsOver (Spec (.of F)) →
      RationalMapIsConstantOver
        (E := Over.mk (BiprojectiveSpace.toSpec p q F))
        (Z := (fixedByCentralizerAction Y σ).V) z

/-- **Hypothesis (b) for a target.**  `Y^σ` has no `F`-section fixed by the
whole centralizer `N = C_G(σ)`; that is, `Y^N(F) = ∅`.

Sections rather than arbitrary morphisms `Spec F ⟶ Y^σ` suffice, because the
constant value produced by hypothesis (a) is automatically a section of the
structure morphism (`noEquivariantRationalMap_of_constant_section`). -/
@[expose] public def TargetHypothesisB
    (Y : Action (Over (Spec (.of F))) G) (σ : G) : Prop :=
  ¬ ∃ y : Spec (.of F) ⟶ (fixedByCentralizerAction Y σ).V.left,
      y ≫ (fixedByCentralizerAction Y σ).V.hom = 𝟙 _ ∧
        ∀ n : Subgroup.centralizer ({σ} : Set G),
          y ≫ ((fixedByCentralizerAction Y σ).ρ n).left = y

/-- **The centralizer obstruction against an abstract target, in plus/minus
coordinates.**  Given a proper `G`-scheme `Y` over `Spec F` satisfying
hypotheses (a) and (b) for an involution `σ`, no `G`-equivariant rational map
reaches `Y` from the numbered projectivization of a faithful representation.

The proof is exactly `FaithfulHeadlineReduction`'s: build the corrected
ordered normal-valuation datum, check that `σ` acts trivially on the function
field of the exceptional divisor, and finish with
`noEquivariantRationalMap_of_constant_fixedSpecialization_section`. -/
public theorem noEquivariantRationalMap_from_ambient_of_target
    [CharZero F]
    (Y : Action (Over (Spec (.of F))) G) [IsProper Y.V.hom]
    (σ : G) (hσ : IsInvolution σ)
    (ha : TargetHypothesisA F Y σ) (hb : TargetHypothesisB F Y σ)
    {V : Type u} [AddCommGroup V] [Module F V]
    (R : FaithfulLinearRep F G V) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) F (R.plusEigenspace σ))
    (bm : Basis (Fin (q + 1)) F (R.minusEigenspace σ)) :
    ¬ HasEquivariantRationalMap
        (ambientProjectiveActionOver R (p + q + 1)
          (plusMinusAmbientBasis R σ hσ p q bp bm)) Y := by
  let X := ambientProjectiveActionOver R (p + q + 1)
    (plusMinusAmbientBasis R σ hσ p q bp bm)
  let D := orderedPlusMinusEquivariantNormalDataOfCorrectedChartActual
    R σ hσ p q bp bm
  apply D.noEquivariantRationalMap_of_constant_fixedSpecialization_section X Y σ
  · change D.exceptionalFunctionFieldAction (sigmaInCentralizer σ) = 𝟙 _
    have hs := orderedPlusMinusEquivariantNormalDataOfCorrectedChartActual_sigma
      R σ hσ p q bp bm
    have helem : sigmaInCentralizer σ = sigmaCentralizer σ :=
      Subtype.ext rfl
    rw [helem]
    exact hs
  · intro z hz
    exact ha p q z hz
  · exact hb

/-- **The centralizer obstruction against an abstract target, coordinate-free.**

There is no `G`-equivariant rational map from `ℙ(V) = Proj (Sym (V*))`, the
projectivization of a faithful `F`-linear representation of a centerless group
`G`, to any proper `G`-scheme `Y` over `Spec F` whose `σ`-fixed locus satisfies
hypotheses (a) and (b) for some involution `σ`.

No basis of `V` and no system of homogeneous coordinates appears: the
`σ`-eigenspace decomposition is chosen inside the proof.

`noEquivariantRationalMap_ambientFree` is this theorem at `F = ℚ(ζ₁₁)`,
`G = PSL(2,11)`, `σ` the distinguished involution and `Y` the coordinate V14;
see `V14TargetInterface`. -/
public theorem noEquivariantRationalMap_ambientFree_of_target
    [CharZero F]
    (Y : Action (Over (Spec (.of F))) G) [IsProper Y.V.hom]
    (σ : G) (hσ : IsInvolution σ) (hG : IsCenterless G)
    (ha : TargetHypothesisA F Y σ) (hb : TargetHypothesisB F Y σ)
    {V : Type u} [AddCommGroup V] [Module F V]
    [FiniteDimensional F V] [Nontrivial V]
    (R : FaithfulLinearRep F G V) :
    ¬ HasEquivariantRationalMap (ambientFree R) Y := by
  intro h
  obtain ⟨p, q, hbp, hbm⟩ :=
    exists_plus_minus_projective_bases R σ hσ
      (not_degenerates_of_centerless hG hσ R)
  let bp := Classical.choice hbp
  let bm := Classical.choice hbm
  exact noEquivariantRationalMap_from_ambient_of_target F Y σ hσ ha hb R p q bp bm
    (hasEquivariantRationalMap_of_iso
      (ambientFreeIso R (plusMinusAmbientBasis R σ hσ p q bp bm)).symm h)

end V14Formalization.SchemeGeometry
