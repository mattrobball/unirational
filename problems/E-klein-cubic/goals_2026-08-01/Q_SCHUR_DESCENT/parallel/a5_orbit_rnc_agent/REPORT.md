# Degree-11 `A5` orbits fail the rational-normal-quartic test

## Exact verdict

The exact degree-11 `A5` point packet does **not** literally use the
restriction of the five-dimensional full Schur source: its generic torsor is
built from the faithful three-dimensional icosahedral source.  It does,
however, construct an exact `A5`-equivariant polynomial map

\[
 \Psi_i:\mathbf P(V_3)\dashrightarrow X_{\rm Klein}\subset\mathbf P(W)
\]

for each of the two maximal `A5` classes, and the verifier independently
identifies the target with the restriction of the original Klein
representation and cubic.

This packet supplies the missing bridge to the genuine Schur source.  For
`H=A5`, put

\[
 B_H(v)=\sum_{h\in H}
 \frac{(\rho(h^{-1})v)_0}
 {(\rho(h^{-1})v)_0+2(\rho(h^{-1})v)_1+\cdots+5(\rho(h^{-1})v)_4}
 \sigma(h),
 \qquad y_H(v)=B_H(v)e_0.
\]

Then `B_H(rho(h)v)=sigma(h)B_H(v)`.  Consequently

\[
 q_H(v)=\Psi_i(y_H(v))
\]

is an `H`-covariant point of the original Klein cubic.  If `A_G` is the full
Schur Hilbert--90 frame, `A_G(v)^{-1}q_H(v)` is therefore an
`E^H`-point on the genuine Schur twist.  At the good prime `89` and
`v=(1,4,5,5,6)`, the two transfer-frame determinants are respectively
`64` and `73`, so both transfers are genuinely defined and generically
invertible in characteristic zero.

For right-coset representatives `g` of `G/H`, the eleven conjugates, before
the common projective transformation `A_G(v)^{-1}`, are

\[
 p_g(v)=\rho(g)q_H(\rho(g^{-1})v).
\]

The replay checks that all eleven are nonzero, pairwise distinct, and lie on
the original Klein cubic.

For eleven points in `P4`, evaluate the fifteen quadrics.  If the points lie
on a rational normal quartic `R`, the evaluation rank is at most

\[
 h^0(R,\mathcal O_R(2))=h^0(\mathbf P^1,\mathcal O(8))=9;
\]

equivalently at least six independent quadrics contain them.  The exact
good-prime result is instead:

| transferred point | distinct points | quadric rank | quadrics through |
|---|---:|---:|---:|
| class 1, `alpha=80 mod 89` | 11 | 11 | 4 |
| class 2, `alpha=49 mod 89` | 11 | 11 | 4 |
| class 2, `alpha=51 mod 89` | 11 | 11 | 4 |
| class 2, `alpha=75 mod 89` | 11 | 11 | 4 |

Thus these transferred degree-11 point orbits do not lie on a rational
normal quartic.  This is a characteristic-zero theorem, not merely negative
specialization evidence: generic RNC incidence would force every `10 x 10`
minor of the quadric-evaluation matrix to vanish identically, hence also at
every good reduction where the formulas are defined.  The displayed rank
`11` specialization contradicts that necessary determinantal identity.

## Scope

This closes only this natural residual-point attempt.  It does not rule out
another `E^H`-point, another transfer column or rational source section, or a
different useful curve through an eleven-point orbit.  It supplies neither a
point nor a pointlessness theorem for the full Schur twist.  The global
status remains `Q-UNDECIDED`.

