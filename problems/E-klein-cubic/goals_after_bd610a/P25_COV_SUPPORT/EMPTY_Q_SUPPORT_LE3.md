# Scoped empty locus: q-support at most three

Over the algebraic closure of `F_89`, the Stage-B and normalized Stage-C
necessary contraction incidences are empty on

```text
union_{|I|=3} P<span(q_i : i in I)> subset P^36_q.
```

Equivalently, neither stratum has a point whose q-coordinate support is at
most three in the installed basis.

Certificate: every one of the `7770` coordinate triples gives a
`412 x 75` matrix of rank 75, with an independently recomputed nonzero
`75 x 75` determinant.  The selected rows are genuine identities
`C(q)M2(q)=0`; `P3=C M1` and `P4=C M0` are rebuilt exactly.

This is not `PC25-DEGREE-EMPTY-SCOPED`.  It does not cover q-support at least
four, does not decide global Stage B or Stage C, does not empty the complete
degree-25 special fibre, and does not transfer any degree-wide statement to
characteristic zero.  Global status remains `PC-UNDECIDED`.
