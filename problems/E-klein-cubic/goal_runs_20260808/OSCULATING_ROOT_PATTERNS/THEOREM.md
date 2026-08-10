# Root-supported degree-nine osculating ansatz

**Date:** 2026-08-08  
**Result:** `F55-OSCULATING-ROOT-SUPPORTED-DEGREE9-EMPTY-SCOPED`  
**Headline:** `F55-QUESTION-OPEN`

## 1. Exact scope

Put

\[
 E=\mathbf C(r_0,\ldots,r_4)/(r_0r_1r_2r_3r_4-1),
 \qquad \sigma(r_j)=r_{j+1},
\]

with indices modulo five, and set

\[
 p(T)=\prod_{j=0}^4(T-r_j),\qquad
 \ell_i(T)=\frac{p(T)}{T-r_i}.
\]

Let

\[
 q(T)=u\prod_{j=0}^4(T-r_j)^{m_j},\qquad
 q_i=\sigma^i(q),\qquad x_i=\ell_iq_i,                 \tag{1.1}
\]

where

\[
 u\in E^*,\qquad m_j\in\mathbf Z_{\ge0},\quad
 m_0=0,\quad m_4\ge1,\quad
 \sum_jm_j\le5.                                       \tag{1.2}
\]

Thus `deg(x_i)<=9`.  The coefficient `u` is completely arbitrary; it is not
assumed to be a Laurent monomial or a unit in a chosen affine model.

Define the pulled-back trace cubic

\[
 S(T)=\sum_{i=0}^4\frac{x_i(T)^2x_{i+1}(T)}{r_{i+2}}.  \tag{1.3}
\]

### Theorem

For every choice (1.1)--(1.2),

\[
                         p(T)^5\nmid S(T).              \tag{1.4}
\]

Consequently the root-supported osculating ansatz does not produce a curve
with contact at least five at all five conjugate vertices.  In particular it
does not produce the degree-at-most-two residual intersection used in the
degree-nine positive construction.

This is a theorem only about (1.1).  A general polynomial
`q=(product of prescribed root factors) h(T)` with a nonconstant factor `h`
having no `r_j` as a root is not covered.  Nor does this exclude arbitrary
degree-nine equivariant curves, arbitrary trace points, `F55`-unirationality,
or `PSL(2,11)`-unirationality.

## 2. The analytically forced finite list

At `T=r_k`, put `d=k-i`.  The order of the `i`th summand of (1.3) is

\[
 w_d=3-2[ d=0]-[d=1]+2m_d+m_{d-1}.                    \tag{2.1}
\]

If (1.4) failed, every minimum below five in the five numbers `w_d` would
have to occur at least twice.  There are only

\[
 \#\{m:m_0=0,\ m_4\ge1,\ \sum m_j\le5\}=70           \tag{2.2}
\]

vectors to consider.  Formula (2.1), not a degree sweep, leaves exactly
twenty:

1. fifteen pair-leading patterns
   \[
   m=(0,0,a,b,1),\qquad a,b\ge0,\quad a+b\le4,
   \]
   whose tied terms at `r_0` are `i=0,4`;
2. three pair-leading patterns
   \[
   m=(0,s,0,0,2),\qquad s=1,2,3,
   \]
   whose tied terms are `i=0,2`;
3. two triple-leading patterns
   \[
   A=(0,1,0,1,3),\quad I_A=(0,4,3),
   \qquad
   B=(0,1,1,0,3),\quad I_B=(0,4,2).                  \tag{2.3}
   \]

The replay enumerates only the seventy vectors in (2.2).

## 3. Leading coefficients and the eighteen pair exclusions

Write `D_h=r_0-r_h`, `h=1,...,4`.  Removing `u_i=\sigma^i(u)`, the leading
coefficient of `x_i` at `r_0` is

\[
 \alpha_i=\prod_{h=1}^4
 D_h^{,1-[i=h]+m_{h-i}}.                              \tag{3.1}
\]

Hence the leading coefficient of the `i`th cubic summand is

\[
 C_iU_i,\qquad
 C_i=r_{i+2}^{-1}\alpha_i^2\alpha_{i+1},
 \qquad U_i=u_i^2u_{i+1}.                              \tag{3.2}
\]

Let

\[
 P_j=r_j-r_{j+1},\qquad Q_j=r_j-r_{j+2}.               \tag{3.3}
\]

All nonunit factors of `C_i` belong to these two length-five prime orbits.
For a specified rational function `v`, the length-five divisor vector of
`v^2\sigma(v)` is in the image of `2+P`.  After its prime divisors have been
removed, the torus-unit cokernel is detected by

\[
 \lambda=(1,9,4,3,5)\pmod {11}.                        \tag{3.4}
\]

Suppose two terms `i,j` were the unique leading pair.  Their cancellation
would give

\[
 \frac{C_i}{C_j}=-\frac{U_j}{U_i}
 =-\bigl(u_j/u_i\bigr)^2\sigma(u_j/u_i).               \tag{3.5}
\]

If the difference-prime divisor of the left side does not lift, (3.5) is
already impossible.  If it does lift, removing it changes the residual unit
only by an element in \((2+\sigma)M\) and by a complex constant.  Its class is
therefore the class of \(c_i/c_j\), where \(c_i=r_{i+2}^{-1}\).

For the first fifteen patterns,

\[
 \lambda(c_0/c_4)=\lambda(r_1/r_2)=9-4=5\ne0.
\]

For the remaining three,

\[
 \lambda(c_0/c_2)=\lambda(r_4/r_2)=5-4=1\ne0.
\]

This excludes all eighteen pair-leading patterns for arbitrary `u in E*`.

## 4. Exact cyclic valuation classification for the two triples

Fix a length-five prime orbit `R_j=sigma^j(R_0)` and put

\[
 W_i=v_{R_0}(U_i).
\]

If `z_i=v_(R_0)(u_i)`, then

\[
 W_i=2z_i+z_{i+1}.                                     \tag{4.1}
\]

Thus

\[
 \mu\mathbin\cdot W=0\pmod {11},\qquad
 \mu=(1,5,3,4,9),                                     \tag{4.2}
\]

because \(2\mu_i+\mu_{i-1}=0\) and \(\sum_i\mu_i=0\) modulo eleven.

The leading identity at `r_0` and its four conjugates give five tropical
three-term equations at `R_0`.  In each equation one of three pairs realizes
the minimum.  There are therefore exactly `3^5=243` active-pair signatures.
Solving their difference equalities and inequalities gives the following
complete lists, normalized by subtracting the common minimum.

| pattern | orbit | all tropical profiles | profiles surviving (4.2) |
|---|---|---|---|
| `A` | `P` | `0`, `s e_1`, `s e_2`, `s e_3` (`s>=0`), `(1,0,0,0,1)` | `0`, `11n e_1`, `11n e_2`, `11n e_3` |
| `A` | `Q` | `(1,0,0,s,0)` (`s>=0`) | `(1,0,0,8+11n,0)` |
| `B` | `P` | `(2,s,0,0,0)` (`s>=0`) | `(2,4+11n,0,0,0)` |
| `B` | `Q` | `0`, `s e_0`, `s e_1`, `s e_3` (`s>=0`), `(0,0,t,0,t)` (`t=1,2`) | `0`, `11n e_0`, `11n e_1`, `11n e_3` |

Here `n>=0`.  The discarded isolated profiles have residues

\[
 \mu(1,0,0,0,1)=10,
 \qquad
 \mu(0,0,t,0,t)=t\ne0\pmod {11}.                      \tag{4.3}
\]

For any unmarked length-five prime orbit, the same `3^5` classification with
zero coefficient offsets says that the normalized profile is `0` or `s e_j`.
Equation (4.2) forces \(11\mid s\), since every \(\mu_j\) is nonzero.  A fixed prime
orbit contributes only a common factor.  Therefore, after common factors are
removed, every unmarked divisor changes the order of at most one of the three
terms, and changes it by a multiple of eleven.

The active-pair calculation is exact: it propagates integer difference
equalities, then solves the remaining one-dimensional difference
inequalities.  It does not bound or enumerate the values of `W`.

## 5. Codimension-two exclusion of pattern A

For pattern `A`, the coefficient-only `P`- and `Q`-vectors of the terms
`(0,4,3)` are

\[
\begin{array}{c|ccc}
 &i=0&i=4&i=3\\ \hline
P&(4,0,0,0,10)&(4,0,0,0,4)&(5,0,0,0,4)\\
Q&(4,0,0,5,0)&(5,0,0,10,0)&(10,0,0,4,0).
\end{array}                                             \tag{5.1}
\]

Consider the generic point of

\[
 Z_A=\{Q_0=Q_2=0\}.
\]

Here `r_0=r_2=r_4`, the local parameters may be taken as

\[
 s=Q_0,qquad t=Q_2,qquad P_4=-(s+t),                 \tag{5.2}
\]

and all other differences are units.  Using the surviving profiles in the
table, the residual orders of the terms `(0,4,3)` are

\[
\begin{array}{c|ccc}
 &i=0&i=4&i=3\\ \hline
Q_0&0&0&13+11n\\
Q_2&8+11n&0&0\\
P_4&6+11a&0&0.
\end{array}                                             \tag{5.3}
\]

The parameter `a` is present only when the `P`-profile spikes in the relevant
entry; otherwise it is zero.  Every unmarked divisor through `Z_A` adds a
multiple of eleven to one term's local order, by Section 4.  Thus, up to a
common shift, the three maximal-ideal orders are congruent to

\[
                     (14,0,13)=(3,0,2)\pmod {11}.       \tag{5.4}
\]

They are pairwise incongruent, hence no two can be equal.  The maximal-ideal
order in this regular local ring satisfies the unique-minimum rule: a sum
cannot vanish when exactly one summand has least order.  This contradicts the
leading identity and excludes `A`.

## 6. Codimension-two exclusion of pattern B

For pattern `B`, the coefficient vectors of the terms `(0,4,2)` are

\[
\begin{array}{c|ccc}
 &i=0&i=4&i=2\\ \hline
P&(4,0,0,0,9)&(6,0,0,0,4)&(9,0,0,0,6)\\
Q&(6,0,0,4,0)&(4,0,0,9,0)&(4,0,0,4,0).
\end{array}                                             \tag{6.1}
\]

Use instead the generic point of

\[
 Z_B=\{P_0=P_1=0\}.
\]

Here `r_0=r_1=r_2` and

\[
 s=P_0,qquad t=P_1,qquad Q_0=s+t.                    \tag{6.2}
\]

The residual-order table is

\[
\begin{array}{c|ccc}
 &i=0&i=4&i=2\\ \hline
P_0&0&0&3\\
P_1&0&0&4+11n\\
Q_0&2+11a&0&0.
\end{array}                                             \tag{6.3}
\]

Again all unmarked contributions are multiples of eleven.  The three local
orders are therefore congruent to

\[
                       (2,0,7)\pmod {11},               \tag{6.4}
\]

which are pairwise distinct.  The unique-minimum contradiction excludes
`B` and completes the proof of (1.4).

## 7. Theorem boundary

This packet closes exactly the root-supported multiplicity ansatz (1.1).
The next positive osculating branch must retain a nonconstant residual factor
`h(T)` and its five values and jets at the `r_j`; those data are absent here.
Nothing in this theorem supplies an all-curve degree bound or an all-trace
point obstruction.
