/-
Comparator solution: the public no-map theorems, proved by the shipped headline.
-/
module

public import V14Formalization.FaithfulHeadline
public import V14Formalization.IntrinsicV14FieldHeadline

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.Comparator

open V14Formalization.SchemeGeometry
open AlgebraicGeometry Module
open V14Formalization.WeilLambda2 (PSL2F11)
open V14Formalization.WeilRep (HasCycl11)
open V14Formalization.IntrinsicV14Field (intrinsicV14)

/-- **The target.**  No `PSL(2,11)`-equivariant rational map from `ℙ(V)` to
the intrinsic `V₁₄`, over any field of characteristic zero carrying a
primitive 11th root of unity.  Unconditional: nothing is assumed about the
target.

`V` is any faithful `F`-linear representation, `ℙ(V) = Proj (Sym (V*))`
carries its action by functoriality, and the target is `Proj (Sym (M*) ⧸ I)`
for the Plücker ideal `I` of the wedge pairing on the `10′` summand
`M ⊆ ⋀²U` of the even Weil representation over `F`.  Neither `AdjoinRoot Φ₁₁`
nor any other carrier of this development occurs in the statement. -/
public theorem noEquivariantRationalMap_intrinsicV14
    (F : Type) [Field F] [CharZero F] [HasCycl11 F]
    {V : Type} [AddCommGroup V] [Module F V] [FiniteDimensional F V] [Nontrivial V]
    (R : FaithfulLinearRep F PSL2F11 V) :
    ¬ HasEquivariantRationalMap (projectiveSpaceOfRep R) (intrinsicV14 F) :=
  IntrinsicV14Field.noEquivariantRationalMap_intrinsicV14 F R

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
