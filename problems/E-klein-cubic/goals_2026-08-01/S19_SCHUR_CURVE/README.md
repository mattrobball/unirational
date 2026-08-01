# S19 scoped-emptiness packet

This packet resolves the literal exact target in `GOAL_S19_SCHUR_CURVE.md`.
It proves that target empty because it simultaneously contains the curve in
the cubic and requires a proper zero-dimensional intersection with that same
cubic.

The result is deliberately scoped.  The coherent ambient-curve target remains
undecided, as does the Klein-cubic headline.

## Files

- `STATUS.md`: binary verdict and theorem boundary;
- `BRIDGE.md`: complete bridge ledger and the binding incompatibility;
- `HILBERT_COMPONENTS.md`: functorial emptiness proof for both Rao branches;
- `emptiness_certificate.json`: machine-readable proof payload;
- `produce_certificate.py`: deterministic producer/checker for the payload;
- `verify.py`: independent verifier using the authoritative source text,
  ideal absorption, branch enumeration, and content hashes;
- `SEAL.json`: deterministic hashes of all deliverables other than itself.

## Replay

```text
cd problems/E-klein-cubic/goals_2026-08-01/S19_SCHUR_CURVE
/usr/bin/python3 produce_certificate.py --check
/usr/bin/python3 verify.py
```

No nonstandard Python package and no Magma installation is required.
