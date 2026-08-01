# Minimal invariant-field presentation

## 1. The normal cyclic layer

Use the exact basis in which

\[
 T=\operatorname{diag}(\zeta^{a_0},\ldots,\zeta^{a_4}),
 \qquad (a_0,\ldots,a_4)=(1,9,4,3,5),
\]

and `P(e_i)=e_(i+1)`.  Then `P*T*P^-1=T^5`.  Put

\[
 L=\mathbf C(\mathbf P^4),\qquad
 r_i=\frac{y_{i+1}y_{i+2}}{y_i^2}\qquad(i\bmod 5).
\]

The weight identity

\[
 -2a_i+a_{i+1}+a_{i+2}=0\pmod {11}
\]

shows that every `r_i` is `C11`-invariant, and
`product_i r_i=1`.

On `y0 != 0`, the exponent columns of `r0,r1,r2,r3` in the four affine
ratios are

\[
 M=
 \begin{pmatrix}
 1&-2&0&0\\
 1& 1&-2&0\\
 0& 1& 1&-2\\
 0& 0& 1& 1
 \end{pmatrix},\qquad \det M=11.
\]

The `C11` character map on the projective exponent lattice is surjective,
so its kernel has index eleven.  The displayed lattice has that same index;
hence it is the whole invariant lattice.  Therefore

\[
 \boxed{E=L^{C_{11}}
 =\mathbf C(r_0,\ldots,r_4)/(r_0r_1r_2r_3r_4-1).}
\]

Define the field action by `sigma(f)(y)=f(P^-1 y)`.  Then
`sigma(r_i)=r_(i+1)` and

\[
 K=L^H=E^{\langle\sigma\rangle}.
\]

## 2. Four independent generators for `K`

Set

\[
 [R_0:\cdots:R_4]
 =\left[1:r_0^{-1}:(r_0r_1)^{-1}:
 (r_0r_1r_2)^{-1}:(r_0r_1r_2r_3)^{-1}\right].
\]

Thus `r_i=R_i/R_(i+1)`.  Projectively, `sigma[R_i]=[R_(i+1)]`.
Because the base field is `C`, fix a primitive fifth root `epsilon` and put

\[
 s_j=\sum_{i=0}^4\epsilon^{-ij}R_i,qquad q_j=s_j/s_0.
\]

On `s0 != 0`,

\[
 \sigma(q_j)=\epsilon^j q_j.
\]

On the further open `q1 != 0`, define

\[
 U_1=q_1^5,qquad U_2=q_2/q_1^2,qquad
 U_3=q_3/q_1^3,qquad U_4=q_4/q_1^4.
\]

Then

\[
 \boxed{K=\mathbf C(U_1,U_2,U_3,U_4)}
\]

is a minimal transcendence-basis presentation.  Indeed

\[
 E=K(\alpha),\qquad \alpha=q_1,qquad \alpha^5=U_1,
\]

and `q_j=U_j alpha^j` for `j=2,3,4`.  Conversely, inverse Fourier transform
gives, up to one common projective factor,

\[
 R_i=1+\sum_{j=1}^4\epsilon^{ij}q_j,qquad
 r_i=R_i/R_{i+1}.
\]

These are the forward and inverse rational maps, not only a list of
invariants.  The exact common chart is

```text
product_i(y_i) * s0 * q1 * product_i(R_i) != 0.
```

The modular witness in `field_model.json` checks the diagonal action,
invariance of all four `U_i`, and inverse DFT at `p=331`, where both fifth
and eleventh roots of unity exist.  The proof itself is the displayed
character-lattice calculation over `C`.
