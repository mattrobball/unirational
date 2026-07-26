/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PointedConicAffineModel
public import BConicBundleMultisections.Unirationality

/-!
# The integral stereographic open of a pointed conic

The whole affine conic need not be known integral in order to use stereographic projection.
The explicit stereographic chart is already isomorphic to

`Spec (A[z] localized at Q(z)L(z))`,

and is therefore integral over a domain `A` as soon as the two slope polynomials are nonzero.
This file packages the line-chart side as a relatively unirational scheme.  It is the small
consumer-facing replacement for the stronger assertion that the entire base-changed conic bundle
is integral and birational to an affine line.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections.PointedConic

noncomputable section

universe u

open AlgebraicGeometry

variable {A : Type u} [CommRing A]

/-- The stereographic line chart as an affine scheme. -/
abbrev lineChartScheme (a b c d e : A) : Scheme.{u} :=
  Spec (CommRingCat.of (lineChart a b c d e))

/-- The structure morphism of the stereographic line chart. -/
def lineChartSchemeToSpec (a b c d e : A) :
    lineChartScheme a b c d e ⟶ Spec (CommRingCat.of A) :=
  Spec.map (CommRingCat.ofHom (lineC a b c d e))

/-- The localization open of the affine line on which the stereographic formula is defined. -/
def lineChartSchemeToLineScheme (a b c d e : A) :
    lineChartScheme a b c d e ⟶ Spec (CommRingCat.of (Polynomial A)) :=
  Spec.map (CommRingCat.ofHom
    (algebraMap (Polynomial A) (lineChart a b c d e)))

instance lineChartSchemeToLineScheme_isOpenImmersion (a b c d e : A) :
    IsOpenImmersion (lineChartSchemeToLineScheme a b c d e) := by
  dsimp only [lineChartSchemeToLineScheme]
  infer_instance

/-- The localization open lies over `Spec A`. -/
@[reassoc]
theorem lineChartSchemeToLineScheme_over (a b c d e : A) :
    lineChartSchemeToLineScheme a b c d e ≫ lineSchemeToSpec (A := A) =
      lineChartSchemeToSpec a b c d e := by
  rw [lineChartSchemeToLineScheme, lineSchemeToSpec, lineChartSchemeToSpec,
    ← Spec.map_comp, ← CommRingCat.ofHom_comp]
  rfl

/-- The line-chart ring is a domain when `A` is a domain and the two slope polynomials are
nonzero.  This conclusion does not mention the affine conic ring. -/
theorem isDomain_lineChart [IsDomain A] (a b c d e : A)
    (hQ : slopeQuad a b c ≠ 0) (hL : slopeLin d e ≠ 0) :
    IsDomain (lineChart a b c d e) :=
  IsLocalization.isDomain_localization
    (powers_le_nonZeroDivisors_of_noZeroDivisors (mul_ne_zero hQ hL))

/-- The stereographic localization is a dense open of the affine line. -/
theorem lineChartSchemeToLineScheme_isDominant [IsDomain A] (a b c d e : A)
    (hQ : slopeQuad a b c ≠ 0) (hL : slopeLin d e ≠ 0) :
    IsDominant (lineChartSchemeToLineScheme a b c d e) := by
  letI : IsDomain (lineChart a b c d e) := isDomain_lineChart a b c d e hQ hL
  letI : Nonempty (lineChartScheme a b c d e) :=
    PrimeSpectrum.nonempty_iff_nontrivial.mpr inferInstance
  refine ⟨?_⟩
  exact ((Scheme.Hom.isOpenEmbedding
    (lineChartSchemeToLineScheme a b c d e)).isOpen_range).dense (Set.range_nonempty _)

/-- The stereographic line chart dominates its coefficient base. -/
theorem lineChartSchemeToSpec_isDominant [IsDomain A] (a b c d e : A)
    (hQ : slopeQuad a b c ≠ 0) (hL : slopeLin d e ≠ 0) :
    IsDominant (lineChartSchemeToSpec a b c d e) := by
  have hloc : Function.Injective
      (algebraMap (Polynomial A) (lineChart a b c d e)) :=
    IsLocalization.injective _
      (powers_le_nonZeroDivisors_of_noZeroDivisors (mul_ne_zero hQ hL))
  have hinj : Function.Injective (lineC a b c d e) := by
    exact hloc.comp Polynomial.C_injective
  rw [lineChartSchemeToSpec, isDominant_iff]
  refine (PrimeSpectrum.denseRange_comap_iff_ker_le_nilRadical
    (lineC a b c d e)).mpr ?_
  intro x hx
  have hx0 : x = 0 := hinj (by simpa [RingHom.mem_ker] using hx)
  simp [hx0]

/-- The integral stereographic open itself has a relative one-dimensional unirational
parametrization.  No integrality hypothesis on `conicRing a b c d e` is needed. -/
theorem hasUnirationalParametrization_lineChart [IsDomain A] (a b c d e : A)
    (hQ : slopeQuad a b c ≠ 0) (hL : slopeLin d e ≠ 0) :
    HasUnirationalParametrization 1 (lineChartSchemeToSpec a b c d e) := by
  letI : IsDomain (lineChart a b c d e) := isDomain_lineChart a b c d e hQ hL
  letI : IsDominant (lineChartSchemeToLineScheme a b c d e) :=
    lineChartSchemeToLineScheme_isDominant a b c d e hQ hL
  let hline : Scheme.BirationalOver
      (lineChartSchemeToSpec a b c d e) (lineSchemeToSpec (A := A)) :=
    Scheme.Hom.birationalOver (lineChartSchemeToLineScheme a b c d e)
      (lineSchemeToSpec (A := A)) (lineChartSchemeToSpec a b c d e)
      (lineChartSchemeToLineScheme_over a b c d e)
  let haff : Scheme.BirationalOver (lineSchemeToSpec (A := A))
      (𝔸(ULift.{u} (Fin 1); Spec (CommRingCat.of A)) ↘ Spec (CommRingCat.of A)) :=
    Scheme.Hom.birationalOver (lineSchemeIsoAffineSpace (A := A)).hom _ _
      (lineSchemeIsoAffineSpace_hom_over (A := A))
  exact ⟨UnirationalParametrization.ofBirationalOverAffine (hline.trans haff)⟩

/-! ### Mapping the integral open into the conic chart -/

/-- The stereographic line chart maps isomorphically to the explicit localization open in the
pointed affine conic. -/
def lineChartSchemeToConicScheme (a b c d e : A) :
    lineChartScheme a b c d e ⟶ conicScheme a b c d e :=
  (specLineChartIso a b c d e).inv ≫
    Spec.map (CommRingCat.ofHom
      (algebraMap (conicRing a b c d e) (conicChart a b c d e)))

instance lineChartSchemeToConicScheme_isOpenImmersion (a b c d e : A) :
    IsOpenImmersion (lineChartSchemeToConicScheme a b c d e) := by
  dsimp only [lineChartSchemeToConicScheme]
  infer_instance

/-- The stereographic open maps to the pointed affine conic over `Spec A`. -/
@[reassoc]
theorem lineChartSchemeToConicScheme_over (a b c d e : A) :
    lineChartSchemeToConicScheme a b c d e ≫ conicSchemeToSpec a b c d e =
      lineChartSchemeToSpec a b c d e := by
  rw [lineChartSchemeToConicScheme, conicSchemeToSpec, lineChartSchemeToSpec,
    Category.assoc, specLineChartIso]
  simp only [← Spec.map_comp, lineChartIsoConicChart, ← CommRingCat.ofHom_comp]
  apply congrArg Spec.map
  apply congrArg CommRingCat.ofHom
  apply RingHom.ext
  intro r
  change conicToLine a b c d e (conicC a b c d e r) = lineC a b c d e r
  exact conicToLine_conicC a b c d e r

/-- After translating an arbitrary marked affine conic to the origin, the same integral
stereographic open maps into the original affine conic. -/
def lineChartSchemeToAffineConicScheme
    (alpha beta gamma delta epsilon zeta p₁ p₂ : A)
    (hp : MvPolynomial.eval ![p₁, p₂]
      (affineConicPoly alpha beta gamma delta epsilon zeta) = 0) :
    lineChartScheme alpha beta gamma
        (2 * alpha * p₁ + beta * p₂ + delta)
        (beta * p₁ + 2 * gamma * p₂ + epsilon) ⟶
      affineConicScheme alpha beta gamma delta epsilon zeta :=
  lineChartSchemeToConicScheme alpha beta gamma
      (2 * alpha * p₁ + beta * p₂ + delta)
      (beta * p₁ + 2 * gamma * p₂ + epsilon) ≫
    (affineConicSchemeIso alpha beta gamma delta epsilon zeta p₁ p₂ hp).hom

instance lineChartSchemeToAffineConicScheme_isOpenImmersion
    (alpha beta gamma delta epsilon zeta p₁ p₂ : A)
    (hp : MvPolynomial.eval ![p₁, p₂]
      (affineConicPoly alpha beta gamma delta epsilon zeta) = 0) :
    IsOpenImmersion
      (lineChartSchemeToAffineConicScheme
        alpha beta gamma delta epsilon zeta p₁ p₂ hp) := by
  dsimp only [lineChartSchemeToAffineConicScheme]
  infer_instance

/-- The translated stereographic open still lies over `Spec A`. -/
@[reassoc]
theorem lineChartSchemeToAffineConicScheme_over
    (alpha beta gamma delta epsilon zeta p₁ p₂ : A)
    (hp : MvPolynomial.eval ![p₁, p₂]
      (affineConicPoly alpha beta gamma delta epsilon zeta) = 0) :
    lineChartSchemeToAffineConicScheme
        alpha beta gamma delta epsilon zeta p₁ p₂ hp ≫
        affineConicSchemeToSpec alpha beta gamma delta epsilon zeta =
      lineChartSchemeToSpec alpha beta gamma
        (2 * alpha * p₁ + beta * p₂ + delta)
        (beta * p₁ + 2 * gamma * p₂ + epsilon) := by
  rw [lineChartSchemeToAffineConicScheme, Category.assoc,
    affineConicSchemeIso_hom_over,
    lineChartSchemeToConicScheme_over]

end

end BConicBundleMultisections.PointedConic
