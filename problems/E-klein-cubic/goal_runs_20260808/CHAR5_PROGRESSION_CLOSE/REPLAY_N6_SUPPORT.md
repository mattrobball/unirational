# Replay: exact root-degree-six support obstruction

From `/Users/worker/unirational`, run

```sh
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/CHAR5_PROGRESSION_CLOSE/verify_n5_support_unsat.py \
  --degree 6
```

Allow roughly three minutes.  Every family must end in
`STATUS UNSAT WITNESS None`.  The final lines must be

```text
TOTAL_NODES 9136
F55-CHAR5-PROGRESSION-N6-SUPPORT-UNSAT-EXACT
```

Verifier SHA-256:

```text
9506bd90610b49ddeccdd055d7855749b3825db3301f2e7632e385d796d7718c
```

The verifier uses only the Python standard library.  It reconstructs all
weight bases and landing rows and then exhausts the Boolean support tree; it
does not trust the earlier MILP calculation, a stored solver status, or the
interrupted exploratory run.

