/-
Comparator challenge: independent statement of the public no-map theorem.
Trusted vocabulary is `HeadlineStatement` only — this file does not import
the proof module `FaithfulHeadline`.
-/
import V14Formalization.HeadlineStatement

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.Comparator

open V14Formalization.SchemeGeometry
open AlgebraicGeometry Module

private abbrev k := V14SchemeModel.k
private abbrev G := V14SchemeModel.G

/-- There is no equivariant `Scheme.RationalMap` from the numbered
projectivization of a faithful linear representation to the coordinate V14. -/
theorem noEquivariantRationalMap_from_ambient
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) :
    ¬ HasEquivariantRationalMap (ambientOf R)
      V14SchemeModel.actionOver := by
  sorry

/-- Same statement, packaged as projective `G`-varieties. -/
theorem noEquivariantRationalMap_projectiveGVariety
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) :
    ¬ ProjectiveGVariety.HasEquivariantRationalMap
        (ProjectiveGVariety.ofFaithfulRep R)
        ProjectiveGVariety.v14 := by
  sorry

end V14Formalization.Comparator
