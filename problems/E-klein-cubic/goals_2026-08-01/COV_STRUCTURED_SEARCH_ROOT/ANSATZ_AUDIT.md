# Structured ansatz and landing audit

## Normal-cone residual families

The degree selection theorem chooses the first unresolved representatives
of the three required residual classes: `(25,3,7)`, `(31,5,1)`, and
`(35,5,5)`.  Rather than lifting a few local generators, the global-jet
calculation begins with the complete characteristic-zero self-covariant
basis in each degree.  Its selected symbolic-order kernel is zero.  Hence:

- the generic `e>=7` formal family has no degree-25 global lift of plane
  order three;
- the unique `e=1` all-swap family has no degree-31 global lift of plane
  order five;
- the three-ledger `e=5` family has no degree-35 global lift of plane order
  five.

This conclusion includes every Reynolds lift of the residual binary
generators and every Koszul, syzygy, orbit-sum, or formal-state deformation
inside those global coefficient modules.  One global coefficient vector is
used throughout; no local patching occurs.

## Invariant/covariant frame family

Independently, `produce_sparse_frame.py` exhausts the primitive triples

```text
p = a M_i V_i + b M_j V_j + c M_k V_k,
```

where `V=(x,C,D,E,K)` has degrees `(1,4,5,6,7)` and each `M_i` is a monomial
in primary invariants of degrees `(3,5,6,8,11)`.  Tuples with a common
displayed primary factor are removed.

| degree | primitive triples | rank 10 | rank 9, non-Veronese | survivors |
|---:|---:|---:|---:|---:|
| 25 | 2,988 | 2,912 | 76 | 0 |
| 31 | 16,013 | 15,825 | 188 | 0 |
| 35 | 32,340 | 32,125 | 215 | 0 |

The table holds at both `p=89` and the independent holdout `p=199`.  Rank
ten supplies a nonzero polar-evaluation minor.  In rank nine, the unique
kernel line violates a binomial of the ternary degree-three Veronese ideal,
so it contains no coefficient cube even over the algebraic closure.  The
independent verifier expands the Klein cubic directly from vector values,
instead of importing the producer's polar polynomials.

This second theorem has only the displayed sparse-family scope.  It does not
empty the complete `m=1` spaces.

## Landing/elimination order

For the selected normal-cone pairs, exact linear elimination ends with zero
parameters, so bilinear, determinantal, homotopy, reconstruction, and final
landing-substitution stages are vacuous.  For the sparse frame family, the
polar-rank/Veronese certificates exactly decide the family before a modular
candidate exists.  No nonzero sample residual is used as an obstruction.

There is therefore no candidate for COV3.  `BR-COV-POS` is not invoked.
