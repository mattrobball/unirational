/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.AlgebraicGeometry.Fiber
public import Mathlib.AlgebraicGeometry.IdealSheaf.Functorial

/-!
# Fibers of closed subschemes

This file records the generic comparison between the fiber of a composite `i ≫ f` and the
pullback of `i` to a fiber of `f`.  When `i` is a closed immersion, the resulting morphism to the
ambient fiber is again a closed immersion, and its kernel is the pullback of the kernel of `i`.
In particular, the fiber of a closed subscheme is canonically the subscheme of the ambient fiber
cut out by the pulled-back ideal sheaf.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace AlgebraicGeometry

noncomputable section

universe u

variable {Z B P : Scheme.{u}}

namespace Scheme.Hom

/-- The fiber of a composite `i ≫ f` is canonically the pullback of `i` along the fiber
inclusion of `f`. -/
def fiberCompIsoPullbackFiber (i : Z ⟶ B) (f : B ⟶ P) (x : P) :
    (i ≫ f).fiber x ≅ pullback i (f.fiberι x) :=
  (pullbackRightPullbackFstIso f (P.fromSpecResidueField x) i).symm

/-- The natural morphism from a fiber of `i ≫ f` to the corresponding fiber of `f`. -/
def fiberCompToFiber (i : Z ⟶ B) (f : B ⟶ P) (x : P) :
    (i ≫ f).fiber x ⟶ f.fiber x :=
  (fiberCompIsoPullbackFiber i f x).hom ≫ pullback.snd _ _

@[reassoc (attr := simp)]
lemma fiberCompIsoPullbackFiber_hom_fst (i : Z ⟶ B) (f : B ⟶ P) (x : P) :
    (fiberCompIsoPullbackFiber i f x).hom ≫ pullback.fst _ _ =
      (i ≫ f).fiberι x := by
  exact pullbackRightPullbackFstIso_inv_fst f (P.fromSpecResidueField x) i

@[reassoc (attr := simp)]
lemma fiberCompToFiber_fiberι (i : Z ⟶ B) (f : B ⟶ P) (x : P) :
    fiberCompToFiber i f x ≫ f.fiberι x = (i ≫ f).fiberι x ≫ i := by
  change (pullbackRightPullbackFstIso f (P.fromSpecResidueField x) i).inv ≫
      pullback.snd i (pullback.fst f (P.fromSpecResidueField x)) ≫
      pullback.fst f (P.fromSpecResidueField x) =
    pullback.fst (i ≫ f) (P.fromSpecResidueField x) ≫ i
  exact pullbackRightPullbackFstIso_inv_snd_fst f (P.fromSpecResidueField x) i

@[reassoc (attr := simp)]
lemma fiberCompToFiber_fiberToSpecResidueField
    (i : Z ⟶ B) (f : B ⟶ P) (x : P) :
    fiberCompToFiber i f x ≫ f.fiberToSpecResidueField x =
      (i ≫ f).fiberToSpecResidueField x := by
  change (pullbackRightPullbackFstIso f (P.fromSpecResidueField x) i).inv ≫
      pullback.snd i (pullback.fst f (P.fromSpecResidueField x)) ≫
      pullback.snd f (P.fromSpecResidueField x) =
    pullback.snd (i ≫ f) (P.fromSpecResidueField x)
  exact pullbackRightPullbackFstIso_inv_snd_snd f (P.fromSpecResidueField x) i

/-- The natural morphism from the fiber of `i ≫ f` to the fiber of `f` exhibits the former as
the pullback of `i`. -/
lemma fiberCompToFiber_isPullback (i : Z ⟶ B) (f : B ⟶ P) (x : P) :
    IsPullback ((i ≫ f).fiberι x) (fiberCompToFiber i f x) i (f.fiberι x) := by
  apply IsPullback.of_iso_pullback
    (by constructor; exact (fiberCompToFiber_fiberι i f x).symm)
    (fiberCompIsoPullbackFiber i f x)
  · exact fiberCompIsoPullbackFiber_hom_fst i f x
  · rfl

/-- A closed immersion remains a closed immersion after restriction to a scheme-theoretic
fiber. -/
instance [IsClosedImmersion i] (f : B ⟶ P) (x : P) :
    IsClosedImmersion (fiberCompToFiber i f x) :=
  MorphismProperty.of_isPullback (fiberCompToFiber_isPullback i f x) inferInstance

/-- The ideal of a closed subscheme restricted to a fiber is its ideal-sheaf pullback along the
ambient fiber inclusion. -/
lemma ker_fiberCompToFiber [IsClosedImmersion i] (f : B ⟶ P) (x : P) :
    (fiberCompToFiber i f x).ker = i.ker.comap (f.fiberι x) := by
  unfold fiberCompToFiber
  rw [ker_comp_of_isIso]
  rw [← pullbackSymmetry_hom_comp_fst i (f.fiberι x)]
  rw [ker_comp_of_isIso]
  exact Scheme.IdealSheafData.ker_fst_of_isClosedImmersion i (f.fiberι x)

end Scheme.Hom

namespace Scheme.IdealSheafData

/-- The fiber of a closed subscheme followed by `f` is the subscheme of the ambient fiber cut
out by the pulled-back ideal. -/
def fiberIsoComapSubscheme (I : B.IdealSheafData) (f : B ⟶ P) (x : P) :
    (I.subschemeι ≫ f).fiber x ≅ (I.comap (f.fiberι x)).subscheme :=
  (Scheme.Hom.fiberCompIsoPullbackFiber I.subschemeι f x).trans
    ((pullbackSymmetry I.subschemeι (f.fiberι x)).trans
      (I.comapIso (f.fiberι x)).symm)

@[reassoc]
lemma fiberIsoComapSubscheme_hom_subschemeι
    (I : B.IdealSheafData) (f : B ⟶ P) (x : P) :
    (I.fiberIsoComapSubscheme f x).hom ≫
        (I.comap (f.fiberι x)).subschemeι =
      Scheme.Hom.fiberCompToFiber I.subschemeι f x := by
  simp [fiberIsoComapSubscheme, Scheme.Hom.fiberCompToFiber]

end Scheme.IdealSheafData

end

end AlgebraicGeometry
