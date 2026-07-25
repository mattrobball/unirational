/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PlaneCubicResidualEquivariance
public import BConicBundleMultisections.ResidualImageAffineParam

/-!
# The residual point lies on the residual line, for an arbitrary line

`eval_residualAmbientRep_residualLinearForm` (`ResidualImageAffineParam`) proves that the
tangent-residual point of a plane cubic lies on the cubic's residual line — but only for the
coordinate line `{W = 0}`, with the point normalised as `(1, t, 0)`, and only for the canonical
direction `p × ∇G(p)`.  The source proof (`certificates/all_smooth_tangent_residual_theorem.md`)
chooses the line in §3 and normalises only in §5, so the development needs the general statement.

This file removes both restrictions, in that order:

* `eval_residualAmbientRep_residualLinearForm_of_span` — any direction in the span of `p` and the
  canonical one works.  This is `residualAmbientRep_reparam`: the residual point only rescales, and
  a linear form vanishing is insensitive to that.
* `eval_residualAmbientRep_residualLinearFormOn` — the line is arbitrary.  The cubic is carried into
  the frame where the line is `{W = 0}` by `linearSubst`, the normalised statement is applied there,
  and the conclusion is carried back.

Nothing here re-derives the §5 coefficient identities: they are used verbatim in the normalised
frame.  The transport acts on a three-variable cubic, never on the biprojective scheme, so it needs
no `Proj.map` or ideal-sheaf machinery.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial
open _root_.MvPolynomial
open scoped Matrix

variable {R : Type u} [CommRing R]

/-! ### Removing the restriction on the direction -/

/-- The restricted cubic has a double root at the first endpoint: this is what makes the
construction residual.  It is the value and transverse-derivative vanishing of
`binaryLineRestriction_double_contact_first`, read as coefficients. -/
theorem coeff_binaryLineRestriction_double_contact
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p q : Fin 3 → R) (hp : eval p G = 0) (hq : q ∈ tangentHyperplaneCone G p) :
    coeff (binaryExponent 3 0) (binaryLineRestriction p q G) = 0 ∧
      coeff (binaryExponent 2 1) (binaryLineRestriction p q G) = 0 := by
  have hf : (binaryLineRestriction p q G).IsHomogeneous 3 :=
    binaryLineRestriction_isHomogeneous hG p q
  obtain ⟨h1, h2⟩ := binaryLineRestriction_double_contact_first G p q hp hq
  refine ⟨?_, ?_⟩
  · rw [← eval_binaryFirstEndpoint_binaryCubic _ hf]; exact h1
  · rw [← eval_pderiv_one_binaryFirstEndpoint_binaryCubic _ hf]; exact h2

/-- **The residual point lies on the residual line, for any direction spanning the tangent line.**

The canonical direction `p × ∇G(p)` is one choice of a vector spanning the tangent line at `p`
modulo `p`; transporting a frame produces a different one.  By `residualAmbientRep_reparam` the
residual point only picks up a factor of `α³`, and a linear form vanishes on a rescaled point
exactly when it vanishes on the original. -/
theorem eval_residualAmbientRep_residualLinearForm_of_span
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0) (hp : eval p G = 0)
    (q : Fin 3 → R) (α β : R)
    (hq : q = fun i => α * complementaryTangentDir G p i + β * p i) :
    eval (residualAmbientRep p q (binaryLineRestriction p q G))
        (PlaneCubicResidual.residualLinearForm G) = 0 := by
  set q₀ := complementaryTangentDir G p with hq₀
  set f₀ := binaryLineRestriction p q₀ G with hf₀
  have hfhom : f₀.IsHomogeneous 3 := binaryLineRestriction_isHomogeneous hG p q₀
  obtain ⟨h30, h21⟩ :=
    coeff_binaryLineRestriction_double_contact G hG p q₀ hp
      (complementaryTangentDir_mem_tangentHyperplaneCone G p)
  -- The residual point for `q` is `α³` times the one for the canonical direction.
  have hscale : residualAmbientRep p q (binaryLineRestriction p q G)
      = fun i => α ^ 3 * residualAmbientRep p q₀ f₀ i := by
    subst hq
    rw [binaryLineRestriction_reparam]
    exact residualAmbientRep_reparam p q₀ α β f₀ hfhom h30 h21
  rw [hscale]
  -- A linear form vanishing is insensitive to rescaling the point.
  have hbase : eval (residualAmbientRep p q₀ f₀)
      (PlaneCubicResidual.residualLinearForm G) = 0 :=
    eval_residualAmbientRep_residualLinearForm G hG p hp0 hp2 hp
  rw [PlaneCubicResidual.eval_residualLinearForm] at hbase ⊢
  simp only [UniversalResidual.residualLinear] at hbase ⊢
  linear_combination (α ^ 3) * hbase

/-! ### Removing the restriction on the line -/

/-- The residual point is built linearly from `p` and `q`, so a matrix passes through it. -/
theorem mulVec_residualAmbientRep (N : Matrix (Fin 3) (Fin 3) R) (p q : Fin 3 → R)
    (f : MvPolynomial (Fin 2) R) :
    N *ᵥ residualAmbientRep p q f = residualAmbientRep (N *ᵥ p) (N *ᵥ q) f := by
  funext j
  simp only [Matrix.mulVec, dotProduct, residualAmbientRep, Finset.mul_sum]
  rw [← Finset.sum_add_distrib]
  exact Finset.sum_congr rfl fun i _ => by ring

/-- Substituting linear forms preserves the degree of a homogeneous polynomial. -/
theorem isHomogeneous_aeval_linearSubst {n d : ℕ} (M : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    {G : MvPolynomial (Fin (n + 1)) R} (hG : G.IsHomogeneous d) :
    ((aeval (linearSubst n M) : MvPolynomial (Fin (n + 1)) R →ₐ[R] _) G).IsHomogeneous d := by
  simpa using hG.aeval (linearSubst n M) (isHomogeneous_linearSubst n M)

/-- **The residual point lies on the residual line, for an arbitrary line.**

`M` is the frame of the line (`lineFrame`, columns the spanning vectors) and `N` its inverse.  The
hypotheses are the normalised ones, read in the frame: `N *ᵥ p` is the point of the line in frame
coordinates, so `(N *ᵥ p) 2 = 0` says `p` lies on the line and `(N *ᵥ p) 0 = 1` normalises it.

The proof carries everything into the frame, where `eval_residualAmbientRep_residualLinearForm_of_span`
applies verbatim, and carries the conclusion back.  No §5 identity is re-derived. -/
theorem eval_residualAmbientRep_residualLinearFormOn
    (M N : Matrix (Fin 3) (Fin 3) R) (hMN : M * N = 1)
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p q : Fin 3 → R)
    (hp0 : (N *ᵥ p) 0 = 1) (hp2 : (N *ᵥ p) 2 = 0) (hp : eval p G = 0)
    (α β : R)
    (hq : N *ᵥ q = fun i =>
      α * complementaryTangentDir
            ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G) (N *ᵥ p) i
        + β * (N *ᵥ p) i) :
    eval (residualAmbientRep p q (binaryLineRestriction p q G))
        (residualLinearFormOn M N G) = 0 := by
  set Gb := (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G with hGb
  -- `M` undoes `N` on points.
  have hinv : ∀ x : Fin 3 → R, M *ᵥ (N *ᵥ x) = x := by
    intro x; rw [Matrix.mulVec_mulVec, hMN, Matrix.one_mulVec]
  -- The restricted cubic is the same computed in the frame.
  have hrestr : binaryLineRestriction p q G
      = binaryLineRestriction (N *ᵥ p) (N *ᵥ q) Gb := by
    rw [hGb, binaryLineRestriction_aeval_linearSubst, hinv, hinv]
  -- The frame point lies on the transported cubic.
  have hpb : eval (N *ᵥ p) Gb = 0 := by
    rw [hGb, eval_aeval_linearSubst, hinv]; exact hp
  rw [eval_residualLinearFormOn, hrestr, mulVec_residualAmbientRep, ← hGb]
  exact eval_residualAmbientRep_residualLinearForm_of_span Gb
    (isHomogeneous_aeval_linearSubst M hG) (N *ᵥ p) hp0 hp2 hpb (N *ᵥ q) α β hq

/-- The tangent direction of a plane cubic at a point of an arbitrary line, read through the frame.

For the coordinate frame this is `complementaryTangentDir` itself; in general it is that direction
computed for the transported cubic and carried back.  Defining it this way — rather than as
`p × ∇G(p)`, which transports only up to the span of `p` — is what makes the residual construction
available for an arbitrary line without a cross-product equivariance argument. -/
def frameTangentDir (M N : Matrix (Fin 3) (Fin 3) R) (G : MvPolynomial (Fin 3) R)
    (p : Fin 3 → R) : Fin 3 → R :=
  M *ᵥ complementaryTangentDir
    ((aeval (linearSubst 2 M) : MvPolynomial (Fin 3) R →ₐ[R] _) G) (N *ᵥ p)

/-- **The residual point lies on the residual line, for an arbitrary line — usable form.**

Taking the direction to be `frameTangentDir` discharges the span hypothesis of
`eval_residualAmbientRep_residualLinearFormOn` outright, with `α = 1` and `β = 0`.  What remains are
exactly the geometric hypotheses: `p` lies on the cubic, and lies on the line in normalised
position. -/
theorem eval_residualAmbientRep_residualLinearFormOn_frameTangentDir
    (M N : Matrix (Fin 3) (Fin 3) R) (hMN : M * N = 1)
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p : Fin 3 → R)
    (hp0 : (N *ᵥ p) 0 = 1) (hp2 : (N *ᵥ p) 2 = 0) (hp : eval p G = 0) :
    eval (residualAmbientRep p (frameTangentDir M N G p)
          (binaryLineRestriction p (frameTangentDir M N G p) G))
        (residualLinearFormOn M N G) = 0 := by
  have hinv : ∀ x : Fin 3 → R, N *ᵥ (M *ᵥ x) = x := by
    intro x
    rw [Matrix.mulVec_mulVec]
    rw [Matrix.mul_eq_one_comm.mp hMN, Matrix.one_mulVec]
  refine eval_residualAmbientRep_residualLinearFormOn M N hMN G hG p _ hp0 hp2 hp 1 0 ?_
  rw [frameTangentDir, hinv]
  funext i
  ring

/-! ### The line's own frame

Specialising to `M = lineFrame p₀ q₀ r` discharges the normalisation hypotheses: the frame carries
`[1 : t : 0]` to the point of `L` at parameter `t`, so in frame coordinates that point *is*
`[1 : t : 0]`, which is normalised on `{W = 0}` by construction. -/

/-- In the frame of `L`, the point of `L` at parameter `t` has coordinates `(1, t, 0)`. -/
theorem mulVec_inverse_linePointOf (p₀ q₀ r : Fin 3 → R) (N : Matrix (Fin 3) (Fin 3) R)
    (hMN : lineFrame p₀ q₀ r * N = 1) (t : R) :
    N *ᵥ linePointOf p₀ q₀ t = ![1, t, 0] := by
  rw [← lineFrame_mulVec_coordinateLinePoint p₀ q₀ r t, Matrix.mulVec_mulVec,
    Matrix.mul_eq_one_comm.mp hMN, Matrix.one_mulVec]

/-- **The residual point of a plane cubic at a point of an arbitrary line lies on that line's
residual line.**

This is the general form of the §5 statement the development previously had only for `{W = 0}`.
The line enters as its frame; the only hypotheses left are that the frame is invertible and that the
point of `L` at parameter `t` lies on the cubic. -/
theorem eval_residualAmbientRep_residualLinearFormOn_linePointOf
    (p₀ q₀ r : Fin 3 → R) (N : Matrix (Fin 3) (Fin 3) R)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3) (t : R)
    (hp : eval (linePointOf p₀ q₀ t) G = 0) :
    eval (residualAmbientRep (linePointOf p₀ q₀ t)
          (frameTangentDir (lineFrame p₀ q₀ r) N G (linePointOf p₀ q₀ t))
          (binaryLineRestriction (linePointOf p₀ q₀ t)
            (frameTangentDir (lineFrame p₀ q₀ r) N G (linePointOf p₀ q₀ t)) G))
        (residualLinearFormOn (lineFrame p₀ q₀ r) N G) = 0 := by
  have hcoord := mulVec_inverse_linePointOf p₀ q₀ r N hMN t
  refine eval_residualAmbientRep_residualLinearFormOn_frameTangentDir _ N hMN G hG _ ?_ ?_ hp
  · rw [hcoord]; simp
  · rw [hcoord]; simp

/-! ### Reduction to the coordinate line

The general construction must agree with the existing one on the line the development hardcoded,
or generality would have been bought at the price of a different object.  It does: the coordinate
line's frame is the identity matrix, and every general notion collapses to its normalised
counterpart. -/

/-- The frame of the coordinate line is the identity. -/
@[simp] theorem lineFrame_coordinate :
    lineFrame ![1, 0, 0] ![0, 1, 0] ![0, 0, (1 : R)] = 1 := by
  ext j l
  fin_cases j <;> fin_cases l <;> simp [lineFrame, Matrix.one_apply]

/-- For the identity frame the transported tangent direction is the canonical one. -/
@[simp] theorem frameTangentDir_one (G : MvPolynomial (Fin 3) R) (p : Fin 3 → R) :
    frameTangentDir 1 1 G p = complementaryTangentDir G p := by
  rw [frameTangentDir, Matrix.one_mulVec, linearSubst_one, Matrix.one_mulVec]
  congr 1
  exact aeval_X_left_apply G

/-- **On the coordinate line the general residual line is the one the development already had.**

So `residualLinearFormOn` extends `PlaneCubicResidual.residualLinearForm` rather than replacing it,
and the coordinate-line results remain exactly the special case they were. -/
theorem residualLinearFormOn_coordinateLine (G : MvPolynomial (Fin 3) R) :
    residualLinearFormOn (lineFrame ![1, 0, 0] ![0, 1, 0] ![0, 0, (1 : R)]) 1 G
      = PlaneCubicResidual.residualLinearForm G := by
  rw [lineFrame_coordinate, residualLinearFormOn_one]

/-- The general vanishing theorem specialises back to the coordinate-line one. -/
theorem eval_residualAmbientRep_residualLinearFormOn_coordinateLine
    (G : MvPolynomial (Fin 3) R) (hG : G.IsHomogeneous 3)
    (p : Fin 3 → R) (hp0 : p 0 = 1) (hp2 : p 2 = 0) (hp : eval p G = 0) :
    eval (residualAmbientRep p (complementaryTangentDir G p)
          (binaryLineRestriction p (complementaryTangentDir G p) G))
        (residualLinearFormOn (lineFrame ![1, 0, 0] ![0, 1, 0] ![0, 0, (1 : R)]) 1 G) = 0 := by
  rw [residualLinearFormOn_coordinateLine]
  exact eval_residualAmbientRep_residualLinearForm G hG p hp0 hp2 hp

end

end BConicBundleMultisections
