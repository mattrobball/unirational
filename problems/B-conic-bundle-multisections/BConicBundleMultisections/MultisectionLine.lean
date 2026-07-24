/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.LinearAlgebra.LinearIndependent.Defs
public import Mathlib.Data.Fin.VecNotation
public import Mathlib.Algebra.Algebra.Defs
public import Mathlib.LinearAlgebra.LinearIndependent.Lemmas

/-!
# The multisection line

The source proof **chooses** the line `L ⊂ ℙ²_y` along which the residual construction is run
(`certificates/all_smooth_tangent_residual_theorem.md` §3–§4), and normalises coordinates so that
`L = {W = 0}` only afterwards (§5).  This development hardcoded the normalisation, which is what
made several obligations false as stated — see `PLAN.md` WP-5 and the corrections log.

This module begins the fix by making the line a **parameter**.  A line in `ℙ²` is the span of two
independent vectors; the affine parameterisation `t ↦ base + t · dir` covers all of it except the
point `[dir]`, which is exactly what the residual construction needs.

## Why parameterise rather than transport

The alternative — keep `L = {Y₂ = 0}` and move a good line there by a `PGL₃` change of coordinates —
was tried first and is now parked.  Mathlib's contribution values decide it: *"definitions should be
very broadly applicable rather than tailored to specific contexts"*, and hardcoding one line is
precisely that tailoring.  Transport is machinery whose only purpose is to undo the hardcoding, and
it needs ideal-sheaf-level work plus a `Proj.map`/`toSpecZero` compatibility Mathlib lacks.
`LinearCoordinateChange.lean` (the `PGL₃` action on `ℙⁿ`) remains as a general, independently useful
result, but it is no longer on the critical path.

## Status

Stage 0 of the refactor: the abstraction is introduced **alongside** the concrete line, with
`coordinateLine` as the canonical instance and a compatibility lemma, so nothing downstream changes
yet.  Migration proceeds inward-out from here.
-/

@[expose] public section

namespace BConicBundleMultisections

universe u

variable {k : Type u} [Field k]

/-- A line in `ℙ²` together with an affine parameterisation: the span of two independent vectors,
parameterised by `t ↦ base + t · dir`.

The parameterisation misses only the point `[dir]`, so it is dense — which is all the residual
construction requires. -/
structure MultisectionLine (k : Type u) [Field k] where
  /-- The point of the line at parameter `0`. -/
  base : Fin 3 → k
  /-- The direction spanning the line together with `base`. -/
  dir : Fin 3 → k
  /-- The two vectors are independent, so they really do span a line. -/
  indep : LinearIndependent k ![base, dir]

/-! ### Points of `L` over an arbitrary ring

The residual construction runs the line's parameter over three different rings: the base field `k`
(a numerical point), `k[t]` (the generic point, where Tsen's theorem is applied), and the affine
plane ring (where the chart lives).  Rather than constrain those rings to be `k`-algebras — which
they are, but stating it costs an instance argument at every downstream site — the low-level
definitions take the two spanning vectors *already in the target ring*.
`MultisectionLine.mapVecs` supplies them from a line over `k`.

This keeps the arithmetic lemmas as broadly applicable as the ones they replace. -/

/-- The point at parameter `t` of the line spanned by `p` and `q`, in any commutative ring. -/
def linePointOf {R : Type u} [CommRing R] (p q : Fin 3 → R) (t : R) : Fin 3 → R :=
  fun a => p a + t * q a

@[simp] theorem linePointOf_zero {R : Type u} [CommRing R] (p q : Fin 3 → R) :
    linePointOf p q 0 = p := by
  funext a; simp [linePointOf]

/-- Transporting the point along a ring homomorphism. -/
theorem map_linePointOf {R S : Type u} [CommRing R] [CommRing S] (f : R →+* S)
    (p q : Fin 3 → R) (t : R) (a : Fin 3) :
    f (linePointOf p q t a) = linePointOf (fun b => f (p b)) (fun b => f (q b)) (f t) a := by
  simp [linePointOf]

namespace MultisectionLine

variable (L : MultisectionLine k)

/-- The point of `L` at parameter `t`. -/
def point (t : k) : Fin 3 → k := fun i => L.base i + t * L.dir i

/-- The spanning vectors of `L` pushed into a `k`-algebra. -/
def mapVecs (R : Type u) [CommRing R] [Algebra k R] : (Fin 3 → R) × (Fin 3 → R) :=
  (fun a => algebraMap k R (L.base a), fun a => algebraMap k R (L.dir a))

/-- The point of `L` at parameter `t`, in a `k`-algebra. -/
def pointOver (R : Type u) [CommRing R] [Algebra k R] (t : R) : Fin 3 → R :=
  linePointOf (L.mapVecs R).1 (L.mapVecs R).2 t

theorem pointOver_apply (R : Type u) [CommRing R] [Algebra k R] (t : R) (a : Fin 3) :
    L.pointOver R t a = algebraMap k R (L.base a) + t * algebraMap k R (L.dir a) := rfl

/-- Over the base field itself the two notions of point agree. -/
@[simp] theorem pointOver_self (t : k) : L.pointOver k t = L.point t := by
  funext a; simp [pointOver, point, linePointOf, mapVecs]

@[simp] theorem point_zero : L.point 0 = L.base := by
  funext i; simp [point]

/-- The parameterised point is never zero, so it is a genuine point of `ℙ²`. -/
theorem point_ne_zero (t : k) : L.point t ≠ 0 := by
  intro h
  have h1 : (1 : k) • L.base + t • L.dir = 0 := by
    funext i
    have := congrFun h i
    simpa [point, mul_comm] using this
  have := (LinearIndependent.pair_iff.mp L.indep) 1 t h1
  exact one_ne_zero this.1

end MultisectionLine

/-- The coordinate line `{Y₂ = 0}`, parameterised by `t ↦ [1 : t : 0]`.

This is the line the development hardcoded; it is now one instance among many. -/
def coordinateLine (k : Type u) [Field k] : MultisectionLine k where
  base := ![1, 0, 0]
  dir := ![0, 1, 0]
  indep := by
    rw [LinearIndependent.pair_iff]
    intro s t h
    have h0 := congrFun h 0
    have h1 := congrFun h 1
    simp at h0 h1
    exact ⟨h0, h1⟩

/-- Compatibility: the abstraction reproduces the hardcoded parameterisation, so nothing downstream
changes until it is migrated. -/
@[simp] theorem coordinateLine_point (t : k) :
    (coordinateLine k).point t = ![1, t, 0] := by
  funext i
  fin_cases i <;> simp [MultisectionLine.point, coordinateLine]

end BConicBundleMultisections
