# Canonical model and theorem scope

Let (H_i\cong A_5) be the two authoritative maximal-subgroup records in
`H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json`.  The verifier realizes the
unique rational five-dimensional irreducible (A_5)-module as the
augmentation subspace of the permutation module on the six Sylow-5
subgroups.  In coordinates (X_0+\cdots+X_5=0), put

\[
 S=\sum_iX_i^3,\qquad
 D=\sum_{I\in O_+}X_I-\sum_{I\in O_-}X_I.
\]

For exact intertwiners (J_i), the two restricted Klein cubics are scalar
multiples of

\[
 S+\frac{4+\sqrt{-11}}9D,\qquad
 S+\frac{4-\sqrt{-11}}9D.
\]

The degree-11 solver uses (C_0=-O_+), (C_1=-O_-).  Its equivalent pencil
parameters are respectively

\[
 \lambda_1=\frac{13-\sqrt{-11}}{18},\qquad
 \lambda_2=\frac{13+\sqrt{-11}}{18},
\]

because (3(1-\lambda_i)/(1+\lambda_i)=t_i).  The outer automorphism of
(\operatorname{PSL}_2(\mathbf F_{11})) and the coefficient automorphism
(\sqrt{-11}\mapsto-\sqrt{-11}) exchange the two records and parameters.

For the faithful icosahedral source, exact Reynolds invariants of degrees
2, 6, and 10 are algebraically independent; their Jacobian is the nonzero
degree-15 invariant.  The exact Molien series

\[
 \frac{1+q^{15}}{(1-q^2)(1-q^6)(1-q^{10})}
\]

then gives

\[
 \mathbf C(\mathbf P^2)^{A_5}
 =\mathbf C\left(f_6/f_2^3,\ f_{10}/f_2^5\right).
\]

The concrete frame comparison is bound to the authoritative degree-zero
Hilbert--90 seed (y_0/(y_0+2y_1+3y_2)) and its good-reduction witness
((1,2,5)).  If (A_i(y)) is that frame and (B_i=J_i^{-1}A_i), then

\[
 F_{\rm Klein}(A_i(y)z)
 =c_i\,(S+t_iD)(B_i(y)z)
\]

exactly; the verifier also checks the recorded frame, determinant, twist
coefficients, and this comparison modulo 89.

The exact degree-11 point calculation is complete because every
composed landing form is an invariant of degree 33, whose invariant space
has dimension six.  Six evaluations have rank six modulo 89, hence remain
injective in characteristic zero.  The resulting six cubic equations on
the chart (a_0=1) have a proper ideal of vector-space dimension 3 over
\(\mathbf Q(\sqrt5,\sqrt{-11})).  Thus both geometric landing schemes are
nonempty.  Transporting a landing covariant \(\Phi_i\) gives

\[
 z_i=A_i^{-1}J_i\Phi_i\in
 \mathbf P^4\bigl(\mathbf C(\mathbf P^2)^{A_5}\bigr),
\]

and (F_{\rm Klein}(A_i z_i)=0).  This proves a rational point on each of
the two specified generic (A_5)-twists.  It does not by itself assert
rationality of either twist or a conclusion for the full Klein group.

Replay the canonical comparison with:

```sh
/opt/homebrew/bin/python3 -u build_canonical_model.py
```

The exact landing transcripts are
`A5_class_1/class_1_exact_rref_{dp,lex}.txt` and
`A5_class_2/class_2_exact_rref_{dp,lex}.txt`.  Each pair begins with
`NONUNIT`; both lex transcripts certify `ALL_SIX_REDUCE_ZERO` and end with
`VDIM` equal to `3`.
