/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PrimeSpanPairDescent
public import BConicBundleMultisections.SndConicDiscriminant
public import Mathlib.RingTheory.Polynomial.Quotient

/-!
# Prime vertical complete intersections

This file packages the quotient bookkeeping behind a vertical complete intersection
`V(F,H(y))`.  Splitting the two Cox-variable blocks identifies its coordinate ring with a ternary
polynomial ring over `k[y]/(H)`, modulo the image of the universal conic.  Consequently primality
reduces exactly to primality of that quotient-coefficient conic equation.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial

/-- The universal second conic after restricting the second projective coordinate to the affine
cone over `H = 0`. -/
def universalSndConicModulo
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) :
    MvPolynomial (Fin 3) (MvPolynomial (Fin 3) k ⧸ Ideal.span {H}) :=
  MvPolynomial.map (Ideal.Quotient.mk (Ideal.span {H})) (universalSndConic F)

/-- Splitting the Cox variables presents `F` as its universal second conic. -/
theorem sumAlgEquiv_eq_universalSndConic
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial.sumAlgEquiv k (Fin 3) (Fin 3) F = universalSndConic F := by
  induction F using MvPolynomial.induction_on with
  | C a => simp [universalSndConic]
  | add P Q hP hQ => simp [universalSndConic, hP, hQ]
  | mul_X P z hP =>
      rcases z with i | j
      · simp [universalSndConic, hP]
      · simp [universalSndConic, hP]

set_option maxHeartbeats 800000 in
-- Elaborating the nested Cox-splitting and coefficient-quotient maps exceeds the default budget.
/-- If the restricted universal-conic ideal over the coefficient quotient by `H` is prime, then
the Cox ideal `(F,H(y))` is prime. -/
theorem isPrime_span_F_rename_inr_of_prime_universalSndConicModulo
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k)
    (hconic : (Ideal.span {universalSndConicModulo F H}).IsPrime) :
    (Ideal.span {F, MvPolynomial.rename Sum.inr H}).IsPrime := by
  let Ry := MvPolynomial (Fin 3) k
  let I : Ideal Ry := Ideal.span {H}
  let A := Ry ⧸ I
  let Rxy := MvPolynomial (BiprojectiveCoordinate 2 2) k
  let Riter := MvPolynomial (Fin 3) Ry
  let e : Rxy ≃+* Riter :=
    (MvPolynomial.sumAlgEquiv k (Fin 3) (Fin 3)).toRingEquiv
  let φ : Riter →+* MvPolynomial (Fin 3) A :=
    MvPolynomial.map (Ideal.Quotient.mk I)
  have hφsurj : Function.Surjective φ :=
    MvPolynomial.map_surjective _ Ideal.Quotient.mk_surjective
  have hφF : φ (e F) = universalSndConicModulo F H := by
    change MvPolynomial.map (Ideal.Quotient.mk I)
      (MvPolynomial.sumAlgEquiv k (Fin 3) (Fin 3) F) = _
    rw [sumAlgEquiv_eq_universalSndConic]
    rfl
  have hφker : RingHom.ker φ = Ideal.span {MvPolynomial.C H} := by
    dsimp only [φ]
    rw [MvPolynomial.ker_map, Ideal.mk_ker]
    change Ideal.map MvPolynomial.C (Ideal.span {H}) = _
    rw [Ideal.map_span]
    simp
  have himagePrime : (Ideal.span {φ (e F)}).IsPrime := by
    rw [hφF]
    exact hconic
  have hiter : (Ideal.span {e F, MvPolynomial.C H}).IsPrime :=
    isPrime_span_pair_of_surjective
      (R := Riter) (S := MvPolynomial (Fin 3) A)
      φ hφsurj (e F) (MvPolynomial.C H) hφker himagePrime
  have herename : e (MvPolynomial.rename Sum.inr H) = MvPolynomial.C H := by
    change MvPolynomial.sumAlgEquiv k (Fin 3) (Fin 3)
      (MvPolynomial.rename Sum.inr H) = _
    have h := DFunLike.congr_fun
      (MvPolynomial.sumAlgEquiv_comp_rename_inr (R := k) (S₁ := Fin 3) (S₂ := Fin 3)) H
    simpa using h
  have hmap : Ideal.map e (Ideal.span {F, MvPolynomial.rename Sum.inr H}) =
      Ideal.span {e F, MvPolynomial.C H} := by
    rw [Ideal.map_span, Set.image_pair, herename]
  have hcomap : Ideal.comap e (Ideal.span {e F, MvPolynomial.C H}) =
      Ideal.span {F, MvPolynomial.rename Sum.inr H} := by
    rw [← hmap, Ideal.comap_map_of_bijective e e.bijective]
  rw [← hcomap]
  exact hiter.comap e

end

end BConicBundleMultisections
