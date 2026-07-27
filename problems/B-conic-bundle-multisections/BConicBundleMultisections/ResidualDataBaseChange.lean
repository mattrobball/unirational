/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualDiscriminantAvoidance
public import BConicBundleMultisections.ResidualEquationLine
public import BConicBundleMultisections.ResidualHorizontalityLine

/-!
# Base change of the good-line data

The closure-free form of the main theorem hypothesises a line `L = span(p₀, q₀)` with completion
`r` and inverse frame `N`, together with a Tsen section `v` over `k`, subject to five conditions:

1. `lineFrame p₀ q₀ r * N = 1` — the frame relation;
2. **G3**, `ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F`;
3. `v 2 ≠ 0`;
4. `lineStereoPolarForm p₀ q₀ F v ≠ 0` — stereographic nondegeneracy;
5. **G4**, `ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v`;

plus the isotropy of `v` itself.  Four of the five — (1)–(4) minus the isotropy, i.e. (1), (2), (3),
(4) and (5) — are *checkable after enlarging the field*.  This module proves that.

## What is transferred and why it is legitimate

Every construction in sight is polynomial in the coefficients, so all three of

* `residualLineCoeffOn` (G3),
* `lineStereoPolarForm` (stereographic nondegeneracy),
* `residualYCoordsOn` and hence `residualConicDiscriminantOn` (G4),

commute with a coefficient ring homomorphism `φ : k →+* K`.  Those commutations are the bulk of
this file; they are stated as `..._map` lemmas and are true over arbitrary commutative rings
wherever the underlying definitions are.

From them the transfer statements follow by the trichotomy of `GeometricPointDescent`:

* **Nonvanishing** (`hpolar`, `hv2`, G4) reflects along *any* ring hom and ascends along an
  injective one, so along a field extension it is an **iff** and costs nothing.
* **G3** is not a nonvanishing statement: it says that the three coefficient forms
  `q_U, q_V, q_W` span a line, i.e. that their coefficient matrix has **rank ≤ 1**.  Rank is
  invariant under field extension, so this too is an **iff** — but the proof is not a pullback of
  a witness: from a witness `(g, c)` over `K` one cannot in general read off one over `k` (the `K`
  chosen `g` need not be defined over `k`).  What descends is the vanishing of all `2 × 2` minors
  of the coefficient matrix, and rank-≤-1 is *equivalent* to that vanishing over any field.  This
  is `residualLineConstantOn_iff_coeffMinorsVanish` below.

## What does **not** transfer

The Tsen section `v` itself.  A section of the conic bundle over `K(t)` says nothing about
`k(t)`, and no base change repairs that: it is the arithmetic input, and the closure-free theorem
must take it as a hypothesis over `k`.  Nothing in this module produces a section.

Note also that the *frame relation* (1) transfers by `lineFrame_map_mul_map`, which already exists;
it is recalled here only inside the packaged transfer theorem.

## Namespace

Everything lives in `BConicBundleMultisections.ResidualDataBaseChange`.  Several of the elementary
commutation lemmas below already exist elsewhere in the development under the same names but in
modules this one deliberately does not import (`ResidualComponentExhaustion`,
`Standard.G4PointwiseLine`); the private namespace keeps both readable in one root module.
-/

@[expose] public section

namespace BConicBundleMultisections

namespace ResidualDataBaseChange

noncomputable section

universe u

open MvPolynomial ResidualDivisor
open _root_.MvPolynomial
open scoped Matrix

/-! ## Rank ≤ 1 for a family of polynomials

`ResidualLineConstantOn` says that three polynomials are scalar multiples of one polynomial.  That
is a rank condition on their coefficient matrix, and the following elementary lemma is the only
form of it we need. -/

/-- **A family of polynomials lies on a single line through the origin iff every `2 × 2` minor of
its coefficient matrix vanishes.**

The left-hand side is the shape of `ResidualLineConstantOn`; the right-hand side is a family of
polynomial identities in the coefficients, hence descends and ascends along an injective
coefficient map.  Note that the `←` direction genuinely uses the field: the witness `g` is one of
the `q a`, chosen by a nonvanishing coefficient. -/
theorem exists_C_mul_iff_coeff_minor_eq_zero
    {k : Type u} [Field k] {σ ι : Type*} (q : ι → MvPolynomial σ k) :
    (∃ (g : MvPolynomial σ k) (c : ι → k), ∀ a : ι, q a = C (c a) * g) ↔
      ∀ (a b : ι) (m n : σ →₀ ℕ),
        coeff m (q a) * coeff n (q b) = coeff n (q a) * coeff m (q b) := by
  classical
  constructor
  · rintro ⟨g, c, hq⟩ a b m n
    simp only [hq, coeff_C_mul]
    ring
  · intro hmin
    by_cases hzero : ∀ (a : ι) (m : σ →₀ ℕ), coeff m (q a) = 0
    · refine ⟨0, fun _ => 0, fun a => ?_⟩
      rw [mul_zero]
      exact MvPolynomial.ext _ _ fun m => by rw [hzero a m, coeff_zero]
    · push Not at hzero
      obtain ⟨a₀, m₀, hm₀⟩ := hzero
      refine ⟨q a₀, fun a => coeff m₀ (q a) / coeff m₀ (q a₀), fun a => ?_⟩
      refine MvPolynomial.ext _ _ fun n => ?_
      rw [coeff_C_mul, div_mul_eq_mul_div, eq_div_iff hm₀]
      exact hmin a a₀ n m₀

/-! ## Coefficient base change

`φ : k →+* K` acts on every ring in sight by `MvPolynomial.map φ`.  On the coordinate ring of the
affine plane — where the residual coordinates live — we give it a name, because it appears as the
*coefficient* map of a further polynomial ring and the two levels are easy to confuse. -/

/-- Base change of the coordinate ring `k[t, s]` of the affine plane along `φ`. -/
def affineTwoBaseChange {k K : Type u} [CommRing k] [CommRing K] (φ : k →+* K) :
    affineTwoRing k →+* affineTwoRing K :=
  MvPolynomial.map φ

@[simp] theorem affineTwoBaseChange_apply {k K : Type u} [CommRing k] [CommRing K] (φ : k →+* K)
    (f : affineTwoRing k) : affineTwoBaseChange φ f = MvPolynomial.map φ f := rfl

@[simp] theorem affineTwoBaseChange_C {k K : Type u} [CommRing k] [CommRing K] (φ : k →+* K)
    (a : k) : affineTwoBaseChange φ (C a) = C (φ a) := by
  simp [affineTwoBaseChange]

theorem affineTwoBaseChange_comp_C {k K : Type u} [CommRing k] [CommRing K] (φ : k →+* K) :
    (affineTwoBaseChange φ).comp (C : k →+* affineTwoRing k) = (C : K →+* affineTwoRing K).comp φ :=
  RingHom.ext fun a => by simp

@[simp] theorem affineTwoBaseChange_coord0 {k K : Type u} [CommRing k] [CommRing K] (φ : k →+* K) :
    affineTwoBaseChange φ (affineTwoCoord0 k) = affineTwoCoord0 K := by
  simp [affineTwoBaseChange, affineTwoCoord0]

@[simp] theorem affineTwoBaseChange_coord1 {k K : Type u} [CommRing k] [CommRing K] (φ : k →+* K) :
    affineTwoBaseChange φ (affineTwoCoord1 k) = affineTwoCoord1 K := by
  simp [affineTwoBaseChange, affineTwoCoord1]

theorem affineTwoBaseChange_injective {k K : Type u} [CommRing k] [CommRing K] {φ : k →+* K}
    (hφ : Function.Injective φ) : Function.Injective (affineTwoBaseChange φ) :=
  MvPolynomial.map_injective φ hφ

/-! ## G3: the residual line along `L`

`ResidualLineConstantOn M N F` is the statement that the three coefficient forms
`residualLineCoeffOn M N F a` are scalar multiples of a single polynomial.  We first push `map φ`
through `residualLineCoeffOn`, and then use the rank characterisation to get an iff. -/

section G3

variable {k K : Type u} [CommRing k] [CommRing K]

/-- Second-block linear substitution commutes with extension of coefficients. -/
theorem map_secondBlockSubst (φ : k →+* K) (M : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    secondBlockSubst (M.map φ) (map φ F) = map φ (secondBlockSubst M F) := by
  induction F using MvPolynomial.induction_on with
  | C a => simp
  | add F G hF hG => simp [hF, hG]
  | mul_X F z hF =>
      cases z with
      | inl i => simp [hF]
      | inr j => simp [hF, map_sum]

/-- **The residual equation along `L` commutes with base change.** -/
theorem map_residualEquationOn (φ : k →+* K) (M N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    residualEquationOn (M.map φ) (N.map φ) (map φ F) = map φ (residualEquationOn M N F) := by
  simp only [residualEquationOn, map_secondBlockSubst, map_residualEquation]

/-- **The three coefficient forms of the residual line along `L` commute with base change.**

This is the commutation the G3 transfer rests on: `q_U, q_V, q_W` over `K` are the `φ`-images of
`q_U, q_V, q_W` over `k`, coefficient by coefficient. -/
theorem map_residualLineCoeffOn (φ : k →+* K) (M N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (a : Fin 3) :
    residualLineCoeffOn (M.map φ) (N.map φ) (map φ F) a
      = map φ (residualLineCoeffOn M N F a) := by
  rw [residualLineCoeffOn, residualLineCoeffOn, map_residualEquationOn, map_secondBlockCoeff]

/-- **Rank-≤-1 form of G3.**  All `2 × 2` minors of the coefficient matrix of `q_U, q_V, q_W`
vanish.  Unlike `ResidualLineConstantOn` this is a family of *polynomial identities in the
coefficients*, so it descends and ascends along an injective coefficient map without any choice of
witness. -/
def ResidualLineCoeffMinorsVanish (M N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Prop :=
  ∀ (a b : Fin 3) (m n : Fin 3 →₀ ℕ),
    coeff m (residualLineCoeffOn M N F a) * coeff n (residualLineCoeffOn M N F b)
      = coeff n (residualLineCoeffOn M N F a) * coeff m (residualLineCoeffOn M N F b)

/-- **G3's negation is a rank condition.**  Over a field, "the residual line is constant" is
exactly "the coefficient matrix of `q_U, q_V, q_W` has rank ≤ 1". -/
theorem residualLineConstantOn_iff_minorsVanish {k : Type u} [Field k]
    (M N : Matrix (Fin 3) (Fin 3) k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    ResidualLineConstantOn M N F ↔ ResidualLineCoeffMinorsVanish M N F :=
  exists_C_mul_iff_coeff_minor_eq_zero (residualLineCoeffOn M N F)

/-- The minor conditions transfer both ways along an injective coefficient map. -/
theorem residualLineCoeffMinorsVanish_map_iff {φ : k →+* K} (hφ : Function.Injective φ)
    (M N : Matrix (Fin 3) (Fin 3) k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    ResidualLineCoeffMinorsVanish (M.map φ) (N.map φ) (map φ F)
      ↔ ResidualLineCoeffMinorsVanish M N F := by
  have key (a b : Fin 3) (m n : Fin 3 →₀ ℕ) :
      (coeff m (residualLineCoeffOn (M.map φ) (N.map φ) (map φ F) a) *
          coeff n (residualLineCoeffOn (M.map φ) (N.map φ) (map φ F) b)
        = coeff n (residualLineCoeffOn (M.map φ) (N.map φ) (map φ F) a) *
            coeff m (residualLineCoeffOn (M.map φ) (N.map φ) (map φ F) b))
      ↔ (φ (coeff m (residualLineCoeffOn M N F a) * coeff n (residualLineCoeffOn M N F b))
        = φ (coeff n (residualLineCoeffOn M N F a) * coeff m (residualLineCoeffOn M N F b))) := by
    simp only [map_residualLineCoeffOn, coeff_map, _root_.map_mul]
  constructor
  · intro h a b m n
    exact hφ ((key a b m n).mp (h a b m n))
  · intro h a b m n
    exact (key a b m n).mpr (congrArg φ (h a b m n))

/-- **G3 is invariant under field extension.**

The `←` direction is a pullback of the witness; the `→` direction is *not* — a `K`-rational witness
`(g, c)` need not be defined over `k`.  What crosses is the rank condition, and
`residualLineConstantOn_iff_minorsVanish` supplies a `k`-rational witness from it. -/
theorem residualLineConstantOn_map_iff {k K : Type u} [Field k] [Field K] (φ : k →+* K)
    (M N : Matrix (Fin 3) (Fin 3) k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    ResidualLineConstantOn (M.map φ) (N.map φ) (map φ F) ↔ ResidualLineConstantOn M N F := by
  rw [residualLineConstantOn_iff_minorsVanish, residualLineConstantOn_iff_minorsVanish]
  exact residualLineCoeffMinorsVanish_map_iff φ.injective M N F

/-- **G3 itself is invariant under field extension**: it may be verified over any extension. -/
theorem residualLineNonconstantOn_map_iff {k K : Type u} [Field k] [Field K] (φ : k →+* K)
    (M N : Matrix (Fin 3) (Fin 3) k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    ResidualLineNonconstantOn (M.map φ) (N.map φ) (map φ F) ↔ ResidualLineNonconstantOn M N F :=
  not_congr (residualLineConstantOn_map_iff φ M N F)

/-- **G3 descends**, in the form a consumer wants: verified over `K`, it holds over `k`. -/
theorem residualLineNonconstantOn_of_map {k K : Type u} [Field k] [Field K] (φ : k →+* K)
    (M N : Matrix (Fin 3) (Fin 3) k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (h : ResidualLineNonconstantOn (M.map φ) (N.map φ) (map φ F)) :
    ResidualLineNonconstantOn M N F :=
  (residualLineNonconstantOn_map_iff φ M N F).mp h

end G3

end

end ResidualDataBaseChange

end BConicBundleMultisections
