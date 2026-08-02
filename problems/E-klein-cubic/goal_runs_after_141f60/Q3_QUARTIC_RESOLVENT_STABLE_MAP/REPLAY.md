# Q3 replay

From `problems/E-klein-cubic`:

```sh
# producer
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/Q3_QUARTIC_RESOLVENT_STABLE_MAP/produce.py

# independent verifiers (must not import produce.py)
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/Q3_QUARTIC_RESOLVENT_STABLE_MAP/verify_monodromy.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/Q3_QUARTIC_RESOLVENT_STABLE_MAP/verify_stable_map.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/Q3_QUARTIC_RESOLVENT_STABLE_MAP/verify_point.py

# seal
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/Q3_QUARTIC_RESOLVENT_STABLE_MAP/make_seal.py
```

## Expected markers

```text
Q3_PRODUCE_OK
Q3_MONODROMY_VERIFY_OK
Q3_STABLE_MAP_VERIFY_OK
Q3_POINT_VERIFY_OK
Q3_SEAL_OK
```

## Primary STATUS line

```text
Q3-SCHUR-MONODROMY-PASS
```
