# Exact Boolean support obstruction in covariant degree thirty-five

**Date:** 2026-08-08  
**Result:** `F55-CHAR5-PROGRESSION-DEGREE35-LANDING-EMPTY`  
**Headline:** `OPEN`

## 1. The finite target

For each of the sixteen two-Frobenius-residue progression families, write

\[
 f=x^{a_d}H^5+x^{b_{d,r}}K^5,
 \qquad d,r\in\mathbf F_5^*,
 \qquad \deg H=\deg K=5.                              \tag{1.1}
\]

Thus `deg(f)=35`.  The `C11` weights of `H,K` are forced, and their complete
monomial bases have dimensions eleven or twelve.  There are at most 24
coefficient variables.

The sibling packet proves emptiness through root degree four.  Root degree
five is therefore the next theorem-forced finite coefficient target; this is
not an arbitrary degree sweep.

## 2. Boolean necessity

Expand the complete identity

\[
                  K(T_f)=\sum_i(\rho^if)^2\rho^{i+1}f=0. \tag{2.1}
\]

For a geometric coefficient point, mark a Boolean variable true exactly
when that coefficient is nonzero.  Both the `H` block and the `K` block must
contain a true variable, because (1.1) is an exact-two-residue coordinate.

Every source-monomial coefficient in (2.1) is a cubic polynomial in the
coefficient variables.  If exactly one of its coefficient monomials is
active, that row cannot vanish: its scalar coefficient is nonzero in
`F5`, and a product of nonzero field elements is nonzero.  Hence every
landing support necessarily satisfies

\[
 \boxed{\text{each coefficient row has either zero or at least two active
 coefficient monomials.}}                              \tag{2.2}
\]

This condition ignores the harder question whether two or more active terms
actually cancel.  Therefore proving (2.2) unsatisfiable is a rigorous
landing obstruction.

## 3. Dependency-free exhaustive proof

`verify_support_unsat.py` independently reconstructs the root-degree-five
weight bases and all coefficient rows using integer tuples modulo five.  It
then converts every coefficient monomial to a bit mask, retaining repeated
masks: for example, `a^2*b` and `a*b^2` are distinct active monomials even
though their Boolean supports agree.

The exact recursive proof uses the following exhaustive rules.

1. If the current support has not met `H` or `K`, branch over every still
   possible variable in that block.
2. If a row has exactly one active monomial, some other possible monomial
   must become active.  Branch over the inclusion-minimal possible monomial
   supports and force all variables of one support true.
3. If a row has no active monomial and only one possible monomial, that
   monomial must remain inactive.  Branch over its missing variables and
   force one false.
4. A node with one forced active monomial and no possible companion is an
   exact contradiction.  Empty `H` or `K` is also a contradiction.
5. If none of the preceding rules applies, setting every unassigned variable
   false gives a valid support.  Such a node would be an explicit SAT
   witness; none occurs.

The branches in rules 1--3 cover every possible completion.  Memoization
only identifies repeated states and does not remove a branch.  Thus the
search is a proof DAG, not a heuristic SAT/MILP success flag.

The complete results are:

| `(d,r)` | dims `(H,K)` | rows / distinct rows | proof states |
|---|---:|---:|---:|
| `(1,1)` | `(12,12)` | `2660 / 529` | 5928 |
| `(1,2)` | `(12,12)` | `2340 / 465` | 8001 |
| `(1,3)` | `(12,11)` | `2355 / 467` | 1519 |
| `(1,4)` | `(12,11)` | `2520 / 500` | 1096 |
| `(2,1)` | `(11,12)` | `2335 / 461` | 2094 |
| `(2,2)` | `(11,11)` | `2565 / 506` | 292 |
| `(2,3)` | `(11,12)` | `2625 / 516` | 3007 |
| `(2,4)` | `(11,12)` | `2270 / 452` | 3350 |
| `(3,1)` | `(11,12)` | `2390 / 472` | 1370 |
| `(3,2)` | `(11,12)` | `2450 / 488` | 6076 |
| `(3,3)` | `(11,11)` | `2095 / 415` | 829 |
| `(3,4)` | `(11,11)` | `2415 / 473` | 599 |
| `(4,1)` | `(12,11)` | `2680 / 527` | 739 |
| `(4,2)` | `(12,12)` | `2335 / 464` | 4751 |
| `(4,3)` | `(12,11)` | `2215 / 441` | 633 |
| `(4,4)` | `(12,11)` | `2775 / 548` | 1283 |

All sixteen proof DAGs are unsatisfiable.  The sealed digest of their input
row digests and deterministic search records is

```text
26320813bd93445e535af7547fb9998d6f5f8cb966598b30e420f8f10f5d66f7
```

It follows that there is no exact-two-residue progression landing in
covariant degree thirty-five.

## 4. Strict scope

This closes one finite target and strengthens the sibling result from degree
thirty to degree thirty-five.  It supplies no all-degree cutoff.  A minimal
landing may use at least three Frobenius residues, and the two-residue branch
at root degree at least six remains open.  Therefore `ed_k(F55)=4` and the
Klein-cubic non-unirationality headline remain open.

```text
F55-CHAR5-PROGRESSION-DEGREE35-SUPPORT-UNSAT-EXACT
F55-CHAR5-PROGRESSION-DEGREE35-LANDING-EMPTY
F55-CHAR5-THREE-OR-MORE-RESIDUES-UNDECIDED
F55-QUESTION-OPEN
```

## 5. Replay

```sh
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/CHAR5_PROGRESSION_DEGREE35_SUPPORT/verify_support_unsat.py
```
