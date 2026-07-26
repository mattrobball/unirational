/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.TargetRelationGenericFiber

/-! # Axiom audit for the target relation's generic fibre -/

@[expose] public section

open BConicBundleMultisections.TargetRelationGenericFiber

#print axioms schemePointFiber_genericPoint_isPreirreducible
#print axioms schemePointFiber_genericPoint_subsingleton_of_discrete
#print axioms schemePointFiber_genericPoint_subsingleton_of_isLocallyArtinian_fiber
#print axioms schemePointFiber_genericPoint_subsingleton_of_locallyQuasiFinite_fiber
#print axioms schemePointFiber_genericPoint_subsingleton_of_locallyQuasiFinite
#print axioms targetRelation_schemePointFiber_subsingleton_of_isLocallyArtinian_fiber
#print axioms residualTargetComponentOnι_isIso_of_isLocallyArtinian_genericFiber
