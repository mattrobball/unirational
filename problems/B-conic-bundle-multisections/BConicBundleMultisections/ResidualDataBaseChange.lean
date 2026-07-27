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

plus the isotropy of `v` itself.  Four of the five — (2), (3), (4), (5) — are *checkable after
enlarging the field*: verify them over any extension `K ⊇ k` and they hold over `k`.  Condition (1)
moves the other way, and for free, being an identity.  This module proves both.

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
* **G3** is not a nonvanishing statement.  Its negation, `ResidualLineConstantOn`, says that the
  three coefficient forms `q_U, q_V, q_W` all lie on one line of the coefficient space — that
  their coefficient matrix has **rank ≤ 1**.  Rank is invariant under field extension, so G3 too
  is an **iff** — but the proof is not a pullback of a witness: from a witness `(g, c)` over `K`
  one cannot in general read off one over `k`, since the chosen `g` need not be defined over `k`.
  What descends is the vanishing of all `2 × 2` minors of the coefficient matrix, and rank-≤-1 is
  *equivalent* to that vanishing over any field.  This is
  `residualLineConstantOn_iff_minorsVanish` below.

The packaged form is `goodLineData_of_map`; the frame relation is `lineFrame_map_mul_map_of`.

## What does **not** transfer

The Tsen section `v` itself.  A section of the conic bundle over `K(t)` says nothing about
`k(t)`, and no base change repairs that: it is the arithmetic input, and the closure-free theorem
must take it as a hypothesis over `k`.  Nothing in this module produces a section.

## Namespace

Everything lives in `BConicBundleMultisections.ResidualDataBaseChange`.  A few of the elementary
commutation lemmas below already exist elsewhere in the development under the same names but in
modules this one deliberately does not import (`ResidualComponentExhaustion`,
`Standard.G4PointwiseLine`); the sub-namespace lets both be present in one root module.
-/

@[expose] public section

namespace BConicBundleMultisections

namespace ResidualDataBaseChange

noncomputable section

universe u

open MvPolynomial ResidualDivisor
open _root_.MvPolynomial
-- `DeterminantHomogeneous` puts `Matrix.det_isHomogeneous` inside `BConicBundleMultisections`, so
-- plain `open scoped Matrix` resolves to that empty namespace and loses the `*ᵥ` notation.
open scoped _root_.Matrix

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
theorem exists_C_mul_iff_coeff_minors_vanish
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

theorem affineTwoBaseChange_apply {k K : Type u} [CommRing k] [CommRing K] (φ : k →+* K)
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

/-- **Failure of G3 is a rank condition.**  Over a field, "the residual line along `L` is constant"
is exactly "the coefficient matrix of `q_U, q_V, q_W` has rank ≤ 1". -/
theorem residualLineConstantOn_iff_minorsVanish {k : Type u} [Field k]
    (M N : Matrix (Fin 3) (Fin 3) k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    ResidualLineConstantOn M N F ↔ ResidualLineCoeffMinorsVanish M N F :=
  exists_C_mul_iff_coeff_minors_vanish (residualLineCoeffOn M N F)

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

/-! ## Elementary commutations over the affine plane

The residual coordinates live in `affineTwoRing k = k[t, s]`, and the objects built from them are
polynomials whose *coefficients* are elements of that ring.  So two levels of `map` are in play:
`affineTwoBaseChange φ` on the coefficients, and `MvPolynomial.map (affineTwoBaseChange φ)` on the
polynomials.  The lemmas here are the elementary commutations, stated once so that the two levels
never have to be untangled again. -/

section Elementary

variable {k K : Type u} [CommRing k] [CommRing K] (φ : k →+* K)

/-- A change of coefficient ring commutes with first-block specialization. -/
theorem map_specializeFirstCoords {R S : Type*} [CommRing R] [CommRing S] (ψ : R →+* S)
    (x : Fin 3 → R) (H : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    map ψ (specializeFirstCoordinates (n := 2) x H)
      = specializeFirstCoordinates (n := 2) (fun i => ψ (x i)) (map ψ H) := by
  induction H using MvPolynomial.induction_on with
  | C c => simp
  | add f g hf hg => simp [hf, hg]
  | mul_X f z hf =>
      cases z with
      | inl j => simp [hf]
      | inr j => simp [hf]

/-- Restriction to a line commutes with coefficient maps, in `fun`-form. -/
theorem map_binaryLineRestrictionFun {R S : Type u} [CommRing R] [CommRing S] (ψ : R →+* S)
    {σ : Type*} (p q : σ → R) (G : MvPolynomial σ R) :
    map ψ (binaryLineRestriction p q G)
      = binaryLineRestriction (fun i => ψ (p i)) (fun i => ψ (q i)) (map ψ G) :=
  map_binaryLineRestriction ψ p q G

/-- The ambient residual representative commutes with coefficient maps. -/
theorem map_residualAmbientRepGen {R S : Type u} [CommRing R] [CommRing S] (ψ : R →+* S)
    {σ : Type*} (p q : σ → R) (g : MvPolynomial (Fin 2) R) :
    (fun i => ψ (residualAmbientRep p q g i))
      = residualAmbientRep (fun j => ψ (p j)) (fun j => ψ (q j)) (map ψ g) := by
  funext i
  simp [residualAmbientRep, residualBinaryRep, coeff_map]

/-- Linear substitution commutes with a change of coefficient ring. -/
theorem map_aevalLinearSubst {R S : Type u} [CommRing R] [CommRing S] (ψ : R →+* S) (n : ℕ)
    (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R) (G : MvPolynomial (Fin (n + 1)) R) :
    map ψ ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G)
      = (aeval (linearSubst n (M.map ψ)) : MvPolynomial (Fin (n + 1)) S →ₐ[S] _) (map ψ G) := by
  induction G using MvPolynomial.induction_on with
  | C a => simp
  | add P Q hP hQ => simpa only [map_add] using congrArg₂ (fun A B => A + B) hP hQ
  | mul_X P i hP =>
      simp only [map_mul, aeval_X, hP]
      congr 1
      simp [linearSubst, map_sum, Matrix.map_apply]

/-- The frame-defined tangent direction commutes with a change of coefficient ring. -/
theorem map_frameTangentDirGen {R S : Type u} [CommRing R] [CommRing S] (ψ : R →+* S)
    (M N : Matrix (Fin 3) (Fin 3) R) (G : MvPolynomial (Fin 3) R) (p : Fin 3 → R) :
    (fun i => ψ (frameTangentDir M N G p i))
      = frameTangentDir (M.map ψ) (N.map ψ) (map ψ G) (fun i => ψ (p i)) := by
  have hG : map ψ ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G)
      = (aeval (linearSubst 2 (M.map ψ)) : MvPolynomial (Fin 3) S →ₐ[S] _) (map ψ G) :=
    map_aevalLinearSubst ψ 2 M G
  have hp : (fun i => ψ ((N *ᵥ p) i)) = (N.map ψ) *ᵥ (fun i => ψ (p i)) := by
    funext i
    exact RingHom.map_mulVec ψ N p i
  have hdir := map_complementaryTangentDir ψ
    ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G) (N *ᵥ p)
  funext i
  simp only [frameTangentDir]
  rw [RingHom.map_mulVec]
  have : (fun j => ψ (complementaryTangentDir
      ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G) (N *ᵥ p) j))
      = complementaryTangentDir
        ((aeval (linearSubst 2 (M.map ψ)) : MvPolynomial (Fin 3) S →ₐ[S] _) (map ψ G))
        ((N.map ψ) *ᵥ (fun i => ψ (p i))) := by
    rw [← hG, ← hp]
    exact hdir
  exact congrFun (congrArg (fun z => (M.map ψ) *ᵥ z) this) i

end Elementary

/-! ## Base change of the affine-plane data

`affineTwoBaseChange φ` transports each ingredient of the residual construction: the generic point
of `L`, the frame of `L`, the conic along `L`, the lifted Tsen section, and the stereographic
direction. -/

section AffinePlane

variable {k K : Type u} [CommRing k] [CommRing K] (φ : k →+* K)

/-- The lift of a univariate polynomial to `k[t, s]` commutes with base change. -/
theorem affineTwoBaseChange_liftPolyT (p : Polynomial k) :
    affineTwoBaseChange φ (liftPolyT p) = liftPolyT (p.map φ) := by
  rw [liftPolyT, liftPolyT, Polynomial.hom_eval₂, affineTwoBaseChange_coord0,
    Polynomial.eval₂_map]
  congr 1
  exact affineTwoBaseChange_comp_C φ

/-- The lifted Tsen section commutes with base change. -/
theorem affineTwoBaseChange_liftTsenSection (v : Fin 3 → Polynomial k) :
    (fun i => affineTwoBaseChange φ (liftTsenSection v i))
      = liftTsenSection (fun i => (v i).map φ) := by
  funext i
  exact affineTwoBaseChange_liftPolyT φ (v i)

/-- The stereographic direction `(1, s, 0)` is defined over the prime field. -/
theorem affineTwoBaseChange_stereoDir :
    (fun i => affineTwoBaseChange φ (affineTwoStereoDir (k := k) i))
      = affineTwoStereoDir (k := K) := by
  funext i
  fin_cases i <;> simp [affineTwoStereoDir]

/-- The generic point of `L` over `k[t, s]` commutes with base change. -/
theorem affineTwoBaseChange_linePoint (p₀ q₀ : Fin 3 → k) :
    (fun i => affineTwoBaseChange φ (affineTwoLinePoint p₀ q₀ i))
      = affineTwoLinePoint (fun j => φ (p₀ j)) (fun j => φ (q₀ j)) := by
  funext i
  rw [affineTwoLinePoint, affineTwoLinePoint, map_linePointOf]
  simp

/-- The frame of `L` over `k[t, s]` commutes with base change. -/
theorem affineTwoBaseChange_lineFrame (p₀ q₀ r : Fin 3 → k) :
    (affineTwoLineFrame p₀ q₀ r).map (affineTwoBaseChange φ)
      = affineTwoLineFrame (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (fun i => φ (r i)) := by
  rw [affineTwoLineFrame, lineFrame_map, affineTwoLineFrame]
  simp

/-- The inverse frame, pushed into `k[t, s]`, commutes with base change. -/
theorem affineTwoBaseChange_mapC_matrix (N : Matrix (Fin 3) (Fin 3) k) :
    (N.map (C : k →+* affineTwoRing k)).map (affineTwoBaseChange φ)
      = (N.map φ).map (C : K →+* affineTwoRing K) := by
  ext i j
  simp

/-- The coefficient pullback of `F` to `k[t, s]` commutes with base change. -/
theorem map_affineTwoPullback (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    map (affineTwoBaseChange φ) (affineTwoPullback F) = affineTwoPullback (map φ F) := by
  rw [affineTwoPullback, affineTwoPullback, MvPolynomial.map_map, MvPolynomial.map_map,
    affineTwoBaseChange_comp_C]

/-- **The conic along `L` commutes with base change.** -/
theorem map_lineSpecializedConicPullback (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    map (affineTwoBaseChange φ) (lineSpecializedConicPullback p₀ q₀ F)
      = lineSpecializedConicPullback (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (map φ F) := by
  rw [lineSpecializedConicPullback, lineSpecializedConicPullback,
    map_specializeSecondCoordinates, map_affineTwoPullback,
    affineTwoBaseChange_linePoint]

/-- The cubic fibre over a point of `k[t, s]` commutes with base change. -/
theorem map_cubicFiberPullback (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (x : Fin 3 → affineTwoRing k) :
    map (affineTwoBaseChange φ) (cubicFiberPullback F x)
      = cubicFiberPullback (map φ F) (fun i => affineTwoBaseChange φ (x i)) := by
  rw [cubicFiberPullback, cubicFiberPullback, map_specializeFirstCoords, map_affineTwoPullback]

end AffinePlane

/-! ## Transfer of the stereographic nondegeneracy hypothesis `hpolar` -/

section Polar

variable {k K : Type u} [Field k] [Field K] (φ : k →+* K)

/-- **The stereographic polar form along `L` commutes with base change.** -/
theorem lineStereoPolarForm_map (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k) :
    lineStereoPolarForm (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (map φ F)
        (fun i => (v i).map φ)
      = affineTwoBaseChange φ (lineStereoPolarForm p₀ q₀ F v) := by
  rw [lineStereoPolarForm, lineStereoPolarForm,
    ← map_lineSpecializedConicPullback φ p₀ q₀ F,
    ← affineTwoBaseChange_liftTsenSection φ v,
    ← affineTwoBaseChange_stereoDir φ (k := k)]
  exact polarEval_map (affineTwoBaseChange φ) _ _ _

/-- **Stereographic nondegeneracy is invariant under field extension.**

Nonvanishing reflects along any ring hom and ascends along an injective one; a field extension is
injective, so this costs nothing. -/
theorem lineStereoPolarForm_ne_zero_map_iff (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k) :
    lineStereoPolarForm (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (map φ F)
        (fun i => (v i).map φ) ≠ 0
      ↔ lineStereoPolarForm p₀ q₀ F v ≠ 0 := by
  rw [lineStereoPolarForm_map]
  exact not_congr (map_eq_zero_iff _ (affineTwoBaseChange_injective φ.injective))

/-- **`v 2 ≠ 0` is invariant under field extension.**  The same trivial pattern, one level down. -/
theorem tsenSection_two_ne_zero_map_iff (v : Fin 3 → Polynomial k) :
    (fun i => (v i).map φ) 2 ≠ 0 ↔ v 2 ≠ 0 :=
  not_congr (Polynomial.map_eq_zero_iff φ.injective)

end Polar

/-! ## Transfer of G4

`residualConicDiscriminantOn` is `aeval (residualYCoordsOn …) (sndConicDiscriminant F)`, so two
commutations are needed: the residual `Y`-coordinates, and the degree-nine discriminant. -/

section G4

variable {k K : Type u} [Field k] [Field K] (φ : k →+* K)

/-- **The stereographic first-block coordinates along `L` commute with base change.** -/
theorem map_stereoFirstCoordsOn (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k) :
    (fun i => affineTwoBaseChange φ (stereoFirstCoordsOn p₀ q₀ F v i))
      = stereoFirstCoordsOn (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (map φ F)
          (fun i => (v i).map φ) := by
  rw [stereoFirstCoordsOn, stereoFirstCoordsOn, map_stereoAlg,
    map_lineSpecializedConicPullback, affineTwoBaseChange_liftTsenSection,
    affineTwoBaseChange_stereoDir]

/-- **The tangent-residual `Y`-coordinates along `L` commute with base change.**

Every ingredient — the stereo point, the cubic fibre, the frame of `L`, the frame tangent
direction, the restriction to the tangent line, and the residual representative — transports, and
this is their composite. -/
theorem residualYCoordsOn_map (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k) :
    (fun a => affineTwoBaseChange φ (residualYCoordsOn p₀ q₀ r N F v a))
      = residualYCoordsOn (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (fun i => φ (r i))
          (N.map φ) (map φ F) (fun i => (v i).map φ) := by
  set Φ := affineTwoBaseChange φ
  -- the cubic fibre of the stereo point
  have hG : map Φ (cubicFiberPullback F (stereoFirstCoordsOn p₀ q₀ F v))
      = cubicFiberPullback (map φ F)
        (stereoFirstCoordsOn (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (map φ F)
          (fun i => (v i).map φ)) := by
    rw [map_cubicFiberPullback, map_stereoFirstCoordsOn]
  -- the generic point of `L`
  have hp : (fun i => Φ (affineTwoLinePoint p₀ q₀ i))
      = affineTwoLinePoint (fun j => φ (p₀ j)) (fun j => φ (q₀ j)) :=
    affineTwoBaseChange_linePoint φ p₀ q₀
  -- the frame of `L` and its inverse
  have hM : (affineTwoLineFrame p₀ q₀ r).map Φ
      = affineTwoLineFrame (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (fun i => φ (r i)) :=
    affineTwoBaseChange_lineFrame φ p₀ q₀ r
  have hN : (N.map (C : k →+* affineTwoRing k)).map Φ
      = (N.map φ).map (C : K →+* affineTwoRing K) :=
    affineTwoBaseChange_mapC_matrix φ N
  -- the tangent direction in the frame
  have hq : (fun i => Φ (frameTangentDir (affineTwoLineFrame p₀ q₀ r) (N.map C)
        (cubicFiberPullback F (stereoFirstCoordsOn p₀ q₀ F v)) (affineTwoLinePoint p₀ q₀) i))
      = frameTangentDir
          (affineTwoLineFrame (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (fun i => φ (r i)))
          ((N.map φ).map C)
          (cubicFiberPullback (map φ F)
            (stereoFirstCoordsOn (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (map φ F)
              (fun i => (v i).map φ)))
          (affineTwoLinePoint (fun j => φ (p₀ j)) (fun j => φ (q₀ j))) := by
    rw [← hG, ← hp, ← hM, ← hN]
    exact map_frameTangentDirGen Φ _ _ _ _
  unfold residualYCoordsOn
  rw [map_residualAmbientRepGen, map_binaryLineRestrictionFun, hp, hq, hG]

/-- **The universal second-projection conic commutes with base change.** -/
theorem map_universalSndConic (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    map (MvPolynomial.map φ : MvPolynomial (Fin 3) k →+* MvPolynomial (Fin 3) K)
        (universalSndConic F)
      = universalSndConic (map φ F) := by
  rw [universalSndConic, universalSndConic, map_specializeSecondCoordinates,
    MvPolynomial.map_map, MvPolynomial.map_map]
  have hX : (fun j : Fin 3 =>
      (MvPolynomial.map φ : MvPolynomial (Fin 3) k →+* MvPolynomial (Fin 3) K) (X j))
      = fun j : Fin 3 => (X j : MvPolynomial (Fin 3) K) := by
    funext j; simp
  have hC : ((MvPolynomial.map φ : MvPolynomial (Fin 3) k →+* MvPolynomial (Fin 3) K).comp
      (C : k →+* MvPolynomial (Fin 3) k))
      = (C : K →+* MvPolynomial (Fin 3) K).comp φ :=
    RingHom.ext fun a => by simp
  rw [hX, hC]

/-- **The degree-nine conic discriminant commutes with base change.** -/
theorem sndConicDiscriminant_map (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    sndConicDiscriminant (map φ F) = map φ (sndConicDiscriminant F) := by
  rw [sndConicDiscriminant, sndConicDiscriminant, ← map_universalSndConic φ F, polarMatrix_map]
  exact (RingHom.map_det _ _).symm

/-- Base change commutes with `aeval` at a point of the affine plane ring. -/
theorem affineTwoBaseChange_aeval (y : Fin 3 → affineTwoRing k) (P : MvPolynomial (Fin 3) k) :
    affineTwoBaseChange φ (aeval y P)
      = aeval (fun i => affineTwoBaseChange φ (y i)) (map φ P) := by
  induction P using MvPolynomial.induction_on with
  | C a => simp only [aeval_C, map_C, MvPolynomial.algebraMap_eq, affineTwoBaseChange_C]
  | add p q hp hq => simp only [_root_.map_add, hp, hq]
  | mul_X p i hp => simp only [_root_.map_mul, map_X, aeval_X, hp]

/-- **The pulled-back conic discriminant commutes with base change.** -/
theorem residualConicDiscriminantOn_map (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k) :
    residualConicDiscriminantOn (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (fun i => φ (r i))
        (N.map φ) (map φ F) (fun i => (v i).map φ)
      = affineTwoBaseChange φ (residualConicDiscriminantOn p₀ q₀ r N F v) := by
  rw [residualConicDiscriminantOn, residualConicDiscriminantOn, sndConicDiscriminant_map,
    ← residualYCoordsOn_map, affineTwoBaseChange_aeval]

/-- **G4 is invariant under field extension.**

Like `hpolar`, G4 is a nonvanishing statement, so it reflects along any ring hom and ascends along
an injective one.  A user may therefore verify it over `k̄`, where genericity arguments are
available, and pull it back to `k`. -/
theorem residualAvoidsConicDiscriminantOn_map_iff (p₀ q₀ r : Fin 3 → k)
    (N : Matrix (Fin 3) (Fin 3) k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) :
    ResidualAvoidsConicDiscriminantOn (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (fun i => φ (r i))
        (N.map φ) (map φ F) (fun i => (v i).map φ)
      ↔ ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v := by
  rw [ResidualAvoidsConicDiscriminantOn, ResidualAvoidsConicDiscriminantOn,
    residualConicDiscriminantOn_map]
  exact not_congr (map_eq_zero_iff _ (affineTwoBaseChange_injective φ.injective))

end G4

/-! ## The packaged transfer

The five conditions the closure-free theorem carries, sorted by which way they move.  The frame
relation `lineFrame p₀ q₀ r * N = 1` moves *up* for free (`lineFrame_map_mul_map`), because it is
an identity; the other four move *down*, by the iffs above; and the Tsen section moves neither way.
-/

section Package

variable {k K : Type u} [Field k] [Field K] (φ : k →+* K)

/-- **The frame relation travels the other way, and for free**: it is a polynomial identity, so it
ascends along any ring hom.  Recorded here so that the whole five-condition package can be moved
with lemmas from this one module. -/
theorem lineFrame_map_mul_map_of (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1) :
    lineFrame (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (fun i => φ (r i)) * N.map φ = 1 :=
  lineFrame_map_mul_map φ p₀ q₀ r N hMN

/-- G3 for a line presented by its spanning vectors, the shape
`det_residualYCoordsOn_ne_zero` takes it in. -/
theorem residualLineNonconstantOn_lineFrame_map_iff (p₀ q₀ r : Fin 3 → k)
    (N : Matrix (Fin 3) (Fin 3) k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    ResidualLineNonconstantOn
        (lineFrame (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (fun i => φ (r i))) (N.map φ) (map φ F)
      ↔ ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F := by
  rw [← lineFrame_map φ p₀ q₀ r]
  exact residualLineNonconstantOn_map_iff φ (lineFrame p₀ q₀ r) N F

/-- **Four of the five good-line conditions descend along a field extension.**

Verify G3, `v 2 ≠ 0`, stereographic nondegeneracy and G4 over any extension field `K` — for
instance over `k̄`, where genericity arguments are available — and they hold over `k`.

What is *not* here is the Tsen section: `v` is an input over `k` in both the hypothesis and the
conclusion.  A section over `K(t)` says nothing about `k(t)`, and no base change repairs that.  The
frame relation is likewise absent, because it travels the other way for free
(`lineFrame_map_mul_map_of`). -/
theorem goodLineData_of_map (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k)
    (hgood : ResidualLineNonconstantOn
      (lineFrame (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (fun i => φ (r i))) (N.map φ) (map φ F))
    (hv2 : (fun i => (v i).map φ) 2 ≠ 0)
    (hpolar : lineStereoPolarForm (fun i => φ (p₀ i)) (fun i => φ (q₀ i)) (map φ F)
      (fun i => (v i).map φ) ≠ 0)
    (hG4 : ResidualAvoidsConicDiscriminantOn (fun i => φ (p₀ i)) (fun i => φ (q₀ i))
      (fun i => φ (r i)) (N.map φ) (map φ F) (fun i => (v i).map φ)) :
    ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F ∧ v 2 ≠ 0 ∧
      lineStereoPolarForm p₀ q₀ F v ≠ 0 ∧
      ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v :=
  ⟨(residualLineNonconstantOn_lineFrame_map_iff φ p₀ q₀ r N F).mp hgood,
    (tsenSection_two_ne_zero_map_iff φ v).mp hv2,
    (lineStereoPolarForm_ne_zero_map_iff φ p₀ q₀ F v).mp hpolar,
    (residualAvoidsConicDiscriminantOn_map_iff φ p₀ q₀ r N F v).mp hG4⟩

/-- The same, along the structure map of a field extension. -/
theorem goodLineData_of_algebraMap [Algebra k K] (p₀ q₀ r : Fin 3 → k)
    (N : Matrix (Fin 3) (Fin 3) k) (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k)
    (hgood : ResidualLineNonconstantOn
      (lineFrame (fun i => algebraMap k K (p₀ i)) (fun i => algebraMap k K (q₀ i))
        (fun i => algebraMap k K (r i)))
      (N.map (algebraMap k K)) (map (algebraMap k K) F))
    (hv2 : (fun i => (v i).map (algebraMap k K)) 2 ≠ 0)
    (hpolar : lineStereoPolarForm (fun i => algebraMap k K (p₀ i))
      (fun i => algebraMap k K (q₀ i)) (map (algebraMap k K) F)
      (fun i => (v i).map (algebraMap k K)) ≠ 0)
    (hG4 : ResidualAvoidsConicDiscriminantOn (fun i => algebraMap k K (p₀ i))
      (fun i => algebraMap k K (q₀ i)) (fun i => algebraMap k K (r i)) (N.map (algebraMap k K))
      (map (algebraMap k K) F) (fun i => (v i).map (algebraMap k K))) :
    ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F ∧ v 2 ≠ 0 ∧
      lineStereoPolarForm p₀ q₀ F v ≠ 0 ∧
      ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v :=
  goodLineData_of_map (algebraMap k K) p₀ q₀ r N F v hgood hv2 hpolar hG4

end Package

/-! ## The intended instance: verify over `k̄`

`GoodLineExistence` and the genericity arguments that produce a good line all live over an
algebraically closed field.  This is the statement that lets them be used from a base field that is
not closed: the frame relation goes up, the four checkable conditions come back down, and only the
Tsen section has to be supplied over `k`. -/

section AlgClosure

variable {k : Type u} [Field k]

/-- **All that base change can do for the good-line data, in one statement.**

Given a frame relation over `k`, a verification of G3, `v 2 ≠ 0`, stereographic nondegeneracy and
G4 for the base-changed data over `k̄` yields those four conditions over `k` — and the frame
relation over `k̄` comes along for free, so nothing has to be re-established upstairs.

The Tsen section `v` is quantified over `k` on both sides.  That is the whole point: it is the one
input this theorem cannot manufacture. -/
theorem goodLineData_of_algebraicClosure (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (v : Fin 3 → Polynomial k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (hgood : ResidualLineNonconstantOn
      (lineFrame (fun i => algebraMap k (AlgebraicClosure k) (p₀ i))
        (fun i => algebraMap k (AlgebraicClosure k) (q₀ i))
        (fun i => algebraMap k (AlgebraicClosure k) (r i)))
      (N.map (algebraMap k (AlgebraicClosure k))) (map (algebraMap k (AlgebraicClosure k)) F))
    (hv2 : (fun i => (v i).map (algebraMap k (AlgebraicClosure k))) 2 ≠ 0)
    (hpolar : lineStereoPolarForm (fun i => algebraMap k (AlgebraicClosure k) (p₀ i))
      (fun i => algebraMap k (AlgebraicClosure k) (q₀ i))
      (map (algebraMap k (AlgebraicClosure k)) F)
      (fun i => (v i).map (algebraMap k (AlgebraicClosure k))) ≠ 0)
    (hG4 : ResidualAvoidsConicDiscriminantOn
      (fun i => algebraMap k (AlgebraicClosure k) (p₀ i))
      (fun i => algebraMap k (AlgebraicClosure k) (q₀ i))
      (fun i => algebraMap k (AlgebraicClosure k) (r i))
      (N.map (algebraMap k (AlgebraicClosure k))) (map (algebraMap k (AlgebraicClosure k)) F)
      (fun i => (v i).map (algebraMap k (AlgebraicClosure k)))) :
    lineFrame (fun i => algebraMap k (AlgebraicClosure k) (p₀ i))
          (fun i => algebraMap k (AlgebraicClosure k) (q₀ i))
          (fun i => algebraMap k (AlgebraicClosure k) (r i))
        * N.map (algebraMap k (AlgebraicClosure k)) = 1
      ∧ ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F ∧ v 2 ≠ 0 ∧
        lineStereoPolarForm p₀ q₀ F v ≠ 0 ∧
        ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v :=
  ⟨lineFrame_map_mul_map_of _ p₀ q₀ r N hMN,
    goodLineData_of_algebraMap (K := AlgebraicClosure k) p₀ q₀ r N F v hgood hv2 hpolar hG4⟩

end AlgClosure

end

end ResidualDataBaseChange

end BConicBundleMultisections
