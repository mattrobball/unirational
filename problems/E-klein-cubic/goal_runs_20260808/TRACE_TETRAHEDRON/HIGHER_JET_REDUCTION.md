# Higher-jet and norm-fibre reduction for a four-term tetrahedron

**Date:** 2026-08-08  
**Result:** `F55-TRACE-FOUR-TERM-TETRAHEDRAL-NORM-FIBRE-REDUCTION`  
**Headline:** open

This continues `FIXED_POINT_TANGENT_REDUCTION.md`.  Assume a hypothetical
four-term trace zero has affinely independent support.  The preceding theorem
then puts all four exponents in one degree residue modulo five, gives
`sum A_j=0`, and leaves at most two spectral coefficient rays.  Here we use
the second and third local moments, without enumerating collision rows.

## 1. Shifted moments

Let `h in V_Q` satisfy

\[
 (2+\sigma)h=-e_2,
\]

and put `z_j=s_j+h`.  On the rational character cover,

\[
 b=\chi^h a=\sum_jA_j\chi^{z_j}
\]

satisfies

\[
 b^2\sigma(b)=c a^2\sigma(a).                             \tag{1.1}
\]

Thus the local trace equation has no coefficient character.  Define its
first three moment polynomials by

\[
\begin{aligned}
 L(x)&=\sum_jA_j\langle z_j,x\rangle,\\
 Q(x)&=\sum_jA_j\langle z_j,x\rangle^2,\\
 R(x)&=\sum_jA_j\langle z_j,x\rangle^3.                  \tag{1.2}
\end{aligned}
\]

The first moment is unchanged by the common shift because `sum A_j=0`.
By Galois symmetry, treat the ray

\[
 L=a x_1+b x_4\in U_{14}=V_1\oplus V_4.                 \tag{1.3}
\]

Both `a` and `b` are nonzero.  A pure eigenline in the rational
three-dimensional support-difference plane would bring all four Galois
conjugate eigenlines into that plane, which is impossible.

## 2. Mixed degree-four equations

Let `L_i,Q_i,R_i` denote the conjugate moment polynomials.  The degree-four
jet of the trace is

\[
 J_4=\sum_i\left(L_iQ_iL_{i+1}+\frac12L_i^2Q_{i+1}\right). \tag{2.1}
\]

Write `q_pq` for the coefficient of `x_p x_q` in `Q`, with `p<=q`.
Exact character collection gives

\[
 \boxed{q_{12}=q_{23}=q_{34}=0}                            \tag{2.2}
\]

and

\[
\begin{aligned}
0={}&-(\zeta^3+2\zeta)a^2q_{44}
 +2(\zeta^3+\zeta^2)abq_{14}\\
 &+(2\zeta^3+\zeta^2+2\zeta+2)b^2q_{11}.                 \tag{2.3}
\end{aligned}
\]

All displayed cyclotomic factors used in (2.2) are nonzero.

There is a useful independent view of `q_23`.  Restrict the source tangent
space to the kernel `U_23` of (1.3), with coordinates `x_2,x_3`.  Then

\[
 Q_i=q_{22}\zeta^{4i}x_2^2+q_{23}x_2x_3
      +q_{33}\zeta^i x_3^2.
\]

In Fourier coordinates `(Z_0,Z_1,Z_4)`, the Klein cubic restricts to

\[
 K=5Z_0\left(Z_0^2+2(1+\zeta+\zeta^4)Z_1Z_4\right).       \tag{2.4}
\]

Thus the pure second-jet restriction alone gives

\[
 q_{23}=0\quad\text{or}\quad
 q_{23}^2+2(1+\zeta+\zeta^4)q_{22}q_{33}=0.               \tag{2.5}
\]

The mixed jet (2.1) selects the first branch `q_23=0`.

## 3. The third mixed moments

The degree-five jet is

\[
\begin{aligned}
J_5=\sum_i\bigg(&\frac13L_iR_iL_{i+1}
 +\frac14Q_i^2L_{i+1}
 +\frac12L_iQ_iQ_{i+1}
 +\frac16L_i^2R_{i+1}\bigg).                              \tag{3.1}
\end{aligned}
\]

After (2.2), two of its character coefficients give

\[
 \boxed{r_{223}=r_{233}=0}.                               \tag{3.2}
\]

Equivalently, if

\[
 u_j=(z_j)_2,\qquad v_j=(z_j)_3,
\]

then (using the harmless multinomial factors)

\[
\begin{gathered}
 \sum_jA_j=\sum_jA_ju_j=\sum_jA_jv_j=0,\\
 \sum_jA_ju_jv_j=\sum_jA_ju_j^2v_j
 =\sum_jA_ju_jv_j^2=0.                                  \tag{3.3}
\end{gathered}
\]

## 4. Four atoms force a common norm fibre

Consider the `3 by 4` evaluation matrix whose `j`-th column is

\[
 (1,u_j,v_j)^{\mathsf T}.                                 \tag{4.1}
\]

It has rank three.  Indeed, if the four projected points `(u_j,v_j)` had
affine span at most one, the rational three-plane `H_C` spanned by the
support differences would meet the projection kernel `U_14` in dimension at
least two.  The fixed-point reduction proved instead that
`dim(H_C intersect U_14)=1`.

By the first line of (3.3), the nonzero vector `(A_j)` spans the kernel of
(4.1).  By the second line, the vector

\[
 (A_ju_jv_j)_j
\]

lies in the same one-dimensional kernel.  Hence it is a scalar multiple of
`(A_j)`.  Since every `A_j` is nonzero,

\[
 \boxed{u_0v_0=u_1v_1=u_2v_2=u_3v_3=\lambda.}            \tag{4.2}
\]

The scalar is nonzero.  Each `z_j` is a nonzero rational vector: `z_j=0`
would say `h in M`, contrary to the order-eleven cokernel obstruction.  A
nonzero rational vector in the irreducible `Q[C_5]`-module has no zero
Fourier component, because one zero component would give four zero
components under Galois conjugacy.

Identify `V_Q` with `F=Q(zeta_5)`.  The components with weights two and three
are complex-conjugate embeddings.  Applying Galois conjugacy to (4.2) also
makes the weight-one/weight-four products equal.  Therefore (4.2) is exactly
the intrinsic statement

\[
 \boxed{
 N_{F/F^+}(z_0)=N_{F/F^+}(z_1)=N_{F/F^+}(z_2)=N_{F/F^+}(z_3)\ne0,
 \quad F^+=\mathbf Q(\sqrt5).}                            \tag{4.3}
\]

Thus every same-residue affine tetrahedron surviving through the third mixed
moment consists of four shifted lattice points on one nonzero CM norm fibre.

## 5. Remaining exact boundary

For each affinely independent four-point support, the current necessary
normal form is:

1. one common degree residue modulo five;
2. one of at most two spectral coefficient rays;
3. the second-moment slice (2.2)--(2.3);
4. one common nonzero relative norm (4.3);
5. the remaining six degree-five moment equations from (3.1), followed by
   all higher jets or the full Laurent identity.

The norm value and the lattice shell are not bounded uniformly, so (4.3)
does not produce a finite list of supports.  It is also not a point: no
support satisfying all trace classes has been constructed.  The formal
third-moment equations retain sufficient freedom that no affine-rank drop
follows from the jet identities alone.

```text
F55-TRACE-FOUR-TERM-TETRAHEDRAL-NORM-FIBRE-REDUCTION
F55-TRACE-FOUR-TERM-QUESTION-OPEN
F55-GLOBAL-QUESTION-OPEN
```
