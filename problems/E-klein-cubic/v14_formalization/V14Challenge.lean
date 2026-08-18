/-
Comparator challenge: independent statement of the public no-map theorem.
Trusted vocabulary is `HeadlineStatement` only — this file does not import
the proof module `FaithfulHeadline`.
-/
module

public import V14Formalization.HeadlineStatement

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.Comparator

open V14Formalization.SchemeGeometry
open AlgebraicGeometry Module

/-- There is no equivariant `Scheme.RationalMap` from the numbered
projectivization of a faithful linear representation to the coordinate V14,
in *any* system `c` of plus/minus homogeneous coordinates. -/
public theorem noEquivariantRationalMap_from_ambient
    {V : Type} [AddCommGroup V] [Module V14SchemeModel.k V]
    (R : FaithfulLinearRep V14SchemeModel.k V14SchemeModel.G V)
    (c : PlusMinusCoords R) :
    ¬ HasEquivariantRationalMap (ambientOf R c)
      V14SchemeModel.actionOver := by
  sorry

/-- Same statement, packaged as projective `G`-varieties. -/
public theorem noEquivariantRationalMap_projectiveGVariety
    {V : Type} [AddCommGroup V] [Module V14SchemeModel.k V]
    (R : FaithfulLinearRep V14SchemeModel.k V14SchemeModel.G V)
    (c : PlusMinusCoords R) :
    ¬ ProjectiveGVariety.HasEquivariantRationalMap
        (ProjectiveGVariety.ofFaithfulRep R c)
        ProjectiveGVariety.v14 := by
  sorry

end V14Formalization.Comparator
