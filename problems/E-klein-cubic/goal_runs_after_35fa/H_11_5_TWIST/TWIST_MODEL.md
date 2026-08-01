# Equivalence with the genuine canonical twist

## 1. Canonical model

The authoritative packet defines

\[
 A(y)=\sum_{h\in H}
 \frac{(\rho(h^{-1})y)_0}
 {(\rho(h^{-1})y)_0+2(\rho(h^{-1})y)_1+
 3(\rho(h^{-1})y)_2+4(\rho(h^{-1})y)_3+
 5(\rho(h^{-1})y)_4}\rho(h)
\]

and the genuine twist `F(A(y)u)=0`.  It satisfies
`A(gy)=rho(g)A(y)`.

## 2. The adapted Vandermonde frame

Put

\[
 \beta=y_2/y_3,\qquad \beta_i=\sigma^i(\beta)=y_{i+2}/y_{i+3},
 \qquad B_{ij}=\beta_i r_i^j.
\]

The `T`-weight of `beta_i` is

\[
 a_{i+2}-a_{i+3}=a_i\pmod {11},
\]

while `r_i` has weight zero.  Also, row `i` of `B(Py)` is row `i-1` of
`B(y)`, exactly matching the permutation matrix `P`.  Hence

\[
 B(Ty)=TB(y),\qquad B(Py)=PB(y),
\]

and therefore `B(gy)=rho(g)B(y)` for every `g in H`.

Moreover

\[
 \det B=\left(\prod_i\beta_i\right)
 \prod_{i<j}(r_j-r_i)=\prod_{i<j}(r_j-r_i),
\]

because `product_i beta_i=1`.  Thus `B` is a genuine Hilbert--90 frame on
the Vandermonde open.

## 3. Pullback of the Klein equation

For `z=(z0,...,z4)`, set

\[
 Z(T)=\sum_{j=0}^4z_jT^j,\qquad a=Z(r_0)\in E.
\]

The `i`th coordinate of `Bz` is `beta_i Z(r_i)`.  Since

\[
 \beta_i^2\beta_{i+1}=\sigma^i(r_2^{-1}),
\]

literal substitution into `F=sum_i x_i^2 x_(i+1)` gives

\[
 F(Bz)=\sum_i\frac{Z(r_i)^2Z(r_{i+1})}{r_{i+2}}
 =\operatorname{Tr}_{E/K}(r_2^{-1}a^2\sigma(a)).
\]

Every coefficient is fixed by `sigma`, so this is a cubic over `K`.

## 4. Forward and inverse maps to the canonical equation

On the common open where both frames are invertible, define

\[
 C(y)=A(y)^{-1}B(y).
\]

The two covariance identities give `C(gy)=C(y)`, hence
`C in GL5(K)`.  The exact coordinate changes are

\[
 \begin{array}{rcl}
 \text{trace to canonical:}&&u=Cz,\\
 \text{canonical to trace:}&&z=C^{-1}u.
 \end{array}
\]

They satisfy

\[
 F(Au)=F(Bz)=\operatorname{Tr}_{E/K}(r_2^{-1}a^2\sigma(a)).
\]

The common open is explicitly

```text
product_i(y_i)
* product_(h in H) ell(rho(h^-1)y)
* det(A)
* product_(i<j)(r_j-r_i)
* s0*q1 != 0.
```

`twist_model.json` records a deterministic common-open witness modulo `89`.
The verifier independently reconstructs both frames, checks their covariance,
checks `A^-1 B` on the full generator orbit, and compares all 35 coefficients
of `F(Bz)` with the trace formula.  It separately reproduces the canonical
anchor `(denominator product, determinant)=(86,87)` and its full coefficient
table.  The model is therefore tied to the authoritative gauge in both
directions.
