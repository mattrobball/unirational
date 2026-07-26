/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualDiscriminantGenericConic
public import BConicBundleMultisections.TernaryQuadraticGradient
public import BConicBundleMultisections.VerticalCompleteIntersectionPrime
public import Mathlib.RingTheory.Flat.Basic
public import Mathlib.RingTheory.TensorProduct.MvPolynomial
public import Mathlib.RingTheory.TensorProduct.Quotient

/-!
# The generic conic over an irreducible target relation

Let `H` be an irreducible homogeneous equation in the second projective coordinates.  The affine
cone ring `A = k[y₀,y₁,y₂]/(H)` is a domain.  If `H` does not divide the second-conic
discriminant, that discriminant remains nonzero in `A`; consequently the universal conic over
`FractionRing A` is nonsingular and irreducible, and its principal ideal is prime.

This is the generic algebraic input for the vertical complete intersection `V(F,H)`.  Notice that
the conclusion in this file is deliberately over `FractionRing A`.  Passing back to the affine
cone, or directly to the biprojective closed subscheme, needs a flatness/saturation argument: the
positive-degree conic coefficients all vanish at the cone vertex, so generic primality alone must
not be advertised as primality of the unsaturated affine-cone ideal.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open _root_.MvPolynomial
open scoped TensorProduct

/-- The homogeneous-coordinate functions on the affine cone `V(H)`. -/
def targetRelationConeCoordinates
    {k : Type u} [Field k] (H : MvPolynomial (Fin 3) k) :
    Fin 3 → MvPolynomial (Fin 3) k ⧸ Ideal.span {H} :=
  fun i ↦ Ideal.Quotient.mk (Ideal.span {H}) (MvPolynomial.X i)

/-- An irreducible target relation has a domain affine-cone coordinate ring. -/
theorem isDomain_targetRelationCone
    {k : Type u} [Field k] {H : MvPolynomial (Fin 3) k}
    (hH : Irreducible H) :
    IsDomain (MvPolynomial (Fin 3) k ⧸ Ideal.span {H}) := by
  letI : (Ideal.span {H}).IsPrime :=
    (Ideal.span_singleton_prime hH.ne_zero).mpr hH.prime
  infer_instance

/-- Quotient evaluation at the tautological cone coordinates is the quotient map. -/
theorem aeval_targetRelationConeCoordinates
    {k : Type u} [Field k] (H : MvPolynomial (Fin 3) k) :
    (aeval (targetRelationConeCoordinates H)).toRingHom =
      Ideal.Quotient.mk (Ideal.span {H}) := by
  change (aeval (targetRelationConeCoordinates H)).toRingHom =
    (Ideal.Quotient.mkₐ k (Ideal.span {H})).toRingHom
  congr 1
  apply MvPolynomial.algHom_ext
  intro i
  simp [targetRelationConeCoordinates]

/-- Not being divisible by `H` is exactly the nonvanishing statement needed in the quotient
cone. -/
theorem quotient_mk_ne_zero_of_not_dvd
    {k : Type u} [Field k] {H P : MvPolynomial (Fin 3) k}
    (hnot : ¬ H ∣ P) :
    Ideal.Quotient.mk (Ideal.span {H}) P ≠ 0 := by
  intro hz
  apply hnot
  have hmem : P ∈ Ideal.span {H} :=
    Ideal.Quotient.eq_zero_iff_mem.mp hz
  obtain ⟨a, ha⟩ := Ideal.mem_span_singleton'.mp hmem
  exact ⟨a, by simpa [mul_comm] using ha.symm⟩

/-- The universal second conic modulo `H` is the conic obtained by evaluating at the tautological
cone coordinates. -/
theorem universalSndConicModulo_eq_sndConicAt
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) :
    universalSndConicModulo F H = sndConicAt F (targetRelationConeCoordinates H) := by
  rw [← map_universalSndConic_aeval F (targetRelationConeCoordinates H)]
  rw [aeval_targetRelationConeCoordinates]
  rfl

/-- Avoiding the discriminant makes the generic conic over the target-relation cone nonsingular.
This packages the quotient-domain and quotient-discriminant bookkeeping around
`sndConicAt_fraction_nonsingular_of_discriminant_ne_zero`. -/
theorem universalSndConicModulo_fraction_nonsingular_of_irreducible_not_dvd_discriminant
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (H : MvPolynomial (Fin 3) k) (hH : Irreducible H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F) :
    let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
    let Q : MvPolynomial (Fin 3) (FractionRing A) :=
      MvPolynomial.map (algebraMap A (FractionRing A)) (universalSndConicModulo F H)
    Q.IsHomogeneous 2 ∧ Q ≠ 0 ∧
      ∀ v : Fin 3 → FractionRing A, v ≠ 0 → MvPolynomial.eval v Q = 0 →
        ∃ j, MvPolynomial.eval v (MvPolynomial.pderiv j Q) ≠ 0 := by
  dsimp only
  let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
  letI : IsDomain A := isDomain_targetRelationCone hH
  have hdiscA :
      aeval (targetRelationConeCoordinates H) (sndConicDiscriminant F) ≠ 0 := by
    change (aeval (targetRelationConeCoordinates H)).toRingHom
      (sndConicDiscriminant F) ≠ 0
    rw [show (aeval (targetRelationConeCoordinates H)).toRingHom =
      Ideal.Quotient.mk (Ideal.span {H}) from aeval_targetRelationConeCoordinates H]
    exact quotient_mk_ne_zero_of_not_dvd hdisc
  have h := sndConicAt_fraction_nonsingular_of_discriminant_ne_zero
    F hF (targetRelationConeCoordinates H) hdiscA
  simpa only [universalSndConicModulo_eq_sndConicAt] using h

/-- The generic conic over an irreducible target relation avoiding the discriminant is
irreducible. -/
theorem irreducible_fraction_universalSndConicModulo_of_irreducible_not_dvd_discriminant
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (H : MvPolynomial (Fin 3) k) (hH : Irreducible H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F) :
    let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
    Irreducible
      (MvPolynomial.map (algebraMap A (FractionRing A))
        (universalSndConicModulo F H)) := by
  dsimp only
  let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
  letI : IsDomain A := isDomain_targetRelationCone hH
  let Q : MvPolynomial (Fin 3) (FractionRing A) :=
    MvPolynomial.map (algebraMap A (FractionRing A)) (universalSndConicModulo F H)
  obtain ⟨hQ, hQ0, hnonsing⟩ :=
    universalSndConicModulo_fraction_nonsingular_of_irreducible_not_dvd_discriminant
      F hF H hH hdisc
  exact TernaryQuadratic.irreducible_of_isHomogeneous_two_of_nonsingular
    Q hQ hQ0 hnonsing

/-- Prime-ideal form of the generic-conic conclusion.  This is the exact generic input one would
combine with a flat/saturated descent theorem before invoking
`isPrime_span_F_rename_inr_of_prime_universalSndConicModulo`. -/
theorem isPrime_span_fraction_universalSndConicModulo_of_irreducible_not_dvd_discriminant
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (H : MvPolynomial (Fin 3) k) (hH : Irreducible H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F) :
    let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
    (Ideal.span
      {MvPolynomial.map (algebraMap A (FractionRing A))
        (universalSndConicModulo F H)}).IsPrime := by
  dsimp only
  let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
  letI : IsDomain A := isDomain_targetRelationCone hH
  let Q : MvPolynomial (Fin 3) (FractionRing A) :=
    MvPolynomial.map (algebraMap A (FractionRing A)) (universalSndConicModulo F H)
  have hQirr : Irreducible Q :=
    irreducible_fraction_universalSndConicModulo_of_irreducible_not_dvd_discriminant
      F hF H hH hdisc
  exact (Ideal.span_singleton_prime hQirr.ne_zero).mpr hQirr.prime

/-! ### The exact affine-cone saturation boundary -/

/-- The canonical map from the conic over the target-relation cone to its generic conic.

Injectivity of this map is exactly contraction of the generic principal ideal back to the cone:
there is no torsion supported over the cone vertex (or another proper closed subset of the cone).
It is the algebraic saturation statement not supplied merely by generic irreducibility. -/
def targetRelationConeConicToGeneric
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) :
    let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
    let Q := universalSndConicModulo F H
    let QK := MvPolynomial.map (algebraMap A (FractionRing A)) Q
    (MvPolynomial (Fin 3) A ⧸ Ideal.span {Q}) →+*
      (MvPolynomial (Fin 3) (FractionRing A) ⧸ Ideal.span {QK}) := by
  dsimp only
  let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
  let Q : MvPolynomial (Fin 3) A := universalSndConicModulo F H
  let QK : MvPolynomial (Fin 3) (FractionRing A) :=
    MvPolynomial.map (algebraMap A (FractionRing A)) Q
  let φ : MvPolynomial (Fin 3) A →+*
      MvPolynomial (Fin 3) (FractionRing A) ⧸ Ideal.span {QK} :=
    (Ideal.Quotient.mk (Ideal.span {QK})).comp
      (MvPolynomial.map (algebraMap A (FractionRing A)))
  exact Ideal.Quotient.lift (Ideal.span {Q}) φ (by
    intro p hp
    obtain ⟨a, rfl⟩ := Ideal.mem_span_singleton'.mp hp
    apply Ideal.Quotient.eq_zero_iff_mem.mpr
    change MvPolynomial.map (algebraMap A (FractionRing A)) (a * Q) ∈
      Ideal.span {QK}
    rw [map_mul]
    apply Ideal.mul_mem_left
    exact Ideal.subset_span (Set.mem_singleton QK))

/-- Tensor-product presentation of the generic conic.  This identifies scalar extension of the
cone conic to its fraction field with the polynomial quotient used above. -/
noncomputable def targetRelationConeConicBaseChangeEquiv
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) :
    let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
    let Q := universalSndConicModulo F H
    let QK := MvPolynomial.map (algebraMap A (FractionRing A)) Q
    FractionRing A ⊗[A] (MvPolynomial (Fin 3) A ⧸ Ideal.span {Q}) ≃ₐ[FractionRing A]
      MvPolynomial (Fin 3) (FractionRing A) ⧸ Ideal.span {QK} := by
  dsimp only
  let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
  let Q : MvPolynomial (Fin 3) A := universalSndConicModulo F H
  let I : Ideal (FractionRing A ⊗[A] MvPolynomial (Fin 3) A) :=
    (Ideal.span {Q}).map Algebra.TensorProduct.includeRight
  let J : Ideal (MvPolynomial (Fin 3) (FractionRing A)) :=
    Ideal.span {MvPolynomial.map (algebraMap A (FractionRing A)) Q}
  let e₁ := Algebra.TensorProduct.tensorQuotientEquiv
    (R := A) (FractionRing A) (MvPolynomial (Fin 3) A) (FractionRing A)
      (Ideal.span {Q})
  have hIJ : J = I.map
      (MvPolynomial.algebraTensorAlgEquiv A (FractionRing A)).toRingHom := by
    dsimp only [I, J]
    rw [Ideal.map_span, Set.image_singleton, Ideal.map_span, Set.image_singleton]
    congr 2
    symm
    change MvPolynomial.algebraTensorAlgEquiv A (FractionRing A) (1 ⊗ₜ[A] Q) =
      MvPolynomial.map (algebraMap A (FractionRing A)) Q
    simp
  let e₂ := Ideal.quotientEquivAlg I J
    (MvPolynomial.algebraTensorAlgEquiv A (FractionRing A)) hIJ
  exact e₁.trans e₂

/-- The tensor-product base-change equivalence carries the canonical `1 ⊗ -` map to
`targetRelationConeConicToGeneric`. -/
theorem targetRelationConeConicBaseChangeEquiv_includeRight
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    (b : MvPolynomial (Fin 3)
        (MvPolynomial (Fin 3) k ⧸ Ideal.span {H}) ⧸
      Ideal.span {universalSndConicModulo F H}) :
    targetRelationConeConicBaseChangeEquiv F H
        (Algebra.TensorProduct.includeRight b) =
      targetRelationConeConicToGeneric F H b := by
  obtain ⟨p, rfl⟩ := Ideal.Quotient.mk_surjective b
  simp [targetRelationConeConicBaseChangeEquiv, targetRelationConeConicToGeneric]

/-- Flatness of the cone conic over the target-relation cone supplies the exact saturation
statement isolated above.  It is tensor-product exactness applied to the injection
`A → FractionRing A`. -/
theorem injective_targetRelationConeConicToGeneric_of_flat
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    (hflat :
      let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
      let Q := universalSndConicModulo F H
      Module.Flat A (MvPolynomial (Fin 3) A ⧸ Ideal.span {Q})) :
    Function.Injective (targetRelationConeConicToGeneric F H) := by
  dsimp only at hflat
  let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
  let Q : MvPolynomial (Fin 3) A := universalSndConicModulo F H
  let B := MvPolynomial (Fin 3) A ⧸ Ideal.span {Q}
  letI : Module.Flat A B := hflat
  let e := targetRelationConeConicBaseChangeEquiv F H
  have hinc : Function.Injective
      (Algebra.TensorProduct.includeRight :
        B →ₐ[A] FractionRing A ⊗[A] B) :=
    Algebra.TensorProduct.includeRight_injective
      (IsFractionRing.injective A (FractionRing A))
  intro x y hxy
  apply hinc
  apply e.injective
  rw [targetRelationConeConicBaseChangeEquiv_includeRight,
    targetRelationConeConicBaseChangeEquiv_includeRight]
  exact hxy

/-- Once the cone-to-generic map is injective, generic nonsingularity descends to primality of the
restricted universal-conic ideal over the cone. -/
theorem isPrime_span_universalSndConicModulo_of_generic_injective
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (H : MvPolynomial (Fin 3) k) (hH : Irreducible H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (hinj : Function.Injective (targetRelationConeConicToGeneric F H)) :
    (Ideal.span {universalSndConicModulo F H}).IsPrime := by
  let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
  letI : IsDomain A := isDomain_targetRelationCone hH
  let Q : MvPolynomial (Fin 3) A := universalSndConicModulo F H
  let QK : MvPolynomial (Fin 3) (FractionRing A) :=
    MvPolynomial.map (algebraMap A (FractionRing A)) Q
  letI hprimeK : (Ideal.span {QK}).IsPrime :=
    isPrime_span_fraction_universalSndConicModulo_of_irreducible_not_dvd_discriminant
      F hF H hH hdisc
  letI : IsDomain
      (MvPolynomial (Fin 3) (FractionRing A) ⧸ Ideal.span {QK}) := inferInstance
  let ψ : (MvPolynomial (Fin 3) A ⧸ Ideal.span {Q}) →+*
      (MvPolynomial (Fin 3) (FractionRing A) ⧸ Ideal.span {QK}) :=
    targetRelationConeConicToGeneric F H
  have hψ : Function.Injective ψ := hinj
  letI : IsDomain (MvPolynomial (Fin 3) A ⧸ Ideal.span {Q}) :=
    Function.Injective.isDomain ψ hψ
  exact (Ideal.Quotient.isDomain_iff_prime (Ideal.span {Q})).mp inferInstance

/-- Full Cox-ideal endpoint under the single explicit cone-saturation hypothesis.  All
discriminant and generic-conic work is discharged; the only extra input is injectivity of
`targetRelationConeConicToGeneric`. -/
theorem isPrime_span_F_rename_inr_of_irreducible_not_dvd_discriminant_of_generic_injective
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (H : MvPolynomial (Fin 3) k) (hH : Irreducible H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (hinj : Function.Injective (targetRelationConeConicToGeneric F H)) :
    (Ideal.span {F, MvPolynomial.rename Sum.inr H}).IsPrime := by
  apply isPrime_span_F_rename_inr_of_prime_universalSndConicModulo F H
  exact isPrime_span_universalSndConicModulo_of_generic_injective
    F hF H hH hdisc hinj

/-- Flat cone-quotient endpoint: generic nonsingularity plus flatness over the target-relation
cone makes the restricted universal-conic ideal prime. -/
theorem isPrime_span_universalSndConicModulo_of_irreducible_not_dvd_discriminant_of_flat
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (H : MvPolynomial (Fin 3) k) (hH : Irreducible H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (hflat :
      let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
      let Q := universalSndConicModulo F H
      Module.Flat A (MvPolynomial (Fin 3) A ⧸ Ideal.span {Q})) :
    (Ideal.span {universalSndConicModulo F H}).IsPrime := by
  apply isPrime_span_universalSndConicModulo_of_generic_injective
    F hF H hH hdisc
  exact injective_targetRelationConeConicToGeneric_of_flat F H hflat

/-- Full Cox-ideal endpoint under flatness of the explicit cone quotient. -/
theorem isPrime_span_F_rename_inr_of_irreducible_not_dvd_discriminant_of_flat
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (H : MvPolynomial (Fin 3) k) (hH : Irreducible H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F)
    (hflat :
      let A := MvPolynomial (Fin 3) k ⧸ Ideal.span {H}
      let Q := universalSndConicModulo F H
      Module.Flat A (MvPolynomial (Fin 3) A ⧸ Ideal.span {Q})) :
    (Ideal.span {F, MvPolynomial.rename Sum.inr H}).IsPrime := by
  apply isPrime_span_F_rename_inr_of_prime_universalSndConicModulo F H
  exact isPrime_span_universalSndConicModulo_of_irreducible_not_dvd_discriminant_of_flat
    F hF H hH hdisc hflat

end

end BConicBundleMultisections
