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

`noEquivariantRationalMap_intrinsicV14` takes no hypothesis on the target.  Its
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

At `F = ℚ(ζ₁₁)` the theorem is the published one: `intrinsicV14_K` shows the
target *is* `IntrinsicHeadline.intrinsicV14`.

The record of what the abstract argument consumes about its target is
`AbstractTargetHeadline.noEquivariantRationalMap_projectiveSpaceOfRep_of_target`;
it carries three hypotheses and is strictly weaker than the theorem here.
-/

set_option linter.unusedSectionVars false

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

`IntrinsicHeadline.intrinsicV14` is defined as `intrinsicV14 k`, so both sides
are the same constant applied to the same field and this is a one-step `rfl`.
(Before the headline collapsed onto `IntrinsicV14Field`, the two sides were
parallel constructions and this defeq walked the whole `ExteriorAlgebra`
instance chain, needing `maxRecDepth 20000` and a half-minute heartbeat
budget.) -/
public theorem intrinsicV14_K :
    intrinsicV14 WeilRep.K = IntrinsicHeadline.intrinsicV14 := rfl

/-! ## The general field -/

variable (F : Type) [Field F] [CharZero F] [HasCycl11 F]

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
end V14Formalization
