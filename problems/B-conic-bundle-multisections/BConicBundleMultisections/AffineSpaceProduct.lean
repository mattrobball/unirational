/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.Algebra.MvPolynomial.Equiv
public import Mathlib.AlgebraicGeometry.AffineSpace
public import Mathlib.Data.Fin.Tuple.Basic
public import Mathlib.Data.Fintype.Sum

/-!
# Affine space products over an affine base

Over `Spec R`,

\[
  \mathbb A^1_{\mathbb A^m} \;\simeq\; \mathbb A^{m+1}.
\]

The isomorphism is constructed from the ring equivalence of successive polynomial rings and is
compatible with structure maps to `Spec R`.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections
namespace AffineSpaceProduct

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial

/-- Base change of affine space along a base isomorphism. -/
def rebaseIso {S T : Scheme.{u}} (n : Type u) (e : S ≅ T) :
    𝔸(n; S) ≅ 𝔸(n; T) where
  hom := AffineSpace.map n e.hom
  inv := AffineSpace.map n e.inv
  hom_inv_id := by rw [← AffineSpace.map_comp, e.hom_inv_id, AffineSpace.map_id]
  inv_hom_id := by rw [← AffineSpace.map_comp, e.inv_hom_id, AffineSpace.map_id]

theorem rebaseIso_hom_over {S T : Scheme.{u}} (n : Type u) (e : S ≅ T) :
    (rebaseIso n e).hom ≫ (𝔸(n; T) ↘ T) = (𝔸(n; S) ↘ S) ≫ e.hom :=
  AffineSpace.map_over (n := n) e.hom

theorem rebaseIso_inv_over {S T : Scheme.{u}} (n : Type u) (e : S ≅ T) :
    (rebaseIso n e).inv ≫ (𝔸(n; S) ↘ S) = (𝔸(n; T) ↘ T) ≫ e.inv :=
  AffineSpace.map_over (n := n) e.inv

/-- CommRingCat isomorphism from a ring equivalence. -/
def ofRingEquiv {R S : Type u} [CommRing R] [CommRing S] (e : R ≃+* S) :
    CommRingCat.of R ≅ CommRingCat.of S where
  hom := CommRingCat.ofHom e.toRingHom
  inv := CommRingCat.ofHom e.symm.toRingHom
  hom_inv_id := by
    ext x
    exact e.left_inv x
  inv_hom_id := by
    ext x
    exact e.right_inv x

/-- Ring equivalence realizing dimension additivity of polynomial rings. -/
def polySuccRingEquiv (R : Type u) [CommRing R] (m : ℕ) :
    MvPolynomial (ULift.{u} (Fin 1)) (MvPolynomial (ULift.{u} (Fin m)) R) ≃+*
      MvPolynomial (ULift.{u} (Fin (m + 1))) R := by
  let eCoeff :
      MvPolynomial (ULift.{u} (Fin 1)) (MvPolynomial (ULift.{u} (Fin m)) R) ≃+*
        MvPolynomial (ULift.{u} (Fin 1)) (MvPolynomial (Fin m) R) :=
    mapEquiv _ (renameEquiv R Equiv.ulift).toRingEquiv
  let eVar :
      MvPolynomial (ULift.{u} (Fin 1)) (MvPolynomial (Fin m) R) ≃+*
        MvPolynomial (Fin 1) (MvPolynomial (Fin m) R) :=
    (renameEquiv (MvPolynomial (Fin m) R) Equiv.ulift).toRingEquiv
  let eSum :
      MvPolynomial (Fin 1) (MvPolynomial (Fin m) R) ≃+* MvPolynomial (Fin 1 ⊕ Fin m) R :=
    (sumAlgEquiv R (Fin 1) (Fin m)).symm.toRingEquiv
  let eFin :
      MvPolynomial (Fin 1 ⊕ Fin m) R ≃+* MvPolynomial (Fin (m + 1)) R :=
    (renameEquiv R
      (finSumFinEquiv (m := 1) (n := m) |>.trans (finCongr (Nat.add_comm 1 m)))).toRingEquiv
  let eUlift :
      MvPolynomial (Fin (m + 1)) R ≃+* MvPolynomial (ULift.{u} (Fin (m + 1))) R :=
    (renameEquiv R Equiv.ulift).symm.toRingEquiv
  exact eCoeff.trans (eVar.trans (eSum.trans (eFin.trans eUlift)))

/-- Constants are preserved by `polySuccRingEquiv`. -/
theorem polySuccRingEquiv_C (R : Type u) [CommRing R] (m : ℕ) (r : R) :
    polySuccRingEquiv R m (C (C r)) = C r := by
  unfold polySuccRingEquiv
  simp only [RingEquiv.coe_trans, Function.comp_apply]
  have hCoeff :
      (mapEquiv (ULift.{u} (Fin 1))
          (renameEquiv R (Equiv.ulift : ULift.{u} (Fin m) ≃ Fin m)).toRingEquiv)
        (C (C r)) =
      C (C r : MvPolynomial (Fin m) R) := by
    have hmap :=
      map_C (σ := ULift.{u} (Fin 1))
        (f := (renameEquiv R (Equiv.ulift : ULift.{u} (Fin m) ≃ Fin m)).toRingHom)
        (a := (C r : MvPolynomial (ULift.{u} (Fin m)) R))
    convert hmap.trans ?_
    · rfl
    · congr 1
      exact rename_C (Equiv.ulift : ULift.{u} (Fin m) → Fin m) r
  rw [hCoeff]
  have hVar :
      ((renameEquiv (MvPolynomial (Fin m) R)
          (Equiv.ulift : ULift.{u} (Fin 1) ≃ Fin 1)).toRingEquiv)
        (C (C r : MvPolynomial (Fin m) R)) =
      (C (C r) : MvPolynomial (Fin 1) (MvPolynomial (Fin m) R)) := by
    change (renameEquiv (MvPolynomial (Fin m) R) Equiv.ulift) (C (C r)) = C (C r)
    exact rename_C Equiv.ulift (C r)
  rw [hVar]
  have hSum :
      ((sumAlgEquiv R (Fin 1) (Fin m)).symm.toRingEquiv)
        (C (C r) : MvPolynomial (Fin 1) (MvPolynomial (Fin m) R)) =
      (C r : MvPolynomial (Fin 1 ⊕ Fin m) R) := by
    change (sumAlgEquiv R (Fin 1) (Fin m)).symm (C (C r)) = C r
    exact sumAlgEquiv_symm_C_C R (Fin 1) (Fin m) r
  rw [hSum]
  have hFin :
      ((renameEquiv R
          (finSumFinEquiv (m := 1) (n := m) |>.trans (finCongr (Nat.add_comm 1 m)))).toRingEquiv)
        (C r) =
      (C r : MvPolynomial (Fin (m + 1)) R) := by
    change (renameEquiv R (finSumFinEquiv.trans (finCongr (Nat.add_comm 1 m)))) (C r) = C r
    exact rename_C _ r
  rw [hFin]
  change (renameEquiv R Equiv.ulift).symm (C r) = C r
  exact rename_C Equiv.ulift.symm r

theorem polySuccRingEquiv_symm_C (R : Type u) [CommRing R] (m : ℕ) (r : R) :
    (polySuccRingEquiv R m).symm (C r) = C (C r) := by
  have h := congrArg (polySuccRingEquiv R m).symm (polySuccRingEquiv_C R m r)
  simpa using h.symm

/-- The inverse ring equivalence sends constants to double constants. -/
theorem polySuccRingEquiv_symm_comp_C (R : Type u) [CommRing R] (m : ℕ) :
    (polySuccRingEquiv R m).symm.toRingHom.comp
        (C : R →+* MvPolynomial (ULift.{u} (Fin (m + 1))) R) =
      (C : MvPolynomial (ULift.{u} (Fin m)) R →+*
          MvPolynomial (ULift.{u} (Fin 1)) (MvPolynomial (ULift.{u} (Fin m)) R)).comp
        (C : R →+* MvPolynomial (ULift.{u} (Fin m)) R) := by
  refine RingHom.ext fun r => ?_
  simp only [RingHom.comp_apply]
  exact polySuccRingEquiv_symm_C R m r

/-- Intermediate isomorphism: `𝔸¹` over `Spec R[ULift Fin m]` ≃ `𝔸^{m+1}` over `Spec R`. -/
def affineOneOverPolySpecIso (R : CommRingCat.{u}) (m : ℕ) :
    𝔸(ULift.{u} (Fin 1); Spec (.of (MvPolynomial (ULift.{u} (Fin m)) ↑R))) ≅
      𝔸(ULift.{u} (Fin (m + 1)); Spec R) :=
  let e := polySuccRingEquiv (↑R : Type u) m
  let eIso := ofRingEquiv e
  (AffineSpace.SpecIso (ULift.{u} (Fin 1))
      (.of (MvPolynomial (ULift.{u} (Fin m)) ↑R))) ≪≫
    { hom := Spec.map eIso.inv
      inv := Spec.map eIso.hom
      hom_inv_id := by rw [← Spec.map_comp, eIso.hom_inv_id, Spec.map_id]
      inv_hom_id := by rw [← Spec.map_comp, eIso.inv_hom_id, Spec.map_id] } ≪≫
    (AffineSpace.SpecIso (ULift.{u} (Fin (m + 1))) R).symm

/-- The poly-spectrum isomorphism preserves structure maps over `Spec R`. -/
theorem affineOneOverPolySpecIso_hom_over (R : CommRingCat.{u}) (m : ℕ) :
    (affineOneOverPolySpecIso R m).hom ≫
      (𝔸(ULift.{u} (Fin (m + 1)); Spec R) ↘ Spec R) =
      𝔸(ULift.{u} (Fin 1); Spec (.of (MvPolynomial (ULift.{u} (Fin m)) ↑R))) ↘
          Spec (.of (MvPolynomial (ULift.{u} (Fin m)) ↑R)) ≫
        Spec.map (CommRingCat.ofHom
          (C : (↑R : Type u) →+* MvPolynomial (ULift.{u} (Fin m)) ↑R)) := by
  let e1 := AffineSpace.SpecIso (ULift.{u} (Fin 1))
    (.of (MvPolynomial (ULift.{u} (Fin m)) ↑R))
  have h1over := AffineSpace.SpecIso_inv_over
    (n := ULift.{u} (Fin 1)) (.of (MvPolynomial (ULift.{u} (Fin m)) ↑R))
  have h1 :
      𝔸(ULift.{u} (Fin 1); Spec (.of (MvPolynomial (ULift.{u} (Fin m)) ↑R))) ↘
          Spec (.of (MvPolynomial (ULift.{u} (Fin m)) ↑R)) =
        e1.hom ≫ Spec.map (CommRingCat.ofHom
          (C : MvPolynomial (ULift.{u} (Fin m)) ↑R →+*
            MvPolynomial (ULift.{u} (Fin 1)) (MvPolynomial (ULift.{u} (Fin m)) ↑R))) :=
    (Iso.eq_inv_comp e1).mp h1over.symm |>.symm
  have h3 := AffineSpace.SpecIso_inv_over (n := ULift.{u} (Fin (m + 1))) R
  simp only [affineOneOverPolySpecIso, Iso.trans_hom, Category.assoc]
  rw [h1, Category.assoc]
  congr 1
  change
      Spec.map (ofRingEquiv (polySuccRingEquiv (↑R : Type u) m)).inv ≫
          (AffineSpace.SpecIso (ULift.{u} (Fin (m + 1))) R).inv ≫
            (𝔸(ULift.{u} (Fin (m + 1)); Spec R) ↘ Spec R) =
        Spec.map (CommRingCat.ofHom
            (C : MvPolynomial (ULift.{u} (Fin m)) ↑R →+*
              MvPolynomial (ULift.{u} (Fin 1)) (MvPolynomial (ULift.{u} (Fin m)) ↑R))) ≫
          Spec.map (CommRingCat.ofHom
            (C : (↑R : Type u) →+* MvPolynomial (ULift.{u} (Fin m)) ↑R))
  rw [h3]
  simp only [← Spec.map_comp, ← CommRingCat.ofHom_comp]
  have hring := polySuccRingEquiv_symm_comp_C (↑R : Type u) m
  dsimp only [ofRingEquiv]
  convert congrArg (fun φ => Spec.map (CommRingCat.ofHom φ)) hring using 1
  · rfl
  · rfl

/--
**Dimension additivity over an affine base.**

`𝔸¹` over `𝔸ᵐ_{Spec R}` is isomorphic to `𝔸^{m+1}_{Spec R}`.
-/
def affineOneOverAffineIso (R : CommRingCat.{u}) (m : ℕ) :
    𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin m); Spec R)) ≅
      𝔸(ULift.{u} (Fin (m + 1)); Spec R) :=
  rebaseIso (ULift.{u} (Fin 1)) (AffineSpace.SpecIso (ULift.{u} (Fin m)) R) ≪≫
    affineOneOverPolySpecIso R m

/-- Specialization `m = 2`: `𝔸¹` over `𝔸²` is `𝔸³`. -/
def affineOneOverAffineTwoIso (R : CommRingCat.{u}) :
    𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin 2); Spec R)) ≅
      𝔸(ULift.{u} (Fin 3); Spec R) :=
  affineOneOverAffineIso R 2

/-- The forward isomorphism preserves the structure map to `Spec R`. -/
theorem affineOneOverAffineIso_hom_over (R : CommRingCat.{u}) (m : ℕ) :
    (affineOneOverAffineIso R m).hom ≫
      (𝔸(ULift.{u} (Fin (m + 1)); Spec R) ↘ Spec R) =
      𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin m); Spec R)) ↘ Spec R := by
  simp only [affineOneOverAffineIso, Iso.trans_hom, Category.assoc]
  have hre := rebaseIso_hom_over (ULift.{u} (Fin 1))
    (AffineSpace.SpecIso (ULift.{u} (Fin m)) R)
  have hpoly := affineOneOverPolySpecIso_hom_over R m
  have hA :
      (𝔸(ULift.{u} (Fin m); Spec R) ↘ Spec R) =
        (AffineSpace.SpecIso (ULift.{u} (Fin m)) R).hom ≫
          Spec.map (CommRingCat.ofHom
            (C : (↑R : Type u) →+* MvPolynomial (ULift.{u} (Fin m)) ↑R)) := by
    have h := AffineSpace.SpecIso_inv_over (n := ULift.{u} (Fin m)) R
    exact (Iso.eq_inv_comp _).mp h.symm |>.symm
  rw [hpoly]
  calc
    (rebaseIso (ULift.{u} (Fin 1)) (AffineSpace.SpecIso (ULift.{u} (Fin m)) R)).hom ≫
        (𝔸(ULift.{u} (Fin 1); Spec (.of (MvPolynomial (ULift.{u} (Fin m)) ↑R))) ↘
            Spec (.of (MvPolynomial (ULift.{u} (Fin m)) ↑R))) ≫
          Spec.map (CommRingCat.ofHom
            (C : (↑R : Type u) →+* MvPolynomial (ULift.{u} (Fin m)) ↑R))
        =
      ((rebaseIso (ULift.{u} (Fin 1)) (AffineSpace.SpecIso (ULift.{u} (Fin m)) R)).hom ≫
          (𝔸(ULift.{u} (Fin 1); Spec (.of (MvPolynomial (ULift.{u} (Fin m)) ↑R))) ↘
            Spec (.of (MvPolynomial (ULift.{u} (Fin m)) ↑R)))) ≫
        Spec.map (CommRingCat.ofHom
          (C : (↑R : Type u) →+* MvPolynomial (ULift.{u} (Fin m)) ↑R)) := by
      simp only [Category.assoc]
    _ =
      ((𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin m); Spec R)) ↘
            𝔸(ULift.{u} (Fin m); Spec R)) ≫
          (AffineSpace.SpecIso (ULift.{u} (Fin m)) R).hom) ≫
        Spec.map (CommRingCat.ofHom
          (C : (↑R : Type u) →+* MvPolynomial (ULift.{u} (Fin m)) ↑R)) := by
      rw [hre]
    _ =
      (𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin m); Spec R)) ↘
          𝔸(ULift.{u} (Fin m); Spec R)) ≫
        ((AffineSpace.SpecIso (ULift.{u} (Fin m)) R).hom ≫
          Spec.map (CommRingCat.ofHom
            (C : (↑R : Type u) →+* MvPolynomial (ULift.{u} (Fin m)) ↑R))) := by
      simp only [Category.assoc]
    _ =
      (𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin m); Spec R)) ↘
          𝔸(ULift.{u} (Fin m); Spec R)) ≫
        (𝔸(ULift.{u} (Fin m); Spec R) ↘ Spec R) := by
      rw [← hA]
    _ = 𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin m); Spec R)) ↘ Spec R := rfl

theorem affineOneOverAffineTwoIso_hom_over (R : CommRingCat.{u}) :
    (affineOneOverAffineTwoIso R).hom ≫
      (𝔸(ULift.{u} (Fin 3); Spec R) ↘ Spec R) =
      𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin 2); Spec R)) ↘ Spec R := by
  simpa [affineOneOverAffineTwoIso] using affineOneOverAffineIso_hom_over R 2

/-- The inverse of `affineOneOverAffineTwoIso` preserves the structure map to `Spec R`. -/
theorem affineOneOverAffineTwoIso_inv_over (R : CommRingCat.{u}) :
    (affineOneOverAffineTwoIso R).inv ≫
      (𝔸(ULift.{u} (Fin 1); 𝔸(ULift.{u} (Fin 2); Spec R)) ↘ Spec R) =
      𝔸(ULift.{u} (Fin 3); Spec R) ↘ Spec R :=
  (Iso.inv_comp_eq _).mpr (affineOneOverAffineTwoIso_hom_over R).symm

end

end AffineSpaceProduct
end BConicBundleMultisections
