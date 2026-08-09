# Three-Frobenius-residue boundary in characteristic five

**Date:** 2026-08-08  
**Status:** `EXACT NO-SINGLETON COUNTERPATTERN / ONE COMPLETE DEGREE-20 LIFT EMPTY`  
**Headline:** `OPEN`

Let `k` be algebraically closed of characteristic five.  Use

\[
 W=(1,9,4,3,5),\qquad \rho(e)_j=e_{j-1},
\]

and write a weight-one coordinate as

\[
 f=\sum_{a\in A}x^a h_a^5,
 \qquad A\subset\{0,1,2,3,4\}^5.
\]

This packet decides two finite questions left immediately beyond the exact
two-residue classification in `TRACE_POSITIVE/CHAR5_MINIMAL_REDUCTION.md`.

## 1. A genuine three-residue no-singleton pattern

Put

\[
 A=\{(4,0,4,1,1),(0,4,1,1,4),(0,0,3,4,3)\}.          \tag{1.1}
\]

All three vectors have ordinary degree ten.  Expand the five terms

\[
 (\rho^if)^2\rho^{i+1}f,
 \qquad i\in\mathbf F_5,
\]

only at the level of Frobenius residues.  There are exactly

\[
 5\binom{3+1}{2}3=90                                  \tag{1.2}
\]

symbolic cubic occurrences.  They occupy 25 residue buckets, with exact
multiplicity distribution

\[
 \begin{array}{c|rrrr}
 \text{bucket multiplicity}&2&3&4&6\\ \hline
 \text{number of buckets}&5&10&5&5.
 \end{array}                                           \tag{1.3}
\]

In particular there is no singleton bucket.  Thus the singleton argument
which gives the complete two-residue progression classification does **not**
reduce a minimal landing coordinate with three residue components to the
two-residue branch.  This is an exact counterexample to that proposed
extension, not a landing covariant.

## 2. The complete first ordinary lift of this pattern

The `C11` weights of the three residues in (1.1) are `(6,8,6)`.  Since
`5^(-1)=9 mod 11`, their fifth roots must have weights

\[
                         (10,3,10).                    \tag{2.1}
\]

In ordinary degree two the weight-ten space has basis

\[
                         x_4^2,\ x_0x_1,
\]

and the weight-three space has basis `x_1x_4`.  Consequently the complete
degree-20 family with precisely the three residue components (1.1) is

\[
\begin{split}
 f={}&a x^{(4,0,4,1,11)}+b x^{(9,5,4,1,1)}
       +c x^{(0,9,1,1,9)}\\
    &+d x^{(0,0,3,4,13)}+e x^{(5,5,3,4,3)}.            \tag{2.2}
\end{split}
\]

Every displayed exponent has degree 20 and `C11` weight one.  Exact
coefficient expansion of

\[
 K(T_f)=\sum_i(\rho^if)^2\rho^{i+1}f                 \tag{2.3}
\]

gives 320 nonzero source-monomial equations and 52 distinct cubic
coefficient equations.  Among them are the five isolated equations

\[
                         a^3=b^3=c^3=d^3=e^3=0.        \tag{2.4}
\]

Therefore the affine landing scheme of (2.2) is supported only at the
origin, and its projectivization is empty.  This proof needs neither a
solver nor a stored success flag: the verifier reconstructs the full
coefficient dictionary and locates five independent source monomials for
each pure cube.

## 3. An all-degree prime-intersection gate

Write `f_i=rho^i(f)`.  Landing gives the five exact ideal consequences

\[
             f_{i+3}^{,2}f_{i+4}\in(f_i,f_{i+2}),
             \qquad i\in\mathbf F_5.                  \tag{3.1}
\]

Indeed, modulo `(f_i,f_(i+2))`, the other four summands of the Klein
equation vanish and the displayed summand is the only survivor.

### Proposition 3.1

For a nonzero homogeneous weight-one `f` satisfying `K(T_f)=0`, none of
the five ideals

\[
                         (f_i,f_{i+2})                  \tag{3.2}
\]

is prime.

If one were prime, (3.1) would put either `f_(i+3)` or `f_(i+4)` in it.
All five forms have the same degree, so homogeneous ideal membership would
write that form as a constant linear combination of `f_i,f_(i+2)`.  This is
impossible: the three forms have distinct `C11` weights, and `C11` is
semisimple in characteristic five.

Equivalently, every hypothetical landing forces each nonadjacent complete
intersection to be reducible or nonreduced (with the usual interpretation
when the two forms have a common factor).  This is degree-independent, but
it is not sufficient.  For the exact weight-one monomial

\[
                         f=x_0^3x_1,                    \tag{3.3}
\]

the five cyclic coordinates have gcd one and every ideal in (3.2) is
nonprime.  For example, in `(x_0^3x_1,x_2^3x_3)` the product
`x_0 * x_0^2x_1` lies in the ideal while neither factor does.  Nevertheless
the cyclic exponent matrix of (3.3) has determinant `244`, so its covariant
is dominant; its five Klein summands have distinct exponent vectors and do
not cancel.  Thus nonprimality alone cannot close the all-degree argument.

## 4. Strict scope

The conclusions point in different methodological directions and must
not be merged:

1. Equation (1.3) proves that Frobenius-residue singleton separation stops
   already at three residue classes.
2. Equation (2.4) excludes the complete first ordinary lift of this **one**
   three-residue pattern.
3. Proposition 3.1 gives a genuine all-degree necessary condition, while
   (3.3) proves that condition is far from sufficient.

The packet does not classify all three-residue patterns, does not bound the
number of Frobenius residues in a minimal coordinate, and does not give a
degree cutoff.  Higher lifts of (1.1), other three-residue patterns, and all
supports of size at least four remain outside its scope.  It proves neither
`ed_k(F55)=4` nor non-unirationality of the Klein cubic.

```text
F55-CHAR5-THREE-RESIDUE-NO-SINGLETON-EXACT
F55-CHAR5-THREE-RESIDUE-DEGREE20-LIFT-EMPTY
F55-CHAR5-NONADJACENT-PRIME-INTERSECTION-GATE
F55-CHAR5-NONPRIME-GATE-ALONE-REFUTED
F55-CHAR5-ARBITRARY-RESIDUE-SUPPORT-OPEN
```

## 5. Replay

Run

```sh
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/CHAR5_THREE_RESIDUE_BOUNDARY/verify.py
```
