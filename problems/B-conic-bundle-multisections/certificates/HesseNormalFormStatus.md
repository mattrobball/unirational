# Hesse normal form: verified projective bridge

This note records the checked Hesse-normal-form layer used by
`Standard.exists_pencil_of_hasCommonResidualLineMap`.  It describes only declarations and commands
verified against the pinned Lean/Mathlib toolchain `v4.32.1` on 2026-07-25.

## Final theorem

`BConicBundleMultisections/HesseNormalFormBridge.lean` proves

```lean
BConicBundleMultisections.HesseNormalForm.exists_hesseNormalForm_coordinates
  [Field k] [CharZero k] [IsAlgClosed k]
  (f : MvPolynomial (Fin 3) k)
  (hsmooth : Standard.IsSmoothPlaneCubic f) :
  ∃ (lam c : k) (M N : Matrix (Fin 3) (Fin 3) k),
    lam ^ 3 ≠ 1 ∧ c ≠ 0 ∧ M * N = 1 ∧ N * M = 1 ∧
      (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) k →ₐ[k] _) f =
        C c * hesseCubic lam
```

Thus every smooth ternary cubic over an algebraically closed characteristic-zero field is carried
by an explicitly invertible projective linear substitution to a nonzero scalar multiple of a
smooth Hesse cubic.  This is the full plane-embedding statement; it is stronger than the earlier
same-`j` Weierstrass endpoint.

## Checked proof layers

### Elementary Hesse family

`BConicBundleMultisections/HesseNormalForm.lean` proves:

* `hesseCubic_isHomogeneous` and the three explicit Jacobian formulas;
* `isSmoothPlaneCubic_hesseCubic_iff`: smoothness is equivalent to `lam ^ 3 ≠ 1`;
* `exists_hesseParameter_jValue_eq`: the classical Hesse `j`-parameter is surjective over an
  algebraically closed characteristic-zero field;
* `exists_hesseParameter_variableChange_to_ofJ`: the strongest abstract Weierstrass consequence.

### Flex and tangent-adapted coordinates

`BConicBundleMultisections/HesseNormalFormFlex.lean` proves:

* existence of a common nonzero zero of a ternary cubic and its Hessian;
* Hessian covariance under a linear substitution, including the determinant-square law;
* a `Fin 3`-indexed tangent-adapted basis and inverse basis matrices;
* `normalized_hessianZero_coefficients`, the local Hessian calculation at `(0:1:0)`;
* `coeffU3_ne_zero_of_smooth_of_lineSupport`, excluding a line component by an explicit singular
  point;
* `exists_weierstrassSupport_coordinates`, giving inverse matrices and a smooth transformed cubic
  with

  ```text
  coeffV3 = coeffUV2 = coeffU2V = 0,
  coeffV2W = 1,
  coeffU3 != 0.
  ```

### Explicit Hesse Weierstrass model

`BConicBundleMultisections/HesseNormalFormWeierstrass.lean` supplies inverse matrices between a
smooth Hesse cubic and the explicit Weierstrass equation

```text
a1 = -lam*u,  a2 = -lam^2*u^2,  a3 = -1,  a4 = 0,  a6 = -1/3,
(lam^3 - 1) * u^3 = 3.
```

It checks the polynomial identity, discriminant, `c4`, ellipticity, and equality of `j` with
`hesseJValue lam`.

### Projectivized same-`j` comparison

`BConicBundleMultisections/HesseNormalFormBridge.lean` adds:

* `variableChangeMatrix` and `variableChangeMatrixInv`, with both inverse identities;
* `aeval_variableChangeMatrix_weierstrassPolynomial`, proving that Mathlib's abstract admissible
  `WeierstrassCurve.VariableChange` is induced by the expected homogeneous `3 x 3` matrix, with
  equation factor `u^6`;
* identification of the local short Weierstrass cubic with Mathlib's projective polynomial and its
  discriminant;
* `aeval_weierstrassToHesseMatrix_hesseWeierstrassPolynomial`, the inverse explicit Hesse endpoint;
* the final composition `exists_hesseNormalForm_coordinates`.

The arbitrary-cubic-to-short-Weierstrass reduction is reused from
`BConicBundleMultisections/ShortWeierstrassNormalForm.lean`; the bridge does not duplicate that
coordinate calculation.

## Axiom audit

`BConicBundleMultisections/HesseNormalFormAxiomAudit.lean` imports the full bridge and prints the
axioms of the principal declarations.  In particular,

```text
exists_hesseNormalForm_coordinates
```

depends only on

```text
propext, Classical.choice, Quot.sound
```

and not on `sorryAx`.  The downstream theorem
`Standard.exists_pencil_of_hasCommonResidualLineMap` is now also proved from this normal form and
the finite Hesse residual certificate.

## Verified commands

```sh
lake env lean BConicBundleMultisections/HesseNormalFormFlex.lean
lake env lean BConicBundleMultisections/HesseNormalFormWeierstrass.lean
lake env lean BConicBundleMultisections/HesseNormalFormBridge.lean
lake build BConicBundleMultisections.HesseNormalFormBridge
lake env lean BConicBundleMultisections/HesseNormalFormAxiomAudit.lean
```

All commands exited successfully.  The targeted bridge build completed all 2570 jobs.  Its output
contains inherited lint warnings; the new Hesse modules contain no `sorry` or custom axiom.

## Remaining boundary

The projective Hesse-normal-form bridge and the residual-pencil consumer are closed.  In particular,
`GoodLineExistenceAxiomAudit.lean` checks `exists_good_line` without `sorryAx`.  This closes G3 only:
the source's separate conditions (2) and (3) are not included, and this note makes no claim that the
headline unirationality theorem is complete.
