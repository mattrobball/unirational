/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.AlgebraicGeometry.IdealSheaf.Functorial

/-!
# Finite open descent for ideal sheaves

This file records the order-theoretic ideal-sheaf lemmas used to descend compatible ideals from
a finite open cover.  For a quasi-compact open immersion, extending an ideal sheaf by `map` and
then restricting it by `comap` recovers the original ideal.  Consequently, the infimum of the
extensions of finitely many mutually compatible local ideals restricts to each given local ideal.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry

universe u

namespace AlgebraicGeometry.Scheme.IdealSheafData

variable {X Y : Scheme.{u}}

private lemma comap_ideal_eqToHom (I : X.IdealSheafData) {U V : X.affineOpens}
    (e : U.1 = V.1) :
    (I.ideal U).comap (X.presheaf.map (eqToHom e).op).hom = I.ideal V := by
  have hUV : U = V := Subtype.ext e
  subst V
  simp

/-- Restriction along an open immersion preserves finite infima of ideal sheaves. -/
lemma comap_iInf_of_isOpenImmersion {ι : Type*} [Finite ι]
    (I : ι → Y.IdealSheafData) (f : X ⟶ Y) [IsOpenImmersion f] :
    (⨅ i, I i).comap f = ⨅ i, (I i).comap f := by
  apply le_antisymm
  · exact le_iInf fun i => comap_mono f (iInf_le I i)
  · intro U x hx
    rw [ideal_comap_of_isOpenImmersion]
    rw [congrFun (ideal_iInf I) ⟨f ''ᵁ U, U.2.image_of_isOpenImmersion f⟩]
    rw [congrFun (ideal_iInf (fun i => (I i).comap f)) U] at hx
    rw [iInf_apply] at hx ⊢
    apply Ideal.mem_comap.mpr
    apply Ideal.mem_iInf.mpr
    intro i
    have hx' : ∀ j : ι, x ∈ ((I j).comap f).ideal U :=
      (Ideal.mem_iInf (I := fun j : ι => ((I j).comap f).ideal U)).mp hx
    have hxi := hx' i
    rw [ideal_comap_of_isOpenImmersion] at hxi
    exact hxi

/-- Extending an ideal sheaf along a quasi-compact open immersion and restricting it back is the
original ideal sheaf. -/
lemma comap_map_of_isOpenImmersion (I : X.IdealSheafData) (f : X ⟶ Y)
    [IsOpenImmersion f] [QuasiCompact f] :
    (I.map f).comap f = I := by
  apply IdealSheafData.ext
  funext U
  let V : Y.affineOpens := ⟨f ''ᵁ U, U.2.image_of_isOpenImmersion f⟩
  have hW : IsAffineOpen (f ⁻¹ᵁ V.1) := by
    change IsAffineOpen (f ⁻¹ᵁ f ''ᵁ U)
    rw [f.preimage_image_eq]
    exact U.2
  let W : X.affineOpens := ⟨f ⁻¹ᵁ V.1, hW⟩
  rw [ideal_comap_of_isOpenImmersion]
  change ((I.map f).ideal V).comap (f.appIso U).inv.hom = I.ideal U
  rw [ideal_map I f V hW]
  change ((I.ideal W).comap (f.app V).hom).comap (f.appIso U).inv.hom = I.ideal U
  rw [Ideal.comap_comap, ← CommRingCat.hom_comp]
  change (I.ideal W).comap ((f.appIso U).inv ≫ f.app V).hom = I.ideal U
  rw [show (f.appIso U).inv ≫ f.app V =
      X.presheaf.map (eqToHom (f.preimage_image_eq U)).op by
    exact f.appIso_inv_app U]
  exact comap_ideal_eqToHom I (f.preimage_image_eq U)

/-- The kernel of a quasi-compact morphism commutes with restriction along an open immersion. -/
lemma ker_eq_comap_of_isPullback_of_isOpenImmersion
    {P U V : Scheme.{u}} (q : U ⟶ Y) (q' : P ⟶ V)
    (a : P ⟶ U) (g : V ⟶ Y) [IsOpenImmersion g] [QuasiCompact q]
    (H : IsPullback q' a g q) :
    q'.ker = q.ker.comap g := by
  apply IdealSheafData.ext
  funext W
  rw [ker_ideal_of_isPullback_of_isOpenImmersion q q' a g H W]
  rw [ideal_comap_of_isOpenImmersion]

/-- Scheme-theoretic closure commutes with pullback along an open immersion. -/
lemma map_comap_eq_comap_map_of_isPullback
    {P U V : Scheme.{u}} (a : P ⟶ U) (b : P ⟶ V)
    (f : U ⟶ Y) (g : V ⟶ Y) (H : IsPullback a b f g)
    [IsOpenImmersion g] [QuasiCompact f] (I : U.IdealSheafData) :
    (I.comap a).map b = (I.map f).comap g := by
  let e := I.comapIso a
  let zmap : (I.comap a).subscheme ⟶ I.subscheme :=
    e.hom ≫ pullback.snd a I.subschemeι
  have hI : IsPullback (I.comap a).subschemeι zmap a I.subschemeι := by
    apply IsPullback.of_iso_pullback (by
      refine ⟨?_⟩
      simp [zmap, e]) e
    · exact I.comapIso_hom_fst a
    · rfl
  have hq : IsPullback ((I.comap a).subschemeι ≫ b) zmap g
      (I.subschemeι ≫ f) := hI.paste_horiz H.flip
  change ((I.comap a).subschemeι ≫ b).ker =
    ((I.subschemeι ≫ f).ker).comap g
  exact ker_eq_comap_of_isPullback_of_isOpenImmersion
    (I.subschemeι ≫ f) ((I.comap a).subschemeι ≫ b) zmap g hq

/-- If two ideal sheaves agree on a pullback and the second vertical map is an open immersion,
then the second ideal is contained in the restriction of the first one's scheme-theoretic
closure. -/
lemma le_comap_map_of_isPullback
    {P U V : Scheme.{u}} (a : P ⟶ U) (b : P ⟶ V)
    (f : U ⟶ Y) (g : V ⟶ Y) (H : IsPullback a b f g)
    [IsOpenImmersion g] [QuasiCompact f]
    (I : U.IdealSheafData) (J : V.IdealSheafData)
    (h : I.comap a = J.comap b) :
    J ≤ (I.map f).comap g := by
  rw [← map_comap_eq_comap_map_of_isPullback a b f g H I]
  rw [le_map_iff_comap_le]
  exact h.ge

/-- Let `I i` be ideal sheaves on finitely many quasi-compact open subschemes `U i` of `Y`.
If every `I j` is contained in the restriction of every extended `I i`, then the infimum of the
extensions restricts to `I j`. -/
lemma finiteOpenClosure_comap_eq {ι : Type*} [Finite ι]
    (U : ι → Scheme.{u}) (f : ∀ i, U i ⟶ Y) (I : ∀ i, (U i).IdealSheafData)
    (j : ι) [∀ i, IsOpenImmersion (f i)] [∀ i, QuasiCompact (f i)]
    (H : ∀ i j, I j ≤ ((I i).map (f i)).comap (f j)) :
    (⨅ i, (I i).map (f i)).comap (f j) = I j := by
  rw [comap_iInf_of_isOpenImmersion]
  apply le_antisymm
  · refine (iInf_le _ j).trans_eq ?_
    exact comap_map_of_isOpenImmersion (I j) (f j)
  · exact le_iInf fun i => H i j

end AlgebraicGeometry.Scheme.IdealSheafData
