/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.GenericConicBaseChange
public import BConicBundleMultisections.HomogeneousJacobianChart
public import Mathlib.Algebra.MvPolynomial.Equiv
public import Mathlib.RingTheory.AdjoinRoot
public import Mathlib.RingTheory.Flat.Basic
public import Mathlib.RingTheory.Flat.Stability

/-!
# Descending integrality of a generic conic chart

The pointed-conic construction only needs an integral affine chart after shrinking the integral
base.  This file isolates the algebraic descent step.  If an `A`-algebra `B` is flat and its
extension to an injective `A`-algebra `K` is a domain, then `B` is a domain: flatness makes
`B → K ⊗[A] B` injective.

For the conic chart, `GenericConicBaseChange.baseChangeChartQuotientEquiv` identifies that tensor
product with the quotient by the mapped chart equation, while
`isDomain_chartDehomogenization_quotient_of_nonsingular` proves the latter is a domain for a
nonsingular ternary quadratic.

Thus the remaining finite-shrink obligation is sharply separated: arrange that the affine chart
quotient is flat over the chosen base ring (for example by inverting a nonzero quadratic
coefficient and presenting the equation as a monic polynomial in one variable).
-/

@[expose] public section

open scoped TensorProduct

universe u

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial

/-- A polynomial quotient with unit leading coefficient is flat over every ring over which its
coefficient ring is flat.  Rescale by the leading-coefficient unit to a monic polynomial, use the
standard free basis of a monic quotient, and transport across the unchanged principal ideal. -/
theorem flat_polynomialQuotient_of_isUnit_leadingCoeff
    {A R : Type u} [CommRing A] [CommRing R] [IsDomain R]
    [Algebra A R] [Module.Flat A R]
    (p : Polynomial R) (hp : IsUnit p.leadingCoeff) :
    Module.Flat A (Polynomial R ⧸ Ideal.span {p}) := by
  let q : Polynomial R := hp.unit⁻¹ • p
  have hq : q.Monic := Polynomial.monic_of_isUnit_leadingCoeff_inv_smul hp
  haveI hfree : Module.Free R (Polynomial R ⧸ Ideal.span {q}) := hq.free_quotient
  haveI hflatR : Module.Flat R (Polynomial R ⧸ Ideal.span {q}) := inferInstance
  haveI hflatA : Module.Flat A (Polynomial R ⧸ Ideal.span {q}) :=
    Module.Flat.trans A R _
  have hpq : Associated p q := by
    dsimp only [q]
    rw [Units.smul_def, Polynomial.smul_eq_C_mul]
    exact associated_unit_mul_right p _ (Polynomial.isUnit_C.mpr hp.unit⁻¹.isUnit)
  have hspan : Ideal.span ({p} : Set (Polynomial R)) = Ideal.span {q} :=
    Ideal.span_singleton_eq_span_singleton.mpr hpq
  let e := Ideal.quotientEquivAlgOfEq R hspan
  exact Module.Flat.of_linearEquiv (e.toLinearEquiv.restrictScalars A)

/-- A binary polynomial quotient is flat over its coefficient ring when, after viewing the first
variable as the polynomial variable, its leading coefficient is a unit. -/
theorem flat_binaryChartQuotient_of_isUnit_leadingCoeff
    {A : Type u} [CommRing A] [IsDomain A]
    (g : MvPolynomial (Fin 2) A)
    (hg : IsUnit (MvPolynomial.finSuccEquiv A 1 g).leadingCoeff) :
    Module.Flat A (MvPolynomial (Fin 2) A ⧸ Ideal.span {g}) := by
  let R := MvPolynomial (Fin 1) A
  let p : Polynomial R := MvPolynomial.finSuccEquiv A 1 g
  haveI hflatP : Module.Flat A (Polynomial R ⧸ Ideal.span {p}) :=
    flat_polynomialQuotient_of_isUnit_leadingCoeff p hg
  let e : (MvPolynomial (Fin 2) A ⧸ Ideal.span {g}) ≃ₐ[A]
      (Polynomial R ⧸ Ideal.span {p}) :=
    Ideal.quotientEquivAlg _ _ (MvPolynomial.finSuccEquiv A 1)
      (by rw [Ideal.map_span, Set.image_singleton]; rfl)
  exact Module.Flat.of_linearEquiv e.toLinearEquiv

/-- A flat algebra whose scalar extension along an injective map is a domain is itself a domain. -/
theorem isDomain_of_flat_of_isDomain_tensorProduct
    {A K B : Type u} [CommRing A] [CommRing K] [CommRing B]
    [Algebra A K] [Algebra A B] [Module.Flat A B]
    [IsDomain (K ⊗[A] B)]
    (hAK : Function.Injective (algebraMap A K)) :
    IsDomain B := by
  let ι : B →ₐ[A] K ⊗[A] B := Algebra.TensorProduct.includeRight
  have hι : Function.Injective ι :=
    Algebra.TensorProduct.includeRight_injective hAK
  exact Function.Injective.isDomain ι hι

/-- Domain descent in the form used for a binary affine chart of a nonsingular projective conic. -/
theorem isDomain_chartQuotient_of_flat_of_nonsingular_baseChange
    {A K : Type u} [CommRing A] [Field K] [Algebra A K]
    (hAK : Function.Injective (algebraMap A K))
    (g : MvPolynomial (Fin 2) A)
    [Module.Flat A (MvPolynomial (Fin 2) A ⧸ Ideal.span {g})]
    (i : Fin 3) (Q : MvPolynomial (Fin 3) K)
    (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0)
    (hnonsing : ∀ v : Fin 3 → K, v ≠ 0 → eval v Q = 0 →
      ∃ j, eval v (pderiv j Q) ≠ 0)
    (hg : MvPolynomial.map (algebraMap A K) g =
      ProjectiveSpace.chartDehomogenization 2 K i Q) :
    IsDomain (MvPolynomial (Fin 2) A ⧸ Ideal.span {g}) := by
  let q := ProjectiveSpace.chartDehomogenization 2 K i Q
  haveI hQdom : IsDomain (MvPolynomial (Fin 2) K ⧸ Ideal.span {q}) :=
    isDomain_chartDehomogenization_quotient_of_nonsingular
      i Q hQ hQ0 hnonsing
  let eQ :
      (MvPolynomial (Fin 2) K ⧸
          Ideal.span {MvPolynomial.map (algebraMap A K) g}) ≃ₐ[K]
        (MvPolynomial (Fin 2) K ⧸ Ideal.span {q}) :=
    Ideal.quotientEquivAlgOfEq K (by rw [hg])
  haveI hCK : IsDomain
      (MvPolynomial (Fin 2) K ⧸
        Ideal.span {MvPolynomial.map (algebraMap A K) g}) :=
    eQ.toRingEquiv.toMulEquiv.isDomain _
  let e := baseChangeChartQuotientEquiv (K := A) (L := K) g
  haveI hTensor : IsDomain
      (K ⊗[A] (MvPolynomial (Fin 2) A ⧸ Ideal.span {g})) :=
    e.toRingEquiv.toMulEquiv.isDomain _
  exact isDomain_of_flat_of_isDomain_tensorProduct hAK

/-- The immediately usable finite-shrink form: a unit leading coefficient supplies the flatness
hypothesis needed by `isDomain_chartQuotient_of_flat_of_nonsingular_baseChange`. -/
theorem isDomain_binaryChartQuotient_of_unitLeadingCoeff_of_nonsingular_baseChange
    {A K : Type u} [CommRing A] [IsDomain A] [Field K] [Algebra A K]
    (hAK : Function.Injective (algebraMap A K))
    (g : MvPolynomial (Fin 2) A)
    (hlead : IsUnit (MvPolynomial.finSuccEquiv A 1 g).leadingCoeff)
    (i : Fin 3) (Q : MvPolynomial (Fin 3) K)
    (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0)
    (hnonsing : ∀ v : Fin 3 → K, v ≠ 0 → eval v Q = 0 →
      ∃ j, eval v (pderiv j Q) ≠ 0)
    (hg : MvPolynomial.map (algebraMap A K) g =
      ProjectiveSpace.chartDehomogenization 2 K i Q) :
    IsDomain (MvPolynomial (Fin 2) A ⧸ Ideal.span {g}) := by
  letI : Module.Flat A (MvPolynomial (Fin 2) A ⧸ Ideal.span {g}) :=
    flat_binaryChartQuotient_of_isUnit_leadingCoeff g hlead
  exact isDomain_chartQuotient_of_flat_of_nonsingular_baseChange
    hAK g i Q hQ hQ0 hnonsing hg

end

end BConicBundleMultisections
