# Exact point on `A5_class_1`

Put \(E=\mathbf Q(\eta)\), where

\[
\eta=\sqrt5+\sqrt{-11},
\qquad \eta^4+12\eta^2+256=0.
\]

The script uses `u` for this constant \(\eta\); it is unrelated to the
invariant-field coordinate \(U=f_6/f_2^3\).  Let
\(R_0,\ldots,R_4:V\to W\) be the exact row-reduced degree-11 Reynolds
covariants reconstructed from the five seeds in
`class_1_exact_rref.json`.

The lexicographic certificate has the triangular form

```text
J[1] = a4^3 + ...
J[2] = a3 + q3(a4)
J[3] = a2 + q2(a4)
J[4] = a1 + q1(a4)
```

with every coefficient written exactly in `class_1_exact_rref.json` and
`class_1_exact_rref_lex.txt`.  Choose any root \(\theta\in\mathbf C\) of
`J[1]` and set

\[
(a_0,a_1,a_2,a_3,a_4)
=(1,-q_1(\theta),-q_2(\theta),-q_3(\theta),\theta).
\]

Then

\[
\Phi_1=R_0+a_1R_1+a_2R_2+a_3R_3+a_4R_4
\]

is nonzero and satisfies

\[
\left(C_0+\frac{13-\sqrt{-11}}{18}C_1\right)(\Phi_1(y))=0
\]

identically.  Completeness is not inferred from sample points: the target
is an invariant degree-33 form, that invariant space has dimension six, and
the six displayed evaluations have rank six.  Singular independently gives
`NONUNIT`, `ALL_SIX_REDUCE_ZERO`, and `VDIM 3`.

With the authoritative frame \(A_1\) and exact intertwiner \(J_1\), the
required projective coordinates are

\[
[z_1(y)]=[A_1(y)^{-1}J_1\Phi_1(y)]\in\mathbf P^4(K).
\]

On any nonzero coordinate chart, all coordinate ratios lie in
\(K=\mathbf C(\mathbf P^2)^{A_5}\).  Direct substitution gives
\(F_{\rm Klein}(A_1z_1)=F_{\rm Klein}(J_1\Phi_1)=0\).

The separate `point.json` records a second exact certificate in a raw
Reynolds basis.  `../common/verify_exact_points_direct.py` substitutes its
coordinates in exact arithmetic and checks both installed classes directly.
