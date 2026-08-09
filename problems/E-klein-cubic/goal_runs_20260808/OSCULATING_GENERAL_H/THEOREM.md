# General residual-factor degree-nine osculating incidence

**Date:** 2026-08-08  
**Result:** `F55-OSCULATING-GENERAL-H-NONDEGENERATE-COMPONENT`  
**Headline:** `F55-QUESTION-OPEN`

## 1. The theorem-forced finite system

Let

\[
 p(T)=\prod_{i=0}^4(T-r_i),\qquad
 \ell_i(T)=\frac{p(T)}{T-r_i},\qquad
 c_i=r_{i+2}^{-1},
\]

with indices modulo five.  After splitting the cyclic coefficient algebra,
the general residual-factor branch of the degree-nine ansatz is

\[
 q_i=(T-r_{i-1})H_i(T),\qquad
 x_i=\ell_iq_i,\qquad \deg H_i\le4.                 \tag{1.1}
\]

The five polynomials `H_i` are the five conjugates of one
`h in E[T]_(<=4)`.  Thus their twenty-five coefficients are exactly the
twenty-five split coordinates of the Weil restriction; they are not an
enlargement of the descended ansatz.

Put

\[
 S(T)=\sum_{i=0}^4c_ix_i(T)^2x_{i+1}(T).
\]

There is an exact identity

\[
 S=p^2\mathcal A,
 \qquad
 \mathcal A=\sum_i c_i
 \frac{p}{(T-r_i)(T-r_{i+1})}
 (T-r_{i-1})^2H_i^2H_{i+1},                         \tag{1.2}
\]

where `deg(A)<=17`.  Hence

\[
                 p^5\mid S\quad\Longleftrightarrow\quad p^3\mid\mathcal A,
                                                                    \tag{1.3}
\]

and, when this holds, `S/p^5` has degree at most two.  Equation (1.3) is
exactly fifteen active scalar equations.  It is not a degree or support
sweep.

At `r_0`, write `z=T-r_0` and

\[
 x_0=\sum a_nz^n,\quad x_1=\sum b_nz^n,\quad
 x_2=\sum d_nz^n,\quad x_3=\sum e_nz^n,\quad
 x_4=\sum f_nz^n,
\]

with `A=a_0`.  The prescribed factor in (1.1) gives `b_1=0`; this is `J1`.
The next three contact equations are

\[
\begin{aligned}
J_2={}&c_0A^2b_2+c_4Af_1^2,\\
J_3={}&c_0(A^2b_3+2Aa_1b_2)+c_2d_1^2e_1+c_3e_1^2f_1
       +c_4(a_1f_1^2+2Af_1f_2),\\
J_4={}&c_0\{A^2b_4+2Aa_1b_3+(a_1^2+2Aa_2)b_2\}\\
 &+c_2(d_1^2e_2+2d_1d_2e_1)
  +c_3(e_1^2f_2+2e_1e_2f_1)\\
 &+c_4\{a_2f_1^2+2a_1f_1f_2+A(f_2^2+2f_1f_3)\}.
                                                               \tag{1.4}
\end{aligned}
\]

Together with their four cyclic conjugates, these are the requested twenty
`J1,...,J4` equations.  The five `J1` equations are automatic after
`q=(T-r_4)h`; the active system consists of the five `J2` and ten `J3/J4`
equations.

## 2. Analytic elimination before computation

Put `y_(i,k)=H_i(r_k)`.  Lagrange interpolation identifies the twenty-five
`y_(i,k)` with the twenty-five coefficients of the `H_i`.  On the open where

\[
 A_k=[z^0]x_k\ne0,
\]

choose also

\[
 f_k=[z^1]x_{k-1}.
\]

The five `J2` equations solve, without a Gröbner basis,

\[
 b_k=[z^2]x_{k+1}
     =-\frac{c_{k-1}}{c_k}\frac{f_k^2}{A_k}.          \tag{2.1}
\]

The three cyclic diagonals corresponding to `A_k`, `f_k`, and `b_k` are now
fixed.  Write

\[
 D_k=H_{k+2}(r_k),\qquad E_k=H_{k+3}(r_k).            \tag{2.2}
\]

Thus the full `J2`-saturated chart has twenty coordinates

\[
       (A_0,\ldots,A_4,f_0,\ldots,f_4,D_0,\ldots,D_4,E_0,\ldots,E_4)
\]

and only the ten cyclic `J3/J4` cubics remain.  The finite computations below
use the covariant slice

\[
                         A_k=r_k,\qquad f_k=1.         \tag{2.3}
\]

This is a chosen fibre, not a gauge normalization.  A point on it is a valid
positive construction, but emptiness of this fibre would not exclude the
full ansatz.

The nondegenerate open used below is an actual resultant chart.  In addition
to `prod A_k != 0`, invert

\[
 U_{\rm top}=\prod_i\operatorname {lc}(H_i),\qquad
 R_{\rm bp}=\operatorname {Res}_T\!\left(x_4,\sum_i x_i\right),             \tag{2.4}
\]

and the leading coefficient of the residual quadratic `S/p^5`.  Nonvanishing
of `R_bp` implies that the five coordinates have no common zero.  Equivalently,
on this chart the contact ideal is saturated by

\[
 \left(\prod_kA_k\right)U_{\rm top}R_{\rm bp}
 \operatorname {lc}_T(S/p^5).                                             \tag{2.5}
\]

This is stronger than merely deleting the zero polynomial and makes the
actual-degree, basepoint-free, residual-quadratic boundary explicit.

## 3. Exact nondegenerate point and smooth component

Over `F_7`, use

\[
 (r_0,r_1,r_2,r_3,r_4)=(1,2,3,4,5),
\]

whose entries are distinct, nonzero, and have product one.  On (2.3), one
solution of the ten remaining equations is

\[
 (D_0,\ldots,D_4)=(6,1,3,3,2),\qquad
 (E_0,\ldots,E_4)=(0,1,0,6,2).                       \tag{3.1}
\]

The resulting interpolation polynomials are

\[
\begin{aligned}
H_0&=-T^4-2T^3+2T^2-2,\\
H_1&=-2T^4+T^3-T^2+3T+3,\\
H_2&=3T^4+2T^3+T,\\
H_3&=-3T^4+T^3-T^2+3,\\
H_4&=T^4-T^3-2T-3.
\end{aligned}                                         \tag{3.2}
\]

Exact arithmetic gives

\[
 \deg x_i=9\quad(0\le i<5),\qquad
 \gcd(x_0,\ldots,x_4)=1,
 \qquad R_{\rm bp}=3,
 \qquad
 \frac{S}{p^5}=T^2+1.                                \tag{3.3}
\]

Thus this point lies in the actual-degree-nine, basepoint-free,
nonzero-residual open.  Moreover,

\[
 \det\frac{\partial(J_3^{(k)},J_4^{(k)})_{k=0}^4}
          {\partial(D_0,\ldots,D_4,E_0,\ldots,E_4)}=5\ne0
 \quad\text{in }\mathbf F_7.                         \tag{3.4}
\]

There are two further top-degree `F_7` points in this fibre; their same
Jacobian determinants are `1` and `4`, and their residual quotients are
`3-T` and `-3T^2+3T+1`.

Consequences of (3.4):

1. On the `J2`-saturated chart, the full contact locus is smooth of relative
   dimension ten over the ordered-root base at (3.1).
2. Already on the covariant slice `A_k=r_k, f_k=1`, projection to the
   four-dimensional ordered-root base is etale at (3.1).  After selecting the
   component through (3.1) and shrinking the root base, this gives a
   generically finite etale cover of the **four-parameter** root base.
3. On the full chart, projection to the fourteen parameters consisting of
   the four independent roots and the ten free `A_k,f_k` is likewise etale
   at (3.1).  This is the local chart for the relative-dimension-ten statement
   in item 1; it is not the base over which the covariant finite cover is
   being claimed.
4. The determinant is a unit modulo seven, so multivariate Hensel lifting
   gives a characteristic-zero `Q_7` point after lifting the rational root
   tuple `(1,2,3,4,1/24)` and (2.3).
5. The etale image in the four-parameter root base is a nonempty open of an
   irreducible scheme.  Hence the covariant slice over the generic
   **geometric** split root field contains an
   actual-degree-nine, basepoint-free component.  For fixed generic roots it
   is zero-dimensional on the covariant slice.  The full chart has affine
   dimension ten over those fixed roots, or dimension nine after common
   projective scaling.

In particular, a saturated unit-ideal proof for the full residual-factor
ansatz is impossible.

## 4. Exact finite counts and their boundary

The generated compiled evaluator exhausts only the theorem-forced ten
variables of (2.3):

* over `F_7`, exactly three of the `7^10` assignments have all five top
  coefficients nonzero, and they are the three points certified above;
* over `F_11`, with roots `(1,2,3,4,6)`, exactly zero of the `11^10`
  assignments have all five top coefficients nonzero.

The second statement is only about this normalized special fibre.  It does
not contradict the dominating geometric component: points may live over
extensions, and a rational component can specialize into a pole or the
degree-drop boundary.

## 5. Exact remaining descent gate

The smooth component is not yet a point over the generic invariant field.
After (2.3), the ten equations define a generically finite etale cover of the
**four-parameter ordered-root base** near (3.1).  The ten extra `A_k,f_k`
parameters belong only to the larger relative-dimension-ten chart.  The
missing headline-changing result is one of:

1. a degree-one component, equivalently cyclic-equivariant rational formulas
   for all `D_k,E_k`; or
2. an explicit analysis of the generic degree and monodromy proving that no
   component descends to a rational section.

The three `F_7` points and absence of `F_11` points are compatible with a
nontrivial cover, but do not prove either alternative.  A finite etale local
branch or a `Q_7` point is not a `K`-rational section.  Therefore this packet
does not prove a rational point on the generic twist, does not refute
`F55`-non-unirationality, and does not establish the requested
`PSL(2,11)` headline.
