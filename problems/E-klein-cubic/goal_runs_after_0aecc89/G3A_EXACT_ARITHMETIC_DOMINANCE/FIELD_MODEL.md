# G3A field model — exact `K_proj` arithmetic

## Object

\[
K_{\mathrm{proj}} = k\bigl(\mathbf P(W)\bigr)^G
= \operatorname{Frac}(R)_{(0)},
\qquad R = \operatorname{Sym}(W^*)^G.
\]

In the certified Hironaka presentation,

\[
A=\mathbf Q[f_3,f_5,f_6,f_8,f_{11}],\qquad
\operatorname{rank}_A R = 12,
\]

with free secondary basis

\[
1,f_7,f_9,f_{10},f_{12},f_{14},f_7^2,f_7f_9,f_9^2,f_9f_{10},f_7^3,f_9^2f_{10}
\]

of degrees \((0,7,9,10,12,14,14,16,18,19,21,28)\).

Normalizing by \(\tau=f_3^2/f_5\) yields the degree-zero model

\[
K_{\mathrm{proj}}/P_0,\qquad
P_0=\mathbf Q(t_3,t_6,t_8,t_{11}),\qquad
t_d=f_d/\tau^{d},
\]

as a free rank-12 algebra over \(P_0\) with basis \(b_i/\tau^{\deg b_i}\).

## Structure constants

All 78 unordered products of secondary basis elements are reduced exactly over
\(\mathbf Q\) and normalized into

```text
tmp/kproj_arithmetic/normalized_kproj_table.json
```

(bound by SHA-256 in `INPUT_MANIFEST.json`).  The G3A API
`src/field_api.py` loads those constants and supplies

```text
add, scale, multiply, eq, trace, norm, inverse_with_open, basis
```

on length-12 vectors over \(\mathbf Q(t_3,t_6,t_8,t_{11})\).

## Inversion opens

`inverse_with_open(v)` returns the inverse together with

- \(\det L_v\) (determinant of left multiplication by \(v\));
- the open condition \(\det L_v\neq 0\);
- the coordinate denominators of the cancelled inverse.

Every inversion used by G3A therefore carries an explicit localization open.

## Independent checks (`verify_field.py`)

1. Manifest hash of the normalized table.
2. Unit laws and basis multiplications.
3. Commutativity on all basis pairs.
4. Hostile associativity sample on eight triples.
5. \(\operatorname{Tr}(1)=12\), \(\operatorname{N}(1)=1\).
6. Inverse of \(1+t_3 e_1\) and of \(e_1\), with open records.
7. Certificate cross-check of table statistics (647 nonzero entries).

Full 12³ associativity of the table is certified upstream by
`tmp/kproj_arithmetic/compile_table.py` / `verify.py` (consumed by hash).

## Minimal polynomials (`verify_field.py`)

Over a good specialization \(P_0\to\mathbf Q\), for the unit and a fixed hostile
set of elements the verifier independently:

1. builds the left-multiplication matrix \(L_v\);
2. computes the characteristic polynomial \(\chi_v\) and minimal polynomial \(\mu_v\);
3. checks \(\mu_v\mid\chi_v\);
4. checks Cayley–Hamilton \(\chi_v(L_v)=0\);
5. checks algebra annihilation \(\mu_v(v)=0\) in the 12-dimensional model;
6. checks \(\mu_1(x)=x-1\).
