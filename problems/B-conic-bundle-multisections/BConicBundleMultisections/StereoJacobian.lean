/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.AlgebraicIndependenceJacobian
public import BConicBundleMultisections.CubicFiberSingularLocus
public import BConicBundleMultisections.ResidualYCoordsPureT

/-!
# The stereographic family sweeps a surface

Input (ii) of the split of obligation 1 — *some stereo parameter has a nonsingular cubic fibre* — is
proved here from two inputs that say what they mean:

* **generic smoothness**, in concrete form: *some* first-block point has a nonsingular cubic fibre;
* **the stereo Jacobian is nonzero**: the `3 × 3` determinant with rows `Y`, `∂Y/∂t`, `∂Y/∂s`, where
  `Y = residualImageXCoords F v`, does not vanish.

The bridge between them is the Jacobian criterion `AlgebraicIndependenceJacobian.
eq_zero_of_isHomogeneous_of_aeval_eq_zero`: a nonzero Jacobian means no nonzero *homogeneous* form
vanishes on `Y`, and the certificates of `CubicFiberSingularLocus` are homogeneous
(`elimCertificates_isHomogeneous`).  So a certificate that survives somewhere on `ℙ²_x` survives
somewhere on the stereo family, and there the fibre is nonsingular.

## `v₂ ≠ 0` is not decoration

If the Tsen section lies in the plane `{x₂ = 0}` then so does `w = (1, s, 0)`, hence so does
`Y = Q(w)·v − B(v,w)·w`: the third coordinate of `Y` is identically zero, the third *column* of the
Jacobian matrix vanishes, and the determinant is zero.  The Jacobian obligation is therefore
**false** without `hv2`, which is why `GoodLineCondition` was strengthened to produce a section off
that plane.

## What the Jacobian obligation reduces to

`Q(Y) = 0` identically, so differentiating in `s` gives `B(Y, ∂Y/∂s) = 0`, and differentiating in
`t` gives `B(Y, ∂Y/∂t) = −(∂Q/∂t)(Y)`.  When the generic conic is smooth — the root
`GoodLineCondition.coordinateLineConicDiscriminant_ne_zero_of_smooth` — the `B`-orthogonal
complement of `Y` is two-dimensional and contains both `Y` and `∂Y/∂s`, so

```
det [Y, ∂Y/∂t, ∂Y/∂s] ≠ 0   ⟺   Y, ∂Y/∂s independent   and   (∂Q/∂t)(Y) ≠ 0 .
```

The first is "the stereographic parameterisation is an immersion"; the second is "the conic family
really moves at `Y`", and would follow from the family not being constant (smoothness, via
`BiprojectiveNoWholeFiber`) together with the fact that a quadratic form vanishing on a smooth conic
is a multiple of it.  Both are conic-level statements, available here because the stereo map has an
explicit formula.  The corresponding determinant on the `y`-side (`det_residualYCoordsOn_ne_zero`,
horizontality) admits no such reduction, since the residual coordinates are not given by a formula
of this kind — so the two determinants are not the same problem twice.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

/-- **Specializing the parameters commutes with pulling a form back along the stereo family.**

`aeval x Δ ∈ k[t,s]` is the pullback of a form `Δ` in the first-block coordinates along the
parameterization `x : 𝔸² → 𝔸³`; evaluating that pullback at `(t, s)` is evaluating `Δ` at the image
point.  This is what turns a form cutting out a locus in `ℙ²_x` into an element of `k[t,s]` cutting
out the bad parameters. -/
theorem evalAffineTwoPoint_aeval {k : Type u} [CommRing k] (t s : k)
    (x : Fin 3 → affineTwoRing k) (Δ : MvPolynomial (Fin 3) k) :
    evalAffineTwoPoint t s ((aeval x : MvPolynomial (Fin 3) k →ₐ[k] affineTwoRing k) Δ)
      = eval (fun i => evalAffineTwoPoint t s (x i)) Δ := by
  induction Δ using MvPolynomial.induction_on with
  | C a => simp [evalAffineTwoPoint, MvPolynomial.algebraMap_eq]
  | add p q hp hq => simp only [map_add, hp, hq]
  | mul_X p j hp => simp only [map_mul, aeval_X, eval_X, hp]

/-- **The Jacobian determinant of the stereographic family**: the `3 × 3` determinant whose rows are
the stereo point and its two parameter derivatives.

It is nonzero exactly when the family sweeps a surface — the hypothesis the Jacobian criterion of
`AlgebraicIndependenceJacobian.lean` consumes. -/
def stereoJacobianDet {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k) :
    affineTwoRing k :=
  (Matrix.of ![residualImageXCoords F v,
    fun a => pderiv (ULift.up 0) (residualImageXCoords F v a),
    fun a => pderiv (ULift.up 1) (residualImageXCoords F v a)]).det

/--
**Obligation: the stereographic family sweeps a surface.**

*Status.* Obligation.  With `CubicFiberSingularLocus` and the conic root in place this is the last
geometric input on the `x`-side of obligation 1.

*Why `hv2` is a hypothesis and not decoration.*  For `v 2 = 0` the whole family lies in the plane
`{x₂ = 0}`, the third column of the matrix vanishes identically and the determinant is zero: the
statement is **false** without it.  A section with `v 2 ≠ 0` comes from `GoodLineCondition`, and the
conjunct is threaded from there.

*Why it is true.*  For fixed `t`, `s ↦ Y(t, s)` sweeps the conic `Q_t` — with `v` off the plane
`{x₂ = 0}` the lines through `v` meeting that plane are all the lines through `v` — and the conics
`Q_y`, `y ∈ L`, are not all proportional, since a proportional family would put a whole `ℙ²_x`
fibre inside `X` (`BiprojectiveNoWholeFiber`).  So the image is two-dimensional, and in
characteristic zero a dominant map has nonvanishing Jacobian.

*What is owed.*  See the module docstring: differentiating `Q(Y) = 0` reduces the determinant to
two conic-level conditions — that the parameterisation is an immersion, and that `(∂Q/∂t)(Y) ≠ 0`.
The second needs "a quadratic vanishing on a smooth conic is a multiple of it", which Mathlib does
not have; the first is a computation with the explicit stereo formula.  Alternatively one proves the
general "dominant implies nonvanishing Jacobian in characteristic zero", which is the converse of
the criterion the tree has and is a larger piece of commutative algebra. -/
theorem stereoJacobianDet_ne_zero_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hnd : polarEval (specializedConicPullback F) (liftTsenSection v) affineTwoStereoDir ≠ 0) :
    stereoJacobianDet F v ≠ 0 :=
  sorry

/--
**Obligation: generic smoothness, in concrete form.**  Some first-block point has a nonsingular
cubic fibre.

*Status.* Obligation, borrowed and standard: this is Hartshorne III.10.7 for the plane-cubic
fibration `ρ : X → ℙ²_x`, of which `Standard.exists_nonempty_open_smooth_restrict` is the
scheme-level form.  `CharZero` is essential — in characteristic `p` a smooth total space can have
every fibre singular (quasi-elliptic fibrations) — and `IsAlgClosed` is used to have points at all.

This is the *only* place obligation 1 needs generic smoothness; everything else about the singular
locus is the elimination theory of `CubicFiberSingularLocus.lean`, which is unconditional. -/
theorem exists_nonsingularCubicFiber_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∃ x : Fin 3 → k, ∀ r : Fin 3 → k, r ≠ 0 →
      eval r (specializeFirstCoordinates (n := 2) x F) = 0 →
        ∃ i : Fin 3, eval r (pderiv i (specializeFirstCoordinates (n := 2) x F)) ≠ 0 :=
  sorry

/-- **Input (ii), derived.**

Some stereo parameter pair has a nonsingular cubic fibre, given generic smoothness and a nonzero
stereo Jacobian.  The certificate that survives at the good point of `ℙ²_x` is homogeneous
(`elimCertificates_isHomogeneous`), so the Jacobian criterion applies to it and it survives along
the family; `k` infinite then produces a parameter pair where it does not vanish, and there the
fibre is nonsingular by the defining property of the certificates. -/
theorem exists_stereo_param_nonsingular_cubicFiber
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hgen : ∃ x : Fin 3 → k, ∀ r : Fin 3 → k, r ≠ 0 →
      eval r (specializeFirstCoordinates (n := 2) x F) = 0 →
        ∃ i : Fin 3, eval r (pderiv i (specializeFirstCoordinates (n := 2) x F)) ≠ 0)
    (hjac : stereoJacobianDet F v ≠ 0) :
    ∃ t s : k, ∀ r : Fin 3 → k, r ≠ 0 →
      eval r (specializeFirstCoordinates (n := 2)
          (fun i => evalAffineTwoPoint t s (residualImageXCoords F v i)) F) = 0 →
        ∃ i : Fin 3, eval r (pderiv i (specializeFirstCoordinates (n := 2)
          (fun i => evalAffineTwoPoint t s (residualImageXCoords F v i)) F)) ≠ 0 := by
  classical
  obtain ⟨S, hhom, hS⟩ := exists_defining_set_nonsingular_cubicFiber_of_bidegree23 F hF
  obtain ⟨x₀, hx₀⟩ := hgen
  obtain ⟨Δ, hΔS, hΔ⟩ := (hS x₀).mpr hx₀
  obtain ⟨n, hn⟩ := hhom Δ hΔS
  have hΔ0 : Δ ≠ 0 := by
    intro h
    rw [h] at hΔ
    exact hΔ (map_zero _)
  have hpull : (aeval (residualImageXCoords F v) :
      MvPolynomial (Fin 3) k →ₐ[k] affineTwoRing k) Δ ≠ 0 := by
    intro hzero
    exact hΔ0 (eq_zero_of_isHomogeneous_of_aeval_eq_zero (residualImageXCoords F v)
      (ULift.up 0) (ULift.up 1) hjac n Δ hn hzero)
  obtain ⟨t, s, hts⟩ := exists_eval_ne_zero_affineTwoRing _ hpull
  refine ⟨t, s, (hS _).mp ⟨Δ, hΔS, ?_⟩⟩
  rw [← evalAffineTwoPoint_aeval]
  exact hts

end

end BConicBundleMultisections
