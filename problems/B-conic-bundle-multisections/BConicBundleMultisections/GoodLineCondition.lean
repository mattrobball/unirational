/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualYCoordsPureT

/-!
# The good-line conditions, and the single root they share

`certificates/all_smooth_tangent_residual_theorem.md` §4(1) asks that the multisection line `L` be
chosen so that "`S_L` is integral and its generic conic over `k(L)` is smooth".  Two obligations of
`ResidualYNonvanishing.lean` are consequences of it:

* `exists_isotropic_stereoNondegenerate` — some isotropic Tsen section is not a base point of the
  conic family, i.e. its polar against the stereo direction does not vanish identically;
* `exists_stereo_param_nonsingularCubicFiber` — some stereo parameter has a nonsingular cubic fibre.

This module isolates the second half of §4(1) — **the generic conic along `L` is smooth** — as a
single named statement about the discriminant of the polar matrix, and proves the first obligation
from it.

## The finding: this is not a genericity condition at all

For a *smooth* `X` the generic conic along **every** line is smooth, the hardcoded coordinate line
included.  Suppose the conic `Q_y` is singular for every `y ∈ L`.  Over `k(L)` the polar matrix `M`
then has a nonzero kernel vector; clearing denominators and dividing by the gcd gives a vector
`n(y)` of forms on `L`, nowhere zero, with `M(y) n(y) = 0`, so

```
F(n(y), y) = 0  and  ∇_x F(n(y), y) = 2 M(y) n(y) = 0     for all y ∈ L.
```

Differentiating `F(n(y), y) ≡ 0` along `L` and using `∇_x F = 0` shows `∇_y F(n(y), y)` annihilates
the plane of `L`, hence is a multiple `c(y)·λ` of the linear form `λ` cutting out `L`.  Now `c` is a
form of degree `2·deg n + 2 > 0` on `L ≅ ℙ¹`, so it has a zero `y*`, and `(n(y*), y*)` is a singular
point of `X`.  Contrapositive: `X` smooth forces the discriminant of the conic family to be nonzero
somewhere on every line.

So §4(1)'s conic half is automatic and costs the choice of `L` nothing; what genuinely constrains
`L` is the *cubic* discriminant (input (ii) of the split,
`exists_stereo_param_nonsingularCubicFiber`), a condition in `ℙ²_x`, not in `ℙ²_y`.

## Why the root is needed, and why nothing weaker will do

`SpecializedConicFreeDir.specializedConicFreeDirForm_ne_zero_of_smooth` already gives `Q(w) ≠ 0` for
the stereo direction `w = (1, s, 0)`, and that is *not* enough.  Over `K = k(t)` the conic
`x₀² − t·x₁²` has rank two with its two lines conjugate over `K(√t)`, so its only `K`-point is the
vertex `(0 : 0 : 1)`; every isotropic section is then a multiple of the vertex and every polar
`B(v, ·)` vanishes identically, while `Q(1, s, 0) = 1 − t s² ≠ 0`.  For such a conic family
`exists_isotropic_stereoNondegenerate` is **false**.  What excludes it is exactly nondegeneracy of
the polar matrix, i.e. the root below — and, by the argument above, smoothness of `X`.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

/-! ### Polar algebra of a ternary quadratic

Everything here is elementary bilinear algebra over a commutative ring, phrased in the tree's
`polarEval` (which is `B(p, w) = Q(p+w) − Q(p) − Q(w)`, i.e. *twice* the symmetric bilinear
form). -/

section PolarAlgebra

variable {R : Type u} [CommRing R]

/-- The polar form is symmetric. -/
theorem polarEval_comm (Q : MvPolynomial (Fin 3) R) (p w : Fin 3 → R) :
    polarEval Q p w = polarEval Q w p := by
  simp only [polarEval]
  rw [show (fun j => p j + w j) = (fun j => w j + p j) from funext fun j => add_comm _ _]
  ring

/-- The polar form is linear in its first argument. -/
theorem polarEval_linear_left {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    (a b : R) (p w z : Fin 3 → R) :
    polarEval Q (fun i => a * p i + b * w i) z
      = a * polarEval Q p z + b * polarEval Q w z := by
  simp only [polarEval_eq_coeff_sum Q hQ, Fin.sum_univ_three]
  ring

/-- The polar form on the diagonal is twice the value of the quadratic. -/
theorem polarEval_self {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2) (v : Fin 3 → R) :
    polarEval Q v v = 2 * eval v Q := by
  simp only [polarEval_eq_coeff_sum Q hQ, eval_eq_ternaryQuadraticCoeff_sum hQ,
    Fin.sum_univ_three]
  ring

/-- Expanding the polar form over the standard basis in its second argument. -/
theorem polarEval_eq_sum_basis {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    (p w : Fin 3 → R) :
    polarEval Q p w = ∑ a : Fin 3, w a * polarEval Q p (Pi.single a 1) := by
  simp only [polarEval_eq_coeff_sum Q hQ, Fin.sum_univ_three, Pi.single_apply, Fin.ext_iff]
  norm_num
  ring

/-- The polar form is linear in its second argument. -/
theorem polarEval_linear_right {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    (a b : R) (p w z : Fin 3 → R) :
    polarEval Q z (fun i => a * p i + b * w i)
      = a * polarEval Q z p + b * polarEval Q z w := by
  rw [polarEval_comm, polarEval_linear_left hQ, polarEval_comm Q p z, polarEval_comm Q w z]

/-- Polar forms commute with a change of coefficient ring. -/
theorem polarEval_map {S : Type u} [CommRing S] (φ : R →+* S)
    (Q : MvPolynomial (Fin 3) R) (p w : Fin 3 → R) :
    polarEval (map φ Q) (fun i => φ (p i)) (fun i => φ (w i)) = φ (polarEval Q p w) := by
  have hev : ∀ x : Fin 3 → R, eval (fun i => φ (x i)) (map φ Q) = φ (eval x Q) := by
    intro x
    rw [eval_map]
    exact (eval₂_comp φ x Q).symm
  simp only [polarEval, map_sub]
  rw [← hev p, ← hev w, ← hev fun j => p j + w j]
  simp only [map_add]

/-- The polar form vanishes on the zero vector. -/
theorem polarEval_zero_left {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    (w : Fin 3 → R) : polarEval Q 0 w = 0 := by
  simp only [polarEval_eq_coeff_sum Q hQ, Fin.sum_univ_three, Pi.zero_apply]
  ring

/-- The polar matrix `Mᵢⱼ = B(eᵢ, eⱼ)` of a ternary quadratic. -/
def polarMatrix (Q : MvPolynomial (Fin 3) R) : Matrix (Fin 3) (Fin 3) R :=
  Matrix.of fun i j => polarEval Q (Pi.single i 1) (Pi.single j 1)

theorem polarMatrix_apply (Q : MvPolynomial (Fin 3) R) (i j : Fin 3) :
    polarMatrix Q i j = polarEval Q (Pi.single i 1) (Pi.single j 1) := rfl

/-- Polar against a basis vector is a row of the polar matrix applied to the vector. -/
theorem polarEval_basis_eq_mulVec {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    (v : Fin 3 → R) (a : Fin 3) :
    polarEval Q v (Pi.single a 1) = (polarMatrix Q).mulVec v a := by
  rw [polarEval_comm, polarEval_eq_sum_basis hQ]
  simp only [Matrix.mulVec, dotProduct, polarMatrix_apply]
  exact Finset.sum_congr rfl fun i _ => by rw [mul_comm]

/-- **A vector in the radical makes the discriminant vanish.**  Over a domain, a nonzero vector
whose polar against every basis vector vanishes forces `det` of the polar matrix to be zero. -/
theorem det_polarMatrix_eq_zero_of_polarEval_eq_zero
    [IsDomain R] {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    {v : Fin 3 → R} (hv0 : v ≠ 0) (h : ∀ a : Fin 3, polarEval Q v (Pi.single a 1) = 0) :
    (polarMatrix Q).det = 0 := by
  classical
  have hmv : (polarMatrix Q).mulVec v = 0 := by
    funext a
    rw [← polarEval_basis_eq_mulVec hQ v a, h a]
    rfl
  have hadj : ((polarMatrix Q).det) • v = 0 := by
    have hh := congrArg (fun w => (polarMatrix Q).adjugate.mulVec w) hmv
    simp only [Matrix.mulVec_mulVec, Matrix.adjugate_mul, Matrix.mulVec_zero] at hh
    rwa [Matrix.smul_mulVec, Matrix.one_mulVec] at hh
  obtain ⟨a, ha⟩ : ∃ a : Fin 3, v a ≠ 0 := by
    by_contra hall
    push Not at hall
    exact hv0 (funext hall)
  have := congrFun hadj a
  simp only [Pi.smul_apply, Pi.zero_apply, smul_eq_mul] at this
  exact (mul_eq_zero.mp this).resolve_right ha

end PolarAlgebra

/-! ### The core lemmas

Two facts about a conic with nondegenerate polar matrix, over any domain.

* An isotropic vector **off the plane `{x₂ = 0}` is automatically stereo-non-degenerate** — the
  plane the stereo direction `(1, s, 0)` sweeps is exactly where the degenerate isotropic vectors
  are trapped.
* From any isotropic vector one gets an isotropic vector **off that plane**, as the stereographic
  second intersection along a direction chosen to meet it.

Together they give the strengthened section: isotropic, off the plane, and non-degenerate.  The
second property is what makes the stereographic family sweep a surface rather than a line, which is
what the cubic-side obligation needs; see `ResidualYNonvanishing`. -/

section Core

variable {R : Type u} [CommRing R] [IsDomain R]

/-- **A degenerate isotropic vector lies in the plane `{x₂ = 0}`.**

If the polar against `e₀` and `e₁` both vanish then, the polar matrix being nonsingular, the polar
against `e₂` does not; and `B(v, v) = 2 Q(v) = 0` expands to `v₂ · B(v, e₂)`. -/
theorem third_eq_zero_of_isotropic_of_polarEval_eq_zero
    {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    (hdet : (polarMatrix Q).det ≠ 0)
    {v : Fin 3 → R} (hv0 : v ≠ 0) (hv : eval v Q = 0)
    (h0 : polarEval Q v (Pi.single 0 1) = 0) (h1 : polarEval Q v (Pi.single 1 1) = 0) :
    v 2 = 0 := by
  classical
  have hb2 : polarEval Q v (Pi.single 2 1) ≠ 0 := by
    intro hb2z
    refine hdet (det_polarMatrix_eq_zero_of_polarEval_eq_zero hQ hv0 fun a => ?_)
    fin_cases a
    · exact h0
    · exact h1
    · exact hb2z
  have hself : polarEval Q v v = 2 * eval v Q := polarEval_self hQ v
  rw [hv, mul_zero, polarEval_eq_sum_basis hQ v v, Fin.sum_univ_three, h0, h1] at hself
  simp only [mul_zero, zero_add, add_zero] at hself
  exact (mul_eq_zero.mp hself).resolve_right hb2

/-- **An isotropic vector off the plane `{x₂ = 0}` is stereo-non-degenerate**, with no further
hypothesis: this is the contrapositive of the previous lemma. -/
theorem polarEval_ne_zero_of_isotropic_of_third_ne_zero
    {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    (hdet : (polarMatrix Q).det ≠ 0)
    {v : Fin 3 → R} (hv : eval v Q = 0) (hv2 : v 2 ≠ 0) :
    polarEval Q v (Pi.single 0 1) ≠ 0 ∨ polarEval Q v (Pi.single 1 1) ≠ 0 := by
  by_contra hcon
  push Not at hcon
  obtain ⟨h0, h1⟩ := hcon
  have hv0 : v ≠ 0 := fun hz => hv2 (by rw [hz]; rfl)
  exact hv2 (third_eq_zero_of_isotropic_of_polarEval_eq_zero hQ hdet hv0 hv h0 h1)

/-- **From any isotropic vector, one off the plane `{x₂ = 0}`.**

If `v` is already off the plane there is nothing to do.  Otherwise the stereographic second
intersection `stereoAlg Q v w` has last coordinate `−B(v, w)·w₂`, so any direction `w` with
`w₂ ≠ 0` and `B(v, w) ≠ 0` works: take `w = e₂`, or `w = e₂ + eₐ` when the polar against `e₂`
happens to vanish — some polar is nonzero because `v` is not in the radical. -/
theorem exists_isotropic_third_ne_zero
    {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    (hdet : (polarMatrix Q).det ≠ 0)
    {v : Fin 3 → R} (hv0 : v ≠ 0) (hv : eval v Q = 0) :
    ∃ u : Fin 3 → R, eval u Q = 0 ∧ u 2 ≠ 0 := by
  classical
  by_cases hv2 : v 2 ≠ 0
  · exact ⟨v, hv, hv2⟩
  push Not at hv2
  obtain ⟨w, hw2, hbw⟩ : ∃ w : Fin 3 → R, w 2 = 1 ∧ polarEval Q v w ≠ 0 := by
    by_cases hb2 : polarEval Q v (Pi.single 2 1) ≠ 0
    · exact ⟨Pi.single 2 1, by simp, hb2⟩
    push Not at hb2
    obtain ⟨a, ha⟩ : ∃ a : Fin 3, polarEval Q v (Pi.single a 1) ≠ 0 := by
      by_contra hall
      push Not at hall
      exact hdet (det_polarMatrix_eq_zero_of_polarEval_eq_zero hQ hv0 hall)
    have ha2 : a ≠ 2 := by
      intro h
      rw [h] at ha
      exact ha hb2
    refine ⟨fun i => 1 * (Pi.single (2 : Fin 3) (1 : R) : Fin 3 → R) i
        + 1 * (Pi.single a (1 : R) : Fin 3 → R) i, ?_, ?_⟩
    · simp [Ne.symm ha2]
    · rw [polarEval_linear_right hQ, hb2, one_mul, one_mul, zero_add]
      exact ha
  refine ⟨stereoAlg Q v w, ?_, ?_⟩
  · rw [eval_stereoAlg Q hQ v w, hv, mul_zero]
  · simp only [stereoAlg, hv2, mul_zero, zero_sub, hw2, mul_one, neg_ne_zero]
    exact hbw

/-- **The strengthened section.**

An isotropic vector that is nonzero, lies off the plane `{x₂ = 0}`, and is stereo-non-degenerate.
The last property is free once the second holds. -/
theorem exists_isotropic_polarEval_ne_zero
    {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    (hdet : (polarMatrix Q).det ≠ 0)
    {v : Fin 3 → R} (hv0 : v ≠ 0) (hv : eval v Q = 0) :
    ∃ u : Fin 3 → R, u ≠ 0 ∧ eval u Q = 0 ∧ u 2 ≠ 0 ∧
      (polarEval Q u (Pi.single 0 1) ≠ 0 ∨ polarEval Q u (Pi.single 1 1) ≠ 0) := by
  obtain ⟨u, hu, hu2⟩ := exists_isotropic_third_ne_zero hQ hdet hv0 hv
  exact ⟨u, fun hz => hu2 (by rw [hz]; rfl), hu, hu2,
    polarEval_ne_zero_of_isotropic_of_third_ne_zero hQ hdet hu hu2⟩

end Core

/-! ### The generic conic along the coordinate line -/

section CoordinateLine

variable {k : Type u} [Field k]

/-- **The discriminant of the generic conic along the coordinate line**: the determinant of the
polar matrix of `Q_t`, an element of `k[t]`.

It is nonzero exactly when the generic conic over `k(t)` is a smooth conic — §4(1) of the source
proof, in the only form the residual construction consumes. -/
def coordinateLineConicDiscriminant (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    Polynomial k :=
  (polarMatrix (coordinateLineSpecializedConicPoly F)).det

/-- Isotropy in the matrix form the Tsen machinery uses is isotropy for the conic. -/
theorem ternaryQuadraticPoly_eval_coordinateLine
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k) :
    TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v
      = eval v (coordinateLineSpecializedConicPoly F) := by
  rw [eval_eq_ternaryQuadraticCoeff_sum (coordinateLineSpecializedConicPoly_isHomogeneous hF)]
  rfl

/-- **The polar condition over `k[t]` is stereo non-degeneracy over `k[t,s]`.**

`affineTwoStereoDir = (1, s, 0)` is `e₀ + s·e₁`, so the polar against it is
`B(v, e₀) + s·B(v, e₁)`; that vanishes identically in `(t, s)` only if both coefficients vanish
in `k[t]`.  The conclusion is `ResidualYNonvanishing.StereoNondegenerate F v` unfolded — this module
is imported *by* that one, so the abbreviation is not available here. -/
theorem polarEval_stereoDir_ne_zero_of_polarEval_ne_zero [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (h : polarEval (coordinateLineSpecializedConicPoly F) v (Pi.single 0 1) ≠ 0 ∨
      polarEval (coordinateLineSpecializedConicPoly F) v (Pi.single 1 1) ≠ 0) :
    polarEval (specializedConicPullback F) (liftTsenSection v) affineTwoStereoDir ≠ 0 := by
  classical
  set Q := coordinateLineSpecializedConicPoly F with hQdef
  set φ := (liftPolyTHom : Polynomial k →+* affineTwoRing k) with hφ
  have hQhom : Q.IsHomogeneous 2 := coordinateLineSpecializedConicPoly_isHomogeneous hF
  have hpull : specializedConicPullback F = map φ Q :=
    (specializedConicPullback_eq_map_eval₂ F).symm
  have hlift : liftTsenSection v = fun i => φ (v i) := rfl
  -- the stereo direction is `e₀ + s·e₁`, both lifted from `k[t]`
  have hdir : (affineTwoStereoDir : Fin 3 → affineTwoRing k)
      = fun i => 1 * (fun j => φ ((Pi.single 0 1 : Fin 3 → Polynomial k) j)) i
        + affineTwoCoord1 k * (fun j => φ ((Pi.single 1 1 : Fin 3 → Polynomial k) j)) i := by
    funext i
    fin_cases i <;>
      simp [affineTwoStereoDir, hφ, liftPolyTHom]
  -- expand the polar
  have hexp : polarEval (specializedConicPullback F) (liftTsenSection v) affineTwoStereoDir
      = φ (polarEval Q v (Pi.single 0 1))
        + affineTwoCoord1 k * φ (polarEval Q v (Pi.single 1 1)) := by
    rw [hpull, hlift, hdir, polarEval_linear_right (Q := map φ Q) (hQhom.map φ), polarEval_map,
      polarEval_map, one_mul]
  rw [hexp]
  intro hzero
  -- evaluate at `(t₀, 0)` and `(t₀, 1)`
  have hval : ∀ t₀ s₀ : k,
      Polynomial.eval t₀ (polarEval Q v (Pi.single 0 1))
        + s₀ * Polynomial.eval t₀ (polarEval Q v (Pi.single 1 1)) = 0 := by
    intro t₀ s₀
    have hs1 : evalAffineTwoPoint t₀ s₀ (affineTwoCoord1 k) = s₀ := by
      simp [evalAffineTwoPoint, affineTwoCoord1]
    have := congrArg (evalAffineTwoPoint t₀ s₀) hzero
    simpa [hφ, map_add, map_mul, ← liftPolyT_eq_hom, evalAffineTwoPoint_liftPolyT, hs1] using this
  have h0 : polarEval Q v (Pi.single 0 1) = 0 := by
    refine Polynomial.funext fun t₀ => ?_
    simpa using hval t₀ 0
  have h1 : polarEval Q v (Pi.single 1 1) = 0 := by
    refine Polynomial.funext fun t₀ => ?_
    have := hval t₀ 1
    rw [h0] at this
    simpa using this
  rcases h with h | h
  · exact h h0
  · exact h h1

variable [IsAlgClosed k] [CharZero k]

omit [CharZero k] in
/-- **The first good-line obligation, from the root.**

Some isotropic Tsen section along the coordinate line lies off the plane `{x₂ = 0}` and is
stereo-non-degenerate, as soon as the generic conic there is smooth.  Tsen's theorem supplies one
isotropic section; a stereographic second intersection moves it off the plane if it started there;
and being off the plane makes non-degeneracy automatic, because nondegeneracy of the polar matrix
traps every degenerate isotropic vector inside `{x₂ = 0}`.

The third coordinate is what the cubic-side obligation needs: with `v₂ ≠ 0` the stereographic family
sweeps each conic and its image is dense in `ℙ²_x`, whereas a `v` inside `{x₂ = 0}` would keep the
whole family inside a line.

`CharZero` is not needed: an algebraically closed field is infinite, which is all the argument
uses. -/
theorem exists_isotropic_stereoNondegenerate_of_disc_ne_zero
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hdisc : coordinateLineConicDiscriminant F ≠ 0) :
    ∃ v : Fin 3 → Polynomial k, v ≠ 0 ∧
      TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0 ∧ v 2 ≠ 0 ∧
      polarEval (specializedConicPullback F) (liftTsenSection v) affineTwoStereoDir ≠ 0 := by
  classical
  obtain ⟨v₀, hv₀0, hv₀⟩ := exists_isotropic_coordinateLine_conic k F
  have hQhom : (coordinateLineSpecializedConicPoly F).IsHomogeneous 2 :=
    coordinateLineSpecializedConicPoly_isHomogeneous hF
  have hv₀' : eval v₀ (coordinateLineSpecializedConicPoly F) = 0 := by
    rw [← ternaryQuadraticPoly_eval_coordinateLine F hF]
    exact hv₀
  obtain ⟨u, hu0, huiso, hu2, hupolar⟩ :=
    exists_isotropic_polarEval_ne_zero hQhom hdisc hv₀0 hv₀'
  refine ⟨u, hu0, ?_, hu2, polarEval_stereoDir_ne_zero_of_polarEval_ne_zero F hF u hupolar⟩
  rw [ternaryQuadraticPoly_eval_coordinateLine F hF]
  exact huiso

/--
**The shared root of both good-line conditions: the generic conic along the line is smooth.**

*Status.* Obligation.  This is §4(1) of `certificates/all_smooth_tangent_residual_theorem.md`, in
the form the development consumes, and it is the single input from which
`exists_isotropic_stereoNondegenerate` follows (see
`exists_isotropic_stereoNondegenerate_of_disc_ne_zero`, proved).

*It is not a condition on `L`.*  The source chooses `L` outside the conic discriminant; in fact no
line lies inside it when `X` is smooth, so the hardcoded coordinate line is as good as any.  The
argument, spelled out in the module docstring: a line inside the discriminant carries a nowhere-zero
kernel section `n(y)` of the polar matrix; then `(n(y), y) ∈ X` with `∇_x F = 0` along it,
differentiating `F(n(y), y) ≡ 0` along `L` forces `∇_y F(n(y), y)` to be a multiple `c(y)·λ` of the
form cutting out `L`, and `c` is a form of positive degree on `L ≅ ℙ¹`, hence has a zero — a
singular point of `X`.

*What is owed*, in four pieces.  This is the decomposition to execute; each piece is stated in the
vocabulary the tree already has.

1. **The vertex is a singular point of the conic.**  From `M(y)·n = 0` conclude
   `eval (Sum.elim n y) F = 0` and `eval (Sum.elim n y) (pderiv (.inl i) F) = 0` for every `i`.  The
   value is free — `2 · Q(n) = B(n, n) = Σ_a n_a B(n, e_a) = 0` and `2 ≠ 0` — and the `x`-partials
   reduce, through `specializeSecondCoordinates_pderiv_inl`, to the identity
   `eval n (pderiv i Q) = polarEval Q n (Pi.single i 1)` for a ternary quadratic.  **That identity
   is
   not in the tree**; `HomogeneousQuadraticEval` has the value formula
   (`eval_eq_ternaryQuadraticCoeff_sum`) but no gradient formula.  It is the analogue for quadrics
   of
   `PlaneCubicPartials`, provable the same way — `coeff_pderiv` plus the monomial expansion — in
   perhaps sixty lines.

2. **The family derivative vanishes at the vertex.**  This is the differentiation step, and it does
   *not* need the chain rule on `F`: writing `Q_t(n(t)) = Σ_{i,j} c_{ij}(t) n_i(t) n_j(t)` and
   differentiating in `t` gives `(∂_t Q)(n) + B_Q(n, n')`, whose second term is killed by the kernel
   condition.  So `Polynomial.derivative` of the coefficient sum plus `polarEval_eq_coeff_sum` and
   `ring` suffice — no `pderiv_aeval`.  Converting `(∂_t Q)(n)` into `∂F/∂y₁(n, y)` is the `y`-chain
   rule at the linear point `y(t) = (1, t, 0)`, whose derivative is the constant `(0, 1, 0)`.

3. **Euler closes the `y`-gradient.**  `y₀ ∂F/∂y₀ + y₁ ∂F/∂y₁ + y₂ ∂F/∂y₂ = 3F = 0` at the point,
and
   `y = (1, t, 0)`, so `∂F/∂y₀ = −t ∂F/∂y₁ = 0`.  Only `∂F/∂y₂` survives — this is the statement
   that
   `∇_y F` is a multiple of the equation of `L`.  Then `exists_pderiv_ne_zero_of_smooth`
   (`BiprojectiveSmoothCriterion`) forces `∂F/∂y₂(n(t), (1,t,0)) ≠ 0` for every `t`, after
   normalising `n(t)` in a chart.

4. **A point where the last partial vanishes.**  Two sub-pieces.  *(a)* A **primitive** kernel
   section: take any nonzero kernel vector over `k(t)`, clear denominators, divide by the gcd of the
   three entries (`k[t]` is a Euclidean domain and Mathlib has `gcd_div_gcd_div_gcd`); primitivity
   gives `n(t₀) ≠ 0` for every `t₀ ∈ k`.  *(b)* The **point at infinity**.  In the affine chart the
   function `c(t) = ∂F/∂y₂(n(t), (1,t,0))` has no root, hence — `k` algebraically closed — is a
   nonzero *constant*, which is not yet a contradiction: the zero of `c` sits at `L`'s point at
   infinity.  The cheapest repair is not to homogenise everything but to compare **leading
   coefficients**: with `m = max_i deg n_i` and `n_∞` the vector of degree-`m` coefficients (nonzero
   by the choice of `m`), the coefficient of `t^{2m+2}` in `c` is `∂F/∂y₂(n_∞, (0,1,0))`, because
   `∂F/∂y₂` is bihomogeneous of bidegree `(2,2)` and only the `y₁²` term survives at `y = (0,1,0)`.
   So `c` constant forces that coefficient to vanish, and `(n_∞, (0,1,0))` is the singular point.
   The same top-coefficient argument transports the kernel condition `M(y) n = 0` and `F(n, y) = 0`
   to `y = (0,1,0)`.

`char k = 0` is used twice: `∇_x F = 2 M x` needs `2 ≠ 0`, and the `Polynomial.funext` arguments
need
`k` infinite.
-/
theorem coordinateLineConicDiscriminant_ne_zero_of_smooth
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    coordinateLineConicDiscriminant F ≠ 0 :=
  sorry

end CoordinateLine

end

end BConicBundleMultisections
