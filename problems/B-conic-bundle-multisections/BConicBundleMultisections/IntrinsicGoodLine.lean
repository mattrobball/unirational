/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.LinePairChangeResidualLine

/-!
# The intrinsic good-line hypothesis (Goal F-4)

The hypothesis of the closure-free unirationality theorem used to be a tuple

```
∃ (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (v : Fin 3 → Polynomial k),
  Standard.HasGoodLineWithSection F p q r N v
```

in which only `(p, q)` — the pair spanning the multisection line `L` — and `v` carry geometry.
The completion `r` and the frame inverse `N` are a **gauge choice**: they name a chart in which
the residual construction is written, not a datum of the geometry.  Worse, `(p, q)` itself is only
a *presentation* of `L`; any other independent pair with the same span presents the same line.

The F-campaign removed both dependencies:

* **F-1 + F-3** (`LinePresentationPairChange`, `LinePairChangeResidualLine`):
  `hasGoodLineWithSection_pair_change` — the full predicate transports under every `GL₂` change
  `(p, q) ↦ (a·p + b·q, c·p + d·q)` of the spanning pair.
* **F-2** (`LineCompletionChange`, `LineCompletionResidualLine`):
  `hasGoodLineSectionPartial_completion_change` and `residualLineConstantOn_completion_iff` — the
  predicate transports under every change of the completion `(r, N)`, condition G3 included, by
  pure `C (g ^ 2)` / `C (det ^ 6)` unit laws.

This module packages the result.  `GoodLineSection F` bundles a `MultisectionLine k` — the line as
an object, `base`/`dir`/`indep` — with a section `v` and the *existential* over `(r, N)`.  The
existential is the honest form precisely because F-2 makes it presentation-independent: no choice
of chart is recorded, and none can be recovered from the bundle.

## What is proved here

* `span_pair_eq_iff_exists_gl2` — two independent pairs span the same subspace iff they are related
  by an invertible `2 × 2` change.  This is the linear algebra that turns F-1 + F-3's `GL₂`
  transport into a statement about the *line*.
* `isGoodMultisectionLine_congr_span` / `goodLineSection_congr_span` — goodness depends only on the
  span of `(base, dir)`.  The section may move: the swap normalisation used in F-1 replaces `v`,
  so the honest conclusion carries `∃ v'`.
* `goodLineSection_iff` — the bundle is equivalent to the old tuple.  The `←` direction needs
  `LinearIndependent k ![p, q]`, which is *not* an explicit conjunct of
  `Standard.HasGoodLineWithSection`; it is forced by the frame identity
  `lineFrame p q r * N = 1`, since a right inverse of a square matrix over a field makes it a unit,
  hence its three columns `p`, `q`, `r` independent.  That is
  `linearIndependent_pair_of_lineFrame_mul_eq_one` below — the `[Infinite k]`-free restatement of
  `Standard.linearIndependent_pair_of_lineFrame_right_inverse`.
* `smooth_bidegree23_hasUnirationalParametrization_of_goodLineSection''` and its closed-field
  corollary — the unirationality theorem stated against the intrinsic hypothesis.

## What is *not* yet intrinsic

Two layers remain parameterised, and both are separate campaigns:

* the **section** is a polynomial triple `v : Fin 3 → Polynomial k`, not a scheme-theoretic
  multisection of the conic bundle;
* the **line** is a `MultisectionLine k` — a chosen affine parameterisation `t ↦ base + t · dir` —
  not a point of the dual plane `(ℙ²)ˇ`.  `span_pair_eq_iff_exists_gl2` and
  `isGoodMultisectionLine_congr_span` are exactly the statement that the parameterisation is
  invisible to goodness, so the quotient by it is available; taking it is not done here.
-/

@[expose] public section

namespace BConicBundleMultisections

universe u v

open AlgebraicGeometry
open _root_.MvPolynomial
open scoped _root_.Matrix

variable {k : Type u} [Field k]

/-! ### F-4.2a — the linear algebra of a change of spanning pair

Two independent pairs with the same span are related by an invertible `2 × 2` matrix.  Membership
supplies the four coefficients; independence of the *target* pair supplies invertibility. -/

/-- **Same span ↔ invertible change of pair.**  Two linearly independent pairs span the same
submodule exactly when an invertible `2 × 2` matrix carries the first to the second.

Mathlib has no packaged form of this (its `span_pair_*` family is about ideals), so it is proved
here.  Only `h'` is load-bearing: it forces `a * d - b * c ≠ 0` in the `→` direction, since
otherwise all four coefficients vanish and `p' = 0`.  `h` is carried for symmetry — the statement
is about two *presentations* of one line — and is used by neither direction. -/
theorem span_pair_eq_iff_exists_gl2 {M : Type v} [AddCommGroup M] [Module k M]
    {p q p' q' : M} (h : LinearIndependent k ![p, q]) (h' : LinearIndependent k ![p', q']) :
    Submodule.span k ({p, q} : Set M) = Submodule.span k ({p', q'} : Set M) ↔
      ∃ a b c d : k, a * d - b * c ≠ 0 ∧ p' = a • p + b • q ∧ q' = c • p + d • q := by
  classical
  constructor
  · intro hspan
    obtain ⟨a, b, hab⟩ : ∃ a b : k, a • p + b • q = p' :=
      Submodule.mem_span_pair.mp (by rw [hspan]; exact Submodule.subset_span (by simp))
    obtain ⟨c, d, hcd⟩ : ∃ c d : k, c • p + d • q = q' :=
      Submodule.mem_span_pair.mp (by rw [hspan]; exact Submodule.subset_span (by simp))
    refine ⟨a, b, c, d, ?_, hab.symm, hcd.symm⟩
    intro hdet
    -- The two "adjugate" combinations of `p'`, `q'` are `(a*d - b*c)` times `p` and `q`.
    have e1 : d • p' + (-b) • q' = (a * d - b * c) • p := by rw [← hab, ← hcd]; module
    have e2 : (-c) • p' + a • q' = (a * d - b * c) • q := by rw [← hab, ← hcd]; module
    rw [hdet, zero_smul] at e1 e2
    obtain ⟨hd, hb⟩ := h'.eq_zero_of_pair e1
    obtain ⟨hc, ha⟩ := h'.eq_zero_of_pair e2
    have hb' : b = 0 := by simpa using hb
    have hc' : c = 0 := by simpa using hc
    -- All four coefficients vanish, so `p' = 0`, contradicting its independence from `q'`.
    have hp' : p' = 0 := by rw [← hab, ha, hb', zero_smul, zero_smul, add_zero]
    exact (h'.ne_zero 0) (by simpa using hp')
  · rintro ⟨a, b, c, d, hdet, rfl, rfl⟩
    apply le_antisymm
    · -- `p` and `q` are recovered from `p'`, `q'` by the inverse matrix.
      rw [Submodule.span_le]
      have e1 : (a * d - b * c) • p = d • (a • p + b • q) + (-b) • (c • p + d • q) := by module
      have e2 : (a * d - b * c) • q = (-c) • (a • p + b • q) + a • (c • p + d • q) := by module
      rintro x (rfl | rfl)
      · refine Submodule.mem_span_pair.mpr
          ⟨(a * d - b * c)⁻¹ * d, (a * d - b * c)⁻¹ * (-b), ?_⟩
        rw [mul_smul, mul_smul, ← smul_add, ← e1, inv_smul_smul₀ hdet]
      · refine Submodule.mem_span_pair.mpr
          ⟨(a * d - b * c)⁻¹ * (-c), (a * d - b * c)⁻¹ * a, ?_⟩
        rw [mul_smul, mul_smul, ← smul_add, ← e2, inv_smul_smul₀ hdet]
    · rw [Submodule.span_le]
      rintro x (rfl | rfl)
      · exact Submodule.mem_span_pair.mpr ⟨a, b, rfl⟩
      · exact Submodule.mem_span_pair.mpr ⟨c, d, rfl⟩

/-- The `→` direction of `span_pair_eq_iff_exists_gl2`, in the form the transport lemmas consume:
the coefficients appear pointwise rather than as `•`. -/
theorem exists_gl2_of_span_pair_eq {p q p' q' : Fin 3 → k}
    (h : LinearIndependent k ![p, q]) (h' : LinearIndependent k ![p', q'])
    (hspan : Submodule.span k ({p, q} : Set (Fin 3 → k))
      = Submodule.span k ({p', q'} : Set (Fin 3 → k))) :
    ∃ a b c d : k, a * d - b * c ≠ 0 ∧ p' = (fun i => a * p i + b * q i) ∧
      q' = (fun i => c * p i + d * q i) := by
  obtain ⟨a, b, c, d, hdet, hp, hq⟩ := (span_pair_eq_iff_exists_gl2 h h').mp hspan
  exact ⟨a, b, c, d, hdet, by rw [hp]; rfl, by rw [hq]; rfl⟩

/-! ### F-4.3a — the frame identity forces independence of the pair

`Standard.HasGoodLineWithSection` does not list `LinearIndependent k ![p, q]` as a conjunct, so the
bundle below could not be built from it without a bridge.  The bridge is the frame identity: a
square matrix over a field with a right inverse is a unit, so the three columns `p`, `q`, `r` of
`lineFrame p q r` are independent, and in particular so is the pair. -/

/-- **A right inverse of the frame makes the pair independent.**

`Standard.linearIndependent_pair_of_lineFrame_right_inverse` proves the same thing, but a
file-level `variable [Infinite K]` in `Standard/G3FrameIncidenceSelection` attaches a spurious
infiniteness binder to it.  Nothing here needs it — the statement is pure linear algebra over an
arbitrary field — so it is restated with the binder removed. -/
theorem linearIndependent_pair_of_lineFrame_mul_eq_one
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p q r * N = 1) :
    LinearIndependent k ![p, q] := by
  have hNM : N * lineFrame p q r = 1 := mul_eq_one_comm.mp hMN
  have hNp : Matrix.mulVec N p = ![1, 0, 0] := by
    calc
      Matrix.mulVec N p
          = Matrix.mulVec N (Matrix.mulVec (lineFrame p q r) ![1, 0, 0]) := by
            rw [lineFrame_mulVec_base]
      _ = ![1, 0, 0] := by rw [Matrix.mulVec_mulVec, hNM, Matrix.one_mulVec]
  have hNq : Matrix.mulVec N q = ![0, 1, 0] := by
    calc
      Matrix.mulVec N q
          = Matrix.mulVec N (Matrix.mulVec (lineFrame p q r) ![0, 1, 0]) := by
            rw [lineFrame_mulVec_dir]
      _ = ![0, 1, 0] := by rw [Matrix.mulVec_mulVec, hNM, Matrix.one_mulVec]
  rw [LinearIndependent.pair_iff]
  intro a b hab
  have hab' := congrArg (Matrix.mulVec N) hab
  simp only [Matrix.mulVec_add, Matrix.mulVec_smul, Matrix.mulVec_zero, hNp, hNq] at hab'
  have ha := congrFun hab' (0 : Fin 3)
  have hb := congrFun hab' (1 : Fin 3)
  exact ⟨by simpa [Pi.smul_apply] using ha, by simpa [Pi.smul_apply] using hb⟩

/-- **The bridge.**  A good line with section presents a genuine line: the frame identity
`lineFrame p q r * N = 1` forces `p` and `q` independent. -/
theorem Standard.HasGoodLineWithSection.linearIndependent_pair
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) k}
    {p q r : Fin 3 → k} {N : Matrix (Fin 3) (Fin 3) k} {v : Fin 3 → Polynomial k}
    (h : Standard.HasGoodLineWithSection F p q r N v) :
    LinearIndependent k ![p, q] :=
  linearIndependent_pair_of_lineFrame_mul_eq_one p q r N h.1

/-- The multisection line underlying a good line with section. -/
def Standard.HasGoodLineWithSection.line
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) k}
    {p q r : Fin 3 → k} {N : Matrix (Fin 3) (Fin 3) k} {v : Fin 3 → Polynomial k}
    (h : Standard.HasGoodLineWithSection F p q r N v) : MultisectionLine k where
  base := p
  dir := q
  indep := h.linearIndependent_pair

@[simp] theorem Standard.HasGoodLineWithSection.line_base
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) k}
    {p q r : Fin 3 → k} {N : Matrix (Fin 3) (Fin 3) k} {v : Fin 3 → Polynomial k}
    (h : Standard.HasGoodLineWithSection F p q r N v) : h.line.base = p := rfl

@[simp] theorem Standard.HasGoodLineWithSection.line_dir
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) k}
    {p q r : Fin 3 → k} {N : Matrix (Fin 3) (Fin 3) k} {v : Fin 3 → Polynomial k}
    (h : Standard.HasGoodLineWithSection F p q r N v) : h.line.dir = q := rfl

/-! ### F-4.1 — the intrinsic hypothesis -/

/-- **A good multisection line for `F`, as a property of the line.**

`L` is good when *some* section `v` on it satisfies the full package — G3, the line discriminant,
isotropy and G4 — in *some* chart `(r, N)`.  Both existentials are gauge, not data: F-2 shows
`(r, N)` is presentation-independent, and the section is pinned only up to the moves of F-1. -/
def IsGoodMultisectionLine (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (L : MultisectionLine k) : Prop :=
  ∃ (v : Fin 3 → Polynomial k) (r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k),
    Standard.HasGoodLineWithSection F L.base L.dir r N v

/-- **The intrinsic hypothesis of the unirationality theorem.**

A multisection line `L` for `F`, a section `v` along it, and the assertion that the full good-line
package holds in some chart.  The chart `(r, N)` is existentially quantified because F-2 proves the
package independent of it; the line is a `MultisectionLine`, so no spanning pair is privileged
beyond `L.base`, `L.dir`, and `isGoodMultisectionLine_congr_span` below removes even that. -/
structure GoodLineSection (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) where
  /-- The multisection line along which the residual construction runs. -/
  L : MultisectionLine k
  /-- The isotropic section of the conic bundle restricted to `L`. -/
  v : Fin 3 → Polynomial k
  /-- The good-line package, in some completion `r` with frame inverse `N`. -/
  good : ∃ (r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k),
    Standard.HasGoodLineWithSection F L.base L.dir r N v

/-- The bundle and the line-level predicate agree. -/
theorem nonempty_goodLineSection_iff_exists_isGoodMultisectionLine
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    Nonempty (GoodLineSection F) ↔ ∃ L : MultisectionLine k, IsGoodMultisectionLine F L := by
  constructor
  · rintro ⟨G⟩; exact ⟨G.L, G.v, G.good⟩
  · rintro ⟨L, v, r, N, h⟩; exact ⟨⟨L, v, r, N, h⟩⟩

/-! ### F-4.2 — well-definedness across presentations of the same line -/

/-- **Goodness is a property of the line, not of the spanning pair.**

If `L` and `L'` span the same subspace of `k³` — i.e. are the same line of `ℙ²` — then a good
section on `L` produces a good section on `L'`.  The section moves: the swap normalisation inside
F-1 replaces `v`, so the conclusion is an existential over `v'`, and that is the honest form. -/
theorem goodLineSection_congr_span
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (L L' : MultisectionLine k)
    (hspan : Submodule.span k ({L.base, L.dir} : Set (Fin 3 → k))
      = Submodule.span k ({L'.base, L'.dir} : Set (Fin 3 → k)))
    (v : Fin 3 → Polynomial k)
    (h : ∃ (r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k),
      Standard.HasGoodLineWithSection F L.base L.dir r N v) :
    ∃ (v' : Fin 3 → Polynomial k) (r' : Fin 3 → k) (N' : Matrix (Fin 3) (Fin 3) k),
      Standard.HasGoodLineWithSection F L'.base L'.dir r' N' v' := by
  obtain ⟨r, N, hgood⟩ := h
  obtain ⟨a, b, c, d, hdet, hbase, hdir⟩ :=
    exists_gl2_of_span_pair_eq L.indep L'.indep hspan
  obtain ⟨r', N', v', hgood'⟩ :=
    hasGoodLineWithSection_pair_change F hF L.base L.dir r N v a b c d hdet hgood
  exact ⟨v', r', N', by rw [hbase, hdir]; exact hgood'⟩

/-- Line-level form of `goodLineSection_congr_span`: `IsGoodMultisectionLine F` factors through
the span of `(base, dir)`. -/
theorem isGoodMultisectionLine_congr_span
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    {L L' : MultisectionLine k}
    (hspan : Submodule.span k ({L.base, L.dir} : Set (Fin 3 → k))
      = Submodule.span k ({L'.base, L'.dir} : Set (Fin 3 → k)))
    (h : IsGoodMultisectionLine F L) : IsGoodMultisectionLine F L' := by
  obtain ⟨v, hv⟩ := h
  exact goodLineSection_congr_span F hF L L' hspan v hv

/-! ### F-4.3 — the dictionary and the theorem -/

/-- **The dictionary.**  The intrinsic bundle is equivalent to the old five-fold tuple.

`→` forgets the independence datum.  `←` recovers it: the frame identity inside
`Standard.HasGoodLineWithSection` makes `lineFrame p q r` a unit, hence `p`, `q` independent
(`Standard.HasGoodLineWithSection.linearIndependent_pair`). -/
theorem goodLineSection_iff (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    Nonempty (GoodLineSection F) ↔
      ∃ (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k) (v : Fin 3 → Polynomial k),
        Standard.HasGoodLineWithSection F p q r N v := by
  constructor
  · rintro ⟨⟨L, v, r, N, h⟩⟩; exact ⟨L.base, L.dir, r, N, v, h⟩
  · rintro ⟨p, q, r, N, v, h⟩; exact ⟨⟨h.line, v, r, N, h⟩⟩

/--
**Unirationality from the intrinsic hypothesis.**

Every smooth bidegree-`(2,3)` hypersurface in `ℙ² × ℙ²` over an infinite field of characteristic
prime to `6` that carries *one good multisection line with a section* is unirational.

This is `smooth_bidegree23_hasUnirationalParametrization_of_lineSection'` with its hypothesis
restated intrinsically: no frame completion, no frame inverse, and no choice of spanning pair
appears in the statement.  The `''` marks the second weakening of the hypothesis surface of
`smooth_bidegree23_hasUnirationalParametrization_of_goodLineSection`.
-/
theorem smooth_bidegree23_hasUnirationalParametrization_of_goodLineSection''
    (k : Type u) [Field k] [NeZero (2 : k)] [NeZero (3 : k)] [Infinite k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (h : Nonempty (GoodLineSection F)) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) :=
  smooth_bidegree23_hasUnirationalParametrization_of_lineSection' k F hF hF0
    ((goodLineSection_iff F).mp h)

/-- **Non-vacuity of the intrinsic hypothesis.**  Over an algebraically closed field every smooth
bidegree-`(2,3)` hypersurface carries a good multisection line with a section; the frame-incidence
construction produces one. -/
theorem nonempty_goodLineSection_of_isAlgClosed
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    Nonempty (GoodLineSection F) := by
  obtain ⟨p, q, r, N, _x, v, _u, hactual, _⟩ :=
    Standard.exists_actualG3G4LineSection_via_frameIncidence F hF hF0
  have hdisc : lineConicDiscriminant p q F ≠ 0 :=
    lineConicDiscriminant_ne_zero_of_smooth p q r N hactual.1 F hF hF0
  exact (goodLineSection_iff F).mpr
    ⟨p, q, r, N, v, hactual.to_HasGoodLineWithSection F p q r N v hdisc⟩

/-- **Closed-field corollary.**  Over an algebraically closed field the `[Infinite k]` binder of
`smooth_bidegree23_hasUnirationalParametrization_of_goodLineSection''` is redundant. -/
theorem smooth_bidegree23_hasUnirationalParametrization_of_goodLineSection''_of_isAlgClosed
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (h : Nonempty (GoodLineSection F)) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F) :=
  smooth_bidegree23_hasUnirationalParametrization_of_goodLineSection'' k F hF hF0 h

end BConicBundleMultisections
