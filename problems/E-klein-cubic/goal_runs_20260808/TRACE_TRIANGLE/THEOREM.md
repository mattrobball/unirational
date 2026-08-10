# Exact all-exponent exclusion for three Laurent terms

**Date:** 2026-08-08  
**Scope:** constant-coefficient Laurent polynomials with exactly three support
points  
**Result:** `F55-TRACE-THREE-TERM-ALL-EXPONENT-EXCLUSION`

Let

\[
M=\mathbf Z^5/\mathbf Z(1,1,1,1,1),\qquad
R=\mathbf C[M],\qquad \sigma(e_i)=e_{i+1},
\]

put `c=chi^(-e_2)`, and define

\[
 \Phi(a)=\sum_{i=0}^4
 \sigma^i\!\left(ca^2\sigma(a)\right).
\]

## Theorem

If

\[
 a=A_0\chi^{s_0}+A_1\chi^{s_1}+A_2\chi^{s_2},
 \qquad A_0A_1A_2\ne0,
\]

and the three `s_j` are distinct points of `M`, then

\[
 \Phi(a)\ne0.
\]

The exponents are arbitrary elements of `M`; there is no box, degree, width,
or affine-dimension cutoff.  In particular this excludes every two-dimensional
triangle support.  Together with the pre-existing one- and two-term results,
it excludes every nonzero constant-coefficient Laurent polynomial supported
on at most three monomials.

## Proof reduction

Write `V=M tensor Q` and identify `V` with the one-dimensional vector space
over `F=Q(zeta_5)` on which `sigma` acts as multiplication by `zeta=zeta_5`.
Let

\[
 h=(2+\sigma)^{-1}(-e_2)\in V,
 \qquad z_j=s_j+h.
\]

For `p<=q` and `r` in `{0,1,2}`, the eighteen base contributions to the
trace have exponent

\[
 -e_2+s_p+s_q+\sigma s_r
   =z_p+z_q+\zeta z_r=:L_{p,q;r}(z).
\tag{1}
\]

Their coefficients are

\[
 \mu(p,q)A_pA_qA_r,
 \qquad \mu(p,q)=1\ (p=q),\quad 2\ (p<q).
\tag{2}
\]

The orbit sums of two Laurent monomials are equal precisely when their
exponents are in the same `sigma`-orbit.  Hence two base contributions can
cancel only on one of the collision hyperplanes

\[
 \bigl(L_t-\zeta^kL_u\bigr)(z)=0,
 \qquad t\ne u,\quad 0\le k<5.
\tag{3}
\]

The vector `z=(z_0,z_1,z_2)` is nonzero.  Indeed `z=0` would imply
`h in M`, whereas `-e_2` is not in `(2+sigma)M`: the standard cokernel
functional

\[
 \lambda=(1,9,4,3,5)\pmod {11}
\]

annihilates `(2+sigma)M` and is nonzero on `-e_2`.  Consequently all rows of
(3) satisfied by a proposed support lie in the at-most-two-dimensional
`F`-space `z^perp`.

This makes collision coverage finite without bounding the exponents.  The
replay starts from an uncovered one of the eighteen terms and adjoins one of
its collision rows.  If another term remains uncovered it adjoins a second
row.  Rank three is impossible for nonzero `z`.  This branching is exhaustive:
in any identity every term must collide, so the first uncovered term must
supply exactly one of the branches.  Projectively identical rows and
rank-two row spaces are merged exactly over `Q(zeta_5)`.

The exact classification is:

```text
distinct collision hyperplanes       543
rank-one covering spaces                0
rank-two covering spaces               61
coefficient-torus viable spaces         1
```

For each covering space, the replay groups the eighteen terms by their exact
cyclic exponent orbit.  After normalizing `A_0=1`, put
`x=A_1/A_0`, `y=A_2/A_0`.  The sum of all class polynomials is
`(1+x+y)^3`, so a common zero must have `y=-1-x`.  Exact univariate gcd after
this substitution, with the forbidden torus roots `x=0,-1` removed, rejects
60 of the 61 patterns.  The sole survivor has one class containing all
eighteen terms and coefficient

\[
 (1+x+y)^3.
\]

Its rank-two collision space has kernel

\[
 F(1,1,1),
\]

so `z_0=z_1=z_2` and therefore `s_0=s_1=s_2`.  This is not a three-point
support; when `1+x+y=0`, it is simply the zero Laurent polynomial.  Thus no
three-distinct-term zero exists.  QED.

## Exactness and boundary

The replay uses rational arithmetic in the cyclotomic basis
`1,zeta,zeta^2,zeta^3` and univariate gcds over `Q` only for the 61
coefficient patterns forced by (3).  It performs no search over exponents and
no modular or numerical identity test.

The theorem does not cover nonconstant coefficients in the invariant field,
four or more Laurent monomials, or arbitrary rational functions in `E`.
It therefore does not decide `F55-NO` or the full `PSL(2,11)` question.
