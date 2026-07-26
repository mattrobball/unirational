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

## Consumers

`PointedConicRationalFamilies.exists_dense_open_smooth_biprojectiveZeroLocusSnd` uses the statement
below directly, for the **second** projection `X → ℙ²_y`, on the way to obligation 3.  It is on the
critical path.

The **first**-projection use in WP-2 is different: what the plane-cubic consumers need of a fibre
`Gs` is

```
∀ r : Fin 3 → k, r ≠ 0 → eval r Gs = 0 → ∃ i, eval r (pderiv i Gs) ≠ 0
```

— the Jacobian criterion already written out on explicit polynomials, with no morphisms and no
relative differentials.  That first-projection obligation lives in `ResidualYNonvanishing`, stated
in the vocabulary it is used in.  **Warning:** generic smoothness is *not* by itself enough for it;
see `ResidualYNonvanishing.exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth`, which is false
as stated, and the counterexample recorded there.  Nothing about the theorem below is in doubt —
the gap is on the other input, the choice of the multisection line and of the Tsen section.

## What Mathlib has, at the pinned revision

Searched: `Mathlib/AlgebraicGeometry/Morphisms/`, `Mathlib/RingTheory/Smooth/`,
`Mathlib/RingTheory/Kaehler/`, `Mathlib/RingTheory/Extension/`.

*Present, and relevant.*

* `AlgebraicGeometry.Scheme.Hom.smoothLocus` and
  `AlgebraicGeometry.Scheme.Hom.isOpen_smoothLocus` (`Morphisms/Smooth.lean`) — the smooth locus of
  a morphism locally of finite presentation is open; `smoothLocus_eq_top_iff` converts it back to
  `Smooth`.
* `AlgebraicGeometry.Scheme.Hom.dense_smoothLocus_of_perfectField` and
  `AlgebraicGeometry.Scheme.Hom.genericPoint_mem_smoothLocus_of_perfectField`
  (`Morphisms/Smooth.lean`) — generic smoothness **over a field**: for `f : X ⟶ Spec K` with `K`
  perfect and `X` reduced (resp. integral), the smooth locus is dense (resp. contains the generic
  point).  This is step (3)–(4) of the classical proof, below, and it is the only "generic
  smoothness" in Mathlib.
* `Algebra.FormallySmooth.of_perfectField` (`RingTheory/Smooth/Field.lean`) — the field-theoretic
  engine of the previous item.
* `AlgebraicGeometry.Smooth.of_smooth_fiberToSpecResidueField` (`Morphisms/SmoothFiber.lean`) —
  flat + locally of finite presentation + smooth fibres implies smooth.
* `Algebra.smoothLocus`, `Algebra.isOpen_smoothLocus`, `Algebra.smoothLocus_eq_compl_support_inter`
  (`RingTheory/Smooth/Locus.lean`); the Jacobian criterion in the form
  `Algebra.PreSubmersivePresentation.jacobian` / `SubmersivePresentation`
  (`RingTheory/Extension/Presentation/Submersive.lean`); the Jacobi–Zariski exact sequence
  (`RingTheory/Kaehler/JacobiZariski.lean`).

*Absent.*

* Generic smoothness for a morphism over a base that is not a field — the statement below.  Grep
  for "generic smoothness", "generically smooth", "generic flatness", "Sard" over all of Mathlib
  returns nothing algebro-geometric.
* Generic freeness / generic flatness in the Noetherian-domain form (`genericFreeness` and
  variants: not found).  The nearest is `Module.freeLocus` with `Module.isOpen_freeLocus`
  (`RingTheory/Spectrum/Prime/FreeLocus.lean`) and
  `Module.FinitePresentation.exists_free_localizedModule_powers`
  (`RingTheory/Localization/Free.lean`), both of which already assume finite presentation.
* A "generic fibre" construction: `Mathlib/AlgebraicGeometry/Fiber.lean` gives `Scheme.Hom.fiber`
  at an arbitrary point, but nothing packages the fibre at `genericPoint Y`, and there is no
  spreading-out (limit) machinery for it.
* A sheaf of relative differentials for schemes.  Any route through `Ω_{X/Y}` as a sheaf is a dead
  end here; only the affine/ring-level `KaehlerDifferential` exists.

## The classical proof, and where it stops

(1) Replace `Y` by the reduced closure of the image, so `f` is dominant and `Y` integral.
(2) Let `K = k(Y)` and form the generic fibre `X_K`.
(3) `X` smooth over `k` implies `X` regular, and the local rings of `X_K` are localizations of
    local rings of `X`, hence regular.
(4) `char k = 0` makes `K` perfect, so a regular `K`-scheme of finite type is smooth over `K`.
    Mathlib supplies the density form of this (`dense_smoothLocus_of_perfectField`) but not
    "regular over a perfect field implies smooth".
(5) Spread out: `X_K = lim_V f⁻¹(V)` and smoothness is of finite presentation, so `X_K` smooth
    over `K` gives `f⁻¹(V) → V` smooth for some nonempty open `V ⊆ Y` (EGA IV 8.10.5, 17.7.8).

Step (5) is the blocker: Mathlib has no limit/spreading-out API for schemes of finite
presentation, and building one is not a by-product of this project.
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

Let `k` be algebraically closed of characteristic zero, let `Y` be an integral `k`-scheme of finite
type, and let `f : X ⟶ Y` be a morphism of finite type with `X` smooth over `k`.  Then `f` is smooth
over some nonempty open subset of `Y`.

*Status: standard, `sorry`ed, and ours to prove — but no longer consumed.*  See the module
docstring: the development takes the coordinate-level form of the same theorem
(`exists_ne_zero_nonsingular_stereo_cubicFiber_of_smooth`, `ResidualYNonvanishing`), because that
is what the Jacobian-criterion consumers actually need and it is statable without machinery Mathlib
lacks.  This declaration records the borrowed statement in its natural generality, together with
the survey above of what Mathlib does and does not provide towards it.

Mathlib has no generic smoothness for morphisms of schemes over a base other than a field at the
pinned revision.  Characteristic zero is essential — the statement is false in positive
characteristic (Frobenius is the standard counterexample).

The integrality and finite-type hypotheses on `Y` are load-bearing.  Without integrality the
statement is false: `Spec k → Spec(k[ε]/ε²)` is a finite morphism from a smooth `k`-scheme, but the
target has no smaller nonempty open and the map is not flat.  They also rule out the vacuous
counterexample `Y = ∅`.  Dominance of `f` is deliberately not assumed: over an integral target the
nondominant case may be handled on an open disjoint from the closure of the image.

The conclusion is stated as *nonempty* rather than *dense* because that is the honest content;
when `Y` is irreducible — as `ℙ²_x` is — nonempty open implies dense, and the caller derives it.
-/
theorem exists_nonempty_open_smooth_restrict
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    {X Y : Scheme.{u}} (sX : X ⟶ Spec (.of k)) (sY : Y ⟶ Spec (.of k))
    (f : X ⟶ Y) (hf : f ≫ sY = sX)
    [Smooth sX] [IsIntegral Y]
    [LocallyOfFiniteType sY] [QuasiCompact sY]
    [LocallyOfFiniteType f] [QuasiCompact f] :
    ∃ U : Y.Opens, Nonempty U ∧ Smooth (f ∣_ U) :=
  sorry

end

end BConicBundleMultisections.Standard
