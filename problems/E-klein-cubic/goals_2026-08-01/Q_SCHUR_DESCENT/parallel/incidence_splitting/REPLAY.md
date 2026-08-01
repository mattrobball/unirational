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
