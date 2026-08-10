# Replay: ordinary graded progression boundary

Run from `/Users/worker/unirational`:

```sh
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/TRACE_POSITIVE/verify_char5_graded_progression.py
```

Exact output:

```text
FAMILY_COUNT=16
ALL_PROGRESSION_LANDINGS_DEGREE_AT_LEAST=20
FAMILIES_DEGREE_AT_LEAST_25=(2,2),(3,3),(4,3)
COORDINATE_VALUATION_COUNTERPROFILES=16
F55-CHAR5-GRADED-PROGRESSION-BOUNDARY-OK
F55-CHAR5-PROGRESSION-ALL-DEGREE-OPEN
F55-QUESTION-OPEN
```

The verifier checks only the analytically finite residue/weight data and the
sixteen stored coordinate-valuation profiles.  It performs no polynomial
degree scan, support scan, coefficient search, or finite-field search.
