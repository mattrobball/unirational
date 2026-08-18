/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.ProjectiveGVariety
public import V14Formalization.CentralizerObstruction
public import V14Formalization.SchemeModelAliases
public import V14Formalization.ProjectiveSpaceIntrinsicIrreducible

/-!
# Public no-map statement (vocabulary only)

Defines the numbered projectivization of a faithful representation in a given
system of plus/minus homogeneous coordinates.  The proof that there is no
equivariant rational map lives in `FaithfulHeadline`.  This module is the
trusted vocabulary for the Comparator challenge.

The coordinates are a *parameter*, not a choice: `ambientOf` and
`ofFaithfulRep` take a `PlusMinusCoords R`, and the published theorems
quantify over it.  Until 2026-08-18 they instead applied
`PlusMinusCoords.ofRep`, which extracts one coordinate system from
`exists_plus_minus_projective_bases` by `Classical.choice`; that made the
published statements depend on two proofs and pinned them to a single
presentation of `ℙ(V)`.  `ofRep` survives below only as the witness that the
coordinate hypothesis can always be discharged.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry GeometricV14Carrier Module


public abbrev ambientFor
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :=
  ambientProjectiveActionOver R (p + q + 1)
    (plusMinusAmbientBasis R sigma sigma_isInvolution p q bp bm)

/-- `σ` cannot act as `±id` on a faithful representation of this centerless
group, so both eigenspaces are available for coordinates. -/
public theorem not_degenerates
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) :
    ¬ R.DegeneratesToPlusMinusId sigma :=
  not_degenerates_of_centerless
    GeometricFanoCarrier.PSL2F11_isCenterless sigma_isInvolution R

/-- Plus/minus homogeneous coordinates used by the normal chart.  This is a
hypothesis of the public theorems, which are stated for *every* such choice;
`PlusMinusCoords.ofRep` below shows the hypothesis is never vacuous. -/
public structure PlusMinusCoords
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) where
  p : ℕ
  q : ℕ
  bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma)
  bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)

/-- Plus/minus coordinates always exist: the group is centerless and `σ` is a
nontrivial involution, so `R` cannot send `σ` to `±id` and both eigenspaces are
nontrivial.  Nothing in the published statements depends on this choice — they
quantify over all of `PlusMinusCoords R` — so this definition exists only to
witness that the coordinate hypothesis can always be discharged. -/
@[expose] public noncomputable def PlusMinusCoords.ofRep
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) : PlusMinusCoords R :=
  let h := exists_plus_minus_projective_bases R sigma sigma_isInvolution
    (not_degenerates R)
  { p := h.choose
    q := h.choose_spec.choose
    bp := Classical.choice h.choose_spec.choose_spec.1
    bm := Classical.choice h.choose_spec.choose_spec.2 }

/-- The numbered projective action of `R` in the plus/minus coordinates `c`. -/
public abbrev ambientOf
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (c : PlusMinusCoords R) :
    Action (Over (Spec (.of k))) G :=
  ambientFor R c.p c.q c.bp c.bm

namespace ProjectiveGVariety

/-- Projectivization of a faithful linear representation, as a closed
subscheme of the numbered `Proj` in the plus/minus coordinates `c`. -/
public abbrev ofFaithfulRep
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (c : PlusMinusCoords R) :
    ProjectiveGVariety k G :=
  ofLinearRep R (c.p + c.q + 1)
    (plusMinusAmbientBasis R sigma sigma_isInvolution c.p c.q c.bp c.bm)

@[expose] public instance ofFaithfulRep_irreducible
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (c : PlusMinusCoords R) :
    IrreducibleSpace (ofFaithfulRep R c).toScheme :=
  ofLinearRep_irreducible R (c.p + c.q + 1)
    (plusMinusAmbientBasis R sigma sigma_isInvolution c.p c.q c.bp c.bm)

end ProjectiveGVariety

end V14Formalization.SchemeGeometry
