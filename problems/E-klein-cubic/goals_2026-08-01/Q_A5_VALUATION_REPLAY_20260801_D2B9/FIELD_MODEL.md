# Exact invariant-field and minimal twist models

Let \(V\) be the faithful three-dimensional icosahedral representation.
For the Reynolds invariants used by `build_minimal_model.py`, exact Molien
and Jacobian calculations give

\[
\mathbf C[V]^{A_5}
=\mathbf C[f_2,f_6,f_{10},f_{15}]/(f_{15}^2-R_{30}),
\qquad
K=\mathbf C(\mathbf P(V))^{A_5}=\mathbf C(U,V),
\]

where

\[
U=f_6/f_2^3,
\qquad
V=f_{10}/f_2^5.
\]

The target is the rational five-dimensional augmentation representation
coming from the action on the six Sylow-5 subgroups.  Five degree-10
Reynolds covariants form a generically invertible matrix \(C(y)\); its
determinant has exact nonzero reduction `39 mod 89`.  The covariant Molien
series proves that degree 10 is minimal among homogeneous polynomial frames:
every degree below 10 has generic evaluation rank at most four.

Write \(e=(e_0,\ldots,e_4)\), \(|e|=3\).  The payload
`minimal_model_payload.json` gives, for all 35 such exponents, exact
polynomials \(A_e(U,V),B_e(U,V)\) in the thirteen monomials

```text
1,U,U^2,U^3,U^4,U^5,V,UV,U^2V,U^3V,V^2,UV^2,V^3.
```

The two small twist equations are

\[
\sum_{|e|=3}\bigl(A_e(U,V)+t_iB_e(U,V)\bigr)z^e=0,
\]

with \(t_1=(4+\sqrt{-11})/9\) and
\(t_2=(4-\sqrt{-11})/9\).  The coefficient reduction is exact over
\(\mathbf Q(\sqrt5,\sqrt{-11})\), has a rank-13 good-reduction certificate,
and is checked on independent holdout evaluations.

For the authoritative Hilbert--90 frame

\[
A_i(y)=\sum_{h\in H_i}
\frac{(\sigma(h^{-1})y)_0}
{(\sigma(h^{-1})y)_0+2(\sigma(h^{-1})y)_1+3(\sigma(h^{-1})y)_2}
\rho(h),
\]

let \(J_i\) be the exact constant intertwiner and put
\(B_i=J_i^{-1}A_i\).  Then

\[
T_i=C^{-1}B_i\in\operatorname {GL}_5(K),
\]

and `installed coordinates -> minimal coordinates` is \(z\mapsto T_i z\).
This verifies exact equivalence with the original frame-substituted equation,
not merely with a good-reduction fibre.

