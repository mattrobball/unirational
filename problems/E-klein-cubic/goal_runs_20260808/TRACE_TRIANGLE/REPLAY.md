# Replay

From `/Users/worker/unirational/problems/E-klein-cubic` run:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/TRACE_TRIANGLE/classify_collision_arrangements.py
```

The final lines must include:

```text
RANK1_COVERING_SPACES 0
RANK2_COVERING_SPACES 61
COEFFICIENT_TORUS_VIABLE 1
Q_LINEAR_TRIANGLE_RANK 0
F55-TRACE-THREE-TERM-ALL-EXPONENT-EXCLUSION-OK
```

The replay is exact over `Q(zeta_5)` and uses only univariate gcds over `Q`
for coefficient compatibility.  It contains no bounded exponent search,
modular screen, random trial, timeout, or solver-silence inference.
