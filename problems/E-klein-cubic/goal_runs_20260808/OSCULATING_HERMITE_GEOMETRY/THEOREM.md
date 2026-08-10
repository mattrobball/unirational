# Degree-nine Hermite contact geometry

**Date:** 2026-08-08  
**Result:** `F55-OSCULATING-HERMITE-GEOMETRIC-COMPONENT-EXISTS`  
**Headline:** `F55-QUESTION-OPEN`

## 1. Universal contact system

Work first over the ordered-root base

\[
 B=\operatorname{Spec}\mathbf Z[r_0^{\pm1},\ldots,r_4^{\pm1},
 \Delta^{-1}]/(r_0r_1r_2r_3r_4-1),
 \qquad \Delta=\prod_{i<j}(r_i-r_j).
\]

Put

\[
 p(T)=\prod_{j=0}^4(T-r_j),\qquad
 \ell_i(T)=\frac{p(T)}{T-r_i},
\]

and use the theorem-forced degree-nine ansatz

\[
 q_i=(T-r_{i-1})H_i,\qquad \deg H_i\leq4,
 \qquad x_i=\ell_iq_i,
\]

with indices modulo five.  Over the ordered-root cover the twenty-five
values

\[
                    y_{ik}=H_i(r_k)
\]

are linear coordinates.  Let

\[
 c_i=r_{i+2}^{-1},\qquad
 S(T)=\sum_i c_i x_i(T)^2x_{i+1}(T).
\]

### Exact factorization

There is an identity

\[
 S=p^2A,
 \qquad
 A=\sum_i c_i\frac{p}{(T-r_i)(T-r_{i+1})}
             (T-r_{i-1})^2H_i^2H_{i+1}.                 \tag{1.1}
\]

Here `deg(A)<=17`.  Consequently

\[
                         p^5\mid S
 \quad\Longleftrightarrow\quad
                         p^3\mid A.                     \tag{1.2}
\]

Thus the contact locus is cut out by exactly fifteen homogeneous cubic
coefficient equations in twenty-five variables.  This is the complete
finite Hermite system; no degree or support sweep occurs.

## 2. Rational elimination of the second-order contacts

At `T=r_k`, write `z=T-r_k` and set

\[
 A_k=[z^0]x_k,\qquad f_k=[z^1]x_{k-1},\qquad
 b_k=[z^2]x_{k+1}.
\]

On the open set `A_k f_k != 0`, the second-order contact is

\[
 c_kA_k^2b_k+c_{k-1}A_kf_k^2=0,
\]

so

\[
 b_k=-\frac{r_{k+2}}{r_{k+1}}\frac{f_k^2}{A_k}.        \tag{2.1}
\]

After this exact elimination, retain

\[
 d_k=H_{k+2}(r_k),\qquad e_k=H_{k+3}(r_k).
\]

The open contact locus is therefore described by the twenty variables

\[
                       (A_k,f_k,d_k,e_k)_{k=0}^4
\]

and the ten remaining third- and fourth-order contact equations.  Its
expected relative dimension over `B` is ten.

The frequently used specialization `A_k=f_k=1` is a slice, not a quotient
by a ten-dimensional gauge group.  Emptiness of that slice would not imply
emptiness of the full contact locus.

## 3. A smooth nondegenerate component dominates the root base

Over `F_7`, take

\[
 (r_0,\ldots,r_4)=(1,2,3,4,5),\qquad A_k=r_k,qquad f_k=1,
\]

and

\[
 d=(6,1,3,3,2),\qquad e=(0,1,0,6,2).                 \tag{3.1}
\]

Exact substitution gives

\[
                       S=p^5(T^2+1).                   \tag{3.2}
\]

All five `H_i` have degree four, the five `x_i` have common gcd one, and
`T^2+1` is coprime to `p`.  Hence (3.1) lies in the genuinely nondegenerate
degree-nine, degree-two-residual open set.

The `10 x 10` Jacobian of the third- and fourth-order contacts with respect
to `(d,e)` has rank ten over `F_7`.  Therefore, on the cyclicly covariant
slice

\[
                         A_k=r_k,\qquad f_k=1,          \tag{3.3}
\]

the contact scheme is etale over `B` at (3.1).  Etale morphisms are open.
The corresponding component meets a dense open of `B`, and hence its
characteristic-zero generic geometric fibre is nonempty.  In particular:

> A resultant or Groebner calculation over the algebraic closure cannot
> prove the general nondegenerate degree-nine Hermite system empty.

The same point also lies on the full twenty-variable chart, whose relative
dimension over `B` is ten.

## 4. No global linear Hermite block

The contact cubics do not become an affine bundle by a linear change of
Hermite coordinates.

Let

\[
 B_i(T)=c_i\frac{p}{(T-r_i)(T-r_{i+1})}(T-r_{i-1})^2.
\]

Suppose a nonzero constant direction

\[
                         v=(v_0,\ldots,v_4),
 \qquad \deg v_i\leq4,
\]

made every contact cubic affine-linear along that direction.  The second
polar of (1.1) would vanish modulo `p^3` against every test direction.
Testing a direction supported only in the `j`th polynomial gives

\[
 \bigl(B_{j-1}v_{j-1}^2+2B_jv_jv_{j+1}\bigr)w_j
                         \equiv0\pmod {p^3}             \tag{4.1}
\]

for every `w_j` of degree at most four.  Taking `w_j=1`, the expression in
parentheses has degree at most thirteen, whereas `deg(p^3)=15`; hence

\[
               B_{j-1}v_{j-1}^2=-2B_jv_jv_{j+1}        \tag{4.2}
\]

as a polynomial identity for every `j`.

If one `v_j` is zero, (4.2) propagates the zero around the five-cycle.  If
none is zero, multiplying the five identities and cancelling in the
polynomial domain gives

\[
                              1=(-2)^5,
\]

or `33=0`.  In characteristic zero this is impossible.  Thus the common
second-polar radical is zero.

Consequently no linear coordinate change supplies even one constant solved
direction on which all fifteen cubics are globally affine-linear.  In
particular the hoped-for ten-variable linear block does not exist.  This
does not exclude a nonlinear birational parametrization.

## 5. Arithmetic and headline boundary

Section 3 proves geometric nonemptiness, not a rational section over the
generic fixed field.  On the covariant slice (3.3), the dominating component
is locally a finite etale cover of the ordered-root base.  A positive
headline result from this slice would require an exact degree-one branch
together with its cyclic descent.  A point on a split finite-field fibre,
even a smooth nondegenerate one, does not provide that branch.

Conversely, failure of this particular covariant slice would not prove the
full twenty-variable contact locus empty, because (3.3) is not a gauge
normalization of all solutions.

Every rational point of the nondegenerate contact locus still yields a
degree-two residual intersection with the trace cubic; the secant line then
yields a rational point on the cubic.  Thus a descended rational section
would prove the opposite of the requested non-unirationality objective.

The exact remaining finite target on this route is the generic finite
algebra of the covariant slice: compute its degree, factorization and cyclic
monodromy, and decide whether it has a degree-one descended branch.  That is
a finite CAS problem.  It is a positive-construction target, not a valid
negative theorem for the full contact space.

