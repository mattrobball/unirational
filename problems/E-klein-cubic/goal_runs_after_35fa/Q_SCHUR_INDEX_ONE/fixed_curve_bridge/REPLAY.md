# Replay

Run from this packet directory:

```text
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_bridge_cases.py
```

Expected terminal marker:

```text
Q_SCHUR_FIXED_CURVE_BRIDGE_EXACT
```

The script checks the implication ledger and that the conditional cyclic
cubic length gate has not been promoted to an unconditional result.  It also
runs the copied independent period-lattice reconstruction and verifies that
the common fixed subgroup of the Klein intermediate Jacobian is trivial.
The mathematical proofs, including the dual-tree parity argument, are in
`THEOREM.md`.
