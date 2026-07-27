/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.HesseTangentResidualCertificate
public import BConicBundleMultisections.ProjectiveHypersurfacePoints

/-!
# Point-level projective tangent-residual map on a Hesse cubic

The quartics in `HesseTangentResidualCertificate` are homogeneous of degree four and have no
common zero on a smooth Hesse cubic.  This file therefore packages them as an everywhere-defined
map on the point-level projective Hesse curve.

This is deliberately a map of projective point sets, not yet a morphism of schemes.  The latter
requires gluing the homogeneous-coordinate formulas on the Hesse closed subscheme (the quartics
have base points in the ambient projective plane, although none lies on the smooth Hesse cubic).
-/

@[expose] public section

open MvPolynomial
open scoped LinearAlgebra.Projectivization

namespace BConicBundleMultisections.HesseTangentResidualProjectiveMap

noncomputable section

universe u

open HesseTangentResidualCertificate

variable {R : Type u} [CommRing R]

/-- The Hesse tangent-residual quartic triple scales with degree four. -/
theorem hesseTangentResidualRep_smul (a : R) (p : Fin 3 -> R) :
    hesseTangentResidualRep (a • p) = a ^ 4 • hesseTangentResidualRep p := by
  funext i
  fin_cases i <;> simp [hesseTangentResidualRep, Pi.smul_apply, smul_eq_mul] <;> ring

section Field

variable {K : Type u} [Field K] [CharZero K]

/-- Point-level projective points of the Hesse cubic. -/
abbrev HessePoint (lam : K) :=
  {P : ℙ K (Fin 3 -> K) //
    P ∈ projectiveHypersurfacePoints (HesseNormalForm.hesseCubic_isHomogeneous lam)}

/-- The quartic tangent-residual formula as an everywhere-defined map on projective Hesse points.

The chosen representative `P.rep` is harmless: `hesseTangentResidualRep_smul` shows that changing
representative only rescales the output by a fourth power. -/
noncomputable def hesseTangentResidualMap (lam : K) (hlam : lam ^ 3 ≠ 1) :
    HessePoint lam -> HessePoint lam := fun P => by
  let p := P.1.rep
  have hp0 : p ≠ 0 := P.1.rep_nonzero
  have hp : eval p (HesseNormalForm.hesseCubic lam) = 0 := by
    have hmem := P.2
    rw [← P.1.mk_rep] at hmem
    exact (mk_mem_projectiveHypersurfacePoints_iff
      (HesseNormalForm.hesseCubic_isHomogeneous lam) p hp0).mp hmem
  have hA : hesseTangentResidualRep p ≠ 0 :=
    hesseTangentResidualRep_ne_zero_of_hesseCubic lam p hlam hp0 hp
  refine ⟨Projectivization.mk K (hesseTangentResidualRep p) hA, ?_⟩
  rw [mk_mem_projectiveHypersurfacePoints_iff]
  rw [eval_hesseCubic_hesseTangentResidualRep, hp, mul_zero]

/-- On a supplied nonzero representative, the projective map is represented by the explicit
quartic triple. -/
theorem hesseTangentResidualMap_mk
    (lam : K) (hlam : lam ^ 3 ≠ 1) (p : Fin 3 -> K) (hp0 : p ≠ 0)
    (hp : eval p (HesseNormalForm.hesseCubic lam) = 0) :
    (hesseTangentResidualMap lam hlam
      ⟨Projectivization.mk K p hp0,
        (mk_mem_projectiveHypersurfacePoints_iff
          (HesseNormalForm.hesseCubic_isHomogeneous lam) p hp0).2 hp⟩).1 =
      Projectivization.mk K (hesseTangentResidualRep p)
        (hesseTangentResidualRep_ne_zero_of_hesseCubic lam p hlam hp0 hp) := by
  change Projectivization.mk K
      (hesseTangentResidualRep (Projectivization.mk K p hp0).rep) _ = _
  obtain ⟨a, ha⟩ :=
    Projectivization.exists_smul_eq_mk_rep (K := K) (V := Fin 3 -> K) p hp0
  have hscale :
      hesseTangentResidualRep (Projectivization.mk K p hp0).rep =
        (a : K) ^ 4 • hesseTangentResidualRep p := by
    rw [← ha]
    exact hesseTangentResidualRep_smul (a : K) p
  apply (Projectivization.mk_eq_mk_iff K _ _ _ _).2
  refine ⟨a ^ 4, ?_⟩
  simpa only [Units.smul_def, Units.val_pow_eq_pow_val] using hscale.symm

/-! ### A concrete nonconstancy witness -/

/-- First standard Hesse flex representative. -/
def flexUVRep : Fin 3 -> K := ![1, -1, 0]

/-- Second standard Hesse flex representative. -/
def flexUWRep : Fin 3 -> K := ![1, 0, -1]

theorem flexUVRep_ne_zero : (flexUVRep : Fin 3 -> K) ≠ 0 := by
  intro h
  have := congrFun h (0 : Fin 3)
  simp [flexUVRep] at this

theorem flexUWRep_ne_zero : (flexUWRep : Fin 3 -> K) ≠ 0 := by
  intro h
  have := congrFun h (0 : Fin 3)
  simp [flexUWRep] at this

@[simp]
theorem eval_hesseCubic_flexUVRep (lam : K) :
    eval (flexUVRep : Fin 3 -> K) (HesseNormalForm.hesseCubic lam) = 0 := by
  simp [HesseNormalForm.eval_hesseCubic, flexUVRep]
  ring

@[simp]
theorem eval_hesseCubic_flexUWRep (lam : K) :
    eval (flexUWRep : Fin 3 -> K) (HesseNormalForm.hesseCubic lam) = 0 := by
  simp [HesseNormalForm.eval_hesseCubic, flexUWRep]
  ring

/-- The first standard flex as a point of every Hesse cubic. -/
def flexUV (lam : K) : HessePoint lam :=
  ⟨Projectivization.mk K flexUVRep flexUVRep_ne_zero,
    (mk_mem_projectiveHypersurfacePoints_iff
      (HesseNormalForm.hesseCubic_isHomogeneous lam) flexUVRep flexUVRep_ne_zero).2
        (eval_hesseCubic_flexUVRep lam)⟩

/-- The second standard flex as a point of every Hesse cubic. -/
def flexUW (lam : K) : HessePoint lam :=
  ⟨Projectivization.mk K flexUWRep flexUWRep_ne_zero,
    (mk_mem_projectiveHypersurfacePoints_iff
      (HesseNormalForm.hesseCubic_isHomogeneous lam) flexUWRep flexUWRep_ne_zero).2
        (eval_hesseCubic_flexUWRep lam)⟩

theorem flexUV_ne_flexUW (lam : K) : flexUV lam ≠ flexUW lam := by
  intro h
  have hproj : Projectivization.mk K flexUVRep flexUVRep_ne_zero =
      Projectivization.mk K flexUWRep flexUWRep_ne_zero := congrArg Subtype.val h
  obtain ⟨a, ha⟩ := (Projectivization.mk_eq_mk_iff' K _ _ _ _).mp hproj
  have hcoord := congrFun ha (1 : Fin 3)
  simp [flexUVRep, flexUWRep, Pi.smul_apply, smul_eq_mul] at hcoord

theorem hesseTangentResidualMap_flexUV
    (lam : K) (hlam : lam ^ 3 ≠ 1) :
    hesseTangentResidualMap lam hlam (flexUV lam) = flexUV lam := by
  apply Subtype.ext
  change (hesseTangentResidualMap lam hlam
      ⟨Projectivization.mk K flexUVRep flexUVRep_ne_zero, _⟩).1 =
    Projectivization.mk K flexUVRep flexUVRep_ne_zero
  rw [hesseTangentResidualMap_mk lam hlam flexUVRep flexUVRep_ne_zero
    (eval_hesseCubic_flexUVRep lam)]
  have hA : hesseTangentResidualRep (flexUVRep : Fin 3 -> K) = ![-1, 1, 0] := by
    simpa only [flexUVRep] using
      (hesseTangentResidualRep_standard_flexes (R := K)).1
  apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).2
  refine ⟨-1, ?_⟩
  rw [hA]
  funext i
  fin_cases i <;> simp [flexUVRep, Pi.smul_apply, smul_eq_mul]

theorem hesseTangentResidualMap_flexUW
    (lam : K) (hlam : lam ^ 3 ≠ 1) :
    hesseTangentResidualMap lam hlam (flexUW lam) = flexUW lam := by
  apply Subtype.ext
  change (hesseTangentResidualMap lam hlam
      ⟨Projectivization.mk K flexUWRep flexUWRep_ne_zero, _⟩).1 =
    Projectivization.mk K flexUWRep flexUWRep_ne_zero
  rw [hesseTangentResidualMap_mk lam hlam flexUWRep flexUWRep_ne_zero
    (eval_hesseCubic_flexUWRep lam)]
  have hA : hesseTangentResidualRep (flexUWRep : Fin 3 -> K) = ![1, 0, -1] := by
    simpa only [flexUWRep] using
      (hesseTangentResidualRep_standard_flexes (R := K)).2
  apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).2
  refine ⟨1, ?_⟩
  rw [hA]
  funext i
  fin_cases i <;> simp [flexUWRep, Pi.smul_apply, smul_eq_mul]

/-- The projective Hesse tangent-residual point map is nonconstant, witnessed by two distinct
fixed flexes. -/
theorem exists_ne_image_ne_hesseTangentResidualMap
    (lam : K) (hlam : lam ^ 3 ≠ 1) :
    ∃ P Q : HessePoint lam,
      hesseTangentResidualMap lam hlam P ≠ hesseTangentResidualMap lam hlam Q := by
  refine ⟨flexUV lam, flexUW lam, ?_⟩
  rw [hesseTangentResidualMap_flexUV, hesseTangentResidualMap_flexUW]
  exact flexUV_ne_flexUW lam

end Field

end

end BConicBundleMultisections.HesseTangentResidualProjectiveMap
