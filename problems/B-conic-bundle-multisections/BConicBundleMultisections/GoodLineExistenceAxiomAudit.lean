/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.GoodLineExistence

/-!
# Axiom audit for good-line existence

Run with

```sh
lake env lean BConicBundleMultisections/GoodLineExistenceAxiomAudit.lean
```

The first two declarations are the newly closed dependencies.  The final declaration is the exact
G3 good-line theorem consumed downstream.  This audit does not concern the source's separate
generic-line conditions (2) and (3).
-/

#print axioms
  BConicBundleMultisections.exists_ne_zero_isSmoothPlaneCubic_specializeFirstCoordinates
#print axioms
  BConicBundleMultisections.HesseResidualMapBridge.eq_C_mul_hesse_of_hasCommonResidualLineMap
#print axioms
  BConicBundleMultisections.Standard.exists_pencil_of_hasCommonResidualLineMap
#print axioms BConicBundleMultisections.exists_good_line
