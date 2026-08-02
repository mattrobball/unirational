# H5.3 — order-eleven coefficient class

## Statement recorded (from H4, not re-proved as a new theorem)

Let `psi(d)=d^2 sigma(d)`.  The class of `c=r_2^{-1}` (equivalently of `r_2`)
in `E^*/psi(E^*)` has exact order eleven.  A witness for the order is

\[
 d=r_1 r_2^6 r_3^{-2} r_4^2
 \quad\Rightarrow\quad
 psi(d)=r_2^{11}.
\]

`verify.py` checks the exponent identity for `psi(d)` against `r_2^{11}` on the
character lattice (modulo the product relation).

## Point boundary (H4)

\[
 X_T(K)\ne\varnothing
 \;\Longleftrightarrow\;
 c\cdot psi(E^*)\;\cap\;\ker(\operatorname{Tr}_{E/K})\;\ne\;\varnothing.
\]

By additive Hilbert 90 for the cyclic extension `E/K`,

\[
 \ker\operatorname{Tr}_{E/K}=\{b-\sigma(b):b\in E\}.
\]

Thus solubility is equivalent to the existence of nonzero `a` with

\[
 r_2^{-1}a^2\sigma(a)=b-\sigma(b)
\]

for some `b\in E`.

## H5.3 decision in this packet

| Acceptable outcome | Status |
|---|---|
| obstruction theorem ⇒ pointlessness | **not obtained** |
| exact counterexample point with nontrivial class | **not obtained** |
| reduction to a named computable torsor with local invariants | **not completed** |
| proof that the class is only a coordinate artifact | **not obtained** |

```text
h5_3_status: recorded; no obstruction theorem and no counterexample point
promotion: FORBIDDEN
```

The order computation itself is **not** promoted to a headline or to
`H5-POINTLESS-HEADLINE-NEGATIVE`.
