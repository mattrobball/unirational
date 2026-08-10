# Planar circuit reduction for four Laurent terms

**Date:** 2026-08-08  
**Result:** `F55-TRACE-FOUR-TERM-PLANAR-CIRCUIT-REDUCTION`  
**Completion:** the last convex-quadrilateral branch is closed in
`RANK2_QUADRATIC_EXCLUSION.md`

Combine `TETRAHEDRAL_EXCLUSION.md` with the following all-exponent argument.
No collision hyperplanes are enumerated.

## 1. The two-residue branch is empty

The fixed-point theorem says that a `2+2` degree-residue partition has
opposite coefficients in each pair.  Its tangent argument showed that the
two pair differences are rationally parallel.  Write them as

\[
 \Delta_2=q\Delta_1,\qquad q\in\mathbf Q^*.
\]

At the five fixed points, the first moments are, up to a nonzero common
scalar,

\[
 v_t=(B+Cq t^m)\Delta_1,
 \qquad t^5=1,\quad m\ne0\pmod5.                          \tag{1.1}
\]

Every `v_t` must lie in `U_14 union U_23`.  Neither spectral plane contains
a nonzero rational vector.  Hence every scalar in (1.1) would have to vanish.
The two-term polynomial `B+CqT^m`, with both coefficients nonzero, cannot
vanish at all five fifth roots.  Contradiction.

Thus every hypothetical four-term zero has

\[
 \boxed{\delta(s_0)=\delta(s_1)=\delta(s_2)=\delta(s_3).} \tag{1.2}
\]

## 2. Collinear support is impossible

Suppose the affine support has rank one.  After clearing denominators, write

\[
 z_j=z_0+n_jd
\]

with four distinct rational numbers `n_j` and a nonzero rational lattice
direction `d`.  Put `m_r=sum A_j n_j^r`.  Equation (1.2) gives `m_0=0`.
The first moment is `m_1d`; since a nonzero rational direction lies in neither
spectral plane, the cubic tangent equation forces `m_1=0`.

If `m_2` were nonzero, the leading trace jet would be a nonzero scalar times

\[
 \sum_i\ell_i^4\ell_{i+1}^2,                              \tag{2.1}
\]

where `(ell_i)` ranges over the sum-zero cyclic representation.  At
`(4,-1,-1,-1,-1)`, (2.1) equals `275`, so it is not the zero polynomial.
Thus `m_2=0`.

The next possible leading jet is a nonzero scalar times

\[
 \sum_i\ell_i^6\ell_{i+1}^3.                              \tag{2.2}
\]

At the same vector it equals `-4035`, so `m_3=0`.  The four equations

\[
 \sum_jA_jn_j^r=0,\qquad r=0,1,2,3,
\]

form an invertible Vandermonde system.  They force all `A_j=0`, a
contradiction.

Therefore every remaining support has affine rank exactly two.

## 3. A nonzero first moment is impossible in an affine plane

Let `H_Q` be the rational two-plane spanned by the support differences, and
suppose the first moment `v` is nonzero.  Choose the branch `v in U_14`; the
other is conjugate.

Galois stability and dimension show that

\[
 H_C=(H_C\cap U_{14})\oplus(H_C\cap U_{23}),              \tag{3.1}
\]

with each intersection a line.  Neither line is a pure eigenline.  Project
the four shifted points to `U_23` and write their two Fourier coordinates as
`(u_j,w_j)`.  Their affine image is therefore a line of nonzero finite slope:

\[
 w_j=\alpha u_j+\beta,\qquad \alpha\ne0.                 \tag{3.2}
\]

The four `u_j` are distinct.  Equality of two would put a nonzero rational
support difference in `H_C intersect U_14`, which is impossible.

The vanishing constant and first moments give

\[
 \sum_jA_j=\sum_jA_ju_j=0.                               \tag{3.3}
\]

The mixed degree-four equation `q_23=0`, together with (3.2), gives

\[
 0=\sum_jA_ju_jw_j=\alpha\sum_jA_ju_j^2,
\]

so the second `u`-moment vanishes.  The degree-five equation `r_223=0`
similarly gives

\[
 0=\sum_jA_ju_j^2w_j=\alpha\sum_jA_ju_j^3.
\]

The four distinct `u_j` again give an invertible Vandermonde system for
degrees zero through three.  Hence all `A_j=0`, a contradiction.

Thus the remaining planar branch has

\[
 \boxed{\sum_jA_js_j=0.}                                  \tag{3.4}
\]

## 4. Circuit coefficients and oriented-matroid type

For four points of affine rank two, the kernel of

\[
 (C_j)\longmapsto\left(\sum_jC_j,\sum_jC_js_j\right)
\]

is one-dimensional.  Equation (3.4) says that `(A_j)` is its affine circuit
vector.  Since every `A_j` is nonzero, no three support points are collinear.

Choose real affine coordinates

\[
 p_0=(0,0),\quad p_1=(1,0),\quad p_2=(0,1),\quad
 p_3=(\alpha,\beta).
\]

The circuit and its second moment, up to common nonzero scale, are

\[
 C=(\alpha+\beta-1,-\alpha,-\beta,1),                    \tag{4.1}
\]

and

\[
 Q=\begin{pmatrix}
 \alpha(\alpha-1)&\alpha\beta\\
 \alpha\beta&\beta(\beta-1)
 \end{pmatrix},
 \qquad
 \det Q=\alpha\beta(1-\alpha-\beta)
       =-\prod_jC_j.                                      \tag{4.2}
\]

If one point lies inside the triangle of the other three, the circuit has
sign pattern `1+3`, so `product C_j<0`; (4.2) makes `Q` definite.  After a
common sign change, all five conjugate quadratic forms `Q_i` are positive
semidefinite and are simultaneously positive at a generic real tangent
vector.  Their leading trace

\[
 \sum_iQ_i^2Q_{i+1}
\]

is then strictly positive, contradicting the trace identity.

The sole remaining oriented-matroid type is therefore a convex
quadrilateral.  Its circuit has sign pattern `2+2`, and `Q` is an indefinite
rank-two rational quadratic form.

## 5. Final normal form and its exclusion

At this stage every hypothetical four-term Laurent trace zero would have to
satisfy all of:

```text
one degree residue modulo five
affine support rank exactly two
four points in convex position, with no collinear triple
coefficients proportional to the unique affine circuit (sign pattern 2+2)
the indefinite rank-two circuit moment Q satisfies sum_i Q_i^2 Q_(i+1)=0
```

This is one oriented-matroid normal form, still representing an unbounded
family of rational lattice quadrilaterals.  It nevertheless closes
universally: `RANK2_QUADRATIC_EXCLUSION.md` proves that no nonzero rational
rank-two quadratic form satisfies the displayed landing identity.  Hence the
convex circuit branch is empty.  Together with the other affine ranks, this
gives the exact four-term theorem recorded in `THEOREM.md`.

```text
F55-TRACE-FOUR-TERM-PLANAR-CIRCUIT-REDUCTION
F55-TRACE-FOUR-TERM-ALL-EXPONENT-EXCLUSION
F55-GLOBAL-QUESTION-OPEN
```
