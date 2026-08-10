# Universal ideal of the five progression buckets

**Date:** 2026-08-08  
**Status:** `PURE-LANDING COMPONENT FORCING REFUTED`  
**Scope:** the fixed five-equation algebraic system in ten independent
symbols; this is not a global polynomial landing solution

Let `k` be algebraically closed of characteristic five.  Continue the
notation of `CHAR5_PROGRESSION_BUCKETS.md`.  This note analyzes the five
bucket equations over the coefficient field containing `x_0,...,x_4,q`,
with `q^5=Q`, after treating the ten values `h_i,k_i` as independent
symbols.

## 1. Four universal cyclic systems

Put

\[
 u_i=A_ih_i,\qquad v_i=A_iq^rk_i,
 \qquad c={r\over3d}\in\mathbf F_5^*.                  \tag{1.1}
\]

Relabel the bucket indexed by `s` using the position of its term with zero
copies of `k`.  Equations (2.4)--(2.7) of the preceding note become

\[
 F_t=P_{t,0}+P_{t+c,1}+P_{t+2c,2}+P_{t+3c,3}=0,
 \qquad t\in\mathbf F_5,                               \tag{1.2}
\]

where now

\[
\begin{aligned}
P_{i,0}&=u_i^2u_{i+1},\\
P_{i,1}&=u_i^2v_{i+1}+2u_iv_iu_{i+1},\\
P_{i,2}&=2u_iv_iv_{i+1}+v_i^2u_{i+1},\\
P_{i,3}&=v_i^2v_{i+1}.
\end{aligned}                                          \tag{1.3}
\]

Thus the sixteen `(d,r)` pairs reduce to the four fixed patterns
`c=1,2,3,4`.  All dependence on `x,q` has been removed by invertible
rescaling.

## 2. Torus linearization

On the open set where all ten symbols are nonzero, put

\[
                 z_i={v_i\over u_i},\qquad
                 a_i=u_i^2u_{i+1}.                     \tag{2.1}
\]

The monomial map `(u_i) -> (a_i)` is a finite etale surjection of tori: its
exponent determinant is

\[
                         \det(2+\rho)=33=3\ne0\pmod5.  \tag{2.2}
\]

Hence the `a_i` may be treated as arbitrary nonzero torus coordinates after
passing to an algebraic closure.  Equations (1.2) become the linear system

\[
\begin{split}
0=F_t={}&a_t\\
 &+a_{t+c}(z_{t+c+1}+2z_{t+c})\\
 &+a_{t+2c}(2z_{t+2c}z_{t+2c+1}+z_{t+2c}^2)\\
 &+a_{t+3c}z_{t+3c}^2z_{t+3c+1}.
\end{split}                                             \tag{2.3}
\]

Write this as

\[
                             M_c(z)a=0.                 \tag{2.4}
\]

The proportional locus cut out by all `2 x 2` minors of the two rows
`(u_i)` and `(v_i)` is exactly the locus where all five `z_i` are equal.

## 3. Exact torus witnesses

The following table is over `F_5`.  Every entry of `a,z` is nonzero, every
`z` is nonconstant, `M_c(z)a=0`, and `rank M_c(z)=4`.

| `c` | `a` | `z` | `sum a_i` | `sum a_i z_i^2 z_(i+1)` |
|---:|---|---|---:|---:|
| 1 | `(1,2,1,3,1)` | `(1,1,2,4,2)` | 3 | 1 |
| 2 | `(1,3,3,2,4)` | `(1,1,1,3,4)` | 3 | 4 |
| 3 | `(1,3,4,2,4)` | `(1,1,1,2,4)` | 4 | 3 |
| 4 | `(1,1,4,1,1)` | `(1,1,2,3,2)` | 3 | 3 |

At each point the Jacobian of the five equations (2.3) in the ten variables
`a,z` has rank five.  Therefore each point lies on a smooth
five-dimensional component of the all-variable/nonproportional saturation.

These points also avoid the two *original* pure landing equations.  Indeed,
if

\[
                         B_i=A_i^2A_{i+1},               \tag{3.1}
\]

then inverse rescaling gives

\[
 K(h)=\sum_i{a_i\over B_i},\qquad
 K(k)=q^{-3r}\sum_i{a_i z_i^2z_{i+1}\over B_i}.         \tag{3.2}
\]

For `d!=0`, the five Laurent monomials `B_i^(-1)` have five distinct
`q`-exponents modulo five: their exponents are `d(3i+1)`.  They are therefore
linearly independent over `k(x_0,...,x_4)` in the basis
`1,q,...,q^4`.  Every coefficient in both sums (3.2) is nonzero at the table
points, so

\[
                             K(h)K(k)\ne0.              \tag{3.3}
\]

Thus the saturated universal variety is not contained in
`V(K(h)) union V(K(k))`.  In particular, not every irreducible component
forces a lower pure landing equation.

## 4. Main determinant component

Let

\[
                             D_c(z)=\det M_c(z).         \tag{4.1}
\]

Exact factorization over `F_5` gives one factor of multiplicity one for each
`c`.  The polynomials have total degree fifteen; they have respectively
`124,154,154,124` terms for `c=1,2,3,4`.

This irreducibility is geometric.  The rank-four, full-Jacobian rational
point in Section 3 is a smooth `F_5`-point of `D_c=0`: at rank four the
adjugate of `M_c` is nonzero, and the fifth Jacobian direction transverse to
the four `a`-directions is precisely the differential of its determinant.
If an irreducible
`F_5` polynomial split into several Frobenius-conjugate factors over the
algebraic closure, every `F_5`-point on it would lie on all conjugate factors
and hence be singular.  Therefore `D_c` is absolutely irreducible.

Over the rank-four open subset of `D_c=0`, the projective kernel of `M_c(z)`
is a single point.  The corresponding incidence variety is thus birational
to the absolutely irreducible determinant hypersurface; allowing the common
scale of `a` gives its smooth five-dimensional affine component.  Pulling
back by the finite etale isogeny (2.2) gives the associated component or
components in the original `u,v` torus.  Every such component dominates the
rank-four determinant open set, and Section 3 shows that pure landing is not
forced there.

No assertion about possible lower-dimensional rank-at-most-three strata is
needed for the forcing verdict.

## 5. Strict scope

The universal-component strategy fails: even after removing all coordinate
hyperplanes and the proportional locus, the fixed bucket ideal has smooth
components on which neither `K(h)` nor `K(k)` vanishes.

The ten symbols in this calculation are independent.  A genuine polynomial
coordinate additionally requires

\[
                       h_i=\rho^ih,\qquad k_i=\rho^ik.  \tag{5.1}
\]

The table does not satisfy or refute that global difference-field
compatibility, and hence is not a landing covariant.  It proves exactly that
elimination or polarization of the five universal bucket equations alone
cannot close the all-degree problem.

Replay:

```sh
python3 probe_char5_progression_universal.py
python3 factor_char5_progression_determinants.py
```

Expected markers:

```text
F55-CHAR5-PROGRESSION-UNIVERSAL-FORCING-REFUTED
F55-CHAR5-PROGRESSION-DETERMINANTS-F5-IRREDUCIBLE
```
