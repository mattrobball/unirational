/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.Algebra.Ring.Hom.InjSurj
public import Mathlib.RingTheory.Ideal.Quotient.Operations
public import Mathlib.RingTheory.Localization.Basic
public import Mathlib.RingTheory.UniqueFactorizationDomain.Basic

/-!
# Torsion-free principal quotients over a UFD

This file isolates the denominator-clearing argument used for a vertical complete intersection.
Let a UFD `R` act on a domain `T`, and let `f : T`.  If the image in `T` of every irreducible
element of `R` is prime and does not divide `f`, then `T/(f)` is torsion-free over `R`.

The proof is elementary.  If `p g = f h`, primality of the image of `p` and `p ∤ f` force
`p ∣ h`; cancellation in the domain then gives `g ∈ (f)`.  Factorization induction in the UFD
extends this cancellation from irreducibles to every nonzero scalar.
-/

@[expose] public section

namespace BConicBundleMultisections

universe u v

/-- An irreducible scalar acts injectively on a principal quotient when its image is prime and
does not divide the defining equation. -/
theorem smul_eq_zero_in_quotient_span_singleton_of_prime_not_dvd
    {R : Type u} {T : Type v}
    [CommRing R] [IsDomain R] [CommRing T] [IsDomain T] [Algebra R T]
    (f : T) (p : R)
    (hp : Prime (algebraMap R T p))
    (hpdvd : ¬ algebraMap R T p ∣ f)
    (z : T ⧸ Ideal.span ({f} : Set T))
    (hz : p • z = 0) :
    z = 0 := by
  obtain ⟨g, rfl⟩ := Ideal.Quotient.mk_surjective z
  have hmap : algebraMap R (T ⧸ Ideal.span ({f} : Set T)) p =
      Ideal.Quotient.mk (Ideal.span ({f} : Set T)) (algebraMap R T p) := rfl
  have hmem : algebraMap R T p * g ∈ Ideal.span ({f} : Set T) := by
    rw [← Ideal.Quotient.eq_zero_iff_mem]
    rw [Algebra.smul_def, hmap, ← map_mul] at hz
    exact hz
  have hdvd : f ∣ algebraMap R T p * g :=
    Ideal.mem_span_singleton.mp hmem
  obtain ⟨h, hh⟩ := hdvd
  have hq_dvd : algebraMap R T p ∣ f * h := by
    exact ⟨g, hh.symm⟩
  have hq_h : algebraMap R T p ∣ h :=
    (hp.2.2 f h hq_dvd).resolve_left hpdvd
  obtain ⟨h', rfl⟩ := hq_h
  have hg : g = f * h' := by
    apply mul_left_cancel₀ hp.ne_zero
    calc
      algebraMap R T p * g = f * (algebraMap R T p * h') := by
        simpa only using hh
      _ = algebraMap R T p * (f * h') := by
        ac_rfl
  rw [Ideal.Quotient.eq_zero_iff_mem]
  exact Ideal.mem_span_singleton.mpr ⟨h', hg⟩

/-- If every irreducible scalar has prime image not dividing `f`, then the principal quotient by
`f` has no scalar torsion. -/
theorem noZeroSMulDivisors_quotient_span_singleton_of_irreducibles
    {R : Type u} {T : Type v}
    [CommRing R] [IsDomain R] [UniqueFactorizationMonoid R]
    [CommRing T] [IsDomain T] [Algebra R T]
    (f : T)
    (hprime : ∀ p : R, Irreducible p → Prime (algebraMap R T p))
    (hnotdvd : ∀ p : R, Irreducible p → ¬ algebraMap R T p ∣ f) :
    NoZeroSMulDivisors R (T ⧸ Ideal.span ({f} : Set T)) := by
  rw [noZeroSMulDivisors_iff_right_eq_zero_of_smul]
  intro r hr
  induction r using WfDvdMonoid.induction_on_irreducible with
  | zero => exact (hr rfl).elim
  | unit u hu =>
      intro z hz
      have hu' : IsUnit (algebraMap R
          (T ⧸ Ideal.span ({f} : Set T)) u) := hu.map _
      have hz' : algebraMap R
          (T ⧸ Ideal.span ({f} : Set T)) u * z = 0 := by
        simpa only [Algebra.smul_def] using hz
      exact (IsUnit.mul_right_eq_zero hu').mp hz'
  | mul a p ha hp ih =>
      intro z hz
      have hpz : p • (a • z) = 0 := by
        simpa only [mul_smul] using hz
      have haz : a • z = 0 :=
        smul_eq_zero_in_quotient_span_singleton_of_prime_not_dvd
          f p (hprime p hp) (hnotdvd p hp) (a • z) hpz
      exact ih ha z haz

/-- Torsion-free module form of the preceding cancellation theorem. -/
theorem isTorsionFree_quotient_span_singleton_of_irreducibles
    {R : Type u} {T : Type v}
    [CommRing R] [IsDomain R] [UniqueFactorizationMonoid R]
    [CommRing T] [IsDomain T] [Algebra R T]
    (f : T)
    (hprime : ∀ p : R, Irreducible p → Prime (algebraMap R T p))
    (hnotdvd : ∀ p : R, Irreducible p → ¬ algebraMap R T p ∣ f) :
    Module.IsTorsionFree R (T ⧸ Ideal.span ({f} : Set T)) := by
  letI : NoZeroSMulDivisors R (T ⧸ Ideal.span ({f} : Set T)) :=
    noZeroSMulDivisors_quotient_span_singleton_of_irreducibles
      f hprime hnotdvd
  infer_instance

/-- A torsion-free algebra embeds into every localization which inverts the images of all
nonzero base scalars. -/
theorem injective_algebraMap_localization_at_base_nonZeroDivisors
    {R : Type u} {B C : Type v}
    [CommRing R] [IsDomain R] [CommRing B] [Algebra R B]
    [NoZeroSMulDivisors R B] [CommRing C] [Algebra B C]
    [IsLocalization
      ((nonZeroDivisors R).map (algebraMap R B).toMonoidHom) C] :
    Function.Injective (algebraMap B C) := by
  apply IsLocalization.injective
    (M := (nonZeroDivisors R).map (algebraMap R B).toMonoidHom) C
  rintro _ ⟨r, hr, rfl⟩
  rw [mem_nonZeroDivisors_iff_left]
  intro b hb
  have happ : (algebraMap R B).toMonoidHom r = algebraMap R B r := rfl
  rw [happ] at hb
  have hmul : algebraMap R B r * b = 0 := by
    exact hb
  have hsmul : r • b = 0 := by
    simpa only [Algebra.smul_def] using hmul
  apply (noZeroSMulDivisors_iff_right_eq_zero_of_smul.mp inferInstance)
    (r : R) (mem_nonZeroDivisors_iff_ne_zero.mp hr) b
  exact hsmul

/-- If that scalar localization is a domain, torsion-free descent makes the original algebra a
domain as well. -/
theorem isDomain_of_isLocalization_at_base_nonZeroDivisors
    {R : Type u} {B C : Type v}
    [CommRing R] [IsDomain R] [CommRing B] [Algebra R B]
    [NoZeroSMulDivisors R B] [CommRing C] [IsDomain C] [Algebra B C]
    [IsLocalization
      ((nonZeroDivisors R).map (algebraMap R B).toMonoidHom) C] :
    IsDomain B := by
  exact Function.Injective.isDomain (algebraMap B C)
    (injective_algebraMap_localization_at_base_nonZeroDivisors
      (R := R) (B := B) (C := C))

end BConicBundleMultisections
