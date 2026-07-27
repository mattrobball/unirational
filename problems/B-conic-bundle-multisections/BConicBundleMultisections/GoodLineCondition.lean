/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualYCoordsPureT
public import BConicBundleMultisections.ConicDiscriminantAssembly
public import BConicBundleMultisections.ConicDiscriminantKernel
public import BConicBundleMultisections.TernaryQuadraticGradient
public import BConicBundleMultisections.BiprojectiveSmoothCriterion
public import BConicBundleMultisections.BiprojectiveSmoothBaseChange

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

/-- A nonzero polar pairing prevents the stereographic second-intersection vector from
vanishing.  This is the projective-point nondegeneracy needed by the arbitrary-line chart; it
uses only isotropy of the chosen section, not smoothness of the ambient hypersurface. -/
theorem stereoAlg_ne_zero_of_isotropic_of_polar_ne_zero [IsDomain R]
    {Q : MvPolynomial (Fin 3) R} (hQ : Q.IsHomogeneous 2)
    (p w : Fin 3 → R) (hp : eval p Q = 0) (hpolar : polarEval Q p w ≠ 0) :
    stereoAlg Q p w ≠ 0 := by
  intro hzero
  have hz : polarEval Q p (stereoAlg Q p w) = 0 := by
    rw [hzero]
    have hzeroVec : (0 : Fin 3 → R) = fun i => 0 * p i + 0 * w i := by
      funext i
      simp
    rw [hzeroVec, polarEval_linear_right hQ]
    simp
  have hvec : stereoAlg Q p w = fun i =>
      eval w Q * p i + (-polarEval Q p w) * w i := by
    funext i
    simp only [stereoAlg]
    ring
  have hexp : polarEval Q p (stereoAlg Q p w) = -(polarEval Q p w) ^ 2 := by
    rw [hvec, polarEval_linear_right hQ, polarEval_self hQ, hp]
    ring
  rw [hexp] at hz
  exact hpolar (sq_eq_zero_iff.mp (neg_eq_zero.mp hz))

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

/-- Polar matrix commutes with coefficient ring maps (same universe). -/
theorem polarMatrix_map {S : Type u} [CommRing S]
    (φ : R →+* S) (Q : MvPolynomial (Fin 3) R) :
    polarMatrix (map φ Q) = (polarMatrix Q).map φ := by
  ext i j
  simp only [polarMatrix_apply, Matrix.map_apply]
  have hsingle (a : Fin 3) :
      (fun b : Fin 3 => φ ((Pi.single a (1 : R) : Fin 3 → R) b)) =
        (Pi.single a (1 : S) : Fin 3 → S) := by
    ext b
    by_cases h : b = a
    · subst h; simp [Pi.single_eq_same, map_one]
    · simp [Pi.single_eq_of_ne h, map_zero]
  rw [← hsingle i, ← hsingle j]
  exact polarEval_map φ Q (Pi.single i (1 : R)) (Pi.single j (1 : R))

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

variable [NeZero (2 : k)] [NeZero (3 : k)]

omit [NeZero (2 : k)] [NeZero (3 : k)] in
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
theorem exists_isotropic_stereoNondegenerate_of_disc_ne_zero [IsAlgClosed k]
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


/-- From vanishing discriminant: a kernel section with no common root on which the specialized
conic vanishes. -/
theorem exists_kernel_section_of_disc_eq_zero
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hdisc : coordinateLineConicDiscriminant F = 0) :
    ∃ n : Fin 3 → Polynomial k,
      n ≠ 0 ∧ (polarMatrix (coordinateLineSpecializedConicPoly F)).mulVec n = 0 ∧
        (∀ t : k, ∃ i, (n i).eval t ≠ 0) ∧
          MvPolynomial.eval n (coordinateLineSpecializedConicPoly F) = 0 := by
  classical
  set Q := coordinateLineSpecializedConicPoly F
  set M := polarMatrix Q
  have hQhom : Q.IsHomogeneous 2 := coordinateLineSpecializedConicPoly_isHomogeneous hF
  have hMdet : M.det = 0 := by simpa [coordinateLineConicDiscriminant, Q, M] using hdisc
  obtain ⟨n, hn0, hker, hnocom⟩ := exists_kernel_vector_no_common_root M hMdet
  have hpol (a : Fin 3) : polarEval Q n (Pi.single a 1) = 0 := by
    have := congrFun hker a
    rwa [← polarEval_basis_eq_mulVec hQhom n a] at this
  have hQn : MvPolynomial.eval n Q = 0 := by
    have hself := polarEval_self hQhom n
    have hsum0 : polarEval Q n n = 0 := by
      rw [polarEval_eq_sum_basis hQhom n n]
      exact Finset.sum_eq_zero fun a _ => by simp [hpol a]
    have h2eq : (2 : Polynomial k) * MvPolynomial.eval n Q = 0 := by
      rw [← hself, hsum0]
    have h2ne : (2 : Polynomial k) ≠ 0 := by
      intro h
      apply two_ne_zero (α := k)
      have hC : Polynomial.C (2 : k) = 0 := by
        simpa [map_ofNat] using h
      exact Polynomial.C_eq_zero.mp hC
    exact (mul_eq_zero.mp h2eq).resolve_left h2ne
  exact ⟨n, hn0, hker, hnocom, hQn⟩


/-- Transport of the specialized conic vanishing to the biprojective equation along the line. -/
theorem eval_F_along_kernel_section
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (n : Fin 3 → Polynomial k)
    (hQn : MvPolynomial.eval n (coordinateLineSpecializedConicPoly F) = 0) :
    MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
      (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) F) = 0 := by
  simpa [coordinateLineSpecializedConicPoly, eval_specializeSecondCoordinates] using hQn

/-- First-block partials of `F` vanish along a polar-kernel section of the specialized conic. -/
theorem eval_pderiv_inl_along_kernel_section
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (n : Fin 3 → Polynomial k)
    (hker : (polarMatrix (coordinateLineSpecializedConicPoly F)).mulVec n = 0)
    (i : Fin 3) :
    MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
      (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
        (MvPolynomial.pderiv (.inl i) F)) = 0 := by
  classical
  set Q := coordinateLineSpecializedConicPoly F
  have hQhom : Q.IsHomogeneous 2 := coordinateLineSpecializedConicPoly_isHomogeneous hF
  have hpol : polarEval Q n (Pi.single i 1) = 0 := by
    have := congrFun hker i
    rwa [← polarEval_basis_eq_mulVec hQhom n i] at this
  have hpQ : MvPolynomial.eval n (MvPolynomial.pderiv i Q) = 0 := by
    rw [eval_pderiv_eq_polarEval_single hQhom n i, hpol]
  have hpmap :
      MvPolynomial.pderiv (.inl i) (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) F) =
        MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
          (MvPolynomial.pderiv (.inl i) F) := MvPolynomial.pderiv_map
  have hcomm :
      MvPolynomial.pderiv i Q =
        specializeSecondCoordinates (m := 2) (coordinateLinePoint (Polynomial k) Polynomial.X)
          (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
            (MvPolynomial.pderiv (.inl i) F)) := by
    simp only [Q, coordinateLineSpecializedConicPoly, ← specializeSecondCoordinates_pderiv_inl,
      hpmap]
  have hspec :
      MvPolynomial.eval n
        (specializeSecondCoordinates (m := 2) (coordinateLinePoint (Polynomial k) Polynomial.X)
          (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
            (MvPolynomial.pderiv (.inl i) F))) = 0 := by
    rwa [← hcomm]
  simpa [eval_specializeSecondCoordinates] using hspec


/-- Along a polar-kernel section of the specialized conic, `∂F/∂y₁` vanishes as a univariate
polynomial (family derivative + kernel kills the polar term). -/
theorem eval_pderiv_inr_one_along_kernel_section
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (n : Fin 3 → Polynomial k)
    (hFpoly :
      MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
        (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) F) = 0)
    (hxpderiv : ∀ i : Fin 3,
      MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
        (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
          (MvPolynomial.pderiv (.inl i) F)) = 0) :
    MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
      (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
        (MvPolynomial.pderiv (.inr 1) F)) = 0 := by
  classical
  set yPath : Fin 3 → Polynomial k := coordinateLinePoint (Polynomial k) Polynomial.X
  set path : BiprojectiveCoordinate 2 2 → Polynomial k := Sum.elim n yPath
  have hder := derivative_eval_map_C (σ := BiprojectiveCoordinate 2 2) F path
  have hleft :
      Polynomial.derivative
        (MvPolynomial.eval path (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) F)) = 0 := by
    simp [path, hFpoly]
  rw [hleft] at hder
  have hyderiv0 : Polynomial.derivative (yPath 0) = 0 := by
    simp [yPath, coordinateLinePoint]
  have hyderiv1 : Polynomial.derivative (yPath 1) = 1 := by
    simp [yPath, coordinateLinePoint]
  have hyderiv2 : Polynomial.derivative (yPath 2) = 0 := by
    simp [yPath, coordinateLinePoint]
  have hinl :
      (∑ i : Fin 3, Polynomial.derivative (n i) *
          MvPolynomial.eval path
            (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
              (MvPolynomial.pderiv (.inl i) F))) = 0 :=
    Finset.sum_eq_zero fun i _ => by
      have := hxpderiv i
      simp [path, this]
  have hinr :
      (∑ j : Fin 3, Polynomial.derivative (yPath j) *
          MvPolynomial.eval path
            (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
              (MvPolynomial.pderiv (.inr j) F))) =
        MvPolynomial.eval path
          (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
            (MvPolynomial.pderiv (.inr 1) F)) := by
    simp only [Fin.sum_univ_three, hyderiv0, hyderiv1, hyderiv2, zero_mul, one_mul, add_zero,
      zero_add]
  have hsplit :
      (∑ z : BiprojectiveCoordinate 2 2,
          Polynomial.derivative (path z) *
            MvPolynomial.eval path
              (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
                (MvPolynomial.pderiv z F))) =
        (∑ i : Fin 3, Polynomial.derivative (n i) *
            MvPolynomial.eval path
              (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
                (MvPolynomial.pderiv (.inl i) F))) +
          (∑ j : Fin 3, Polynomial.derivative (yPath j) *
              MvPolynomial.eval path
                (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
                  (MvPolynomial.pderiv (.inr j) F))) := by
    simpa [path, Sum.elim_inl, Sum.elim_inr] using
      (Fintype.sum_sum_type
        (fun z : BiprojectiveCoordinate 2 2 =>
          Polynomial.derivative (path z) *
            MvPolynomial.eval path
              (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
                (MvPolynomial.pderiv z F)))).symm
  have htotal := hder.symm
  rw [hsplit, hinl, hinr, zero_add] at htotal
  exact htotal


/-- Along a polar-kernel section, Euler's identity forces `∂F/∂y₀` to vanish as a univariate
polynomial once `∂F/∂y₁` does. -/
theorem eval_pderiv_inr_zero_along_kernel_section
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (n : Fin 3 → Polynomial k)
    (hFpoly :
      MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
        (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) F) = 0)
    (hy1 :
      MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
        (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
          (MvPolynomial.pderiv (.inr 1) F)) = 0) :
    MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
      (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
        (MvPolynomial.pderiv (.inr 0) F)) = 0 := by
  classical
  set yPath : Fin 3 → Polynomial k := coordinateLinePoint (Polynomial k) Polynomial.X
  set path : BiprojectiveCoordinate 2 2 → Polynomial k := Sum.elim n yPath
  have hEuler :=
    congrArg
      (fun G => MvPolynomial.eval path (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) G))
      hF.sum_inr_X_mul_pderiv
  -- After map/eval: ∑ yⱼ * ∂F/∂yⱼ = 3 • F
  have hleft :
      (∑ j : Fin 3,
        yPath j *
          MvPolynomial.eval path
            (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
              (MvPolynomial.pderiv (.inr j) F))) =
        (3 : Polynomial k) *
          MvPolynomial.eval path (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) F) := by
    simp only [map_sum, map_mul, map_nsmul, map_X, MvPolynomial.eval_sum, MvPolynomial.eval_mul,
      nsmul_eq_mul] at hEuler ⊢
    convert hEuler using 1
    · refine Finset.sum_congr rfl fun j _ => ?_
      simp [path, yPath, Sum.elim_inr]
    · simp [nsmul_eq_mul]
  -- Expand: y0=1, y1=X, y2=0
  simp only [hFpoly, mul_zero, Fin.sum_univ_three, yPath, coordinateLinePoint_zero,
    coordinateLinePoint_one, coordinateLinePoint_two, one_mul, zero_mul, add_zero] at hleft
  -- hleft: ∂/∂y0 + X * ∂/∂y1 = 0
  simpa [path, hy1, mul_zero, add_zero] using hleft



/-- Helper: first-block rescaling for evaluation of a bihomogeneous form. -/
private theorem eval_smul_first_bidegree
    {d e : ℕ} {G : MvPolynomial (BiprojectiveCoordinate 2 2) k}
    (hG : IsBihomogeneousOfBidegree d e G) (r : k) (x y : Fin 3 → k) :
    MvPolynomial.eval (Sum.elim (fun i => r * x i) y) G =
      r ^ d * MvPolynomial.eval (Sum.elim x y) G := by
  -- reduce to specializeFirstCoordinates_smul
  have hx : (fun i => r * x i) = (r • x : Fin 3 → k) := by
    funext i; simp [Pi.smul_apply, smul_eq_mul]
  have h := congrArg (MvPolynomial.eval y) (hG.specializeFirstCoordinates_smul r x)
  -- h : eval y (specializeFirstCoordinates (r • x) G) = eval y (C (r^d) * specializeFirstCoordinates x G)
  rw [eval_specializeFirstCoordinates, map_mul, MvPolynomial.eval_C, eval_specializeFirstCoordinates] at h
  rw [hx, h]

/-- Specialize a mapped polynomial along the kernel path at a scalar parameter. -/
private theorem eval_t_map_path
    (G : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (n : Fin 3 → Polynomial k) (t : k) :
    Polynomial.eval t
        (MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
          (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) G)) =
      MvPolynomial.eval
        (Sum.elim (fun i => Polynomial.eval t (n i)) (coordinateLinePoint k t)) G := by
  have hpath :
      (fun z : BiprojectiveCoordinate 2 2 =>
          Polynomial.eval t (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X) z)) =
        Sum.elim (fun i => Polynomial.eval t (n i)) (coordinateLinePoint k t) := by
    funext z
    cases z with
    | inl i => rfl
    | inr j =>
        fin_cases j
        · -- y₀ = 1
          change Polynomial.eval t 1 = (1 : k)
          simp
        · -- y₁ = X
          change Polynomial.eval t Polynomial.X = t
          simp
        · -- y₂ = 0
          change Polynomial.eval t 0 = (0 : k)
          simp
  rw [eval_eval_map_C, hpath]


theorem eval_last_partial_ne_zero_along_kernel_section
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (n : Fin 3 → Polynomial k)
    (hnocom : ∀ t : k, ∃ i, (n i).eval t ≠ 0)
    (hFpoly :
      MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
        (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) F) = 0)
    (hxpderiv : ∀ i : Fin 3,
      MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
        (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
          (MvPolynomial.pderiv (.inl i) F)) = 0)
    (hy0 :
      MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
        (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
          (MvPolynomial.pderiv (.inr 0) F)) = 0)
    (hy1 :
      MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
        (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
          (MvPolynomial.pderiv (.inr 1) F)) = 0)
    (t : k) :
    Polynomial.eval t
      (MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
        (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
          (MvPolynomial.pderiv (.inr 2) F))) ≠ 0 := by
  classical
  set nt : Fin 3 → k := fun i => Polynomial.eval t (n i)
  set yt : Fin 3 → k := coordinateLinePoint k t
  have hnt0 : nt ≠ 0 := by
    intro h
    obtain ⟨i, hi⟩ := hnocom t
    exact hi (by simpa [nt] using congrFun h i)
  have hFpt : MvPolynomial.eval (Sum.elim nt yt) F = 0 := by
    have h := congrArg (Polynomial.eval t) hFpoly
    rw [eval_t_map_path F n t, Polynomial.eval_zero] at h
    simpa [nt, yt] using h
  have hxp (i : Fin 3) :
      MvPolynomial.eval (Sum.elim nt yt) (MvPolynomial.pderiv (.inl i) F) = 0 := by
    have h := congrArg (Polynomial.eval t) (hxpderiv i)
    rw [eval_t_map_path _ n t, Polynomial.eval_zero] at h
    simpa [nt, yt] using h
  have hyp0' : MvPolynomial.eval (Sum.elim nt yt) (MvPolynomial.pderiv (.inr 0) F) = 0 := by
    have h := congrArg (Polynomial.eval t) hy0
    rw [eval_t_map_path _ n t, Polynomial.eval_zero] at h
    simpa [nt, yt] using h
  have hyp1' : MvPolynomial.eval (Sum.elim nt yt) (MvPolynomial.pderiv (.inr 1) F) = 0 := by
    have h := congrArg (Polynomial.eval t) hy1
    rw [eval_t_map_path _ n t, Polynomial.eval_zero] at h
    simpa [nt, yt] using h
  obtain ⟨i0, hi0⟩ : ∃ i0, nt i0 ≠ 0 := by
    by_contra h; push Not at h; exact hnt0 (funext h)
  set r : k := (nt i0)⁻¹
  set n1 : Fin 3 → k := fun i => r * nt i with hn1
  have hi1 : n1 i0 = 1 := by simp [n1, r, hi0]
  have hyj : yt 0 = 1 := by simp [yt, coordinateLinePoint]
  have hne : affineChartEquation 2 2 k i0 0 F ≠ 0 :=
    BiprojectiveSpace.affineChartEquation_ne_zero 2 2 k i0 0 F hF hF0
  have hF1 : MvPolynomial.eval (Sum.elim n1 yt) F = 0 := by
    have h := eval_smul_first_bidegree hF r nt yt
    -- n1 = fun i => r * nt i
    simpa [n1, hFpt] using h
  obtain ⟨z, hz⟩ :=
    BiprojectiveSpace.exists_pderiv_ne_zero_of_smooth 2 2 k F hF i0 0 hne n1 yt hi1 hyj hF1
  -- Scaling formulas
  have sc_inl (i : Fin 3) :
      MvPolynomial.eval (Sum.elim n1 yt) (MvPolynomial.pderiv (.inl i) F) =
        r * MvPolynomial.eval (Sum.elim nt yt) (MvPolynomial.pderiv (.inl i) F) := by
    have hp : IsBihomogeneousOfBidegree 1 3 (MvPolynomial.pderiv (.inl i) F) :=
      hF.pderiv_inl (by decide) i
    simpa [n1, pow_one] using eval_smul_first_bidegree hp r nt yt
  have sc_inr (j : Fin 3) :
      MvPolynomial.eval (Sum.elim n1 yt) (MvPolynomial.pderiv (.inr j) F) =
        r ^ 2 * MvPolynomial.eval (Sum.elim nt yt) (MvPolynomial.pderiv (.inr j) F) := by
    have hp : IsBihomogeneousOfBidegree 2 2 (MvPolynomial.pderiv (.inr j) F) :=
      hF.pderiv_inr (by decide) j
    simpa [n1] using eval_smul_first_bidegree hp r nt yt
  -- Pointwise vanishing of all but y2 partials at the specialized (unnormalized) point
  have van_inr (j : Fin 3) (hj : j ≠ 2) :
      MvPolynomial.eval (Sum.elim nt yt) (MvPolynomial.pderiv (.inr j) F) = 0 := by
    match j, hj with
    | ⟨0, _⟩, _ => exact hyp0'
    | ⟨1, _⟩, _ => exact hyp1'
    | ⟨2, _⟩, hj => exact (hj rfl).elim
  have hne2 : MvPolynomial.eval (Sum.elim n1 yt) (MvPolynomial.pderiv (.inr 2) F) ≠ 0 := by
    intro h2
    apply hz
    match z with
    | Sum.inl i => rw [sc_inl i, hxp i, mul_zero]
    | Sum.inr j =>
        by_cases hj : j = 2
        · subst hj; exact h2
        · rw [sc_inr j, van_inr j hj, mul_zero]
  intro hcz
  apply hne2
  have hct := eval_t_map_path (MvPolynomial.pderiv (.inr 2) F) n t
  -- hct : eval t (path map ∂y2 F) = eval (Sum.elim (eval t n) (coord t)) ∂y2 F
  have hsc := sc_inr 2
  -- goal: eval (Sum.elim n1 yt) ∂y2 F = 0
  calc MvPolynomial.eval (Sum.elim n1 yt) (MvPolynomial.pderiv (.inr 2) F)
      = r ^ 2 * MvPolynomial.eval (Sum.elim nt yt) (MvPolynomial.pderiv (.inr 2) F) := hsc
    _ = r ^ 2 * Polynomial.eval t
          (MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
            (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
              (MvPolynomial.pderiv (.inr 2) F))) := by
          rw [← hct]
    _ = r ^ 2 * 0 := by rw [hcz]
    _ = 0 := by ring


/-- Left degree of a multiindex equals the sum of first-block exponents. -/
private theorem weight_leftDegree_eq_sum (s : BiprojectiveCoordinate 2 2 →₀ ℕ) :
    Finsupp.weight (leftDegreeWeight (m := 2) (n := 2)) s =
      ∑ i : Fin 3, s (.inl i) := by
  classical
  simp only [Finsupp.weight_apply, leftDegreeWeight]
  rw [Finsupp.sum_fintype _ _ (by intro; simp)]
  simp [Fintype.sum_sum_type, nsmul_eq_mul]

/-- Right degree of a multiindex equals the sum of second-block exponents. -/
private theorem weight_rightDegree_eq_sum (s : BiprojectiveCoordinate 2 2 →₀ ℕ) :
    Finsupp.weight (rightDegreeWeight (m := 2) (n := 2)) s =
      ∑ j : Fin 3, s (.inr j) := by
  classical
  simp only [Finsupp.weight_apply, rightDegreeWeight]
  rw [Finsupp.sum_fintype _ _ (by intro; simp)]
  simp [Fintype.sum_sum_type, nsmul_eq_mul]

/-- Top coefficient of a bihomogeneous form evaluated along the coordinate line equals its value
at the leading vector and the point at infinity `(0:1:0)`. -/
theorem coeff_bihomogeneous_coordinateLine_eval
    {d e : ℕ} (G : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hG : IsBihomogeneousOfBidegree d e G)
    (n : Fin 3 → Polynomial k) (m : ℕ)
    (hdeg : ∀ i, (n i).natDegree ≤ m) :
    (MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
        (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) G)).coeff (d * m + e) =
      MvPolynomial.eval (Sum.elim (fun i => (n i).coeff m) ![0, 1, 0]) G := by
  classical
  set nInf : Fin 3 → k := fun i => (n i).coeff m
  set yPath : Fin 3 → Polynomial k := coordinateLinePoint (Polynomial k) Polynomial.X
  have hy0 : yPath 0 = 1 := by simp [yPath, coordinateLinePoint]
  have hy1 : yPath 1 = Polynomial.X := by simp [yPath, coordinateLinePoint]
  have hy2 : yPath 2 = 0 := by simp [yPath, coordinateLinePoint]
  -- Expand G as a sum of its monomials.
  have hGsum : G = ∑ s ∈ G.support, MvPolynomial.monomial s (MvPolynomial.coeff s G) :=
    MvPolynomial.as_sum G
  rw [hGsum, map_sum, MvPolynomial.eval_sum, Polynomial.finsetSum_coeff, MvPolynomial.eval_sum]
  refine Finset.sum_congr rfl fun s hs => ?_
  have hne : MvPolynomial.coeff s G ≠ 0 := (MvPolynomial.mem_support_iff).mp hs
  have hwt : Finsupp.weight (bidegreeWeight (m := 2) (n := 2)) s = (d, e) := hG hne
  have hLdeg : ∑ i : Fin 3, s (.inl i) = d := by
    have := congrArg Prod.fst hwt
    simpa [fst_weight_bidegreeWeight, weight_leftDegree_eq_sum] using this
  have hRdeg : ∑ j : Fin 3, s (.inr j) = e := by
    have := congrArg Prod.snd hwt
    simpa [snd_weight_bidegreeWeight, weight_rightDegree_eq_sum] using this
  -- Convert Finsupp.prod along a path into an ordinary product over the two blocks.
  have hprod_path (p : Fin 3 → Polynomial k) (q : Fin 3 → Polynomial k) :
      s.prod (fun i e => Sum.elim p q i ^ e) =
        (∏ i : Fin 3, p i ^ s (.inl i)) * (∏ j : Fin 3, q j ^ s (.inr j)) := by
    rw [Finsupp.prod_fintype _ _ (by intro; simp)]
    simp [Fintype.prod_sum_type]
  have hprod_inf (p : Fin 3 → k) (q : Fin 3 → k) :
      s.prod (fun i e => Sum.elim p q i ^ e) =
        (∏ i : Fin 3, p i ^ s (.inl i)) * (∏ j : Fin 3, q j ^ s (.inr j)) := by
    rw [Finsupp.prod_fintype _ _ (by intro; simp)]
    simp [Fintype.prod_sum_type]
  -- Path / infinity evaluation of a single monomial.
  have hEval :
      MvPolynomial.eval (Sum.elim n yPath)
          (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
            (MvPolynomial.monomial s (MvPolynomial.coeff s G))) =
        Polynomial.C (MvPolynomial.coeff s G) *
          ((∏ i : Fin 3, n i ^ s (.inl i)) * (∏ j : Fin 3, yPath j ^ s (.inr j))) := by
    simp only [map_monomial, MvPolynomial.eval_monomial]
    rw [hprod_path n yPath]
  have hEvalInf :
      MvPolynomial.eval (Sum.elim nInf ![0, 1, 0])
          (MvPolynomial.monomial s (MvPolynomial.coeff s G)) =
        MvPolynomial.coeff s G *
          ((∏ i : Fin 3, nInf i ^ s (.inl i)) *
            (∏ j : Fin 3, (![0, 1, 0] : Fin 3 → k) j ^ s (.inr j))) := by
    simp only [MvPolynomial.eval_monomial]
    rw [hprod_inf nInf ![0, 1, 0]]
  -- Expand the three-factor products.
  have hYpath :
      (∏ j : Fin 3, yPath j ^ s (.inr j)) =
        yPath 0 ^ s (.inr 0) * yPath 1 ^ s (.inr 1) * yPath 2 ^ s (.inr 2) := by
    simp [Fin.prod_univ_three, mul_assoc]
  have hYinf :
      (∏ j : Fin 3, (![0, 1, 0] : Fin 3 → k) j ^ s (.inr j)) =
        (![0, 1, 0] : Fin 3 → k) 0 ^ s (.inr 0) *
          (![0, 1, 0] : Fin 3 → k) 1 ^ s (.inr 1) *
            (![0, 1, 0] : Fin 3 → k) 2 ^ s (.inr 2) := by
    simp [Fin.prod_univ_three, mul_assoc]
  have hNprod :
      (∏ i : Fin 3, n i ^ s (.inl i)) =
        n 0 ^ s (.inl 0) * n 1 ^ s (.inl 1) * n 2 ^ s (.inl 2) := by
    simp [Fin.prod_univ_three, mul_assoc]
  have hNinf :
      (∏ i : Fin 3, nInf i ^ s (.inl i)) =
        nInf 0 ^ s (.inl 0) * nInf 1 ^ s (.inl 1) * nInf 2 ^ s (.inl 2) := by
    simp [Fin.prod_univ_three, mul_assoc]
  have hsumL : s (.inl 0) + s (.inl 1) + s (.inl 2) = d := by
    simpa [Fin.sum_univ_three] using hLdeg
  have hsumR : s (.inr 0) + s (.inr 1) + s (.inr 2) = e := by
    simpa [Fin.sum_univ_three] using hRdeg
  -- Degree bound on the pure x-product.
  have hNdeg :
      (n 0 ^ s (.inl 0) * n 1 ^ s (.inl 1) * n 2 ^ s (.inl 2)).natDegree ≤ d * m := by
    have ha0 : (n 0 ^ s (.inl 0)).natDegree ≤ s (.inl 0) * m :=
      (Polynomial.natDegree_pow_le).trans (Nat.mul_le_mul_left _ (hdeg 0))
    have ha1 : (n 1 ^ s (.inl 1)).natDegree ≤ s (.inl 1) * m :=
      (Polynomial.natDegree_pow_le).trans (Nat.mul_le_mul_left _ (hdeg 1))
    have ha2 : (n 2 ^ s (.inl 2)).natDegree ≤ s (.inl 2) * m :=
      (Polynomial.natDegree_pow_le).trans (Nat.mul_le_mul_left _ (hdeg 2))
    have h01 :
        (n 0 ^ s (.inl 0) * n 1 ^ s (.inl 1)).natDegree ≤
          s (.inl 0) * m + s (.inl 1) * m :=
      (Polynomial.natDegree_mul_le).trans (add_le_add ha0 ha1)
    have h012 :
        (n 0 ^ s (.inl 0) * n 1 ^ s (.inl 1) * n 2 ^ s (.inl 2)).natDegree ≤
          s (.inl 0) * m + s (.inl 1) * m + s (.inl 2) * m :=
      (Polynomial.natDegree_mul_le).trans (add_le_add h01 ha2)
    have hidx :
        s (.inl 0) * m + s (.inl 1) * m + s (.inl 2) * m = d * m := by
      calc s (.inl 0) * m + s (.inl 1) * m + s (.inl 2) * m
          = m * (s (.inl 0) + s (.inl 1) + s (.inl 2)) := by ring
        _ = m * d := by rw [hsumL]
        _ = d * m := by ring
    exact hidx ▸ h012
  -- Case analysis on the y₂- and y₀-exponents (path is y = (1, X, 0)).
  by_cases hb2 : s (.inr 2) = 0
  · by_cases hb0 : s (.inr 0) = 0
    · -- Pure y₁-power: b₀ = b₂ = 0 ⇒ b₁ = e. Top coefficient matches infinity evaluation.
      have hb1 : s (.inr 1) = e := by
        have : s (.inr 0) + s (.inr 1) + s (.inr 2) = e := hsumR
        simp [hb0, hb2] at this
        exact this
      set pX : Polynomial k :=
        n 0 ^ s (.inl 0) * n 1 ^ s (.inl 1) * n 2 ^ s (.inl 2)
      have hpath :
          MvPolynomial.eval (Sum.elim n yPath)
              (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
                (MvPolynomial.monomial s (MvPolynomial.coeff s G))) =
            Polynomial.C (MvPolynomial.coeff s G) * (pX * Polynomial.X ^ e) := by
        rw [hEval, hNprod, hYpath, hy0, hy1, hy2, hb0, hb2, hb1]
        simp [pX, pow_zero, one_pow, mul_one, mul_assoc]
      have hinf :
          MvPolynomial.eval (Sum.elim nInf ![0, 1, 0])
              (MvPolynomial.monomial s (MvPolynomial.coeff s G)) =
            MvPolynomial.coeff s G *
              (nInf 0 ^ s (.inl 0) * nInf 1 ^ s (.inl 1) * nInf 2 ^ s (.inl 2)) := by
        rw [hEvalInf, hNinf, hYinf, hb0, hb2]
        simp [pow_zero, one_pow, mul_one]
      have htop : pX.coeff (d * m) =
            nInf 0 ^ s (.inl 0) * nInf 1 ^ s (.inl 1) * nInf 2 ^ s (.inl 2) := by
        have h :=
          coeff_prod3_pow_of_natDegree_le (n 0) (n 1) (n 2) m
            (s (.inl 0)) (s (.inl 1)) (s (.inl 2)) (hdeg 0) (hdeg 1) (hdeg 2)
        have hidx : m * (s (.inl 0) + s (.inl 1) + s (.inl 2)) = d * m := by
          rw [hsumL, mul_comm]
        simpa [pX, nInf, hidx] using h
      have hshift : (pX * Polynomial.X ^ e).coeff (d * m + e) = pX.coeff (d * m) := by
        simpa [add_comm] using
          (Polynomial.coeff_mul_X_pow (p := pX) (n := e) (d := d * m))
      rw [hpath, hinf, Polynomial.coeff_C_mul, hshift, htop]
    · -- b₀ > 0: infinity has factor 0^{b₀}; path degree is too low for t^{d m + e}.
      have hinf0 :
          MvPolynomial.eval (Sum.elim nInf ![0, 1, 0])
              (MvPolynomial.monomial s (MvPolynomial.coeff s G)) = 0 := by
        rw [hEvalInf, hYinf]
        have h00 : (![0, 1, 0] : Fin 3 → k) 0 = 0 := by simp
        rw [h00, zero_pow hb0]
        ring
      set pX : Polynomial k :=
        n 0 ^ s (.inl 0) * n 1 ^ s (.inl 1) * n 2 ^ s (.inl 2)
      have hpathExpr :
          MvPolynomial.eval (Sum.elim n yPath)
              (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
                (MvPolynomial.monomial s (MvPolynomial.coeff s G))) =
            Polynomial.C (MvPolynomial.coeff s G) * (pX * Polynomial.X ^ s (.inr 1)) := by
        rw [hEval, hNprod, hYpath, hy0, hy1, hy2, hb2]
        simp [pX, pow_zero, one_pow, mul_one, mul_assoc]
      have hXdeg : ((Polynomial.X : Polynomial k) ^ s (.inr 1)).natDegree = s (.inr 1) :=
        Polynomial.natDegree_X_pow (R := k) _
      have hdeg_lt :
          (Polynomial.C (MvPolynomial.coeff s G) *
              (pX * Polynomial.X ^ s (.inr 1))).natDegree < d * m + e := by
        have hC :
            (Polynomial.C (MvPolynomial.coeff s G) *
                (pX * Polynomial.X ^ s (.inr 1))).natDegree ≤
              (pX * Polynomial.X ^ s (.inr 1)).natDegree :=
          Polynomial.natDegree_C_mul_le _ _
        have hmul :
            (pX * Polynomial.X ^ s (.inr 1)).natDegree ≤ pX.natDegree + s (.inr 1) := by
          calc (pX * Polynomial.X ^ s (.inr 1)).natDegree
              ≤ pX.natDegree + (Polynomial.X ^ s (.inr 1)).natDegree :=
                Polynomial.natDegree_mul_le
            _ = pX.natDegree + s (.inr 1) := by rw [hXdeg]
        have hN : pX.natDegree ≤ d * m := by simpa [pX] using hNdeg
        have hle :
            (Polynomial.C (MvPolynomial.coeff s G) *
                (pX * Polynomial.X ^ s (.inr 1))).natDegree ≤ d * m + s (.inr 1) := by
          calc (Polynomial.C (MvPolynomial.coeff s G) *
                  (pX * Polynomial.X ^ s (.inr 1))).natDegree
              ≤ (pX * Polynomial.X ^ s (.inr 1)).natDegree := hC
            _ ≤ pX.natDegree + s (.inr 1) := hmul
            _ ≤ d * m + s (.inr 1) := Nat.add_le_add_right hN _
        have hstrict : d * m + s (.inr 1) < d * m + e := by
          have : s (.inr 1) < e := by
            have heq : e = s (.inr 0) + s (.inr 1) := by
              simpa [hb2, add_zero] using hsumR.symm
            omega
          omega
        exact lt_of_le_of_lt hle hstrict
      have hpath0 :
          (MvPolynomial.eval (Sum.elim n yPath)
              (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
                (MvPolynomial.monomial s (MvPolynomial.coeff s G)))).coeff (d * m + e) = 0 := by
        rw [hpathExpr]
        exact Polynomial.coeff_eq_zero_of_natDegree_lt hdeg_lt
      -- Goal: path.coeff = inf; both sides are 0.
      rw [hpath0, hinf0]
  · -- b₂ > 0: both evaluations carry a factor of 0^{b₂}.
    have hpath_eq0 :
        MvPolynomial.eval (Sum.elim n yPath)
            (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
              (MvPolynomial.monomial s (MvPolynomial.coeff s G))) = 0 := by
      rw [hEval, hYpath, hy2, zero_pow hb2]
      ring
    have hinf0 :
        MvPolynomial.eval (Sum.elim nInf ![0, 1, 0])
            (MvPolynomial.monomial s (MvPolynomial.coeff s G)) = 0 := by
      rw [hEvalInf, hYinf]
      have h20 : (![0, 1, 0] : Fin 3 → k) 2 = 0 := by simp
      rw [h20, zero_pow hb2]
      ring
    rw [hpath_eq0, Polynomial.coeff_zero, hinf0]

theorem false_of_kernel_path_constant_last_partial
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (n : Fin 3 → Polynomial k) (hn0 : n ≠ 0)
    (hnocom : ∀ t : k, ∃ i, (n i).eval t ≠ 0)
    (hFpoly :
      MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
        (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) F) = 0)
    (hxpderiv : ∀ i : Fin 3,
      MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
        (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
          (MvPolynomial.pderiv (.inl i) F)) = 0)
    (hy0 :
      MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
        (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
          (MvPolynomial.pderiv (.inr 0) F)) = 0)
    (hy1 :
      MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
        (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
          (MvPolynomial.pderiv (.inr 1) F)) = 0)
    (c0 : k) (hc0 : c0 ≠ 0)
    (hcC :
      MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
          (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
            (MvPolynomial.pderiv (.inr 2) F)) = Polynomial.C c0) :
    False := by
  classical
  set m : ℕ := Finset.univ.sup fun i => (n i).natDegree
  have hm (i : Fin 3) : (n i).natDegree ≤ m := by
    simpa [m] using Finset.le_sup (f := fun j => (n j).natDegree) (Finset.mem_univ i)
  set nInf : Fin 3 → k := fun i => (n i).coeff m
  have hnInf0 : nInf ≠ 0 := leading_vector_ne_zero n hn0 m rfl
  set yInf : Fin 3 → k := ![0, 1, 0]
  -- Use leading-coeff comparison (coeff_bihomogeneous_coordinateLine_eval) once proved.
  -- Temporary: keep sorry only on that lemma.
  have hFInf : MvPolynomial.eval (Sum.elim nInf yInf) F = 0 := by
    have h := coeff_bihomogeneous_coordinateLine_eval (d := 2) (e := 3) F hF n m hm
    have hzero :
        (MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
          (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) F)).coeff (2 * m + 3) = 0 := by
      simp [hFpoly]
    -- h : path.coeff (2m+3) = eval (nInf, yInf) F  (up to defeq of nInf/yInf)
    change _ = MvPolynomial.eval (Sum.elim nInf yInf) F at h
    rw [← h, hzero]
  have hxpInf (i : Fin 3) :
      MvPolynomial.eval (Sum.elim nInf yInf) (MvPolynomial.pderiv (.inl i) F) = 0 := by
    have hp : IsBihomogeneousOfBidegree 1 3 (MvPolynomial.pderiv (.inl i) F) :=
      hF.pderiv_inl (by decide) i
    have h := coeff_bihomogeneous_coordinateLine_eval (d := 1) (e := 3) _ hp n m hm
    have hzero :
        (MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
          (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
            (MvPolynomial.pderiv (.inl i) F))).coeff (m + 3) = 0 := by
      simp [hxpderiv i]
    change _ = MvPolynomial.eval (Sum.elim nInf yInf) _ at h
    rw [one_mul] at h
    rw [← h, hzero]
  have hypInf0 :
      MvPolynomial.eval (Sum.elim nInf yInf) (MvPolynomial.pderiv (.inr 0) F) = 0 := by
    have hp : IsBihomogeneousOfBidegree 2 2 (MvPolynomial.pderiv (.inr 0) F) :=
      hF.pderiv_inr (by decide) 0
    have h := coeff_bihomogeneous_coordinateLine_eval (d := 2) (e := 2) _ hp n m hm
    have hzero :
        (MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
          (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
            (MvPolynomial.pderiv (.inr 0) F))).coeff (2 * m + 2) = 0 := by
      simp [hy0]
    change _ = MvPolynomial.eval (Sum.elim nInf yInf) _ at h
    rw [← h, hzero]
  have hypInf1 :
      MvPolynomial.eval (Sum.elim nInf yInf) (MvPolynomial.pderiv (.inr 1) F) = 0 := by
    have hp : IsBihomogeneousOfBidegree 2 2 (MvPolynomial.pderiv (.inr 1) F) :=
      hF.pderiv_inr (by decide) 1
    have h := coeff_bihomogeneous_coordinateLine_eval (d := 2) (e := 2) _ hp n m hm
    have hzero :
        (MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
          (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
            (MvPolynomial.pderiv (.inr 1) F))).coeff (2 * m + 2) = 0 := by
      simp [hy1]
    change _ = MvPolynomial.eval (Sum.elim nInf yInf) _ at h
    rw [← h, hzero]
  have hypInf2 :
      MvPolynomial.eval (Sum.elim nInf yInf) (MvPolynomial.pderiv (.inr 2) F) = 0 := by
    have hp : IsBihomogeneousOfBidegree 2 2 (MvPolynomial.pderiv (.inr 2) F) :=
      hF.pderiv_inr (by decide) 2
    have h := coeff_bihomogeneous_coordinateLine_eval (d := 2) (e := 2) _ hp n m hm
    have hpos : 2 * m + 2 ≠ 0 := by omega
    have hzero :
        (MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
          (MvPolynomial.map (Polynomial.C : k →+* Polynomial k)
            (MvPolynomial.pderiv (.inr 2) F))).coeff (2 * m + 2) = 0 := by
      rw [hcC, Polynomial.coeff_C]; simp [hpos]
    change _ = MvPolynomial.eval (Sum.elim nInf yInf) _ at h
    rw [← h, hzero]
  -- Normalize nInf and contradict smoothness at yInf = (0:1:0)
  obtain ⟨i0, hi0⟩ : ∃ i0, nInf i0 ≠ 0 := by
    by_contra h; push Not at h; exact hnInf0 (funext h)
  set r : k := (nInf i0)⁻¹
  set n1 : Fin 3 → k := fun i => r * nInf i
  have hi1 : n1 i0 = 1 := by simp [n1, r, hi0]
  have hyj : yInf 1 = 1 := by simp [yInf]
  have hne : affineChartEquation 2 2 k i0 1 F ≠ 0 :=
    BiprojectiveSpace.affineChartEquation_ne_zero 2 2 k i0 1 F hF hF0
  have hF1 : MvPolynomial.eval (Sum.elim n1 yInf) F = 0 := by
    have h := eval_smul_first_bidegree hF r nInf yInf
    simpa [n1, hFInf] using h
  obtain ⟨z, hz⟩ :=
    BiprojectiveSpace.exists_pderiv_ne_zero_of_smooth 2 2 k F hF i0 1 hne n1 yInf hi1 hyj hF1
  have sc_inl (i : Fin 3) :
      MvPolynomial.eval (Sum.elim n1 yInf) (MvPolynomial.pderiv (.inl i) F) =
        r * MvPolynomial.eval (Sum.elim nInf yInf) (MvPolynomial.pderiv (.inl i) F) := by
    have hp : IsBihomogeneousOfBidegree 1 3 (MvPolynomial.pderiv (.inl i) F) :=
      hF.pderiv_inl (by decide) i
    simpa [n1, pow_one] using eval_smul_first_bidegree hp r nInf yInf
  have sc_inr (j : Fin 3) :
      MvPolynomial.eval (Sum.elim n1 yInf) (MvPolynomial.pderiv (.inr j) F) =
        r ^ 2 * MvPolynomial.eval (Sum.elim nInf yInf) (MvPolynomial.pderiv (.inr j) F) := by
    have hp : IsBihomogeneousOfBidegree 2 2 (MvPolynomial.pderiv (.inr j) F) :=
      hF.pderiv_inr (by decide) j
    simpa [n1] using eval_smul_first_bidegree hp r nInf yInf
  apply hz
  match z with
  | Sum.inl i => rw [sc_inl i, hxpInf i, mul_zero]
  | Sum.inr j =>
      rw [sc_inr j]
      have hvan : MvPolynomial.eval (Sum.elim nInf yInf) (MvPolynomial.pderiv (.inr j) F) = 0 := by
        match j with
        | ⟨0, _⟩ => exact hypInf0
        | ⟨1, _⟩ => exact hypInf1
        | ⟨2, _⟩ => exact hypInf2
      rw [hvan, mul_zero]

/-- **The coordinate-line conic discriminant commutes with a change of base field.** -/
theorem map_coordinateLineConicDiscriminant {L : Type u} [Field L] (φ : k →+* L)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    Polynomial.map φ (coordinateLineConicDiscriminant F) =
      coordinateLineConicDiscriminant (MvPolynomial.map φ F) := by
  rw [coordinateLineConicDiscriminant, coordinateLineConicDiscriminant,
    ← map_coordinateLineSpecializedConicPoly φ F,
    polarMatrix_map (Polynomial.mapRingHom φ), ← RingHom.mapMatrix_apply,
    ← RingHom.map_det]
  rfl

private theorem coordinateLineConicDiscriminant_ne_zero_of_smooth_of_isAlgClosed [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    coordinateLineConicDiscriminant F ≠ 0 := by
  classical
  intro hdisc
  obtain ⟨n, hn0, hker, hnocom, hQn⟩ := exists_kernel_section_of_disc_eq_zero F hF hdisc
  have hFpoly := eval_F_along_kernel_section F hF n hQn
  have hxpderiv := eval_pderiv_inl_along_kernel_section F hF n hker
  have hy1 := eval_pderiv_inr_one_along_kernel_section F hF n hFpoly hxpderiv
  have hy0 := eval_pderiv_inr_zero_along_kernel_section F hF n hFpoly hy1
  set c : Polynomial k :=
    MvPolynomial.eval (Sum.elim n (coordinateLinePoint (Polynomial k) Polynomial.X))
      (MvPolynomial.map (Polynomial.C : k →+* Polynomial k) (MvPolynomial.pderiv (.inr 2) F))
  have hc_ne (t : k) : c.eval t ≠ 0 :=
    eval_last_partial_ne_zero_along_kernel_section F hF hF0 n hnocom hFpoly hxpderiv hy0 hy1 t
  obtain ⟨c0, hc0, hcC⟩ := eq_C_of_forall_eval_ne_zero c hc_ne
  exact false_of_kernel_path_constant_last_partial F hF hF0 n hn0 hnocom hFpoly hxpderiv hy0 hy1
    c0 hc0 (by simpa [c] using hcC)

/-- **The generic conic along the coordinate line is nondegenerate**, over an arbitrary base
field.  The closed-field argument is run over `AlgebraicClosure k` — where
`BiprojectiveSpace.smooth_biprojectiveZeroLocusToSpec_map_of_smooth_bidegree23` supplies the
smoothness hypothesis — and the conclusion, a nonvanishing of a polynomial over `k`, reflects
along the (injective) coefficient extension. -/
theorem coordinateLineConicDiscriminant_ne_zero_of_smooth
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    coordinateLineConicDiscriminant F ≠ 0 := by
  intro hdisc
  haveI : NeZero (2 : AlgebraicClosure k) :=
    neZero_two_of_injective_algebraMap (algebraMap k (AlgebraicClosure k)).injective
  haveI : NeZero (3 : AlgebraicClosure k) :=
    neZero_three_of_injective_algebraMap (algebraMap k (AlgebraicClosure k)).injective
  haveI : Smooth (biprojectiveZeroLocusToSpec 2 2 (AlgebraicClosure k)
      (MvPolynomial.map (algebraMap k (AlgebraicClosure k)) F)) :=
    BiprojectiveSpace.smooth_biprojectiveZeroLocusToSpec_map_of_smooth_bidegree23 k F hF hF0
  refine coordinateLineConicDiscriminant_ne_zero_of_smooth_of_isAlgClosed
    (MvPolynomial.map (algebraMap k (AlgebraicClosure k)) F)
    (hF.map_coefficients _)
    (fun h => hF0 (MvPolynomial.map_injective _ (algebraMap k _).injective
      (by rw [h, map_zero]))) ?_
  rw [← map_coordinateLineConicDiscriminant, hdisc, Polynomial.map_zero]

end CoordinateLine

end

end BConicBundleMultisections
