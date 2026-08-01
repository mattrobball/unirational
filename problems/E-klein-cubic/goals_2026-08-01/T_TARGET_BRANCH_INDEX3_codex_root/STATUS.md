T-ROUTE-REFUTED

# Status

- T0 subexit: `T-BRIDGE-BLOCKED`.
- Problem E headline: **OPEN**.
- Pinned mathematical baseline: `715faf441289e2589b9325311b6613ea0331bf88`.
- Exact tracked commit consumed: `80f24697dd8fcb1ee0e8fff86e3d8e38a9cfc09c`.
- Workspace: `T_TARGET_BRANCH_INDEX3_codex_root/`, isolated from sibling agents.

## Resolution

The branch computation concerns the full fixed-frame Pfaffian plane cubic
`C_fix`, a coordinate section of the auxiliary projector cubic.  Proper
specialization along the accepted residue-degree-one branch could prove
`C_fix(K_proj)=empty`, but the binding repository supplies no implication
from that statement to pointlessness of the genuine generic Klein twist.
The authoritative Pfaffian audit instead requires five simultaneous
Hermitian isotropy equations on a quaternionic line.

An exact counterexample confirms that the missing arrow is not a formal
principle: over `C((s))((t))`, the smooth plane cubic
`x^3+s*y^3+t*z^3=0` has index three, yet it is a coordinate plane section of
the smooth cubic threefold
`x^3+s*y^3+t*z^3+w^2*x+q^3=0`, which has the rational smooth point
`[0:0:0:1:0]`.

The work order requires T0 before computation and permits a precise bridge
gap/counterexample as a terminal route refutation.  T1--T3 therefore stop;
their normalization and class-group computations cannot repair the object
mismatch.  No claim about non-`G`-unirationality or essential dimension is
made.

## Replay

From this directory:

```sh
/opt/homebrew/bin/python3 produce_route_refutation.py
/opt/homebrew/bin/python3 verify_route_refutation.py
```

Expected terminal markers:

```text
T_TARGET_BRANCH_ROUTE_REFUTATION_PRODUCER_SEALED
T_TARGET_BRANCH_ROUTE_REFUTATION_VERIFIER_ACCEPT
```
