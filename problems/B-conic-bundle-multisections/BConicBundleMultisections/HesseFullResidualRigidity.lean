/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.HesseResidualCertificate

/-!
# Full residual-map rigidity in Hesse coordinates

This module kernel-checks the triangular part of the exact Groebner certificate in
`certificates/hesse_full_residual_map_certificate.py`.  The 45 `recoveryCoeff` expressions
are the coefficients, in lexicographic order, of the three universal affine residual
quartics minus `rho` times the normalized Hesse quartics.  The three reconstruction lemmas
tie those explicit expressions back to `UniversalResidual` by `ring`.

If all 45 coefficients vanish and `rho` is nonzero, the proof-producing Groebner identities
show that the general cubic is a scalar multiple of the fixed Hesse cubic.  Every identity
is replayed by Lean `linear_combination`; the external computation is not trusted by Lean.
-/

@[expose] public section

namespace BConicBundleMultisections.HesseFullResidualRigidity

universe u

variable {R : Type u} [CommRing R]

set_option linter.unusedVariables false

abbrev transportedA (a e i k s : R) := a + e*s + i*s^2 + k*s^3
abbrev transportedB (b e f i j k s t : R) :=
  b + e*t + f*s + 2*i*s*t + j*s^2 + 3*k*s^2*t
abbrev transportedC (c f h i j k s t : R) :=
  c + f*t + h*s + i*t^2 + 2*j*s*t + 3*k*s*t^2
abbrev transportedD (d h j k t : R) := d + h*t + j*t^2 + k*t^3
abbrev transportedE (e i k s : R) := e + 2*i*s + 3*k*s^2
abbrev transportedF (f i j k s t : R) := f + 2*i*t + 2*j*s + 6*k*s*t
abbrev transportedH (h j k t : R) := h + 2*j*t + 3*k*t^2
abbrev transportedI (i k s : R) := i + 3*k*s
abbrev transportedJ (j k t : R) := j + 3*k*t

abbrev ambientCoeffU (a b c d e f h i j k s t : R) :=
  UniversalResidual.residualCoeffU
      (transportedA a e i k s) (transportedB b e f i j k s t)
      (transportedC c f h i j k s t) (transportedD d h j k t)
      (transportedE e i k s) (transportedF f i j k s t)
      (transportedH h j k t) (transportedI i k s)
    - s * UniversalResidual.residualCoeffW
      (transportedA a e i k s) (transportedB b e f i j k s t)
      (transportedC c f h i j k s t) (transportedD d h j k t)
      (transportedE e i k s) (transportedF f i j k s t)
      (transportedH h j k t) k

abbrev ambientCoeffV (a b c d e f h i j k s t : R) :=
  UniversalResidual.residualCoeffV
      (transportedA a e i k s) (transportedB b e f i j k s t)
      (transportedC c f h i j k s t) (transportedD d h j k t)
      (transportedE e i k s) (transportedF f i j k s t)
      (transportedH h j k t) (transportedJ j k t)
    - t * UniversalResidual.residualCoeffW
      (transportedA a e i k s) (transportedB b e f i j k s t)
      (transportedC c f h i j k s t) (transportedD d h j k t)
      (transportedE e i k s) (transportedF f i j k s t)
      (transportedH h j k t) k

abbrev ambientCoeffW (a b c d e f h i j k s t : R) :=
  UniversalResidual.residualCoeffW
    (transportedA a e i k s) (transportedB b e f i j k s t)
    (transportedC c f h i j k s t) (transportedD d h j k t)
    (transportedE e i k s) (transportedF f i j k s t)
    (transportedH h j k t) k

abbrev hesseQuarticU (lam s t : R) := s^4 - 2*s*t^3 + 2*s + 3*lam*t^2
abbrev hesseQuarticV (lam s t : R) := t^4 - 2*s^3*t + 2*t + 3*lam*s^2
abbrev hesseQuarticW (lam s t : R) := 1 + 2*s^3 + 2*t^3 + 3*lam*s^2*t^2

abbrev recoveryCoeff0 (a b c d e f h i j k lam rho : R) : R :=
  -27*a*d^2*k^2 + 18*a*d*h*j*k - 4*a*d*j^3 - 4*a*h^3*k + a*h^2*j^2 + c^3*k^2 - c^2*f*j*k - 2*c^2*h*i*k + c^2*i*j^2 + 3*c*d*f*i*k - 2*c*d*i^2*j + c*f^2*h*k - c*f*h*i*j + c*h^2*i^2 + d^2*i^3 - d*f^3*k + d*f^2*i*j - d*f*h*i^2 - rho

abbrev recoveryCoeff1 (a b c d e f h i j k lam rho : R) : R :=
  54*a*c*d*k^2 - 18*a*c*h*j*k + 4*a*c*j^3 - 18*a*d*f*j*k - 18*a*d*h*i*k + 12*a*d*i*j^2 + 12*a*f*h^2*k - 2*a*f*h*j^2 - 2*a*h^2*i*j - 6*b*c^2*k^2 + 4*b*c*f*j*k + 8*b*c*h*i*k - 4*b*c*i*j^2 - 6*b*d*f*i*k + 4*b*d*i^2*j - 2*b*f^2*h*k + 2*b*f*h*i*j - 2*b*h^2*i^2 + 2*c^2*e*j*k - 6*c*d*e*i*k - 4*c*e*f*h*k + 2*c*e*h*i*j + 6*d*e*f^2*k - 4*d*e*f*i*j + 2*d*e*h*i^2

abbrev recoveryCoeff2 (a b c d e f h i j k lam rho : R) : R :=
  18*a*c*d*j*k - 12*a*c*h^2*k + 2*a*c*h*j^2 - 54*a*d^2*i*k + 18*a*d*f*h*k - 12*a*d*f*j^2 + 18*a*d*h*i*j + 2*a*f*h^2*j - 4*a*h^3*i - 2*b*c^2*j*k + 6*b*c*d*i*k + 4*b*c*f*h*k - 2*b*c*h*i*j - 6*b*d*f^2*k + 4*b*d*f*i*j - 2*b*d*h*i^2 - 4*c^2*e*h*k + 2*c^2*e*j^2 + 6*c*d*e*f*k - 8*c*d*e*i*j - 2*c*e*f*h*j + 4*c*e*h^2*i + 6*d^2*e*i^2 + 2*d*e*f^2*j - 4*d*e*f*h*i

abbrev recoveryCoeff3 (a b c d e f h i j k lam rho : R) : R :=
  -54*a*b*d*k^2 + 18*a*b*h*j*k - 4*a*b*j^3 - 18*a*c^2*k^2 + 12*a*c*f*j*k + 6*a*c*h*i*k - 6*a*c*i*j^2 + 18*a*d*e*j*k + 27*a*d*f*i*k - 18*a*d*i^2*j - 12*a*e*h^2*k + 2*a*e*h*j^2 - 9*a*f^2*h*k + a*f^2*j^2 + a*f*h*i*j + 4*a*h^2*i^2 + 12*b^2*c*k^2 - 4*b^2*f*j*k - 8*b^2*h*i*k + 4*b^2*i*j^2 - 8*b*c*e*j*k - 3*b*c*f*i*k + 2*b*c*i^2*j + 12*b*d*e*i*k - 2*b*d*i^3 + 8*b*e*f*h*k - 4*b*e*h*i*j + b*f^3*k - b*f^2*i*j + b*f*h*i^2 + 2*c^2*e*i*k + 4*c*e^2*h*k - c*e*f^2*k + c*e*f*i*j - 2*c*e*h*i^2 - 12*d*e^2*f*k + 4*d*e^2*i*j + d*e*f*i^2

abbrev recoveryCoeff4 (a b c d e f h i j k lam rho : R) : R :=
  -36*a*b*d*j*k + 24*a*b*h^2*k - 4*a*b*h*j^2 - 12*a*c^2*j*k + 72*a*c*d*i*k - 6*a*c*f*h*k + 10*a*c*f*j^2 - 16*a*c*h*i*j - 36*a*d*e*h*k + 24*a*d*e*j^2 - 6*a*d*f*i*j - 12*a*d*h*i^2 - 4*a*e*h^2*j - 4*a*f^2*h*j + 10*a*f*h^2*i + 8*b^2*c*j*k - 12*b^2*d*i*k - 8*b^2*f*h*k + 4*b^2*h*i*j - 4*b*c^2*i*k + 8*b*c*e*h*k - 8*b*c*e*j^2 + 2*b*c*f^2*k - 2*b*c*f*i*j + 4*b*c*h*i^2 + 12*b*d*e*f*k + 8*b*d*e*i*j - 2*b*d*f*i^2 + 4*b*e*f*h*j - 8*b*e*h^2*i - 2*c^2*e*f*k + 4*c^2*e*i*j - 12*c*d*e^2*k - 4*c*d*e*i^2 + 4*c*e^2*h*j - 2*c*e*f*h*i - 8*d*e^2*f*j + 8*d*e^2*h*i + 2*d*e*f^2*i

abbrev recoveryCoeff5 (a b c d e f h i j k lam rho : R) : R :=
  18*a*b*d*h*k - 12*a*b*d*j^2 + 2*a*b*h^2*j - 18*a*c^2*h*k + 4*a*c^2*j^2 + 27*a*c*d*f*k + 6*a*c*d*i*j + a*c*f*h*j - 6*a*c*h^2*i - 54*a*d^2*e*k - 18*a*d^2*i^2 + 18*a*d*e*h*j - 9*a*d*f^2*j + 12*a*d*f*h*i - 4*a*e*h^3 + a*f^2*h^2 + 4*b^2*c*h*k - 12*b^2*d*f*k + 4*b^2*d*i*j + b*c^2*f*k - 2*b*c^2*i*j + 12*b*c*d*e*k + 2*b*c*d*i^2 - 4*b*c*e*h*j + b*c*f*h*i + 8*b*d*e*f*j - 8*b*d*e*h*i - b*d*f^2*i - 2*c^3*e*k + c^2*e*f*j + 2*c^2*e*h*i - 8*c*d*e^2*j - 3*c*d*e*f*i + 4*c*e^2*h^2 - c*e*f^2*h + 12*d^2*e^2*i - 4*d*e^2*f*h + d*e*f^3

abbrev recoveryCoeff6 (a b c d e f h i j k lam rho : R) : R :=
  54*a^2*d*k^2 - 18*a^2*h*j*k + 4*a^2*j^3 + 18*a*b*c*k^2 - 6*a*b*f*j*k + 6*a*b*h*i*k - 6*a*c*e*j*k - 12*a*c*f*i*k + 8*a*c*i^2*j - 36*a*d*e*i*k + 8*a*d*i^3 + 12*a*e*f*h*k - 2*a*e*f*j^2 + 2*a*e*h*i*j + 2*a*f^3*k - 4*a*f*h*i^2 - 8*b^3*k^2 + 8*b^2*e*j*k + 6*b^2*f*i*k - 4*b^2*i^2*j - 2*b*c*e*i*k - 8*b*e^2*h*k - 4*b*e*f^2*k + 2*b*e*f*i*j + 2*b*e*h*i^2 + 4*c*e^2*f*k - 2*c*e^2*i*j + 8*d*e^3*k - 2*d*e^2*i^2 + 2*rho

abbrev recoveryCoeff7 (a b c d e f h i j k lam rho : R) : R :=
  54*a^2*d*j*k - 36*a^2*h^2*k + 6*a^2*h*j^2 + 18*a*b*c*j*k - 18*a*b*d*i*k + 6*a*b*f*h*k - 8*a*b*f*j^2 + 8*a*b*h*i*j - 24*a*c^2*i*k + 12*a*c*e*h*k - 10*a*c*e*j^2 + 4*a*c*f*i*j + 8*a*c*h*i^2 - 30*a*d*e*i*j + 12*a*d*f*i^2 + 6*a*e*f*h*j + 4*a*e*h^2*i + 2*a*f^3*j - 8*a*f^2*h*i - 8*b^3*j*k + 10*b^2*c*i*k + 8*b^2*e*j^2 + 2*b^2*f^2*k - 6*b^2*h*i^2 - 10*b*c*e*f*k - 2*b*c*e*i*j + 2*b*d*e*i^2 - 8*b*e^2*h*j - 2*b*e*f^2*j + 8*b*e*f*h*i + 8*c^2*e^2*k + 2*c*e^2*f*j - 4*c*e^2*h*i + 8*d*e^3*j - 4*d*e^2*f*i

abbrev recoveryCoeff8 (a b c d e f h i j k lam rho : R) : R :=
  -54*a^2*d*h*k + 36*a^2*d*j^2 - 6*a^2*h^2*j + 30*a*b*c*h*k - 4*a*b*c*j^2 - 12*a*b*d*i*j - 6*a*b*f*h*j + 10*a*b*h^2*i - 12*a*c^2*f*k - 8*a*c^2*i*j + 18*a*c*d*e*k + 24*a*c*d*i^2 - 8*a*c*e*h*j + 8*a*c*f^2*j - 4*a*c*f*h*i - 6*a*d*e*f*j - 18*a*d*e*h*i + 8*a*e*f*h^2 - 2*a*f^3*h - 8*b^3*h*k + 4*b^2*c*f*k + 4*b^2*c*i*j - 8*b^2*d*i^2 + 8*b^2*e*h*j - 2*b^2*f*h*i - 2*b*c^2*e*k - 8*b*c*e*f*j + 2*b*c*e*h*i + 10*b*d*e*f*i - 8*b*e^2*h^2 + 2*b*e*f^2*h + 6*c^2*e^2*j - 10*c*d*e^2*i + 8*d*e^3*h - 2*d*e^2*f^2

abbrev recoveryCoeff9 (a b c d e f h i j k lam rho : R) : R :=
  -54*a^2*d^2*k + 18*a^2*d*h*j - 4*a^2*h^3 + 36*a*b*c*d*k - 2*a*b*c*h*j - 12*a*b*d*f*j + 6*a*b*d*h*i + 2*a*b*f*h^2 - 8*a*c^3*k + 4*a*c^2*f*j - 8*a*c^2*h*i - 6*a*c*d*e*j + 12*a*c*d*f*i - 18*a*d^2*e*i + 6*a*d*e*f*h - 2*a*d*f^3 - 8*b^3*d*k + 2*b^2*c^2*k + 2*b^2*c*h*i + 8*b^2*d*e*j - 4*b^2*d*f*i - 2*b*c^2*e*j + 2*b*c*d*e*i - 2*b*c*e*f*h - 8*b*d*e^2*h + 4*b*d*e*f^2 + 4*c^2*e^2*h - 6*c*d*e^2*f + 8*d^2*e^3 - 2*rho

abbrev recoveryCoeff10 (a b c d e f h i j k lam rho : R) : R :=
  -27*a^2*c*k^2 + 9*a^2*f*j*k - 3*a^2*i*j^2 + 9*a*b^2*k^2 - 6*a*b*e*j*k - 3*a*b*f*i*k + 2*a*b*i^2*j + 18*a*c*e*i*k - 4*a*c*i^3 + a*e^2*j^2 - 3*a*e*f^2*k - a*e*f*i*j + a*f^2*i^2 - 4*b^2*e*i*k + b^2*i^3 + 4*b*e^2*f*k - b*e*f*i^2 - 4*c*e^3*k + c*e^2*i^2

abbrev recoveryCoeff11 (a b c d e f h i j k lam rho : R) : R :=
  -36*a^2*c*j*k + 18*a^2*f*h*k + 6*a^2*f*j^2 - 12*a^2*h*i*j + 12*a*b^2*j*k + 12*a*b*c*i*k - 12*a*b*e*h*k - 4*a*b*e*j^2 - 6*a*b*f^2*k + 4*a*b*h*i^2 + 6*a*c*e*f*k + 16*a*c*e*i*j - 8*a*c*f*i^2 + 4*a*e^2*h*j - 4*a*e*f^2*j - 2*a*e*f*h*i + 2*a*f^3*i - 4*b^3*i*k + 4*b^2*e*f*k - 4*b^2*e*i*j + 2*b^2*f*i^2 - 4*b*c*e^2*k + 4*b*e^2*f*j - 2*b*e*f^2*i - 4*c*e^3*j + 2*c*e^2*f*i

abbrev recoveryCoeff12 (a b c d e f h i j k lam rho : R) : R :=
  -18*a^2*c*h*k - 12*a^2*c*j^2 + 27*a^2*d*f*k - 18*a^2*d*i*j + 15*a^2*f*h*j - 12*a^2*h^2*i + 6*a*b^2*h*k + 4*a*b^2*j^2 - 3*a*b*c*f*k + 14*a*b*c*i*j - 18*a*b*d*e*k + 6*a*b*d*i^2 - 10*a*b*e*h*j - 5*a*b*f^2*j + 3*a*b*f*h*i + 6*a*c^2*e*k - 8*a*c^2*i^2 + 3*a*c*e*f*j + 14*a*c*e*h*i - 2*a*c*f^2*i + 6*a*d*e^2*j - 3*a*d*e*f*i + 4*a*e^2*h^2 - 5*a*e*f^2*h + a*f^4 - 4*b^3*i*j + 2*b^2*c*i^2 + 4*b^2*e*f*j - 4*b^2*e*h*i + b^2*f^2*i - 4*b*c*e^2*j - 2*b*c*e*f*i + 4*b*e^2*f*h - b*e*f^3 + 2*c^2*e^2*i - 4*c*e^3*h + c*e^2*f^2 - 3*lam*rho

abbrev recoveryCoeff13 (a b c d e f h i j k lam rho : R) : R :=
  -12*a^2*c*h*j + 18*a^2*d*f*j - 36*a^2*d*h*i + 6*a^2*f*h^2 + 4*a*b^2*h*j - 2*a*b*c*f*j + 16*a*b*c*h*i - 12*a*b*d*e*j + 6*a*b*d*f*i - 4*a*b*e*h^2 - 4*a*b*f^2*h + 4*a*c^2*e*j - 8*a*c^2*f*i + 12*a*c*d*e*i + 2*a*c*f^3 + 12*a*d*e^2*h - 6*a*d*e*f^2 - 4*b^3*h*i + 2*b^2*c*f*i - 4*b^2*d*e*i + 4*b^2*e*f*h - 4*b*c*e^2*h - 2*b*c*e*f^2 + 4*b*d*e^2*f + 2*c^2*e^2*f - 4*c*d*e^3

abbrev recoveryCoeff14 (a b c d e f h i j k lam rho : R) : R :=
  -3*a^2*c*h^2 - 27*a^2*d^2*i + 9*a^2*d*f*h + a*b^2*h^2 + 18*a*b*c*d*i - a*b*c*f*h - 6*a*b*d*e*h - 3*a*b*d*f^2 - 4*a*c^3*i + 2*a*c^2*e*h + a*c^2*f^2 - 3*a*c*d*e*f + 9*a*d^2*e^2 - 4*b^3*d*i + b^2*c^2*i + 4*b^2*d*e*f - b*c^2*e*f - 4*b*c*d*e^2 + c^3*e^2

abbrev recoveryCoeff15 (a b c d e f h i j k lam rho : R) : R :=
  -27*b*d^2*k^2 + 18*b*d*h*j*k - 4*b*d*j^3 - 4*b*h^3*k + b*h^2*j^2 + 9*c^2*d*k^2 - 4*c^2*h*j*k + c^2*j^3 - 3*c*d*f*j*k - 6*c*d*h*i*k + 2*c*d*i*j^2 + 4*c*f*h^2*k - c*f*h*j^2 + 9*d^2*f*i*k - 3*d^2*i^2*j - 3*d*f^2*h*k + d*f^2*j^2 - d*f*h*i*j + d*h^2*i^2

abbrev recoveryCoeff16 (a b c d e f h i j k lam rho : R) : R :=
  54*a*d^2*k^2 - 36*a*d*h*j*k + 8*a*d*j^3 + 8*a*h^3*k - 2*a*h^2*j^2 + 18*b*c*d*k^2 - 2*b*c*h*j*k - 12*b*d*f*j*k - 6*b*d*h*i*k + 8*b*d*i*j^2 + 4*b*f*h^2*k - 2*b*h^2*i*j - 8*c^3*k^2 + 6*c^2*f*j*k + 8*c^2*h*i*k - 4*c^2*i*j^2 + 6*c*d*e*j*k - 6*c*d*f*i*k - 8*c*e*h^2*k + 2*c*e*h*j^2 - 4*c*f^2*h*k + 2*c*f*h*i*j - 18*d^2*e*i*k + 4*d^2*i^3 + 12*d*e*f*h*k - 4*d*e*f*j^2 + 2*d*e*h*i*j + 2*d*f^3*k - 2*d*f*h*i^2 + 2*rho

abbrev recoveryCoeff17 (a b c d e f h i j k lam rho : R) : R :=
  12*b*c*d*j*k - 4*b*c*h^2*k - 36*b*d^2*i*k + 6*b*d*f*h*k - 8*b*d*f*j^2 + 16*b*d*h*i*j + 2*b*f*h^2*j - 4*b*h^3*i - 4*c^3*j*k + 12*c^2*d*i*k + 4*c^2*f*h*k + 2*c^2*f*j^2 - 4*c^2*h*i*j - 12*c*d*e*h*k + 4*c*d*e*j^2 - 6*c*d*f^2*k - 4*c*d*h*i^2 - 2*c*f^2*h*j + 4*c*f*h^2*i + 18*d^2*e*f*k - 12*d^2*e*i*j + 6*d^2*f*i^2 - 2*d*e*f*h*j + 4*d*e*h^2*i + 2*d*f^3*j - 4*d*f^2*h*i

abbrev recoveryCoeff18 (a b c d e f h i j k lam rho : R) : R :=
  -54*a*c*d*k^2 + 12*a*c*h*j*k - 2*a*c*j^3 + 27*a*d*f*j*k + 18*a*d*h*i*k - 18*a*d*i*j^2 - 12*a*f*h^2*k + a*f*h*j^2 + 4*a*h^2*i*j - 18*b^2*d*k^2 + 2*b^2*h*j*k + 12*b*c^2*k^2 - 3*b*c*f*j*k - 8*b*c*h*i*k + 2*b*c*i*j^2 + 6*b*d*e*j*k + 12*b*d*f*i*k - 6*b*d*i^2*j + 4*b*e*h^2*k - 2*b*e*h*j^2 - b*f^2*h*k + b*f*h*i*j - 8*c^2*e*j*k - 4*c^2*f*i*k + 4*c^2*i^2*j + 18*c*d*e*i*k - 4*c*d*i^3 + 8*c*e*f*h*k + c*e*f*j^2 - 4*c*e*h*i*j + c*f^3*k - c*f^2*i*j - 12*d*e^2*h*k + 4*d*e^2*j^2 - 9*d*e*f^2*k + d*e*f*i*j + 2*d*e*h*i^2 + d*f^2*i^2

abbrev recoveryCoeff19 (a b c d e f h i j k lam rho : R) : R :=
  -18*a*c*d*j*k + 2*a*c*h*j^2 + 54*a*d^2*i*k + 12*a*d*f*j^2 - 30*a*d*h*i*j - 4*a*f*h^2*j + 8*a*h^3*i - 24*b^2*d*j*k + 8*b^2*h^2*k + 10*b*c^2*j*k + 18*b*c*d*i*k - 10*b*c*f*h*k - 2*b*c*h*i*j + 12*b*d*e*h*k + 8*b*d*e*j^2 + 4*b*d*f*i*j - 10*b*d*h*i^2 - 4*b*e*h^2*j + 2*b*f*h^2*i - 8*c^3*i*k - 6*c^2*e*j^2 + 2*c^2*f^2*k + 8*c^2*h*i^2 + 6*c*d*e*f*k + 8*c*d*e*i*j - 8*c*d*f*i^2 + 8*c*e*f*h*j - 8*c*e*h^2*i - 2*c*f^2*h*i - 36*d^2*e^2*k + 6*d^2*e*i^2 + 4*d*e^2*h*j - 8*d*e*f^2*j + 6*d*e*f*h*i + 2*d*f^3*i

abbrev recoveryCoeff20 (a b c d e f h i j k lam rho : R) : R :=
  -18*a*c*d*h*k + 6*a*c*d*j^2 + 27*a*d^2*f*k - 18*a*d^2*i*j - 3*a*d*f*h*j + 6*a*d*h^2*i + 6*b^2*d*h*k - 8*b^2*d*j^2 + 2*b^2*h^2*j + 2*b*c^2*j^2 - 3*b*c*d*f*k + 14*b*c*d*i*j - 2*b*c*f*h*j - 4*b*c*h^2*i - 18*b*d^2*e*k - 12*b*d^2*i^2 + 14*b*d*e*h*j - 2*b*d*f^2*j + 3*b*d*f*h*i - 4*b*e*h^3 + b*f^2*h^2 - 4*c^3*i*j + 6*c^2*d*e*k + 4*c^2*d*i^2 - 4*c^2*e*h*j + c^2*f^2*j + 4*c^2*f*h*i + 3*c*d*e*f*j - 10*c*d*e*h*i - 5*c*d*f^2*i + 4*c*e*f*h^2 - c*f^3*h - 12*d^2*e^2*j + 15*d^2*e*f*i + 4*d*e^2*h^2 - 5*d*e*f^2*h + d*f^4 - 3*lam*rho

abbrev recoveryCoeff21 (a b c d e f h i j k lam rho : R) : R :=
  54*a*b*d*k^2 - 6*a*b*h*j*k - 6*a*c*f*j*k + 4*a*c*i*j^2 - 18*a*d*e*j*k - 18*a*d*f*i*k + 12*a*d*i^2*j + 2*a*e*h*j^2 + 6*a*f^2*h*k - 4*a*f*h*i*j - 6*b^2*c*k^2 + 2*b^2*h*i*k + 8*b*c*e*j*k + 4*b*c*f*i*k - 4*b*c*i^2*j - 18*b*d*e*i*k + 4*b*d*i^3 - 4*b*e*f*h*k + 2*b*e*h*i*j - 2*c*e^2*j^2 - 2*c*e*f^2*k + 2*c*e*f*i*j + 12*d*e^2*f*k - 2*d*e^2*i*j - 2*d*e*f*i^2

abbrev recoveryCoeff22 (a b c d e f h i j k lam rho : R) : R :=
  72*a*b*d*j*k - 12*a*b*h^2*k - 4*a*b*h*j^2 - 12*a*c^2*j*k - 36*a*c*d*i*k + 12*a*c*f*h*k - 2*a*c*f*j^2 + 8*a*c*h*i*j - 36*a*d*e*h*k - 12*a*d*e*j^2 - 6*a*d*f*i*j + 24*a*d*h*i^2 + 8*a*e*h^2*j + 2*a*f^2*h*j - 8*a*f*h^2*i - 4*b^2*c*j*k - 12*b^2*d*i*k - 2*b^2*f*h*k + 4*b^2*h*i*j + 8*b*c^2*i*k + 8*b*c*e*h*k + 4*b*c*e*j^2 + 2*b*c*f^2*k - 2*b*c*f*i*j - 8*b*c*h*i^2 - 6*b*d*e*f*k - 16*b*d*e*i*j + 10*b*d*f*i^2 - 2*b*e*f*h*j + 4*b*e*h^2*i - 8*c^2*e*f*k + 4*c^2*e*i*j + 24*c*d*e^2*k - 4*c*d*e*i^2 - 8*c*e^2*h*j + 4*c*e*f*h*i + 10*d*e^2*f*j - 4*d*e^2*h*i - 4*d*e*f^2*i

abbrev recoveryCoeff23 (a b c d e f h i j k lam rho : R) : R :=
  18*a*b*d*h*k + 24*a*b*d*j^2 - 10*a*b*h^2*j - 8*a*c^2*j^2 - 12*a*c*d*i*j + 10*a*c*f*h*j - 54*a*d^2*e*k + 36*a*d^2*i^2 - 18*a*d*e*h*j - 6*a*d*f*h*i + 8*a*e*h^3 - 2*a*f^2*h^2 - 2*b^2*c*h*k - 12*b^2*d*f*k - 8*b^2*d*i*j + 6*b^2*h^2*i + 4*b*c^2*f*k + 4*b*c^2*i*j + 30*b*c*d*e*k - 4*b*c*d*i^2 + 2*b*c*e*h*j - 8*b*c*f*h*i - 4*b*d*e*f*j - 8*b*d*e*h*i + 8*b*d*f^2*i - 8*c^3*e*k - 2*c^2*e*f*j + 8*c^2*e*h*i + 10*c*d*e^2*j - 6*c*d*e*f*i - 8*c*e^2*h^2 + 2*c*e*f^2*h - 6*d^2*e^2*i + 8*d*e^2*f*h - 2*d*e*f^3

abbrev recoveryCoeff24 (a b c d e f h i j k lam rho : R) : R :=
  12*a*b*d*h*j - 4*a*b*h^3 - 4*a*c^2*h*j + 6*a*c*d*f*j - 12*a*c*d*h*i + 4*a*c*f*h^2 - 36*a*d^2*e*j + 18*a*d^2*f*i + 12*a*d*e*h^2 - 6*a*d*f^2*h - 8*b^2*d*f*j + 4*b^2*d*h*i + 2*b^2*f*h^2 + 2*b*c^2*f*j + 16*b*c*d*e*j - 2*b*c*d*f*i - 4*b*c*e*h^2 - 2*b*c*f^2*h - 12*b*d^2*e*i + 2*b*d*f^3 - 4*c^3*e*j + 4*c^2*d*e*i + 4*c^2*e*f*h - 4*c*d*e^2*h - 4*c*d*e*f^2 + 6*d^2*e^2*f

abbrev recoveryCoeff25 (a b c d e f h i j k lam rho : R) : R :=
  -27*a^2*d*k^2 + a^2*j^3 + 3*a*b*f*j*k - 2*a*b*i*j^2 + 18*a*d*e*i*k - 4*a*d*i^3 - a*e*f*j^2 - a*f^3*k + a*f^2*i*j + b^3*k^2 - 2*b^2*e*j*k - b^2*f*i*k + b^2*i^2*j + b*e^2*j^2 + b*e*f^2*k - b*e*f*i*j - 4*d*e^3*k + d*e^2*i^2 - rho

abbrev recoveryCoeff26 (a b c d e f h i j k lam rho : R) : R :=
  -54*a^2*d*j*k + 6*a^2*h*j^2 + 6*a*b*c*j*k + 18*a*b*d*i*k + 6*a*b*f*h*k - 8*a*b*h*i*j - 2*a*c*e*j^2 - 6*a*c*f^2*k + 4*a*c*f*i*j + 18*a*d*e*f*k + 18*a*d*e*i*j - 12*a*d*f*i^2 - 4*a*e*f*h*j + 2*a*f^2*h*i - 2*b^2*c*i*k - 4*b^2*e*h*k + 2*b^2*h*i^2 + 4*b*c*e*f*k - 2*b*c*e*i*j - 12*b*d*e^2*k + 2*b*d*e*i^2 + 4*b*e^2*h*j - 2*b*e*f*h*i - 4*d*e^3*j + 2*d*e^2*f*i

abbrev recoveryCoeff27 (a b c d e f h i j k lam rho : R) : R :=
  -54*a^2*d*h*k - 18*a^2*d*j^2 + 12*a^2*h^2*j + 12*a*b*c*h*k + 2*a*b*c*j^2 + 27*a*b*d*f*k + 6*a*b*d*i*j - 3*a*b*f*h*j - 8*a*b*h^2*i - 12*a*c^2*f*k + 4*a*c^2*i*j + 18*a*c*d*e*k - 12*a*c*d*i^2 - 8*a*c*e*h*j - a*c*f^2*j + 8*a*c*f*h*i + 12*a*d*e*f*j + 18*a*d*e*h*i - 9*a*d*f^2*i - 4*a*e*f*h^2 + a*f^3*h - 2*b^3*h*k + b^2*c*f*k - 2*b^2*c*i*j - 18*b^2*d*e*k + 4*b^2*d*i^2 + 2*b^2*e*h*j + b^2*f*h*i + 4*b*c^2*e*k + b*c*e*f*j - 4*b*c*e*h*i - 6*b*d*e^2*j + b*d*e*f*i + 4*b*e^2*h^2 - b*e*f^2*h + 2*c*d*e^2*i - 4*d*e^3*h + d*e^2*f^2

abbrev recoveryCoeff28 (a b c d e f h i j k lam rho : R) : R :=
  -54*a^2*d^2*k - 18*a^2*d*h*j + 8*a^2*h^3 + 36*a*b*c*d*k + 2*a*b*c*h*j + 12*a*b*d*f*j - 6*a*b*d*h*i - 6*a*b*f*h^2 - 8*a*c^3*k - 4*a*c^2*f*j + 8*a*c^2*h*i + 6*a*c*d*e*j - 12*a*c*d*f*i - 8*a*c*e*h^2 + 4*a*c*f^2*h + 18*a*d^2*e*i + 6*a*d*e*f*h - 2*a*d*f^3 - 8*b^3*d*k + 2*b^2*c^2*k - 2*b^2*c*h*i - 8*b^2*d*e*j + 4*b^2*d*f*i + 4*b^2*e*h^2 + 2*b*c^2*e*j - 2*b*c*d*e*i - 2*b*c*e*f*h + 2*c*d*e^2*f - 4*d^2*e^3 - 2*rho

abbrev recoveryCoeff29 (a b c d e f h i j k lam rho : R) : R :=
  -27*a^2*d^2*j + 9*a^2*d*h^2 + 18*a*b*c*d*j - 4*a*b*c*h^2 - 3*a*b*d*f*h - 4*a*c^3*j + 4*a*c^2*f*h - 6*a*c*d*e*h - 3*a*c*d*f^2 + 9*a*d^2*e*f - 4*b^3*d*j + b^3*h^2 + b^2*c^2*j - b^2*c*f*h + 2*b^2*d*e*h + b^2*d*f^2 - b*c*d*e*f - 3*b*d^2*e^2 + c^2*d*e^2

abbrev recoveryCoeff30 (a b c d e f h i j k lam rho : R) : R :=
  -3*c^2*h*k^2 + c^2*j^2*k + 9*c*d*f*k^2 - 6*c*d*i*j*k - c*f*h*j*k + 2*c*h^2*i*k - 27*d^2*e*k^2 + 9*d^2*i^2*k + 18*d*e*h*j*k - 4*d*e*j^3 - 3*d*f^2*j*k - 3*d*f*h*i*k + 4*d*f*i*j^2 - 4*d*h*i^2*j - 4*e*h^3*k + e*h^2*j^2 + f^2*h^2*k - f*h^2*i*j + h^3*i^2

abbrev recoveryCoeff31 (a b c d e f h i j k lam rho : R) : R :=
  12*b*c*h*k^2 - 4*b*c*j^2*k - 18*b*d*f*k^2 + 12*b*d*i*j*k + 2*b*f*h*j*k - 4*b*h^2*i*k - 6*c^2*f*k^2 + 4*c^2*i*j*k + 36*c*d*e*k^2 - 12*c*d*i^2*k - 16*c*e*h*j*k + 4*c*e*j^3 + 4*c*f^2*j*k - 4*c*f*i*j^2 + 4*c*h*i^2*j - 6*d*e*f*j*k - 12*d*e*h*i*k + 4*d*e*i*j^2 + 6*d*f^2*i*k - 4*d*f*i^2*j + 4*d*h*i^3 + 8*e*f*h^2*k - 2*e*f*h*j^2 - 2*f^3*h*k + 2*f^2*h*i*j - 2*f*h^2*i^2

abbrev recoveryCoeff32 (a b c d e f h i j k lam rho : R) : R :=
  -54*a*d^2*k^2 + 36*a*d*h*j*k - 8*a*d*j^3 - 8*a*h^3*k + 2*a*h^2*j^2 + 18*b*c*d*k^2 - 2*b*c*h*j*k - 12*b*d*f*j*k - 6*b*d*h*i*k + 8*b*d*i*j^2 + 4*b*f*h^2*k - 2*b*h^2*i*j - 4*c^3*k^2 + 2*c^2*f*j*k + 6*c*d*e*j*k + 6*c*d*f*i*k - 8*c*d*i^2*j - 8*c*e*h^2*k + 2*c*e*h*j^2 - 2*c*f*h*i*j + 4*c*h^2*i^2 - 18*d^2*e*i*k + 8*d^2*i^3 + 12*d*e*f*h*k - 4*d*e*f*j^2 + 2*d*e*h*i*j - 2*d*f^3*k + 4*d*f^2*i*j - 6*d*f*h*i^2 - 2*rho

abbrev recoveryCoeff33 (a b c d e f h i j k lam rho : R) : R :=
  -18*a*c*h*k^2 + 6*a*c*j^2*k + 27*a*d*f*k^2 - 18*a*d*i*j*k - 3*a*f*h*j*k + 6*a*h^2*i*k - 12*b^2*h*k^2 + 4*b^2*j^2*k + 15*b*c*f*k^2 - 10*b*c*i*j*k - 18*b*d*e*k^2 + 6*b*d*i^2*k + 14*b*e*h*j*k - 4*b*e*j^3 - 5*b*f^2*j*k + 3*b*f*h*i*k + 4*b*f*i*j^2 - 4*b*h*i^2*j - 12*c^2*e*k^2 + 4*c^2*i^2*k + 3*c*e*f*j*k + 14*c*e*h*i*k - 4*c*e*i*j^2 - 5*c*f^2*i*k + 4*c*f*i^2*j - 4*c*h*i^3 + 6*d*e^2*j*k - 3*d*e*f*i*k - 8*e^2*h^2*k + 2*e^2*h*j^2 - 2*e*f^2*h*k + e*f^2*j^2 - 2*e*f*h*i*j + 2*e*h^2*i^2 + f^4*k - f^3*i*j + f^2*h*i^2 - 3*lam*rho

abbrev recoveryCoeff34 (a b c d e f h i j k lam rho : R) : R :=
  54*a*c*d*k^2 - 30*a*c*h*j*k + 8*a*c*j^3 - 18*a*d*h*i*k + 12*a*f*h^2*k - 4*a*f*h*j^2 + 2*a*h^2*i*j - 36*b^2*d*k^2 + 4*b^2*h*j*k + 6*b*c^2*k^2 + 6*b*c*f*j*k + 8*b*c*h*i*k - 8*b*c*i*j^2 + 12*b*d*e*j*k + 6*b*d*f*i*k + 8*b*e*h^2*k - 4*b*e*h*j^2 - 8*b*f^2*h*k + 8*b*f*h*i*j - 6*b*h^2*i^2 - 10*c^2*e*j*k - 8*c^2*f*i*k + 8*c^2*i^2*j + 18*c*d*e*i*k - 8*c*d*i^3 + 4*c*e*f*h*k + 2*c*e*f*j^2 - 2*c*e*h*i*j + 2*c*f^3*k - 2*c*f^2*i*j - 24*d*e^2*h*k + 8*d*e^2*j^2 - 10*d*e*f*i*j + 10*d*e*h*i^2 + 2*d*f^2*i^2

abbrev recoveryCoeff35 (a b c d e f h i j k lam rho : R) : R :=
  18*a*c*d*j*k - 18*a*c*h^2*k + 4*a*c*h*j^2 - 54*a*d^2*i*k + 27*a*d*f*h*k - 12*a*d*f*j^2 + 12*a*d*h*i*j + a*f*h^2*j - 2*a*h^3*i - 12*b^2*d*j*k + 4*b^2*h^2*k + 2*b*c^2*j*k + 18*b*c*d*i*k + b*c*f*h*k - 4*b*c*h*i*j + 6*b*d*e*h*k + 4*b*d*e*j^2 - 9*b*d*f^2*k + 8*b*d*f*i*j - 8*b*d*h*i^2 - 2*b*e*h^2*j + b*f*h^2*i - 4*c^3*i*k - 6*c^2*e*h*k + c^2*f^2*k + 4*c^2*h*i^2 + 12*c*d*e*f*k - 8*c*d*e*i*j - 4*c*d*f*i^2 + c*e*f*h*j + 2*c*e*h^2*i - c*f^2*h*i - 18*d^2*e^2*k + 12*d^2*e*i^2 + 2*d*e^2*h*j - d*e*f^2*j - 3*d*e*f*h*i + d*f^3*i

abbrev recoveryCoeff36 (a b c d e f h i j k lam rho : R) : R :=
  36*a*b*h*k^2 - 12*a*b*j^2*k - 18*a*c*f*k^2 + 12*a*c*i*j*k - 12*a*e*h*j*k + 4*a*e*j^3 + 6*a*f^2*j*k - 6*a*f*h*i*k - 4*a*f*i*j^2 + 4*a*h*i^2*j - 6*b^2*f*k^2 + 4*b^2*i*j*k + 12*b*c*e*k^2 - 4*b*c*i^2*k - 16*b*e*h*i*k + 4*b*e*i*j^2 + 4*b*f^2*i*k - 4*b*f*i^2*j + 4*b*h*i^3 - 4*c*e^2*j*k + 2*c*e*f*i*k + 8*e^2*f*h*k - 2*e^2*f*j^2 - 2*e*f^3*k + 2*e*f^2*i*j - 2*e*f*h*i^2

abbrev recoveryCoeff37 (a b c d e f h i j k lam rho : R) : R :=
  54*a*b*d*k^2 + 18*a*b*h*j*k - 8*a*b*j^3 - 36*a*c^2*k^2 + 6*a*c*f*j*k + 12*a*c*h*i*k - 18*a*d*e*j*k - 24*a*e*h^2*k + 10*a*e*h*j^2 + 2*a*f^2*j^2 - 10*a*f*h*i*j + 8*a*h^2*i^2 + 6*b^2*c*k^2 - 8*b^2*f*j*k - 10*b^2*h*i*k + 8*b^2*i*j^2 + 8*b*c*e*j*k + 6*b*c*f*i*k - 8*b*c*i^2*j - 30*b*d*e*i*k + 8*b*d*i^3 + 4*b*e*f*h*k - 2*b*e*h*i*j + 2*b*f^3*k - 2*b*f^2*i*j + 2*b*f*h*i^2 + 4*c^2*e*i*k + 8*c*e^2*h*k - 6*c*e^2*j^2 - 8*c*e*f^2*k + 8*c*e*f*i*j - 4*c*e*h*i^2 + 12*d*e^2*f*k + 2*d*e^2*i*j - 4*d*e*f*i^2

abbrev recoveryCoeff38 (a b c d e f h i j k lam rho : R) : R :=
  36*a*b*d*j*k + 12*a*b*h^2*k - 8*a*b*h*j^2 - 24*a*c^2*j*k + 36*a*c*d*i*k + 6*a*c*f*h*k + 8*a*c*f*j^2 - 8*a*c*h*i*j - 72*a*d*e*h*k + 12*a*d*e*j^2 - 12*a*d*f*i*j + 12*a*d*h*i^2 + 4*a*e*h^2*j - 2*a*f^2*h*j + 2*a*f*h^2*i + 4*b^2*c*j*k - 24*b^2*d*i*k - 10*b^2*f*h*k + 8*b^2*h*i*j + 4*b*c^2*i*k + 16*b*c*e*h*k - 4*b*c*e*j^2 + 4*b*c*f^2*k - 4*b*c*f*i*j - 4*b*c*h*i^2 + 6*b*d*e*f*k - 8*b*d*e*i*j + 8*b*d*f*i^2 + 2*b*e*f*h*j - 4*b*e*h^2*i - 10*c^2*e*f*k + 8*c^2*e*i*j + 12*c*d*e^2*k - 8*c*d*e*i^2 - 4*c*e^2*h*j + 2*c*e*f*h*i + 2*d*e^2*f*j + 4*d*e^2*h*i - 2*d*e*f^2*i

abbrev recoveryCoeff39 (a b c d e f h i j k lam rho : R) : R :=
  18*a*b*d*h*k - 2*a*b*h^2*j - 12*a*c^2*h*k + 18*a*c*d*f*k + 4*a*c*f*h*j - 4*a*c*h^2*i - 54*a*d^2*e*k + 6*a*d*e*h*j - 6*a*d*f^2*j + 6*a*d*f*h*i + 2*b^2*c*h*k - 12*b^2*d*f*k + 2*b^2*h^2*i + 2*b*c^2*f*k + 18*b*c*d*e*k - 2*b*c*e*h*j - 2*b*c*f*h*i + 4*b*d*e*f*j - 8*b*d*e*h*i + 2*b*d*f^2*i - 4*c^3*e*k + 4*c^2*e*h*i - 2*c*d*e^2*j - 4*c*d*e*f*i + 6*d^2*e^2*i

abbrev recoveryCoeff40 (a b c d e f h i j k lam rho : R) : R :=
  -27*a^2*h*k^2 + 9*a^2*j^2*k + 9*a*b*f*k^2 - 6*a*b*i*j*k - 3*a*e*f*j*k + 18*a*e*h*i*k - 4*a*e*i*j^2 - 3*a*f^2*i*k + 4*a*f*i^2*j - 4*a*h*i^3 - 3*b^2*e*k^2 + b^2*i^2*k + 2*b*e^2*j*k - b*e*f*i*k - 4*e^3*h*k + e^3*j^2 + e^2*f^2*k - e^2*f*i*j + e^2*h*i^2

abbrev recoveryCoeff41 (a b c d e f h i j k lam rho : R) : R :=
  -54*a^2*d*k^2 - 18*a^2*h*j*k + 8*a^2*j^3 + 18*a*b*c*k^2 + 6*a*b*f*j*k + 6*a*b*h*i*k - 8*a*b*i*j^2 - 6*a*c*e*j*k - 12*a*c*f*i*k + 8*a*c*i^2*j + 36*a*d*e*i*k - 8*a*d*i^3 + 12*a*e*f*h*k - 6*a*e*f*j^2 + 2*a*e*h*i*j - 2*a*f^3*k + 4*a*f^2*i*j - 4*a*f*h*i^2 - 4*b^3*k^2 + 2*b^2*f*i*k - 2*b*c*e*i*k - 8*b*e^2*h*k + 4*b*e^2*j^2 - 2*b*e*f*i*j + 2*b*e*h*i^2 + 4*c*e^2*f*k - 2*c*e^2*i*j - 8*d*e^3*k + 2*d*e^2*i^2 - 2*rho

abbrev recoveryCoeff42 (a b c d e f h i j k lam rho : R) : R :=
  -54*a^2*d*j*k - 18*a^2*h^2*k + 12*a^2*h*j^2 + 18*a*b*c*j*k + 18*a*b*d*i*k + 12*a*b*f*h*k - 4*a*b*f*j^2 - 8*a*b*h*i*j - 12*a*c^2*i*k + 6*a*c*e*h*k - 8*a*c*e*j^2 - 9*a*c*f^2*k + 8*a*c*f*i*j + 4*a*c*h*i^2 + 27*a*d*e*f*k + 12*a*d*e*i*j - 12*a*d*f*i^2 - 3*a*e*f*h*j + 2*a*e*h^2*i + a*f^3*j - a*f^2*h*i - 4*b^3*j*k + 2*b^2*c*i*k - 6*b^2*e*h*k + 4*b^2*e*j^2 + b^2*f^2*k + b*c*e*f*k - 4*b*c*e*i*j - 18*b*d*e^2*k + 4*b*d*e*i^2 + 2*b*e^2*h*j - b*e*f^2*j + b*e*f*h*i + 4*c^2*e^2*k + c*e^2*f*j - 2*c*e^2*h*i - 2*d*e^3*j + d*e^2*f*i

abbrev recoveryCoeff43 (a b c d e f h i j k lam rho : R) : R :=
  -54*a^2*d*h*k + 6*a^2*h^2*j + 18*a*b*c*h*k + 18*a*b*d*f*k - 4*a*b*f*h*j - 2*a*b*h^2*i - 12*a*c^2*f*k + 18*a*c*d*e*k - 8*a*c*e*h*j + 2*a*c*f^2*j + 4*a*c*f*h*i + 6*a*d*e*f*j + 6*a*d*e*h*i - 6*a*d*f^2*i - 4*b^3*h*k + 2*b^2*c*f*k - 12*b^2*d*e*k + 4*b^2*e*h*j + 2*b*c^2*e*k - 2*b*c*e*f*j - 2*b*c*e*h*i - 4*b*d*e^2*j + 4*b*d*e*f*i + 2*c^2*e^2*j - 2*c*d*e^2*i

abbrev recoveryCoeff44 (a b c d e f h i j k lam rho : R) : R :=
  -27*a^2*d^2*k + a^2*h^3 + 18*a*b*c*d*k - a*b*f*h^2 - 4*a*c^3*k - 2*a*c*e*h^2 + a*c*f^2*h + 3*a*d*e*f*h - a*d*f^3 - 4*b^3*d*k + b^2*c^2*k + b^2*e*h^2 - b*c*e*f*h - 2*b*d*e^2*h + b*d*e*f^2 + c^2*e^2*h - c*d*e^2*f + d^2*e^3 - rho

/-- Exact coefficient reconstruction of the `U` ambient residual quartic. -/
theorem u_sub_smul_hesse_eq_sum (a b c d e f h i j k lam rho s t : R) :
    ambientCoeffU a b c d e f h i j k s t - rho * hesseQuarticU lam s t =
      recoveryCoeff0 a b c d e f h i j k lam rho * s^4 +
      recoveryCoeff1 a b c d e f h i j k lam rho * s^3 * t^1 +
      recoveryCoeff2 a b c d e f h i j k lam rho * s^3 +
      recoveryCoeff3 a b c d e f h i j k lam rho * s^2 * t^2 +
      recoveryCoeff4 a b c d e f h i j k lam rho * s^2 * t^1 +
      recoveryCoeff5 a b c d e f h i j k lam rho * s^2 +
      recoveryCoeff6 a b c d e f h i j k lam rho * s^1 * t^3 +
      recoveryCoeff7 a b c d e f h i j k lam rho * s^1 * t^2 +
      recoveryCoeff8 a b c d e f h i j k lam rho * s^1 * t^1 +
      recoveryCoeff9 a b c d e f h i j k lam rho * s^1 +
      recoveryCoeff10 a b c d e f h i j k lam rho * t^4 +
      recoveryCoeff11 a b c d e f h i j k lam rho * t^3 +
      recoveryCoeff12 a b c d e f h i j k lam rho * t^2 +
      recoveryCoeff13 a b c d e f h i j k lam rho * t^1 +
      recoveryCoeff14 a b c d e f h i j k lam rho := by
  simp only [ambientCoeffU, hesseQuarticU, transportedA, transportedB,
    transportedC, transportedD, transportedE, transportedF, transportedH,
    transportedI, UniversalResidual.residualCoeffU, UniversalResidual.residualCoeffW,
    recoveryCoeff0, recoveryCoeff1, recoveryCoeff2, recoveryCoeff3, recoveryCoeff4, recoveryCoeff5, recoveryCoeff6, recoveryCoeff7, recoveryCoeff8, recoveryCoeff9, recoveryCoeff10, recoveryCoeff11, recoveryCoeff12, recoveryCoeff13, recoveryCoeff14]
  ring

/-- Exact coefficient reconstruction of the `V` ambient residual quartic. -/
theorem v_sub_smul_hesse_eq_sum (a b c d e f h i j k lam rho s t : R) :
    ambientCoeffV a b c d e f h i j k s t - rho * hesseQuarticV lam s t =
      recoveryCoeff15 a b c d e f h i j k lam rho * s^4 +
      recoveryCoeff16 a b c d e f h i j k lam rho * s^3 * t^1 +
      recoveryCoeff17 a b c d e f h i j k lam rho * s^3 +
      recoveryCoeff18 a b c d e f h i j k lam rho * s^2 * t^2 +
      recoveryCoeff19 a b c d e f h i j k lam rho * s^2 * t^1 +
      recoveryCoeff20 a b c d e f h i j k lam rho * s^2 +
      recoveryCoeff21 a b c d e f h i j k lam rho * s^1 * t^3 +
      recoveryCoeff22 a b c d e f h i j k lam rho * s^1 * t^2 +
      recoveryCoeff23 a b c d e f h i j k lam rho * s^1 * t^1 +
      recoveryCoeff24 a b c d e f h i j k lam rho * s^1 +
      recoveryCoeff25 a b c d e f h i j k lam rho * t^4 +
      recoveryCoeff26 a b c d e f h i j k lam rho * t^3 +
      recoveryCoeff27 a b c d e f h i j k lam rho * t^2 +
      recoveryCoeff28 a b c d e f h i j k lam rho * t^1 +
      recoveryCoeff29 a b c d e f h i j k lam rho := by
  simp only [ambientCoeffV, hesseQuarticV, transportedA, transportedB,
    transportedC, transportedD, transportedE, transportedF, transportedH,
    transportedJ, UniversalResidual.residualCoeffV, UniversalResidual.residualCoeffW,
    recoveryCoeff15, recoveryCoeff16, recoveryCoeff17, recoveryCoeff18, recoveryCoeff19, recoveryCoeff20, recoveryCoeff21, recoveryCoeff22, recoveryCoeff23, recoveryCoeff24, recoveryCoeff25, recoveryCoeff26, recoveryCoeff27, recoveryCoeff28, recoveryCoeff29]
  ring

/-- Exact coefficient reconstruction of the `W` ambient residual quartic. -/
theorem w_sub_smul_hesse_eq_sum (a b c d e f h i j k lam rho s t : R) :
    ambientCoeffW a b c d e f h i j k s t - rho * hesseQuarticW lam s t =
      recoveryCoeff30 a b c d e f h i j k lam rho * s^4 +
      recoveryCoeff31 a b c d e f h i j k lam rho * s^3 * t^1 +
      recoveryCoeff32 a b c d e f h i j k lam rho * s^3 +
      recoveryCoeff33 a b c d e f h i j k lam rho * s^2 * t^2 +
      recoveryCoeff34 a b c d e f h i j k lam rho * s^2 * t^1 +
      recoveryCoeff35 a b c d e f h i j k lam rho * s^2 +
      recoveryCoeff36 a b c d e f h i j k lam rho * s^1 * t^3 +
      recoveryCoeff37 a b c d e f h i j k lam rho * s^1 * t^2 +
      recoveryCoeff38 a b c d e f h i j k lam rho * s^1 * t^1 +
      recoveryCoeff39 a b c d e f h i j k lam rho * s^1 +
      recoveryCoeff40 a b c d e f h i j k lam rho * t^4 +
      recoveryCoeff41 a b c d e f h i j k lam rho * t^3 +
      recoveryCoeff42 a b c d e f h i j k lam rho * t^2 +
      recoveryCoeff43 a b c d e f h i j k lam rho * t^1 +
      recoveryCoeff44 a b c d e f h i j k lam rho := by
  simp only [ambientCoeffW, hesseQuarticW, transportedA, transportedB,
    transportedC, transportedD, transportedE, transportedF, transportedH,
    UniversalResidual.residualCoeffW,
    recoveryCoeff30, recoveryCoeff31, recoveryCoeff32, recoveryCoeff33, recoveryCoeff34, recoveryCoeff35, recoveryCoeff36, recoveryCoeff37, recoveryCoeff38, recoveryCoeff39, recoveryCoeff40, recoveryCoeff41, recoveryCoeff42, recoveryCoeff43, recoveryCoeff44]
  ring

/-- Coefficientwise equality of the full universal residual triple with `rho` times the
normalized Hesse triple. -/
structure RecoveryEquations (a b c d e f h i j k lam rho : R) : Prop where
  h0 : recoveryCoeff0 a b c d e f h i j k lam rho = 0
  h1 : recoveryCoeff1 a b c d e f h i j k lam rho = 0
  h2 : recoveryCoeff2 a b c d e f h i j k lam rho = 0
  h3 : recoveryCoeff3 a b c d e f h i j k lam rho = 0
  h4 : recoveryCoeff4 a b c d e f h i j k lam rho = 0
  h5 : recoveryCoeff5 a b c d e f h i j k lam rho = 0
  h6 : recoveryCoeff6 a b c d e f h i j k lam rho = 0
  h7 : recoveryCoeff7 a b c d e f h i j k lam rho = 0
  h8 : recoveryCoeff8 a b c d e f h i j k lam rho = 0
  h9 : recoveryCoeff9 a b c d e f h i j k lam rho = 0
  h10 : recoveryCoeff10 a b c d e f h i j k lam rho = 0
  h11 : recoveryCoeff11 a b c d e f h i j k lam rho = 0
  h12 : recoveryCoeff12 a b c d e f h i j k lam rho = 0
  h13 : recoveryCoeff13 a b c d e f h i j k lam rho = 0
  h14 : recoveryCoeff14 a b c d e f h i j k lam rho = 0
  h15 : recoveryCoeff15 a b c d e f h i j k lam rho = 0
  h16 : recoveryCoeff16 a b c d e f h i j k lam rho = 0
  h17 : recoveryCoeff17 a b c d e f h i j k lam rho = 0
  h18 : recoveryCoeff18 a b c d e f h i j k lam rho = 0
  h19 : recoveryCoeff19 a b c d e f h i j k lam rho = 0
  h20 : recoveryCoeff20 a b c d e f h i j k lam rho = 0
  h21 : recoveryCoeff21 a b c d e f h i j k lam rho = 0
  h22 : recoveryCoeff22 a b c d e f h i j k lam rho = 0
  h23 : recoveryCoeff23 a b c d e f h i j k lam rho = 0
  h24 : recoveryCoeff24 a b c d e f h i j k lam rho = 0
  h25 : recoveryCoeff25 a b c d e f h i j k lam rho = 0
  h26 : recoveryCoeff26 a b c d e f h i j k lam rho = 0
  h27 : recoveryCoeff27 a b c d e f h i j k lam rho = 0
  h28 : recoveryCoeff28 a b c d e f h i j k lam rho = 0
  h29 : recoveryCoeff29 a b c d e f h i j k lam rho = 0
  h30 : recoveryCoeff30 a b c d e f h i j k lam rho = 0
  h31 : recoveryCoeff31 a b c d e f h i j k lam rho = 0
  h32 : recoveryCoeff32 a b c d e f h i j k lam rho = 0
  h33 : recoveryCoeff33 a b c d e f h i j k lam rho = 0
  h34 : recoveryCoeff34 a b c d e f h i j k lam rho = 0
  h35 : recoveryCoeff35 a b c d e f h i j k lam rho = 0
  h36 : recoveryCoeff36 a b c d e f h i j k lam rho = 0
  h37 : recoveryCoeff37 a b c d e f h i j k lam rho = 0
  h38 : recoveryCoeff38 a b c d e f h i j k lam rho = 0
  h39 : recoveryCoeff39 a b c d e f h i j k lam rho = 0
  h40 : recoveryCoeff40 a b c d e f h i j k lam rho = 0
  h41 : recoveryCoeff41 a b c d e f h i j k lam rho = 0
  h42 : recoveryCoeff42 a b c d e f h i j k lam rho = 0
  h43 : recoveryCoeff43 a b c d e f h i j k lam rho = 0
  h44 : recoveryCoeff44 a b c d e f h i j k lam rho = 0

variable {R : Type u} [Field R] [CharZero R]

/-- Exact interpolation on the fifteen integral points `0 <= s,t` and `s+t <= 4`. -/
theorem quartic_coefficients_eq_zero (c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 : R)
    (hzero : ∀ s t : R,
      c0 * s^4 +
      c1 * s^3 * t^1 +
      c2 * s^3 +
      c3 * s^2 * t^2 +
      c4 * s^2 * t^1 +
      c5 * s^2 +
      c6 * s^1 * t^3 +
      c7 * s^1 * t^2 +
      c8 * s^1 * t^1 +
      c9 * s^1 +
      c10 * t^4 +
      c11 * t^3 +
      c12 * t^2 +
      c13 * t^1 +
      c14 = 0) :
    c0 = 0 ∧ c1 = 0 ∧ c2 = 0 ∧ c3 = 0 ∧ c4 = 0 ∧ c5 = 0 ∧ c6 = 0 ∧ c7 = 0 ∧ c8 = 0 ∧ c9 = 0 ∧ c10 = 0 ∧ c11 = 0 ∧ c12 = 0 ∧ c13 = 0 ∧ c14 = 0 := by
  have hc0 : c0 = 0 := by
    linear_combination
      (1/24) * (hzero 0 0) +
      (-1/6) * (hzero 1 0) +
      (1/4) * (hzero 2 0) +
      (-1/6) * (hzero 3 0) +
      (1/24) * (hzero 4 0)
  have hc1 : c1 = 0 := by
    linear_combination
      (1/6) * (hzero 0 0) +
      (-1/2) * (hzero 1 0) +
      (-1/6) * (hzero 0 1) +
      (1/2) * (hzero 2 0) +
      (1/2) * (hzero 1 1) +
      (-1/6) * (hzero 3 0) +
      (-1/2) * (hzero 2 1) +
      (1/6) * (hzero 3 1)
  have hc2 : c2 = 0 := by
    linear_combination
      (-5/12) * (hzero 0 0) +
      (3/2) * (hzero 1 0) +
      (-2) * (hzero 2 0) +
      (7/6) * (hzero 3 0) +
      (-1/4) * (hzero 4 0)
  have hc3 : c3 = 0 := by
    linear_combination
      (1/4) * (hzero 0 0) +
      (-1/2) * (hzero 1 0) +
      (-1/2) * (hzero 0 1) +
      (1/4) * (hzero 2 0) +
      (1) * (hzero 1 1) +
      (1/4) * (hzero 0 2) +
      (-1/2) * (hzero 2 1) +
      (-1/2) * (hzero 1 2) +
      (1/4) * (hzero 2 2)
  have hc4 : c4 = 0 := by
    linear_combination
      (-5/4) * (hzero 0 0) +
      (3) * (hzero 1 0) +
      (3/2) * (hzero 0 1) +
      (-9/4) * (hzero 2 0) +
      (-7/2) * (hzero 1 1) +
      (-1/4) * (hzero 0 2) +
      (1/2) * (hzero 3 0) +
      (5/2) * (hzero 2 1) +
      (1/2) * (hzero 1 2) +
      (-1/2) * (hzero 3 1) +
      (-1/4) * (hzero 2 2)
  have hc5 : c5 = 0 := by
    linear_combination
      (35/24) * (hzero 0 0) +
      (-13/3) * (hzero 1 0) +
      (19/4) * (hzero 2 0) +
      (-7/3) * (hzero 3 0) +
      (11/24) * (hzero 4 0)
  have hc6 : c6 = 0 := by
    linear_combination
      (1/6) * (hzero 0 0) +
      (-1/6) * (hzero 1 0) +
      (-1/2) * (hzero 0 1) +
      (1/2) * (hzero 1 1) +
      (1/2) * (hzero 0 2) +
      (-1/2) * (hzero 1 2) +
      (-1/6) * (hzero 0 3) +
      (1/6) * (hzero 1 3)
  have hc7 : c7 = 0 := by
    linear_combination
      (-5/4) * (hzero 0 0) +
      (3/2) * (hzero 1 0) +
      (3) * (hzero 0 1) +
      (-1/4) * (hzero 2 0) +
      (-7/2) * (hzero 1 1) +
      (-9/4) * (hzero 0 2) +
      (1/2) * (hzero 2 1) +
      (5/2) * (hzero 1 2) +
      (1/2) * (hzero 0 3) +
      (-1/4) * (hzero 2 2) +
      (-1/2) * (hzero 1 3)
  have hc8 : c8 = 0 := by
    linear_combination
      (35/12) * (hzero 0 0) +
      (-13/3) * (hzero 1 0) +
      (-13/3) * (hzero 0 1) +
      (7/4) * (hzero 2 0) +
      (6) * (hzero 1 1) +
      (7/4) * (hzero 0 2) +
      (-1/3) * (hzero 3 0) +
      (-2) * (hzero 2 1) +
      (-2) * (hzero 1 2) +
      (-1/3) * (hzero 0 3) +
      (1/3) * (hzero 3 1) +
      (1/4) * (hzero 2 2) +
      (1/3) * (hzero 1 3)
  have hc9 : c9 = 0 := by
    linear_combination
      (-25/12) * (hzero 0 0) +
      (4) * (hzero 1 0) +
      (-3) * (hzero 2 0) +
      (4/3) * (hzero 3 0) +
      (-1/4) * (hzero 4 0)
  have hc10 : c10 = 0 := by
    linear_combination
      (1/24) * (hzero 0 0) +
      (-1/6) * (hzero 0 1) +
      (1/4) * (hzero 0 2) +
      (-1/6) * (hzero 0 3) +
      (1/24) * (hzero 0 4)
  have hc11 : c11 = 0 := by
    linear_combination
      (-5/12) * (hzero 0 0) +
      (3/2) * (hzero 0 1) +
      (-2) * (hzero 0 2) +
      (7/6) * (hzero 0 3) +
      (-1/4) * (hzero 0 4)
  have hc12 : c12 = 0 := by
    linear_combination
      (35/24) * (hzero 0 0) +
      (-13/3) * (hzero 0 1) +
      (19/4) * (hzero 0 2) +
      (-7/3) * (hzero 0 3) +
      (11/24) * (hzero 0 4)
  have hc13 : c13 = 0 := by
    linear_combination
      (-25/12) * (hzero 0 0) +
      (4) * (hzero 0 1) +
      (-3) * (hzero 0 2) +
      (4/3) * (hzero 0 3) +
      (-1/4) * (hzero 0 4)
  have hc14 : c14 = 0 := by
    linear_combination
      (1) * (hzero 0 0)
  exact ⟨hc0, hc1, hc2, hc3, hc4, hc5, hc6, hc7, hc8, hc9, hc10, hc11, hc12, hc13, hc14⟩

/-- Functional equality of all three affine residual quartics gives all 45 coefficient
equations used by the recovery certificate. -/
theorem recoveryEquations_of_fullResidual_eq (a b c d e f h i j k lam rho : R)
    (hU : ∀ s t, ambientCoeffU a b c d e f h i j k s t = rho * hesseQuarticU lam s t)
    (hV : ∀ s t, ambientCoeffV a b c d e f h i j k s t = rho * hesseQuarticV lam s t)
    (hW : ∀ s t, ambientCoeffW a b c d e f h i j k s t = rho * hesseQuarticW lam s t) :
    RecoveryEquations a b c d e f h i j k lam rho := by
  have hUc : ∀ s t : R,
      recoveryCoeff0 a b c d e f h i j k lam rho * s^4 +
      recoveryCoeff1 a b c d e f h i j k lam rho * s^3 * t^1 +
      recoveryCoeff2 a b c d e f h i j k lam rho * s^3 +
      recoveryCoeff3 a b c d e f h i j k lam rho * s^2 * t^2 +
      recoveryCoeff4 a b c d e f h i j k lam rho * s^2 * t^1 +
      recoveryCoeff5 a b c d e f h i j k lam rho * s^2 +
      recoveryCoeff6 a b c d e f h i j k lam rho * s^1 * t^3 +
      recoveryCoeff7 a b c d e f h i j k lam rho * s^1 * t^2 +
      recoveryCoeff8 a b c d e f h i j k lam rho * s^1 * t^1 +
      recoveryCoeff9 a b c d e f h i j k lam rho * s^1 +
      recoveryCoeff10 a b c d e f h i j k lam rho * t^4 +
      recoveryCoeff11 a b c d e f h i j k lam rho * t^3 +
      recoveryCoeff12 a b c d e f h i j k lam rho * t^2 +
      recoveryCoeff13 a b c d e f h i j k lam rho * t^1 +
      recoveryCoeff14 a b c d e f h i j k lam rho = 0 := by
    intro s t
    rw [← u_sub_smul_hesse_eq_sum]
    exact sub_eq_zero.mpr (hU s t)
  obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12, h13, h14⟩ := quartic_coefficients_eq_zero (recoveryCoeff0 a b c d e f h i j k lam rho) (recoveryCoeff1 a b c d e f h i j k lam rho) (recoveryCoeff2 a b c d e f h i j k lam rho) (recoveryCoeff3 a b c d e f h i j k lam rho) (recoveryCoeff4 a b c d e f h i j k lam rho) (recoveryCoeff5 a b c d e f h i j k lam rho) (recoveryCoeff6 a b c d e f h i j k lam rho) (recoveryCoeff7 a b c d e f h i j k lam rho) (recoveryCoeff8 a b c d e f h i j k lam rho) (recoveryCoeff9 a b c d e f h i j k lam rho) (recoveryCoeff10 a b c d e f h i j k lam rho) (recoveryCoeff11 a b c d e f h i j k lam rho) (recoveryCoeff12 a b c d e f h i j k lam rho) (recoveryCoeff13 a b c d e f h i j k lam rho) (recoveryCoeff14 a b c d e f h i j k lam rho) hUc
  have hVc : ∀ s t : R,
      recoveryCoeff15 a b c d e f h i j k lam rho * s^4 +
      recoveryCoeff16 a b c d e f h i j k lam rho * s^3 * t^1 +
      recoveryCoeff17 a b c d e f h i j k lam rho * s^3 +
      recoveryCoeff18 a b c d e f h i j k lam rho * s^2 * t^2 +
      recoveryCoeff19 a b c d e f h i j k lam rho * s^2 * t^1 +
      recoveryCoeff20 a b c d e f h i j k lam rho * s^2 +
      recoveryCoeff21 a b c d e f h i j k lam rho * s^1 * t^3 +
      recoveryCoeff22 a b c d e f h i j k lam rho * s^1 * t^2 +
      recoveryCoeff23 a b c d e f h i j k lam rho * s^1 * t^1 +
      recoveryCoeff24 a b c d e f h i j k lam rho * s^1 +
      recoveryCoeff25 a b c d e f h i j k lam rho * t^4 +
      recoveryCoeff26 a b c d e f h i j k lam rho * t^3 +
      recoveryCoeff27 a b c d e f h i j k lam rho * t^2 +
      recoveryCoeff28 a b c d e f h i j k lam rho * t^1 +
      recoveryCoeff29 a b c d e f h i j k lam rho = 0 := by
    intro s t
    rw [← v_sub_smul_hesse_eq_sum]
    exact sub_eq_zero.mpr (hV s t)
  obtain ⟨h15, h16, h17, h18, h19, h20, h21, h22, h23, h24, h25, h26, h27, h28, h29⟩ := quartic_coefficients_eq_zero (recoveryCoeff15 a b c d e f h i j k lam rho) (recoveryCoeff16 a b c d e f h i j k lam rho) (recoveryCoeff17 a b c d e f h i j k lam rho) (recoveryCoeff18 a b c d e f h i j k lam rho) (recoveryCoeff19 a b c d e f h i j k lam rho) (recoveryCoeff20 a b c d e f h i j k lam rho) (recoveryCoeff21 a b c d e f h i j k lam rho) (recoveryCoeff22 a b c d e f h i j k lam rho) (recoveryCoeff23 a b c d e f h i j k lam rho) (recoveryCoeff24 a b c d e f h i j k lam rho) (recoveryCoeff25 a b c d e f h i j k lam rho) (recoveryCoeff26 a b c d e f h i j k lam rho) (recoveryCoeff27 a b c d e f h i j k lam rho) (recoveryCoeff28 a b c d e f h i j k lam rho) (recoveryCoeff29 a b c d e f h i j k lam rho) hVc
  have hWc : ∀ s t : R,
      recoveryCoeff30 a b c d e f h i j k lam rho * s^4 +
      recoveryCoeff31 a b c d e f h i j k lam rho * s^3 * t^1 +
      recoveryCoeff32 a b c d e f h i j k lam rho * s^3 +
      recoveryCoeff33 a b c d e f h i j k lam rho * s^2 * t^2 +
      recoveryCoeff34 a b c d e f h i j k lam rho * s^2 * t^1 +
      recoveryCoeff35 a b c d e f h i j k lam rho * s^2 +
      recoveryCoeff36 a b c d e f h i j k lam rho * s^1 * t^3 +
      recoveryCoeff37 a b c d e f h i j k lam rho * s^1 * t^2 +
      recoveryCoeff38 a b c d e f h i j k lam rho * s^1 * t^1 +
      recoveryCoeff39 a b c d e f h i j k lam rho * s^1 +
      recoveryCoeff40 a b c d e f h i j k lam rho * t^4 +
      recoveryCoeff41 a b c d e f h i j k lam rho * t^3 +
      recoveryCoeff42 a b c d e f h i j k lam rho * t^2 +
      recoveryCoeff43 a b c d e f h i j k lam rho * t^1 +
      recoveryCoeff44 a b c d e f h i j k lam rho = 0 := by
    intro s t
    rw [← w_sub_smul_hesse_eq_sum]
    exact sub_eq_zero.mpr (hW s t)
  obtain ⟨h30, h31, h32, h33, h34, h35, h36, h37, h38, h39, h40, h41, h42, h43, h44⟩ := quartic_coefficients_eq_zero (recoveryCoeff30 a b c d e f h i j k lam rho) (recoveryCoeff31 a b c d e f h i j k lam rho) (recoveryCoeff32 a b c d e f h i j k lam rho) (recoveryCoeff33 a b c d e f h i j k lam rho) (recoveryCoeff34 a b c d e f h i j k lam rho) (recoveryCoeff35 a b c d e f h i j k lam rho) (recoveryCoeff36 a b c d e f h i j k lam rho) (recoveryCoeff37 a b c d e f h i j k lam rho) (recoveryCoeff38 a b c d e f h i j k lam rho) (recoveryCoeff39 a b c d e f h i j k lam rho) (recoveryCoeff40 a b c d e f h i j k lam rho) (recoveryCoeff41 a b c d e f h i j k lam rho) (recoveryCoeff42 a b c d e f h i j k lam rho) (recoveryCoeff43 a b c d e f h i j k lam rho) (recoveryCoeff44 a b c d e f h i j k lam rho) hWc
  exact ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12, h13, h14, h15, h16, h17, h18, h19, h20, h21, h22, h23, h24, h25, h26, h27, h28, h29, h30, h31, h32, h33, h34, h35, h36, h37, h38, h39, h40, h41, h42, h43, h44⟩


set_option maxRecDepth 100000 in
set_option maxHeartbeats 8000000 in
-- The nine proof-producing Groebner combinations expand to large degree-six identities.
/-- A nonzero full residual triple equal to the normalized Hesse triple recovers the cubic.
The conclusion says the cubic is a scalar multiple of
`U^3+V^3+W^3-3*lam*U*V*W`. -/
theorem eq_hesse_of_recoveryEquations (a b c d e f h i j k lam rho : R) (hrho : rho ≠ 0)
    (H : RecoveryEquations a b c d e f h i j k lam rho) :
    b = 0 ∧ c = 0 ∧ e = 0 ∧ h = 0 ∧ i = 0 ∧ j = 0 ∧
      d = a ∧ k = a ∧ f = -3 * lam * a := by
  let v : R := rho⁻¹
  have hv : v * rho = 1 := by simp [v, hrho]
  have e0 := H.h0
  dsimp only [recoveryCoeff0] at e0
  have e1 := H.h1
  dsimp only [recoveryCoeff1] at e1
  have e2 := H.h2
  dsimp only [recoveryCoeff2] at e2
  have e3 := H.h3
  dsimp only [recoveryCoeff3] at e3
  have e4 := H.h4
  dsimp only [recoveryCoeff4] at e4
  have e5 := H.h5
  dsimp only [recoveryCoeff5] at e5
  have e6 := H.h6
  dsimp only [recoveryCoeff6] at e6
  have e7 := H.h7
  dsimp only [recoveryCoeff7] at e7
  have e8 := H.h8
  dsimp only [recoveryCoeff8] at e8
  have e9 := H.h9
  dsimp only [recoveryCoeff9] at e9
  have e10 := H.h10
  dsimp only [recoveryCoeff10] at e10
  have e11 := H.h11
  dsimp only [recoveryCoeff11] at e11
  have e12 := H.h12
  dsimp only [recoveryCoeff12] at e12
  have e13 := H.h13
  dsimp only [recoveryCoeff13] at e13
  have e14 := H.h14
  dsimp only [recoveryCoeff14] at e14
  have e15 := H.h15
  dsimp only [recoveryCoeff15] at e15
  have e16 := H.h16
  dsimp only [recoveryCoeff16] at e16
  have e18 := H.h18
  dsimp only [recoveryCoeff18] at e18
  have e19 := H.h19
  dsimp only [recoveryCoeff19] at e19
  have e20 := H.h20
  dsimp only [recoveryCoeff20] at e20
  have e21 := H.h21
  dsimp only [recoveryCoeff21] at e21
  have e22 := H.h22
  dsimp only [recoveryCoeff22] at e22
  have e24 := H.h24
  dsimp only [recoveryCoeff24] at e24
  have e25 := H.h25
  dsimp only [recoveryCoeff25] at e25
  have e26 := H.h26
  dsimp only [recoveryCoeff26] at e26
  have e28 := H.h28
  dsimp only [recoveryCoeff28] at e28
  have e30 := H.h30
  dsimp only [recoveryCoeff30] at e30
  have e31 := H.h31
  dsimp only [recoveryCoeff31] at e31
  have e33 := H.h33
  dsimp only [recoveryCoeff33] at e33
  have e36 := H.h36
  dsimp only [recoveryCoeff36] at e36
  have e39 := H.h39
  dsimp only [recoveryCoeff39] at e39
  have e40 := H.h40
  dsimp only [recoveryCoeff40] at e40
  have e43 := H.h43
  dsimp only [recoveryCoeff43] at e43
  have hj : j = 0 := by
    linear_combination
      (e*lam*v/3) * e0 +
      (h*lam*v/6 + i*v/3) * e3 +
      (-j*lam*v/36) * e4 +
      (-k*lam*v/3) * e5 +
      (j*v/6) * e6 +
      (-k*v/4) * e7 +
      (-e*lam*v/12) * e16 +
      (5*h*lam*v/12 + i*v/6) * e21 +
      (-5*j*lam*v/36) * e22 +
      (-2*j*v/3) * e25 +
      (k*v/4) * e26 +
      (-2*a*lam*v/3) * e30 +
      (b*lam*v/12) * e31 +
      (-e*v/6) * e33 +
      (-5*d*lam*v/12 - f*v/12) * e36 +
      (5*k*lam*v/12) * e39 +
      (h*v/3) * e40 +
      (-j) * hv
  have hi : i = 0 := by
    linear_combination
      (a*v/6) * e2 +
      (-b*v/18) * e4 +
      (-c*v/6) * e7 +
      (-i*v/6) * e9 +
      (-5*d*v/6) * e11 +
      (j*v/6) * e13 +
      (4*k*v/3) * e14 +
      (a*v/3) * e19 +
      (2*b*v/9) * e22 +
      (c*v/3) * e26 +
      (-i*v/3) * e28 +
      (-i) * hv
  have hh : h = 0 := by
    linear_combination
      (-e*v/6) * e1 +
      (-h*v/6) * e6 +
      (k*v/6) * e8 +
      (-4*h*v/3) * e25 +
      (j*v/3) * e26 +
      (a*v/3) * e31 +
      (4*d*v/3) * e40 +
      (-k*v/3) * e43 +
      (-h) * hv
  have he : e = 0 := by
    linear_combination
      (-2*e*v/3) * e0 +
      (-h*v/3) * e3 +
      (j*v/18) * e4 +
      (2*k*v/3) * e5 +
      (e*v/6) * e16 +
      (-5*h*v/6) * e21 +
      (5*j*v/18) * e22 +
      (4*a*v/3) * e30 +
      (-b*v/6) * e31 +
      (5*d*v/6) * e36 +
      (-5*k*v/6) * e39 +
      (-e) * hv
  have hdk0 : d - k = 0 := by
    linear_combination
      (-4*a*v/3) * e0 +
      (-b*v/6) * e1 +
      (e*v/6) * e2 +
      (f*v/9) * e4 +
      (d*v/6) * e6 +
      (h*v/6) * e7 +
      (-k*v/6) * e9 +
      (-2*a*v/3) * e16 +
      (-b*v/3) * e18 +
      (-c*v/3) * e21 +
      (f*v/18) * e22 +
      (-2*d*v/3) * e25 +
      (h*v/3) * e26 +
      (2*k*v/3) * e28 +
      (-j*v/2) * e43 +
      (-d + k) * hv
  have hc : c = 0 := by
    linear_combination
      (-e*lam^2*v/6) * e0 +
      (-b*v/6 - h*lam^2*v/12 - i*lam*v/6) * e3 +
      (j*lam^2*v/72) * e4 +
      (k*lam^2*v/6) * e5 +
      (-c*v/6 - j*lam*v/12) * e6 +
      (f*v/12 + k*lam*v/8) * e7 +
      (d*v) * e10 +
      (h*v/6) * e11 +
      (-j*v/6) * e12 +
      (e*lam^2*v/24) * e16 +
      (-b*v/3 - 5*h*lam^2*v/24 - i*lam*v/12) * e21 +
      (5*j*lam^2*v/72) * e22 +
      (-4*c*v/3 + j*lam*v/3) * e25 +
      (f*v/6 - k*lam*v/8) * e26 +
      (a*lam^2*v/3) * e30 +
      (-b*lam^2*v/24) * e31 +
      (e*lam*v/12) * e33 +
      (5*d*lam^2*v/24 + f*lam*v/24) * e36 +
      (-5*k*lam^2*v/24) * e39 +
      (-h*lam*v/6) * e40 +
      (-c) * hv
  have hb : b = 0 := by
    linear_combination
      (-2*b*v/3) * e0 +
      (-c*v/3) * e1 +
      (-d*v/3) * e3 +
      (4*a*v/3) * e15 +
      (b*v/6) * e16 +
      (-d*v/6) * e21 +
      (-k*v/3) * e24 +
      (j*v/6) * e39 +
      (-b) * hv
  have hak0 : a - k = 0 := by
    linear_combination
      (-2*a*v/3) * e0 +
      (-b*v/3) * e1 +
      (e*v/6) * e2 +
      (-c*v/3) * e3 +
      (f*v/9) * e4 +
      (-2*d*v/3) * e6 +
      (h*v/6) * e7 +
      (k*v/6) * e9 +
      (a*v/6) * e16 +
      (-c*v/6) * e21 +
      (f*v/18) * e22 +
      (-4*d*v/3) * e25 +
      (h*v/3) * e26 +
      (k*v/3) * e28 +
      (-i*v/6) * e39 +
      (-j*v/3) * e43 +
      (-a + k) * hv
  have hf0 : 3*k*lam + f = 0 := by
    linear_combination
      (-2*f*v/3) * e0 +
      (-2*h*v/3) * e1 +
      (2*j*v/3) * e2 +
      (2*e*v) * e15 +
      (f*v/6) * e16 +
      (-h*v/3) * e18 +
      (j*v/3) * e19 +
      (-k*v) * e20 +
      (-4*b*v/3) * e30 +
      (-c*v/3) * e31 +
      (-f - 3*k*lam) * hv
  have hdk : d = k := sub_eq_zero.mp hdk0
  have hak : a = k := sub_eq_zero.mp hak0
  have hf : f = -3 * lam * a := by
    rw [hak]
    linear_combination hf0
  exact ⟨hb, hc, he, hh, hi, hj, hdk.trans hak.symm, hak.symm, hf⟩

/-- **Full affine residual-map rigidity in Hesse coordinates.**

If the three universal residual quartics of a general cubic are one nonzero scalar times the
normalized residual quartics of the Hesse cubic with parameter `lam`, then the general cubic is a
scalar multiple of that Hesse cubic.  No smoothness assumption on `lam` is needed for this purely
algebraic implication.
-/
theorem eq_hesse_of_fullResidual_eq (a b c d e f h i j k lam rho : R) (hrho : rho ≠ 0)
    (hU : ∀ s t, ambientCoeffU a b c d e f h i j k s t = rho * hesseQuarticU lam s t)
    (hV : ∀ s t, ambientCoeffV a b c d e f h i j k s t = rho * hesseQuarticV lam s t)
    (hW : ∀ s t, ambientCoeffW a b c d e f h i j k s t = rho * hesseQuarticW lam s t) :
    b = 0 ∧ c = 0 ∧ e = 0 ∧ h = 0 ∧ i = 0 ∧ j = 0 ∧
      d = a ∧ k = a ∧ f = -3 * lam * a :=
  eq_hesse_of_recoveryEquations a b c d e f h i j k lam rho hrho
    (recoveryEquations_of_fullResidual_eq a b c d e f h i j k lam rho hU hV hW)

end BConicBundleMultisections.HesseFullResidualRigidity
