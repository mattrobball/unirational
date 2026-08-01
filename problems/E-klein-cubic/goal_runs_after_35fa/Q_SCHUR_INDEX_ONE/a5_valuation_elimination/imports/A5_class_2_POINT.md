# Exact point on `A5_class_2`

Put \(E=\mathbf Q(\eta)\), where

\[
\eta=\sqrt5+\sqrt{-11},
\qquad \eta^4+12\eta^2+256=0.
\]

The script uses `u` for this constant \(\eta\); it is unrelated to the
invariant-field coordinate \(U=f_6/f_2^3\).  Let
\(R_0,\ldots,R_4:V\to W\) be the exact row-reduced degree-11 Reynolds
covariants reconstructed from the five seeds in
`class_2_exact_rref.json`.

The lexicographic certificate has the triangular form

```text
J[1] = a4^3 + ...
J[2] = a3 + q3(a4)
J[3] = a2 + q2(a4)
J[4] = a1 + q1(a4)
```

with every coefficient written exactly in `class_2_exact_rref.json` and
`class_2_exact_rref_lex.txt`.  Choose any root \(\theta\in\mathbf C\) of
`J[1]` and set

\[
(a_0,a_1,a_2,a_3,a_4)
=(1,-q_1(\theta),-q_2(\theta),-q_3(\theta),\theta).
\]

Then

\[
\Phi_2=R_0+a_1R_1+a_2R_2+a_3R_3+a_4R_4
\]

is nonzero and satisfies

\[
\left(C_0+\frac{13+\sqrt{-11}}{18}C_1\right)(\Phi_2(y))=0
\]

identically.  Completeness is proved by the rank-six evaluation map on the
six-dimensional invariant degree-33 space.  This class has its own exact
input and output: Singular gives `NONUNIT`, `ALL_SIX_REDUCE_ZERO`, and
`VDIM 3`.

With the authoritative frame \(A_2\) and exact intertwiner \(J_2\), the
required projective coordinates are

\[
[z_2(y)]=[A_2(y)^{-1}J_2\Phi_2(y)]\in\mathbf P^4(K).
\]

On any nonzero coordinate chart, all coordinate ratios lie in
\(K=\mathbf C(\mathbf P^2)^{A_5}\).  Direct substitution gives
\(F_{\rm Klein}(A_2z_2)=F_{\rm Klein}(J_2\Phi_2)=0\).

The separate `point.json` records a second exact certificate in a raw
Reynolds basis.  `../common/verify_exact_points_direct.py` substitutes its
coordinates in exact arithmetic and checks both installed classes directly.
