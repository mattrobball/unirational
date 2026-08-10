# Independent audit: exclusion of planar four-term trace support

**Date:** 2026-08-08  
**Result:** `F55-TRACE-FOUR-TERM-PLANAR-EXCLUSION-AUDITED`  
**CAS boundary:** no collision-row enumeration; the only replay expands two
two-variable factorizations and one Fourier coefficient

This note independently closes the affine-rank-at-most-two branch left by
`TRACE_TETRAHEDRON/TETRAHEDRAL_EXCLUSION.md`.  It uses the fixed-point and
mixed-jet identities proved in that packet, but the last rank-two quadratic
argument below is analytic and does not use the 3,900 raw collision
hyperplanes.

Throughout,

\[
 a=\sum_{j=0}^3 A_j\chi^{s_j},\qquad A_0A_1A_2A_3\ne0,
\]

has four distinct exponents in
`M=Z^5/Z(1,1,1,1,1)`, and hypothetically satisfies the trace equation.
Write

\[
 U_{14}=V_1\oplus V_4,\qquad U_{23}=V_2\oplus V_3.
\]

Neither spectral plane contains a nonzero scalar multiple of a rational
lattice vector.

## 1. Two degree residues are impossible

The fixed-point equations make the two coefficient pairs opposite.  The
tangent argument in `FIXED_POINT_TANGENT_REDUCTION.md` makes their two
rational difference vectors parallel.  Thus, after removing a common
nonzero scalar, the five first moments have the form

\[
 v_t=(B+Cq t^m)\Delta,
 \qquad t^5=1,\quad q\in\mathbf Q^*,\quad m\not\equiv0\pmod5,
\]

where `Delta` is a nonzero rational lattice vector and `BC != 0`.  Every
`v_t` lies in `U_14 union U_23`.  A nonzero scalar multiple of `Delta` lies
in neither plane, so all five scalars `B+Cq t^m` would have to vanish.  A
nonzero two-term polynomial of degree at most four cannot vanish at all five
fifth roots.  Hence all four exponents have one common degree residue.

## 2. The nonzero-first-moment planar branch is impossible

Let `H_Q` be the rational plane spanned by the support differences and let
`v=sum A_j s_j` be nonzero.  Choose the branch `v in U_14`; the other is
Galois conjugate.  Since `H` is defined over `Q`, cyclotomic Galois symmetry
and dimension give

\[
 H_{\mathbf C}=(H_{\mathbf C}\cap U_{14})
 \oplus(H_{\mathbf C}\cap U_{23}),
\]

with both intersections lines.  Neither is a pure eigenline: otherwise the
four Galois-conjugate eigenlines would all lie in the two-plane `H`.

Project the shifted support to `U_23`, with weight-two and weight-three
coordinates `(u_j,w_j)`.  Its affine image is a line of nonzero finite slope,

\[
 w_j=\alpha u_j+\beta,\qquad \alpha\ne0.
\]

The four `u_j` are distinct.  Equality of two would make the corresponding
nonzero rational support difference lie in `H_C intersect U_14`.

Put `m_r=sum A_j u_j^r`.  The constant and first moments give `m_0=m_1=0`.
The exact mixed jets `q_23=0` and `r_223=0` give successively

\[
 0=\alpha m_2,\qquad 0=\alpha m_3.
\]

Thus `m_0=m_1=m_2=m_3=0`.  The Vandermonde matrix on the four distinct
`u_j` is invertible, forcing every `A_j=0`, a contradiction.

The collinear same-residue case is already excluded by the analogous
one-variable moment argument in `PLANAR_CIRCUIT_REDUCTION.md`.  It follows
that the only branch not yet covered by those arguments has affine rank two
and zero first moment.

## 3. The circuit quadratic

Zero constant and first moments make `(A_j)` proportional to the unique
affine circuit of the four planar points.  Normalize it to be rational and
real.  No three support points are collinear.  In affine coordinates

\[
 p_0=(0,0),\quad p_1=(1,0),\quad p_2=(0,1),\quad
 p_3=(\alpha,\beta),
\]

the circuit and second moment are

\[
 C=(\alpha+\beta-1,-\alpha,-\beta,1),
\]

\[
 Q=\begin{pmatrix}
 \alpha(\alpha-1)&\alpha\beta\\
 \alpha\beta&\beta(\beta-1)
 \end{pmatrix},
 \qquad \det Q=-\prod_j C_j.
\]

For circuit sign pattern `1+3`, `Q` is definite.  All five cyclic conjugates
are semidefinite with the same sign and are simultaneously strict at a
generic real tangent vector.  Hence their leading trace

\[
 \sum_{i=0}^4 Q_i^2Q_{i+1}
\]

has a strict sign and cannot vanish identically.

It remains to exclude sign pattern `2+2`.  Then `Q` is an indefinite
rational rank-two quadratic form.  Over its real splitting field `K`, write

\[
 Q=LM
\]

with distinct linear factors.  Their coefficient plane is exactly the
rational support plane `H_Q`.

## 4. The factor-field dichotomy

Let `F=Q(zeta_5)` and let `S` be the Fourier support of `L`.

* If `K=Q`, a nonzero rational factor has all four Fourier components:
  one missing component and cyclotomic Galois transitivity would make all
  four vanish.
* If `K` is quadratic and `K intersect F=Q`, the nontrivial automorphism of
  `KF/F` swaps `L` and `M`, so they have the same Fourier support.  If that
  common support missed one component, the rational plane `H` would miss
  it; Galois transitivity would then make `H=0`.  Thus the support is again
  full.
* The only remaining intersection is
  `K=F^+=Q(sqrt(5))`.  Complex conjugation fixes each factor, so
  `S=-S`.  The automorphism `zeta -> zeta^2` swaps the two factors, so the
  support of `M` is `2S`.  If `S` is proper, rationality of `H` forces
  `S union 2S` to be all four weights.  Therefore, after swapping factors,

  \[
  S=\{1,4\},\qquad 2S=\{2,3\}.
  \]

  Both entries in either pair are nonzero, since complex conjugation pairs
  them.

Thus there are only two cases: one factor has full cyclic span, or the two
factors have the complementary spectral supports `14` and `23`.

## 5. Full cyclic span: four sparse tests

Assume the cyclic orbit of `L` spans the four-dimensional representation.
Put `l_i=sigma^i(L)`.  The only relation is

\[
 l_0+l_1+l_2+l_3+l_4=0,
\]

so the `l_i` are coordinates on the sum-zero hyperplane.  Write, uniquely
after setting the irrelevant fifth convolution coefficient to zero,

\[
 m_i=\sigma^i(M)=\sum_{k=0}^3 b_k l_{i+k},\qquad q_i=l_i m_i.
\]

The required leading identity is

\[
 \mathcal F(l)=\sum_iq_i^2q_{i+1}=0                    \tag{5.1}
\]

for every sum-zero five-tuple `l`.

First take

\[
 l=(x,y,0,-x-y,0).
\]

Only `q_0^2q_1` survives, and exact factorization gives

\[
 \mathcal F=x^2y
 ((b_0-b_3)x+(b_1-b_3)y)^2
 (-b_2x+(b_0-b_2)y).
\]

Since `C[x,y]` is a domain, either

\[
 \text{(I)}\quad b_0=b_2=0,
 \qquad\text{or}\qquad
 \text{(II)}\quad b_0=b_1=b_3.                         \tag{5.2}
\]

Next take

\[
 l=(x,y,-x-y,0,0).
\]

In case (I),

\[
 \mathcal F=-b_1^2xy^2(x+y)
 \bigl(b_1xy+b_3(x+y)^2\bigr),
\]

so `b_1=0`.  In case (II), put
`t=b_0=b_1=b_3` and `u=b_2`.  Then

\[
 \mathcal F=-t x^2y(x+y)
 \bigl((t-u)^2x(x+y)-t^2y^2\bigr),
\]

so `t=0`.

Case (I) now leaves only `b_3`; evaluating (5.1) at

\[
 l=(1,1,0,1,-3)
\]

gives `-3b_3^3=0`.  Case (II) leaves only `b_2`; evaluating at

\[
 l=(1,1,1,-3,0)
\]

gives `-3b_2^3=0`.  Hence all `b_k` vanish, which would make `M=0`.
This excludes the full-support case without a Groebner calculation.

## 6. Complementary spectral supports

In the exceptional `K=F^+` case write

\[
 L_i=a\zeta^i x_1+b\zeta^{4i}x_4,
 \qquad
 M_i=c\zeta^{2i}x_2+d\zeta^{3i}x_3,
\]

where `abcd != 0`.  In

\[
 \sum_i(L_iM_i)^2(L_{i+1}M_{i+1}),
\]

the coefficient of `x_1^3x_2^2x_3` is

\[
 5a^3c^2d(\zeta^4+2\zeta^3)
 =5a^3c^2d(\zeta^3-\zeta^2-\zeta-1),
\]

which is nonzero.  This excludes the complementary-support case.

## 7. Audited conclusion

Every affine-rank-at-most-two four-term branch is empty.  Together with the
sealed affine-rank-three exclusion, this proves:

```text
F55-TRACE-FOUR-TERM-ALL-EXPONENT-EXCLUSION
```

Equivalently, every nonzero constant-coefficient Laurent solution of the
trace equation, if one exists, has at least five support terms.  This is not
an unrestricted trace obstruction and does not decide `F55`- or
`PSL(2,11)`-unirationality.

The exact replay is:

```sh
cd /Users/worker/unirational/problems/E-klein-cubic
/opt/homebrew/bin/python3 \
  goal_runs_20260808/TRACE_PLANAR_AUDIT/verify_sparse_factor_landing.py
```

