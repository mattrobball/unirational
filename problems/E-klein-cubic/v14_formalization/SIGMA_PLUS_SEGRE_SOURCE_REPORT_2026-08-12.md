# Sigma-plus exact normal-form review

## Verdict

The requested `GL6 + Veronese` search is not the smallest natural certificate.
For the actual lifted operator one has `S6 = R6^3` and `S6^2 = -1`.  Hence over
`L = K(i)` the six-dimensional representation splits as `A (+i) + B (-i)`,
with `dim A = dim B = 3`.  The `+1` eigenspace in `Lambda^2` is the cross term
`A tensor B`, so its decomposable locus is a Segre `P(A) x P(B)`, not a
canonically chosen Veronese surface.

The current nine-dimensional restricted-Pluecker span is exactly the span of
the nine `2 x 2` minors of a `3 x 3` matrix of linear forms.  The plus curve is
therefore a codimension-three linear section of `Segre(P2 x P2)`.  This gives a
plane cubic by either projection, without solving a nonlinear 36-variable
`GL6` system or choosing a square root of the degree-six line bundle.

## Exact artifacts

* `/tmp/export_sigma_plus_segre.py`
* `/tmp/sigma_plus_segre_Ki.json`
* `/tmp/sigma_plus_smooth_mod89.m2`

The Python generator recomputes everything from
`results/d12_lean_K.json` and `results/sigma_normal_form_K.json`; it does not
trust Macaulay2 booleans or the stored echelon basis.  It proves by exact
arithmetic over `K(i)`:

1. `S6^2 = -I`, both eigenspaces have dimension three, and the eigenbasis
   matrix and its inverse multiply both ways to the identity.
2. `H : L^6 -> L^9` gives the nine cross coordinates.  The certificate stores
   `L H = I6`, `N H = 0`, and an invertible completion `T = [L;N]` whose inverse
   has first six columns exactly `H`.  Consequently `Nz=0` iff `z=H(Lz)`.
3. The nine minors of the `3 x 3` matrix `reshape(Hx)` have exactly the same
   quadratic span as all fifteen restricted Pluecker quadrics.  Both coefficient
   matrices are stored (`Qplus = U*minors`, `minors = V*Qplus`).
4. The three rows of `N` are three `(1,1)` equations on `P2 x P2`.  For fixed
   `u` they form a `3 x 3` matrix `A(u)`, and the stored ternary cubic is
   `F(u)=det A(u)` (all ten coefficients are nonzero before reduction).

The bidirectional point argument is now linear algebra:

* a nonzero common zero `x` gives nonzero `z=Hx`; the minor identities make
  `rank z <= 1`, hence over an algebraically closed extension `z=u tensor v`;
  `Nz=0` gives `A(u)v=0`, hence `F(u)=0`;
* if `F(u)=0`, choose nonzero `v in ker A(u)`; then `z=u tensor v` satisfies
  `Nz=0`, so `z=H(Lz)` by `T^{-1}` and `x=Lz` is a nonzero common zero of all
  restricted Pluecker quadrics.

The split-prime reduction uses `p=89`, `zeta11 -> 2`, `i -> 34` and gives

```
F89 = 45 U^3 + 20 U^2 V + 38 U V^2 + 26 V^3 + 6 U V W
      + 18 V^2 W + 42 U W^2 + 20 V W^2 + W^3.
```

The Macaulay2 replay checks all three projective charts and constructs explicit
Nullstellensatz coefficient columns `CU,CV,CW`, verifying
`gens(Jchart)*Cchart = 1`.  Thus the reduction is smooth, so the
characteristic-zero discriminant is nonzero.

## Reproduction

```
/opt/homebrew/bin/python3 /tmp/export_sigma_plus_segre.py
M2 --script /tmp/sigma_plus_smooth_mod89.m2
```

Expected Python payload hash:
`33e041bca84be0651701f95fca539be5293ef0f07131c49cb2b9fcbbe7f67b59`.

Expected JSON file SHA-256:
`52c1280a0a5e84128432db79e4d95753efe52a73d49a0fa450e69798a64965dc`.

The M2 replay must print `chart_smooth={true,true,true}` and exits through
assertions if any chart identity fails.

## Problem B handoff

After packaging the ternary cubic as `MvPolynomial (Fin 3) Omega`, the intended
consumer is
`BConicBundleMultisections.HesseNormalForm.exists_hesseNormalForm_coordinates`
from `HesseNormalFormBridge.lean`.  It takes
`Standard.IsSmoothPlaneCubic f` over an algebraically closed field and returns
both inverse coordinate matrices and an exact equality with a smooth Hesse
cubic.  `HesseNormalFormWeierstrass.lean` then supplies the explicit elliptic
Weierstrass endpoint.  Thus the faithful formal route is:

`Segre linear section -> exact determinant cubic -> smoothness certificate ->
Problem B Hesse/Weierstrass bridge`.

## Honest remaining boundary

This does **not** provide a `GL6` Veronese matrix over `K`.  Such a matrix is an
extra choice of a degree-three line bundle whose square is the degree-six
embedding line bundle; it need not descend to `K(i)` and is unnecessary for
the plane-cubic obstruction.  The exact Segre certificate and smooth cubic are
complete computationally, but their Lean serialization has not been written.
