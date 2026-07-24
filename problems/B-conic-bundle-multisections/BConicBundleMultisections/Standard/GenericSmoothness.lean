/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.AlgebraicGeometry.Morphisms.Smooth
public import Mathlib.AlgebraicGeometry.Morphisms.FiniteType
public import Mathlib.AlgebraicGeometry.Restrict

/-!
# Generic smoothness

**This module is part of `BConicBundleMultisections/Standard/`.  Read the contract.**

## The contract for `Standard/`

Modules in this directory hold results that are *standard mathematics absent from Mathlib at the
pinned revision*, and nothing else.  The rules are:

* **Definitions here are built correctly and completely.**  A `sorry`ed theorem is honest; a
  `sorry`ed or fabricated definition is not, because everything downstream would then be about the
  wrong object.  If a statement cannot be made without first defining something, the definition
  gets built.
* **Theorems here may carry `sorry`.**  They are textbook results we are standing in for, and each
  is *ours to prove* — the `sorry` is scaffolding, not a standing assumption.
* **Nothing novel to this project belongs here.**  The tangent-residual argument is built on top,
  in the main tree, and is proved outright.  The point of the separation is that a reader can see
  at a glance which mathematics is borrowed and which is ours.
* **Each statement is in its natural generality**, not narrowed to the shape this project happens
  to consume.  These are intended to be provable independently, reusable, and upstreamable.

## This module

Generic smoothness, in the form of Hartshorne III.10.7: over an algebraically closed field of
characteristic zero, a morphism out of a nonsingular variety is smooth over some nonempty open of
the target.

It is used by `certificates/all_smooth_tangent_residual_theorem.md` §1 to make the generic plane
cubic fibre of `ρ : X → ℙ²_x` smooth, which is what makes the tangent-residual construction
nondegenerate.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections.Standard

noncomputable section

universe u

open AlgebraicGeometry

/--
**Generic smoothness** (Hartshorne III.10.7).

Let `k` be algebraically closed of characteristic zero and let `f : X ⟶ Y` be a morphism of
`k`-schemes of finite type with `X` smooth over `k`.  Then `f` is smooth over some nonempty open
subset of `Y`.

*Status: standard, `sorry`ed, and ours to prove.*  Mathlib has no generic smoothness for morphisms
of schemes at the pinned revision.  Characteristic zero is essential — the statement is false in
positive characteristic (Frobenius is the standard counterexample).

Dominance of `f` is deliberately **not** assumed: if `f` is not dominant then a nonempty open
disjoint from its image works, with `f ∣_ U` a morphism out of the empty scheme.  Requiring
dominance would be a stronger hypothesis for no gain.

The conclusion is stated as *nonempty* rather than *dense* because that is the honest content;
when `Y` is irreducible — as `ℙ²_x` is — nonempty open implies dense, and the caller derives it.
-/
theorem exists_nonempty_open_smooth_restrict
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    {X Y : Scheme.{u}} (sX : X ⟶ Spec (.of k)) (sY : Y ⟶ Spec (.of k))
    (f : X ⟶ Y) (hf : f ≫ sY = sX)
    [Smooth sX] [LocallyOfFiniteType f] :
    ∃ U : Y.Opens, Nonempty U ∧ Smooth (f ∣_ U) :=
  sorry

end

end BConicBundleMultisections.Standard
