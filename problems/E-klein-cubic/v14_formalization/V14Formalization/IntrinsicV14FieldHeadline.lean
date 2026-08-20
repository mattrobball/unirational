/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.IntrinsicV14Field
public import V14Formalization.IntrinsicV14Headline
public import V14Formalization.AbstractTargetHeadline

/-!
# The intrinsic `V₁₄` theorem with the base field as a hypothesis

`IntrinsicHeadline.noEquivariantRationalMap_intrinsicV14` is stated over
`V14SchemeModel.k`, which chases down to `WeilRep.K = AdjoinRoot Φ₁₁`.  That is
this development's carrier, not a condition a reader can check.  Here the field
is a bound variable and the condition on it is stated:

* `[CharZero F]`, and
* a primitive 11th root of unity in `F`.

`BaseFieldCriteria` proves those two are exactly the same data as a ring map
`ℚ(ζ₁₁) → F`, in both directions, so nothing is lost or gained by phrasing them
this way — but `AdjoinRoot Φ₁₁` no longer appears in the statement, in any
position, and in particular the theorem is not stated with `[Algebra k F]`.

## What is unconditional and what is not

`noEquivariantRationalMap_intrinsicV14_cycl` is unconditional: it is the
published theorem, restated against the field-parameterized target at
`F = ℚ(ζ₁₁)`, which `intrinsicV14_K` shows is the very same scheme with the
very same action.

`noEquivariantRationalMap_intrinsicV14_of_target` is the general-field form.
It carries three hypotheses on the target, and they are the *reason* the
general form is not yet unconditional:

* `[IsProper …]`, properness of `V₁₄_F` over `Spec F`;
* `HypothesisA F`, that a rational map from a biprojective space to the
  `σ`-fixed locus of `V₁₄_F` is constant;
* `HypothesisB F`, that `V₁₄_F^{D₁₂}(F) = ∅`.

All three are stated *against the intrinsic target itself*, so no carrier of
this development leaks into them either.  Over `ℚ(ζ₁₁)` all three are true —
that is what the published proof establishes, through the coordinate model —
and `FIELD_CRITERIA_2026-08-18.md` records that hypothesis (b) is already
proved over every field over `ℚ(ζ₁₁)` and hypothesis (a) is not.  Discharging
them for the intrinsic target over a general `F` needs the comparison morphism
of `IntrinsicV14Compare` over `F`, which is not built here; see the report
accompanying this file.
-/

set_option linter.unusedSectionVars false
-- `intrinsicV14_K` is `rfl`, but the two sides reach it through different
-- namespaces and the defeq check walks the whole `ExteriorAlgebra` instance
-- chain; it costs about half a minute at these budgets.  Nothing else in the
-- file needs them.
set_option maxRecDepth 20000
set_option maxHeartbeats 1000000

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace IntrinsicV14Field

open AlgebraicGeometry Module
open V14Formalization.WeilLambda2
open V14Formalization.WeilRep (IsCycl11)
open V14Formalization.SchemeGeometry

/-! ## The distinguished field is one of the fields covered -/

/-- **The field-parameterized target at `ℚ(ζ₁₁)` is the published target.**

Both sides are `IntrinsicV14.actionOver` applied to the same field, the same
even Weil module, the same `10′` summand and the same representation; the two
routes to them differ only in which namespace the intermediate names live in,
and in `Prop`-valued arguments. -/
public theorem intrinsicV14_K :
    intrinsicV14 WeilRep.K = IntrinsicHeadline.intrinsicV14 := rfl

/-- **The published theorem, restated against the field-parameterized target.**

Unconditional.  This is `IntrinsicHeadline.noEquivariantRationalMap_intrinsicV14`
with the target written in the form that takes the field as a parameter. -/
public theorem noEquivariantRationalMap_intrinsicV14_cycl
    {V : Type} [AddCommGroup V] [Module WeilRep.K V] [FiniteDimensional WeilRep.K V]
    [Nontrivial V] (R : FaithfulLinearRep WeilRep.K PSL2F11 V) :
    ¬ HasEquivariantRationalMap (ambientFree R) (intrinsicV14 WeilRep.K) := by
  rw [intrinsicV14_K]
  exact IntrinsicHeadline.noEquivariantRationalMap_intrinsicV14 R

/-! ## The general field -/

variable (F : Type) [Field F] [CharZero F] [IsCycl11 F]

/-- **Hypothesis (a) for the intrinsic `V₁₄` over `F`.**  Every rational map
over `Spec F` from a biprojective space to the `σ`-fixed locus of `V₁₄_F` is
constant: the positive-dimensional part of `V₁₄_F^σ` carries no rational
curve. -/
@[expose] public def HypothesisA : Prop :=
  TargetHypothesisA F (intrinsicV14 F) GeometricV14Carrier.sigma

/-- **Hypothesis (b) for the intrinsic `V₁₄` over `F`.**  `V₁₄_F^σ` has no
`F`-point fixed by the whole centralizer `D₁₂ = C_G(σ)`. -/
@[expose] public def HypothesisB : Prop :=
  TargetHypothesisB F (intrinsicV14 F) GeometricV14Carrier.sigma

/-- **No `PSL(2,11)`-equivariant rational map from `ℙ(V)` to the intrinsic
`V₁₄`, over any field of characteristic zero carrying a primitive 11th root of
unity.**

`V` is any faithful `F`-linear representation, `ℙ(V) = Proj (Sym (V*))` carries
its action by functoriality, and the target is `Proj (Sym (M*) ⧸ I)` for the
Plücker ideal `I` of the wedge pairing on the `10′` summand `M ⊆ ⋀²U` of the
even Weil representation over `F`.  Neither `AdjoinRoot Φ₁₁` nor any other
carrier of this development occurs in the statement.

The three target hypotheses are exactly what `AbstractTargetHeadline` records
as the whole of what the argument uses about its target. -/
public theorem noEquivariantRationalMap_intrinsicV14_of_target
    [IsProper (intrinsicV14 F).V.hom]
    (ha : HypothesisA F) (hb : HypothesisB F)
    {V : Type} [AddCommGroup V] [Module F V] [FiniteDimensional F V] [Nontrivial V]
    (R : FaithfulLinearRep F PSL2F11 V) :
    ¬ HasEquivariantRationalMap (ambientFree R) (intrinsicV14 F) :=
  noEquivariantRationalMap_ambientFree_of_target F (intrinsicV14 F)
    GeometricV14Carrier.sigma GeometricV14Carrier.sigma_isInvolution
    GeometricFanoCarrier.PSL2F11_isCenterless ha hb R

end IntrinsicV14Field

namespace IntrinsicV14Field

open AlgebraicGeometry
open V14Formalization.SchemeGeometry
open V14Formalization.WeilRep (IsCycl11)

/-- **The same theorem with the field condition spelled out as an element and a
property**, which is the form a reader checks.

`hζ` is the entire hypothesis on `F` beyond characteristic zero: an element of
`F` that is a primitive 11th root of unity.  `BaseFieldCriteria` shows this is
interchangeable with `[Algebra ℚ(ζ₁₁) F]`, and the statement uses this side. -/
public theorem noEquivariantRationalMap_ofPrimitiveRoot
    {F : Type} [Field F] [CharZero F] {ζ : F} (hζ : IsPrimitiveRoot ζ 11)
    (hproper : IsProper (ofPrimitiveRoot hζ).V.hom)
    (ha : letI : IsCycl11 F := ⟨ζ, hζ⟩; HypothesisA F)
    (hb : letI : IsCycl11 F := ⟨ζ, hζ⟩; HypothesisB F)
    {V : Type} [AddCommGroup V] [Module F V] [FiniteDimensional F V] [Nontrivial V]
    (R : FaithfulLinearRep F WeilLambda2.PSL2F11 V) :
    ¬ HasEquivariantRationalMap (ambientFree R) (ofPrimitiveRoot hζ) :=
  letI : IsCycl11 F := ⟨ζ, hζ⟩
  haveI : IsProper (intrinsicV14 F).V.hom := hproper
  noEquivariantRationalMap_intrinsicV14_of_target F ha hb R

end IntrinsicV14Field
end V14Formalization
