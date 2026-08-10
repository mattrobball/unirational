# All-exponent exclusion of affine-tetrahedral four-term support

**Date:** 2026-08-08  
**Result:** `F55-TRACE-FOUR-TERM-AFFINE-RANK-THREE-EXCLUSION`  
**Boundary:** planar four-point supports remain open

## Theorem

Let

\[
 a=\sum_{j=0}^3A_j\chi^{s_j},\qquad A_0A_1A_2A_3\ne0,
\]

with four distinct exponents in `M`.  If `Phi(a)=0`, then the affine span of
the four `s_j` over `Q` has dimension at most two.

Equivalently, there is no four-term trace zero whose support is an affine
tetrahedron.  Exponents are unrestricted.

This does **not** exclude a segment, a triangle with a fourth lattice point,
or a general coplanar quadrilateral.

## 1. Inputs from the fixed-point and higher-jet reductions

Suppose for contradiction that the support is affinely independent.  The
five fixed torus points and cubic tangent tensor, proved in
`FIXED_POINT_TANGENT_REDUCTION.md`, give:

1. all four exponents have the same degree residue modulo five;
2. `sum A_j=0`;
3. after choosing one of the two conjugate spectral branches, the first
   moment lies in `U_14=V_1+V_4`, with both components nonzero.

Put `z_j=s_j+h`, where `(2+sigma)h=-e_2`.  The second and third mixed jets in
`HIGHER_JET_REDUCTION.md` show that the weight-two and weight-three
coordinates

\[
 u_j=(z_j)_2,\qquad v_j=(z_j)_3
\]

satisfy

\[
 u_jv_j=\lambda\ne0                                      \tag{1.1}
\]

for one common scalar.  They also show that the projected points
`(u_j,v_j)` affinely span the plane.

The four `u_j` are distinct.  If two were equal, (1.1) would make the
corresponding projected columns `(1,u_j,v_j)` equal.  The resulting kernel
vector supported on those two columns would contradict the fact that the
rank-three evaluation matrix has one-dimensional kernel spanned by the
all-nonzero vector `(A_j)`.

## 2. Barycentric moment recurrence

Define Laurent moments

\[
 m_n=\sum_jA_ju_j^n,\qquad n\in\mathbf Z.
\]

The fixed-point and first-moment equations give

\[
 m_{-1}=m_0=m_1=0.                                       \tag{2.1}
\]

Let

\[
 P(T)=\prod_{j=0}^3(T-u_j)
 =T^4-e_1T^3+e_2T^2-e_3T+e_4.                            \tag{2.2}
\]

All roots are distinct and nonzero.  Put `B_j=A_j/u_j`.  Equation (2.1)
says

\[
 \sum_jB_j u_j^k=0,\qquad k=0,1,2.
\]

The kernel of this `3 by 4` Vandermonde matrix is one-dimensional, so the
standard partial-fraction weights give

\[
 \boxed{A_j=\kappa\frac{u_j}{P'(u_j)}}                   \tag{2.3}
\]

for a nonzero common scalar.  Consequently

\[
 m_n=\kappa S_{n+1},\qquad
 S_r=\sum_j\frac{u_j^r}{P'(u_j)},                         \tag{2.4}
\]

and the entire two-sided moment sequence obeys the quartic recurrence from
`P`.  In particular

\[
\begin{gathered}
S_0=S_1=S_2=0,\quad S_3=1,\quad S_4=e_1,\quad
S_5=e_1^2-e_2,\\
S_{-1}=-e_4^{-1},\quad S_{-2}=-e_3e_4^{-2},\quad
S_{-3}=(e_2e_4-e_3^2)e_4^{-3}.                           \tag{2.5}
\end{gathered}
\]

## 3. Exact restricted trace coefficients

On the kernel `U_23` of the first moment, the conjugate local functions are

\[
 F_i(x,y)=\sum_j A_j
 \exp\!\left(\zeta^{2i}u_jx+zeta^{3i}\lambda u_j^{-1}y\right).
\tag{3.1}
\]

Their trace identity is

\[
 \sum_iF_i(x,y)^2F_{i+1}(x,y)=0.                          \tag{3.2}
\]

After removing the common power of `lambda`, the coefficient of `x^P y^Q`
vanishes automatically unless `P-Q=0 mod 5`.  When the congruence holds it
is, up to a nonzero rational factorial,

\[
 \sum_{\substack{p_1+p_2+p_3=P\\q_1+q_2+q_3=Q}}
 {P\choose p_1,p_2,p_3}{Q\choose q_1,q_2,q_3}
 \zeta^{2(p_3-q_3)}
 \prod_{r=1}^3m_{p_r-q_r}.                               \tag{3.3}
\]

Substitute (2.4).  The first nonzero equations occur at total degrees eight
and nine, for

\[
 (P,Q)=(4,4),(2,7),(7,2).                                \tag{3.4}
\]

They are weighted-homogeneous in the `e_i`.  Since `e_4` is nonzero, scale
the `u_j` so that `e_4=1`.  Exact Groebner reduction over
`Q[zeta_5]` of just the three equations (3.4) gives

\[
 (e_1-e_2e_3)^2=0,
 \qquad (e_2-e_3^2)^2=0,                                 \tag{3.5}
\]

and, after these equalities,

\[
 (3\zeta+2)e_3^2(e_3^4-1)=0.                             \tag{3.6}
\]

The factor `3*zeta+2` is nonzero.  Hence there are only two root shapes:

### Square shape

If `e_3=0`, then (3.5) gives `e_1=e_2=0`, so

\[
 P(T)=T^4+1.                                              \tag{3.7}
\]

The total-degree-ten coefficient `(P,Q)=(0,10)` equals

\[
 1260\zeta(\zeta^2+2)\ne0,                               \tag{3.8}
\]

contradicting (3.2).

### Four-of-five shape

If `e_3^4=1`, equations (3.5) give

\[
 e_1=e_3^3,\qquad e_2=e_3^2.
\]

After the harmless scaling `T=e_3^3W`,

\[
 P(T)=W^4-W^3+W^2-W+1=\frac{W^5+1}{W+1}.                 \tag{3.9}
\]

Thus the four `u_j` are a common nonzero scalar times

\[
 -\zeta,-\zeta^2,-\zeta^3,-\zeta^4.                     \tag{3.10}
\]

Every ratio of two distinct `u_j` is a nontrivial fifth root of unity.

## 4. The affine lattice coset kills the final shape

Identify `V_Q` with `F=Q(zeta_5)` so that `sigma` is multiplication by
`zeta`.  A single Fourier embedding `F -> C` is injective.  Therefore, if

\[
 u_j/u_k=\zeta^r,
\]

there is an `m in {1,2,3,4}` with `2m=r mod 5`, and injectivity gives

\[
 z_j=\sigma^m z_k.                                       \tag{4.1}
\]

But every `z_j` belongs to the same affine lattice coset `h+M`.  Equation
(4.1) would imply

\[
 \sigma^m h-h\in M.                                      \tag{4.2}
\]

This is impossible.  Apply `(2+sigma)` and then the cokernel functional

\[
 \ell=(1,9,4,3,5)\pmod {11}.
\]

It satisfies `ell(sigma x)=9 ell(x)`, while for `c=-e_2` one has
`ell(c)=7`.  Hence for `1<=m<=4`,

\[
 \ell((\sigma^m-1)c)=(9^m-1)7\ne0\pmod {11}.             \tag{4.3}
\]

Thus `(sigma^m-1)c` is not in `(2+sigma)M`, contradicting (4.2).

Both root shapes are impossible, completing the affine-rank-three
exclusion.

## 5. Scope

Combining this theorem with the two-residue parallel-segment theorem gives:

```text
every four-term Laurent trace zero has affine support rank at most two
```

This is an exact all-exponent theorem.  It is not a four-term exclusion:
same-residue planar quadrilaterals and other affine-rank-at-most-two supports
still require analysis.  It also does not decide the unrestricted Laurent,
`F55`, or `PSL(2,11)` questions.

```text
F55-TRACE-FOUR-TERM-AFFINE-RANK-THREE-EXCLUSION
F55-TRACE-FOUR-TERM-QUESTION-OPEN
F55-GLOBAL-QUESTION-OPEN
```
