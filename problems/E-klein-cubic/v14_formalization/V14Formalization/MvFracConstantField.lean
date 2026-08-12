/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.EllipticPolynomialConstancy
import Mathlib.FieldTheory.RatFunc.IntermediateField
import Mathlib.RingTheory.Algebraic.Basic
import Mathlib.RingTheory.Algebraic.Integral
import Mathlib.RingTheory.Localization.FractionRing

/-!
# Relative constants of pure transcendental function fields

Algebraic elements of a finite-variable rational function field are exactly
the image of the coefficient field.  No algebraic closure is used.
-/

noncomputable section

open Polynomial

namespace V14Formalization.MvFracConstantField

open EllipticPolynomialConstancy

variable {K : Type*} [Field K]

theorem ratFunc_isAlgebraic_iff_constant (x : RatFunc K) :
    IsAlgebraic K x ↔ ∃ a : K, x = RatFunc.C a := by
  constructor
  · intro hx
    by_contra h
    exact (RatFunc.transcendental_of_ne_C (f := x) h) hx
  · rintro ⟨a, rfl⟩
    simpa [RatFunc.algebraMap_eq_C] using (isAlgebraic_algebraMap (A := RatFunc K) a)

lemma mvFractionSuccRingEquiv_algebraMap (n : ℕ) (c : K) :
    mvFractionSuccRingEquiv (K := K) n (algebraMap K (MvFrac K (n + 1)) c) =
      algebraMap K (RatFunc (MvFrac K n)) c := by
  simpa [RatFunc.algebraMap_eq_C,
    IsScalarTower.algebraMap_apply K (MvFrac K n) (RatFunc (MvFrac K n))] using
    mvSuccToRatFunc_algebraMap_base (K := K) n c

noncomputable def mvFractionSuccAlgEquiv (n : ℕ) :
    MvFrac K (n + 1) ≃ₐ[K] RatFunc (MvFrac K n) :=
  AlgEquiv.ofRingEquiv (f := mvFractionSuccRingEquiv (K := K) n)
    (fun c => mvFractionSuccRingEquiv_algebraMap n c)

lemma isAlgebraic_map_of_isAlgebraic_mvSucc (n : ℕ) {x : MvFrac K (n + 1)}
    (hx : IsAlgebraic K x) :
    IsAlgebraic K (mvFractionSuccRingEquiv (K := K) n x) := by
  obtain ⟨p, hp0, hp⟩ := hx
  refine ⟨p, hp0, ?_⟩
  have hφ := aeval_algHom_apply (mvFractionSuccAlgEquiv (K := K) n).toAlgHom x p
  change aeval (mvFractionSuccAlgEquiv (K := K) n x) p = 0
  simpa [hp, map_zero] using hφ

theorem mvFrac_isAlgebraic_iff_constant (n : ℕ) (x : MvFrac K n) :
    IsAlgebraic K x ↔ ∃ a : K, x = algebraMap K (MvFrac K n) a := by
  induction n with
  | zero =>
      constructor
      · intro _
        let φ := mvFractionZeroAlgEquiv (K := K)
        refine ⟨φ x, ?_⟩
        apply φ.injective
        simp [φ]
      · rintro ⟨a, rfl⟩
        exact isAlgebraic_algebraMap a
  | succ n ih =>
      constructor
      · intro hx
        let φ := mvFractionSuccRingEquiv (K := K) n
        have hxK : IsAlgebraic K (φ x) := isAlgebraic_map_of_isAlgebraic_mvSucc n hx
        have hxF : IsAlgebraic (MvFrac K n) (φ x) := hxK.tower_top (MvFrac K n)
        obtain ⟨a, ha⟩ := (ratFunc_isAlgebraic_iff_constant (φ x)).mp hxF
        have haAlg : IsAlgebraic K a := by
          have : IsAlgebraic K (RatFunc.C a) := by
            simpa [ha] using hxK
          simpa [RatFunc.algebraMap_eq_C] using
            (isAlgebraic_algebraMap_iff
              (RatFunc.C_injective (K := MvFrac K n))).1 this
        obtain ⟨b, hb⟩ := (ih a).mp haAlg
        refine ⟨b, ?_⟩
        apply φ.injective
        change mvSuccToRatFunc (K := K) n x =
          mvSuccToRatFunc (K := K) n (algebraMap K (MvFrac K (n + 1)) b)
        have hx' : mvSuccToRatFunc (K := K) n x = RatFunc.C a := by
          simpa [φ] using ha
        rw [hx', hb, mvSuccToRatFunc_algebraMap_base]
      · rintro ⟨a, rfl⟩
        exact isAlgebraic_algebraMap a

/-- Coefficient extension of a finite-variable rational function field. -/
def mvFracBaseChange {L : Type*} [Field L] (f : K →+* L)
    (hf : Function.Injective f) (n : ℕ) :
    MvFrac K n →+* MvFrac L n :=
  IsFractionRing.map (K := MvFrac K n) (L := MvFrac L n)
    (j := MvPolynomial.map (σ := Fin n) f)
    (MvPolynomial.map_injective (σ := Fin n) f hf)

lemma mvFracBaseChange_algebraMap {L : Type*} [Field L] (f : K →+* L)
    (hf : Function.Injective f) (n : ℕ) (p : MvPolynomial (Fin n) K) :
    mvFracBaseChange f hf n
        (algebraMap (MvPolynomial (Fin n) K) (MvFrac K n) p) =
      algebraMap (MvPolynomial (Fin n) L) (MvFrac L n) (MvPolynomial.map f p) := by
  rw [mvFracBaseChange]
  exact IsLocalization.map_eq _ p

lemma mvFracBaseChange_algebraMap_base {L : Type*} [Field L] (f : K →+* L)
    (hf : Function.Injective f) (n : ℕ) (a : K) :
    mvFracBaseChange f hf n (algebraMap K (MvFrac K n) a) =
      algebraMap L (MvFrac L n) (f a) := by
  rw [IsScalarTower.algebraMap_apply K (MvPolynomial (Fin n) K) (MvFrac K n),
    mvFracBaseChange_algebraMap]
  simp [MvPolynomial.algebraMap_eq, MvPolynomial.map_C,
    IsScalarTower.algebraMap_apply L (MvPolynomial (Fin n) L) (MvFrac L n)]

lemma mvFracBaseChange_injective {L : Type*} [Field L] (f : K →+* L)
    (hf : Function.Injective f) (n : ℕ) :
    Function.Injective (mvFracBaseChange f hf n) :=
  RingHom.injective _

/-- The coefficient base-change map as a `K`-algebra homomorphism. -/
def mvFracBaseChangeAlg {L : Type*} [Field L] [Algebra K L] (n : ℕ) :
    MvFrac K n →ₐ[K] MvFrac L n where
  toRingHom :=
    mvFracBaseChange (algebraMap K L)
      (FaithfulSMul.algebraMap_injective K L) n
  commutes' a :=
    mvFracBaseChange_algebraMap_base
      (algebraMap K L) (FaithfulSMul.algebraMap_injective K L) n a

/-- If an element becomes a constant after injective coefficient extension along
an algebraic field map, then it was already a base-field constant. -/
theorem mvFrac_eq_constant_of_map_eq_constant
    {L : Type*} [Field L] [Algebra K L] [Algebra.IsAlgebraic K L]
    (n : ℕ)
    (f : MvFrac K n →ₐ[K] MvFrac L n)
    (hf : Function.Injective f)
    (x : MvFrac K n) (a : L)
    (h : f x = algebraMap L (MvFrac L n) a) :
    ∃ b : K, x = algebraMap K (MvFrac K n) b := by
  have hL : IsAlgebraic L (f x) := by
    rw [h]
    exact isAlgebraic_algebraMap a
  have hK : IsAlgebraic K (f x) := hL.restrictScalars K
  exact (mvFrac_isAlgebraic_iff_constant n x).mp
    ((isAlgebraic_algHom_iff f hf).mp hK)

/-- Specialization of the previous corollary to coefficient base change. -/
theorem mvFrac_eq_constant_of_baseChange_eq_constant
    {L : Type*} [Field L] [Algebra K L] [Algebra.IsAlgebraic K L]
    (n : ℕ) (x : MvFrac K n) (a : L)
    (h : mvFracBaseChange (algebraMap K L)
        (FaithfulSMul.algebraMap_injective K L) n x =
      algebraMap L (MvFrac L n) a) :
    ∃ b : K, x = algebraMap K (MvFrac K n) b :=
  mvFrac_eq_constant_of_map_eq_constant (L := L) n
    (mvFracBaseChangeAlg (L := L) n)
    (by
      change Function.Injective (mvFracBaseChange (algebraMap K L)
        (FaithfulSMul.algebraMap_injective K L) n)
      exact mvFracBaseChange_injective _ _ n) x a h

end V14Formalization.MvFracConstantField
