# Replay and audit scope

Run from `problems/E-klein-cubic/goal_runs_20260808/SCHUR_CONIC_CURVES`:

```text
python3 audit.py
```

Expected output:

```text
SCHUR-CONIC-AUDIT PASS
degree 2: [(1, 1)]
degree 4: [(1, 3), (2, 2)]
degree 6: [(1, 5), (3, 3)]
degree 8: [(1, 7), (3, 5), (4, 4)]
```

The script is a consistency audit only.  It checks packet markers, cited
local inputs, and the elementary all-degree splitting-type rule.  The
algebraic-geometric proofs are the hand proofs in `THEOREM.md`; the script
is not represented as a proof of them.
