# Replay

From `problems/E-klein-cubic` run:

```bash
python3 goal_runs_20260808/DELTA1_EQUIVARIANT_DIAGONAL_OBSTRUCTION_AUDIT/verify.py
```

Expected terminal marker:

```text
DELTA1-EQUIVARIANT-DIAGONAL-FINITE-AUDIT-OK
```

The replay checks the Sylow indices and Bezout identity independently and
then verifies the exact fixed-locus, diagonal, Sylow-detection, and Burnside
claims against the consumed packets.  It performs no bounded covariant or
cycle enumeration.
