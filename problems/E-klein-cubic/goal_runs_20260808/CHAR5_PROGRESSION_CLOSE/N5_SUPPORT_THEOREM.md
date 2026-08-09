# Exact support obstruction in root degree five

**Date:** 2026-08-08  
**Result:** `F55-CHAR5-PROGRESSION-N5-SUPPORT-UNSAT-EXACT`  
**Scope:** the sixteen exact-two-residue progression families only

## Theorem

Over any field of characteristic five, there is no nonzero pair of
root-degree-five semi-invariants `H,K` in any of the sixteen progression
families

\[
 f=x^{a_d}H^5+x^{b_{d,r}}K^5,
 \qquad d,r\in\mathbf F_5^*,
\]

for which the full Klein landing identity

\[
                 \sum_i(\rho^if)^2\rho^{i+1}f=0
\]

holds.  Equivalently, the progression branch has no landing coordinate of
covariant degree `10+5*5=35`.

## Exact finite reduction

Fix `(d,r)`.  The forced degree-five `C11` weight spaces have dimensions
between eleven and twelve.  Expand every coefficient row of the landing
identity over `F5`.  For a proposed coefficient point, mark a coefficient
variable active exactly when it is nonzero.  A cubic coefficient monomial is
active exactly when every variable in its support is active.

If a coefficient row vanishes, the number of its active coefficient
monomials cannot equal one: a single surviving term is a nonzero scalar
times a product of nonzero field elements.  Thus every landing point would
give a Boolean support satisfying all three conditions:

1. at least one `H` variable is active;
2. at least one `K` variable is active;
3. every landing row has either zero or at least two active cubic monomials.

These are necessary conditions over every characteristic-five field; no
genericity or algebraic-closure assumption enters this reduction.

`verify_n5_support_unsat.py` reconstructs the complete monomial bases and
landing rows, then exhausts the Boolean condition by a dependency-free DPLL
search.  Its propagation rules are direct logical consequences of condition
3:

- with one already-active term, some other possible term must become active;
- with no active terms and only one possible term, that term must be made
  inactive;
- the two component nonemptiness clauses are propagated in the usual way.

All remaining Boolean variables are exhaustively branched.  The complete
sixteen-family tree has only 862 visited nodes and is UNSAT in every family.

## Consequence and boundary

Together with the independently checked root degrees one through four, this
proves

```text
F55-CHAR5-TWO-RESIDUE-EMPTY-THROUGH-35
```

It supplies no degree cutoff.  Exact-two-residue progression landings at
root degree at least six, landings with at least three Frobenius residues,
the all-degree characteristic-five dominance theorem, and the
characteristic-zero headline remain open.

