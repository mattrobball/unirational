# Replay

Run from this directory:

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify.py
```

The replay hashes every source used by the exact A5 calculation, reruns the
characteristic-zero covariant landing check, independently reconstructs the
two maximal \(A_5\) classes in the exact group model, and finishes with:

```text
PACKET_SEAL_OK files=4
EXACT_A5_EQUIVARIANT_LANDING_REPLAY_OK
FULL_GROUP_A5_INDEX11_MAXIMALITY_REPLAY_OK
A5_WEAK_VERSALITY_BRIDGE_AUDIT_OK
Q_SCHUR_EFFECTIVE_DEGREE11_ZERO_CYCLE_VERIFIED
```
