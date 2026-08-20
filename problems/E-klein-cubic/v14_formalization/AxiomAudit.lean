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
public import V14Formalization.IntrinsicV14FieldHeadline

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

-- The abstract-target statement and the three things it asks of a target.
-- `noEquivariantRationalMap_ambientFree` is the first of these instantiated at
-- the coordinate V14 by the three below, so these carry the whole argument.
#print axioms V14Formalization.SchemeGeometry.noEquivariantRationalMap_ambientFree_of_target
#print axioms V14Formalization.SchemeGeometry.noEquivariantRationalMap_from_ambient_of_target
#print axioms V14Formalization.SchemeGeometry.v14_isProper
#print axioms V14Formalization.SchemeGeometry.v14_targetHypothesisA
#print axioms V14Formalization.SchemeGeometry.v14_targetHypothesisB

-- The intrinsic V14 with the base field as a stated condition rather than this
-- project's carrier. `intrinsicV14` and `ofPrimitiveRoot` are the target built
-- over any characteristic-zero field carrying a primitive 11th root of unity;
-- `intrinsicV14_K` identifies it at ℚ(ζ₁₁) with the published target, so
-- `noEquivariantRationalMap_intrinsicV14_cycl` is unconditional. Since
-- 2026-08-20 so is the general-field form,
-- `noEquivariantRationalMap_intrinsicV14` / `..._ofPrimitiveRoot`: it assumes
-- nothing about the target. `..._of_target` is the *record* of what
-- `AbstractTargetHeadline` shows the argument uses, and is strictly weaker.
#print axioms V14Formalization.WeilRep.IsCycl11
#print axioms V14Formalization.WeilLambda2.pslLambda2Hom
#print axioms V14Formalization.WeilLambda2.projectorM_equivariant
#print axioms V14Formalization.IntrinsicV14Field.intrinsicV14
#print axioms V14Formalization.IntrinsicV14Field.ofPrimitiveRoot
#print axioms V14Formalization.IntrinsicV14Field.intrinsicV14_K
#print axioms V14Formalization.IntrinsicV14Field.noEquivariantRationalMap_intrinsicV14_cycl
#print axioms V14Formalization.IntrinsicV14Field.noEquivariantRationalMap_intrinsicV14_of_target
#print axioms V14Formalization.IntrinsicV14Field.noEquivariantRationalMap_intrinsicV14
#print axioms V14Formalization.IntrinsicV14Field.noEquivariantRationalMap_ofPrimitiveRoot
#print axioms V14Formalization.SchemeGeometry.hypothesisAOver
#print axioms V14Formalization.SchemeGeometry.noEquivariantRationalMap_ambientFree_over_of_constancy
#print axioms V14Formalization.WeilModelBaseChange.projectorMatrix_map_mulVec_Msub
#print axioms V14Formalization.IntrinsicV14BaseChange.compareBCPullback

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
