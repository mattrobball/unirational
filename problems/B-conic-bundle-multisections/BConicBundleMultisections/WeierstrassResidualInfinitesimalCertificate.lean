/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.UniversalResidualIdentity

/-!
# Infinitesimal residual-map rigidity in short Weierstrass coordinates

This file records a finite algebraic certificate for the following local fact.  At the smooth
short Weierstrass cubic

`-U^3 + V^2 W - A U W^2 - B W^3`,

an infinitesimal deformation which changes the residual-line map only by an infinitesimal common
scalar is itself only a scalar deformation of the cubic.  The certificate uses coefficients of
the first component of the residual quartic on the affine dual chart `W = sU + tV`.

The result is deliberately local.  Turning it into the global pencil theorem still requires a
normal-form/descent argument; no such geometric statement is hidden here.
-/

@[expose] public section

namespace BConicBundleMultisections.WeierstrassResidualInfinitesimalCertificate

universe u

variable {K : Type u} [Field K] [CharZero K]

open BConicBundleMultisections.UniversalResidual

/-! ## The affine residual quartic and its linearization -/

section Formula

variable {R : Type u} [CommRing R]

/-- Coefficients of a cubic after substituting `W = sU + tV + W`. -/
abbrev transportedA (a e i k s : R) := a + e * s + i * s ^ 2 + k * s ^ 3
abbrev transportedB (b e f i j k s t : R) :=
  b + e * t + f * s + 2 * i * s * t + j * s ^ 2 + 3 * k * s ^ 2 * t
abbrev transportedC (c f h i j k s t : R) :=
  c + f * t + h * s + i * t ^ 2 + 2 * j * s * t + 3 * k * s * t ^ 2
abbrev transportedD (d h j k t : R) := d + h * t + j * t ^ 2 + k * t ^ 3
abbrev transportedE (e i k s : R) := e + 2 * i * s + 3 * k * s ^ 2
abbrev transportedF (f i j k s t : R) := f + 2 * i * t + 2 * j * s + 6 * k * s * t
abbrev transportedH (h j k t : R) := h + 2 * j * t + 3 * k * t ^ 2
abbrev transportedI (i k s : R) := i + 3 * k * s
abbrev transportedK (k : R) := k

/-- First ambient coefficient of the residual line on the affine dual chart `W = sU+tV`. -/
abbrev ambientCoeffU (a b c d e f h i j k s t : R) : R :=
  residualCoeffU
      (transportedA a e i k s) (transportedB b e f i j k s t)
      (transportedC c f h i j k s t) (transportedD d h j k t)
      (transportedE e i k s) (transportedF f i j k s t)
      (transportedH h j k t) (transportedI i k s)
    - s * residualCoeffW
      (transportedA a e i k s) (transportedB b e f i j k s t)
      (transportedC c f h i j k s t) (transportedD d h j k t)
      (transportedE e i k s) (transportedF f i j k s t)
      (transportedH h j k t) (transportedK k)

/-- The first residual quartic of the short Weierstrass cubic. -/
theorem ambientCoeffU_weierstrass (A B s t : R) :
    ambientCoeffU (-1) 0 0 0 0 0 1 (-A) 0 (-B) s t =
      -4 * (A ^ 2 * s ^ 2 * t ^ 2 + A * s ^ 3 - 3 * A * t ^ 2 +
        B * s ^ 4 - 9 * B * s * t ^ 2 + s) := by
  simp only [ambientCoeffU, transportedA, transportedB, transportedC, transportedD,
    transportedE, transportedF, transportedH, transportedI, transportedK,
    residualCoeffU, residualCoeffW]
  ring

/-- Explicit first-order part of the first residual quartic at a short Weierstrass cubic. -/
abbrev residualUSlope
    (A B da db dc dd de df dh di dj dk s t : R) : R :=
  (-3 * dc) +
  (36 * A * dd + 6 * df) * t +
  (-24 * A * da + 18 * B * dc + 24 * A * dh - 12 * di) * t ^ 2 +
  (-4 * A ^ 2 * db - 18 * B * df + 12 * A * dj) * t ^ 3 +
  (-(4 * A ^ 3 + 27 * B ^ 2) * dc) * t ^ 4 +
  (8 * da - 12 * dh) * s +
  (10 * A * db + 54 * B * dd - 6 * dj) * s * t +
  (-72 * B * da - 8 * A ^ 2 * dc + 4 * A * de + 72 * B * dh - 36 * dk) *
    s * t ^ 2 +
  (-6 * A * B * db + 2 * (4 * A ^ 3 + 27 * B ^ 2) * dd + 4 * A ^ 2 * df +
    18 * B * dj) * s * t ^ 3 +
  (-6 * A * dc + 4 * de) * s ^ 2 +
  (24 * B * db + 12 * A ^ 2 * dd + 10 * A * df) * s ^ 2 * t +
  (4 * A ^ 2 * da - 6 * A * B * dc - 12 * B * de - 8 * A ^ 2 * dh +
    8 * A * di) * s ^ 2 * t ^ 2 +
  (4 * A * da - 12 * A * dh - 12 * B * dc + 4 * di) * s ^ 3 +
  (-2 * A ^ 2 * db + 18 * A * B * dd - 2 * A * dj + 12 * B * df) * s ^ 3 * t +
  (4 * B * da + A ^ 2 * dc - 12 * B * dh + 4 * dk) * s ^ 4

end Formula

/-- The discriminant factor of `V^2 W = U^3 + A U W^2 + B W^3`. -/
abbrev discr (A B : K) : K := 4 * A ^ 3 + 27 * B ^ 2

/-- A short Weierstrass cubic with nonzero discriminant cannot have both parameters zero. -/
theorem ne_zero_or_ne_zero_of_discr_ne_zero (A B : K) (hdisc : discr A B ≠ 0) :
    A ≠ 0 ∨ B ≠ 0 := by
  by_contra h
  push Not at h
  exact hdisc (by simp [discr, h.1, h.2])

/--
Ten particularly small coefficients of the two cross-products
`R_U dR_V - R_V dR_U` and `R_U dR_W - R_W dR_U` already prove projective
infinitesimal rigidity.  Unlike the scalar-form certificate below, this version does not first
need to show that the pointwise proportionality scalar is independent of the dual-plane point.
-/
theorem tangent_eq_smul_of_cross_equations
    (A B da db dc dd de df dh di dj dk : K)
    (hAB : A ≠ 0 ∨ B ≠ 0)
    (hc01 : 24 * dc = 0)
    (hc10 : -36 * dd = 0)
    (hc20 : -16 * db = 0)
    (hcUWs20 : 4 * (4 * A * dc - de) = 0)
    (hcUWt01 : -6 * (6 * A * dd + df) = 0)
    (hcUWt02 : 12 * (A * dh + 3 * B * dc + di) = 0)
    (hcUWs30 : 12 * (A * da + 5 * B * dc - di) = 0)
    (hcUWs11 : -2 * (A * db + 135 * B * dd + 9 * dj) = 0)
    (hcVWs31 : -8 * (2 * A * de + 9 * B * da - 9 * dk) = 0)
    (hcVWt03 : -16 * (2 * A ^ 2 * dc - A * de + 9 * B * dh + 9 * dk) = 0) :
    da = -dh ∧ db = 0 ∧ dc = 0 ∧ dd = 0 ∧ de = 0 ∧ df = 0 ∧
      di = -A * dh ∧ dj = 0 ∧ dk = -B * dh := by
  have hdc : dc = 0 := by linear_combination (24 : K)⁻¹ * hc01
  have hdd : dd = 0 := by linear_combination (-36 : K)⁻¹ * hc10
  have hdb : db = 0 := by linear_combination (-16 : K)⁻¹ * hc20
  have hde : de = 0 := by
    rw [hdc] at hcUWs20
    linear_combination (-4 : K)⁻¹ * hcUWs20
  have hdf : df = 0 := by
    rw [hdd] at hcUWt01
    linear_combination (-6 : K)⁻¹ * hcUWt01
  have hdi : di = -A * dh := by
    rw [hdc] at hcUWt02
    linear_combination (12 : K)⁻¹ * hcUWt02
  have hdj : dj = 0 := by
    rw [hdb, hdd] at hcUWs11
    linear_combination (-18 : K)⁻¹ * hcUWs11
  have hdk_da : dk = B * da := by
    rw [hde] at hcVWs31
    linear_combination (72 : K)⁻¹ * hcVWs31
  have hAda : A * (da + dh) = 0 := by
    rw [hdc, hdi] at hcUWs30
    linear_combination (12 : K)⁻¹ * hcUWs30
  have hBda : B * (da + dh) = 0 := by
    rw [hdc, hde, hdk_da] at hcVWt03
    linear_combination (-144 : K)⁻¹ * hcVWt03
  have hda : da = -dh := by
    rcases hAB with hA | hB
    · exact eq_neg_of_add_eq_zero_left ((mul_eq_zero.mp hAda).resolve_left hA)
    · exact eq_neg_of_add_eq_zero_left ((mul_eq_zero.mp hBda).resolve_left hB)
  have hdk : dk = -B * dh := by rw [hdk_da, hda]; ring
  exact by simp [hda, hdb, hdc, hdd, hde, hdf, hdi, hdj, hdk]

/--
The ten coefficient equations used by the `A != 0` chart of the rank certificate, together with
the two extra equations which cover the `A = 0` chart.  The variables `da,...,dk` are the ten
coefficients of a tangent cubic, and `mu` is the infinitesimal target scalar.
-/
theorem tangent_eq_smul_of_residualU_equations
    (A B da db dc dd de df dh di dj dk mu : K)
    (hdisc : discr A B ≠ 0)
    (h00 : -3 * dc = 0)
    (h01 : 36 * A * dd + 6 * df = 0)
    (h02 : -24 * A * da + 18 * B * dc + 24 * A * dh - 12 * di - 12 * A * mu = 0)
    (h03 : -4 * A ^ 2 * db - 18 * B * df + 12 * A * dj = 0)
    (h10 : 8 * da - 12 * dh + 4 * mu = 0)
    (h11 : 10 * A * db + 54 * B * dd - 6 * dj = 0)
    (h12 : -72 * B * da - 8 * A ^ 2 * dc + 4 * A * de + 72 * B * dh -
      36 * dk - 36 * B * mu = 0)
    (h13 : -6 * A * B * db + 2 * discr A B * dd + 4 * A ^ 2 * df + 18 * B * dj = 0)
    (h20 : -6 * A * dc + 4 * de = 0)
    (h21 : 24 * B * db + 12 * A ^ 2 * dd + 10 * A * df = 0)
    (h22 : 4 * A ^ 2 * da - 6 * A * B * dc - 12 * B * de - 8 * A ^ 2 * dh +
      8 * A * di + 4 * A ^ 2 * mu = 0)
    (h40 : 4 * B * da + A ^ 2 * dc - 12 * B * dh + 4 * dk + 4 * B * mu = 0) :
    da = -dh /\ db = 0 /\ dc = 0 /\ dd = 0 /\ de = 0 /\ df = 0 /\
      di = -A * dh /\ dj = 0 /\ dk = -B * dh /\ mu = 5 * dh := by
  have hdc : dc = 0 := by
    linear_combination (-3 : K)⁻¹ * h00
  have hdf : df = -6 * A * dd := by
    linear_combination (6 : K)⁻¹ * h01
  have hmu : mu = -2 * da + 3 * dh := by
    linear_combination (4 : K)⁻¹ * h10
  have hdi : di = -A * dh := by
    rw [hdc, hmu] at h02
    linear_combination (-12 : K)⁻¹ * h02
  have hde : de = 0 := by
    rw [hdc] at h20
    linear_combination (4 : K)⁻¹ * h20
  have hdk : dk = -B * dh := by
    rw [hdc, hde, hmu] at h12
    linear_combination (-36 : K)⁻¹ * h12
  have hdj : dj = (5 * A * db) / 3 + 9 * B * dd := by
    linear_combination (-6 : K)⁻¹ * h11
  have hrel21 : B * db = 2 * A ^ 2 * dd := by
    rw [hdf] at h21
    linear_combination (24 : K)⁻¹ * h21
  have hdd_disc : discr A B * dd = 0 := by
    rw [hdf, hdj] at h13
    linear_combination (1 / 8 : K) * h13 - 3 * A * hrel21
  have hdd : dd = 0 := (mul_eq_zero.mp hdd_disc).resolve_left hdisc
  have hdf0 : df = 0 := by simp [hdf, hdd]
  have hBdb : B * db = 0 := by rw [hrel21, hdd, mul_zero]
  have hA2db : A ^ 2 * db = 0 := by
    rw [hdf0, hdj, hdd] at h03
    norm_num at h03
    linear_combination (16 : K)⁻¹ * h03
  have hdb : db = 0 := by
    by_cases hA : A = 0
    · have hB : B ≠ 0 := by
        intro hB
        apply hdisc
        simp [discr, hA, hB]
      exact (mul_eq_zero.mp hBdb).resolve_left hB
    · have hA2 : A ^ 2 ≠ 0 := pow_ne_zero 2 hA
      exact (mul_eq_zero.mp hA2db).resolve_left hA2
  have hdj0 : dj = 0 := by rw [hdj, hdb, hdd]; norm_num
  have hAda : A ^ 2 * (da + dh) = 0 := by
    rw [hdc, hde, hdi, hmu] at h22
    linear_combination (-1 / 4 : K) * h22
  have hBda : B * (da + dh) = 0 := by
    rw [hdc, hdk, hmu] at h40
    linear_combination (-1 / 4 : K) * h40
  have hda : da = -dh := by
    by_cases hA : A = 0
    · have hB : B ≠ 0 := by
        intro hB
        apply hdisc
        simp [discr, hA, hB]
      have := (mul_eq_zero.mp hBda).resolve_left hB
      exact eq_neg_of_add_eq_zero_left this
    · have hA2 : A ^ 2 ≠ 0 := pow_ne_zero 2 hA
      have := (mul_eq_zero.mp hAda).resolve_left hA2
      exact eq_neg_of_add_eq_zero_left this
  have hmu5 : mu = 5 * dh := by rw [hmu, hda]; ring
  exact by simp [hda, hdb, hdc, hdd, hde, hdf0, hdi, hdj0, hdk, hmu5]

end BConicBundleMultisections.WeierstrassResidualInfinitesimalCertificate
