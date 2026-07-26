/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.HomogeneousJacobianChart
public import Mathlib.RingTheory.Smooth.Basic
public import Mathlib.RingTheory.TensorProduct.MvPolynomial
public import Mathlib.RingTheory.TensorProduct.Quotient

/-!
# Base change of the affine charts of a plane conic

This file supplies the algebraic base-change part of the generic-conic integrality argument.
For a field extension `K → L`, it identifies

`L ⊗[K] (K[u,v] / (g))`

with `L[u,v] / (map g)`.  Consequently smoothness of all three dehomogenized charts of a
homogeneous ternary quadratic base-changes to `L`, and the mapped quadratic is nonsingular.

The remaining scheme-theoretic step is deliberately not hidden here: to deduce integrality of
the projective conic one must also identify these three affine spectra with a jointly-surjective
open cover of the fibre and prove the cover irreducible (equivalently, identify the fibre with
the appropriate `Proj`).
-/

@[expose] public section

open scoped TensorProduct

universe u

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial

/-- Dehomogenization commutes with extension of the coefficient ring. -/
theorem chartDehomogenization_map
    {K L : Type u} [CommRing K] [CommRing L] [Algebra K L]
    (i : Fin 3) (Q : MvPolynomial (Fin 3) K) :
    ProjectiveSpace.chartDehomogenization 2 L i
        (MvPolynomial.map (algebraMap K L) Q) =
      MvPolynomial.map (algebraMap K L)
        (ProjectiveSpace.chartDehomogenization 2 K i Q) := by
  induction Q using MvPolynomial.induction_on with
  | C a => simp [ProjectiveSpace.chartDehomogenization]
  | add p q hp hq => simp [hp, hq]
  | mul_X p j hp =>
      simp only [map_mul, MvPolynomial.map_X, hp]
      unfold ProjectiveSpace.chartDehomogenization
      simp only [MvPolynomial.aeval_X]
      congr 1
      by_cases hji : j = i
      · subst j
        simp
      · obtain ⟨r, rfl⟩ := Fin.exists_succAbove_eq hji
        simp

/-- Base change of the coordinate ring of a dehomogenized hypersurface chart. -/
noncomputable def baseChangeChartQuotientEquiv
    {K L : Type u} [CommRing K] [CommRing L] [Algebra K L]
    (g : MvPolynomial (Fin 2) K) :
    L ⊗[K] (MvPolynomial (Fin 2) K ⧸ Ideal.span {g}) ≃ₐ[L]
      MvPolynomial (Fin 2) L ⧸ Ideal.span {MvPolynomial.map (algebraMap K L) g} := by
  let I : Ideal (L ⊗[K] MvPolynomial (Fin 2) K) :=
    (Ideal.span {g}).map Algebra.TensorProduct.includeRight
  let J : Ideal (MvPolynomial (Fin 2) L) :=
    Ideal.span {MvPolynomial.map (algebraMap K L) g}
  let e₁ := Algebra.TensorProduct.tensorQuotientEquiv
    (R := K) L (MvPolynomial (Fin 2) K) L (Ideal.span {g})
  have hIJ : J = I.map (MvPolynomial.algebraTensorAlgEquiv K L).toRingHom := by
    dsimp only [I, J]
    rw [Ideal.map_span, Set.image_singleton, Ideal.map_span, Set.image_singleton]
    congr 2
    symm
    change MvPolynomial.algebraTensorAlgEquiv K L (1 ⊗ₜ[K] g) =
      MvPolynomial.map (algebraMap K L) g
    simp
  let e₂ := Ideal.quotientEquivAlg I J
    (MvPolynomial.algebraTensorAlgEquiv K L) hIJ
  exact e₁.trans e₂

/-- Smoothness of a dehomogenized chart quotient persists after a field extension. -/
theorem ringHom_smooth_chartDehomogenization_baseChange
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    (Q : MvPolynomial (Fin 3) K)
    (hsm : ∀ i : Fin 3,
      RingHom.Smooth
        (algebraMap K
          (MvPolynomial (Fin 2) K ⧸ Ideal.span
            {ProjectiveSpace.chartDehomogenization 2 K i Q})))
    (i : Fin 3) :
    RingHom.Smooth
      (algebraMap L
        (MvPolynomial (Fin 2) L ⧸ Ideal.span
          {ProjectiveSpace.chartDehomogenization 2 L i
            (MvPolynomial.map (algebraMap K L) Q)})) := by
  let g := ProjectiveSpace.chartDehomogenization 2 K i Q
  haveI hsmK : Algebra.Smooth K
      (MvPolynomial (Fin 2) K ⧸ Ideal.span {g}) :=
    (RingHom.smooth_algebraMap).mp (hsm i)
  haveI hsmT : Algebra.Smooth L
      (L ⊗[K] (MvPolynomial (Fin 2) K ⧸ Ideal.span {g})) := inferInstance
  have hmap : ProjectiveSpace.chartDehomogenization 2 L i
      (MvPolynomial.map (algebraMap K L) Q) =
      MvPolynomial.map (algebraMap K L) g :=
    chartDehomogenization_map i Q
  rw [hmap]
  let e := baseChangeChartQuotientEquiv (K := K) (L := L) g
  haveI hsmQ : Algebra.Smooth L
      (MvPolynomial (Fin 2) L ⧸
        Ideal.span {MvPolynomial.map (algebraMap K L) g}) :=
    Algebra.Smooth.of_equiv (A :=
      L ⊗[K] (MvPolynomial (Fin 2) K ⧸ Ideal.span {g})) e
  exact (RingHom.smooth_algebraMap).mpr hsmQ

/-- A smooth ternary quadratic remains Jacobian-nonsingular after a field extension, expressed
using the smoothness of its three dehomogenized chart quotients. -/
theorem nonsingular_map_of_smooth_dehomogenized_charts
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0)
    (hsm : ∀ i : Fin 3,
      RingHom.Smooth
        (algebraMap K
          (MvPolynomial (Fin 2) K ⧸ Ideal.span
            {ProjectiveSpace.chartDehomogenization 2 K i Q}))) :
    let QL := MvPolynomial.map (algebraMap K L) Q
    ∀ v : Fin 3 → L, v ≠ 0 → MvPolynomial.eval v QL = 0 →
      ∃ i, MvPolynomial.eval v (MvPolynomial.pderiv i QL) ≠ 0 := by
  dsimp only
  let QL := MvPolynomial.map (algebraMap K L) Q
  have hQL : QL.IsHomogeneous 2 := hQ.map _
  have hinj : Function.Injective (algebraMap K L) :=
    FaithfulSMul.algebraMap_injective K L
  have hQL0 : QL ≠ 0 := by
    change MvPolynomial.map (algebraMap K L) Q ≠ 0
    simpa only [map_zero] using (MvPolynomial.map_injective _ hinj).ne hQ0
  have hsmL : ∀ i : Fin 3,
      RingHom.Smooth
        (algebraMap L
          (MvPolynomial (Fin 2) L ⧸ Ideal.span
            {ProjectiveSpace.chartDehomogenization 2 L i QL})) := by
    intro i
    exact ringHom_smooth_chartDehomogenization_baseChange Q hsm i
  intro v hv hzero
  exact nonsingular_of_smooth_dehomogenized_charts QL hQL hQL0 hsmL v hv hzero

end

end BConicBundleMultisections
