/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.UniversalResidualIdentity

/-!
# Exact Hesse-form residual-map certificate

On the affine chart of the dual plane parametrising the line
`W = s U + t V`, carry the Hesse cubic

`U³ + V³ + W³ - 3 λ U V W`

into the frame with third coordinate `W - sU - tV`.  Its ten coefficients in that frame are

```
1+s³,  3s²t-3λs,  3st²-3λt,  1+t³,
3s²,   6st-3λ,     3t²,       3s, 3t, 1.
```

The three identities below substitute those coefficients into the universal residual formula and
pull the resulting linear form back to the original coordinates.  They give a degree-four map,
with the expected common scalar `27(λ³-1)`.  These are pure polynomial identities checked by
Lean's `ring` tactic; they are the exact algebraic core of
`certificates/residual_line_pencil_probe.py`.

This module does **not** assert the global Hesse-normal-form theorem or the saturation statement
that the common fixed-line equations cut out the Hesse pencil.  Those are separate geometric and
commutative-algebra obligations.
-/

@[expose] public section

namespace BConicBundleMultisections.HesseResidualCertificate

universe u

variable {R : Type u} [CommRing R]

abbrev A (_lam s _t : R) := 1 + s ^ 3
abbrev B (lam s t : R) := 3 * s ^ 2 * t - 3 * lam * s
abbrev C (lam s t : R) := 3 * s * t ^ 2 - 3 * lam * t
abbrev D (_lam _s t : R) := 1 + t ^ 3
abbrev E (_lam s _t : R) := 3 * s ^ 2
abbrev F (lam s t : R) := 6 * s * t - 3 * lam
abbrev H (_lam _s t : R) := 3 * t ^ 2
abbrev I (_lam s _t : R) := 3 * s
abbrev J (_lam _s t : R) := 3 * t
abbrev K (_lam _s _t : R) := 1

/-- First coefficient after pulling the residual linear form back to the original coordinates. -/
abbrev ambientCoeffU (lam s t : R) :=
  UniversalResidual.residualCoeffU
      (A lam s t) (B lam s t) (C lam s t) (D lam s t)
      (E lam s t) (F lam s t) (H lam s t) (I lam s t)
    - s * UniversalResidual.residualCoeffW
      (A lam s t) (B lam s t) (C lam s t) (D lam s t)
      (E lam s t) (F lam s t) (H lam s t) (K lam s t)

/-- Second coefficient after pulling the residual linear form back to the original coordinates. -/
abbrev ambientCoeffV (lam s t : R) :=
  UniversalResidual.residualCoeffV
      (A lam s t) (B lam s t) (C lam s t) (D lam s t)
      (E lam s t) (F lam s t) (H lam s t) (J lam s t)
    - t * UniversalResidual.residualCoeffW
      (A lam s t) (B lam s t) (C lam s t) (D lam s t)
      (E lam s t) (F lam s t) (H lam s t) (K lam s t)

/-- Third coefficient after pulling the residual linear form back to the original coordinates. -/
abbrev ambientCoeffW (lam s t : R) :=
  UniversalResidual.residualCoeffW
    (A lam s t) (B lam s t) (C lam s t) (D lam s t)
    (E lam s t) (F lam s t) (H lam s t) (K lam s t)

/-- First ambient coefficient of the residual line of a Hesse cubic on `W = sU+tV`. -/
theorem residualCoeffU_sub_smul_residualCoeffW (lam s t : R) :
    ambientCoeffU lam s t
      = 27 * (lam ^ 3 - 1) * (s ^ 4 - 2 * s * t ^ 3 + 2 * s + 3 * lam * t ^ 2) := by
  simp only [ambientCoeffU, A, B, C, D, E, F, H, I, K,
    UniversalResidual.residualCoeffU, UniversalResidual.residualCoeffW]
  ring

/-- Second ambient coefficient of the residual line of a Hesse cubic on `W = sU+tV`. -/
theorem residualCoeffV_sub_tmul_residualCoeffW (lam s t : R) :
    ambientCoeffV lam s t
      = 27 * (lam ^ 3 - 1) * (t ^ 4 - 2 * s ^ 3 * t + 2 * t + 3 * lam * s ^ 2) := by
  simp only [ambientCoeffV, A, B, C, D, E, F, H, J, K,
    UniversalResidual.residualCoeffV, UniversalResidual.residualCoeffW]
  ring

/-- Third ambient coefficient of the residual line of a Hesse cubic on `W = sU+tV`. -/
theorem residualCoeffW_eq (lam s t : R) :
    ambientCoeffW lam s t
      = 27 * (lam ^ 3 - 1) * (1 + 2 * s ^ 3 + 2 * t ^ 3 + 3 * lam * s ^ 2 * t ^ 2) := by
  simp only [ambientCoeffW, A, B, C, D, E, F, H, K,
    UniversalResidual.residualCoeffW]
  ring

/-- The coordinate line `W = 0` is fixed by the Hesse residual-line map. -/
theorem coordinateLine_fixed (lam : R) :
    ambientCoeffU lam 0 0 = 0 ∧ ambientCoeffV lam 0 0 = 0 := by
  rw [residualCoeffU_sub_smul_residualCoeffW, residualCoeffV_sub_tmul_residualCoeffW]
  constructor <;> ring

/-- The nine affine Hesse-configuration lines are fixed by the residual-line map.

The line `W = sU+tV` has coefficient vector `(-s,-t,1)`.  The displayed equations say that the
residual coefficient vector is proportional to it.  Over a field containing the three cube roots
of `-1`, the two independent choices of `s` and `t` give the nine lines.
-/
theorem cubeRootLines_fixed (lam s t : R) (hs : s ^ 3 = -1) (ht : t ^ 3 = -1) :
    ambientCoeffU lam s t + s * ambientCoeffW lam s t = 0 ∧
      ambientCoeffV lam s t + t * ambientCoeffW lam s t = 0 := by
  have hu :
      (s ^ 4 - 2 * s * t ^ 3 + 2 * s + 3 * lam * t ^ 2) +
          s * (1 + 2 * s ^ 3 + 2 * t ^ 3 + 3 * lam * s ^ 2 * t ^ 2) = 0 := by
    calc
      _ = 3 * (s ^ 3 + 1) * (s + lam * t ^ 2) := by ring
      _ = 0 := by rw [hs]; ring
  have hv :
      (t ^ 4 - 2 * s ^ 3 * t + 2 * t + 3 * lam * s ^ 2) +
          t * (1 + 2 * s ^ 3 + 2 * t ^ 3 + 3 * lam * s ^ 2 * t ^ 2) = 0 := by
    calc
      _ = 3 * (t ^ 3 + 1) * (t + lam * s ^ 2) := by ring
      _ = 0 := by rw [ht]; ring
  rw [residualCoeffU_sub_smul_residualCoeffW, residualCoeffV_sub_tmul_residualCoeffW,
    residualCoeffW_eq]
  constructor
  · calc
      _ = 27 * (lam ^ 3 - 1) *
          ((s ^ 4 - 2 * s * t ^ 3 + 2 * s + 3 * lam * t ^ 2) +
            s * (1 + 2 * s ^ 3 + 2 * t ^ 3 + 3 * lam * s ^ 2 * t ^ 2)) := by ring
      _ = 0 := by rw [hu, mul_zero]
  · calc
      _ = 27 * (lam ^ 3 - 1) *
          ((t ^ 4 - 2 * s ^ 3 * t + 2 * t + 3 * lam * s ^ 2) +
            t * (1 + 2 * s ^ 3 + 2 * t ^ 3 + 3 * lam * s ^ 2 * t ^ 2)) := by ring
      _ = 0 := by rw [hv, mul_zero]

end BConicBundleMultisections.HesseResidualCertificate
