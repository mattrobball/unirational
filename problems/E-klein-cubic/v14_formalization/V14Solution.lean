/-
Comparator solution: the public no-map theorems, proved by the shipped headline.
-/
module

public import V14Formalization.FaithfulHeadline

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.Comparator

open V14Formalization.SchemeGeometry
open AlgebraicGeometry Module

public theorem noEquivariantRationalMap_from_ambient
    {V : Type} [AddCommGroup V] [Module V14SchemeModel.k V]
    (R : FaithfulLinearRep V14SchemeModel.k V14SchemeModel.G V)
    (c : PlusMinusCoords R) :
    ¬ HasEquivariantRationalMap (ambientOf R c)
      V14SchemeModel.actionOver :=
  SchemeGeometry.noEquivariantRationalMap_from_ambient R c

public theorem noEquivariantRationalMap_projectiveGVariety
    {V : Type} [AddCommGroup V] [Module V14SchemeModel.k V]
    (R : FaithfulLinearRep V14SchemeModel.k V14SchemeModel.G V)
    (c : PlusMinusCoords R) :
    ¬ ProjectiveGVariety.HasEquivariantRationalMap
        (ProjectiveGVariety.ofFaithfulRep R c)
        ProjectiveGVariety.v14 :=
  SchemeGeometry.noEquivariantRationalMap_projectiveGVariety R c

end V14Formalization.Comparator
