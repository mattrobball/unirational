# The full four-character Fourier hyperplane boundary

**Date:** 2026-08-08  
**Scope:** all Laurent supports and degrees; no support or degree enumeration  
**Result:** exact rank-four incidence and local-boundary classification, not an exclusion

This note combines the replacement theorem in
`TRACE_FULL_CYCLIC_REPLACEMENT/THEOREM.md` with the divisor method in
`TRACE_COBOUNDARY/THEOREM.md`.  The replacement theorem makes the branch
below the headline negative branch: excluding it uniformly would prove
`F55-NO`.

The branch is **not** excluded here.  Instead, the note proves the exact
prime-incidence ceiling and the exact order-eleven multiplicity conditions.
It then gives both a cyclic formal divisor counterconfiguration and exact
unramified local Fourier models.  They show that the usual logarithmic
differential, Wronskian, ramification, and truncated Cartan counts do not by
themselves close the rank-four branch.

No object below is a nonzero solution of the authoritative trace equation in
the global field `E`.  The global `F55` and `PSL(2,11)` questions remain
open.

## 1. The four-character hyperplane system

Let `zeta` be a primitive fifth root, put

\[
 b_j=\sigma^j(b),\qquad b=c a^2\sigma(a),
 \qquad \sum_{j=0}^4b_j=0,
\]

and assume that the cyclic span has dimension four.  Its Fourier components

\[
 f_q={1\over5}\sum_{j=0}^4\zeta^{-jq}b_j,
 \qquad q=1,2,3,4,                                  \tag{1.1}
\]

are all nonzero, satisfy `sigma(f_q)=zeta^q f_q`, and give Fourier inversion

\[
 b_j=\sum_{q=1}^4\zeta^{jq}f_q.                       \tag{1.2}
\]

After invariant denominator clearing, all `b_j` and `f_q` are Laurent
polynomials.  Remove their Laurent gcd:

\[
 f_q=QF_q,\qquad \gcd(F_1,F_2,F_3,F_4)=1.
\]

Then

\[
 b_j=QH_j,\qquad
 H_j=\zeta^jF_1+\zeta^{2j}F_2+
     \zeta^{3j}F_3+\zeta^{4j}F_4.                    \tag{1.3}
\]

This is the full four-character Fourier hyperplane system.  It has

\[
 \sum_{j=0}^4H_j=0,\qquad \gcd(H_0,\ldots,H_4)=1.     \tag{1.4}
\]

Every four of its five rows are independent.  Indeed, a relation among four
rows would give a polynomial

\[
 p(z)=u_1z+u_2z^2+u_3z^3+u_4z^4
\]

vanishing at four distinct fifth roots.  Since it also vanishes at zero and
has degree at most four, it is zero.

The divisor conjugacy is genuine.  From `sigma(b_j)=b_(j+1)` one gets

\[
 \sigma(H_j)=L H_{j+1},\qquad L={Q\over\sigma(Q)}.     \tag{1.5}
\]

Taking the minimum valuation over the five `H_j` at every Laurent prime and
using (1.4) shows that `L` is a Laurent unit.  Thus all incidence strata below
are cyclically permuted, rather than being five unrelated collections.

## 2. Prime incidence is at most three

### Proposition 2.1

An irreducible Laurent prime can divide at most three of the five `H_j`.

### Proof

If a prime `P` divided four `H_j`, reduce (1.3) modulo `P` and pass to the
fraction field of `R/(P)`.  The corresponding four Fourier rows are
invertible, so all four `F_q` vanish modulo `P`.  This contradicts their
gcd-one normalization.  The possibility of five incidences was already
excluded by (1.4).  QED.

This ceiling is sharp at the level of the Fourier hyperplane system: Sections
5 and 6 realize both cyclic types of triple incidence.

## 3. Exact order-eleven multiplicities

Fix a Laurent prime `P` and put

\[
 x_j=v_P(\sigma^j(a)),\qquad m=v_P(Q),\qquad
 s_j=v_P(H_j).
\]

Every conjugate of `c` is a Laurent unit, so

\[
 w_j:=m+s_j=2x_j+x_{j+1}.                              \tag{3.1}
\]

For

\[
 \mu=(1,5,3,4,9)\pmod {11},                           \tag{3.2}
\]

one has `2 mu_j+mu_(j-1)=0 mod 11` and
`sum mu_j=0 mod 11`.  Hence the common offset disappears and the exact
order-eleven condition is

\[
 \boxed{\ \sum_{j=0}^4\mu_js_j=0\pmod {11}.\ }        \tag{3.3}
\]

Together with Proposition 2.1 this gives the complete incidence table.  All
indices are modulo five.

\[
\begin{array}{c|c|c}
\text{incidence support}&\text{exact congruence}&
  \text{least positive pattern}\cr
\hline
\{i\}&s_i=0&(11)\cr
\{i,i+1\}&s_i+5s_{i+1}=0&(1,2)\cr
\{i,i+2\}&s_i+3s_{i+2}=0&(2,3)\cr
\{i,i+1,i+2\}&s_i+5s_{i+1}+3s_{i+2}=0&(3,1,1)\cr
\{i,i+1,i+3\}&s_i+5s_{i+1}+4s_{i+3}=0&(2,1,1).
\end{array}                                             \tag{3.4}
\]

The equalities in the middle column are modulo eleven.  They classify all
multiplicities, not just the least representatives in the last column.  The
two triple rows are the two cyclic orbits of three-subsets: their complements
are respectively an adjacent pair and a diagonal pair.

There is no hidden integral obstruction behind (3.3).  Let `A=2I+shift`, so
that (3.1) is `w=Ax`.  Its determinant is 33, and

\[
 A\mathbf Z^5
 =\left\{w:\ \mu\mathbin\cdot w=0\pmod {11},\quad
                  \sum_jw_j=0\pmod3\right\}.           \tag{3.5}
\]

For `w=m 1+s`, condition (3.3) is the first condition in (3.5), and the
second is achieved by the unique choice

\[
 m=\sum_js_j\pmod3.                                   \tag{3.6}
\]

Adding three to `m` adds `1` to every entry of `x`.  Thus every positive
incidence pattern satisfying (3.3) has an integral, and after a sufficiently
large common offset a nonnegative, divisor lift through `2I+shift`.

For the two least triple patterns the small lifts are already

\[
\begin{aligned}
 (3,1,1,0,0)+2\mathbf1
   &=(5,3,3,2,2)=A(2,1,1,1,0),\\
 (2,1,0,1,0)+\mathbf1
   &=(3,2,1,2,1)=A(1,1,0,1,0).                         \tag{3.7}
\end{aligned}
\]

## 4. A cyclic formal counterconfiguration

Introduce ten distinct formal prime symbols `C_i,G_i`, cyclically permuted
by `sigma`, and put

\[
 \mathcal H_j=
 C_j^3C_{j-1}C_{j-2}\,
 G_j^2G_{j-1}G_{j-3},                                  \tag{4.1}
\]

\[
 \mathcal Q=\prod_{i=0}^4C_i^2G_i,
 \qquad \mathcal B_j=\mathcal Q\mathcal H_j.           \tag{4.2}
\]

Then:

* `C_i` meets `(H_i,H_(i+1),H_(i+2))` with multiplicities `(3,1,1)`;
* `G_i` meets `(H_i,H_(i+1),H_(i+3))` with multiplicities `(2,1,1)`;
* every `C_i` has the first integral lift in (3.7), and every `G_i` the
  second;
* `sigma(mathcal H_j)=mathcal H_(j+1)` and `mathcal Q` is invariant;
* if all ten symbols have degree one, every `mathcal H_j` has degree nine.

This configuration passes the standard rank-four Wronskian count with very
large slack.  For five terms spanning dimension four, a prime with `m_P`
nondivisible terms has refined local weight

\[
 {4\choose2}-{m_P-1\choose2}.                          \tag{4.3}
\]

Every formal prime above divides three terms, so `m_P=2` and its weight is
six.  The resulting right side is

\[
 -{4\choose2}+10\cdot6=54,                             \tag{4.4}
\]

whereas the formal degree is only nine.

It also passes the five-hyperplane Cartan truncation in `P^3`.  The
coefficient is `5-3-1=1` and counting truncates at level three.  Each `C_i`
contributes `3+1+1=5`, and each `G_i` contributes `2+1+1=4`, so

\[
 1\cdot9\le5\cdot5+5\cdot4=45.                        \tag{4.5}
\]

The common factor `mathcal Q` is removed in both projective counts.

Equations (4.1)--(4.2) are an exact **divisor counterconfiguration** to these
inequalities.  They are not Laurent polynomials satisfying
`sum H_j=0`, and they are not a trace solution.

## 5. Exact unramified local Fourier models

The formal multiplicities in Section 4 are not merely numerical accidents.
Both least triple types occur in exact rank-four polynomial hyperplane nets.

### 5.1 Consecutive triple

Set

\[
\begin{aligned}
 h_0&=t^3,& h_1&=t,& h_2&=t+t^2,\\
 h_3&=1,& h_4&=-(1+2t+t^2+t^3).
\end{aligned}                                          \tag{5.1}
\]

Then

\[
 \sum_jh_j=0,\qquad
 (v_0(h_0),\ldots,v_0(h_4))=(3,1,1,0,0).               \tag{5.2}
\]

The four functions `(1,t,t+t^2,t^3)` form a basis of the polynomials of
degree at most three.  Hence (5.1) has exactly one constant relation, the
displayed five-term relation; in particular it has no proper zero subsum.
Its four nontrivial Fourier components form a basis as well, so this is an
exact full four-character Fourier net.

Its Wronskian is

\[
 W(1,t,t+t^2,t^3)=12.                                  \tag{5.3}
\]

Thus the triple incidence creates no ramification.  Logarithmically, the
three vanishing sections have residues `(3,1,1)`; the difference
`h_2-h_1=t^2` supplies the missing order two, so the vanishing sequence is
the ordinary `(0,1,2,3)`.

After multiplying all five terms by `t^2`, their valuations are the first
vector in (3.7), an exact integral `2I+shift` lift.

### 5.2 Gapped triple

Set

\[
\begin{aligned}
 k_0&=t^2,& k_1&=t,& k_2&=1,\\
 k_3&=t+t^3,& k_4&=-(1+2t+t^2+t^3).
\end{aligned}                                          \tag{5.4}
\]

Now

\[
 \sum_jk_j=0,\qquad
 (v_0(k_0),\ldots,v_0(k_4))=(2,1,0,1,0).               \tag{5.5}
\]

Again the five functions have exactly one constant relation, no proper zero
subsum, and four nonzero independent Fourier components.  The basis
`(1,t,t^2,t+t^3)` has Wronskian 12.  The difference `k_3-k_1=t^3`, together
with `k_0=t^2`, gives the unramified vanishing sequence `(0,1,2,3)`.

Multiplication by `t` gives the second exact integral lift in (3.7).

Both models are projectively the complete cubic series
`[1:t:t^2:t^3]` on `P^1`.  Consequently even the full local ramification
sequence, not only the coarse Wronskian order, accepts both minimal triple
incidences.

## 6. The local multiplicative equation also lifts

The last common offsets in Section 5 are not cosmetic.  Let

\[
 \widehat L=\prod_{j=0}^4\mathbf C((t))
\]

with `sigma` cyclically shifting the five factors.  At a free Laurent-prime
orbit this is the relevant semilocal formal shape.  Let `c_j` be the five
unit germs of the conjugates of `c`.

For either local model, write the common-factor-adjusted terms as
`beta_j=t^(w_j)u_j`.  Equation (3.7) supplies a nonnegative vector `x` with
`w=Ax`.  The unit group `C[[t]]^*` is divisible, while `det(A)=33`; hence the
map

\[
 (v_j)\longmapsto(v_j^2v_{j+1})                        \tag{6.1}
\]

is surjective on five-tuples of units.  Choose `v_j` so that

\[
 c_jv_j^2v_{j+1}=u_j
\]

and put `a_j=t^(x_j)v_j`.  Then in the semilocal completion

\[
 \beta=c a^2\sigma(a),\qquad \operatorname {Tr}(\beta)=0. \tag{6.2}
\]

This is an exact **formal semilocal model**, but it is still not a solution in
`E`.  It does not construct global Laurent eigenfunctions `F_q`, and it does
not prove that the five formal germs algebraize and glue to one rational
function on the generic torus.  That global compatibility is precisely the
information discarded by primewise logarithmic, Wronskian, and ramification
tests.

## 7. Exact boundary

The proved rank-four conclusions are

```text
RANK4-FOURIER-HYPERPLANE-SYSTEM-EXACT
RANK4-FOURIER-PRIME-INCIDENCE-AT-MOST-THREE
RANK4-MOD11-MULTIPLICITY-CLASSIFICATION-EXACT
RANK4-TRIPLE-INCIDENCE-WRONSKIAN-RAMIFICATION-ESCAPE
RANK4-GLOBAL-CASE-OPEN
F55-GLOBAL-QUESTION-OPEN
```

Thus a successful all-support exclusion must couple different Laurent
primes through the global eigencharacter functions `F_q`, or introduce a
genuinely global invariant not visible in the semilocal completion.  The
incidence ceiling, the exact mod-eleven residues, logarithmic residues,
ordinary Wronskians, local ramification, and level-three Cartan truncation do
not supply that coupling.

