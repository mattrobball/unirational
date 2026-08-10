# The rank-three Fourier net and its pair-divisor escape

**Date:** 2026-08-08  
**Scope:** all Laurent supports and degrees; fixed five-line incidence only  
**Result:** exact rank-three reduction, not a rank-three exclusion

This addendum continues `THEOREM.md`, Theorem 5.1.  It proves that a
hypothetical cyclic-rank-three trace zero must contain pair-common Fourier
divisors.  It then shows exactly why ordinary four-term Mason/Wronskian and
Cartan truncation do not eliminate those divisors.

No Laurent support, exponent box, or polynomial degree is enumerated.

## 1. The five-line Fourier net

Assume that the cyclic span of

\[
 b=c a^2\sigma(a),\qquad \sum_{j=0}^4\sigma^j(b)=0
\]

has dimension three.  Choose its three nontrivial Fourier components.  After
absorbing common rational factors, the five conjugates have the form

\[
 b_j=\alpha^j QH_j,
 \qquad
 H_j=F+\eta^jG+\theta^jH,                               \tag{1.1}
\]

where `F,G,H in R` have gcd one and the three characters
`1,eta,theta` are distinct powers of a primitive fifth root after a common
character has been removed.

Every `3 x 3` minor of the five Fourier rows

\[
 (1,\eta^j,\theta^j),\qquad 0\le j<5,                  \tag{1.2}
\]

is nonzero.  This is the prime-order full-spark property of the order-five
Fourier matrix.  Here it is also a fixed calculation: all forty minors for
the four possible triples of nontrivial characters remain nonzero after
specializing a fifth root to the order-five element `3 in F_11`.

Consequently an irreducible Laurent prime can divide at most two of the
`H_j`.  If it divided three, (1.2) would force it to divide `F,G,H`, contrary
to their gcd-one normalization.

The conjugacy is genuine at the divisor level.  From
`sigma(b_j)=b_(j+1)` one obtains

\[
 \sigma(H_j)=L H_{j+1},\qquad L={\alpha Q\over\sigma Q}. \tag{1.3}
\]

Taking the minimum valuation over all `j` on both sides and using
`gcd(H_0,...,H_4)=1` shows that `L` has zero valuation at every Laurent
prime.  Hence `L` is a Laurent unit.  In particular the pair-divisor strata
are cyclically permuted.

## 2. Exact multiplicity congruences

Retain the term-coordinate cokernel row

\[
 \mu=(1,5,3,4,9)\pmod {11}
\]

from `THEOREM.md`, Section 3.  Let `P` divide `H_i` with multiplicity `s_i`
and possibly `H_k` with multiplicity `s_k`.  Since the common factor `Q`
adds a diagonal valuation vector, the exact condition is

\[
 \mu_i s_i+\mu_k s_k=0\pmod {11}.                       \tag{2.1}
\]

For a prime unique to `H_i`, this says `11 | s_i`.

Since `mu_(i+1)=5 mu_i` and `mu_(i+2)=3 mu_i` modulo eleven, the two cyclic
pair types are

\[
\begin{array}{c|c|c}
\text{pair}&\text{congruence}&\text{least positive pair}\cr
(i,i+1)&s_i+5s_{i+1}=0&(1,2)\cr
(i,i+2)&s_i+3s_{i+2}=0&(2,3).
\end{array}                                             \tag{2.2}
\]

Thus the modulus eleven makes unique factors eleventh powers, but it permits
pair-common factors with multiplicities as small as one and two.  These are
not artificial valuations: `(1,2,0,0,0)` is exactly

\[
 (2I+\text{shift})(0,1,0,0,0).                         \tag{2.3}
\]

It is the divisor pattern produced by one simple factor of `a`.

The remaining Smith factor is the sum modulo three.  A diagonal pair
`(2,3)` has sum five, so its common diagonal offset must be `2 mod 3`.
Taking offset two gives

\[
 2\mathbf1+2e_i+3e_{i+2}
  =(2I+\text{shift})(2e_i+2e_{i+2}+e_{i+3}),            \tag{2.4}
\]

whereas the adjacent pair needs offset zero and is already (2.3).  Hence
both minimal pair types satisfy the **full** integral divisor-lifting test,
not only its order-eleven quotient.

## 3. What would happen without pair divisors

### Proposition 3.1

A cyclic-rank-three solution cannot have the five `H_j` pairwise coprime.

### Proof

If the `H_j` are pairwise coprime, (2.1) gives

\[
 H_j=U_jY_j^{11}                                       \tag{3.1}
\]

with Laurent units `U_j`.  Any four Fourier rows in (1.2) have one
constant-coefficient relation, all four coefficients are nonzero, and no
proper subsum vanishes because any three rows are independent.

Restrict to a generic one-parameter torus coset, as in the power-pencil
lemma of `THEOREM.md`.  The pairwise-coprime four-term generalized Mason
bound has coefficient `4-2=2`.  If `d_j` is the Laurent width of the
restricted `Y_j` and `d=max d_j`, then

\[
 11d\le2\sum_{j=1}^4d_j\le8d.                          \tag{3.2}
\]

Hence all `Y_j` are units.  A nondegenerate relation among four Laurent
monomials cannot split into exponent classes, so the four monomials must be
associates.  The full-spark Fourier equations then make `F,G,H` associates,
which would make the nontrivial eigen-ratios constant.  This is impossible.
QED.

Thus pair-common divisors are a **necessary** escape from the rank-two
argument.

## 4. The refined four-term Wronskian still permits the escape

For four polynomials spanning dimension three, the refined univariate
Wronskian bound assigns to a prime `P` the local weight

\[
 {3\choose2}-{m_P-1\choose2},                          \tag{4.1}
\]

where `m_P` is the number of the four terms not divisible by `P`.  A prime
dividing one term has weight two; a prime dividing two terms has weight
three.

The exact congruences (2.2) admit the following cyclic formal divisor
configuration.  Introduce five adjacent-pair primes `D_i` and five
diagonal-pair primes `E_i`, and set

\[
 \mathcal H_i=
 D_iD_{i-1}^2 E_i^2E_{i-2}^3.                          \tag{4.2}
\]

To include the diagonal mod-three offset, put

\[
 \mathcal Q=\prod_{i=0}^4E_i^2,
 \qquad \mathcal B_i=\mathcal Q\mathcal H_i.           \tag{4.3}
\]

Then

- `D_i` divides `(mathcal H_i,mathcal H_(i+1))` with exponents `(1,2)`;
- `E_i` divides `(mathcal H_i,mathcal H_(i+2))` with exponents `(2,3)`;
- every prime of the five `mathcal B_i` satisfies the full integral
  `(2I+shift)` divisor condition by (2.3)--(2.4);
- if every formal prime has degree one, every `mathcal H_i` has degree eight.

Delete any one of the five terms to form a four-term Fourier relation.  Of
the ten pair primes, six join two retained terms and four join the deleted
term to a retained term.  The right side of the refined Wronskian bound is

\[
 -{3\choose2}+6\cdot3+4\cdot2=23,                      \tag{4.4}
\]

while the left side is only eight.  Thus the exact mod-eleven pair
multiplicities are comfortably compatible with every four-term Wronskian
inequality.

The same configuration passes the five-line Cartan truncation.  For five
lines in `P^2`, the coefficient on the characteristic is `5-3=2` and the
counting functions truncate at level two.  The adjacent primes contribute
`5(1+2)=15`, the diagonal primes contribute `5(2+2)=20`, while twice the
formal degree is only `16`:

\[
 2\cdot8\le15+20.                                      \tag{4.5}
\]

The common factor `mathcal Q` is removed before either projective inequality,
so it does not alter (4.4)--(4.5).  Configuration (4.2)--(4.3) is a
counterconfiguration to these divisor inequalities, not a construction of
polynomials satisfying the Fourier net.

## 5. An actual local Fourier-net realization of the adjacent escape

The small pair `(1,2)` also occurs in an exact rank-three polynomial net.
Let `zeta` be a primitive fifth root and put

\[
\begin{aligned}
 h_0&=t,\\
 h_1&=t^2,\\
 h_2&=1,\\
 h_3&=(\zeta+\zeta^2+\zeta^3)+\zeta t
          +(\zeta+\zeta^2)t^2,\\
 h_4&=\zeta^4-(1+\zeta)t+(\zeta^3+\zeta^4)t^2.
\end{aligned}                                          \tag{5.1}
\]

Directly,

\[
 \sum_jh_j=0,\qquad \sum_j\zeta^j h_j=0,              \tag{5.2}
\]

and the other three Fourier components are nonzero.  Hence the cyclic span
of the indexed vector `(h_0,...,h_4)` has dimension exactly three.  No proper
subsum vanishes.  At `t=0`, its valuation vector is

\[
 (1,2,0,0,0),\qquad \mu\cdot(1,2,0,0,0)=11.            \tag{5.3}
\]

Thus the full-spark Fourier net, additive nondegeneracy, and the smallest
allowed pair-divisor multiplicities coexist exactly.  The other primes of
(5.1) do not satisfy all lifting residues, so (5.1) is not a solution of the
`F55` trace equation.  Its role is to show that the adjacent pair escape
cannot be removed by local Fourier linear algebra.

## 6. Exact remaining rank-three problem

The current uniform conclusion is:

```text
RANK3-FOURIER-PRIME-INCIDENCE-AT-MOST-TWO
RANK3-PAIRWISE-COPRIME-CASE-EXCLUDED
RANK3-PAIR-DIVISOR-MASON-CARTAN-ESCAPE
RANK3-GLOBAL-CASE-OPEN
```

A rank-three exclusion must couple the ten pair-gcd strata across different
Laurent primes and use the fact that the five factored expressions still lie
in the same three-dimensional Fourier net.  Valuation residues, four-term
Wronskians, and level-two Cartan truncation do not supply that coupling.
