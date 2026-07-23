/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.RingTheory.Jacobson.Ring
public import Mathlib.RingTheory.KrullDimension.Field
public import Mathlib.RingTheory.KrullDimension.Polynomial
public import Mathlib.RingTheory.KrullDimension.Regular

/-!
# Heights of maximal ideals in finite-variable polynomial rings

This file isolates the dimension-theoretic fact that every maximal ideal of a polynomial ring
in finitely many variables over a field has height equal to the number of variables.  The
statement is independent of the biprojective chart application and is therefore kept in a
generic polynomial-ring module.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

namespace MvPolynomial

private theorem height_eq_fin_of_isMaximal
    (k : Type u) [Field k] :
    ∀ (N : ℕ) (M : Ideal (MvPolynomial (Fin N) k)),
      [M.IsMaximal] → M.height = N := by
  intro N
  induction N with
  | zero =>
      intro M hM
      letI : M.IsMaximal := hM
      let e := MvPolynomial.isEmptyRingEquiv k (Fin 0)
      let P : Ideal k := M.map e
      haveI : P.IsMaximal := inferInstance
      rw [← e.height_map M]
      change P.height = 0
      rcases P.eq_bot_or_top with hP0 | hP1
      · simp [hP0]
      · exact (this.ne_top hP1).elim
  | succ N ih =>
      intro M hM
      letI : M.IsMaximal := hM
      let e := (MvPolynomial.finSuccEquiv k N).toRingEquiv
      let P : Ideal (Polynomial (MvPolynomial (Fin N) k)) := M.map e
      have hP : P.height = M.height := e.height_map M
      let p : Ideal (MvPolynomial (Fin N) k) := P.under (MvPolynomial (Fin N) k)
      haveI : P.IsMaximal := inferInstance
      haveI : p.IsMaximal := by
        change (P.comap Polynomial.C).IsMaximal
        exact Polynomial.isMaximal_comap_C_of_isJacobsonRing P
      have hp : p.height = N := ih p
      rw [← hP, Polynomial.height_eq_height_add_one p P, hp]
      simp

/-- Every maximal ideal of a finite-variable polynomial ring over a field has height equal to
the number of variables. -/
theorem height_eq_natCard_of_isMaximal
    {k : Type u} [Field k] {ι : Type*} [Finite ι]
    (M : Ideal (MvPolynomial ι k)) [M.IsMaximal] :
    M.height = Nat.card ι := by
  let e : ι ≃ Fin (Nat.card ι) := Finite.equivFin ι
  let φ := (MvPolynomial.renameEquiv k e).toRingEquiv
  rw [← φ.height_map M]
  exact height_eq_fin_of_isMaximal k (Nat.card ι) (M.map φ)

end MvPolynomial

end

end BConicBundleMultisections
