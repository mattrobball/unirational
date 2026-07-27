/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.RelativelyAlgClosedRationalFunctionField
public import Mathlib.AlgebraicGeometry.Morphisms.Proper
public import Mathlib.FieldTheory.IsAlgClosed.Basic

/-!
# Global functions on proper integral schemes

An integral scheme universally closed over an algebraically closed field has no nonconstant
global regular functions.  This is the precise form needed by the negative-twist argument on a
projective plane curve.

## Algebraic closure is not what the argument uses

Mathlib's `IsAlgClosed.ringHom_bijective_of_isIntegral` factors through
`IsAlgClosed.algebraMap_bijective_of_isIntegral`, whose content is only that `k` has no proper
integral extension *inside the ring in question*.  So the statement below is proved twice: once
from `[IsAlgClosed k]`, and once from the strictly weaker hypothesis that `Γ(X, 𝒪)` embeds
`k`-compatibly into some field `L` in which `k` is relatively algebraically closed
(`algebraicClosure k L = ⊥`).  The second form is what survives when the base field is not
assumed algebraically closed: for a curve dominated by `𝔸²_k` one may take `L = k(t,s)`, where
`algebraicClosure_fractionRing_mvPolynomial_eq_bot` supplies the hypothesis with no condition on
`k` at all.

The compatibility `g.comp f = algebraMap k L` is automatic in the intended application — `g` is
restriction to the generic point — but it is not formally derivable from injectivity, so it is a
named hypothesis.
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

/-- **The same conclusion without `[IsAlgClosed k]`.**

Global sections of an integral scheme universally closed over `k` are integral over `k`, so the
only thing algebraic closure was ever used for is that `k` admits no proper integral extension
inside `Γ(X, 𝒪)`.  It is enough that `Γ(X, 𝒪)` embeds `k`-compatibly into *some* field `L` with
`algebraicClosure k L = ⊥`; the embedding carries the integral element to an algebraic element of
`L`, which is then a scalar. -/
theorem globalSectionsMapFromBase_bijective_of_isIntegral_of_universallyClosed_of_embedding
    (k : Type u) [Field k] {X : Scheme.{u}}
    (f : X ⟶ Spec (.of k)) [IsIntegral X] [UniversallyClosed f]
    {L : Type*} [Field L] [Algebra k L] (hL : algebraicClosure k L = ⊥)
    (g : Γ(X, ⊤) →+* L) (hg : Function.Injective g)
    (hgf : g.comp (globalSectionsMapFromBase k f) = algebraMap k L) :
    Function.Bijective (globalSectionsMapFromBase k f) := by
  have hFint : (globalSectionsMapFromBase k f).IsIntegral := by
    apply RingHom.isIntegral_respectsIso.2
      (e := (Scheme.ΓSpecIso (.of k)).symm.commRingCatIsoToRingEquiv)
    exact isIntegral_appTop_of_universallyClosed f
  exact ringHom_bijective_of_isIntegral_of_injective hL _ hFint g hg hgf

/-- Surjective form of the `IsAlgClosed`-free statement. -/
theorem exists_scalar_eq_globalSection_of_isIntegral_of_universallyClosed_of_embedding
    (k : Type u) [Field k] {X : Scheme.{u}}
    (f : X ⟶ Spec (.of k)) [IsIntegral X] [UniversallyClosed f]
    {L : Type*} [Field L] [Algebra k L] (hL : algebraicClosure k L = ⊥)
    (g : Γ(X, ⊤) →+* L) (hg : Function.Injective g)
    (hgf : g.comp (globalSectionsMapFromBase k f) = algebraMap k L)
    (s : Γ(X, ⊤)) :
    ∃ c : k, globalSectionsMapFromBase k f c = s :=
  (globalSectionsMapFromBase_bijective_of_isIntegral_of_universallyClosed_of_embedding
    k f hL g hg hgf).2 s

end

end BConicBundleMultisections
