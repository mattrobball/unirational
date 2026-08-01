T-ROUTE-REFUTED

# Status

- T0 subexit: `T-BRIDGE-BLOCKED`.
- Problem E headline: **OPEN**.
- Pinned mathematical baseline: `715faf441289e2589b9325311b6613ea0331bf88`.
- Exact repository commit consumed: `e1fc474a448db9d93df13967a4cef5f9918ff443`.
- Output state: uncommitted, isolated worktree packet.

## Requirement ledger

| Requirement | Result |
|---|---|
| Identify `F`, `K_proj`, and the branch field | passed |
| Check `(e,f)=(2,1)` and `k(R)=k(D)` | passed from the hash-bound hostile branch certificate |
| Check normalization/proper specialization step | valid only for `C_fix` |
| Check `C_fix(K_proj)=empty => X_gen(K_proj)=empty` | refuted as an available implication |
| Supply a precise counterexample/gap | passed; see `THEOREM.md` |
| T1--T3 computation | stopped by the mandatory T0 rule |
| T4 negative headline | unavailable; not claimed |

The exact route-destroying theorem is that index three for the auxiliary
fixed-frame coordinate-plane curve cannot imply pointlessness of the ambient
generic Klein cubic.  The binding bridge audit independently identifies the
same missing arrow, and the supplied smooth cubic counterexample disproves
the formal coordinate-section inference.

## Replay

From this directory run:

```text
python3 produce_bridge_scope.py
python3 verify_bridge_scope.py
python3 produce_seal.py
python3 verify_seal.py
```

No T1--T3 normalization or class-group claim is made or needed for this
route-refutation exit.
