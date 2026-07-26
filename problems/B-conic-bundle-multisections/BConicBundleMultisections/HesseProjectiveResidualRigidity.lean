/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.HesseFullResidualRigidity

/-!
# Projective residual-map rigidity in Hesse coordinates

This module upgrades affine scalar rigidity to projective rigidity.  For three arbitrary
quartics `D_U,D_V,D_W`, the two cross-product identities with the normalized Hesse residual
triple, together with the normalization that the constant coefficient of `D_W` is zero,
force every coefficient of all three quartics to vanish.

The proof is global over every characteristic-zero field.  It first extracts the 88
cross-product coefficients by exact degree-eight interpolation and then replays a sparse
left inverse over `QQ[lam]` with `linear_combination`.  Thus no localization, generic-rank
argument, radical computation, or smoothness condition on `lam` is used.
-/

@[expose] public section

namespace BConicBundleMultisections.HesseProjectiveResidualRigidity

universe u

open HesseFullResidualRigidity

variable {R : Type u} [CommRing R]

set_option linter.unusedVariables false

abbrev quartic (c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 s t : R) : R :=
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
  c14

abbrev octic (c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 s t : R) : R :=
  c0 * s^8 +
  c1 * s^7 * t^1 +
  c2 * s^7 +
  c3 * s^6 * t^2 +
  c4 * s^6 * t^1 +
  c5 * s^6 +
  c6 * s^5 * t^3 +
  c7 * s^5 * t^2 +
  c8 * s^5 * t^1 +
  c9 * s^5 +
  c10 * s^4 * t^4 +
  c11 * s^4 * t^3 +
  c12 * s^4 * t^2 +
  c13 * s^4 * t^1 +
  c14 * s^4 +
  c15 * s^3 * t^5 +
  c16 * s^3 * t^4 +
  c17 * s^3 * t^3 +
  c18 * s^3 * t^2 +
  c19 * s^3 * t^1 +
  c20 * s^3 +
  c21 * s^2 * t^6 +
  c22 * s^2 * t^5 +
  c23 * s^2 * t^4 +
  c24 * s^2 * t^3 +
  c25 * s^2 * t^2 +
  c26 * s^2 * t^1 +
  c27 * s^2 +
  c28 * s^1 * t^7 +
  c29 * s^1 * t^6 +
  c30 * s^1 * t^5 +
  c31 * s^1 * t^4 +
  c32 * s^1 * t^3 +
  c33 * s^1 * t^2 +
  c34 * s^1 * t^1 +
  c35 * s^1 +
  c36 * t^8 +
  c37 * t^7 +
  c38 * t^6 +
  c39 * t^5 +
  c40 * t^4 +
  c41 * t^3 +
  c42 * t^2 +
  c43 * t^1 +
  c44

theorem crossU_sub_eq_octic (c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 lam s t : R) :
    quartic c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 s t * hesseQuarticW lam s t -
      quartic c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 s t * hesseQuarticU lam s t =
      octic (-c30) (-c31) (2*c0 - c32) (3*c0*lam - c33) (2*c1 - c34) (2*c2 - c35) (3*c1*lam + 2*c30 - c36) (3*c2*lam + 2*c3 - c37) (-c38 + 2*c4) (-2*c30 - c39 + 2*c5) (3*c3*lam + 2*c31 - c40) (2*c0 + 2*c32 + 3*c4*lam - c41 + 2*c6) (-3*c30*lam - c42 + 3*c5*lam + 2*c7) (-2*c31 - c43 + 2*c8) (c0 - 2*c32 - c44 + 2*c9) (2*c33 + 3*c6*lam) (2*c1 + 2*c10 + 2*c34 + 3*c7*lam) (2*c11 + 2*c2 - 3*c31*lam + 2*c35 + 3*c8*lam) (2*c12 - 3*c32*lam - 2*c33 + 3*c9*lam) (c1 + 2*c13 - 2*c34) (2*c14 + c2 - 2*c35) (3*c10*lam + 2*c36) (3*c11*lam + 2*c3 + 2*c37) (3*c12*lam - 3*c33*lam + 2*c38 + 2*c4) (3*c13*lam - 3*c34*lam - 2*c36 + 2*c39 + 2*c5) (3*c14*lam + c3 - 3*c35*lam - 2*c37) (-2*c38 + c4) (-2*c39 + c5) (2*c40) (2*c41 + 2*c6) (-3*c36*lam + 2*c42 + 2*c7) (-3*c37*lam - 2*c40 + 2*c43 + 2*c8) (-3*c38*lam - 2*c41 + 2*c44 + c6 + 2*c9) (-3*c39*lam - 2*c42 + c7) (-2*c43 + c8) (-2*c44 + c9) (0) (2*c10) (2*c11 - 3*c40*lam) (2*c12 - 3*c41*lam) (c10 + 2*c13 - 3*c42*lam) (c11 + 2*c14 - 3*c43*lam) (c12 - 3*c44*lam) (c13) (c14) s t := by
  simp only [quartic, octic, hesseQuarticU, hesseQuarticW]
  ring

theorem crossV_sub_eq_octic (c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 lam s t : R) :
    quartic c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 s t * hesseQuarticW lam s t -
      quartic c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 s t * hesseQuarticV lam s t =
      octic (0) (2*c30) (2*c15) (3*c15*lam + 2*c31) (2*c16 + 2*c32) (2*c17 - 3*c30*lam) (3*c16*lam + 2*c33) (3*c17*lam + 2*c18 + 2*c34) (2*c19 - 3*c31*lam + 2*c35) (2*c20 - 3*c32*lam) (3*c18*lam - c30 + 2*c36) (2*c15 + 3*c19*lam + 2*c21 + 2*c37) (3*c20*lam + 2*c22 - 3*c33*lam + 2*c38) (2*c23 - 2*c30 - 3*c34*lam + 2*c39) (c15 + 2*c24 - 3*c35*lam) (3*c21*lam - c31 + 2*c40) (2*c16 + 3*c22*lam + 2*c25 - c32 + 2*c41) (2*c17 + 3*c23*lam + 2*c26 - 3*c36*lam + 2*c42) (3*c24*lam + 2*c27 - 2*c31 - 3*c37*lam + 2*c43) (c16 + 2*c28 - 2*c32 - 3*c38*lam + 2*c44) (c17 + 2*c29 - 3*c39*lam) (3*c25*lam - c33) (2*c18 + 3*c26*lam - c34) (2*c19 + 3*c27*lam - c35 - 3*c40*lam) (2*c20 + 3*c28*lam - 2*c33 - 3*c41*lam) (c18 + 3*c29*lam - 2*c34 - 3*c42*lam) (c19 - 2*c35 - 3*c43*lam) (c20 - 3*c44*lam) (-c36) (2*c21 - c37) (2*c22 - c38) (2*c23 - 2*c36 - c39) (c21 + 2*c24 - 2*c37) (c22 - 2*c38) (c23 - 2*c39) (c24) (-c40) (2*c25 - c41) (2*c26 - c42) (2*c27 - 2*c40 - c43) (c25 + 2*c28 - 2*c41 - c44) (c26 + 2*c29 - 2*c42) (c27 - 2*c43) (c28 - 2*c44) (c29) s t := by
  simp only [quartic, octic, hesseQuarticV, hesseQuarticW]
  ring

structure CrossEquations (c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 lam : R) : Prop where
  h0 : -c30 = 0
  h1 : -c31 = 0
  h2 : 2*c0 - c32 = 0
  h3 : 3*c0*lam - c33 = 0
  h4 : 2*c1 - c34 = 0
  h5 : 2*c2 - c35 = 0
  h6 : 3*c1*lam + 2*c30 - c36 = 0
  h7 : 3*c2*lam + 2*c3 - c37 = 0
  h8 : -c38 + 2*c4 = 0
  h9 : -2*c30 - c39 + 2*c5 = 0
  h10 : 3*c3*lam + 2*c31 - c40 = 0
  h11 : 2*c0 + 2*c32 + 3*c4*lam - c41 + 2*c6 = 0
  h12 : -3*c30*lam - c42 + 3*c5*lam + 2*c7 = 0
  h13 : -2*c31 - c43 + 2*c8 = 0
  h14 : c0 - 2*c32 - c44 + 2*c9 = 0
  h15 : 2*c33 + 3*c6*lam = 0
  h16 : 2*c1 + 2*c10 + 2*c34 + 3*c7*lam = 0
  h17 : 2*c11 + 2*c2 - 3*c31*lam + 2*c35 + 3*c8*lam = 0
  h18 : 2*c12 - 3*c32*lam - 2*c33 + 3*c9*lam = 0
  h19 : c1 + 2*c13 - 2*c34 = 0
  h20 : 2*c14 + c2 - 2*c35 = 0
  h21 : 3*c10*lam + 2*c36 = 0
  h22 : 3*c11*lam + 2*c3 + 2*c37 = 0
  h23 : 3*c12*lam - 3*c33*lam + 2*c38 + 2*c4 = 0
  h24 : 3*c13*lam - 3*c34*lam - 2*c36 + 2*c39 + 2*c5 = 0
  h25 : 3*c14*lam + c3 - 3*c35*lam - 2*c37 = 0
  h26 : -2*c38 + c4 = 0
  h27 : -2*c39 + c5 = 0
  h28 : 2*c40 = 0
  h29 : 2*c41 + 2*c6 = 0
  h30 : -3*c36*lam + 2*c42 + 2*c7 = 0
  h31 : -3*c37*lam - 2*c40 + 2*c43 + 2*c8 = 0
  h32 : -3*c38*lam - 2*c41 + 2*c44 + c6 + 2*c9 = 0
  h33 : -3*c39*lam - 2*c42 + c7 = 0
  h34 : -2*c43 + c8 = 0
  h35 : -2*c44 + c9 = 0
  h36 : 2*c10 = 0
  h37 : 2*c11 - 3*c40*lam = 0
  h38 : 2*c12 - 3*c41*lam = 0
  h39 : c10 + 2*c13 - 3*c42*lam = 0
  h40 : c11 + 2*c14 - 3*c43*lam = 0
  h41 : c12 - 3*c44*lam = 0
  h42 : c13 = 0
  h43 : c14 = 0
  h44 : 2*c30 = 0
  h45 : 2*c15 = 0
  h46 : 3*c15*lam + 2*c31 = 0
  h47 : 2*c16 + 2*c32 = 0
  h48 : 2*c17 - 3*c30*lam = 0
  h49 : 3*c16*lam + 2*c33 = 0
  h50 : 3*c17*lam + 2*c18 + 2*c34 = 0
  h51 : 2*c19 - 3*c31*lam + 2*c35 = 0
  h52 : 2*c20 - 3*c32*lam = 0
  h53 : 3*c18*lam - c30 + 2*c36 = 0
  h54 : 2*c15 + 3*c19*lam + 2*c21 + 2*c37 = 0
  h55 : 3*c20*lam + 2*c22 - 3*c33*lam + 2*c38 = 0
  h56 : 2*c23 - 2*c30 - 3*c34*lam + 2*c39 = 0
  h57 : c15 + 2*c24 - 3*c35*lam = 0
  h58 : 3*c21*lam - c31 + 2*c40 = 0
  h59 : 2*c16 + 3*c22*lam + 2*c25 - c32 + 2*c41 = 0
  h60 : 2*c17 + 3*c23*lam + 2*c26 - 3*c36*lam + 2*c42 = 0
  h61 : 3*c24*lam + 2*c27 - 2*c31 - 3*c37*lam + 2*c43 = 0
  h62 : c16 + 2*c28 - 2*c32 - 3*c38*lam + 2*c44 = 0
  h63 : c17 + 2*c29 - 3*c39*lam = 0
  h64 : 3*c25*lam - c33 = 0
  h65 : 2*c18 + 3*c26*lam - c34 = 0
  h66 : 2*c19 + 3*c27*lam - c35 - 3*c40*lam = 0
  h67 : 2*c20 + 3*c28*lam - 2*c33 - 3*c41*lam = 0
  h68 : c18 + 3*c29*lam - 2*c34 - 3*c42*lam = 0
  h69 : c19 - 2*c35 - 3*c43*lam = 0
  h70 : c20 - 3*c44*lam = 0
  h71 : -c36 = 0
  h72 : 2*c21 - c37 = 0
  h73 : 2*c22 - c38 = 0
  h74 : 2*c23 - 2*c36 - c39 = 0
  h75 : c21 + 2*c24 - 2*c37 = 0
  h76 : c22 - 2*c38 = 0
  h77 : c23 - 2*c39 = 0
  h78 : c24 = 0
  h79 : -c40 = 0
  h80 : 2*c25 - c41 = 0
  h81 : 2*c26 - c42 = 0
  h82 : 2*c27 - 2*c40 - c43 = 0
  h83 : c25 + 2*c28 - 2*c41 - c44 = 0
  h84 : c26 + 2*c29 - 2*c42 = 0
  h85 : c27 - 2*c43 = 0
  h86 : c28 - 2*c44 = 0
  h87 : c29 = 0
  h88 : c44 = 0

variable {R : Type u} [Field R] [CharZero R]

set_option maxRecDepth 100000 in
set_option maxHeartbeats 16000000 in
/-- Exact interpolation on the 45 integral points `0 <= s,t` and `s+t <= 8`. -/
theorem octic_coefficients_eq_zero (c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 : R)
    (hzero : ∀ s t : R, octic (c0) (c1) (c2) (c3) (c4) (c5) (c6) (c7) (c8) (c9) (c10) (c11) (c12) (c13) (c14) (c15) (c16) (c17) (c18) (c19) (c20) (c21) (c22) (c23) (c24) (c25) (c26) (c27) (c28) (c29) (c30) (c31) (c32) (c33) (c34) (c35) (c36) (c37) (c38) (c39) (c40) (c41) (c42) (c43) (c44) s t = 0) :
    c0 = 0 ∧ c1 = 0 ∧ c2 = 0 ∧ c3 = 0 ∧ c4 = 0 ∧ c5 = 0 ∧ c6 = 0 ∧ c7 = 0 ∧ c8 = 0 ∧ c9 = 0 ∧ c10 = 0 ∧ c11 = 0 ∧ c12 = 0 ∧ c13 = 0 ∧ c14 = 0 ∧ c15 = 0 ∧ c16 = 0 ∧ c17 = 0 ∧ c18 = 0 ∧ c19 = 0 ∧ c20 = 0 ∧ c21 = 0 ∧ c22 = 0 ∧ c23 = 0 ∧ c24 = 0 ∧ c25 = 0 ∧ c26 = 0 ∧ c27 = 0 ∧ c28 = 0 ∧ c29 = 0 ∧ c30 = 0 ∧ c31 = 0 ∧ c32 = 0 ∧ c33 = 0 ∧ c34 = 0 ∧ c35 = 0 ∧ c36 = 0 ∧ c37 = 0 ∧ c38 = 0 ∧ c39 = 0 ∧ c40 = 0 ∧ c41 = 0 ∧ c42 = 0 ∧ c43 = 0 ∧ c44 = 0 := by
  have hc0 : c0 = 0 := by
    linear_combination
      (1/40320) * (hzero 0 0) +
      (-1/5040) * (hzero 1 0) +
      (1/1440) * (hzero 2 0) +
      (-1/720) * (hzero 3 0) +
      (1/576) * (hzero 4 0) +
      (-1/720) * (hzero 5 0) +
      (1/1440) * (hzero 6 0) +
      (-1/5040) * (hzero 7 0) +
      (1/40320) * (hzero 8 0)
  have hc1 : c1 = 0 := by
    linear_combination
      (1/5040) * (hzero 0 0) +
      (-1/5040) * (hzero 0 1) +
      (-1/720) * (hzero 1 0) +
      (1/720) * (hzero 1 1) +
      (1/240) * (hzero 2 0) +
      (-1/240) * (hzero 2 1) +
      (-1/144) * (hzero 3 0) +
      (1/144) * (hzero 3 1) +
      (1/144) * (hzero 4 0) +
      (-1/144) * (hzero 4 1) +
      (-1/240) * (hzero 5 0) +
      (1/240) * (hzero 5 1) +
      (1/720) * (hzero 6 0) +
      (-1/720) * (hzero 6 1) +
      (-1/5040) * (hzero 7 0) +
      (1/5040) * (hzero 7 1)
  have hc2 : c2 = 0 := by
    linear_combination
      (-1/1120) * (hzero 0 0) +
      (1/144) * (hzero 1 0) +
      (-17/720) * (hzero 2 0) +
      (11/240) * (hzero 3 0) +
      (-1/18) * (hzero 4 0) +
      (31/720) * (hzero 5 0) +
      (-1/48) * (hzero 6 0) +
      (29/5040) * (hzero 7 0) +
      (-1/1440) * (hzero 8 0)
  have hc3 : c3 = 0 := by
    linear_combination
      (1/1440) * (hzero 0 0) +
      (-1/720) * (hzero 0 1) +
      (1/1440) * (hzero 0 2) +
      (-1/240) * (hzero 1 0) +
      (1/120) * (hzero 1 1) +
      (-1/240) * (hzero 1 2) +
      (1/96) * (hzero 2 0) +
      (-1/48) * (hzero 2 1) +
      (1/96) * (hzero 2 2) +
      (-1/72) * (hzero 3 0) +
      (1/36) * (hzero 3 1) +
      (-1/72) * (hzero 3 2) +
      (1/96) * (hzero 4 0) +
      (-1/48) * (hzero 4 1) +
      (1/96) * (hzero 4 2) +
      (-1/240) * (hzero 5 0) +
      (1/120) * (hzero 5 1) +
      (-1/240) * (hzero 5 2) +
      (1/1440) * (hzero 6 0) +
      (-1/720) * (hzero 6 1) +
      (1/1440) * (hzero 6 2)
  have hc4 : c4 = 0 := by
    linear_combination
      (-1/160) * (hzero 0 0) +
      (1/144) * (hzero 0 1) +
      (-1/1440) * (hzero 0 2) +
      (1/24) * (hzero 1 0) +
      (-11/240) * (hzero 1 1) +
      (1/240) * (hzero 1 2) +
      (-19/160) * (hzero 2 0) +
      (31/240) * (hzero 2 1) +
      (-1/96) * (hzero 2 2) +
      (3/16) * (hzero 3 0) +
      (-29/144) * (hzero 3 1) +
      (1/72) * (hzero 3 2) +
      (-17/96) * (hzero 4 0) +
      (3/16) * (hzero 4 1) +
      (-1/96) * (hzero 4 2) +
      (1/10) * (hzero 5 0) +
      (-5/48) * (hzero 5 1) +
      (1/240) * (hzero 5 2) +
      (-1/32) * (hzero 6 0) +
      (23/720) * (hzero 6 1) +
      (-1/1440) * (hzero 6 2) +
      (1/240) * (hzero 7 0) +
      (-1/240) * (hzero 7 1)
  have hc5 : c5 = 0 := by
    linear_combination
      (13/960) * (hzero 0 0) +
      (-73/720) * (hzero 1 0) +
      (239/720) * (hzero 2 0) +
      (-149/240) * (hzero 3 0) +
      (209/288) * (hzero 4 0) +
      (-391/720) * (hzero 5 0) +
      (61/240) * (hzero 6 0) +
      (-49/720) * (hzero 7 0) +
      (23/2880) * (hzero 8 0)
  have hc6 : c6 = 0 := by
    linear_combination
      (1/720) * (hzero 0 0) +
      (-1/240) * (hzero 0 1) +
      (1/240) * (hzero 0 2) +
      (-1/720) * (hzero 0 3) +
      (-1/144) * (hzero 1 0) +
      (1/48) * (hzero 1 1) +
      (-1/48) * (hzero 1 2) +
      (1/144) * (hzero 1 3) +
      (1/72) * (hzero 2 0) +
      (-1/24) * (hzero 2 1) +
      (1/24) * (hzero 2 2) +
      (-1/72) * (hzero 2 3) +
      (-1/72) * (hzero 3 0) +
      (1/24) * (hzero 3 1) +
      (-1/24) * (hzero 3 2) +
      (1/72) * (hzero 3 3) +
      (1/144) * (hzero 4 0) +
      (-1/48) * (hzero 4 1) +
      (1/48) * (hzero 4 2) +
      (-1/144) * (hzero 4 3) +
      (-1/720) * (hzero 5 0) +
      (1/240) * (hzero 5 1) +
      (-1/240) * (hzero 5 2) +
      (1/720) * (hzero 5 3)
  have hc7 : c7 = 0 := by
    linear_combination
      (-3/160) * (hzero 0 0) +
      (1/24) * (hzero 0 1) +
      (-13/480) * (hzero 0 2) +
      (1/240) * (hzero 0 3) +
      (5/48) * (hzero 1 0) +
      (-11/48) * (hzero 1 1) +
      (7/48) * (hzero 1 2) +
      (-1/48) * (hzero 1 3) +
      (-23/96) * (hzero 2 0) +
      (25/48) * (hzero 2 1) +
      (-31/96) * (hzero 2 2) +
      (1/24) * (hzero 2 3) +
      (7/24) * (hzero 3 0) +
      (-5/8) * (hzero 3 1) +
      (3/8) * (hzero 3 2) +
      (-1/24) * (hzero 3 3) +
      (-19/96) * (hzero 4 0) +
      (5/12) * (hzero 4 1) +
      (-23/96) * (hzero 4 2) +
      (1/48) * (hzero 4 3) +
      (17/240) * (hzero 5 0) +
      (-7/48) * (hzero 5 1) +
      (19/240) * (hzero 5 2) +
      (-1/240) * (hzero 5 3) +
      (-1/96) * (hzero 6 0) +
      (1/48) * (hzero 6 1) +
      (-1/96) * (hzero 6 2)
  have hc8 : c8 = 0 := by
    linear_combination
      (13/160) * (hzero 0 0) +
      (-73/720) * (hzero 0 1) +
      (11/480) * (hzero 0 2) +
      (-1/360) * (hzero 0 3) +
      (-73/144) * (hzero 1 0) +
      (89/144) * (hzero 1 1) +
      (-1/8) * (hzero 1 2) +
      (1/72) * (hzero 1 3) +
      (389/288) * (hzero 2 0) +
      (-77/48) * (hzero 2 1) +
      (9/32) * (hzero 2 2) +
      (-1/36) * (hzero 2 3) +
      (-287/144) * (hzero 3 0) +
      (331/144) * (hzero 3 1) +
      (-1/3) * (hzero 3 2) +
      (1/36) * (hzero 3 3) +
      (169/96) * (hzero 4 0) +
      (-283/144) * (hzero 4 1) +
      (7/32) * (hzero 4 2) +
      (-1/72) * (hzero 4 3) +
      (-671/720) * (hzero 5 0) +
      (241/240) * (hzero 5 1) +
      (-3/40) * (hzero 5 2) +
      (1/360) * (hzero 5 3) +
      (79/288) * (hzero 6 0) +
      (-41/144) * (hzero 6 1) +
      (1/96) * (hzero 6 2) +
      (-5/144) * (hzero 7 0) +
      (5/144) * (hzero 7 1)
  have hc9 : c9 = 0 := by
    linear_combination
      (-9/80) * (hzero 0 0) +
      (115/144) * (hzero 1 0) +
      (-179/72) * (hzero 2 0) +
      (71/16) * (hzero 3 0) +
      (-179/36) * (hzero 4 0) +
      (2581/720) * (hzero 5 0) +
      (-13/8) * (hzero 6 0) +
      (61/144) * (hzero 7 0) +
      (-7/144) * (hzero 8 0)
  have hc10 : c10 = 0 := by
    linear_combination
      (1/576) * (hzero 0 0) +
      (-1/144) * (hzero 0 1) +
      (1/96) * (hzero 0 2) +
      (-1/144) * (hzero 0 3) +
      (1/576) * (hzero 0 4) +
      (-1/144) * (hzero 1 0) +
      (1/36) * (hzero 1 1) +
      (-1/24) * (hzero 1 2) +
      (1/36) * (hzero 1 3) +
      (-1/144) * (hzero 1 4) +
      (1/96) * (hzero 2 0) +
      (-1/24) * (hzero 2 1) +
      (1/16) * (hzero 2 2) +
      (-1/24) * (hzero 2 3) +
      (1/96) * (hzero 2 4) +
      (-1/144) * (hzero 3 0) +
      (1/36) * (hzero 3 1) +
      (-1/24) * (hzero 3 2) +
      (1/36) * (hzero 3 3) +
      (-1/144) * (hzero 3 4) +
      (1/576) * (hzero 4 0) +
      (-1/144) * (hzero 4 1) +
      (1/96) * (hzero 4 2) +
      (-1/144) * (hzero 4 3) +
      (1/576) * (hzero 4 4)
  have hc11 : c11 = 0 := by
    linear_combination
      (-1/32) * (hzero 0 0) +
      (5/48) * (hzero 0 1) +
      (-1/8) * (hzero 0 2) +
      (1/16) * (hzero 0 3) +
      (-1/96) * (hzero 0 4) +
      (5/36) * (hzero 1 0) +
      (-11/24) * (hzero 1 1) +
      (13/24) * (hzero 1 2) +
      (-19/72) * (hzero 1 3) +
      (1/24) * (hzero 1 4) +
      (-35/144) * (hzero 2 0) +
      (19/24) * (hzero 2 1) +
      (-11/12) * (hzero 2 2) +
      (31/72) * (hzero 2 3) +
      (-1/16) * (hzero 2 4) +
      (5/24) * (hzero 3 0) +
      (-2/3) * (hzero 3 1) +
      (3/4) * (hzero 3 2) +
      (-1/3) * (hzero 3 3) +
      (1/24) * (hzero 3 4) +
      (-25/288) * (hzero 4 0) +
      (13/48) * (hzero 4 1) +
      (-7/24) * (hzero 4 2) +
      (17/144) * (hzero 4 3) +
      (-1/96) * (hzero 4 4) +
      (1/72) * (hzero 5 0) +
      (-1/24) * (hzero 5 1) +
      (1/24) * (hzero 5 2) +
      (-1/72) * (hzero 5 3)
  have hc12 : c12 = 0 := by
    linear_combination
      (13/64) * (hzero 0 0) +
      (-73/144) * (hzero 0 1) +
      (61/144) * (hzero 0 2) +
      (-5/36) * (hzero 0 3) +
      (11/576) * (hzero 0 4) +
      (-73/72) * (hzero 1 0) +
      (89/36) * (hzero 1 1) +
      (-95/48) * (hzero 1 2) +
      (43/72) * (hzero 1 3) +
      (-11/144) * (hzero 1 4) +
      (25/12) * (hzero 2 0) +
      (-79/16) * (hzero 2 1) +
      (359/96) * (hzero 2 2) +
      (-1) * (hzero 2 3) +
      (11/96) * (hzero 2 4) +
      (-325/144) * (hzero 3 0) +
      (31/6) * (hzero 3 1) +
      (-131/36) * (hzero 3 2) +
      (29/36) * (hzero 3 3) +
      (-11/144) * (hzero 3 4) +
      (785/576) * (hzero 4 0) +
      (-431/144) * (hzero 4 1) +
      (23/12) * (hzero 4 2) +
      (-11/36) * (hzero 4 3) +
      (11/576) * (hzero 4 4) +
      (-7/16) * (hzero 5 0) +
      (11/12) * (hzero 5 1) +
      (-25/48) * (hzero 5 2) +
      (1/24) * (hzero 5 3) +
      (17/288) * (hzero 6 0) +
      (-17/144) * (hzero 6 1) +
      (17/288) * (hzero 6 2)
  have hc13 : c13 = 0 := by
    linear_combination
      (-9/16) * (hzero 0 0) +
      (115/144) * (hzero 0 1) +
      (-89/288) * (hzero 0 2) +
      (1/12) * (hzero 0 3) +
      (-1/96) * (hzero 0 4) +
      (115/36) * (hzero 1 0) +
      (-209/48) * (hzero 1 1) +
      (71/48) * (hzero 1 2) +
      (-13/36) * (hzero 1 3) +
      (1/24) * (hzero 1 4) +
      (-2237/288) * (hzero 2 0) +
      (485/48) * (hzero 2 1) +
      (-277/96) * (hzero 2 2) +
      (11/18) * (hzero 2 3) +
      (-1/16) * (hzero 2 4) +
      (505/48) * (hzero 3 0) +
      (-1871/144) * (hzero 3 1) +
      (211/72) * (hzero 3 2) +
      (-1/2) * (hzero 3 3) +
      (1/24) * (hzero 3 4) +
      (-155/18) * (hzero 4 0) +
      (161/16) * (hzero 4 1) +
      (-157/96) * (hzero 4 2) +
      (7/36) * (hzero 4 3) +
      (-1/96) * (hzero 4 4) +
      (77/18) * (hzero 5 0) +
      (-227/48) * (hzero 5 1) +
      (23/48) * (hzero 5 2) +
      (-1/36) * (hzero 5 3) +
      (-115/96) * (hzero 6 0) +
      (181/144) * (hzero 6 1) +
      (-17/288) * (hzero 6 2) +
      (7/48) * (hzero 7 0) +
      (-7/48) * (hzero 7 1)
  have hc14 : c14 = 0 := by
    linear_combination
      (1069/1920) * (hzero 0 0) +
      (-329/90) * (hzero 1 0) +
      (15289/1440) * (hzero 2 0) +
      (-268/15) * (hzero 3 0) +
      (10993/576) * (hzero 4 0) +
      (-1193/90) * (hzero 5 0) +
      (2803/480) * (hzero 6 0) +
      (-67/45) * (hzero 7 0) +
      (967/5760) * (hzero 8 0)
  have hc15 : c15 = 0 := by
    linear_combination
      (1/720) * (hzero 0 0) +
      (-1/144) * (hzero 0 1) +
      (1/72) * (hzero 0 2) +
      (-1/72) * (hzero 0 3) +
      (1/144) * (hzero 0 4) +
      (-1/720) * (hzero 0 5) +
      (-1/240) * (hzero 1 0) +
      (1/48) * (hzero 1 1) +
      (-1/24) * (hzero 1 2) +
      (1/24) * (hzero 1 3) +
      (-1/48) * (hzero 1 4) +
      (1/240) * (hzero 1 5) +
      (1/240) * (hzero 2 0) +
      (-1/48) * (hzero 2 1) +
      (1/24) * (hzero 2 2) +
      (-1/24) * (hzero 2 3) +
      (1/48) * (hzero 2 4) +
      (-1/240) * (hzero 2 5) +
      (-1/720) * (hzero 3 0) +
      (1/144) * (hzero 3 1) +
      (-1/72) * (hzero 3 2) +
      (1/72) * (hzero 3 3) +
      (-1/144) * (hzero 3 4) +
      (1/720) * (hzero 3 5)
  have hc16 : c16 = 0 := by
    linear_combination
      (-1/32) * (hzero 0 0) +
      (5/36) * (hzero 0 1) +
      (-35/144) * (hzero 0 2) +
      (5/24) * (hzero 0 3) +
      (-25/288) * (hzero 0 4) +
      (1/72) * (hzero 0 5) +
      (5/48) * (hzero 1 0) +
      (-11/24) * (hzero 1 1) +
      (19/24) * (hzero 1 2) +
      (-2/3) * (hzero 1 3) +
      (13/48) * (hzero 1 4) +
      (-1/24) * (hzero 1 5) +
      (-1/8) * (hzero 2 0) +
      (13/24) * (hzero 2 1) +
      (-11/12) * (hzero 2 2) +
      (3/4) * (hzero 2 3) +
      (-7/24) * (hzero 2 4) +
      (1/24) * (hzero 2 5) +
      (1/16) * (hzero 3 0) +
      (-19/72) * (hzero 3 1) +
      (31/72) * (hzero 3 2) +
      (-1/3) * (hzero 3 3) +
      (17/144) * (hzero 3 4) +
      (-1/72) * (hzero 3 5) +
      (-1/96) * (hzero 4 0) +
      (1/24) * (hzero 4 1) +
      (-1/16) * (hzero 4 2) +
      (1/24) * (hzero 4 3) +
      (-1/96) * (hzero 4 4)
  have hc17 : c17 = 0 := by
    linear_combination
      (13/48) * (hzero 0 0) +
      (-73/72) * (hzero 0 1) +
      (211/144) * (hzero 0 2) +
      (-49/48) * (hzero 0 3) +
      (25/72) * (hzero 0 4) +
      (-7/144) * (hzero 0 5) +
      (-73/72) * (hzero 1 0) +
      (89/24) * (hzero 1 1) +
      (-83/16) * (hzero 1 2) +
      (497/144) * (hzero 1 3) +
      (-53/48) * (hzero 1 4) +
      (7/48) * (hzero 1 5) +
      (211/144) * (hzero 2 0) +
      (-83/16) * (hzero 2 1) +
      (83/12) * (hzero 2 2) +
      (-77/18) * (hzero 2 3) +
      (59/48) * (hzero 2 4) +
      (-7/48) * (hzero 2 5) +
      (-49/48) * (hzero 3 0) +
      (497/144) * (hzero 3 1) +
      (-77/18) * (hzero 3 2) +
      (7/3) * (hzero 3 3) +
      (-77/144) * (hzero 3 4) +
      (7/144) * (hzero 3 5) +
      (25/72) * (hzero 4 0) +
      (-53/48) * (hzero 4 1) +
      (59/48) * (hzero 4 2) +
      (-77/144) * (hzero 4 3) +
      (1/16) * (hzero 4 4) +
      (-7/144) * (hzero 5 0) +
      (7/48) * (hzero 5 1) +
      (-7/48) * (hzero 5 2) +
      (7/144) * (hzero 5 3)
  have hc18 : c18 = 0 := by
    linear_combination
      (-9/8) * (hzero 0 0) +
      (115/36) * (hzero 0 1) +
      (-983/288) * (hzero 0 2) +
      (29/16) * (hzero 0 3) +
      (-155/288) * (hzero 0 4) +
      (5/72) * (hzero 0 5) +
      (115/24) * (hzero 1 0) +
      (-209/16) * (hzero 1 1) +
      (209/16) * (hzero 1 2) +
      (-101/16) * (hzero 1 3) +
      (83/48) * (hzero 1 4) +
      (-5/24) * (hzero 1 5) +
      (-805/96) * (hzero 2 0) +
      (347/16) * (hzero 2 1) +
      (-1897/96) * (hzero 2 2) +
      (197/24) * (hzero 2 3) +
      (-47/24) * (hzero 2 4) +
      (5/24) * (hzero 2 5) +
      (125/16) * (hzero 3 0) +
      (-341/18) * (hzero 3 1) +
      (547/36) * (hzero 3 2) +
      (-39/8) * (hzero 3 3) +
      (127/144) * (hzero 3 4) +
      (-5/72) * (hzero 3 5) +
      (-25/6) * (hzero 4 0) +
      (113/12) * (hzero 4 1) +
      (-619/96) * (hzero 4 2) +
      (21/16) * (hzero 4 3) +
      (-11/96) * (hzero 4 4) +
      (59/48) * (hzero 5 0) +
      (-125/48) * (hzero 5 1) +
      (73/48) * (hzero 5 2) +
      (-7/48) * (hzero 5 3) +
      (-5/32) * (hzero 6 0) +
      (5/16) * (hzero 6 1) +
      (-5/32) * (hzero 6 2)
  have hc19 : c19 = 0 := by
    linear_combination
      (1069/480) * (hzero 0 0) +
      (-329/90) * (hzero 0 1) +
      (209/96) * (hzero 0 2) +
      (-71/72) * (hzero 0 3) +
      (13/48) * (hzero 0 4) +
      (-1/30) * (hzero 0 5) +
      (-329/30) * (hzero 1 0) +
      (6077/360) * (hzero 1 1) +
      (-69/8) * (hzero 1 2) +
      (251/72) * (hzero 1 3) +
      (-7/8) * (hzero 1 4) +
      (1/10) * (hzero 1 5) +
      (33713/1440) * (hzero 2 0) +
      (-4007/120) * (hzero 2 1) +
      (439/32) * (hzero 2 2) +
      (-167/36) * (hzero 2 3) +
      (1) * (hzero 2 4) +
      (-1/10) * (hzero 2 5) +
      (-10247/360) * (hzero 3 0) +
      (1345/36) * (hzero 3 1) +
      (-34/3) * (hzero 3 2) +
      (103/36) * (hzero 3 3) +
      (-11/24) * (hzero 3 4) +
      (1/30) * (hzero 3 5) +
      (6193/288) * (hzero 4 0) +
      (-937/36) * (hzero 4 1) +
      (169/32) * (hzero 4 2) +
      (-59/72) * (hzero 4 3) +
      (1/16) * (hzero 4 4) +
      (-3641/360) * (hzero 5 0) +
      (1367/120) * (hzero 5 1) +
      (-11/8) * (hzero 5 2) +
      (7/72) * (hzero 5 3) +
      (3923/1440) * (hzero 6 0) +
      (-1037/360) * (hzero 6 1) +
      (5/32) * (hzero 6 2) +
      (-29/90) * (hzero 7 0) +
      (29/90) * (hzero 7 1)
  have hc20 : c20 = 0 := by
    linear_combination
      (-267/160) * (hzero 0 0) +
      (349/36) * (hzero 1 0) +
      (-18353/720) * (hzero 2 0) +
      (797/20) * (hzero 3 0) +
      (-1457/36) * (hzero 4 0) +
      (4891/180) * (hzero 5 0) +
      (-187/16) * (hzero 6 0) +
      (527/180) * (hzero 7 0) +
      (-469/1440) * (hzero 8 0)
  have hc21 : c21 = 0 := by
    linear_combination
      (1/1440) * (hzero 0 0) +
      (-1/240) * (hzero 0 1) +
      (1/96) * (hzero 0 2) +
      (-1/72) * (hzero 0 3) +
      (1/96) * (hzero 0 4) +
      (-1/240) * (hzero 0 5) +
      (1/1440) * (hzero 0 6) +
      (-1/720) * (hzero 1 0) +
      (1/120) * (hzero 1 1) +
      (-1/48) * (hzero 1 2) +
      (1/36) * (hzero 1 3) +
      (-1/48) * (hzero 1 4) +
      (1/120) * (hzero 1 5) +
      (-1/720) * (hzero 1 6) +
      (1/1440) * (hzero 2 0) +
      (-1/240) * (hzero 2 1) +
      (1/96) * (hzero 2 2) +
      (-1/72) * (hzero 2 3) +
      (1/96) * (hzero 2 4) +
      (-1/240) * (hzero 2 5) +
      (1/1440) * (hzero 2 6)
  have hc22 : c22 = 0 := by
    linear_combination
      (-3/160) * (hzero 0 0) +
      (5/48) * (hzero 0 1) +
      (-23/96) * (hzero 0 2) +
      (7/24) * (hzero 0 3) +
      (-19/96) * (hzero 0 4) +
      (17/240) * (hzero 0 5) +
      (-1/96) * (hzero 0 6) +
      (1/24) * (hzero 1 0) +
      (-11/48) * (hzero 1 1) +
      (25/48) * (hzero 1 2) +
      (-5/8) * (hzero 1 3) +
      (5/12) * (hzero 1 4) +
      (-7/48) * (hzero 1 5) +
      (1/48) * (hzero 1 6) +
      (-13/480) * (hzero 2 0) +
      (7/48) * (hzero 2 1) +
      (-31/96) * (hzero 2 2) +
      (3/8) * (hzero 2 3) +
      (-23/96) * (hzero 2 4) +
      (19/240) * (hzero 2 5) +
      (-1/96) * (hzero 2 6) +
      (1/240) * (hzero 3 0) +
      (-1/48) * (hzero 3 1) +
      (1/24) * (hzero 3 2) +
      (-1/24) * (hzero 3 3) +
      (1/48) * (hzero 3 4) +
      (-1/240) * (hzero 3 5)
  have hc23 : c23 = 0 := by
    linear_combination
      (13/64) * (hzero 0 0) +
      (-73/72) * (hzero 0 1) +
      (25/12) * (hzero 0 2) +
      (-325/144) * (hzero 0 3) +
      (785/576) * (hzero 0 4) +
      (-7/16) * (hzero 0 5) +
      (17/288) * (hzero 0 6) +
      (-73/144) * (hzero 1 0) +
      (89/36) * (hzero 1 1) +
      (-79/16) * (hzero 1 2) +
      (31/6) * (hzero 1 3) +
      (-431/144) * (hzero 1 4) +
      (11/12) * (hzero 1 5) +
      (-17/144) * (hzero 1 6) +
      (61/144) * (hzero 2 0) +
      (-95/48) * (hzero 2 1) +
      (359/96) * (hzero 2 2) +
      (-131/36) * (hzero 2 3) +
      (23/12) * (hzero 2 4) +
      (-25/48) * (hzero 2 5) +
      (17/288) * (hzero 2 6) +
      (-5/36) * (hzero 3 0) +
      (43/72) * (hzero 3 1) +
      (-1) * (hzero 3 2) +
      (29/36) * (hzero 3 3) +
      (-11/36) * (hzero 3 4) +
      (1/24) * (hzero 3 5) +
      (11/576) * (hzero 4 0) +
      (-11/144) * (hzero 4 1) +
      (11/96) * (hzero 4 2) +
      (-11/144) * (hzero 4 3) +
      (11/576) * (hzero 4 4)
  have hc24 : c24 = 0 := by
    linear_combination
      (-9/8) * (hzero 0 0) +
      (115/24) * (hzero 0 1) +
      (-805/96) * (hzero 0 2) +
      (125/16) * (hzero 0 3) +
      (-25/6) * (hzero 0 4) +
      (59/48) * (hzero 0 5) +
      (-5/32) * (hzero 0 6) +
      (115/36) * (hzero 1 0) +
      (-209/16) * (hzero 1 1) +
      (347/16) * (hzero 1 2) +
      (-341/18) * (hzero 1 3) +
      (113/12) * (hzero 1 4) +
      (-125/48) * (hzero 1 5) +
      (5/16) * (hzero 1 6) +
      (-983/288) * (hzero 2 0) +
      (209/16) * (hzero 2 1) +
      (-1897/96) * (hzero 2 2) +
      (547/36) * (hzero 2 3) +
      (-619/96) * (hzero 2 4) +
      (73/48) * (hzero 2 5) +
      (-5/32) * (hzero 2 6) +
      (29/16) * (hzero 3 0) +
      (-101/16) * (hzero 3 1) +
      (197/24) * (hzero 3 2) +
      (-39/8) * (hzero 3 3) +
      (21/16) * (hzero 3 4) +
      (-7/48) * (hzero 3 5) +
      (-155/288) * (hzero 4 0) +
      (83/48) * (hzero 4 1) +
      (-47/24) * (hzero 4 2) +
      (127/144) * (hzero 4 3) +
      (-11/96) * (hzero 4 4) +
      (5/72) * (hzero 5 0) +
      (-5/24) * (hzero 5 1) +
      (5/24) * (hzero 5 2) +
      (-5/72) * (hzero 5 3)
  have hc25 : c25 = 0 := by
    linear_combination
      (1069/320) * (hzero 0 0) +
      (-329/30) * (hzero 0 1) +
      (21559/1440) * (hzero 0 2) +
      (-139/12) * (hzero 0 3) +
      (3229/576) * (hzero 0 4) +
      (-187/120) * (hzero 0 5) +
      (137/720) * (hzero 0 6) +
      (-329/30) * (hzero 1 0) +
      (6077/180) * (hzero 1 1) +
      (-2521/60) * (hzero 1 2) +
      (2101/72) * (hzero 1 3) +
      (-929/72) * (hzero 1 4) +
      (133/40) * (hzero 1 5) +
      (-137/360) * (hzero 1 6) +
      (21559/1440) * (hzero 2 0) +
      (-2521/60) * (hzero 2 1) +
      (719/16) * (hzero 2 2) +
      (-911/36) * (hzero 2 3) +
      (883/96) * (hzero 2 4) +
      (-79/40) * (hzero 2 5) +
      (137/720) * (hzero 2 6) +
      (-139/12) * (hzero 3 0) +
      (2101/72) * (hzero 3 1) +
      (-911/36) * (hzero 3 2) +
      (173/18) * (hzero 3 3) +
      (-19/9) * (hzero 3 4) +
      (5/24) * (hzero 3 5) +
      (3229/576) * (hzero 4 0) +
      (-929/72) * (hzero 4 1) +
      (883/96) * (hzero 4 2) +
      (-19/9) * (hzero 4 3) +
      (121/576) * (hzero 4 4) +
      (-187/120) * (hzero 5 0) +
      (133/40) * (hzero 5 1) +
      (-79/40) * (hzero 5 2) +
      (5/24) * (hzero 5 3) +
      (137/720) * (hzero 6 0) +
      (-137/360) * (hzero 6 1) +
      (137/720) * (hzero 6 2)
  have hc26 : c26 = 0 := by
    linear_combination
      (-801/160) * (hzero 0 0) +
      (349/36) * (hzero 0 1) +
      (-6077/720) * (hzero 0 2) +
      (23/4) * (hzero 0 3) +
      (-251/96) * (hzero 0 4) +
      (7/10) * (hzero 0 5) +
      (-1/12) * (hzero 0 6) +
      (349/18) * (hzero 1 0) +
      (-341/10) * (hzero 1 1) +
      (743/30) * (hzero 1 2) +
      (-533/36) * (hzero 1 3) +
      (73/12) * (hzero 1 4) +
      (-3/2) * (hzero 1 5) +
      (1/6) * (hzero 1 6) +
      (-2443/72) * (hzero 2 0) +
      (1583/30) * (hzero 2 1) +
      (-1373/48) * (hzero 2 2) +
      (241/18) * (hzero 2 3) +
      (-71/16) * (hzero 2 4) +
      (9/10) * (hzero 2 5) +
      (-1/12) * (hzero 2 6) +
      (544/15) * (hzero 3 0) +
      (-1793/36) * (hzero 3 1) +
      (325/18) * (hzero 3 2) +
      (-11/2) * (hzero 3 3) +
      (13/12) * (hzero 3 4) +
      (-1/10) * (hzero 3 5) +
      (-7369/288) * (hzero 4 0) +
      (127/4) * (hzero 4 1) +
      (-353/48) * (hzero 4 2) +
      (47/36) * (hzero 4 3) +
      (-11/96) * (hzero 4 4) +
      (2077/180) * (hzero 5 0) +
      (-79/6) * (hzero 5 1) +
      (53/30) * (hzero 5 2) +
      (-5/36) * (hzero 5 3) +
      (-145/48) * (hzero 6 0) +
      (289/90) * (hzero 6 1) +
      (-137/720) * (hzero 6 2) +
      (7/20) * (hzero 7 0) +
      (-7/20) * (hzero 7 1)
  have hc27 : c27 = 0 := by
    linear_combination
      (29531/10080) * (hzero 0 0) +
      (-481/35) * (hzero 1 0) +
      (621/20) * (hzero 2 0) +
      (-2003/45) * (hzero 3 0) +
      (691/16) * (hzero 4 0) +
      (-141/5) * (hzero 5 0) +
      (2143/180) * (hzero 6 0) +
      (-103/35) * (hzero 7 0) +
      (363/1120) * (hzero 8 0)
  have hc28 : c28 = 0 := by
    linear_combination
      (1/5040) * (hzero 0 0) +
      (-1/720) * (hzero 0 1) +
      (1/240) * (hzero 0 2) +
      (-1/144) * (hzero 0 3) +
      (1/144) * (hzero 0 4) +
      (-1/240) * (hzero 0 5) +
      (1/720) * (hzero 0 6) +
      (-1/5040) * (hzero 0 7) +
      (-1/5040) * (hzero 1 0) +
      (1/720) * (hzero 1 1) +
      (-1/240) * (hzero 1 2) +
      (1/144) * (hzero 1 3) +
      (-1/144) * (hzero 1 4) +
      (1/240) * (hzero 1 5) +
      (-1/720) * (hzero 1 6) +
      (1/5040) * (hzero 1 7)
  have hc29 : c29 = 0 := by
    linear_combination
      (-1/160) * (hzero 0 0) +
      (1/24) * (hzero 0 1) +
      (-19/160) * (hzero 0 2) +
      (3/16) * (hzero 0 3) +
      (-17/96) * (hzero 0 4) +
      (1/10) * (hzero 0 5) +
      (-1/32) * (hzero 0 6) +
      (1/240) * (hzero 0 7) +
      (1/144) * (hzero 1 0) +
      (-11/240) * (hzero 1 1) +
      (31/240) * (hzero 1 2) +
      (-29/144) * (hzero 1 3) +
      (3/16) * (hzero 1 4) +
      (-5/48) * (hzero 1 5) +
      (23/720) * (hzero 1 6) +
      (-1/240) * (hzero 1 7) +
      (-1/1440) * (hzero 2 0) +
      (1/240) * (hzero 2 1) +
      (-1/96) * (hzero 2 2) +
      (1/72) * (hzero 2 3) +
      (-1/96) * (hzero 2 4) +
      (1/240) * (hzero 2 5) +
      (-1/1440) * (hzero 2 6)
  have hc30 : c30 = 0 := by
    linear_combination
      (13/160) * (hzero 0 0) +
      (-73/144) * (hzero 0 1) +
      (389/288) * (hzero 0 2) +
      (-287/144) * (hzero 0 3) +
      (169/96) * (hzero 0 4) +
      (-671/720) * (hzero 0 5) +
      (79/288) * (hzero 0 6) +
      (-5/144) * (hzero 0 7) +
      (-73/720) * (hzero 1 0) +
      (89/144) * (hzero 1 1) +
      (-77/48) * (hzero 1 2) +
      (331/144) * (hzero 1 3) +
      (-283/144) * (hzero 1 4) +
      (241/240) * (hzero 1 5) +
      (-41/144) * (hzero 1 6) +
      (5/144) * (hzero 1 7) +
      (11/480) * (hzero 2 0) +
      (-1/8) * (hzero 2 1) +
      (9/32) * (hzero 2 2) +
      (-1/3) * (hzero 2 3) +
      (7/32) * (hzero 2 4) +
      (-3/40) * (hzero 2 5) +
      (1/96) * (hzero 2 6) +
      (-1/360) * (hzero 3 0) +
      (1/72) * (hzero 3 1) +
      (-1/36) * (hzero 3 2) +
      (1/36) * (hzero 3 3) +
      (-1/72) * (hzero 3 4) +
      (1/360) * (hzero 3 5)
  have hc31 : c31 = 0 := by
    linear_combination
      (-9/16) * (hzero 0 0) +
      (115/36) * (hzero 0 1) +
      (-2237/288) * (hzero 0 2) +
      (505/48) * (hzero 0 3) +
      (-155/18) * (hzero 0 4) +
      (77/18) * (hzero 0 5) +
      (-115/96) * (hzero 0 6) +
      (7/48) * (hzero 0 7) +
      (115/144) * (hzero 1 0) +
      (-209/48) * (hzero 1 1) +
      (485/48) * (hzero 1 2) +
      (-1871/144) * (hzero 1 3) +
      (161/16) * (hzero 1 4) +
      (-227/48) * (hzero 1 5) +
      (181/144) * (hzero 1 6) +
      (-7/48) * (hzero 1 7) +
      (-89/288) * (hzero 2 0) +
      (71/48) * (hzero 2 1) +
      (-277/96) * (hzero 2 2) +
      (211/72) * (hzero 2 3) +
      (-157/96) * (hzero 2 4) +
      (23/48) * (hzero 2 5) +
      (-17/288) * (hzero 2 6) +
      (1/12) * (hzero 3 0) +
      (-13/36) * (hzero 3 1) +
      (11/18) * (hzero 3 2) +
      (-1/2) * (hzero 3 3) +
      (7/36) * (hzero 3 4) +
      (-1/36) * (hzero 3 5) +
      (-1/96) * (hzero 4 0) +
      (1/24) * (hzero 4 1) +
      (-1/16) * (hzero 4 2) +
      (1/24) * (hzero 4 3) +
      (-1/96) * (hzero 4 4)
  have hc32 : c32 = 0 := by
    linear_combination
      (1069/480) * (hzero 0 0) +
      (-329/30) * (hzero 0 1) +
      (33713/1440) * (hzero 0 2) +
      (-10247/360) * (hzero 0 3) +
      (6193/288) * (hzero 0 4) +
      (-3641/360) * (hzero 0 5) +
      (3923/1440) * (hzero 0 6) +
      (-29/90) * (hzero 0 7) +
      (-329/90) * (hzero 1 0) +
      (6077/360) * (hzero 1 1) +
      (-4007/120) * (hzero 1 2) +
      (1345/36) * (hzero 1 3) +
      (-937/36) * (hzero 1 4) +
      (1367/120) * (hzero 1 5) +
      (-1037/360) * (hzero 1 6) +
      (29/90) * (hzero 1 7) +
      (209/96) * (hzero 2 0) +
      (-69/8) * (hzero 2 1) +
      (439/32) * (hzero 2 2) +
      (-34/3) * (hzero 2 3) +
      (169/32) * (hzero 2 4) +
      (-11/8) * (hzero 2 5) +
      (5/32) * (hzero 2 6) +
      (-71/72) * (hzero 3 0) +
      (251/72) * (hzero 3 1) +
      (-167/36) * (hzero 3 2) +
      (103/36) * (hzero 3 3) +
      (-59/72) * (hzero 3 4) +
      (7/72) * (hzero 3 5) +
      (13/48) * (hzero 4 0) +
      (-7/8) * (hzero 4 1) +
      (1) * (hzero 4 2) +
      (-11/24) * (hzero 4 3) +
      (1/16) * (hzero 4 4) +
      (-1/30) * (hzero 5 0) +
      (1/10) * (hzero 5 1) +
      (-1/10) * (hzero 5 2) +
      (1/30) * (hzero 5 3)
  have hc33 : c33 = 0 := by
    linear_combination
      (-801/160) * (hzero 0 0) +
      (349/18) * (hzero 0 1) +
      (-2443/72) * (hzero 0 2) +
      (544/15) * (hzero 0 3) +
      (-7369/288) * (hzero 0 4) +
      (2077/180) * (hzero 0 5) +
      (-145/48) * (hzero 0 6) +
      (7/20) * (hzero 0 7) +
      (349/36) * (hzero 1 0) +
      (-341/10) * (hzero 1 1) +
      (1583/30) * (hzero 1 2) +
      (-1793/36) * (hzero 1 3) +
      (127/4) * (hzero 1 4) +
      (-79/6) * (hzero 1 5) +
      (289/90) * (hzero 1 6) +
      (-7/20) * (hzero 1 7) +
      (-6077/720) * (hzero 2 0) +
      (743/30) * (hzero 2 1) +
      (-1373/48) * (hzero 2 2) +
      (325/18) * (hzero 2 3) +
      (-353/48) * (hzero 2 4) +
      (53/30) * (hzero 2 5) +
      (-137/720) * (hzero 2 6) +
      (23/4) * (hzero 3 0) +
      (-533/36) * (hzero 3 1) +
      (241/18) * (hzero 3 2) +
      (-11/2) * (hzero 3 3) +
      (47/36) * (hzero 3 4) +
      (-5/36) * (hzero 3 5) +
      (-251/96) * (hzero 4 0) +
      (73/12) * (hzero 4 1) +
      (-71/16) * (hzero 4 2) +
      (13/12) * (hzero 4 3) +
      (-11/96) * (hzero 4 4) +
      (7/10) * (hzero 5 0) +
      (-3/2) * (hzero 5 1) +
      (9/10) * (hzero 5 2) +
      (-1/10) * (hzero 5 3) +
      (-1/12) * (hzero 6 0) +
      (1/6) * (hzero 6 1) +
      (-1/12) * (hzero 6 2)
  have hc34 : c34 = 0 := by
    linear_combination
      (29531/5040) * (hzero 0 0) +
      (-481/35) * (hzero 0 1) +
      (341/20) * (hzero 0 2) +
      (-743/45) * (hzero 0 3) +
      (533/48) * (hzero 0 4) +
      (-73/15) * (hzero 0 5) +
      (5/4) * (hzero 0 6) +
      (-1/7) * (hzero 0 7) +
      (-481/35) * (hzero 1 0) +
      (28) * (hzero 1 1) +
      (-28) * (hzero 1 2) +
      (70/3) * (hzero 1 3) +
      (-14) * (hzero 1 4) +
      (28/5) * (hzero 1 5) +
      (-4/3) * (hzero 1 6) +
      (1/7) * (hzero 1 7) +
      (341/20) * (hzero 2 0) +
      (-28) * (hzero 2 1) +
      (35/2) * (hzero 2 2) +
      (-28/3) * (hzero 2 3) +
      (7/2) * (hzero 2 4) +
      (-4/5) * (hzero 2 5) +
      (1/12) * (hzero 2 6) +
      (-743/45) * (hzero 3 0) +
      (70/3) * (hzero 3 1) +
      (-28/3) * (hzero 3 2) +
      (28/9) * (hzero 3 3) +
      (-2/3) * (hzero 3 4) +
      (1/15) * (hzero 3 5) +
      (533/48) * (hzero 4 0) +
      (-14) * (hzero 4 1) +
      (7/2) * (hzero 4 2) +
      (-2/3) * (hzero 4 3) +
      (1/16) * (hzero 4 4) +
      (-73/15) * (hzero 5 0) +
      (28/5) * (hzero 5 1) +
      (-4/5) * (hzero 5 2) +
      (1/15) * (hzero 5 3) +
      (5/4) * (hzero 6 0) +
      (-4/3) * (hzero 6 1) +
      (1/12) * (hzero 6 2) +
      (-1/7) * (hzero 7 0) +
      (1/7) * (hzero 7 1)
  have hc35 : c35 = 0 := by
    linear_combination
      (-761/280) * (hzero 0 0) +
      (8) * (hzero 1 0) +
      (-14) * (hzero 2 0) +
      (56/3) * (hzero 3 0) +
      (-35/2) * (hzero 4 0) +
      (56/5) * (hzero 5 0) +
      (-14/3) * (hzero 6 0) +
      (8/7) * (hzero 7 0) +
      (-1/8) * (hzero 8 0)
  have hc36 : c36 = 0 := by
    linear_combination
      (1/40320) * (hzero 0 0) +
      (-1/5040) * (hzero 0 1) +
      (1/1440) * (hzero 0 2) +
      (-1/720) * (hzero 0 3) +
      (1/576) * (hzero 0 4) +
      (-1/720) * (hzero 0 5) +
      (1/1440) * (hzero 0 6) +
      (-1/5040) * (hzero 0 7) +
      (1/40320) * (hzero 0 8)
  have hc37 : c37 = 0 := by
    linear_combination
      (-1/1120) * (hzero 0 0) +
      (1/144) * (hzero 0 1) +
      (-17/720) * (hzero 0 2) +
      (11/240) * (hzero 0 3) +
      (-1/18) * (hzero 0 4) +
      (31/720) * (hzero 0 5) +
      (-1/48) * (hzero 0 6) +
      (29/5040) * (hzero 0 7) +
      (-1/1440) * (hzero 0 8)
  have hc38 : c38 = 0 := by
    linear_combination
      (13/960) * (hzero 0 0) +
      (-73/720) * (hzero 0 1) +
      (239/720) * (hzero 0 2) +
      (-149/240) * (hzero 0 3) +
      (209/288) * (hzero 0 4) +
      (-391/720) * (hzero 0 5) +
      (61/240) * (hzero 0 6) +
      (-49/720) * (hzero 0 7) +
      (23/2880) * (hzero 0 8)
  have hc39 : c39 = 0 := by
    linear_combination
      (-9/80) * (hzero 0 0) +
      (115/144) * (hzero 0 1) +
      (-179/72) * (hzero 0 2) +
      (71/16) * (hzero 0 3) +
      (-179/36) * (hzero 0 4) +
      (2581/720) * (hzero 0 5) +
      (-13/8) * (hzero 0 6) +
      (61/144) * (hzero 0 7) +
      (-7/144) * (hzero 0 8)
  have hc40 : c40 = 0 := by
    linear_combination
      (1069/1920) * (hzero 0 0) +
      (-329/90) * (hzero 0 1) +
      (15289/1440) * (hzero 0 2) +
      (-268/15) * (hzero 0 3) +
      (10993/576) * (hzero 0 4) +
      (-1193/90) * (hzero 0 5) +
      (2803/480) * (hzero 0 6) +
      (-67/45) * (hzero 0 7) +
      (967/5760) * (hzero 0 8)
  have hc41 : c41 = 0 := by
    linear_combination
      (-267/160) * (hzero 0 0) +
      (349/36) * (hzero 0 1) +
      (-18353/720) * (hzero 0 2) +
      (797/20) * (hzero 0 3) +
      (-1457/36) * (hzero 0 4) +
      (4891/180) * (hzero 0 5) +
      (-187/16) * (hzero 0 6) +
      (527/180) * (hzero 0 7) +
      (-469/1440) * (hzero 0 8)
  have hc42 : c42 = 0 := by
    linear_combination
      (29531/10080) * (hzero 0 0) +
      (-481/35) * (hzero 0 1) +
      (621/20) * (hzero 0 2) +
      (-2003/45) * (hzero 0 3) +
      (691/16) * (hzero 0 4) +
      (-141/5) * (hzero 0 5) +
      (2143/180) * (hzero 0 6) +
      (-103/35) * (hzero 0 7) +
      (363/1120) * (hzero 0 8)
  have hc43 : c43 = 0 := by
    linear_combination
      (-761/280) * (hzero 0 0) +
      (8) * (hzero 0 1) +
      (-14) * (hzero 0 2) +
      (56/3) * (hzero 0 3) +
      (-35/2) * (hzero 0 4) +
      (56/5) * (hzero 0 5) +
      (-14/3) * (hzero 0 6) +
      (8/7) * (hzero 0 7) +
      (-1/8) * (hzero 0 8)
  have hc44 : c44 = 0 := by
    linear_combination
      (1) * (hzero 0 0)
  exact ⟨hc0, hc1, hc2, hc3, hc4, hc5, hc6, hc7, hc8, hc9, hc10, hc11, hc12, hc13, hc14, hc15, hc16, hc17, hc18, hc19, hc20, hc21, hc22, hc23, hc24, hc25, hc26, hc27, hc28, hc29, hc30, hc31, hc32, hc33, hc34, hc35, hc36, hc37, hc38, hc39, hc40, hc41, hc42, hc43, hc44⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 4000000 in
/-- Functional cross-product equality gives the 89 linear coefficient equations. -/
theorem crossEquations_of_cross_eq (c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 lam : R) (hnorm : c44 = 0)
    (hU : ∀ s t, quartic c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 s t * hesseQuarticW lam s t =
      quartic c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 s t * hesseQuarticU lam s t)
    (hV : ∀ s t, quartic c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 s t * hesseQuarticW lam s t =
      quartic c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 s t * hesseQuarticV lam s t) :
    CrossEquations c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 lam := by
  have hUz : ∀ s t : R, octic (-c30) (-c31) (2*c0 - c32) (3*c0*lam - c33) (2*c1 - c34) (2*c2 - c35) (3*c1*lam + 2*c30 - c36) (3*c2*lam + 2*c3 - c37) (-c38 + 2*c4) (-2*c30 - c39 + 2*c5) (3*c3*lam + 2*c31 - c40) (2*c0 + 2*c32 + 3*c4*lam - c41 + 2*c6) (-3*c30*lam - c42 + 3*c5*lam + 2*c7) (-2*c31 - c43 + 2*c8) (c0 - 2*c32 - c44 + 2*c9) (2*c33 + 3*c6*lam) (2*c1 + 2*c10 + 2*c34 + 3*c7*lam) (2*c11 + 2*c2 - 3*c31*lam + 2*c35 + 3*c8*lam) (2*c12 - 3*c32*lam - 2*c33 + 3*c9*lam) (c1 + 2*c13 - 2*c34) (2*c14 + c2 - 2*c35) (3*c10*lam + 2*c36) (3*c11*lam + 2*c3 + 2*c37) (3*c12*lam - 3*c33*lam + 2*c38 + 2*c4) (3*c13*lam - 3*c34*lam - 2*c36 + 2*c39 + 2*c5) (3*c14*lam + c3 - 3*c35*lam - 2*c37) (-2*c38 + c4) (-2*c39 + c5) (2*c40) (2*c41 + 2*c6) (-3*c36*lam + 2*c42 + 2*c7) (-3*c37*lam - 2*c40 + 2*c43 + 2*c8) (-3*c38*lam - 2*c41 + 2*c44 + c6 + 2*c9) (-3*c39*lam - 2*c42 + c7) (-2*c43 + c8) (-2*c44 + c9) (0) (2*c10) (2*c11 - 3*c40*lam) (2*c12 - 3*c41*lam) (c10 + 2*c13 - 3*c42*lam) (c11 + 2*c14 - 3*c43*lam) (c12 - 3*c44*lam) (c13) (c14) s t = 0 := by
    intro s t
    rw [← crossU_sub_eq_octic c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 lam s t]
    exact sub_eq_zero.mpr (hU s t)
  obtain ⟨hu0, hu1, hu2, hu3, hu4, hu5, hu6, hu7, hu8, hu9, hu10, hu11, hu12, hu13, hu14, hu15, hu16, hu17, hu18, hu19, hu20, hu21, hu22, hu23, hu24, hu25, hu26, hu27, hu28, hu29, hu30, hu31, hu32, hu33, hu34, hu35, hu36, hu37, hu38, hu39, hu40, hu41, hu42, hu43, hu44⟩ :=
    octic_coefficients_eq_zero (-c30) (-c31) (2*c0 - c32) (3*c0*lam - c33) (2*c1 - c34) (2*c2 - c35) (3*c1*lam + 2*c30 - c36) (3*c2*lam + 2*c3 - c37) (-c38 + 2*c4) (-2*c30 - c39 + 2*c5) (3*c3*lam + 2*c31 - c40) (2*c0 + 2*c32 + 3*c4*lam - c41 + 2*c6) (-3*c30*lam - c42 + 3*c5*lam + 2*c7) (-2*c31 - c43 + 2*c8) (c0 - 2*c32 - c44 + 2*c9) (2*c33 + 3*c6*lam) (2*c1 + 2*c10 + 2*c34 + 3*c7*lam) (2*c11 + 2*c2 - 3*c31*lam + 2*c35 + 3*c8*lam) (2*c12 - 3*c32*lam - 2*c33 + 3*c9*lam) (c1 + 2*c13 - 2*c34) (2*c14 + c2 - 2*c35) (3*c10*lam + 2*c36) (3*c11*lam + 2*c3 + 2*c37) (3*c12*lam - 3*c33*lam + 2*c38 + 2*c4) (3*c13*lam - 3*c34*lam - 2*c36 + 2*c39 + 2*c5) (3*c14*lam + c3 - 3*c35*lam - 2*c37) (-2*c38 + c4) (-2*c39 + c5) (2*c40) (2*c41 + 2*c6) (-3*c36*lam + 2*c42 + 2*c7) (-3*c37*lam - 2*c40 + 2*c43 + 2*c8) (-3*c38*lam - 2*c41 + 2*c44 + c6 + 2*c9) (-3*c39*lam - 2*c42 + c7) (-2*c43 + c8) (-2*c44 + c9) (0) (2*c10) (2*c11 - 3*c40*lam) (2*c12 - 3*c41*lam) (c10 + 2*c13 - 3*c42*lam) (c11 + 2*c14 - 3*c43*lam) (c12 - 3*c44*lam) (c13) (c14) hUz
  have hVz : ∀ s t : R, octic (0) (2*c30) (2*c15) (3*c15*lam + 2*c31) (2*c16 + 2*c32) (2*c17 - 3*c30*lam) (3*c16*lam + 2*c33) (3*c17*lam + 2*c18 + 2*c34) (2*c19 - 3*c31*lam + 2*c35) (2*c20 - 3*c32*lam) (3*c18*lam - c30 + 2*c36) (2*c15 + 3*c19*lam + 2*c21 + 2*c37) (3*c20*lam + 2*c22 - 3*c33*lam + 2*c38) (2*c23 - 2*c30 - 3*c34*lam + 2*c39) (c15 + 2*c24 - 3*c35*lam) (3*c21*lam - c31 + 2*c40) (2*c16 + 3*c22*lam + 2*c25 - c32 + 2*c41) (2*c17 + 3*c23*lam + 2*c26 - 3*c36*lam + 2*c42) (3*c24*lam + 2*c27 - 2*c31 - 3*c37*lam + 2*c43) (c16 + 2*c28 - 2*c32 - 3*c38*lam + 2*c44) (c17 + 2*c29 - 3*c39*lam) (3*c25*lam - c33) (2*c18 + 3*c26*lam - c34) (2*c19 + 3*c27*lam - c35 - 3*c40*lam) (2*c20 + 3*c28*lam - 2*c33 - 3*c41*lam) (c18 + 3*c29*lam - 2*c34 - 3*c42*lam) (c19 - 2*c35 - 3*c43*lam) (c20 - 3*c44*lam) (-c36) (2*c21 - c37) (2*c22 - c38) (2*c23 - 2*c36 - c39) (c21 + 2*c24 - 2*c37) (c22 - 2*c38) (c23 - 2*c39) (c24) (-c40) (2*c25 - c41) (2*c26 - c42) (2*c27 - 2*c40 - c43) (c25 + 2*c28 - 2*c41 - c44) (c26 + 2*c29 - 2*c42) (c27 - 2*c43) (c28 - 2*c44) (c29) s t = 0 := by
    intro s t
    rw [← crossV_sub_eq_octic c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 lam s t]
    exact sub_eq_zero.mpr (hV s t)
  obtain ⟨hv0, hv1, hv2, hv3, hv4, hv5, hv6, hv7, hv8, hv9, hv10, hv11, hv12, hv13, hv14, hv15, hv16, hv17, hv18, hv19, hv20, hv21, hv22, hv23, hv24, hv25, hv26, hv27, hv28, hv29, hv30, hv31, hv32, hv33, hv34, hv35, hv36, hv37, hv38, hv39, hv40, hv41, hv42, hv43, hv44⟩ :=
    octic_coefficients_eq_zero (0) (2*c30) (2*c15) (3*c15*lam + 2*c31) (2*c16 + 2*c32) (2*c17 - 3*c30*lam) (3*c16*lam + 2*c33) (3*c17*lam + 2*c18 + 2*c34) (2*c19 - 3*c31*lam + 2*c35) (2*c20 - 3*c32*lam) (3*c18*lam - c30 + 2*c36) (2*c15 + 3*c19*lam + 2*c21 + 2*c37) (3*c20*lam + 2*c22 - 3*c33*lam + 2*c38) (2*c23 - 2*c30 - 3*c34*lam + 2*c39) (c15 + 2*c24 - 3*c35*lam) (3*c21*lam - c31 + 2*c40) (2*c16 + 3*c22*lam + 2*c25 - c32 + 2*c41) (2*c17 + 3*c23*lam + 2*c26 - 3*c36*lam + 2*c42) (3*c24*lam + 2*c27 - 2*c31 - 3*c37*lam + 2*c43) (c16 + 2*c28 - 2*c32 - 3*c38*lam + 2*c44) (c17 + 2*c29 - 3*c39*lam) (3*c25*lam - c33) (2*c18 + 3*c26*lam - c34) (2*c19 + 3*c27*lam - c35 - 3*c40*lam) (2*c20 + 3*c28*lam - 2*c33 - 3*c41*lam) (c18 + 3*c29*lam - 2*c34 - 3*c42*lam) (c19 - 2*c35 - 3*c43*lam) (c20 - 3*c44*lam) (-c36) (2*c21 - c37) (2*c22 - c38) (2*c23 - 2*c36 - c39) (c21 + 2*c24 - 2*c37) (c22 - 2*c38) (c23 - 2*c39) (c24) (-c40) (2*c25 - c41) (2*c26 - c42) (2*c27 - 2*c40 - c43) (c25 + 2*c28 - 2*c41 - c44) (c26 + 2*c29 - 2*c42) (c27 - 2*c43) (c28 - 2*c44) (c29) hVz
  exact ⟨hu0, hu1, hu2, hu3, hu4, hu5, hu6, hu7, hu8, hu9, hu10, hu11, hu12, hu13, hu14, hu15, hu16, hu17, hu18, hu19, hu20, hu21, hu22, hu23, hu24, hu25, hu26, hu27, hu28, hu29, hu30, hu31, hu32, hu33, hu34, hu35, hu37, hu38, hu39, hu40, hu41, hu42, hu43, hu44, hv1, hv2, hv3, hv4, hv5, hv6, hv7, hv8, hv9, hv10, hv11, hv12, hv13, hv14, hv15, hv16, hv17, hv18, hv19, hv20, hv21, hv22, hv23, hv24, hv25, hv26, hv27, hv28, hv29, hv30, hv31, hv32, hv33, hv34, hv35, hv36, hv37, hv38, hv39, hv40, hv41, hv42, hv43, hv44, hnorm⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 4000000 in
/-- The proof-producing `QQ[lam]` left inverse of the cross-coefficient system. -/
theorem coefficients_eq_zero_of_crossEquations (c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 lam : R)
    (H : CrossEquations c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 lam) :
    c0 = 0 ∧ c1 = 0 ∧ c2 = 0 ∧ c3 = 0 ∧ c4 = 0 ∧ c5 = 0 ∧ c6 = 0 ∧ c7 = 0 ∧ c8 = 0 ∧ c9 = 0 ∧ c10 = 0 ∧ c11 = 0 ∧ c12 = 0 ∧ c13 = 0 ∧ c14 = 0 ∧ c15 = 0 ∧ c16 = 0 ∧ c17 = 0 ∧ c18 = 0 ∧ c19 = 0 ∧ c20 = 0 ∧ c21 = 0 ∧ c22 = 0 ∧ c23 = 0 ∧ c24 = 0 ∧ c25 = 0 ∧ c26 = 0 ∧ c27 = 0 ∧ c28 = 0 ∧ c29 = 0 ∧ c30 = 0 ∧ c31 = 0 ∧ c32 = 0 ∧ c33 = 0 ∧ c34 = 0 ∧ c35 = 0 ∧ c36 = 0 ∧ c37 = 0 ∧ c38 = 0 ∧ c39 = 0 ∧ c40 = 0 ∧ c41 = 0 ∧ c42 = 0 ∧ c43 = 0 ∧ c44 = 0 := by
  have e0 := H.h0
  have e1 := H.h1
  have e2 := H.h2
  have e3 := H.h3
  have e4 := H.h4
  have e5 := H.h5
  have e6 := H.h6
  have e7 := H.h7
  have e8 := H.h8
  have e9 := H.h9
  have e10 := H.h10
  have e11 := H.h11
  have e12 := H.h12
  have e13 := H.h13
  have e14 := H.h14
  have e15 := H.h15
  have e16 := H.h16
  have e17 := H.h17
  have e18 := H.h18
  have e19 := H.h19
  have e20 := H.h20
  have e21 := H.h21
  have e22 := H.h22
  have e23 := H.h23
  have e24 := H.h24
  have e25 := H.h25
  have e26 := H.h26
  have e27 := H.h27
  have e28 := H.h28
  have e29 := H.h29
  have e30 := H.h30
  have e31 := H.h31
  have e32 := H.h32
  have e33 := H.h33
  have e34 := H.h34
  have e35 := H.h35
  have e36 := H.h36
  have e37 := H.h37
  have e38 := H.h38
  have e39 := H.h39
  have e40 := H.h40
  have e41 := H.h41
  have e42 := H.h42
  have e43 := H.h43
  have e44 := H.h44
  have e45 := H.h45
  have e46 := H.h46
  have e47 := H.h47
  have e48 := H.h48
  have e49 := H.h49
  have e50 := H.h50
  have e51 := H.h51
  have e52 := H.h52
  have e53 := H.h53
  have e54 := H.h54
  have e55 := H.h55
  have e56 := H.h56
  have e57 := H.h57
  have e58 := H.h58
  have e59 := H.h59
  have e60 := H.h60
  have e61 := H.h61
  have e62 := H.h62
  have e63 := H.h63
  have e64 := H.h64
  have e65 := H.h65
  have e66 := H.h66
  have e67 := H.h67
  have e68 := H.h68
  have e69 := H.h69
  have e70 := H.h70
  have e71 := H.h71
  have e72 := H.h72
  have e73 := H.h73
  have e74 := H.h74
  have e75 := H.h75
  have e76 := H.h76
  have e77 := H.h77
  have e78 := H.h78
  have e79 := H.h79
  have e80 := H.h80
  have e81 := H.h81
  have e82 := H.h82
  have e83 := H.h83
  have e84 := H.h84
  have e85 := H.h85
  have e86 := H.h86
  have e87 := H.h87
  have e88 := H.h88
  have hc0 : c0 = 0 := by
    linear_combination
      (2/3) * e2 +
      (-1/3) * e14 +
      (2/3) * e35 +
      (1) * e88
  have hc1 : c1 = 0 := by
    linear_combination
      (2/3) * e4 +
      (-1/3) * e19 +
      (2/3) * e42
  have hc2 : c2 = 0 := by
    linear_combination
      (2/3) * e5 +
      (-1/3) * e20 +
      (2/3) * e43
  have hc3 : c3 = 0 := by
    linear_combination
      (lam) * e5 +
      (-2*lam) * e20 +
      (1) * e25 +
      (lam) * e43 +
      (2/3) * e72 +
      (-4/3) * e75 +
      (8/3) * e78
  have hc4 : c4 = 0 := by
    linear_combination
      (1/2) * e8 +
      (1/6) * e73 +
      (-1/3) * e76
  have hc5 : c5 = 0 := by
    linear_combination
      (-1) * e0 +
      (1/2) * e9 +
      (-1/3) * e71 +
      (1/6) * e74 +
      (-1/3) * e77
  have hc6 : c6 = 0 := by
    linear_combination
      (1/2) * e29 +
      (-1/3) * e80 +
      (2/3) * e83 +
      (-4/3) * e86 +
      (-2) * e88
  have hc7 : c7 = 0 := by
    linear_combination
      (1) * e33 +
      (-2*lam) * e71 +
      (lam) * e74 +
      (-2*lam) * e77 +
      (2/3) * e81 +
      (-4/3) * e84 +
      (8/3) * e87
  have hc8 : c8 = 0 := by
    linear_combination
      (-1) * e1 +
      (1/2) * e13 +
      (1/6) * e28 +
      (1/6) * e82 +
      (-1/3) * e85
  have hc9 : c9 = 0 := by
    linear_combination
      (1) * e35 +
      (2) * e88
  have hc10 : c10 = 0 := by
    linear_combination
      (1/2) * e36
  have hc11 : c11 = 0 := by
    linear_combination
      (lam) * e28 +
      (1) * e40 +
      (-2) * e43 +
      (lam) * e82 +
      (-2*lam) * e85
  have hc12 : c12 = 0 := by
    linear_combination
      (1) * e41 +
      (3*lam) * e88
  have hc13 : c13 = 0 := by
    linear_combination
      (1) * e42
  have hc14 : c14 = 0 := by
    linear_combination
      (1) * e43
  have hc15 : c15 = 0 := by
    linear_combination
      (1/2) * e45
  have hc16 : c16 = 0 := by
    linear_combination
      (-1/3) * e2 +
      (2/3) * e14 +
      (-4/3) * e35 +
      (1/2) * e47 +
      (-2) * e88
  have hc17 : c17 = 0 := by
    linear_combination
      (1) * e63 +
      (-2*lam) * e71 +
      (lam) * e74 +
      (-2*lam) * e77 +
      (-2) * e87
  have hc18 : c18 = 0 := by
    linear_combination
      (2/3) * e4 +
      (-4/3) * e19 +
      (8/3) * e42 +
      (1) * e68 +
      (lam) * e81 +
      (-2*lam) * e84 +
      (lam) * e87
  have hc19 : c19 = 0 := by
    linear_combination
      (2/3) * e5 +
      (-4/3) * e20 +
      (lam) * e28 +
      (8/3) * e43 +
      (1) * e69 +
      (lam) * e82 +
      (-2*lam) * e85
  have hc20 : c20 = 0 := by
    linear_combination
      (1) * e70 +
      (3*lam) * e88
  have hc21 : c21 = 0 := by
    linear_combination
      (2/3) * e72 +
      (-1/3) * e75 +
      (2/3) * e78
  have hc22 : c22 = 0 := by
    linear_combination
      (2/3) * e73 +
      (-1/3) * e76
  have hc23 : c23 = 0 := by
    linear_combination
      (-4/3) * e71 +
      (2/3) * e74 +
      (-1/3) * e77
  have hc24 : c24 = 0 := by
    linear_combination
      (1) * e78
  have hc25 : c25 = 0 := by
    linear_combination
      (2/3) * e80 +
      (-1/3) * e83 +
      (2/3) * e86 +
      (1) * e88
  have hc26 : c26 = 0 := by
    linear_combination
      (2/3) * e81 +
      (-1/3) * e84 +
      (2/3) * e87
  have hc27 : c27 = 0 := by
    linear_combination
      (2/3) * e28 +
      (2/3) * e82 +
      (-1/3) * e85
  have hc28 : c28 = 0 := by
    linear_combination
      (1) * e86 +
      (2) * e88
  have hc29 : c29 = 0 := by
    linear_combination
      (1) * e87
  have hc30 : c30 = 0 := by
    linear_combination
      (-1) * e0
  have hc31 : c31 = 0 := by
    linear_combination
      (-1) * e1
  have hc32 : c32 = 0 := by
    linear_combination
      (1/3) * e2 +
      (-2/3) * e14 +
      (4/3) * e35 +
      (2) * e88
  have hc33 : c33 = 0 := by
    linear_combination
      (-1/2) * e67 +
      (1) * e70 +
      (-(1/2)*lam) * e80 +
      (lam) * e83 +
      (-(1/2)*lam) * e86 +
      (3*lam) * e88
  have hc34 : c34 = 0 := by
    linear_combination
      (1/3) * e4 +
      (-2/3) * e19 +
      (4/3) * e42
  have hc35 : c35 = 0 := by
    linear_combination
      (1/3) * e5 +
      (-2/3) * e20 +
      (4/3) * e43
  have hc36 : c36 = 0 := by
    linear_combination
      (-1) * e71
  have hc37 : c37 = 0 := by
    linear_combination
      (1/3) * e72 +
      (-2/3) * e75 +
      (4/3) * e78
  have hc38 : c38 = 0 := by
    linear_combination
      (1/3) * e73 +
      (-2/3) * e76
  have hc39 : c39 = 0 := by
    linear_combination
      (-2/3) * e71 +
      (1/3) * e74 +
      (-2/3) * e77
  have hc40 : c40 = 0 := by
    linear_combination
      (1/2) * e28
  have hc41 : c41 = 0 := by
    linear_combination
      (1/3) * e80 +
      (-2/3) * e83 +
      (4/3) * e86 +
      (2) * e88
  have hc42 : c42 = 0 := by
    linear_combination
      (1/3) * e81 +
      (-2/3) * e84 +
      (4/3) * e87
  have hc43 : c43 = 0 := by
    linear_combination
      (1/3) * e28 +
      (1/3) * e82 +
      (-2/3) * e85
  have hc44 : c44 = 0 := by
    linear_combination
      (1) * e88
  exact ⟨hc0, hc1, hc2, hc3, hc4, hc5, hc6, hc7, hc8, hc9, hc10, hc11, hc12, hc13, hc14, hc15, hc16, hc17, hc18, hc19, hc20, hc21, hc22, hc23, hc24, hc25, hc26, hc27, hc28, hc29, hc30, hc31, hc32, hc33, hc34, hc35, hc36, hc37, hc38, hc39, hc40, hc41, hc42, hc43, hc44⟩

/-- Global scalar rigidity for a projectively equal Hesse residual triple. -/
theorem coefficients_eq_zero_of_projective_hesse (c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 lam : R) (hnorm : c44 = 0)
    (hU : ∀ s t, quartic c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 s t * hesseQuarticW lam s t =
      quartic c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 s t * hesseQuarticU lam s t)
    (hV : ∀ s t, quartic c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 s t * hesseQuarticW lam s t =
      quartic c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 s t * hesseQuarticV lam s t) :
    c0 = 0 ∧ c1 = 0 ∧ c2 = 0 ∧ c3 = 0 ∧ c4 = 0 ∧ c5 = 0 ∧ c6 = 0 ∧ c7 = 0 ∧ c8 = 0 ∧ c9 = 0 ∧ c10 = 0 ∧ c11 = 0 ∧ c12 = 0 ∧ c13 = 0 ∧ c14 = 0 ∧ c15 = 0 ∧ c16 = 0 ∧ c17 = 0 ∧ c18 = 0 ∧ c19 = 0 ∧ c20 = 0 ∧ c21 = 0 ∧ c22 = 0 ∧ c23 = 0 ∧ c24 = 0 ∧ c25 = 0 ∧ c26 = 0 ∧ c27 = 0 ∧ c28 = 0 ∧ c29 = 0 ∧ c30 = 0 ∧ c31 = 0 ∧ c32 = 0 ∧ c33 = 0 ∧ c34 = 0 ∧ c35 = 0 ∧ c36 = 0 ∧ c37 = 0 ∧ c38 = 0 ∧ c39 = 0 ∧ c40 = 0 ∧ c41 = 0 ∧ c42 = 0 ∧ c43 = 0 ∧ c44 = 0 :=
  coefficients_eq_zero_of_crossEquations c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 lam
    (crossEquations_of_cross_eq c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 lam hnorm hU hV)

omit [CharZero R] in
lemma sub_smul_cross_eq_of_cross_eq (p q x y rho : R) (h : p * y = q * x) :
    (p - rho * x) * y = (q - rho * y) * x := by
  linear_combination h

/-- Projective equality with the Hesse residual triple gives all recovery equations.
The scalar is normalized by the constant coefficient of the `W` quartic. -/
theorem recoveryEquations_of_projectiveResidual_eq (a b c d e f h i j k lam rho : R)
    (hrho : rho = ambientCoeffW a b c d e f h i j k 0 0)
    (hU : ∀ s t, ambientCoeffU a b c d e f h i j k s t * hesseQuarticW lam s t =
      ambientCoeffW a b c d e f h i j k s t * hesseQuarticU lam s t)
    (hV : ∀ s t, ambientCoeffV a b c d e f h i j k s t * hesseQuarticW lam s t =
      ambientCoeffW a b c d e f h i j k s t * hesseQuarticV lam s t) :
    RecoveryEquations a b c d e f h i j k lam rho := by
  have hnorm : recoveryCoeff44 a b c d e f h i j k lam rho = 0 := by
    simpa [hesseQuarticW, hrho] using
      (w_sub_smul_hesse_eq_sum a b c d e f h i j k lam rho 0 0).symm
  have hDU : ∀ s t : R, quartic (recoveryCoeff0 a b c d e f h i j k lam rho) (recoveryCoeff1 a b c d e f h i j k lam rho) (recoveryCoeff2 a b c d e f h i j k lam rho) (recoveryCoeff3 a b c d e f h i j k lam rho) (recoveryCoeff4 a b c d e f h i j k lam rho) (recoveryCoeff5 a b c d e f h i j k lam rho) (recoveryCoeff6 a b c d e f h i j k lam rho) (recoveryCoeff7 a b c d e f h i j k lam rho) (recoveryCoeff8 a b c d e f h i j k lam rho) (recoveryCoeff9 a b c d e f h i j k lam rho) (recoveryCoeff10 a b c d e f h i j k lam rho) (recoveryCoeff11 a b c d e f h i j k lam rho) (recoveryCoeff12 a b c d e f h i j k lam rho) (recoveryCoeff13 a b c d e f h i j k lam rho) (recoveryCoeff14 a b c d e f h i j k lam rho) s t * hesseQuarticW lam s t =
      quartic (recoveryCoeff30 a b c d e f h i j k lam rho) (recoveryCoeff31 a b c d e f h i j k lam rho) (recoveryCoeff32 a b c d e f h i j k lam rho) (recoveryCoeff33 a b c d e f h i j k lam rho) (recoveryCoeff34 a b c d e f h i j k lam rho) (recoveryCoeff35 a b c d e f h i j k lam rho) (recoveryCoeff36 a b c d e f h i j k lam rho) (recoveryCoeff37 a b c d e f h i j k lam rho) (recoveryCoeff38 a b c d e f h i j k lam rho) (recoveryCoeff39 a b c d e f h i j k lam rho) (recoveryCoeff40 a b c d e f h i j k lam rho) (recoveryCoeff41 a b c d e f h i j k lam rho) (recoveryCoeff42 a b c d e f h i j k lam rho) (recoveryCoeff43 a b c d e f h i j k lam rho) (recoveryCoeff44 a b c d e f h i j k lam rho) s t * hesseQuarticU lam s t := by
    intro s t
    simp only [quartic]
    rw [← u_sub_smul_hesse_eq_sum, ← w_sub_smul_hesse_eq_sum]
    exact sub_smul_cross_eq_of_cross_eq _ _ _ _ rho (hU s t)
  have hDV : ∀ s t : R, quartic (recoveryCoeff15 a b c d e f h i j k lam rho) (recoveryCoeff16 a b c d e f h i j k lam rho) (recoveryCoeff17 a b c d e f h i j k lam rho) (recoveryCoeff18 a b c d e f h i j k lam rho) (recoveryCoeff19 a b c d e f h i j k lam rho) (recoveryCoeff20 a b c d e f h i j k lam rho) (recoveryCoeff21 a b c d e f h i j k lam rho) (recoveryCoeff22 a b c d e f h i j k lam rho) (recoveryCoeff23 a b c d e f h i j k lam rho) (recoveryCoeff24 a b c d e f h i j k lam rho) (recoveryCoeff25 a b c d e f h i j k lam rho) (recoveryCoeff26 a b c d e f h i j k lam rho) (recoveryCoeff27 a b c d e f h i j k lam rho) (recoveryCoeff28 a b c d e f h i j k lam rho) (recoveryCoeff29 a b c d e f h i j k lam rho) s t * hesseQuarticW lam s t =
      quartic (recoveryCoeff30 a b c d e f h i j k lam rho) (recoveryCoeff31 a b c d e f h i j k lam rho) (recoveryCoeff32 a b c d e f h i j k lam rho) (recoveryCoeff33 a b c d e f h i j k lam rho) (recoveryCoeff34 a b c d e f h i j k lam rho) (recoveryCoeff35 a b c d e f h i j k lam rho) (recoveryCoeff36 a b c d e f h i j k lam rho) (recoveryCoeff37 a b c d e f h i j k lam rho) (recoveryCoeff38 a b c d e f h i j k lam rho) (recoveryCoeff39 a b c d e f h i j k lam rho) (recoveryCoeff40 a b c d e f h i j k lam rho) (recoveryCoeff41 a b c d e f h i j k lam rho) (recoveryCoeff42 a b c d e f h i j k lam rho) (recoveryCoeff43 a b c d e f h i j k lam rho) (recoveryCoeff44 a b c d e f h i j k lam rho) s t * hesseQuarticV lam s t := by
    intro s t
    simp only [quartic]
    rw [← v_sub_smul_hesse_eq_sum, ← w_sub_smul_hesse_eq_sum]
    exact sub_smul_cross_eq_of_cross_eq _ _ _ _ rho (hV s t)
  obtain ⟨hc0, hc1, hc2, hc3, hc4, hc5, hc6, hc7, hc8, hc9, hc10, hc11, hc12, hc13, hc14, hc15, hc16, hc17, hc18, hc19, hc20, hc21, hc22, hc23, hc24, hc25, hc26, hc27, hc28, hc29, hc30, hc31, hc32, hc33, hc34, hc35, hc36, hc37, hc38, hc39, hc40, hc41, hc42, hc43, hc44⟩ :=
    coefficients_eq_zero_of_projective_hesse (recoveryCoeff0 a b c d e f h i j k lam rho) (recoveryCoeff1 a b c d e f h i j k lam rho) (recoveryCoeff2 a b c d e f h i j k lam rho) (recoveryCoeff3 a b c d e f h i j k lam rho) (recoveryCoeff4 a b c d e f h i j k lam rho) (recoveryCoeff5 a b c d e f h i j k lam rho) (recoveryCoeff6 a b c d e f h i j k lam rho) (recoveryCoeff7 a b c d e f h i j k lam rho) (recoveryCoeff8 a b c d e f h i j k lam rho) (recoveryCoeff9 a b c d e f h i j k lam rho) (recoveryCoeff10 a b c d e f h i j k lam rho) (recoveryCoeff11 a b c d e f h i j k lam rho) (recoveryCoeff12 a b c d e f h i j k lam rho) (recoveryCoeff13 a b c d e f h i j k lam rho) (recoveryCoeff14 a b c d e f h i j k lam rho) (recoveryCoeff15 a b c d e f h i j k lam rho) (recoveryCoeff16 a b c d e f h i j k lam rho) (recoveryCoeff17 a b c d e f h i j k lam rho) (recoveryCoeff18 a b c d e f h i j k lam rho) (recoveryCoeff19 a b c d e f h i j k lam rho) (recoveryCoeff20 a b c d e f h i j k lam rho) (recoveryCoeff21 a b c d e f h i j k lam rho) (recoveryCoeff22 a b c d e f h i j k lam rho) (recoveryCoeff23 a b c d e f h i j k lam rho) (recoveryCoeff24 a b c d e f h i j k lam rho) (recoveryCoeff25 a b c d e f h i j k lam rho) (recoveryCoeff26 a b c d e f h i j k lam rho) (recoveryCoeff27 a b c d e f h i j k lam rho) (recoveryCoeff28 a b c d e f h i j k lam rho) (recoveryCoeff29 a b c d e f h i j k lam rho) (recoveryCoeff30 a b c d e f h i j k lam rho) (recoveryCoeff31 a b c d e f h i j k lam rho) (recoveryCoeff32 a b c d e f h i j k lam rho) (recoveryCoeff33 a b c d e f h i j k lam rho) (recoveryCoeff34 a b c d e f h i j k lam rho) (recoveryCoeff35 a b c d e f h i j k lam rho) (recoveryCoeff36 a b c d e f h i j k lam rho) (recoveryCoeff37 a b c d e f h i j k lam rho) (recoveryCoeff38 a b c d e f h i j k lam rho) (recoveryCoeff39 a b c d e f h i j k lam rho) (recoveryCoeff40 a b c d e f h i j k lam rho) (recoveryCoeff41 a b c d e f h i j k lam rho) (recoveryCoeff42 a b c d e f h i j k lam rho) (recoveryCoeff43 a b c d e f h i j k lam rho) (recoveryCoeff44 a b c d e f h i j k lam rho) lam hnorm hDU hDV
  exact ⟨hc0, hc1, hc2, hc3, hc4, hc5, hc6, hc7, hc8, hc9, hc10, hc11, hc12, hc13, hc14, hc15, hc16, hc17, hc18, hc19, hc20, hc21, hc22, hc23, hc24, hc25, hc26, hc27, hc28, hc29, hc30, hc31, hc32, hc33, hc34, hc35, hc36, hc37, hc38, hc39, hc40, hc41, hc42, hc43, hc44⟩

/-- **Projective full residual-map rigidity in Hesse coordinates.**
Two cross-product identities and one nonzero normalized coordinate recover the cubic. -/
theorem eq_hesse_of_projective_fullResidual_eq (a b c d e f h i j k lam rho : R)
    (hrho : rho = ambientCoeffW a b c d e f h i j k 0 0) (hrho0 : rho ≠ 0)
    (hU : ∀ s t, ambientCoeffU a b c d e f h i j k s t * hesseQuarticW lam s t =
      ambientCoeffW a b c d e f h i j k s t * hesseQuarticU lam s t)
    (hV : ∀ s t, ambientCoeffV a b c d e f h i j k s t * hesseQuarticW lam s t =
      ambientCoeffW a b c d e f h i j k s t * hesseQuarticV lam s t) :
    b = 0 ∧ c = 0 ∧ e = 0 ∧ h = 0 ∧ i = 0 ∧ j = 0 ∧ d = a ∧ k = a ∧ f = -3 * lam * a :=
  eq_hesse_of_recoveryEquations a b c d e f h i j k lam rho hrho0
    (recoveryEquations_of_projectiveResidual_eq a b c d e f h i j k lam rho hrho hU hV)

/-- Convenience form normalized directly by the `W` value at the affine origin. -/
theorem eq_hesse_of_projective_fullResidual_eq_at_origin (a b c d e f h i j k lam : R)
    (hW0 : ambientCoeffW a b c d e f h i j k 0 0 ≠ 0)
    (hU : ∀ s t, ambientCoeffU a b c d e f h i j k s t * hesseQuarticW lam s t =
      ambientCoeffW a b c d e f h i j k s t * hesseQuarticU lam s t)
    (hV : ∀ s t, ambientCoeffV a b c d e f h i j k s t * hesseQuarticW lam s t =
      ambientCoeffW a b c d e f h i j k s t * hesseQuarticV lam s t) :
    b = 0 ∧ c = 0 ∧ e = 0 ∧ h = 0 ∧ i = 0 ∧ j = 0 ∧ d = a ∧ k = a ∧ f = -3 * lam * a :=
  eq_hesse_of_projective_fullResidual_eq a b c d e f h i j k lam
    (ambientCoeffW a b c d e f h i j k 0 0) rfl hW0 hU hV

end BConicBundleMultisections.HesseProjectiveResidualRigidity
