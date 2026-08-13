/-
Comparator solution: the public no-map theorems, proved by the shipped headline.
-/
import V14Formalization.FaithfulHeadline

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.Comparator

open V14Formalization.SchemeGeometry
open AlgebraicGeometry Module

private abbrev k := V14SchemeModel.k
private abbrev G := V14SchemeModel.G

theorem noEquivariantRationalMap_from_ambient
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) :
    ¬ HasEquivariantRationalMap (ambientOf R)
      V14SchemeModel.actionOver :=
  SchemeGeometry.noEquivariantRationalMap_from_ambient R

theorem noEquivariantRationalMap_projectiveGVariety
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V) :
    ¬ ProjectiveGVariety.HasEquivariantRationalMap
        (ProjectiveGVariety.ofFaithfulRep R)
        ProjectiveGVariety.v14 :=
  SchemeGeometry.noEquivariantRationalMap_projectiveGVariety R

end V14Formalization.Comparator
