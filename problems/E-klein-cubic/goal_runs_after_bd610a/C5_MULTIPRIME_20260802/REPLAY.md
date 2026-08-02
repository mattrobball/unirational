# Replay

From the repository root:

```sh
cd goal_runs_after_bd610a/C5_MULTIPRIME_20260802
PYTHONDONTWRITEBYTECODE=1 python3 -u produce_multiprime_morita.py
PYTHONDONTWRITEBYTECODE=1 python3 -u verify_multiprime_morita.py
```

Expected terminal markers:

```text
C5-MORITA-MULTIPRIME-HOLDOUT-PASS
```

on both producer and verifier.

Runtime is on the order of a few minutes (four primes × group of order 660 ×
degree-12 Reynolds × 1935 factor walks).  Memory stays well under 8 GiB.
