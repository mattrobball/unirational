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

/-- **Coordinate-free form.**  There is no equivariant `Scheme.RationalMap`
from `ℙ(V) = Proj (Sym (V*))`, the projectivization of a faithful linear
representation, to the coordinate V14.

No basis of `V` and no system of homogeneous coordinates appears anywhere in
this statement; the `G`-action on `ℙ(V)` arrives by functoriality alone.  The
two coordinatized theorems below are corollaries of this one. -/
public theorem noEquivariantRationalMap_projectiveSpaceOfRep
    {V : Type} [AddCommGroup V] [Module V14SchemeModel.k V]
    [FiniteDimensional V14SchemeModel.k V] [Nontrivial V]
    (R : FaithfulLinearRep V14SchemeModel.k V14SchemeModel.G V) :
    ¬ HasEquivariantRationalMap (projectiveSpaceOfRep R)
      V14SchemeModel.actionOver :=
  SchemeGeometry.noEquivariantRationalMap_projectiveSpaceOfRep R

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
