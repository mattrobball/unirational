/-
Axiom audit entrypoint.

The first block is the one that matters: the two theorems Comparator checks,
named exactly as `comparator.json` lists them.  The rest are the legacy
Theorem 3.1 / Corollary 6.1 / Weil-core declarations, kept because they are
the historical audit surface.
-/
module

public import V14Solution
public import V14Formalization.CentralizerObstruction
public import V14Formalization.V14Application
public import V14Formalization.WeilRep
public import V14Formalization.GeometricFanoV14

-- The two Comparator theorems.
#print axioms V14Formalization.Comparator.noEquivariantRationalMap_from_ambient
#print axioms V14Formalization.Comparator.noEquivariantRationalMap_projectiveGVariety

-- Legacy audit surface.
#print axioms V14Formalization.centralizerObstruction
#print axioms V14Formalization.centralizerObstruction_one_rep
#print axioms V14Formalization.noDegenerates_of_centerless_involution
#print axioms V14Formalization.V14App.V14_not_weakly_versal
#print axioms V14Formalization.V14App.V14_no_equivariant_map_from_faithful_rep
#print axioms V14Formalization.V14App.V14_not_GUnirational
#print axioms V14Formalization.WeilRep.gauss_sq
#print axioms V14Formalization.WeilRep.Sfull_sq_apply
#print axioms V14Formalization.WeilRep.S_even_sq
#print axioms V14Formalization.GeometricFanoV14.S_sq
