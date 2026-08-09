# Exact support obstruction in root degree six

**Date:** 2026-08-08  
**Result:** `F55-CHAR5-PROGRESSION-N6-SUPPORT-UNSAT-EXACT`  
**Scope:** the sixteen exact-two-residue progression families only

## Theorem

Over any field of characteristic five, no pair of nonzero root-degree-six
semi-invariants `H,K` in any of the sixteen progression families satisfies
the full Klein landing identity.  Hence there is no exact-two-residue
progression landing coordinate of covariant degree

\[
                         10+5\cdot6=40.
\]

## Certificate

The finite reduction is the same support lemma as in
`N5_SUPPORT_THEOREM.md`: in every vanished output coefficient row, the
number of active cubic coefficient monomials cannot equal one.

At root degree six the forced root-weight spaces have dimension nineteen,
except that weight zero has dimension twenty.  Thus a family has 38 or 39
Boolean coefficient variables.  The verifier reconstructs between 4,255
and 5,310 nonzero landing rows and exactly exhausts the support constraints
with no external solver.  The sixteen DPLL node counts are

```text
703, 703, 447, 1045,
223, 261, 237, 259,
377, 343, 2711, 333,
503, 385, 397, 209.
```

Their sum is 9,136.  Every family is UNSAT.  The complete replay took about
177 seconds on the audit machine; runtime is not part of the theorem.

## Consequence and boundary

Combining root degrees one through six gives the exact bounded statement

```text
F55-CHAR5-TWO-RESIDUE-EMPTY-THROUGH-40
```

There is still no analytic cutoff on the root degree.  Root degree at least
seven, all branches with at least three Frobenius residues, the full
characteristic-five dominance problem, and the characteristic-zero headline
remain open.
