# Ordinary graded constraints on the sixteen progression families

**Date:** 2026-08-08  
**Status:** `EXACT GRADED/KUMMER LEMMA; DEGREE < 20 EMPTY; DIVISOR CLOSURE REFUTED`  
**Strict scope:** this note does not exclude the progression families in all
degrees and does not construct a Klein landing covariant.

Let `k` be algebraically closed of characteristic five, put

\[
 R=k[x_0,\ldots,x_4],\qquad
 W=(1,9,4,3,5),\qquad Q=x_0x_1x_2x_3x_4,
\]

and let `rho` shift exponent vectors by
`rho(e)_j=e_(j-1)`.  Polynomial weight always means the dot product with
`W`, modulo eleven.  This note inserts the ordinary grading and the
`C11`-weight into the sixteen cases left by
`CHAR5_MINIMAL_REDUCTION.md`.

## 1. Canonical ordinary form

For `d,r in F_5^*`, let

\[
 a_{d,j}=\langle dj\rangle_5,
 \qquad b_{d,r,j}=\langle dj+r\rangle_5,
 \qquad j=0,\ldots,4,                              \tag{1.1}
\]

where the brackets denote the representative in `{0,1,2,3,4}`.  Both
vectors are permutations of `(0,1,2,3,4)`, and hence both have ordinary
degree ten.

### Proposition 1.1 (ordinary graded/Kummer normal form)

If a nonzero homogeneous weight-one polynomial `f` has exactly the two
Frobenius residues `a_d,b_(d,r)`, then uniquely

\[
 f=x^{a_d}H^5+x^{b_{d,r}}K^5,                         \tag{1.2}
\]

where `H,K` are nonzero **ordinary homogeneous polynomials of the same
degree** `n`.  In particular

\[
                         \deg f=10+5n.                 \tag{1.3}
\]

The two roots are `C11` semi-invariants.  If

\[
 A_d=W\mathbin\cdot a_d,
 \qquad B_{d,r}=W\mathbin\cdot b_{d,r},               \tag{1.4}
\]

then, because `5^(-1)=9 mod 11`,

\[
 \operatorname {wt}(H)=9(1-A_d),\qquad
 \operatorname {wt}(K)=9(1-B_{d,r})\pmod {11}.        \tag{1.5}
\]

The complete table is as follows.  The column `delta=r/d` records the
separation of the two surviving target coordinates on a coordinate
divisor.

| `(d,r)` | `a_d` | `b_(d,r)` | `(A,B)` | `(wt H,wt K)` | `delta` |
|---|---|---|---|---|---:|
| `(1,1)` | `01234` | `12340` | `(2,10)` | `(2,7)` | 1 |
| `(1,2)` | `01234` | `23401` | `(2,6)` | `(2,10)` | 2 |
| `(1,3)` | `01234` | `34012` | `(2,8)` | `(2,3)` | 3 |
| `(1,4)` | `01234` | `40123` | `(2,7)` | `(2,1)` | 4 |
| `(2,1)` | `02413` | `13024` | `(8,10)` | `(3,7)` | 3 |
| `(2,2)` | `02413` | `24130` | `(8,7)` | `(3,1)` | 1 |
| `(2,3)` | `02413` | `30241` | `(8,6)` | `(3,10)` | 4 |
| `(2,4)` | `02413` | `41302` | `(8,2)` | `(3,2)` | 2 |
| `(3,1)` | `03142` | `14203` | `(9,5)` | `(5,8)` | 2 |
| `(3,2)` | `03142` | `20314` | `(9,4)` | `(5,6)` | 4 |
| `(3,3)` | `03142` | `31420` | `(9,1)` | `(5,0)` | 1 |
| `(3,4)` | `03142` | `42031` | `(9,3)` | `(5,4)` | 3 |
| `(4,1)` | `04321` | `10432` | `(4,3)` | `(6,4)` | 4 |
| `(4,2)` | `04321` | `21043` | `(4,5)` | `(6,8)` | 3 |
| `(4,3)` | `04321` | `32104` | `(4,1)` | `(6,0)` | 2 |
| `(4,4)` | `04321` | `43210` | `(4,9)` | `(6,5)` | 1 |

There is also a global ramification constraint absent from the abstract
Artin--Schreier countermodels.  On putting

\[
 Z={x^{b_{d,r}}K^5\over x^{a_d}H^5},
 \qquad
 \epsilon={a_d+r\mathbf1-b_{d,r}\over5}\in\{0,1\}^5,
\]

one has `sum epsilon_j=r` and

\[
 Z=Q^r\left(x^{-\epsilon}{K\over H}\right)^5.          \tag{1.6}
\]

The rational semi-invariant inside parentheses has weight zero: indeed
`B-A=-5 W*epsilon` and (1.5) gives
`wt(K)-wt(H)=W*epsilon`.  Thus both it and `Z` belong to the affine
`C11`-quotient function field; `Z` is also homogeneous of degree zero.  Its
Kummer class there is

\[
                         [Z]=[Q]^r.                     \tag{1.7}
\]

Equivalently, every noncoordinate prime has valuation divisible by five,
while

\[
                   \operatorname {ord}_{x_j}(Z)\equiv r\pmod5             \tag{1.8}
\]

for every coordinate prime.  Since `rho(Q)=Q`, all five conjugates have the
same Kummer class and

\[
                         {\rho^iZ\over Z}\in\operatorname {Frac}(R)^{*5}.
                                                                    \tag{1.9}
\]

Proof of Proposition 1.1.  Frobenius-residue decomposition is unique because
`R` is free over `R^5` on the monomials with exponents in
`{0,1,2,3,4}^5`.  Perfectness of `k` supplies the fifth roots.  Equality of
the two ordinary degrees gives (1.3).  The `C11` action is semisimple, so
each residue component, and then each fifth root, is a semi-invariant;
(1.5) follows.  Formula (1.6) follows from
`b=a+r*1-5*epsilon`.  All remaining assertions are immediate.  QED.

## 2. The coordinate-boundary UFD lemma

Let `D_j=V(x_j)`.  For `f_i=rho^i(f)`, the first term of (1.2) can survive
on `D_j` only for `i=j`, and the second only for

\[
                         i=j+\delta,\qquad \delta=r/d\pmod5.               \tag{2.1}
\]

Consequently the restriction of `T_f` to `D_j` has at most two nonzero
target coordinates, numbered `j` and `j+delta`.

### Proposition 2.1 (adjacent-boundary divisibility)

If `K(T_f)=0`, then

\[
\begin{array}{c|c}
\delta=1 & x_0\mid H\quad\hbox{or}\quad x_4\mid K,\\
\delta=4 & x_0\mid H\quad\hbox{or}\quad x_1\mid K.
\end{array}                                             \tag{2.2}
\]

For `delta=2,3`, the coordinate-boundary restriction gives no equation.

Indeed, for `delta=1`, the Klein cubic restricts on the target line
`<e_j,e_(j+1)>` to `y_j^2y_(j+1)`.  Since `R/(x_j)` is a domain, its
pullback is zero only if

\[
 x_j\mid\rho^jH\quad\hbox{or}\quad
 x_j\mid\rho^{j+1}K.
\]

Taking `j=0` gives the first line of (2.2).  The case `delta=4` uses
`y_(j-1)^2y_j` and gives the second.  When `delta=2,3`, the corresponding
coordinate line is one of the ten coordinate lines contained in the Klein
cubic.  QED.

The five values of `j` do not give five independent factors: they are the
five translates of the same alternative in (2.2).  Thus this lemma alone
does not force `Q` to divide either root or force a common cyclic factor.

## 3. Exact degree consequence

The weights occurring among degree-`n` monomials are

\[
\begin{array}{c|c}
n=0&\{0\},\\
n=1&\{1,3,4,5,9\},\\
n=2&\{1,2,3,4,5,6,7,8,9,10\},\\
n\ge3&\mathbf Z/11.
\end{array}                                             \tag{3.1}
\]

The last line follows from the fixed degree-three check and multiplication
by `x_0`: translating the full set of residues by one leaves it full.

It follows from the table that only `(d,r)=(2,2),(3,4)` even exist with
`n=1`.  In both cases `H,K` are single variables, so `f` has two monomials.
The segment theorem in `CHAR5_NORMAL_FAN_ADDENDUM.md` makes the associated
covariant dominant; it cannot land on a hypersurface.

For `(2,2)`, Proposition 2.1 also rules out `n=2`: its two alternatives
would require a degree-one polynomial of weight

\[
                    3-1=2\quad\hbox{or}\quad1-5=7,
\]

and neither weight occurs in degree one.  The pairs `(3,3)` and `(4,3)`
require `wt(K)=0`, which among positive degrees first occurs in degree
three.  Therefore every
progression landing, if one exists, satisfies

\[
                         \deg f\ge20,                   \tag{3.2}
\]

and the three families

\[
                  (2,2),\ (3,3),\ (4,3)                \tag{3.3}
\]

in fact satisfy `deg f>=25`.

This is an analytic degree floor, not a bounded degree search and not a
finite cutoff.

## 4. Why coordinate-divisor ramification does not close the proof

Write `p_j=ord_(x_j)(H)` and `q_j=ord_(x_j)(K)`.  In each of the five
Frobenius-residue bucket equations, a necessary DVR condition is that the
minimum valuation among its six nonzero displayed terms occur at least
twice.  The following fixed table satisfies that condition simultaneously
for all five buckets and all five coordinate primes.  It also has zero
common coordinate valuation among the five cyclic coordinates of `T_f`.

| `(d,r)` | `p` | `q` |
|---|---|---|
| `(1,1)` | `01000` | `00001` |
| `(1,2)` | `00000` | `00001` |
| `(1,3)` | `00002` | `00110` |
| `(1,4)` | `01001` | `01011` |
| `(2,1)` | `00000` | `00000` |
| `(2,2)` | `00000` | `00001` |
| `(2,3)` | `00001` | `01001` |
| `(2,4)` | `00000` | `00000` |
| `(3,1)` | `00100` | `00000` |
| `(3,2)` | `01001` | `01011` |
| `(3,3)` | `01012` | `01001` |
| `(3,4)` | `00000` | `00001` |
| `(4,1)` | `00002` | `01001` |
| `(4,2)` | `00001` | `01001` |
| `(4,3)` | `00001` | `00110` |
| `(4,4)` | `00001` | `00012` |

These are not merely incompatible formal weights.  For any omitted variable,
the other four variables realize every `C11` weight already in degree three.
Hence, for every prescribed weight `w` and every degree `m>=3`, there is a
weight-`w` polynomial of degree `m` not divisible by any coordinate
variable: sum, for the five omitted variables, one monomial of the required
weight.  It follows that every row of the table is realized by ordinary
homogeneous semi-invariants of the weights in Section 1 for all sufficiently
large common root degrees.

The table is therefore an exact counterconfiguration to closing the problem
using only:

* ordinary homogeneity and the two `C11` weights;
* the Kummer congruences (1.7)--(1.9);
* coordinate-prime UFD valuations; and
* the requirement that every six-term bucket have at least two lowest
  terms.

It is **not** a coefficient solution of the bucket equations.  In
particular it is not a Klein landing and does not refute a future argument
using noncoordinate prime divisors, residues of leading coefficients, or
the global geometry of the cyclic quotient.

## 5. Verdict

Polynomiality and `C11` grading sharpen the progression branch: they give
the canonical equal-degree form, its nontrivial Kummer ramification class,
the adjacent-boundary factor lemma, and the degree bounds (3.2)--(3.3).
They do not give an all-degree contradiction.  From root degree three on,
all required weights occur, and the fixed valuation table shows why the
coordinate-divisor argument cannot be iterated formally to a common factor.

Replay:

```sh
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/TRACE_POSITIVE/verify_char5_graded_progression.py
```

Expected marker:

```text
F55-CHAR5-GRADED-PROGRESSION-BOUNDARY-OK
F55-CHAR5-PROGRESSION-ALL-DEGREE-OPEN
F55-QUESTION-OPEN
```
