# Replay: exact root-degree-five support obstruction

From `/Users/worker/unirational`, run

```sh
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/CHAR5_PROGRESSION_CLOSE/verify_n5_support_unsat.py
```

Every one of the sixteen rows must end in `STATUS UNSAT WITNESS None`, and
the final lines must be

```text
TOTAL_NODES 862
F55-CHAR5-PROGRESSION-N5-SUPPORT-UNSAT-EXACT
```

Verifier SHA-256:

```text
9506bd90610b49ddeccdd055d7855749b3825db3301f2e7632e385d796d7718c
```

The verifier imports only the Python standard library and reconstructs all
coefficient rows from the defining equation.  It does not consume stored
MILP output, stored support lists, CAS output, or a solver success flag.
