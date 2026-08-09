# Root-degree-eight support preflight

**Date:** 2026-08-08  
**Status:** `UNSAT_PREFLIGHT_ONLY / NO THEOREM`

`preflight_cadical.py` reconstructed the characteristic-five landing rows at
root degree eight and encoded the necessary Boolean support condition: both
the H and K coefficient blocks are nonempty, and no landing row has exactly
one active coefficient monomial.  Distinct coefficient monomials having the
same squarefree support retain their multiplicity.

CaDiCaL 1.9.5, reached through the development installation of python-sat,
reported UNSAT for all sixteen `(d,r)` cases.  Every case has 45 H variables,
45 K variables, 121,575 support-AND auxiliaries, and between 11,810 and 14,260
nonzero landing rows.  The generated CNFs had between 2,324,747 and 2,324,837
clauses.

| `(d,r)` | rows | clauses | preflight |
|---|---:|---:|---|
| `(1,1)` | 14,040 | 2,324,817 | UNSAT |
| `(1,2)` | 12,890 | 2,324,747 | UNSAT |
| `(1,3)` | 12,805 | 2,324,807 | UNSAT |
| `(1,4)` | 14,080 | 2,324,817 | UNSAT |
| `(2,1)` | 11,865 | 2,324,817 | UNSAT |
| `(2,2)` | 13,745 | 2,324,837 | UNSAT |
| `(2,3)` | 13,970 | 2,324,787 | UNSAT |
| `(2,4)` | 11,810 | 2,324,777 | UNSAT |
| `(3,1)` | 12,745 | 2,324,807 | UNSAT |
| `(3,2)` | 12,930 | 2,324,797 | UNSAT |
| `(3,3)` | 12,625 | 2,324,827 | UNSAT |
| `(3,4)` | 12,645 | 2,324,817 | UNSAT |
| `(4,1)` | 14,260 | 2,324,827 | UNSAT |
| `(4,2)` | 12,725 | 2,324,797 | UNSAT |
| `(4,3)` | 12,770 | 2,324,757 | UNSAT |
| `(4,4)` | 13,905 | 2,324,797 | UNSAT |

No DRAT/LRAT proof or static semantic certificate was generated, by design.
Therefore these solver answers do **not** extend the exact exclusion through
covariant degree 50.  The checked bound remains covariant degree 45, and no
all-degree cutoff or Klein-cubic headline follows from this preflight.

If a future run returns SAT, the script reconstructs every row again and
directly checks the reported coefficient mask before printing it.  That path
was not reached in this run.
