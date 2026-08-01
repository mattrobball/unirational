T2-ROUTE-REFUTED

# Status

- Pinned state: `35fa8f59b6a1423cc89300aeaceefe91552be5ba`.
- Exact tracked commit consumed: `37d61c19a108781cf74af837e24810a9f7f7c3be`.
- Problem E headline: **OPEN**.
- No normalization, conductor, or new class-group theorem is claimed.

## Terminal decision

Goal T2 cannot reach its advertised negative headline for two independent
reasons.

1. The exact infinity divisor used by the conic packet gives an unramified
   ordered place of `K_proj/F` with `(e,f)=(1,1)`.  The genuine
   multiplicity-one target branch has a ramified ordered prime with
   `(e,f)=(2,1)`.  They cannot be the same ordered valuation, so the already
   proved residual index-three theorem does not identify the T2 target
   branch.
2. Even if T2.0--T2.3 constructed the target normalization and proved index
   three, proper specialization would show only that the auxiliary
   fixed-frame Pfaffian plane cubic has no `K_proj`-point.  The binding
   `FAIL-SCOPE` audit proves that a fixed-frame projector is not a common
   isotropic line for the five Klein forms and is not a point of the genuine
   generic Klein twist.

An exact smooth cubic-threefold counterexample independently shows that
index three of a coordinate plane cubic cannot formally imply pointlessness
of the ambient cubic.  Thus neither completing the target normalization nor
identifying abstract branch fields can repair the missing functorial arrow.

## Replay

```sh
/opt/homebrew/bin/python3 produce_t2_route_refutation.py
/opt/homebrew/bin/python3 verify_t2_route_refutation.py
```

Expected markers:

```text
T2_TARGET_BRANCH_ROUTE_REFUTATION_PRODUCER_SEALED
T2_TARGET_BRANCH_ROUTE_REFUTATION_VERIFIER_ACCEPT
```
