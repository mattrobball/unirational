/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.IntrinsicV14Field
public import V14Formalization.IntrinsicV14Headline
public import V14Formalization.AbstractTargetHeadline
public import V14Formalization.IntrinsicV14BaseChangeCompare
public import V14Formalization.V14FixedRationalConstancyOverField

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

## The theorem is unconditional (2026-08-20)

`noEquivariantRationalMap_ofPrimitiveRoot` and
`noEquivariantRationalMap_intrinsicV14` take no hypothesis on the target.  Their
hypotheses are exactly: `F` is a field, of characteristic zero, carrying a
primitive 11th root of unity, and `V` is a faithful finite-dimensional
`F`-representation.  Nothing else.

The proof is the same three lines as the `ℚ(ζ₁₁)` one: post-compose along a
morphism into a target for which the theorem is already proved, and cite it.
The morphism is `IntrinsicV14BaseChange.compareBCPullback`, into
`V14SchemeModel.actionOverBaseChange F`; the theorem it cites is
`SchemeGeometry.noEquivariantRationalMap_projectiveSpaceOfRep_over_of_constancy`, whose
one remaining hypothesis — constancy on the `σ`-fixed locus over `F` — is
discharged by `SchemeGeometry.hypothesisAOver`.

Two things had to be built to get there, and both are now in the tree:

* the identification.  `IntrinsicV14Compare.compare` over `F` lands in the
  coordinate `V₁₄` *built over `F`*, not in the base change of the `ℚ(ζ₁₁)`
  model, and those are different schemes.  `WeilModelBaseChange` shows the whole
  Weil model — `ψ`, the Gauss sum, the Weil operators, `⋀²`, the character
  projector — is carried across by any field map matching the two chosen roots,
  and hence that `V14SchemeModel.projectorMatrix`, the `ℚ(ζ₁₁)`-defined matrix,
  read over `F`, fixes the Plücker coordinates of `M_F`.  That is what lets
  `Proj.map` along coefficient extension land in the `ℚ(ζ₁₁)` equations, and
  `pullback.lift` then reaches the base change.  No base-change theorem for
  `Proj` is needed: a morphism into a fibre product is a pair.
* hypothesis (a) over `F` (`SchemeGeometry.hypothesisAOver`), the last gap named
  by `FIELD_CRITERIA_2026-08-18.md`.

`noEquivariantRationalMap_intrinsicV14_cycl` is the same statement at
`F = ℚ(ζ₁₁)`, where `intrinsicV14_K` shows the target *is* the published one.

`noEquivariantRationalMap_intrinsicV14_of_target` is **not** the theorem: it is
the record of what `AbstractTargetHeadline` shows the argument uses about its
target, and it carries three hypotheses.  It is kept for that purpose and is
strictly weaker than the theorems above; do not cite it as the result.
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
open V14Formalization.WeilRep (HasCycl11)
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
    ¬ HasEquivariantRationalMap (projectiveSpaceOfRep R) (intrinsicV14 WeilRep.K) := by
  rw [intrinsicV14_K]
  exact IntrinsicHeadline.noEquivariantRationalMap_intrinsicV14 R

/-! ## The general field -/

variable (F : Type) [Field F] [CharZero F] [HasCycl11 F]

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

/-- **What the abstract argument consumes about its target.**

`NOT THE THEOREM.`  This is `AbstractTargetHeadline`'s reduction instantiated at
the intrinsic `V₁₄` over `F`: it says that properness together with hypotheses
(a) and (b) *for that target* suffice.  All three hypotheses are things the
certificate corpus exists to prove, so a statement carrying them is weaker, not
stronger, than `noEquivariantRationalMap_intrinsicV14` below, which carries
none of them.  It is kept only as the record of what the argument uses. -/
public theorem noEquivariantRationalMap_intrinsicV14_of_target
    [IsProper (intrinsicV14 F).V.hom]
    (ha : HypothesisA F) (hb : HypothesisB F)
    {V : Type} [AddCommGroup V] [Module F V] [FiniteDimensional F V] [Nontrivial V]
    (R : FaithfulLinearRep F PSL2F11 V) :
    ¬ HasEquivariantRationalMap (projectiveSpaceOfRep R) (intrinsicV14 F) :=
  noEquivariantRationalMap_projectiveSpaceOfRep_of_target F (intrinsicV14 F)
    GeometricV14Carrier.sigma GeometricV14Carrier.sigma_isInvolution
    GeometricFanoCarrier.PSL2F11_isCenterless ha hb R

/-- **No `PSL(2,11)`-equivariant rational map from `ℙ(V)` to the intrinsic
`V₁₄`, over any field of characteristic zero carrying a primitive 11th root of
unity.**  Unconditional.

`V` is any faithful `F`-linear representation, `ℙ(V) = Proj (Sym (V*))` carries
its action by functoriality, and the target is `Proj (Sym (M*) ⧸ I)` for the
Plücker ideal `I` of the wedge pairing on the `10′` summand `M ⊆ ⋀²U` of the
even Weil representation over `F`.  Neither `AdjoinRoot Φ₁₁` nor any other
carrier of this development occurs in the statement, and nothing is assumed
about the target.

The proof post-composes along `IntrinsicV14BaseChange.compareBCPullback`, an
equivariant morphism over `Spec F` from this target to the base change of the
coordinate `V₁₄`, and cites the general-field coordinate theorem there. -/
public theorem noEquivariantRationalMap_intrinsicV14
    {V : Type} [AddCommGroup V] [Module F V] [FiniteDimensional F V] [Nontrivial V]
    (R : FaithfulLinearRep F PSL2F11 V) :
    ¬ HasEquivariantRationalMap (projectiveSpaceOfRep R) (intrinsicV14 F) := by
  letI : Algebra V14SchemeModel.k F :=
    BaseField.algebraOfPrimitiveRoot (WeilRep.isPrimitiveRoot_ζ (E := F))
  have hzF : algebraMap V14SchemeModel.k F (WeilRep.ζ : V14SchemeModel.k) =
      (WeilRep.ζ : F) :=
    BaseField.algebraMap_algebraOfPrimitiveRoot _
  intro h
  exact noEquivariantRationalMap_projectiveSpaceOfRep_over_of_constancy F R (hypothesisAOver F)
    (hasEquivariantRationalMap_of_hom
      (IntrinsicV14BaseChange.compareBCPullback F hzF)
      (IntrinsicV14BaseChange.compareBCPullback_isOver F hzF)
      (IntrinsicV14BaseChange.compareBCPullback_equivariant F hzF) h)

end IntrinsicV14Field

namespace IntrinsicV14Field

open AlgebraicGeometry
open V14Formalization.SchemeGeometry
open V14Formalization.WeilRep (HasCycl11)

/-- **The same theorem with the field condition spelled out as an element and a
property**, which is the form a reader checks.  Unconditional.

`hζ` is the entire hypothesis on `F` beyond characteristic zero: an element of
`F` that is a primitive 11th root of unity.  `BaseFieldCriteria` shows this is
interchangeable with `[Algebra ℚ(ζ₁₁) F]`, and the statement uses this side.
There is no hypothesis on the target: no properness, no constancy on the fixed
locus, no emptiness of the `D₁₂`-fixed points. -/
public theorem noEquivariantRationalMap_ofPrimitiveRoot
    {F : Type} [Field F] [CharZero F] {ζ : F} (hζ : IsPrimitiveRoot ζ 11)
    {V : Type} [AddCommGroup V] [Module F V] [FiniteDimensional F V] [Nontrivial V]
    (R : FaithfulLinearRep F WeilLambda2.PSL2F11 V) :
    ¬ HasEquivariantRationalMap (projectiveSpaceOfRep R) (ofPrimitiveRoot hζ) :=
  letI : HasCycl11 F := ⟨ζ, hζ⟩
  noEquivariantRationalMap_intrinsicV14 F R

#print axioms noEquivariantRationalMap_intrinsicV14
#print axioms noEquivariantRationalMap_ofPrimitiveRoot

end IntrinsicV14Field
end V14Formalization
