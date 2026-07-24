/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveZeroLocus
public import BConicBundleMultisections.SchemeFiberClosedSubscheme

/-!
# Fibers of the projections from a biprojective zero locus

This file identifies the ambient fibers of the two projections from
`BiprojectiveSpace m n R` with residue-field base changes of the opposite projective factor.
It then realizes the fibers of a biprojective zero locus as closed subschemes of those ambient
fibers, first intrinsically and then after transport to the corresponding base change.

All declarations retain arbitrary dimensions `m` and `n`.  In particular, the homogeneous
coordinates of the two factors remain indexed by `Fin (m + 1)` and `Fin (n + 1)` through the
definitions of `ProjectiveSpace` and `BiprojectiveSpace`.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry

namespace BiprojectiveSpace

/-! ## Ambient fibers as residue-field base changes -/

/-- The base change of the second projective factor to the residue field of a point `x` in the
first factor. -/
abbrev fstFiberBaseChange (m n : ℕ) (R : Type u) [CommRing R]
    (x : ProjectiveSpace m R) : Scheme :=
  pullback (ProjectiveSpace.toSpec n R)
    ((ProjectiveSpace m R).fromSpecResidueField x ≫ ProjectiveSpace.toSpec m R)

/-- The ambient fiber of the first projection is canonically the residue-field base change of
the second projective factor. -/
def fstFiberIsoBaseChange (m n : ℕ) (R : Type u) [CommRing R]
    (x : ProjectiveSpace m R) :
    (fst m n R).fiber x ≅ fstFiberBaseChange m n R x :=
  pullbackSymmetry (fst m n R) ((ProjectiveSpace m R).fromSpecResidueField x) ≪≫
    pullbackRightPullbackFstIso (ProjectiveSpace.toSpec m R)
      (ProjectiveSpace.toSpec n R) ((ProjectiveSpace m R).fromSpecResidueField x) ≪≫
    pullbackSymmetry
      ((ProjectiveSpace m R).fromSpecResidueField x ≫ ProjectiveSpace.toSpec m R)
      (ProjectiveSpace.toSpec n R)

@[reassoc (attr := simp)]
theorem fstFiberIsoBaseChange_hom_fst (m n : ℕ) (R : Type u) [CommRing R]
    (x : ProjectiveSpace m R) :
    (fstFiberIsoBaseChange m n R x).hom ≫ pullback.fst _ _ =
      (fst m n R).fiberι x ≫ snd m n R := by
  unfold fstFiberIsoBaseChange
  change _ = pullback.fst (fst m n R)
      ((ProjectiveSpace m R).fromSpecResidueField x) ≫
        pullback.snd (ProjectiveSpace.toSpec m R) (ProjectiveSpace.toSpec n R)
  simp only [Iso.trans_hom, Category.assoc,
    pullbackSymmetry_hom_comp_fst, pullbackRightPullbackFstIso_hom_snd]
  simpa only [Scheme.Hom.fiber] using
    pullbackSymmetry_hom_comp_snd_assoc (fst m n R)
      ((ProjectiveSpace m R).fromSpecResidueField x) (snd m n R)

@[reassoc (attr := simp)]
theorem fstFiberIsoBaseChange_hom_snd (m n : ℕ) (R : Type u) [CommRing R]
    (x : ProjectiveSpace m R) :
    (fstFiberIsoBaseChange m n R x).hom ≫ pullback.snd _ _ =
      (fst m n R).fiberToSpecResidueField x := by
  unfold fstFiberIsoBaseChange
  simp only [Iso.trans_hom, Category.assoc,
    pullbackSymmetry_hom_comp_snd, pullbackRightPullbackFstIso_hom_fst]
  exact pullbackSymmetry_hom_comp_fst _ _

/-- The base change of the first projective factor to the residue field of a point `y` in the
second factor. -/
abbrev sndFiberBaseChange (m n : ℕ) (R : Type u) [CommRing R]
    (y : ProjectiveSpace n R) : Scheme :=
  pullback (ProjectiveSpace.toSpec m R)
    ((ProjectiveSpace n R).fromSpecResidueField y ≫ ProjectiveSpace.toSpec n R)

/-- The ambient fiber of the second projection is canonically the residue-field base change of
the first projective factor. -/
def sndFiberIsoBaseChange (m n : ℕ) (R : Type u) [CommRing R]
    (y : ProjectiveSpace n R) :
    (snd m n R).fiber y ≅ sndFiberBaseChange m n R y :=
  pullbackLeftPullbackSndIso (ProjectiveSpace.toSpec m R)
    (ProjectiveSpace.toSpec n R) ((ProjectiveSpace n R).fromSpecResidueField y)

@[reassoc (attr := simp)]
theorem sndFiberIsoBaseChange_hom_fst (m n : ℕ) (R : Type u) [CommRing R]
    (y : ProjectiveSpace n R) :
    (sndFiberIsoBaseChange m n R y).hom ≫ pullback.fst _ _ =
      (snd m n R).fiberι y ≫ fst m n R := by
  exact pullbackLeftPullbackSndIso_hom_fst _ _ _

@[reassoc (attr := simp)]
theorem sndFiberIsoBaseChange_hom_snd (m n : ℕ) (R : Type u) [CommRing R]
    (y : ProjectiveSpace n R) :
    (sndFiberIsoBaseChange m n R y).hom ≫ pullback.snd _ _ =
      (snd m n R).fiberToSpecResidueField y := by
  exact pullbackLeftPullbackSndIso_hom_snd _ _ _

/-! ## Fibers as closed subschemes of the ambient fibers -/

variable (m n : ℕ) (R : Type u) [CommRing R]
variable (F : MvPolynomial (BiprojectiveCoordinate m n) R)

/-- The fiber of the first restricted projection as a closed subscheme of the corresponding
ambient fiber. -/
abbrev zeroLocusFstFiberι (x : ProjectiveSpace m R) :
    (biprojectiveZeroLocusFst m n R F).fiber x ⟶ (fst m n R).fiber x :=
  Scheme.Hom.fiberCompToFiber
    (biprojectiveZeroLocusι m n R F) (fst m n R) x

instance (x : ProjectiveSpace m R) :
    IsClosedImmersion (zeroLocusFstFiberι m n R F x) := by
  change IsClosedImmersion
    (Scheme.Hom.fiberCompToFiber
      (biprojectiveZeroLocusι m n R F) (fst m n R) x)
  infer_instance

@[reassoc (attr := simp)]
theorem zeroLocusFstFiberι_fiberι (x : ProjectiveSpace m R) :
    zeroLocusFstFiberι m n R F x ≫ (fst m n R).fiberι x =
      (biprojectiveZeroLocusFst m n R F).fiberι x ≫
        biprojectiveZeroLocusι m n R F :=
  Scheme.Hom.fiberCompToFiber_fiberι _ _ _

@[reassoc (attr := simp)]
theorem zeroLocusFstFiberι_toSpecResidueField (x : ProjectiveSpace m R) :
    zeroLocusFstFiberι m n R F x ≫
        (fst m n R).fiberToSpecResidueField x =
      (biprojectiveZeroLocusFst m n R F).fiberToSpecResidueField x :=
  Scheme.Hom.fiberCompToFiber_fiberToSpecResidueField _ _ _

/-- The ideal cutting out a fiber of the first restricted projection inside the corresponding
ambient fiber. -/
def zeroLocusFstFiberIdeal (x : ProjectiveSpace m R) :
    ((fst m n R).fiber x).IdealSheafData :=
  (biprojectiveZeroLocusIdeal m n R F).comap ((fst m n R).fiberι x)

theorem ker_zeroLocusFstFiberι (x : ProjectiveSpace m R) :
    (zeroLocusFstFiberι m n R F x).ker =
      zeroLocusFstFiberIdeal m n R F x := by
  change (Scheme.Hom.fiberCompToFiber
      (biprojectiveZeroLocusι m n R F) (fst m n R) x).ker = _
  rw [Scheme.Hom.ker_fiberCompToFiber]
  exact congrArg (fun I ↦ I.comap ((fst m n R).fiberι x))
    (ker_biprojectiveZeroLocusι m n R F)

/-- A fiber of the first restricted projection is canonically the subscheme of the ambient fiber
defined by the pulled-back biprojective ideal. -/
def zeroLocusFstFiberIsoSubscheme (x : ProjectiveSpace m R) :
    (biprojectiveZeroLocusFst m n R F).fiber x ≅
      (zeroLocusFstFiberIdeal m n R F x).subscheme :=
  (biprojectiveZeroLocusIdeal m n R F).fiberIsoComapSubscheme (fst m n R) x

@[reassoc]
theorem zeroLocusFstFiberIsoSubscheme_hom_subschemeι
    (x : ProjectiveSpace m R) :
    (zeroLocusFstFiberIsoSubscheme m n R F x).hom ≫
        (zeroLocusFstFiberIdeal m n R F x).subschemeι =
      zeroLocusFstFiberι m n R F x := by
  exact Scheme.IdealSheafData.fiberIsoComapSubscheme_hom_subschemeι _ _ _

/-- The first restricted projection has its whole ambient fiber at `x` exactly when the
pulled-back defining ideal is zero. -/
theorem isIso_zeroLocusFstFiberι_iff (x : ProjectiveSpace m R) :
    IsIso (zeroLocusFstFiberι m n R F x) ↔
      zeroLocusFstFiberIdeal m n R F x = ⊥ := by
  rw [IsClosedImmersion.isIso_iff_ker_eq_bot, ker_zeroLocusFstFiberι]

/-- The fiber of the second restricted projection as a closed subscheme of the corresponding
ambient fiber. -/
abbrev zeroLocusSndFiberι (y : ProjectiveSpace n R) :
    (biprojectiveZeroLocusSnd m n R F).fiber y ⟶ (snd m n R).fiber y :=
  Scheme.Hom.fiberCompToFiber
    (biprojectiveZeroLocusι m n R F) (snd m n R) y

instance (y : ProjectiveSpace n R) :
    IsClosedImmersion (zeroLocusSndFiberι m n R F y) := by
  change IsClosedImmersion
    (Scheme.Hom.fiberCompToFiber
      (biprojectiveZeroLocusι m n R F) (snd m n R) y)
  infer_instance

@[reassoc (attr := simp)]
theorem zeroLocusSndFiberι_fiberι (y : ProjectiveSpace n R) :
    zeroLocusSndFiberι m n R F y ≫ (snd m n R).fiberι y =
      (biprojectiveZeroLocusSnd m n R F).fiberι y ≫
        biprojectiveZeroLocusι m n R F :=
  Scheme.Hom.fiberCompToFiber_fiberι _ _ _

@[reassoc (attr := simp)]
theorem zeroLocusSndFiberι_toSpecResidueField (y : ProjectiveSpace n R) :
    zeroLocusSndFiberι m n R F y ≫
        (snd m n R).fiberToSpecResidueField y =
      (biprojectiveZeroLocusSnd m n R F).fiberToSpecResidueField y :=
  Scheme.Hom.fiberCompToFiber_fiberToSpecResidueField _ _ _

/-- The ideal cutting out a fiber of the second restricted projection inside the corresponding
ambient fiber. -/
def zeroLocusSndFiberIdeal (y : ProjectiveSpace n R) :
    ((snd m n R).fiber y).IdealSheafData :=
  (biprojectiveZeroLocusIdeal m n R F).comap ((snd m n R).fiberι y)

theorem ker_zeroLocusSndFiberι (y : ProjectiveSpace n R) :
    (zeroLocusSndFiberι m n R F y).ker =
      zeroLocusSndFiberIdeal m n R F y := by
  change (Scheme.Hom.fiberCompToFiber
      (biprojectiveZeroLocusι m n R F) (snd m n R) y).ker = _
  rw [Scheme.Hom.ker_fiberCompToFiber]
  exact congrArg (fun I ↦ I.comap ((snd m n R).fiberι y))
    (ker_biprojectiveZeroLocusι m n R F)

/-- A fiber of the second restricted projection is canonically the subscheme of the ambient
fiber defined by the pulled-back biprojective ideal. -/
def zeroLocusSndFiberIsoSubscheme (y : ProjectiveSpace n R) :
    (biprojectiveZeroLocusSnd m n R F).fiber y ≅
      (zeroLocusSndFiberIdeal m n R F y).subscheme :=
  (biprojectiveZeroLocusIdeal m n R F).fiberIsoComapSubscheme (snd m n R) y

@[reassoc]
theorem zeroLocusSndFiberIsoSubscheme_hom_subschemeι
    (y : ProjectiveSpace n R) :
    (zeroLocusSndFiberIsoSubscheme m n R F y).hom ≫
        (zeroLocusSndFiberIdeal m n R F y).subschemeι =
      zeroLocusSndFiberι m n R F y := by
  exact Scheme.IdealSheafData.fiberIsoComapSubscheme_hom_subschemeι _ _ _

/-- The analogous whole-fiber criterion for the second restricted projection. -/
theorem isIso_zeroLocusSndFiberι_iff (y : ProjectiveSpace n R) :
    IsIso (zeroLocusSndFiberι m n R F y) ↔
      zeroLocusSndFiberIdeal m n R F y = ⊥ := by
  rw [IsClosedImmersion.isIso_iff_ker_eq_bot, ker_zeroLocusSndFiberι]

/-! ## Transport to the residue-field base changes -/

private lemma ker_comp_iso_hom
    {Z X Y : Scheme.{u}} (j : Z ⟶ X) [IsClosedImmersion j] (e : X ≅ Y) :
    (j ≫ e.hom).ker = j.ker.comap e.inv := by
  have he : inv e.inv = e.hom := IsIso.inv_eq_of_hom_inv_id e.inv_hom_id
  rw [← he]
  rw [← pullback_inv_snd_fst_of_left_isIso e.inv j]
  rw [Scheme.Hom.ker_comp_of_isIso]
  exact Scheme.IdealSheafData.ker_fst_of_isClosedImmersion j e.inv

/-- The first restricted fiber embedded in the residue-field base change of the second
projective factor. -/
abbrev zeroLocusFstFiberToBaseChange (x : ProjectiveSpace m R) :
    (biprojectiveZeroLocusFst m n R F).fiber x ⟶ fstFiberBaseChange m n R x :=
  zeroLocusFstFiberι m n R F x ≫ (fstFiberIsoBaseChange m n R x).hom

instance (x : ProjectiveSpace m R) :
    IsClosedImmersion (zeroLocusFstFiberToBaseChange m n R F x) := by
  dsimp only [zeroLocusFstFiberToBaseChange]
  infer_instance

/-- The ideal cutting out the first restricted fiber on the residue-field base change of the
second projective factor. -/
def zeroLocusFstFiberIdealOnBaseChange (x : ProjectiveSpace m R) :
    (fstFiberBaseChange m n R x).IdealSheafData :=
  (biprojectiveZeroLocusIdeal m n R F).comap
    ((fstFiberIsoBaseChange m n R x).inv ≫ (fst m n R).fiberι x)

theorem ker_zeroLocusFstFiberToBaseChange (x : ProjectiveSpace m R) :
    (zeroLocusFstFiberToBaseChange m n R F x).ker =
      zeroLocusFstFiberIdealOnBaseChange m n R F x := by
  rw [ker_comp_iso_hom]
  rw [ker_zeroLocusFstFiberι]
  exact (Scheme.IdealSheafData.comap_comp
    (biprojectiveZeroLocusIdeal m n R F)
    (fstFiberIsoBaseChange m n R x).inv ((fst m n R).fiberι x)).symm

/-- The first restricted fiber fills its residue-field base-changed ambient projective space
exactly when its transported ideal is zero. -/
theorem isIso_zeroLocusFstFiberToBaseChange_iff (x : ProjectiveSpace m R) :
    IsIso (zeroLocusFstFiberToBaseChange m n R F x) ↔
      zeroLocusFstFiberIdealOnBaseChange m n R F x = ⊥ := by
  rw [IsClosedImmersion.isIso_iff_ker_eq_bot,
    ker_zeroLocusFstFiberToBaseChange]

/-- The first restricted fiber is canonically the subscheme cut out by its transported ideal on
the residue-field base change of the second projective factor. -/
def zeroLocusFstFiberIsoBaseChangeSubscheme (x : ProjectiveSpace m R) :
    (biprojectiveZeroLocusFst m n R F).fiber x ≅
      (zeroLocusFstFiberIdealOnBaseChange m n R F x).subscheme := by
  let j := zeroLocusFstFiberToBaseChange m n R F x
  let ι := (zeroLocusFstFiberIdealOnBaseChange m n R F x).subschemeι
  have hker : j.ker = ι.ker := by
    rw [ker_zeroLocusFstFiberToBaseChange,
      Scheme.IdealSheafData.ker_subschemeι]
  let f := IsClosedImmersion.lift ι j hker.symm.le
  letI : IsIso f := IsClosedImmersion.isIso_lift ι j hker.symm
  exact asIso f

@[reassoc]
theorem zeroLocusFstFiberIsoBaseChangeSubscheme_hom_subschemeι
    (x : ProjectiveSpace m R) :
    (zeroLocusFstFiberIsoBaseChangeSubscheme m n R F x).hom ≫
        (zeroLocusFstFiberIdealOnBaseChange m n R F x).subschemeι =
      zeroLocusFstFiberToBaseChange m n R F x := by
  change IsClosedImmersion.lift _ _ _ ≫ _ = _
  exact IsClosedImmersion.lift_fac _ _ _

/-- The second restricted fiber embedded in the residue-field base change of the first
projective factor. -/
abbrev zeroLocusSndFiberToBaseChange (y : ProjectiveSpace n R) :
    (biprojectiveZeroLocusSnd m n R F).fiber y ⟶ sndFiberBaseChange m n R y :=
  zeroLocusSndFiberι m n R F y ≫ (sndFiberIsoBaseChange m n R y).hom

instance (y : ProjectiveSpace n R) :
    IsClosedImmersion (zeroLocusSndFiberToBaseChange m n R F y) := by
  dsimp only [zeroLocusSndFiberToBaseChange]
  infer_instance

/-- The ideal cutting out the second restricted fiber on the residue-field base change of the
first projective factor. -/
def zeroLocusSndFiberIdealOnBaseChange (y : ProjectiveSpace n R) :
    (sndFiberBaseChange m n R y).IdealSheafData :=
  (biprojectiveZeroLocusIdeal m n R F).comap
    ((sndFiberIsoBaseChange m n R y).inv ≫ (snd m n R).fiberι y)

theorem ker_zeroLocusSndFiberToBaseChange (y : ProjectiveSpace n R) :
    (zeroLocusSndFiberToBaseChange m n R F y).ker =
      zeroLocusSndFiberIdealOnBaseChange m n R F y := by
  rw [ker_comp_iso_hom]
  rw [ker_zeroLocusSndFiberι]
  exact (Scheme.IdealSheafData.comap_comp
    (biprojectiveZeroLocusIdeal m n R F)
    (sndFiberIsoBaseChange m n R y).inv ((snd m n R).fiberι y)).symm

/-- The second restricted fiber fills its residue-field base-changed ambient projective space
exactly when its transported ideal is zero. -/
theorem isIso_zeroLocusSndFiberToBaseChange_iff (y : ProjectiveSpace n R) :
    IsIso (zeroLocusSndFiberToBaseChange m n R F y) ↔
      zeroLocusSndFiberIdealOnBaseChange m n R F y = ⊥ := by
  rw [IsClosedImmersion.isIso_iff_ker_eq_bot,
    ker_zeroLocusSndFiberToBaseChange]

/-- The second restricted fiber is canonically the subscheme cut out by its transported ideal on
the residue-field base change of the first projective factor. -/
def zeroLocusSndFiberIsoBaseChangeSubscheme (y : ProjectiveSpace n R) :
    (biprojectiveZeroLocusSnd m n R F).fiber y ≅
      (zeroLocusSndFiberIdealOnBaseChange m n R F y).subscheme := by
  let j := zeroLocusSndFiberToBaseChange m n R F y
  let ι := (zeroLocusSndFiberIdealOnBaseChange m n R F y).subschemeι
  have hker : j.ker = ι.ker := by
    rw [ker_zeroLocusSndFiberToBaseChange,
      Scheme.IdealSheafData.ker_subschemeι]
  let f := IsClosedImmersion.lift ι j hker.symm.le
  letI : IsIso f := IsClosedImmersion.isIso_lift ι j hker.symm
  exact asIso f

@[reassoc]
theorem zeroLocusSndFiberIsoBaseChangeSubscheme_hom_subschemeι
    (y : ProjectiveSpace n R) :
    (zeroLocusSndFiberIsoBaseChangeSubscheme m n R F y).hom ≫
        (zeroLocusSndFiberIdealOnBaseChange m n R F y).subschemeι =
      zeroLocusSndFiberToBaseChange m n R F y := by
  change IsClosedImmersion.lift _ _ _ ≫ _ = _
  exact IsClosedImmersion.lift_fac _ _ _

end BiprojectiveSpace

end

end BConicBundleMultisections
