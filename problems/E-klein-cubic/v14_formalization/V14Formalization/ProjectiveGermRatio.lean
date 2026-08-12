import V14Formalization.ProjectiveFunctionFieldAwayAction
import Mathlib.RingTheory.Localization.AtPrime.Basic

/-! Generic germ identities for ratios of homogeneous linear forms. -/

noncomputable section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

universe u
variable {Omega : Type u} [Field Omega]

theorem awayToSection_germ_linear_ratio_mul
    (n : ℕ)
    (f g : MvPolynomial (Fin (n + 1)) Omega)
    (hf : f ∈ MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega 1)
    (hg : g ∈ MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega 1)
    (x : ProjectiveSpectrum.top
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega))
    (hxf : x ∈ AlgebraicGeometry.Proj.basicOpen
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega) f)
    (hx0 : x ∈ AlgebraicGeometry.Proj.basicOpen
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega)
      (MvPolynomial.X (0 : Fin (n + 1)))) :
    let A := MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega
    (ProjectiveSpectrum.Proj.structureSheaf A).presheaf.germ
        (AlgebraicGeometry.Proj.basicOpen A f) x hxf
        ((AlgebraicGeometry.Proj.awayToSection A f)
          (HomogeneousLocalization.Away.mk A hf 1 g (by
            change g ∈ MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega 1
            exact hg))) *
      (ProjectiveSpectrum.Proj.structureSheaf A).presheaf.germ
        (AlgebraicGeometry.Proj.basicOpen A
          (MvPolynomial.X (0 : Fin (n + 1)))) x hx0
        ((AlgebraicGeometry.Proj.awayToSection A
          (MvPolynomial.X (0 : Fin (n + 1))))
          (HomogeneousLocalization.Away.mk A
            (MvPolynomial.isHomogeneous_X Omega (0 : Fin (n + 1)))
            1 f (by
              change f ∈ MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega 1
              exact hf))) =
      (ProjectiveSpectrum.Proj.structureSheaf A).presheaf.germ
        (AlgebraicGeometry.Proj.basicOpen A
          (MvPolynomial.X (0 : Fin (n + 1)))) x hx0
        ((AlgebraicGeometry.Proj.awayToSection A
          (MvPolynomial.X (0 : Fin (n + 1))))
          (HomogeneousLocalization.Away.mk A
            (MvPolynomial.isHomogeneous_X Omega (0 : Fin (n + 1)))
            1 g (by
              change g ∈ MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega 1
              exact hg))) := by
  dsimp only
  let A := MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega
  let zGF := HomogeneousLocalization.Away.mk A hf 1 g (by
    change g ∈ MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega 1
    exact hg)
  let zF0 := HomogeneousLocalization.Away.mk A
    (MvPolynomial.isHomogeneous_X Omega (0 : Fin (n + 1)))
    1 f (by
      change f ∈ MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega 1
      exact hf)
  let zG0 := HomogeneousLocalization.Away.mk A
    (MvPolynomial.isHomogeneous_X Omega (0 : Fin (n + 1)))
    1 g (by
      change g ∈ MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega 1
      exact hg)
  change
    ((AlgebraicGeometry.Proj.awayToSection A f ≫
      (ProjectiveSpectrum.Proj.structureSheaf A).presheaf.germ
        (AlgebraicGeometry.Proj.basicOpen A f) x hxf).hom zGF) *
      ((AlgebraicGeometry.Proj.awayToSection A
          (MvPolynomial.X (0 : Fin (n + 1))) ≫
        (ProjectiveSpectrum.Proj.structureSheaf A).presheaf.germ
          (AlgebraicGeometry.Proj.basicOpen A
            (MvPolynomial.X (0 : Fin (n + 1)))) x hx0).hom zF0) =
      ((AlgebraicGeometry.Proj.awayToSection A
          (MvPolynomial.X (0 : Fin (n + 1))) ≫
        (ProjectiveSpectrum.Proj.structureSheaf A).presheaf.germ
          (AlgebraicGeometry.Proj.basicOpen A
            (MvPolynomial.X (0 : Fin (n + 1)))) x hx0).hom zG0)
  erw [ProjectiveSpectrum.Proj.awayToSection_germ A f x hxf,
    ProjectiveSpectrum.Proj.awayToSection_germ A
      (MvPolynomial.X (0 : Fin (n + 1))) x hx0]
  change
    (AlgebraicGeometry.Proj.stalkIso'
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega) x).symm
        (HomogeneousLocalization.mapId A
          (Submonoid.powers_le.mpr hxf) zGF) *
      (AlgebraicGeometry.Proj.stalkIso'
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega) x).symm
        (HomogeneousLocalization.mapId A
          (Submonoid.powers_le.mpr hx0) zF0) =
      (AlgebraicGeometry.Proj.stalkIso'
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega) x).symm
        (HomogeneousLocalization.mapId A
          (Submonoid.powers_le.mpr hx0) zG0)
  rw [← map_mul]
  apply congrArg (AlgebraicGeometry.Proj.stalkIso'
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega) x).symm
  apply HomogeneousLocalization.val_injective
  rw [HomogeneousLocalization.val_mul]
  unfold zGF zF0 zG0 HomogeneousLocalization.Away.mk
  simp only [HomogeneousLocalization.map_mk]
  simp only [HomogeneousLocalization.val_mk, GradedRingHom.id_apply, pow_one]
  rw [Localization.mk_mul]
  rw [Localization.mk_eq_mk'_apply, Localization.mk_eq_mk'_apply]
  let sf : x.asHomogeneousIdeal.toIdeal.primeCompl := ⟨f, hxf⟩
  let sx0 : x.asHomogeneousIdeal.toIdeal.primeCompl :=
    ⟨MvPolynomial.X (0 : Fin (n + 1)), hx0⟩
  have hcancel := IsLocalization.mk'_cancel
    (S := Localization x.asHomogeneousIdeal.toIdeal.primeCompl) g sx0 sf
  change IsLocalization.mk'
      (Localization x.asHomogeneousIdeal.toIdeal.primeCompl)
      (g * f) (sf * sx0) =
    IsLocalization.mk'
      (Localization x.asHomogeneousIdeal.toIdeal.primeCompl) g sx0
  rw [mul_comm sf sx0]
  exact hcancel

theorem awayToSection_germ_standard_linear_ratio_isUnit
    (n : ℕ)
    (f : MvPolynomial (Fin (n + 1)) Omega)
    (hf : f ∈ MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega 1)
    (x : ProjectiveSpectrum.top
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega))
    (hxf : x ∈ AlgebraicGeometry.Proj.basicOpen
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega) f)
    (hx0 : x ∈ AlgebraicGeometry.Proj.basicOpen
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega)
      (MvPolynomial.X (0 : Fin (n + 1)))) :
    let A := MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega
    IsUnit ((ProjectiveSpectrum.Proj.structureSheaf A).presheaf.germ
      (AlgebraicGeometry.Proj.basicOpen A
        (MvPolynomial.X (0 : Fin (n + 1)))) x hx0
      ((AlgebraicGeometry.Proj.awayToSection A
        (MvPolynomial.X (0 : Fin (n + 1))))
        (HomogeneousLocalization.Away.mk A
          (MvPolynomial.isHomogeneous_X Omega (0 : Fin (n + 1)))
          1 f (by
            change f ∈ MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega 1
            exact hf)))) := by
  dsimp only
  let A := MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega
  let z := HomogeneousLocalization.Away.mk A
    (MvPolynomial.isHomogeneous_X Omega (0 : Fin (n + 1)))
    1 f (by
      change f ∈ MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega 1
      exact hf)
  have hz := congrArg (fun q => q.hom z)
    (ProjectiveSpectrum.Proj.awayToSection_germ A
      (MvPolynomial.X (0 : Fin (n + 1))) x hx0)
  have hmapVal : IsUnit
      (HomogeneousLocalization.mapId A
        (Q := x.asHomogeneousIdeal.toIdeal.primeCompl)
        (Submonoid.powers_le.mpr hx0) z).val := by
    unfold z HomogeneousLocalization.Away.mk
    rw [HomogeneousLocalization.map_mk, HomogeneousLocalization.val_mk,
      Localization.mk_eq_mk'_apply,
      IsLocalization.AtPrime.isUnit_mk'_iff]
    simp only [GradedRingHom.id_apply]
    change f ∉ x.asHomogeneousIdeal
    exact hxf
  have hmap : IsUnit (HomogeneousLocalization.mapId A
      (Q := x.asHomogeneousIdeal.toIdeal.primeCompl)
      (Submonoid.powers_le.mpr hx0) z) :=
    (HomogeneousLocalization.isUnit_iff_isUnit_val A
      x.asHomogeneousIdeal.toIdeal _).mp hmapVal
  have hinv := hmap.map
    (AlgebraicGeometry.Proj.stalkIso' A x).symm.toRingHom
  have hz' :
      (ProjectiveSpectrum.Proj.structureSheaf A).presheaf.germ
          (AlgebraicGeometry.Proj.basicOpen A
            (MvPolynomial.X (0 : Fin (n + 1)))) x hx0
          ((AlgebraicGeometry.Proj.awayToSection A
            (MvPolynomial.X (0 : Fin (n + 1)))) z) =
        (AlgebraicGeometry.Proj.stalkIso' A x).symm
          (HomogeneousLocalization.mapId A
            (Q := x.asHomogeneousIdeal.toIdeal.primeCompl)
            (Submonoid.powers_le.mpr hx0) z) := by
    change ((AlgebraicGeometry.Proj.awayToSection A
        (MvPolynomial.X (0 : Fin (n + 1))) ≫
      (ProjectiveSpectrum.Proj.structureSheaf A).presheaf.germ
        (AlgebraicGeometry.Proj.basicOpen A
          (MvPolynomial.X (0 : Fin (n + 1)))) x hx0).hom z) = _
    erw [ProjectiveSpectrum.Proj.awayToSection_germ A
      (MvPolynomial.X (0 : Fin (n + 1))) x hx0]
    rfl
  rw [hz']
  exact hinv

end V14Formalization.SchemeGeometry
