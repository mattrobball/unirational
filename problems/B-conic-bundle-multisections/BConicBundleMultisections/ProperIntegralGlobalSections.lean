/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.AlgebraicGeometry.Morphisms.Proper
public import Mathlib.FieldTheory.IsAlgClosed.Basic

/-!
# Global functions on proper integral schemes

An integral scheme universally closed over an algebraically closed field has no nonconstant
global regular functions.  This is the precise form needed by the negative-twist argument on a
projective plane curve.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry

/-- The structural map on global sections, with `Γ(Spec k, ⊤)` identified with `k`. -/
def globalSectionsMapFromBase
    (k : Type u) [Field k] {X : Scheme.{u}}
    (f : X ⟶ Spec (.of k)) :
    k →+* Γ(X, ⊤) :=
  ((Scheme.ΓSpecIso (.of k)).inv ≫ f.appTop).hom

/-- Every global function on an integral scheme universally closed over an algebraically closed
field comes from a unique scalar in the base field. -/
theorem globalSectionsMapFromBase_bijective_of_isIntegral_of_universallyClosed
    (k : Type u) [Field k] [IsAlgClosed k] {X : Scheme.{u}}
    (f : X ⟶ Spec (.of k)) [IsIntegral X] [UniversallyClosed f] :
    Function.Bijective (globalSectionsMapFromBase k f) := by
  let F := (Scheme.ΓSpecIso (.of k)).inv ≫ f.appTop
  have hFint : F.hom.IsIntegral := by
    apply RingHom.isIntegral_respectsIso.2
      (e := (Scheme.ΓSpecIso (.of k)).symm.commRingCatIsoToRingEquiv)
    exact isIntegral_appTop_of_universallyClosed f
  letI : IsField Γ(X, ⊤) := isField_of_universallyClosed k f
  change Function.Bijective F.hom
  exact IsAlgClosed.ringHom_bijective_of_isIntegral F.hom hFint

/-- Surjective form: every global regular function is a scalar. -/
theorem exists_scalar_eq_globalSection_of_isIntegral_of_universallyClosed
    (k : Type u) [Field k] [IsAlgClosed k] {X : Scheme.{u}}
    (f : X ⟶ Spec (.of k)) [IsIntegral X] [UniversallyClosed f]
    (s : Γ(X, ⊤)) :
    ∃ c : k, globalSectionsMapFromBase k f c = s :=
  (globalSectionsMapFromBase_bijective_of_isIntegral_of_universallyClosed k f).2 s

end

end BConicBundleMultisections
