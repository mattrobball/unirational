# Replay

Run from `goals_2026-08-01`:

```text
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 \
  Q_SCHUR_DESCENT/parallel/fixed_curve_bridge/verify_bridge_cases.py
```

Expected terminal marker:

```text
Q_SCHUR_FIXED_CURVE_BRIDGE_EXACT
```

The script checks the implication ledger and that the conditional cyclic
cubic length gate has not been promoted to an unconditional result.  The
mathematical proofs, including the dual-tree parity argument, are in
`THEOREM.md`.
