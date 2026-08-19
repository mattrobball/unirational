/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.V14SchemeModel

/-!
# What the base field has to satisfy

The published no-map theorem fixes `V14SchemeModel.k = ℚ(ζ₁₁)`.  That is
narrower than intended: a rational map defined over a larger field does not
descend to `ℚ(ζ₁₁)`, so ruling out `ℚ(ζ₁₁)`-maps is the weaker of the two
directions, and `FaithfulLinearRep k G V` does not even reach the two
12-dimensional irreducibles of `PSL(2,11)`, whose character field is `ℚ(√5)`
and whose only quadratic subfield candidate in `ℚ(ζ₁₁)` is `ℚ(√−11)`.

The criteria the argument actually needs on a base field `F` are recorded in
`FIELD_CRITERIA_2026-08-18.md`:

* **characteristic zero**, and
* **a primitive 11th root of unity in `F`**.

Nothing else.  In particular `F` need not be algebraically closed — every
`IsAlgClosed` in this development sits on an `AlgebraicClosure` of the field at
hand and the conclusion is descended afterwards — and `F` need not contain a
square root of `−1`; `Ki = ℚ(ζ₁₁, i)` is internal scaffolding that the proof
descends out of.

This file proves that those two criteria are *exactly* `[Algebra k F]`, which
is the form the theorems are stated in.  `algebraOfPrimitiveRoot` is the
forward direction and `isPrimitiveRoot_zetaOf` / `charZero_of_algebra` are the
backward one, so a reader can check the hypothesis in whichever form is
convenient.

## What char 0 is really doing

Char 0 is load-bearing in exactly one place, the plus branch of hypothesis (a):
`EllipticPolynomialConstancy` reduces "a genus-1 curve admits no non-constant
map from a rational variety" to `Polynomial.eq_C_of_derivative_eq_zero` (false
in char `p`) and to Mason–Stothers.  The underlying mathematical fact holds in
every characteristic — Lüroth does — so this is a limit of the technique, not
of the theorem.
-/

noncomputable section

open Polynomial

namespace V14Formalization
namespace BaseField

open V14SchemeModel (k)

/-- A field over `ℚ(ζ₁₁)` has characteristic zero. -/
public theorem charZero_of_algebra (F : Type*) [Field F] [Algebra k F] :
    CharZero F :=
  charZero_of_injective_algebraMap
    (FaithfulSMul.algebraMap_injective k F)

/-- A field over `ℚ(ζ₁₁)` contains a primitive 11th root of unity, namely the
image of the generator. -/
public theorem isPrimitiveRoot_zetaOf (F : Type*) [Field F] [Algebra k F] :
    IsPrimitiveRoot (algebraMap k F WeilRep.ζ) 11 := by
  haveI : CharZero F := charZero_of_algebra F
  have hprim : IsPrimitiveRoot (WeilRep.ζ : k) 11 :=
    (IsPrimitiveRoot.iff_orderOf).2 WeilRep.orderOf_ζ
  exact hprim.map_of_injective (FaithfulSMul.algebraMap_injective k F)

/-- Conversely, a characteristic-zero field with a primitive 11th root of unity
is an algebra over `ℚ(ζ₁₁) = AdjoinRoot Φ₁₁`: send the generator to the root.

This is the criteria in their intrinsic form.  Everything downstream is stated
with `[Algebra k F]` instead, because a *chosen* embedding is what the model —
`WeilRep`, `Λ²U`, `projectorMatrix`, all built out of one root — actually
consumes; the two are the same data. -/
@[reducible] public noncomputable def algebraOfPrimitiveRoot
    {F : Type*} [Field F] [CharZero F]
    {ζ : F} (hζ : IsPrimitiveRoot ζ 11) : Algebra k F :=
  (AdjoinRoot.lift (algebraMap ℚ F) ζ (by
    have hroot : (cyclotomic 11 F).IsRoot ζ :=
      hζ.isRoot_cyclotomic (by norm_num)
    have hmap : map (algebraMap ℚ F) WeilRep.Φ11 = cyclotomic 11 F := by
      simpa [WeilRep.Φ11] using map_cyclotomic 11 (algebraMap ℚ F)
    calc aeval ζ WeilRep.Φ11
        = eval ζ (map (algebraMap ℚ F) WeilRep.Φ11) := by
          simp [aeval_def, eval_map]
      _ = eval ζ (cyclotomic 11 F) := by rw [hmap]
      _ = 0 := hroot)).toAlgebra

end BaseField
end V14Formalization
