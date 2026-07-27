/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BirationalUnirationality
public import BConicBundleMultisections.ConicFlatnessBricks
public import BConicBundleMultisections.PointedConicOpenParametrization
public import BConicBundleMultisections.PointedConicRationalFamilies

/-!
# Consuming only the integral stereographic open

The existing pointed-conic consumer asks for a birational equivalence between the *entire*
base-changed conic bundle and an affine line.  That forces integrality of the entire pullback and
therefore inherits the two outstanding integrality leaves in
`PointedConicRationalFamilies`.

For the headline unirationality theorem this is stronger than necessary.  The chart computation
already supplies an affine conic over a dense affine open of the multisection base.  Its explicit
stereographic open is integral and relatively rational without knowing that the ambient pullback
is integral.  This file packages that open and assembles its `2 + 1` parametrization.

The remaining geometric statement is exact: the composite of this open chart with the first
pullback projection must be dominant onto the original biprojective hypersurface.  No theorem
with that conclusion is postulated here; it is exposed as `PointedConicOpenChartData.Dominates`.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace

/-- The consumer-facing data of the integral stereographic open inside a pointed conic
pullback.  The base and source are kept abstract in the interface; the constructor below uses
`Spec A` and `Spec A[z]_{QL}` respectively. -/
structure PointedConicOpenChartData
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    {T : Scheme.{u}} (t : T ⟶ ProjectiveSpace 2 k) where
  base : Scheme.{u}
  source : Scheme.{u}
  baseOpen : base ⟶ T
  sourceToBase : source ⟶ base
  sourceToPullback : source ⟶
    Limits.pullback (biprojectiveZeroLocusSnd 2 2 k F) t
  baseOpen_isOpenImmersion : IsOpenImmersion baseOpen
  baseOpen_isDominant : IsDominant baseOpen
  sourceToBase_isDominant : IsDominant sourceToBase
  sourceToPullback_isOpenImmersion : IsOpenImmersion sourceToPullback
  source_over :
    sourceToPullback ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t =
      sourceToBase ≫ baseOpen
  source_parametrization : HasUnirationalParametrization 1 sourceToBase

namespace PointedConicOpenChartData

variable {k : Type u} [Field k]
variable {F : MvPolynomial (BiprojectiveCoordinate 2 2) k}
variable {T : Scheme.{u}} {t : T ⟶ ProjectiveSpace 2 k}

/-- The map whose dominance is the sole remaining geometric obligation in the open-chart route. -/
def toTotal (D : PointedConicOpenChartData F t) :
    D.source ⟶ biprojectiveZeroLocus 2 2 k F :=
  D.sourceToPullback ≫ Limits.pullback.fst (biprojectiveZeroLocusSnd 2 2 k F) t

/-- Exact residual obligation: the integral stereographic open dominates the original
biprojective hypersurface after the first pullback projection. -/
def Dominates (D : PointedConicOpenChartData F t) : Prop :=
  IsDominant D.toTotal

/-- If the full pullback is preirreducible, the open-chart dominance leaf is immediate: a
nonempty open in a preirreducible space is dense, and dominance then composes with the already
dominant first pullback projection.  Thus the open-chart route needs no reducedness of the
pullback; at worst it needs only this topological half of the old integrality leaf. -/
theorem dominates_of_preirreducible
    (D : PointedConicOpenChartData F t)
    [PreirreducibleSpace
      (Limits.pullback (C := Scheme.{u}) (biprojectiveZeroLocusSnd 2 2 k F) t)]
    [Nonempty D.source]
    [IsDominant (Limits.pullback.fst (biprojectiveZeroLocusSnd 2 2 k F) t)] :
    D.Dominates := by
  haveI : IsOpenImmersion D.sourceToPullback := D.sourceToPullback_isOpenImmersion
  haveI : IsDominant D.sourceToPullback := by
    refine ⟨?_⟩
    exact ((Scheme.Hom.isOpenEmbedding D.sourceToPullback).isOpen_range).dense
      (Set.range_nonempty _)
  dsimp only [Dominates, toTotal]
  infer_instance

/-- Flatness plus irreducibility of the generic conic fibre is the precise geometric route to
the same dominance conclusion.  The source chart dominates the base by construction, hence its
open immersion into the pullback is dense by the flat-generic-fibre theorem; composing with the
dominant first pullback projection finishes. -/
theorem dominates_of_flat_of_irreducibleSpace_genericFiber
    (D : PointedConicOpenChartData F t)
    [IsIntegral T]
    [Flat (Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t)]
    [IrreducibleSpace
      ((Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t).fiber
        (genericPoint T))]
    [IsDominant (Limits.pullback.fst (biprojectiveZeroLocusSnd 2 2 k F) t)] :
    D.Dominates := by
  haveI : IsOpenImmersion D.sourceToPullback := D.sourceToPullback_isOpenImmersion
  haveI : IsDominant D.sourceToBase := D.sourceToBase_isDominant
  haveI : IsDominant D.baseOpen := D.baseOpen_isDominant
  haveI : IsDominant
      (D.sourceToPullback ≫
        Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t) := by
    rw [D.source_over]
    infer_instance
  haveI : IsDominant D.sourceToPullback :=
    isDominant_openImmersion_of_comp_isDominant_of_flat_of_irreducibleSpace_genericFiber
      D.sourceToPullback
      (Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t)
  dsimp only [Dominates, toTotal]
  infer_instance

/-- Global-flatness form of `dominates_of_flat_of_irreducibleSpace_genericFiber`.

Flatness of the original conic projection supplies flatness of the pullback projection.  It also
makes the other pullback projection dominant: the multisection is quasi-compact and dominant, and
scheme-theoretic dominance survives flat base change over the reduced projective plane.  Thus the
only conic-specific input left here, besides flatness, is topological irreducibility of the generic
fibre; neither reducedness nor integrality of that fibre is needed. -/
theorem dominates_of_flat_conicProjection_of_irreducibleSpace_genericFiber
    (D : PointedConicOpenChartData F t)
    [IsIntegral T] [QuasiCompact t] [IsDominant t]
    [Flat (biprojectiveZeroLocusSnd 2 2 k F)]
    [IrreducibleSpace
      ((Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t).fiber
        (genericPoint T))] :
    D.Dominates := by
  let π := biprojectiveZeroLocusSnd 2 2 k F
  haveI : Flat (Limits.pullback.snd π t) := by
    dsimp only [π]
    infer_instance
  haveI : IsDominant (Limits.pullback.fst π t) := by
    exact isDominant_pullback_fst_of_flat_of_isDominant π t
  exact D.dominates_of_flat_of_irreducibleSpace_genericFiber

/-- The two maps from the stereographic source to `Spec k` agree. -/
theorem toTotal_comp_toSpec (D : PointedConicOpenChartData F t) :
    D.toTotal ≫ biprojectiveZeroLocusToSpec 2 2 k F =
      D.sourceToBase ≫ D.baseOpen ≫ t ≫ ProjectiveSpace.toSpec 2 k := by
  rw [toTotal, Category.assoc, ← biprojectiveZeroLocusSnd_toSpec 2 2 k F,
    ← Category.assoc (Limits.pullback.fst (biprojectiveZeroLocusSnd 2 2 k F) t),
    Limits.pullback.condition, Category.assoc, ← Category.assoc D.sourceToPullback,
    D.source_over]
  simp only [Category.assoc]

/-- A parametrization of the multisection base and the relative stereographic parametrization
assemble to a three-dimensional parametrization of the open chart. -/
theorem source_hasUnirationalParametrization3
    (D : PointedConicOpenChartData F t)
    (hT : HasUnirationalParametrization 2 (t ≫ ProjectiveSpace.toSpec 2 k)) :
    HasUnirationalParametrization 3
      (D.sourceToBase ≫ D.baseOpen ≫ t ≫ ProjectiveSpace.toSpec 2 k) := by
  haveI : IsOpenImmersion D.baseOpen := D.baseOpen_isOpenImmersion
  haveI : IsDominant D.baseOpen := D.baseOpen_isDominant
  let hbir : Scheme.BirationalOver
      (D.baseOpen ≫ t ≫ ProjectiveSpace.toSpec 2 k)
      (t ≫ ProjectiveSpace.toSpec 2 k) :=
    Scheme.Hom.birationalOver D.baseOpen
      (t ≫ ProjectiveSpace.toSpec 2 k)
      (D.baseOpen ≫ t ≫ ProjectiveSpace.toSpec 2 k) rfl
  have hbase : HasUnirationalParametrization 2
      (D.baseOpen ≫ t ≫ ProjectiveSpace.toSpec 2 k) :=
    hT.of_birationalOver hbir
  letI : Nonempty D.base := nonempty_of_hasUnirationalParametrization hbase
  simpa only [Nat.reduceAdd] using
    (hasUnirationalParametrization_succ_of_tower
      (D.baseOpen ≫ t ≫ ProjectiveSpace.toSpec 2 k)
      D.sourceToBase hbase D.source_parametrization)

/-- Conditional final assembly: once the explicit open chart dominates the original zero locus,
the headline three-dimensional parametrization follows directly, without rationalizing or proving
integral the whole pullback. -/
theorem total_hasUnirationalParametrization3
    (D : PointedConicOpenChartData F t)
    (hT : HasUnirationalParametrization 2 (t ≫ ProjectiveSpace.toSpec 2 k))
    (hdom : D.Dominates) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) := by
  haveI : IsDominant D.toTotal := hdom
  exact (D.source_hasUnirationalParametrization3 hT).postcomp D.toTotal D.toTotal_comp_toSpec

/-- Final open-chart assembly in the form consumed by a globally flat conic projection.  The
quasi-compact dominant multisection takes care of the first pullback projection automatically;
the only remaining fibre hypothesis is irreducibility of the generic conic as a topological
space. -/
theorem total_hasUnirationalParametrization3_of_flat_conicProjection
    (D : PointedConicOpenChartData F t)
    [IsIntegral T] [QuasiCompact t] [IsDominant t]
    [Flat (biprojectiveZeroLocusSnd 2 2 k F)]
    [IrreducibleSpace
      ((Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t).fiber
        (genericPoint T))]
    (hT : HasUnirationalParametrization 2 (t ≫ ProjectiveSpace.toSpec 2 k)) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) :=
  D.total_hasUnirationalParametrization3 hT
    D.dominates_of_flat_conicProjection_of_irreducibleSpace_genericFiber

end PointedConicOpenChartData

/-- The existing affine chart computation produces the weaker data actually needed by the
headline open-chart route.  This theorem uses neither generic-fibre integrality nor integrality of
the whole pullback. -/
theorem exists_pointedConicOpenChartData
    {k : Type u} [Field k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T]
    (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t) :
    Nonempty (PointedConicOpenChartData F t) := by
  obtain ⟨A, instCR, alpha, beta, gamma, delta, epsilon, zeta, p₁, p₂,
    hp, hQ, hL, psi, instOI, instDom, r₀, instR₀, hr₀⟩ :=
    exists_conicChart_openImmersion F hF hF0 t s
  letI := instCR
  haveI := instOI
  haveI := instDom
  haveI := instR₀
  haveI : Nonempty (Spec (CommRingCat.of A)) :=
    (IsDominant.denseRange (f := psi)).nonempty
  letI : IsIntegral (Spec (CommRingCat.of A)) := isIntegral_of_isOpenImmersion psi
  letI : IsDomain A := (affine_isIntegral_iff (CommRingCat.of A)).mp inferInstance
  let d : A := 2 * alpha * p₁ + beta * p₂ + delta
  let e : A := beta * p₁ + 2 * gamma * p₂ + epsilon
  let source := PointedConic.lineChartScheme alpha beta gamma d e
  let p : source ⟶ Spec (CommRingCat.of A) :=
    PointedConic.lineChartSchemeToSpec alpha beta gamma d e
  let u : source ⟶ Limits.pullback (biprojectiveZeroLocusSnd 2 2 k F) t :=
    PointedConic.lineChartSchemeToAffineConicScheme
      alpha beta gamma delta epsilon zeta p₁ p₂ hp ≫ r₀
  haveI : IsOpenImmersion u := by
    dsimp only [u]
    infer_instance
  have hu : u ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t = p ≫ psi := by
    dsimp only [u, p, d, e]
    rw [Category.assoc, hr₀, ← Category.assoc,
      PointedConic.lineChartSchemeToAffineConicScheme_over]
  have hp1 : HasUnirationalParametrization 1 p := by
    dsimp only [p, d, e]
    exact PointedConic.hasUnirationalParametrization_lineChart
      alpha beta gamma
      (2 * alpha * p₁ + beta * p₂ + delta)
      (beta * p₁ + 2 * gamma * p₂ + epsilon) hQ hL
  have hpdom : IsDominant p := by
    dsimp only [p, d, e]
    exact PointedConic.lineChartSchemeToSpec_isDominant
      alpha beta gamma
      (2 * alpha * p₁ + beta * p₂ + delta)
      (beta * p₁ + 2 * gamma * p₂ + epsilon) hQ hL
  exact ⟨⟨Spec (CommRingCat.of A), source, psi, p, u,
    inferInstance, inferInstance, hpdom, inferInstance, hu, hp1⟩⟩

/-- Consumer-level replacement for whole-pullback rationality.  A pointed conic over a
two-dimensionally parametrized integral quasi-compact multisection yields the headline
three-dimensional parametrization from global flatness and irreducibility of the generic conic
fibre.  In particular, no integrality (or reducedness) assertion about the whole pullback occurs
in the statement or proof. -/
theorem hasUnirationalParametrization3_of_pointedConicOpen_of_flat
    {k : Type u} [Field k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T]
    (t : T ⟶ ProjectiveSpace 2 k) [QuasiCompact t] [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t)
    [Flat (biprojectiveZeroLocusSnd 2 2 k F)]
    [IrreducibleSpace
      ((Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t).fiber
        (genericPoint T))]
    (hT : HasUnirationalParametrization 2 (t ≫ ProjectiveSpace.toSpec 2 k)) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) := by
  obtain ⟨D⟩ := exists_pointedConicOpenChartData F hF hF0 t s
  exact D.total_hasUnirationalParametrization3_of_flat_conicProjection hT

end

end BConicBundleMultisections
