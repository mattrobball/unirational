# C6.0 — exact five-form matrix

## Convention

Ambient split space \(V=k^6\) with standard basis after Hilbert--90.  The five
alternating forms are

\[
A_i=Q(V_i(x)),\qquad V=(x,C,D,E,K),
\]

with \(Q\) the sealed linear Pfaffian map from
`involution.json` and frame vectors from `distinguished_five_plane.json`.

\[
M(u)=\begin{pmatrix} u^t A_1\\ \vdots\\ u^t A_5 \end{pmatrix}\in \mathrm{Mat}_{5\times 6}.
\]

## Certificates

1. **Skew / \(M(u)u=0\)**.  Each \(A_i\) is skew, so \(u^t A_i u=0\) and \(M(u)u=0\).
2. **Plücker agreement**.  \(\omega_i(u,v)=u^t A_i v\) equals the sealed generic
   Plücker hyperplane pairing on all tested fibres and by construction on the
   generic split model (same \(Q(V_i)\)).
3. **Morita same target**.  Common lines of the five forms are the split
   realization of the Morita isotropic right \(D\)-lines.
4. **\(K_{\mathrm{proj}}\) coefficients**.  Descent membership is the
   Galois-invariance + Morita trace-circuit certificate (see
   `five_form_matrix.json` ledger).  Flat secondary-basis 12-tuples for every
   matrix entry are **not** expanded in this packet.

## Serialization

Exact sparse matrices over \(\mathbf Q(\zeta_{11})[x]\) are in
`five_form_matrix.json`.  Modular multi-prime certificates cover primes
23, 331, 419, 463, 617.

## Marker

```text
C6-FIVE-FORM-MATRIX-PASS
```

C5 seed cross-check at \(p=23\): \(u=(16,3,22,17,7,8)\), \(v=(6,9,17,15,1,0)\)
gives all five pairings zero, \(\mathrm{rank}\,M(u)=4\), and \(Q(u)=0\).
