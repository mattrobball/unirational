/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualComponentExhaustion
public import Mathlib.AlgebraicGeometry.Morphisms.QuasiFinite

/-!
# The generic fibre of the target relation

This file separates the topological generic-fibre argument from the algebraic finiteness input for
`targetRelationToFirst`.  A discrete set-theoretic generic fibre of a dominant morphism between
integral schemes has at most one point: the fibre is preirreducible because every nonempty open in
it contains the generic point of the source.
-/

@[expose] public section

open CategoryTheory Topology TopologicalSpace
open scoped AlgebraicGeometry
open AlgebraicGeometry

namespace BConicBundleMultisections
namespace TargetRelationGenericFiber

noncomputable section

universe u

open _root_.MvPolynomial

/-- The underlying fibre over the generic point of a dominant morphism between integral schemes
is preirreducible. -/
theorem schemePointFiber_genericPoint_isPreirreducible
    {Y S : Scheme.{u}} [IsIntegral Y] [IsIntegral S]
    (p : Y ⟶ S) [IsDominant p] :
    IsPreirreducible {y : Y | p y = genericPoint S} := by
  intro U V hU hV hUnonempty hVnonempty
  have hgeneric : p (genericPoint Y) = genericPoint S :=
    schemeMap_genericPoint_eq_of_isDominant p
  have hgU : genericPoint Y ∈ U := by
    apply ((genericPoint_spec Y).mem_open_set_iff hU).mpr
    obtain ⟨y, _hyfiber, hyU⟩ := hUnonempty
    exact ⟨y, Set.mem_univ y, hyU⟩
  have hgV : genericPoint Y ∈ V := by
    apply ((genericPoint_spec Y).mem_open_set_iff hV).mpr
    obtain ⟨y, _hyfiber, hyV⟩ := hVnonempty
    exact ⟨y, Set.mem_univ y, hyV⟩
  exact ⟨genericPoint Y, hgeneric, hgU, hgV⟩

/-- A discrete generic fibre of a dominant morphism between integral schemes is a subsingleton. -/
theorem schemePointFiber_genericPoint_subsingleton_of_discrete
    {Y S : Scheme.{u}} [IsIntegral Y] [IsIntegral S]
    (p : Y ⟶ S) [IsDominant p]
    (hdiscrete : _root_.IsDiscrete {y : Y | p y = genericPoint S}) :
    Subsingleton (schemePointFiber p (genericPoint S)) := by
  refine ⟨fun x y => Subtype.ext ?_⟩
  exact hdiscrete.subsingleton_of_isPreirreducible
    (schemePointFiber_genericPoint_isPreirreducible p) x.2 y.2

/-- A locally Artinian scheme-theoretic fibre has discrete underlying topology, which is the
exact topological input needed by the generic-point argument. -/
theorem schemePointFiber_genericPoint_subsingleton_of_isLocallyArtinian_fiber
    {Y S : Scheme.{u}} [IsIntegral Y] [IsIntegral S]
    (p : Y ⟶ S) [IsDominant p]
    [IsLocallyArtinian (p.fiber (genericPoint S))] :
    Subsingleton (schemePointFiber p (genericPoint S)) := by
  apply schemePointFiber_genericPoint_subsingleton_of_discrete p
  have hdiscrete : _root_.IsDiscrete (p ⁻¹' {genericPoint S}) := by
    simpa [Scheme.Hom.range_fiberι] using
      (isDiscrete_univ_iff.mpr inferInstance).image
        (p.fiberι (genericPoint S)).isEmbedding.toIsInducing
  convert hdiscrete using 1
  ext y
  simp

/-- It is enough that the scheme-theoretic fibre over the generic point be locally quasi-finite.

This is deliberately weaker than assuming that `p` is locally quasi-finite everywhere: only the
single residue-field fibre used by the exhaustion argument is required. -/
theorem schemePointFiber_genericPoint_subsingleton_of_locallyQuasiFinite_fiber
    {Y S : Scheme.{u}} [IsIntegral Y] [IsIntegral S]
    (p : Y ⟶ S) [IsDominant p]
    [LocallyQuasiFinite (p.fiberToSpecResidueField (genericPoint S))] :
    Subsingleton (schemePointFiber p (genericPoint S)) := by
  letI : IsLocallyArtinian (p.fiber (genericPoint S)) :=
    IsLocallyArtinian.of_locallyQuasiFinite
      (p.fiberToSpecResidueField (genericPoint S))
  exact schemePointFiber_genericPoint_subsingleton_of_isLocallyArtinian_fiber p

/-- Global local quasi-finiteness is a convenient sufficient form of the preceding criterion. -/
theorem schemePointFiber_genericPoint_subsingleton_of_locallyQuasiFinite
    {Y S : Scheme.{u}} [IsIntegral Y] [IsIntegral S]
    (p : Y ⟶ S) [IsDominant p] [LocallyQuasiFinite p] :
    Subsingleton (schemePointFiber p (genericPoint S)) :=
  schemePointFiber_genericPoint_subsingleton_of_discrete p
    (p.isDiscrete_preimage_singleton (genericPoint S))

/-! ### The target relation

For homogeneous nonconstant `H`, the generic fibre below is the scheme-theoretic intersection in
the `y`-plane of `H` with the cubic obtained by specializing the first coordinates of `F` at the
generic point of `P²_x`.  Algebraically, a no-common-component (equivalently, an appropriate
nondivisibility) argument should prove that this projective intersection is locally Artinian.

The current project and Mathlib do not yet contain the required bridge from coprimality of those
two multivariate homogeneous polynomials to local Artinianness of their projective intersection.
The theorem below therefore takes `IsLocallyArtinian` itself as the precise remaining algebraic
hypothesis; it does not disguise that missing bridge as a proved no-common-component theorem. -/

/-- The exact generic-plane-intersection input needed to discharge the target relation's
`Subsingleton` hypothesis. -/
theorem targetRelation_schemePointFiber_subsingleton_of_isLocallyArtinian_fiber
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    [IsIntegral (targetRelationZeroLocus F H)]
    [IsDominant (targetRelationToFirst F H)]
    [IsLocallyArtinian
      ((targetRelationToFirst F H).fiber (genericPoint (ProjectiveSpace 2 k)))] :
    Subsingleton
      (schemePointFiber (targetRelationToFirst F H)
        (genericPoint (ProjectiveSpace 2 k))) :=
  schemePointFiber_genericPoint_subsingleton_of_isLocallyArtinian_fiber
    (targetRelationToFirst F H)

/-- The residual component exhausts the target relation once the generic plane-curve
intersection is known to be locally Artinian.  Compared with
`residualTargetComponentOnι_isIso_of_subsingleton_genericFiber`, this theorem discharges the
set-theoretic generic-fibre hypothesis; the remaining `IsLocallyArtinian` instance is precisely
the algebraic no-common-component step described above. -/
theorem residualTargetComponentOnι_isIso_of_isLocallyArtinian_genericFiber
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0)
    [IsIntegral (targetRelationZeroLocus F H)]
    [hsurj : Surjective
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hH hvan)]
    [IsLocallyArtinian
      ((targetRelationToFirst F H).fiber (genericPoint (ProjectiveSpace 2 k)))] :
    IsIso
      (residualTargetComponentOnι
        p₀ q₀ r N hMN F hF v hv i j H hH hvan) := by
  letI : Surjective
      (residualTargetComponentOnι
          p₀ q₀ r N hMN F hF v hv i j H hH hvan ≫
        targetRelationToFirst F H) := by
    change Surjective
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hH hvan)
    exact hsurj
  letI : IsDominant (targetRelationToFirst F H) :=
    IsDominant.of_comp
      (residualTargetComponentOnι
        p₀ q₀ r N hMN F hF v hv i j H hH hvan)
      (targetRelationToFirst F H)
  letI : Subsingleton
      (schemePointFiber (targetRelationToFirst F H)
        (genericPoint (ProjectiveSpace 2 k))) :=
    targetRelation_schemePointFiber_subsingleton_of_isLocallyArtinian_fiber F H
  exact
    residualTargetComponentOnι_isIso_of_subsingleton_genericFiber
      p₀ q₀ r N hMN F hF v hv i j H hH hvan

end

end TargetRelationGenericFiber
end BConicBundleMultisections
