/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveFiberNonempty
public import BConicBundleMultisections.BiprojectiveNoWholeFiber
public import BConicBundleMultisections.BiprojectiveZeroLocus
public import BConicBundleMultisections.GoodLineConic
public import BConicBundleMultisections.GoodLineExistence
public import BConicBundleMultisections.MultisectionPrinciple
public import BConicBundleMultisections.ResidualDivisor
public import BConicBundleMultisections.ResidualImage
public import BConicBundleMultisections.ResidualBaseChangeUnirational
public import BConicBundleMultisections.ResidualComponentAssembly
public import BConicBundleMultisections.ResidualComponentOnAssembly
public import BConicBundleMultisections.ResidualMultisectionDominant
public import BConicBundleMultisections.MainTheoremTargetReduction
public import BConicBundleMultisections.Unirationality
public import BConicBundleMultisections.UniversalResidualIdentity
public import BConicBundleMultisections.VerticalSurface

/-!
# Main theorem: unirationality of smooth bidegree `(2,3)` threefolds

States and reduces the all-smooth tangent-residual unirationality theorem from
`certificates/all_smooth_tangent_residual_theorem.md`.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry BiprojectiveSpace

/-- The biprojective zero locus of a bidegree-`(2,3)` equation. -/
abbrev Bidegree23ZeroLocus (k : Type u) [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Scheme :=
  biprojectiveZeroLocus 2 2 k F

/-- Structure morphism of a bidegree-`(2,3)` zero locus to the base. -/
abbrev Bidegree23ZeroLocus.toSpec (k : Type u) [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    Bidegree23ZeroLocus k F ⟶ Spec (.of k) :=
  biprojectiveZeroLocusToSpec 2 2 k F

/-- Second projection of a bidegree-`(2,3)` zero locus (conic fibration). -/
abbrev Bidegree23ZeroLocus.snd (k : Type u) [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    Bidegree23ZeroLocus k F ⟶ ProjectiveSpace 2 k :=
  biprojectiveZeroLocusSnd 2 2 k F

/-- First projection of a bidegree-`(2,3)` zero locus (cubic fibration). -/
abbrev Bidegree23ZeroLocus.fst (k : Type u) [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    Bidegree23ZeroLocus k F ⟶ ProjectiveSpace 2 k :=
  biprojectiveZeroLocusFst 2 2 k F

/-- Residual divisor equation of a bidegree-`(2,3)` hypersurface. -/
abbrev residualDivisorEquation
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial (BiprojectiveCoordinate 2 2) k :=
  ResidualDivisor.residualEquation F

/-- Residual image multisection of the conic projection of a bidegree-`(2,3)` zero locus.

This is the regular multisection cut out by `F` together with its residual divisor equation on
the coordinate line `Y₂ = 0`.  The main unirationality theorem further requires a good line
(horizontality / nonconstant residual line), rationality of a normalization, flatness of the
conic fibration, and pointed-conic rationality of the base change.
-/
abbrev residualMultisection_bidegree23
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    Multisection (Bidegree23ZeroLocus.snd k F) :=
  residualMultisection F

/--
**Reduction of the main theorem to the multisection principle (dominance form).**

If a multisection of the conic projection has dominant base-change projection `X_T → X` and the
base change admits a unirational parametrization of dimension 3, then so does `X`.

This is pure composition: flatness/horizontality are used only to *produce* dominance of
`baseChangeFst` (via `IsSchemeTheoreticallyDominant.pullbackFst`), and may be replaced by any other
proof of that dominance.
-/
theorem smooth_bidegree23_hasUnirationalParametrization_of_multisection_dominant
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (_hF : IsBidegree23 F) (_hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (m : Multisection (Bidegree23ZeroLocus.snd k F))
    [IsDominant m.baseChangeFst]
    (h : HasUnirationalParametrization 3
      (m.baseChangeFst ≫ Bidegree23ZeroLocus.toSpec k F)) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) :=
  m.hasUnirationalParametrization_of_baseChange (Bidegree23ZeroLocus.toSpec k F) h

/--
**Reduction via the flat / scheme-theoretic-horizontal package.**

Specializes the dominance form when `π` is flat and the multisection is scheme-theoretically
horizontal, so `baseChangeFst` is automatically dominant.
-/
theorem smooth_bidegree23_hasUnirationalParametrization_of_multisection
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (m : Multisection (Bidegree23ZeroLocus.snd k F))
    [Flat (Bidegree23ZeroLocus.snd k F)]
    [m.IsSchemeTheoreticallyHorizontal]
    (h : HasUnirationalParametrization 3
      (m.baseChangeFst ≫ Bidegree23ZeroLocus.toSpec k F)) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) :=
  smooth_bidegree23_hasUnirationalParametrization_of_multisection_dominant
    k F hF hF0 m h

/--
Specialization of the multisection reduction to the residual multisection cut out by the residual
divisor equation.  Closing the main theorem still requires horizontality, unirationality of the
base change of dimension 3 (pointed conics + rationality of the residual image), and flatness of
the conic projection (or an independent proof that `baseChangeFst` is dominant).
-/
theorem smooth_bidegree23_hasUnirationalParametrization_of_residualMultisection
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    [Flat (Bidegree23ZeroLocus.snd k F)]
    [(residualMultisection_bidegree23 F).IsSchemeTheoreticallyHorizontal]
    (h : HasUnirationalParametrization 3
      ((residualMultisection_bidegree23 F).baseChangeFst ≫
        Bidegree23ZeroLocus.toSpec k F)) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) :=
  smooth_bidegree23_hasUnirationalParametrization_of_multisection
    k F hF hF0 (residualMultisection_bidegree23 F) h

/-- Residual form of the dominance-only multisection reduction.

Dominance of `baseChangeFst` is supplied by
`isDominant_residualMultisection_baseChangeFst_of_smooth_bidegree23` (surjective residual base
map, stable under pullback).  The remaining geometric input is a 3-dimensional unirational
parametrization of the residual base change.
-/
theorem smooth_bidegree23_hasUnirationalParametrization_of_residualMultisection_dominant
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    [IsDominant (residualMultisection_bidegree23 F).baseChangeFst]
    (h : HasUnirationalParametrization 3
      ((residualMultisection_bidegree23 F).baseChangeFst ≫
        Bidegree23ZeroLocus.toSpec k F)) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) :=
  smooth_bidegree23_hasUnirationalParametrization_of_multisection_dominant
    k F hF hF0 (residualMultisection_bidegree23 F) h

/-- On a smooth nonzero bidegree-`(2,3)` threefold the residual multisection base-change projection
is dominant (hence the residual multisection reduction applies once a 3-dimensional
parametrization of the base change is available). -/
theorem isDominant_residualMultisection_bidegree23_baseChangeFst
    (k : Type u) [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    IsDominant (residualMultisection_bidegree23 F).baseChangeFst :=
  isDominant_residualMultisection_baseChangeFst_of_smooth_bidegree23 k F hF hF0

/-- Residual multisection base map is scheme-theoretically horizontal for smooth nonzero
bidegree-`(2,3)` threefolds. -/
theorem residualMultisection_bidegree23_isSchemeTheoreticallyHorizontal
    (k : Type u) [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    (residualMultisection_bidegree23 F).IsSchemeTheoreticallyHorizontal :=
  residualMultisection_isSchemeTheoreticallyHorizontal_of_smooth_bidegree23 k F hF hF0

/-- The residual multisection base map is quasi-compact (closed immersion into a proper
projection). -/
theorem residualMultisection_bidegree23_toBase_quasiCompact
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    QuasiCompact (residualMultisection_bidegree23 F).toBase :=
  inferInstance

/-- Dominance form specialized with residual base-change dominance proved for smooth bidegree
`(2,3)`.  Remaining input: unirationality of the residual base change in dimension 3. -/
theorem smooth_bidegree23_hasUnirationalParametrization_of_residualBaseChange
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (h : HasUnirationalParametrization 3
      ((residualMultisection_bidegree23 F).baseChangeFst ≫
        Bidegree23ZeroLocus.toSpec k F)) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) := by
  haveI : IsDominant (residualMultisection_bidegree23 F).baseChangeFst :=
    isDominant_residualMultisection_bidegree23_baseChangeFst k F hF hF0
  exact smooth_bidegree23_hasUnirationalParametrization_of_residualMultisection_dominant
    k F hF hF0 h

/-- No whole first-projection fiber on a smooth nonzero bidegree-`(2,3)` threefold. -/
theorem smooth_bidegree23_no_whole_first_fiber
    (k : Type u) [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (i : Fin 3) (x : Fin 3 → k) (hxi : x i = 1) :
    specializeFirstCoordinates (n := 2) x F ≠ 0 :=
  not_specializeFirstCoordinates_eq_zero_of_smooth_bidegree23 k F hF hF0 i x hxi

/-- No whole second-projection fiber on a smooth nonzero bidegree-`(2,3)` threefold. -/
theorem smooth_bidegree23_no_whole_second_fiber
    (k : Type u) [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (j : Fin 3) (y : Fin 3 → k) (hyj : y j = 1) :
    specializeSecondCoordinates (m := 2) y F ≠ 0 :=
  not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23 k F hF hF0 j y hyj

/-- Universal residual identity available for the residual divisor construction. -/
theorem residual_identity_available
    {R : Type u} [CommRing R] (a b c d e f hh i j kk U V W : R) :
    UniversalResidual.polarResultant a b c d e f hh U V W +
        UniversalResidual.binaryCubicDiscr a b c d *
          UniversalResidual.planeCubicValue a b c d e f hh i j kk U V W =
      W ^ 2 * UniversalResidual.residualLinear a b c d e f hh i j kk U V W :=
  UniversalResidual.residual_identity a b c d e f hh i j kk U V W

/-- Residual base-change package: dominance of `baseChangeFst` and Tsen isotropy of the
coordinate-line specialized conic (input for vertical-surface rationality). -/
theorem residual_baseChange_tsen_package
    (k : Type u) [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    IsDominant (residualMultisection_bidegree23 F).baseChangeFst ∧
      (∃ v : Fin 3 → Polynomial k, v ≠ 0 ∧
        TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0) := by
  obtain ⟨hdom, htsen, _⟩ := residual_baseChange_package_summary k F hF hF0
  exact ⟨hdom, htsen⟩

/-- Vertical-surface stereographic package: Tsen section + free direction give isotropic points of
the specialized conic for every `(t,s) ∈ 𝔸²`, together with residual base-change dominance.

This is the algebraic content of `𝔸² ⤏ S_L`.  Scheme-level residual-image birationality and
pointed-conic rationality of `X_T` remain the inputs to
`HasResidualBaseChangeUnirationalParametrization3`.
-/
theorem residual_baseChange_vertical_surface_package
    (k : Type u) [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    (∃ v : Fin 3 → Polynomial k, v ≠ 0 ∧
      TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0 ∧
        ∀ t s : k,
          MvPolynomial.eval (coordinateLineStereoParam F hF v t s)
            (coordinateLineSpecializedConic F t) = 0) ∧
      (∀ t : k, coordinateLineSpecializedConic F t ≠ 0) ∧
        IsDominant (residualMultisection_bidegree23 F).baseChangeFst :=
  vertical_surface_stereo_package F hF hF0

/-- Every smooth bidegree-`(2,3)` hypersurface whose coordinate line satisfies G3 is unirational.

The argument: pick a Tsen isotropic section `v` of the coordinate-line conic (proved, from Tsen
for ternary quadratics over `k[t]`) and a chart in which the residual chart denominator does not
vanish (residual `X`-coordinates nonzero is proved from smoothness; residual `Y`-coordinates is
obligation 1).  The residual component `T_L` — the scheme-theoretic image of the localized
residual chart map — is then a multisection of the conic bundle; its horizontality (obligation 2)
upgrades to dominance of `baseChangeFst` without any flatness hypothesis, and its base change is
unirational in dimension `2 + 1 = 3` (obligations 3 and 4).  The multisection principle transports
that parametrization back to `X`.

The G3 hypothesis is essential for this coordinate normalization.  It cannot be inferred from
smoothness: `Bidegree23Example.residualLineConstant` records a smooth counterexample.  The
unconditioned theorem below must instead run this construction along a chosen good line.
-/
theorem smooth_bidegree23_hasUnirationalParametrization_of_residualLineNonconstant
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (hgood : ResidualLineNonconstant F) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) := by
  obtain ⟨v, hv0, hv, hv2, hpolar, i, j, hdenom, _⟩ :=
    exists_residualChart_of_smooth_of_residualLineNonconstant F hF hF0 hgood
  haveI : IsDominant (residualComponentMultisection F hF v hv i j).baseChangeFst :=
    isDominant_residualComponentMultisection_baseChangeFst F hF v hv i j
      (isDominant_residualComponentToBase F hF v hv i j
        (isDominant_residualImagePointOfNormalizedLoc_toBase
          F hF hF0 hgood v hv0 hv hv2 hpolar i j hdenom))
  exact smooth_bidegree23_hasUnirationalParametrization_of_multisection_dominant
    k F hF hF0 (residualComponentMultisection F hF v hv i j)
    (hasUnirationalParametrization3_residualComponentBaseChange
      F hF hF0 hgood v hv0 hv hv2 hpolar i j hdenom)

/-- The arbitrary-line tangent-residual construction, once a good framed line and a
stereo-nondegenerate polynomial point on its generic conic have been chosen. -/
theorem smooth_bidegree23_hasUnirationalParametrization_of_good_line_section
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (hgood : ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) := by
  obtain ⟨i, j, hdenom, hdom⟩ :=
    exists_isDominant_residualComponentOnToBase
      p₀ q₀ r N hMN F hF hF0 hgood v hv0 hv hv2 hpolar
  let m := residualComponentOnMultisection p₀ q₀ r N hMN F hF v hv i j
  haveI : IsDominant m.baseChangeFst :=
    isDominant_residualComponentOnMultisection_baseChangeFst
      p₀ q₀ r N hMN F hF v hv i j hdom
  exact smooth_bidegree23_hasUnirationalParametrization_of_multisection_dominant
    k F hF hF0 m
    (hasUnirationalParametrization3_residualComponentOnBaseChange
      p₀ q₀ r N hMN F hF v hv i j hF0 hdenom hdom)

/--
**Main theorem.**  Every smooth bidegree-`(2,3)` hypersurface in `ℙ² × ℙ²` over an algebraically
closed field of characteristic zero is unirational: it admits a dominant rational map from affine
`3`-space over the base.

The statement is faithful and has no auxiliary geometric hypotheses.  The proof uses the
frame-incidence construction to choose one actual line carrying G3, a nondegenerate Tsen section,
and G4 simultaneously.  Retained-chart projective integrality and the degree `-2` transition law
for the residual quotient are automatic under smoothness; the latter turns homogeneous quadratic
multiples into compatible global functions on every target curve.  The resulting target-geometry
assembly feeds the arbitrary-line residual-component tower without using the obsolete isolated
horizontality determinant obligation.
-/
theorem smooth_bidegree23_hasUnirationalParametrization
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) :=
  hasUnirationalParametrization3_biprojectiveZeroLocus k F hF hF0

/-- Existential form of the main theorem. -/
theorem smooth_bidegree23_isUnirationalOver
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    IsUnirationalOver (Bidegree23ZeroLocus.toSpec k F) :=
  (smooth_bidegree23_hasUnirationalParametrization k F hF hF0).isUnirationalOver

/-- Packaging on the `residualImage` track, retained for reference.

**This route is superseded.**  `HasResidualImageUnirationalParametrization2 F` and
`HasResidualBaseChangeUnirationalParametrization3 F` are statements about the complete
intersection `residualImage F = V(F) ∩ V(q_F)`, which is reducible whenever the degree-ten
coefficients of `q_F` share a common factor.  Both are then *false*, not merely unproved, because
no dominant rational map from irreducible affine space onto a reducible target exists.  The live
argument runs on `residualComponent` instead; see `ResidualComponentAssembly.lean`. -/
theorem smooth_bidegree23_hasUnirationalParametrization_of_residual_image_and_pointed
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (hT : HasResidualImageUnirationalParametrization2 F)
    (hP : IsResidualPointedConicRational F)
    (hbridge :
      HasResidualImageUnirationalParametrization2 F →
        IsResidualPointedConicRational F →
          HasResidualBaseChangeUnirationalParametrization3 F) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) :=
  smooth_bidegree23_hasUnirationalParametrization_of_residualBaseChange k F hF hF0
    (hasResidualBaseChangeUnirationalParametrization3_of_image_and_pointed F hT hP hbridge)

end

end BConicBundleMultisections
