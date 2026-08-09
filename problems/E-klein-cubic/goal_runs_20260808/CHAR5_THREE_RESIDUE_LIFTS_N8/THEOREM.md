# Fixed three-residue lifts through root degree eight

**Date:** 2026-08-08  
**Status:** `EXACT DPLL THROUGH n=7 / EXACT SOLVER REPLAY AT n=8`  
**Headline:** `OPEN`  
**Certificate caveat:** `NO DRAT/RUP PROOF FOR n=8`

Work over an algebraically closed field of characteristic five.  Put

\[
 W=(1,9,4,3,5),
 \qquad
 A=\{(4,0,4,1,1),(0,4,1,1,4),(0,0,3,4,3)\}.
\]

The three residue weights force fifth-root weights `(10,3,10)`.  For root
degree `n`, consider the complete fixed-pattern coordinate

\[
 f=x^{a_0}H_0^5+x^{a_1}H_1^5+x^{a_2}H_2^5,             \tag{1}
\]

where every `H_j` is nonzero, homogeneous of degree `n`, and has the forced
`C11` weight.  Thus `f` has ordinary degree `10+5n` and has **exactly** the
three Frobenius residues in `A`.

## Bounded result

There is no coordinate (1) satisfying

\[
 \sum_{i\in\mathbf F_5}(\rho^if)^2\rho^{i+1}f=0          \tag{2}
\]

for root degrees `0 <= n <= 8`.

- At `n=0,1`, at least one required root-weight space is zero, so the three
  residue blocks cannot all occur.
- At `n=2`, exact coefficient reconstruction contains an isolated cube for
  every one of the five coefficient variables (in five cyclic source rows).
- At `n=2,...,7`, the dependency-free verifier reconstructs every coefficient
  row over `F5` and exhausts the necessary Boolean support problem by exact
  semantic DPLL.
- At `n=8`, two independent multiplication models reconstruct the same full
  coefficient dictionary.  The induced grouped CNF is solved twice by pinned
  PicoSAT 0.6.6 and returns `UNSAT` both times.

The exact finite counts are:

| root degree | ordinary degree | block dimensions | coefficient variables | source rows | unique support rows |
|---:|---:|---:|---:|---:|---:|
| 2 | 20 | `(2,1,2)` | 5 | 320 | 35 |
| 3 | 25 | `(3,3,3)` | 9 | 1,105 | 182 |
| 4 | 30 | `(6,7,6)` | 19 | 4,155 | 798 |
| 5 | 35 | `(12,11,12)` | 35 | 10,595 | 2,093 |
| 6 | 40 | `(19,19,19)` | 57 | 20,825 | 4,148 |
| 7 | 45 | `(30,30,30)` | 90 | 37,070 | 7,394 |
| 8 | 50 | `(45,45,45)` | 135 | 60,515 | 12,085 |

For `n=8`, the canonical grouped CNF has

```text
135 coefficient-support variables
410175 conjunction variables
82232 grouped-OR auxiliary variables
492542 total variables
4163268 clauses
```

Its canonical clause-stream SHA-256 is

```text
f2e5180fdb315cb5705eba6ebd96e8b5b76e43a68d591d0fee885726c223fb83
```

## Why the Boolean obstruction is valid

At a geometric point, a selected coefficient variable is nonzero.  Hence a
coefficient monomial is active exactly when all variables in its Boolean mask
are selected.  If any source row has exactly one active coefficient monomial,
that nonzero term cannot sum to zero.  Every landing therefore gives a support
meeting all three residue blocks in which every row has active count zero or
at least two.  The finite searches prove that no such support exists.

Repeated masks in a row are retained: for example, `a^2*b` and `a*b^2` are
distinct coefficient monomials and count twice even though their Boolean masks
coincide.  The verifier never collapses these multiplicities.

## Exact status of the `n=8` computation

The arithmetic reconstruction, support rows, CNF equivalences, hashes, and
solver input are exact.  The pinned solver is deterministic and is replayed
from the final packet path after both unordered-`Sym^2` and literal ordered
coefficient expansions agree term by term.

However, this packet does **not** contain a DRAT, RUP, or independently checked
proof trace for the `n=8` `UNSAT` answer.  Consequently `n=8` is an exact
trusted-solver replay, not the same certificate grade as the dependency-free
DPLL exhaustion through `n=7`.  A stored solver status or hash alone is not
being promoted to a proof certificate.

## Strict scope and first unbounded gate

This packet treats only the single residue set `A`.  It neither classifies
other three-residue sets nor treats supports with four or more Frobenius
residues.  Even on this fixed branch, root degrees `n >= 9` remain open: new
root-weight monomials and coefficient rows appear, and no induction,
monotonicity, or finite-cutoff theorem propagates the bounded exclusions.

Thus this packet does not prove an all-degree characteristic-five theorem,
does not establish `ed(F55)=4`, and does not prove non-`PSL(2,11)`
unirationality of the Klein cubic.

```text
F55-CHAR5-FIXED-THREE-RESIDUE-N2-N7-SUPPORT-UNSAT-EXACT-DPLL
F55-CHAR5-FIXED-THREE-RESIDUE-N8-SUPPORT-UNSAT-SOLVER-REPLAY
CAVEAT_NO_DRAT_OR_RUP_PROOF
HEADLINE_OPEN_NO_ALL_DEGREE_CUTOFF
```
