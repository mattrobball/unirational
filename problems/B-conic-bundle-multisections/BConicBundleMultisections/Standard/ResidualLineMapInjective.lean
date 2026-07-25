/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PlaneCubicResidualEquivariance
public import Mathlib.Algebra.MvPolynomial.PDeriv
public import Mathlib.FieldTheory.IsAlgClosed.Basic

/-!
# The residual-line map of a smooth plane cubic, and what it determines

**This module is part of `BConicBundleMultisections/Standard/`.  Read the contract at the top of
`Standard/GenericSmoothness.lean`:** these are standard results absent from Mathlib, definitions
built completely, theorems allowed to carry `sorry`, each stated in its natural generality.

## The object

For a smooth plane cubic `C = {f = 0}` over a field of characteristic zero, a line `L` cuts
`L · C = p + q + r`, and the three tangent-residual points `g(p), g(q), g(r)` (where
`T_pC · C = 2p + g(p)`) are again collinear.  The resulting

```
δ_C : (ℙ²)^∨ → (ℙ²)^∨,    L ↦ ⟨g(p) g(q) g(r)⟩
```

is `certificates/all_smooth_tangent_residual_theorem.md` (2.1): the degree-four Lattès map of `C`.
In this development `δ_C(L)` is the linear form `residualLinearFormOn M N f`, where `M` is a frame
of `L` (`lineFrame`, columns the spanning vectors) and `N` its inverse; the point of `(ℙ²)^∨` is the
coefficient vector of that form.

## What is borrowed here, and why

The source's **Lemma 2.1** says the critical-value curve of `δ_C` is the dual sextic `C^∨`, so `δ_C`
determines `C` by biduality — i.e. `C ↦ δ_C` is *injective* on smooth plane cubics.  Its proof runs
through: choosing a flex as origin so that `g = [-2]` for the chord-and-tangent group law;
`π : C × C → (ℙ²)^∨`, `(p, q) ↦ ⟨pq⟩`, as the quotient by the natural `S₃`-action, with branch curve
`C^∨`; the étale `μ = [-2] × [-2]` with `π ∘ μ = δ_C ∘ π`; the ramification formula
`π^* R_{δ_C} = μ^* R_π - R_π`; and finally biduality `(C^∨)^∨ = C`.

*This is borrowed, not proved.*  A prior feasibility study for this project established that every
route to Lemma 2.1 bottoms out on the flex-origin group law of an *arbitrary* smooth plane cubic,
and that Mathlib at the pinned revision has none of the required machinery:

* no plane-cubic ↔ Weierstrass dictionary in usable projective form (Mathlib has the Weierstrass
  group law, `Mathlib/AlgebraicGeometry/EllipticCurve/`, and nothing connecting it to a general
  ternary cubic);
* no flexes / Hessian of a plane curve;
* no torsion-subgroup or isogeny lemmas beyond the Weierstrass setting;
* no dual varieties and no biduality;
* no branch or ramification divisors for a finite morphism of surfaces;
* no quotients of schemes by finite group actions;
* no sheaf of Kähler differentials for schemes (only the affine/ring-level
  `KaehlerDifferential`).

Literature: C. T. McMullen, R. E. Mukamel, A. Wright, *Cubic curves and totally geodesic
subvarieties of moduli space*, Ann. of Math. **185** (2017), 957–990, §2, especially equation
(2.6); and M. Dabija, M. Jonsson, *Algebraic webs invariant under endomorphisms*, Publ. Mat. **54**
(2010), 137–148, §4.3.

## The statement below is deliberately **weaker** than the source's Lemma 2.1

The theorem here concludes only that cubics with a common residual-line map lie in a common
**pencil**, not that they are equal.  Two reasons, both established by the same feasibility study:

1. *It is all the argument needs.*  The consumer (`GoodLineExistence.lean`) turns "the cubic
   fibration lies in a fixed pencil `A(x)·f₀(y) + B(x)·f₁(y)`" into a contradiction with smoothness,
   because two conics in `ℙ²` always meet — see `not_eq_pencil_of_smooth`.  Injectivity would be
   strictly more than is consumed.
2. *The cheap route to Lemma 2.1 provably cannot give more.*  The fixed points of `δ_C` are the
   `21` lines meeting `C` only in its nine flexes, so `δ_C = δ_{C'}` forces `C` and `C'` to have the
   same nine flexes, hence to lie in a common Hesse pencil — but numerical checking confirms that
   `δ` genuinely **varies** along the Hesse pencil, so the fixed-point route stops exactly at the
   pencil.  Getting injectivity requires the full critical-value computation.  Anyone strengthening
   this statement to `f i = f j` should know that the fixed-point argument will not deliver it.

## The base-point-freeness hypothesis is not decoration

`HasCommonResidualLineMap` is a condition on *values*, and the zero vector is a legal value of a
coefficient vector even though it is not a point of `(ℙ²)^∨`.  Without
`ResidualLineMapBasepointFree` the hypothesis is satisfied by any family one of whose members has
`δ ≡ 0`, and the conclusion is then false.

Note that the *weak* form — "some line has nonzero residual coefficient vector" — would **not** be
enough: what the proof consumes is that `δ_{f i}` and `δ_{f j}` agree as morphisms, and a single
nondegenerate line does not give that.  The hypothesis below is therefore the all-lines form.

It is not an assumption of the development:
`ResidualLineBasePointFree.residualLinearFormOn_ne_zero_of_nonsingular` proves it (over an
algebraically closed field, with no hypothesis on the characteristic), and
`GoodLineExistence.residualLineMapBasepointFree_of_isSmoothPlaneCubic` discharges it in the exact
shape used here.
-/

@[expose] public section

namespace BConicBundleMultisections.Standard

noncomputable section

universe u v

open MvPolynomial
open _root_.MvPolynomial

variable {k : Type u} [Field k]

/-! ### Smooth plane cubics -/

/--
**A smooth plane cubic**, in the coordinate form the Jacobian criterion takes over a field: a
homogeneous cubic form in three variables no projective zero of which is a common zero of the three
partial derivatives.

This is the same shape as the nonsingularity hypothesis of
`binaryLineRestriction_ne_zero_of_nonsingular`, stated once so that it can be named.
-/
def IsSmoothPlaneCubic (f : MvPolynomial (Fin 3) k) : Prop :=
  f.IsHomogeneous 3 ∧
    ∀ r : Fin 3 → k, r ≠ 0 → eval r f = 0 → ∃ i : Fin 3, eval r (pderiv i f) ≠ 0

/-! ### The residual-line map as a map -/

/--
**`δ_f` is base-point free**: along every line the residual coefficient vector is nonzero, so
`δ_f` really is a morphism `(ℙ²)^∨ → (ℙ²)^∨` rather than a rational map.

For a smooth plane cubic this is true — `δ_f` is the degree-four Lattès map, a morphism — and it is
the reason the source can speak of `δ_C` as a map at all.  It is stated separately because nothing
in this development proves it, and because it is exactly the hypothesis that stops
`HasCommonResidualLineMap` from being vacuous; see the module docstring.
-/
def ResidualLineMapBasepointFree (f : MvPolynomial (Fin 3) k) : Prop :=
  ∀ M N : Matrix (Fin 3) (Fin 3) k, M * N = 1 → residualLinearFormOn M N f ≠ 0

/--
**A family of plane cubics has a common residual-line map**: along every line, the residual lines
`δ_{f i}(L)` of all members are scalar multiples of one linear form, i.e. they are the same point of
`(ℙ²)^∨`.

Quantifying over all invertible pairs `(M, N)` rather than over lines is harmless and slightly
stronger: every matrix is a `lineFrame` (`lineFrame_of_matrix`), and rescaling a frame rescales the
residual form, so this says exactly that the maps `δ_{f i}` agree pointwise on `k`-points of
`(ℙ²)^∨`.
-/
def HasCommonResidualLineMap {ι : Type v} (f : ι → MvPolynomial (Fin 3) k) : Prop :=
  ∀ M N : Matrix (Fin 3) (Fin 3) k, M * N = 1 →
    ∃ ℓ : MvPolynomial (Fin 3) k, ∀ i : ι, ∃ a : k,
      residualLinearFormOn M N (f i) = C a * ℓ

/-! ### Lemma 2.1, in its pencil form -/

/--
**Lemma 2.1 (pencil form): smooth plane cubics with a common residual-line map lie in a pencil.**

*What it says.*  If every member of a family of smooth plane cubics over an algebraically closed
field of characteristic zero has the same residual-line map `δ`, then the whole family lies in a
single pencil `⟨f₀, f₁⟩` of cubic forms.

*Why it is true.*  `δ_f = δ_g` forces `f` and `g` to have the same fixed lines; those are the `21`
lines meeting the cubic only in its nine flexes, so `f` and `g` have the same nine flexes; the
cubics through nine such points are exactly the Hesse pencil of `f`.  Alternatively, and this is the
source's route, the critical-value curve of `δ_f` is the dual sextic `f^∨`, which recovers `f`
outright by biduality — a strictly stronger conclusion than the one stated here.

*Status: standard, `sorry`ed, and ours to prove.*  See the module docstring for the two literature
citations, for the survey of what Mathlib lacks, and for why the conclusion is deliberately the
pencil rather than injectivity.

Source: `certificates/all_smooth_tangent_residual_theorem.md` §2, Lemma 2.1, consumed in §3.

*Hypotheses.*  Characteristic zero is used for the group law and for the ramification count;
algebraic closure is used to choose a flex as origin.  `hbpf` is essential and not decoration — see
the module docstring.  The index type is arbitrary: for a one- or two-element family the conclusion
is trivially true, which is correct, since the content of the lemma is that the *fibres* of
`f ↦ δ_f` are contained in pencils.
-/
theorem exists_pencil_of_hasCommonResidualLineMap
    [IsAlgClosed k] [CharZero k] {ι : Type v} (f : ι → MvPolynomial (Fin 3) k)
    (hsmooth : ∀ i, IsSmoothPlaneCubic (f i))
    (hbpf : ∀ i, ResidualLineMapBasepointFree (f i))
    (hcommon : HasCommonResidualLineMap f) :
    ∃ f₀ f₁ : MvPolynomial (Fin 3) k,
      f₀.IsHomogeneous 3 ∧ f₁.IsHomogeneous 3 ∧
        ∀ i : ι, ∃ a b : k, f i = C a * f₀ + C b * f₁ :=
  sorry

end

end BConicBundleMultisections.Standard
