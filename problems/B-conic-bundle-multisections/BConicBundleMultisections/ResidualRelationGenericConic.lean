/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.HomogeneousFactor
public import BConicBundleMultisections.ResidualDiscriminantGenericConic

/-!
# The generic conic over an irreducible residual relation

If a homogeneous relation `H` vanishes on the tangent-residual coordinates while the pulled-back
second-conic discriminant does not vanish, then `H` cannot divide that discriminant.  For an
irreducible `H`, the affine cone ring `k[y]/(H)` is a domain and the discriminant remains nonzero
there.  Consequently the conic over its fraction field is nonsingular.

This is the exact algebraic generic-fibre input in the discriminant-avoidance route to residual
horizontality.  It contains no assertion that the corresponding total space is integral or that
the residual component exhausts it; those are separate geometric steps.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u v

open _root_.MvPolynomial

/-- A polynomial which vanishes after evaluation cannot divide one whose evaluation is nonzero. -/
theorem not_dvd_of_aeval_eq_zero_of_aeval_ne_zero
    {k : Type u} [Field k] {S : Type v} [CommRing S] [Algebra k S]
    {H D : MvPolynomial (Fin 3) k} {y : Fin 3 → S}
    (hH : aeval y H = 0) (hD : aeval y D ≠ 0) :
    ¬ H ∣ D := by
  rintro ⟨G, rfl⟩
  apply hD
  rw [map_mul, hH, zero_mul]

/-- G4 discriminant avoidance rules out divisibility by every vanishing residual relation. -/
theorem not_dvd_sndConicDiscriminant_of_residual_relation
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k)
    {H : MvPolynomial (Fin 3) k}
    (hH : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0)
    (havoid : ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v) :
    ¬ H ∣ sndConicDiscriminant F := by
  exact not_dvd_of_aeval_eq_zero_of_aeval_ne_zero hH havoid

/-- Every nonzero positive-degree homogeneous relation contains an irreducible homogeneous
relation which is still invisible to the residual map and does not divide the conic
discriminant. -/
theorem exists_irreducible_homogeneous_residual_relation_not_dvd_discriminant
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k)
    {d : ℕ} {P : MvPolynomial (Fin 3) k}
    (hP : P.IsHomogeneous d) (hP0 : P ≠ 0) (hd : 0 < d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) P = 0)
    (havoid : ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v) :
    ∃ H : MvPolynomial (Fin 3) k, ∃ e : ℕ,
      Irreducible H ∧ H.IsHomogeneous e ∧ 0 < e ∧ H ∣ P ∧
        aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0 ∧
          ¬ H ∣ sndConicDiscriminant F := by
  obtain ⟨H, e, hHirr, hHhom, he, hHdiv, hHeval⟩ :=
    MvPolynomial.exists_irreducible_isHomogeneous_dvd_aeval_eq_zero
      hP hP0 hd (residualYCoordsOn p₀ q₀ r N F v) hvan
  exact ⟨H, e, hHirr, hHhom, he, hHdiv, hHeval,
    not_dvd_sndConicDiscriminant_of_residual_relation
      p₀ q₀ r N F v hHeval havoid⟩

/-- An irreducible relation generates a prime principal ideal. -/
theorem isPrime_span_singleton_of_irreducible
    {k : Type u} [Field k] {H : MvPolynomial (Fin 3) k}
    (hH : Irreducible H) :
    (Ideal.span ({H} : Set (MvPolynomial (Fin 3) k))).IsPrime := by
  exact (Ideal.span_singleton_prime hH.ne_zero).mpr hH.prime

/-- If `H` does not divide `D`, then `D` remains nonzero modulo the irreducible relation `H`. -/
theorem quotient_mk_ne_zero_of_irreducible_of_not_dvd
    {k : Type u} [Field k] {H D : MvPolynomial (Fin 3) k}
    (_hH : Irreducible H) (hD : ¬ H ∣ D) :
    Ideal.Quotient.mk (Ideal.span ({H} : Set (MvPolynomial (Fin 3) k))) D ≠ 0 := by
  intro hzero
  apply hD
  exact Ideal.mem_span_singleton.mp (Ideal.Quotient.eq_zero_iff_mem.mp hzero)

/-- The coordinate evaluation into `k[y]/(H)` is the quotient map. -/
theorem aeval_quotient_mk_X
    {k : Type u} [Field k] (H P : MvPolynomial (Fin 3) k) :
    aeval
        (fun i ↦ Ideal.Quotient.mk
          (Ideal.span ({H} : Set (MvPolynomial (Fin 3) k))) (MvPolynomial.X i))
        P =
      Ideal.Quotient.mk (Ideal.span ({H} : Set (MvPolynomial (Fin 3) k))) P := by
  induction P using MvPolynomial.induction_on with
  | C a =>
      rw [MvPolynomial.aeval_C]
      rw [show MvPolynomial.C a =
        algebraMap k (MvPolynomial (Fin 3) k) a from rfl,
        Ideal.Quotient.mk_algebraMap]
  | add P Q hP hQ => simp [hP, hQ]
  | mul_X P i hP => simp [hP]

/-- Over the affine cone of an irreducible residual relation, G4 makes the generic conic
nonsingular. -/
theorem sndConicAt_relationCone_fraction_nonsingular
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    {H : MvPolynomial (Fin 3) k} (hH : Irreducible H)
    (hdisc : ¬ H ∣ sndConicDiscriminant F) :
    let A := MvPolynomial (Fin 3) k ⧸
      Ideal.span ({H} : Set (MvPolynomial (Fin 3) k))
    let y : Fin 3 → A := fun i ↦
      Ideal.Quotient.mk (Ideal.span ({H} : Set (MvPolynomial (Fin 3) k)))
        (MvPolynomial.X i)
    let Q : MvPolynomial (Fin 3) (FractionRing A) :=
      MvPolynomial.map (algebraMap A (FractionRing A)) (sndConicAt F y)
    Q.IsHomogeneous 2 ∧ Q ≠ 0 ∧
      ∀ x : Fin 3 → FractionRing A, x ≠ 0 → MvPolynomial.eval x Q = 0 →
        ∃ j, MvPolynomial.eval x (MvPolynomial.pderiv j Q) ≠ 0 := by
  let I : Ideal (MvPolynomial (Fin 3) k) := Ideal.span {H}
  let A := MvPolynomial (Fin 3) k ⧸ I
  let y : Fin 3 → A := fun i ↦ Ideal.Quotient.mk I (MvPolynomial.X i)
  letI : I.IsPrime := isPrime_span_singleton_of_irreducible hH
  letI : IsDomain A := (Ideal.Quotient.isDomain_iff_prime I).mpr inferInstance
  have hdiscA : aeval y (sndConicDiscriminant F) ≠ 0 := by
    rw [show aeval y (sndConicDiscriminant F) =
      Ideal.Quotient.mk I (sndConicDiscriminant F) by
        simpa only [I, y] using
          aeval_quotient_mk_X H (sndConicDiscriminant F)]
    exact quotient_mk_ne_zero_of_irreducible_of_not_dvd hH hdisc
  exact sndConicAt_fraction_nonsingular_of_discriminant_ne_zero F hF y hdiscA

end

end BConicBundleMultisections
