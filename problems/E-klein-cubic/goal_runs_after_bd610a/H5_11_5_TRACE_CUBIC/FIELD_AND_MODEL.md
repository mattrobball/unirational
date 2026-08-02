# H5.0 — field and model audit

## Binding

This packet consumes the sealed H4 model

```text
goal_runs_after_35fa/H_11_5_TWIST/
exit: H-11_5-NORM-MODEL-PASS
```

by path and SHA-256 in `INPUT_MANIFEST.json`.  It does not re-derive the
Hilbert--90 transition from scratch; it audits the load-bearing formulas and
replays the modular anchors.

## Fields

\[
 E=\mathbf C(r_0,\ldots,r_4)/(r_0r_1r_2r_3r_4-1),\qquad
 \sigma(r_i)=r_{i+1},\qquad
 K=E^{\langle\sigma\rangle}=\mathbf C(U_1,U_2,U_3,U_4).
\]

Independent lattice checks in `verify.py`:

- each `r_i` exponent vector is degree zero and `C_{11}`-invariant for weights
  `(1,9,4,3,5)`;
- the four-by-four minor of the first four `r`-exponents on affine ratios has
  determinant `11`, matching H4.

The Fourier presentation of `K` (generators `U_j`, inverse DFT for the `R_i`)
is taken from `field_model.json` and is not expanded into an unrelated Schur
frame.

## Trace cubic

With `a=Z(r_0)` and `Z(T)=z_0+z_1T+\cdots+z_4T^4`, `z_j\in K`,

\[
 \Phi(a)
 =\operatorname{Tr}_{E/K}\bigl(r_2^{-1}a^2\sigma(a)\bigr)
 =\sum_{i\in\mathbf Z/5}
   \frac{Z(r_i)^2 Z(r_{i+1})}{r_{i+2}}.
\]

On the H4 common-open witness at `p=89`, `verify.py` rebuilds all nonzero
cubic coefficients and matches `twist_model.json`.  The identity

\[
 F(A(y)u)=F(B(y)z)=\Phi(z)
\]

is the H4 equivalence; this packet treats `Phi=0` as the genuine generic
`11:5` twist on the installed open.

## Coefficient and index boundary

- `N_{E/K}(r_2^{-1})=1`, but `r_2^{-1}` has exact order eleven modulo
  `d\mapsto d^2\sigma(d)` (H4; restated in `COEFFICIENT_CLASS.md`).
- The degree-five closed point over `E` and a degree-three linear section give
  index one only; neither is a `K`-point.

## Open conditions

The common open recorded by H4 remains the working locus:

```text
product_i(y_i)
* product_h ell(rho(h^{-1})y)
* det(A)
* product_{i<j}(r_j-r_i)
* s0 * q1 != 0.
```

No smoothness failure was introduced by the screens below; specialized fibres
over the modular primes used here carried the full 34–35 nonzero cubic
monomials in the sample rows.
