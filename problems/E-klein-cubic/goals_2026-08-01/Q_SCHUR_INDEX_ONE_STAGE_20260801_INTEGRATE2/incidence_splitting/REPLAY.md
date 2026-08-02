# Replay

From `goals_2026-08-01` run:

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/incidence_splitting/verify_splitting_logic.py
```

Expected marker:

```text
Q_SCHUR_INCIDENCE_SPLITTING_BOUNDARY_EXACT
```

The verifier checks the dimension and orbit arithmetic and the strict
nonclaim.  Integrality of the twisted-cubic incidence space and enumerativity
of its generic degree are cited theorem inputs.

For the degree-eleven `A5` rational-normal-quartic chart, run:

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  Q_SCHUR_DESCENT/parallel/incidence_splitting/verify_a5_rnc_chart.py
```

Expected terminal marker:

```text
A5_DEGREE11_RNC_STRICT_SEAL_OK
Q_SCHUR_A5_DEGREE11_RNC_INCIDENCE_EXACT
```
