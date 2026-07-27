/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.Algebra.Algebra.Defs
public import Mathlib.Algebra.CharZero.Defs
public import Mathlib.Algebra.GroupWithZero.Basic
public import Mathlib.Algebra.Order.Ring.Nat
public import Mathlib.Algebra.Ring.Hom.Defs
public import Mathlib.Tactic.FieldSimp
public import Mathlib.Tactic.LinearCombination
public import Mathlib.Tactic.NormNum.Basic
public import Mathlib.Tactic.Ring

/-!
# `2 ≠ 0` and `3 ≠ 0`: the characteristic hypothesis of this project

The project used to carry `[CharZero k]`.  What its proofs actually consume is much less:

* `(2 : k) ≠ 0`, in every polar-form identity `B(v, v) = 2 Q(v)` and in the polar/gradient
  dictionary;
* `(3 : k) ≠ 0`, in the Hesse pencil (whose partials all carry a factor `3`) and in the two
  short-Weierstrass residual certificates.

Both are `NeZero` statements about a numeral, so both are typeclass hypotheses:
`[NeZero (2 : k)] [NeZero (3 : k)]`.  Together they say exactly that `ringChar k ∤ 6`, and
Mathlib's `two_ne_zero` and `three_ne_zero` are stated with precisely these instances, so they
fire without any glue.

For this to be a genuine weakening, `[CharZero k]` must still imply both — see the next section:
it does for `2` out of the box, and for `3` only after the instance added below.

This file collects the glue that `CharZero` used to provide for free.

## Numerals beyond `2` and `3`

`norm_num` cannot prove `(4 : k) ≠ 0` without `CharZero`: numeral disequality in a general
semiring is not decidable by normalization.  Under `ringChar k ∤ 6`, though, every numeral whose
prime factors lie in `{2, 3}` is nonzero, and the ones this project needs are listed below.  Each
is proved by factoring the numeral and using that a field has no zero divisors — the factorization
itself is a ring identity, which `norm_num` *can* do.

## Transfer along an algebra map

`CharZero` transfers along an injective ring hom (`charZero_of_injective_algebraMap`); so does
`NeZero` of a numeral, for the same one-line reason, and `neZero_ofNat_of_injective_algebraMap`
below is that reason.  It is used where the project passes from `k` to a residue field or to a
chart ring.
-/

@[expose] public section

namespace BConicBundleMultisections

/-! ### `CharZero` really is stronger

Mathlib has `CharZero.NeZero.two : NeZero (2 : R)` as an instance, and `NeZero.charZero_ofNat`
covers every numeral — but the latter is stated for the `OfNat` instance that
`AddMonoidWithOne` provides, and does not fire for `(3 : k)` as elaborated over a field in this
development (checked: `example (k) [Field k] [CharZero k] : NeZero (3 : k) := inferInstance`
fails).  Without the instance below, `[CharZero k]` would *not* imply `[NeZero (3 : k)]` for
instance resolution, and the declarations that still carry `CharZero` — together with the
comparator wrapper in `Solution.lean` — could not call the ones that carry `NeZero (3 : k)`.
So the weakening really would not be a weakening.  This restores that. -/

instance (priority := 100) NeZero.charZeroThree {R : Type*} [AddMonoidWithOne R] [CharZero R] :
    NeZero (3 : R) where
  out := by rw [← Nat.cast_ofNat, Nat.cast_ne_zero]; decide

/-- The same for `5`, which the concrete bidegree-`(2,3)` witness of `Bidegree23Example` needs:
its Vandermonde elimination produces the relation `3 x₀² = 5 x₂²`. -/
instance (priority := 100) NeZero.charZeroFive {R : Type*} [AddMonoidWithOne R] [CharZero R] :
    NeZero (5 : R) where
  out := by rw [← Nat.cast_ofNat, Nat.cast_ne_zero]; decide

/-! ### Transfer along an injective algebra map -/

/-- A numeral that is nonzero downstairs is nonzero upstairs, along any injective ring hom.  This
is the `NeZero` analogue of `charZero_of_injective_algebraMap`. -/
theorem neZero_ofNat_of_injective_algebraMap {R A : Type*} [CommSemiring R] [Semiring A]
    [Algebra R A]
    (hinj : Function.Injective (algebraMap R A)) (n : ℕ) [n.AtLeastTwo]
    [NeZero (ofNat(n) : R)] : NeZero (ofNat(n) : A) :=
  ⟨fun h => NeZero.ne (ofNat(n) : R) (hinj (by rw [map_ofNat, h, map_zero]))⟩

/-- `NeZero (2 : A)` from `NeZero (2 : R)`, along an injective algebra map. -/
theorem neZero_two_of_injective_algebraMap {R A : Type*} [CommSemiring R] [Semiring A]
    [Algebra R A]
    (hinj : Function.Injective (algebraMap R A)) [NeZero (2 : R)] : NeZero (2 : A) :=
  neZero_ofNat_of_injective_algebraMap hinj 2

/-- `NeZero (3 : A)` from `NeZero (3 : R)`, along an injective algebra map. -/
theorem neZero_three_of_injective_algebraMap {R A : Type*} [CommSemiring R] [Semiring A]
    [Algebra R A]
    (hinj : Function.Injective (algebraMap R A)) [NeZero (3 : R)] : NeZero (3 : A) :=
  neZero_ofNat_of_injective_algebraMap hinj 3

/-! ### Numerals with prime factors in `{2, 3}`

Only the numerals actually occurring in the project's proofs are listed.  Each is a product of
`2`s and `3`s, so each is nonzero in a domain in which `2` and `3` are. -/

section Numerals

variable {k : Type*} [Field k]

/-- `4 = 2 * 2`. -/
theorem four_ne_zero' [NeZero (2 : k)] : (4 : k) ≠ 0 := by
  have h : (4 : k) = 2 * 2 := by norm_num
  rw [h]; exact mul_ne_zero two_ne_zero two_ne_zero

/-- `6 = 2 * 3`. -/
theorem six_ne_zero' [NeZero (2 : k)] [NeZero (3 : k)] : (6 : k) ≠ 0 := by
  have h : (6 : k) = 2 * 3 := by norm_num
  rw [h]; exact mul_ne_zero two_ne_zero three_ne_zero

/-- `8 = 4 * 2`. -/
theorem eight_ne_zero' [NeZero (2 : k)] : (8 : k) ≠ 0 := by
  have h : (8 : k) = 4 * 2 := by norm_num
  rw [h]; exact mul_ne_zero four_ne_zero' two_ne_zero

/-- `9 = 3 * 3`. -/
theorem nine_ne_zero' [NeZero (3 : k)] : (9 : k) ≠ 0 := by
  have h : (9 : k) = 3 * 3 := by norm_num
  rw [h]; exact mul_ne_zero three_ne_zero three_ne_zero

/-- `12 = 4 * 3`. -/
theorem twelve_ne_zero' [NeZero (2 : k)] [NeZero (3 : k)] : (12 : k) ≠ 0 := by
  have h : (12 : k) = 4 * 3 := by norm_num
  rw [h]; exact mul_ne_zero four_ne_zero' three_ne_zero

/-- `16 = 4 * 4`. -/
theorem sixteen_ne_zero' [NeZero (2 : k)] : (16 : k) ≠ 0 := by
  have h : (16 : k) = 4 * 4 := by norm_num
  rw [h]; exact mul_ne_zero four_ne_zero' four_ne_zero'

/-- `18 = 2 * 9`. -/
theorem eighteen_ne_zero' [NeZero (2 : k)] [NeZero (3 : k)] : (18 : k) ≠ 0 := by
  have h : (18 : k) = 2 * 9 := by norm_num
  rw [h]; exact mul_ne_zero two_ne_zero nine_ne_zero'

/-- `24 = 8 * 3`. -/
theorem twentyfour_ne_zero' [NeZero (2 : k)] [NeZero (3 : k)] : (24 : k) ≠ 0 := by
  have h : (24 : k) = 8 * 3 := by norm_num
  rw [h]; exact mul_ne_zero eight_ne_zero' three_ne_zero

/-- `27 = 9 * 3`. -/
theorem twentyseven_ne_zero' [NeZero (3 : k)] : (27 : k) ≠ 0 := by
  have h : (27 : k) = 9 * 3 := by norm_num
  rw [h]; exact mul_ne_zero nine_ne_zero' three_ne_zero

/-- `32 = 16 * 2`. -/
theorem thirtytwo_ne_zero' [NeZero (2 : k)] : (32 : k) ≠ 0 := by
  have h : (32 : k) = 16 * 2 := by norm_num
  rw [h]; exact mul_ne_zero sixteen_ne_zero' two_ne_zero

/-- `36 = 4 * 9`. -/
theorem thirtysix_ne_zero' [NeZero (2 : k)] [NeZero (3 : k)] : (36 : k) ≠ 0 := by
  have h : (36 : k) = 4 * 9 := by norm_num
  rw [h]; exact mul_ne_zero four_ne_zero' nine_ne_zero'

/-- `54 = 27 * 2`. -/
theorem fiftyfour_ne_zero' [NeZero (2 : k)] [NeZero (3 : k)] : (54 : k) ≠ 0 := by
  have h : (54 : k) = 27 * 2 := by norm_num
  rw [h]; exact mul_ne_zero twentyseven_ne_zero' two_ne_zero

/-- `108 = 4 * 27`. -/
theorem onehundredeight_ne_zero' [NeZero (2 : k)] [NeZero (3 : k)] : (108 : k) ≠ 0 := by
  have h : (108 : k) = 4 * 27 := by norm_num
  rw [h]; exact mul_ne_zero four_ne_zero' twentyseven_ne_zero'

/-- `48 = 16 * 3`. -/
theorem fortyeight_ne_zero' [NeZero (2 : k)] [NeZero (3 : k)] : (48 : k) ≠ 0 := by
  have h : (48 : k) = 16 * 3 := by norm_num
  rw [h]; exact mul_ne_zero sixteen_ne_zero' three_ne_zero

/-- `64 = 32 * 2`. -/
theorem sixtyfour_ne_zero' [NeZero (2 : k)] : (64 : k) ≠ 0 := by
  have h : (64 : k) = 32 * 2 := by norm_num
  rw [h]; exact mul_ne_zero thirtytwo_ne_zero' two_ne_zero

/-- `72 = 8 * 9`. -/
theorem seventytwo_ne_zero' [NeZero (2 : k)] [NeZero (3 : k)] : (72 : k) ≠ 0 := by
  have h : (72 : k) = 8 * 9 := by norm_num
  rw [h]; exact mul_ne_zero eight_ne_zero' nine_ne_zero'

/-- `144 = 16 * 9`. -/
theorem onehundredfortyfour_ne_zero' [NeZero (2 : k)] [NeZero (3 : k)] : (144 : k) ≠ 0 := by
  have h : (144 : k) = 16 * 9 := by norm_num
  rw [h]; exact mul_ne_zero sixteen_ne_zero' nine_ne_zero'

end Numerals

/-! ### `linear_combination` with numeral denominators

`ring1` — the normalizer `linear_combination` runs — cannot evaluate `(24 : k)⁻¹` without
`CharZero`: `NormNum` needs `(24 : k) ≠ 0` to build the rational normal form, and in a field of
unknown characteristic it has no way to get it.  `field_simp` *can*, if it is handed the
nonvanishing facts, and what is left afterwards is an honest integer-coefficient ring identity.

`linear_combination₆` is `linear_combination` with exactly that normalizer.  It proves precisely
the certificates whose denominators are products of `2`s and `3`s — that is, the ones that
`ringChar k ∤ 6` legitimises — and fails loudly on any other, which is the behaviour wanted: a
certificate that secretly divides by `5` must not slip through. -/

/-- `field_simp` armed with every numeral-nonvanishing fact that `ringChar k ∤ 6` supplies. -/
macro "field_simp₆" : tactic =>
  `(tactic| field_simp [two_ne_zero, three_ne_zero, four_ne_zero', six_ne_zero', eight_ne_zero',
      nine_ne_zero', twelve_ne_zero', sixteen_ne_zero', eighteen_ne_zero', twentyfour_ne_zero',
      twentyseven_ne_zero', thirtytwo_ne_zero', thirtysix_ne_zero', fortyeight_ne_zero',
      fiftyfour_ne_zero', sixtyfour_ne_zero', seventytwo_ne_zero',
      onehundredeight_ne_zero', onehundredfortyfour_ne_zero'])

/-- `linear_combination` whose normalizer clears numeral denominators built from `2` and `3`. -/
macro "linear_combination₆" e:term : tactic =>
  `(tactic| linear_combination (norm := (field_simp₆; ring1)) $e:term)

end BConicBundleMultisections
