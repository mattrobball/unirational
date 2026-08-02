# C6 replay (including residual + Morita descent + positive-degree)

From `problems/E-klein-cubic`:

```sh
# sealed model producer (C6.0–C6.1; do not need to re-run if artifacts present)
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/produce.py

# residual exact point search
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/produce_residual.py

# Morita / K_proj descent of the 12 split lines
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/phase_morita_descent/produce_descent.py

# positive-degree / rational-function / Morita-linear residual
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/phase_positive_degree/produce_positive.py

# independent verifiers (must not import produce*.py for decisive claims)
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/verify_matrix.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/verify_model.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/verify_point.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/verify_residual.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/phase_morita_descent/verify_descent.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/phase_positive_degree/verify_positive.py

# seal
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/make_seal.py
```

## Expected markers

```text
C6_PRODUCE_OK                 # if produce.py re-run
C6_RESIDUAL_PRODUCE_OK
C6_MORITA_DESCENT_PRODUCE_OK
C6_POSITIVE_DEGREE_PRODUCE_OK
C6_MATRIX_VERIFY_OK
C6_MODEL_VERIFY_OK
C6_POINT_VERIFY_OK
C6_RESIDUAL_VERIFY_OK
C6_MORITA_DESCENT_VERIFY_OK
C6_MORITA_DESCENT_OBSTRUCTION_CONFIRMED
C6_POSITIVE_DEGREE_VERIFY_OK
C6_POSITIVE_DEGREE_RESIDUAL_CONFIRMED
C6_SEAL_OK
```

## Primary STATUS line

```text
C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS
```

## Residual markers

```text
C6-MORITA-DESCENT-OBSTRUCTION
C6-POSITIVE-DEGREE-RESIDUAL
```
