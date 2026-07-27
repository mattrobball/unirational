/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.TargetRelationGenericResidueTransport

/-! # Axiom audit for generic projective residue-field transport and coprimality -/

open BConicBundleMultisections
open BConicBundleMultisections.MvPolynomial
open BConicBundleMultisections.ProjectiveSpace
open BConicBundleMultisections.BiprojectiveSpace

#print axioms irreducible_map_isFractionRing_mvPolynomial
#print axioms isFractionRing_standardChartResidue_generic
#print axioms irreducible_map_residueCoefficientMap_generic
#print axioms not_dvd_fstResidueFiberPolynomial_generic_of_smooth
#print axioms hasTargetRelationFstFiberGlobalCoprimality_generic_of_smooth
#print axioms targetRelation_genericFiber_isLocallyArtinian_of_smooth_irreducible
