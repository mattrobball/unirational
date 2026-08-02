# PC.0 independent rank replication

Status: `PC0-INDEPENDENT-RANK-REPLICATION-PASS` over `F_89`.

## Cubic ledger

The immutable finite-module inputs rebuild the residual cubic space `V0` and
the missing monic-tail block `W`:

| space | rows | exact rank |
|---|---:|---:|
| `V0` | 690 | 690 |
| `W` | 56 | 56 |
| `V0+W` | 746 | 746 |

Thus `V0 intersect W=0`.  This independently repairs the old incomplete
690-row presentation at its cubic input boundary.

## Multiplication map

For

```text
mu : S1 tensor (V0+W) -> S4
```

the domain has dimension `27602`, the codomain has dimension `91390`, and

```text
rank(mu)=27583,
dim ker(mu)=19.
```

The producer selects 30,000 codomain coefficients with seed `2026080125` and
exhibits rank `27583`.  It then stores a 19-vector kernel basis and substitutes
it coefficient-by-coefficient into all 91,390 rows of the complete map; every
coefficient vanishes.  The matching lower and upper bounds give the exact
full rank.  Both projections of the kernel to `S1 tensor V0` and
`S1 tensor W` have rank 19, while the kernel meets either summand trivially.

The independent verifier reconstructs the map and uses a separate
balanced-double rank path plus full all-row kernel substitution.  It terminates
with `PASS_INDEPENDENT_PC0_REPLAY`.

## Transition and commutator subspaces

All `6*690=4140` transition rows have formal/image rank `2072`.  Their
intersection with `S1 V0` has dimension 19, so their image modulo `S1 V0` has
dimension `2053`.  Every individual row is outside `S1 V0`.

All `15*21=315` quadratic-basis commutator defects have rank `210`; none is in
`S1 V0`.  Their span adds no direction to the transition span.  This is a
subspace calculation, not a row-by-row nonmembership count.  In the character
ledger, dimension 315 refers only to the formal row-label source; the actual
commutator image is the 210-dimensional space.

## Durable certificates

- `pc0_rank_certificate.json` records dimensions, hashes, and theorem scope.
- `pc0_selected_degree4_rows.npz` records the deterministic coefficient set.
- `pc0_multiplication_kernel.npz` records the 19-dimensional exact kernel.
- `verify_pc0_result.json` is the independent replay result.

This proves no transition stabilization, no projective-support statement, no
characteristic-zero rank theorem, and no headline covariant.
