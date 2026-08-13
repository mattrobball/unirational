/-
  Driver for the public no-map type.  Import the shipped headline module
  only; print the public theorems and their kernel axioms.
-/
import V14Formalization.FaithfulHeadline

open V14Formalization.SchemeGeometry

#check @noEquivariantRationalMap_from_ambient
#check @noEquivariantRationalMap_projectiveGVariety
#print axioms noEquivariantRationalMap_from_ambient
#print axioms noEquivariantRationalMap_projectiveGVariety
