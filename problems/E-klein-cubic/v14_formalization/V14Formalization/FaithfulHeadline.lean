/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.FaithfulHeadlineReduction
public import V14Formalization.V14FixedRationalConstancy
public import V14Formalization.HeadlineStatement
public import V14Formalization.SchemeModelAliases
public import V14Formalization.ProjectiveSpaceIntrinsicCompare

/-!
# Unconditional faithful no-map theorem

The public statements take a faithful linear representation and *any* system
of numbered plus/minus coordinates for the normal chart.  Such a system always
exists (`PlusMinusCoords.ofRep`: the group is centerless and `σ` is a
nontrivial involution, so the representation cannot send `σ` to `±id`, and
both eigenspaces are then nontrivial), but the statements no longer choose
one — they hold for every choice.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry GeometricV14Carrier Module


/-- The theorem in unbundled plus/minus coordinates.  The public theorem below
is this one with the four coordinate arguments bundled as a
`PlusMinusCoords`. -/
public theorem noEquivariantRationalMap_from_ambient_of_plusMinusBases
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :
    ¬ HasEquivariantRationalMap (ambientFor R p q bp bm)
      V14SchemeModel.actionOver := by
  apply noEquivariantRationalMap_from_ambient_of_constancy R p q bp bm
  intro z hz
  exact rationalMapIsConstantOver_v14FixedBy p q z hz

/-- The same statement for the projective `G`-variety packaging, in unbundled
plus/minus coordinates: closed subschemes of Mathlib `Proj` with a `G`-action
over `Spec k`. -/
public theorem noEquivariantRationalMap_projectiveGVariety_of_plusMinusBases
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V)
    (p q : ℕ)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :
    ¬ ProjectiveGVariety.HasEquivariantRationalMap
        (ProjectiveGVariety.ofLinearRep R (p + q + 1)
          (plusMinusAmbientBasis R sigma sigma_isInvolution p q bp bm))
        ProjectiveGVariety.v14 :=
  noEquivariantRationalMap_from_ambient_of_plusMinusBases R p q bp bm

/-- **The coordinate-free statement.**  There is no equivariant rational map
from `ℙ(V) = Proj (Sym (V*))`, the projectivization of a faithful linear
representation, to the coordinate V14.

No basis of `V` and no system of homogeneous coordinates appears anywhere in
this statement: the `G`-action on `ℙ(V)` arrives purely by functoriality.  The
σ-eigenspace decomposition, which the proof still needs, is chosen inside the
proof and is invisible from outside.

This is strictly stronger than the coordinatized statements below, which are
recovered from it by transporting along `ambientFreeIso`. -/
public theorem noEquivariantRationalMap_ambientFree
    {V : Type} [AddCommGroup V] [Module k V]
    [FiniteDimensional k V] [Nontrivial V]
    (R : FaithfulLinearRep k G V) :
    ¬ HasEquivariantRationalMap (ambientFree R)
      V14SchemeModel.actionOver := by
  intro h
  let c : PlusMinusCoords R := PlusMinusCoords.ofRep R
  exact noEquivariantRationalMap_from_ambient_of_plusMinusBases R c.p c.q c.bp c.bm
    (hasEquivariantRationalMap_of_iso
      (ambientFreeIso R
        (plusMinusAmbientBasis R sigma sigma_isInvolution c.p c.q c.bp c.bm)).symm h)

/-- There is no equivariant rational map from the projectivization of a
faithful linear representation to the coordinate V14, in *any* system of
plus/minus homogeneous coordinates.

A corollary of the coordinate-free statement above: a choice of plus/minus
coordinates is exactly a basis of `V`, and `ambientFreeIso` says the two
presentations of `ℙ(V)` are isomorphic as `G`-schemes over `Spec k`. -/
public theorem noEquivariantRationalMap_from_ambient
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (c : PlusMinusCoords R) :
    ¬ HasEquivariantRationalMap (ambientOf R c)
      V14SchemeModel.actionOver := by
  intro h
  haveI : FiniteDimensional k V := R.finiteDimensional
  haveI : Nontrivial V :=
    ⟨⟨plusMinusAmbientBasis R sigma sigma_isInvolution c.p c.q c.bp c.bm 0, 0,
      (plusMinusAmbientBasis R sigma sigma_isInvolution c.p c.q c.bp c.bm).ne_zero 0⟩⟩
  exact noEquivariantRationalMap_ambientFree R
    (hasEquivariantRationalMap_of_iso
      (ambientFreeIso R
        (plusMinusAmbientBasis R sigma sigma_isInvolution c.p c.q c.bp c.bm)) h)

/-- Same statement, packaged as projective `G`-varieties: closed subschemes
of Mathlib `Proj` with a `G`-action over `Spec k`. -/
public theorem noEquivariantRationalMap_projectiveGVariety
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (c : PlusMinusCoords R) :
    ¬ ProjectiveGVariety.HasEquivariantRationalMap
        (ProjectiveGVariety.ofFaithfulRep R c)
        ProjectiveGVariety.v14 :=
  noEquivariantRationalMap_projectiveGVariety_of_plusMinusBases R c.p c.q c.bp c.bm

end V14Formalization.SchemeGeometry
