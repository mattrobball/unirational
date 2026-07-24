/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualDivisor

/-!
# Nonconstancy of the residual line

Condition **G3** of `PLAN.md` WP-5, in concrete form.

`certificates/all_smooth_tangent_residual_theorem.md` §5 writes the residual line as

```
q_L(x, y) = q_U(x)·U + q_V(x)·V + q_W(x)·W
```

with `q_U, q_V, q_W` homogeneous of degree ten in `x`.  Viewed as a point of `(ℙ²_y)^∨` depending
on `x`, this is the residual-line map `δ_C(L)` of §2–§3.  It is **constant** exactly when the three
coefficient forms are proportional with *constant* ratios; §3 chooses `L` so that it is not.

## Why this predicate is needed

§4 proves horizontality by a contradiction ending "…so `δ_C(L) = M ∈ (ℙ²_y)^∨(k)`, contrary to the
choice of `L`", and §5 records that horizontality is *equivalent* to nonconstancy of `δ_C(L)`.  So
this is a genuine hypothesis, not a consequence: for a line where it fails, horizontality is false.
An earlier version of the plan recorded it as "verified unnecessary"; that was wrong, and the
obligation in `ResidualComponentHorizontality.lean` inherits the defect until this is threaded
through.

Stating it concretely here means the Lattès map `δ_C`, dual varieties and biduality are **not**
needed to express the condition — they are needed in the source only to prove that a good `L`
*exists*, which is WP-5's remaining half.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial ResidualDivisor

variable {k : Type u} [CommRing k]

/-- The three degree-ten coefficient forms of the residual line, `q_U, q_V, q_W` of §5.

`residualEquation F` has bidegree `(10, 1)`, so it is linear in `y`; this extracts the coefficient
of `y_a`, a form in `x` alone. -/
def residualLineCoeff (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (a : Fin 3) :
    MvPolynomial (Fin 3) k :=
  secondBlockCoeff (residualEquation F) (Finsupp.single a 1)

/-- **The residual line is constant**: as `x` varies, the point `[q_U(x) : q_V(x) : q_W(x)]` of
`(ℙ²_y)^∨` does not move.

Equivalently the three coefficient forms are common multiples of a single form with *constant*
ratios.  This is the negation of the source's condition on `L`. -/
def ResidualLineConstant (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Prop :=
  ∃ (g : MvPolynomial (Fin 3) k) (c : Fin 3 → k),
    ∀ a : Fin 3, residualLineCoeff F a = C (c a) * g

/-- **Condition G3**: the residual line is nonconstant — the source's requirement on the choice of
`L`, here for the fixed coordinate line `{Y₂ = 0}` and hence a condition on `F`. -/
def ResidualLineNonconstant (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Prop :=
  ¬ ResidualLineConstant F

/-- Unfolding lemma: nonconstancy says no single form with constant ratios reproduces all three
coefficient forms. -/
theorem residualLineNonconstant_iff (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    ResidualLineNonconstant F ↔
      ¬ ∃ (g : MvPolynomial (Fin 3) k) (c : Fin 3 → k),
          ∀ a : Fin 3, residualLineCoeff F a = C (c a) * g :=
  Iff.rfl

/-! ### A convenience criterion, deliberately not stated here

The tempting shortcut — *"if `q_a` is not a constant multiple of `q_b` then the line is
nonconstant"* — is **false**: constancy with `c b = 0` and `c a ≠ 0` gives `q_b = 0` and
`q_a ≠ 0`, and then no scalar `c` satisfies `q_a = C c * q_b`, yet the line is constant.

The correct criterion is `k`-linear independence of two of the three coefficient forms (constancy
puts all three in the `k`-span of a single `g`, which has dimension at most one).  That needs a
`Field k` and the module structure, so it is left to whoever first needs it rather than guessed at
here.
-/

end

end BConicBundleMultisections
