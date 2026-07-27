/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.CoefficientVanishing
public import BConicBundleMultisections.HesseFullResidualRigidity
public import BConicBundleMultisections.NeZeroTwoThree

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

variable {R : Type u} [Field R] [Infinite R] [NeZero (2 : R)] [NeZero (3 : R)]

set_option maxRecDepth 100000 in
/-- **The 45 coefficients of a vanishing bidegree-`(8,8)` form vanish.**

Read the hypothesis as a polynomial in `t` whose coefficients are polynomials in `s`.  Over an
infinite domain each of those nine coefficients vanishes identically (`coeffs8_eq_zero` in `t`),
and then each of *their* coefficients vanishes (`coeffs8_eq_zero` again, in `s`).

This replaces an exact interpolation on the 45 integral points `0 ≤ s, t`, `s + t ≤ 8`, whose
Vandermonde inverse divides by `8! = 40320` and therefore needed `ringChar R ∉ {2, 3, 5, 7}`.
The argument below divides by nothing, so `Infinite R` — which `IsAlgClosed` supplies — is the
whole hypothesis. -/
theorem octic_coefficients_eq_zero (c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 c32 c33 c34 c35 c36 c37 c38 c39 c40 c41 c42 c43 c44 : R)
    (hzero : ∀ s t : R, octic (c0) (c1) (c2) (c3) (c4) (c5) (c6) (c7) (c8) (c9) (c10) (c11) (c12) (c13) (c14) (c15) (c16) (c17) (c18) (c19) (c20) (c21) (c22) (c23) (c24) (c25) (c26) (c27) (c28) (c29) (c30) (c31) (c32) (c33) (c34) (c35) (c36) (c37) (c38) (c39) (c40) (c41) (c42) (c43) (c44) s t = 0) :
    c0 = 0 ∧ c1 = 0 ∧ c2 = 0 ∧ c3 = 0 ∧ c4 = 0 ∧ c5 = 0 ∧ c6 = 0 ∧ c7 = 0 ∧ c8 = 0 ∧ c9 = 0 ∧ c10 = 0 ∧ c11 = 0 ∧ c12 = 0 ∧ c13 = 0 ∧ c14 = 0 ∧ c15 = 0 ∧ c16 = 0 ∧ c17 = 0 ∧ c18 = 0 ∧ c19 = 0 ∧ c20 = 0 ∧ c21 = 0 ∧ c22 = 0 ∧ c23 = 0 ∧ c24 = 0 ∧ c25 = 0 ∧ c26 = 0 ∧ c27 = 0 ∧ c28 = 0 ∧ c29 = 0 ∧ c30 = 0 ∧ c31 = 0 ∧ c32 = 0 ∧ c33 = 0 ∧ c34 = 0 ∧ c35 = 0 ∧ c36 = 0 ∧ c37 = 0 ∧ c38 = 0 ∧ c39 = 0 ∧ c40 = 0 ∧ c41 = 0 ∧ c42 = 0 ∧ c43 = 0 ∧ c44 = 0 := by
  -- Collect the hypothesis by powers of `t`; each coefficient is a polynomial in `s`.
  have hT : ∀ s : R,
      (c44 + c35 * s + c27 * s ^ 2 + c20 * s ^ 3 + c14 * s ^ 4 + c9 * s ^ 5 + c5 * s ^ 6 + c2 * s ^ 7 + c0 * s ^ 8 = 0) ∧
      (c43 + c34 * s + c26 * s ^ 2 + c19 * s ^ 3 + c13 * s ^ 4 + c8 * s ^ 5 + c4 * s ^ 6 + c1 * s ^ 7 = 0) ∧
      (c42 + c33 * s + c25 * s ^ 2 + c18 * s ^ 3 + c12 * s ^ 4 + c7 * s ^ 5 + c3 * s ^ 6 = 0) ∧
      (c41 + c32 * s + c24 * s ^ 2 + c17 * s ^ 3 + c11 * s ^ 4 + c6 * s ^ 5 = 0) ∧
      (c40 + c31 * s + c23 * s ^ 2 + c16 * s ^ 3 + c10 * s ^ 4 = 0) ∧
      (c39 + c30 * s + c22 * s ^ 2 + c15 * s ^ 3 = 0) ∧
      (c38 + c29 * s + c21 * s ^ 2 = 0) ∧
      (c37 + c28 * s = 0) ∧
      (c36 = 0) := by
    intro s
    exact coeffs8_eq_zero _ _ _ _ _ _ _ _ _ (fun t => by linear_combination hzero s t)
  -- Each of those nine polynomials in `s` vanishes identically, so its coefficients vanish.
  obtain ⟨hc44, hc35, hc27, hc20, hc14, hc9, hc5, hc2, hc0⟩ :=
    coeffs8_eq_zero c44 c35 c27 c20 c14 c9 c5 c2 c0
      (fun s => (hT s).1)
  obtain ⟨hc43, hc34, hc26, hc19, hc13, hc8, hc4, hc1, -⟩ :=
    coeffs8_eq_zero c43 c34 c26 c19 c13 c8 c4 c1 0
      (fun s => by linear_combination (hT s).2.1)
  obtain ⟨hc42, hc33, hc25, hc18, hc12, hc7, hc3, -, -⟩ :=
    coeffs8_eq_zero c42 c33 c25 c18 c12 c7 c3 0 0
      (fun s => by linear_combination (hT s).2.2.1)
  obtain ⟨hc41, hc32, hc24, hc17, hc11, hc6, -, -, -⟩ :=
    coeffs8_eq_zero c41 c32 c24 c17 c11 c6 0 0 0
      (fun s => by linear_combination (hT s).2.2.2.1)
  obtain ⟨hc40, hc31, hc23, hc16, hc10, -, -, -, -⟩ :=
    coeffs8_eq_zero c40 c31 c23 c16 c10 0 0 0 0
      (fun s => by linear_combination (hT s).2.2.2.2.1)
  obtain ⟨hc39, hc30, hc22, hc15, -, -, -, -, -⟩ :=
    coeffs8_eq_zero c39 c30 c22 c15 0 0 0 0 0
      (fun s => by linear_combination (hT s).2.2.2.2.2.1)
  obtain ⟨hc38, hc29, hc21, -, -, -, -, -, -⟩ :=
    coeffs8_eq_zero c38 c29 c21 0 0 0 0 0 0
      (fun s => by linear_combination (hT s).2.2.2.2.2.2.1)
  obtain ⟨hc37, hc28, -, -, -, -, -, -, -⟩ :=
    coeffs8_eq_zero c37 c28 0 0 0 0 0 0 0
      (fun s => by linear_combination (hT s).2.2.2.2.2.2.2.1)
  obtain ⟨hc36, -, -, -, -, -, -, -, -⟩ :=
    coeffs8_eq_zero c36 0 0 0 0 0 0 0 0
      (fun _ => by linear_combination (hT 0).2.2.2.2.2.2.2.2)
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
    linear_combination₆
      (2/3) * e2 +
      (-1/3) * e14 +
      (2/3) * e35 +
      (1) * e88
  have hc1 : c1 = 0 := by
    linear_combination₆
      (2/3) * e4 +
      (-1/3) * e19 +
      (2/3) * e42
  have hc2 : c2 = 0 := by
    linear_combination₆
      (2/3) * e5 +
      (-1/3) * e20 +
      (2/3) * e43
  have hc3 : c3 = 0 := by
    linear_combination₆
      (lam) * e5 +
      (-2*lam) * e20 +
      (1) * e25 +
      (lam) * e43 +
      (2/3) * e72 +
      (-4/3) * e75 +
      (8/3) * e78
  have hc4 : c4 = 0 := by
    linear_combination₆
      (1/2) * e8 +
      (1/6) * e73 +
      (-1/3) * e76
  have hc5 : c5 = 0 := by
    linear_combination₆
      (-1) * e0 +
      (1/2) * e9 +
      (-1/3) * e71 +
      (1/6) * e74 +
      (-1/3) * e77
  have hc6 : c6 = 0 := by
    linear_combination₆
      (1/2) * e29 +
      (-1/3) * e80 +
      (2/3) * e83 +
      (-4/3) * e86 +
      (-2) * e88
  have hc7 : c7 = 0 := by
    linear_combination₆
      (1) * e33 +
      (-2*lam) * e71 +
      (lam) * e74 +
      (-2*lam) * e77 +
      (2/3) * e81 +
      (-4/3) * e84 +
      (8/3) * e87
  have hc8 : c8 = 0 := by
    linear_combination₆
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
    linear_combination₆
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
    linear_combination₆
      (1/2) * e45
  have hc16 : c16 = 0 := by
    linear_combination₆
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
    linear_combination₆
      (2/3) * e4 +
      (-4/3) * e19 +
      (8/3) * e42 +
      (1) * e68 +
      (lam) * e81 +
      (-2*lam) * e84 +
      (lam) * e87
  have hc19 : c19 = 0 := by
    linear_combination₆
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
    linear_combination₆
      (2/3) * e72 +
      (-1/3) * e75 +
      (2/3) * e78
  have hc22 : c22 = 0 := by
    linear_combination₆
      (2/3) * e73 +
      (-1/3) * e76
  have hc23 : c23 = 0 := by
    linear_combination₆
      (-4/3) * e71 +
      (2/3) * e74 +
      (-1/3) * e77
  have hc24 : c24 = 0 := by
    linear_combination
      (1) * e78
  have hc25 : c25 = 0 := by
    linear_combination₆
      (2/3) * e80 +
      (-1/3) * e83 +
      (2/3) * e86 +
      (1) * e88
  have hc26 : c26 = 0 := by
    linear_combination₆
      (2/3) * e81 +
      (-1/3) * e84 +
      (2/3) * e87
  have hc27 : c27 = 0 := by
    linear_combination₆
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
    linear_combination₆
      (1/3) * e2 +
      (-2/3) * e14 +
      (4/3) * e35 +
      (2) * e88
  have hc33 : c33 = 0 := by
    linear_combination₆
      (-1/2) * e67 +
      (1) * e70 +
      (-(1/2)*lam) * e80 +
      (lam) * e83 +
      (-(1/2)*lam) * e86 +
      (3*lam) * e88
  have hc34 : c34 = 0 := by
    linear_combination₆
      (1/3) * e4 +
      (-2/3) * e19 +
      (4/3) * e42
  have hc35 : c35 = 0 := by
    linear_combination₆
      (1/3) * e5 +
      (-2/3) * e20 +
      (4/3) * e43
  have hc36 : c36 = 0 := by
    linear_combination
      (-1) * e71
  have hc37 : c37 = 0 := by
    linear_combination₆
      (1/3) * e72 +
      (-2/3) * e75 +
      (4/3) * e78
  have hc38 : c38 = 0 := by
    linear_combination₆
      (1/3) * e73 +
      (-2/3) * e76
  have hc39 : c39 = 0 := by
    linear_combination₆
      (-2/3) * e71 +
      (1/3) * e74 +
      (-2/3) * e77
  have hc40 : c40 = 0 := by
    linear_combination₆
      (1/2) * e28
  have hc41 : c41 = 0 := by
    linear_combination₆
      (1/3) * e80 +
      (-2/3) * e83 +
      (4/3) * e86 +
      (2) * e88
  have hc42 : c42 = 0 := by
    linear_combination₆
      (1/3) * e81 +
      (-2/3) * e84 +
      (4/3) * e87
  have hc43 : c43 = 0 := by
    linear_combination₆
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

omit [NeZero (2 : R)] [NeZero (3 : R)] in
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
