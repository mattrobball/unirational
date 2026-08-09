# Characteristic-five progression landing through degree forty

**Date:** 2026-08-08  
**Result:** `F55-CHAR5-TWO-RESIDUE-EMPTY-THROUGH-40`  
**Headline:** `F55-QUESTION-OPEN`

## 1. Complete bounded target

Work over an algebraically closed field of characteristic five.  The exact
two-Frobenius-residue classification in
`TRACE_POSITIVE/CHAR5_MINIMAL_REDUCTION.md` says that every least-degree
two-residue Klein landing must belong to one of the sixteen progression
families

\[
 a_j=\langle dj\rangle_5,
 \qquad b_j=\langle dj+r\rangle_5,
 \qquad d,r\in\mathbf F_5^*.
\]

The ordinary graded normal form is

\[
 f=x^aH^5+x^bK^5,
 \qquad \deg H=\deg K=n,
 \qquad \deg f=10+5n,
\]

with the two `C11` weights of `H,K` forced by `(d,r)`.  For fixed `n`, the
relevant weight spaces are finite.  The verifier constructs their complete
monomial bases and expands the full identity

\[
 \sum_{i=0}^4(\rho^if)^2\rho^{i+1}f=0.
\]

The fifth powers of the scalar coefficients are renamed as independent
variables.  This loses no points over the algebraic closure because
Frobenius is bijective there.

For every `(d,r)` and every pair consisting of a nonzero `H` coefficient
and a nonzero `K` coefficient, the verifier fixes the first coefficient to
one by the common projective scaling and inverts the second with an auxiliary
variable.  These charts cover exactly the open `H != 0`, `K != 0`.  Singular
computes a unit ideal on every chart for

\[
                         n=1,2,3,4.
\]

Thus there is no exact-two-residue progression landing of covariant degree

\[
                         15,20,25,30.
\]

Together with the analytic degree floor, the relevant new statement is

\[
 \boxed{\text{a least-degree characteristic-five landing either uses at
 least three Frobenius residues, or has degree at least }35.}
\]

The largest coefficient calculation in this first stage has root-weight
spaces of dimensions at most seven, at most fourteen projective coefficient
variables before charting, and at most 1290 nonzero landing rows.  It is a
finite coefficient calculation, not a monomial-support or degree sweep.

## 2. Exact support exhaustion at degree 35

At `n=5`, the root-weight spaces have dimensions eleven or twelve, hence at
most 24 coefficient variables.  On a fixed coefficient support, a landing
row with exactly one active coefficient monomial is impossible.  The
dependency-free verifier `verify_support_degree35.py` reconstructs every
coefficient row, checks all of the at most `2^24` supports in each family,
requires both residue components to be nonzero, and finds a singleton row
on every support.  Thus degree 35 is empty before coefficient solving.

An independent exact DPLL implementation in
`../CHAR5_PROGRESSION_CLOSE/verify_n5_support_unsat.py` reaches the same
conclusion after comparing the reconstructed rows term for term.

At root degree `n=6`, the same exact DPLL has 19 or 20 variables in each
root-weight space and proves all sixteen support systems UNSAT in 9136 total
branch nodes.  The fixed statement and replay are
`../CHAR5_PROGRESSION_CLOSE/N6_SUPPORT_THEOREM.md` and
`../CHAR5_PROGRESSION_CLOSE/verify_n5_support_unsat.py --degree 6`.

Consequently the boxed statement strengthens to

\[
 \boxed{\text{a least-degree characteristic-five landing either uses at
 least three Frobenius residues, or has degree at least }45.}
\]

The calculation gives no bound beyond `n=6`, and a minimal landing could use
three or more Frobenius residues.  Hence this theorem does not establish
all-degree characteristic-five dominance, `ed(F55)=4`, or the
characteristic-zero Klein-cubic headline.

```text
F55-CHAR5-TWO-RESIDUE-EMPTY-THROUGH-40
F55-CHAR5-DEGREE45-UNDECIDED
F55-CHAR5-THREE-OR-MORE-RESIDUES-UNDECIDED
F55-QUESTION-OPEN
```
