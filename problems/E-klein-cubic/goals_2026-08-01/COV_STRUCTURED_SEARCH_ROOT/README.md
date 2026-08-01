# COV structured positive search — isolated run

This directory is the only write target for this worker.  The goal packet's
historical output contract names `problems/E-klein-cubic/goal_runs/`, but the
current user instruction and sandbox require a new folder *here*, under
`goals_2026-08-01/`.  No parent certificate or narrative file is modified.

## Binding theorem boundary

The headline target is an explicit primitive homogeneous
`PSL(2,11)`-equivariant map `p: W -> W`, of degree at least 25, with
`F(p)=0`, together with an exact rank-four Jacobian witness.  Nothing weaker
is a positive solution.

The first representatives of the three residual classes required by the
goal are:

| degree | residual class | reason selected |
|---:|---|---|
| 25 | `e >= 7` | first unrestricted degree and existing strict-space route |
| 31 | `e = 1` | first unresolved `d=6m+1` representative above 24 |
| 35 | `e = 5` | first unresolved `d=6m+5` representative above 24 |

The first exact search packet is the exhaustive **primitive three-sparse
primary-monomial frame family**.  Write `V=(x,C,D,E,K)`, of degrees
`(1,4,5,6,7)`, and let the primary invariants have degrees `(3,5,6,8,11)`.
For every selected degree `d`, every three-element subset of `V`, and every
choice of one primary-invariant monomial `M_i` of degree `d-deg(V_i)`, it
tests

```text
p = a M_i V_i + b M_j V_j + c M_k V_k.
```

Tuples with a displayed common primary monomial factor are removed before
testing.  For every remaining tuple, the producer computes the exact polar
map modulo 89.  Rank ten gives immediate emptiness.  In the genuine
rank-nine cases it computes the unique kernel line and exhibits a violated
binomial of the degree-three ternary Veronese ideal, proving that the line
contains no pure cube and hence no coefficient point even over the algebraic
closure.  Prime 199 is a holdout.  The independent verifier reconstructs
`F(p)` directly from the scaled vector values rather than reading the
producer's polar-coefficient expansion.

This is a finite structured ansatz theorem.  It is not the full degree-25,
31, or 35 strict covariant module, and emptiness here is not an all-degree or
headline-negative theorem.

## Complete selected residual-family result

The exact Reynolds bases in degrees 25, 31, and 35 have dimensions 189, 410,
and 637.  Direct global normal Taylor maps, independently reconstructed at
`p=67` and `p=89`, give

```text
d=25: 189 -> 59  -> 3   -> 0
d=31: 410 -> 198 -> 43  -> 0
d=35: 637 -> 361 -> 128 -> 0.
```

Full rank at the good holdout prime 89 proves characteristic-zero
injectivity.  Thus the selected `(d,m,e)` pairs `(25,3,7)`, `(31,5,1)`, and
`(35,5,5)` have zero global coefficient module.  See
`STRUCTURAL_EMPTY_THEOREM.md` and `STATUS.md`.

The exit is scoped: lower plane order `m=1` remains live in all three
degrees.  No degree-wide or headline-negative theorem is claimed.

## Replay

From this directory:

```bash
/opt/homebrew/bin/python3 -u produce_sparse_frame.py
/opt/homebrew/bin/python3 -u verify_sparse_frame.py
/opt/homebrew/bin/python3 -u verify_all.py
```
