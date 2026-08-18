/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.FaithfulHeadlineReduction
public import V14Formalization.V14FixedRationalConstancy
public import V14Formalization.HeadlineStatement
public import V14Formalization.SchemeModelAliases

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

/-- There is no equivariant rational map from the projectivization of a
faithful linear representation to the coordinate V14, in *any* system of
plus/minus homogeneous coordinates. -/
public theorem noEquivariantRationalMap_from_ambient
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) (c : PlusMinusCoords R) :
    ¬ HasEquivariantRationalMap (ambientOf R c)
      V14SchemeModel.actionOver :=
  noEquivariantRationalMap_from_ambient_of_plusMinusBases R c.p c.q c.bp c.bm

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
