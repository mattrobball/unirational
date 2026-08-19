/-
Axiom audit entrypoint.

The first block is the one that matters: the three theorems Comparator checks,
named exactly as `comparator.json` lists them.  The rest are the legacy
Theorem 3.1 / Corollary 6.1 / Weil-core declarations, kept because they are
the historical audit surface.
-/
module

public import V14Solution
public import V14Formalization.V14D12FixedPointExclusionComplex
public import V14Formalization.FaithfulHeadlineOverField
public import V14Formalization.D12SigmaMinusDescent
public import V14Formalization.CentralizerObstruction
public import V14Formalization.V14Application
public import V14Formalization.WeilRep
public import V14Formalization.GeometricFanoV14

-- The three Comparator theorems.
#print axioms V14Formalization.Comparator.noEquivariantRationalMap_ambientFree
#print axioms V14Formalization.Comparator.noEquivariantRationalMap_from_ambient
#print axioms V14Formalization.Comparator.noEquivariantRationalMap_projectiveGVariety

-- Hypothesis (b) over an arbitrary field, and over the complex numbers.
#print axioms V14Formalization.D12CertificateK.certificateOver
#print axioms V14Formalization.SchemeGeometry.no_centralizer_fixed_point_over
#print axioms V14Formalization.SchemeGeometry.no_centralizer_fixed_point_complex

-- The general-field statement and the pieces it rests on. The headline is
-- conditional on `HypothesisAOver F`, which is hypothesis (a) over `F`; the
-- descent inputs it will need are already unconditional over every base field.
#print axioms V14Formalization.BaseField.algebraOfPrimitiveRoot
#print axioms V14Formalization.BaseField.isPrimitiveRoot_zetaOf
#print axioms V14Formalization.SchemeGeometry.exists_centralizer_fixed_point_of_baseChange
#print axioms V14Formalization.SchemeGeometry.noEquivariantRationalMap_of_normal_specialization_over
#print axioms V14Formalization.SchemeGeometry.noEquivariantRationalMap_ambientFree_over_of_constancy
#print axioms V14Formalization.D12SigmaPlusSegreCore.smooth_detCubic_rank_eq_two_map
#print axioms V14Formalization.D12SigmaPlusDescent.plusCarrier_commonPluckerZero_descends_mvfrac_base
#print axioms V14Formalization.D12SigmaMinusDescent.minusCarrier_ambient_descends_mvfrac_overBase

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
