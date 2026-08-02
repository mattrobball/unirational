# C6 replay (including residual)

From `problems/E-klein-cubic`:

```sh
# sealed model producer (C6.0–C6.1; do not need to re-run if artifacts present)
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/produce.py

# residual exact point search
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/produce_residual.py

# independent verifiers (must not import produce*.py for decisive claims)
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/verify_matrix.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/verify_model.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/verify_point.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/verify_residual.py

# seal
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/make_seal.py
```

## Expected markers

```text
C6_PRODUCE_OK                 # if produce.py re-run
C6_RESIDUAL_PRODUCE_OK
C6_MATRIX_VERIFY_OK
C6_MODEL_VERIFY_OK
C6_POINT_VERIFY_OK
C6_RESIDUAL_VERIFY_OK
C6_SEAL_OK
```

## Primary STATUS line

```text
C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS
```
