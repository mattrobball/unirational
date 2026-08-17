/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.FaithfulHeadlineReduction
import V14Formalization.V14FixedRationalConstancy
import V14Formalization.HeadlineStatement
import V14Formalization.SchemeModelAliases

/-!
# Unconditional faithful no-map theorem

The public statements take only a faithful linear representation.  Numbered
plus/minus coordinates for the normal chart are chosen internally: the
group is centerless and `σ` is a nontrivial involution, so the representation
cannot send `σ` to `±id`, and both eigenspaces are then nontrivial.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry GeometricV14Carrier Module


/-- Same statement after an explicit choice of plus/minus coordinates.
The public theorems below hide this choice. -/
theorem noEquivariantRationalMap_from_ambient_of_plusMinusBases
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

/-- There is no equivariant rational map from the projectivization of a
faithful linear representation to the coordinate V14. -/
theorem noEquivariantRationalMap_from_ambient
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) :
    ¬ HasEquivariantRationalMap (ambientOf R)
      V14SchemeModel.actionOver :=
  let c := PlusMinusCoords.ofRep R
  noEquivariantRationalMap_from_ambient_of_plusMinusBases R c.p c.q c.bp c.bm

/-- Same statement, packaged as projective `G`-varieties: closed subschemes
of Mathlib `Proj` with a `G`-action over `Spec k`. -/
theorem noEquivariantRationalMap_projectiveGVariety
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) :
    ¬ ProjectiveGVariety.HasEquivariantRationalMap
        (ProjectiveGVariety.ofFaithfulRep R)
        ProjectiveGVariety.v14 :=
  noEquivariantRationalMap_from_ambient R

end V14Formalization.SchemeGeometry
