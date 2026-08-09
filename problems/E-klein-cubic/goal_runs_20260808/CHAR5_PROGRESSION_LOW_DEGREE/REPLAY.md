# Replay

From `problems/E-klein-cubic`, run

```sh
/opt/homebrew/bin/python3 \
  goal_runs_20260808/CHAR5_PROGRESSION_LOW_DEGREE/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/CHAR5_PROGRESSION_LOW_DEGREE/verify_support_degree35.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/CHAR5_PROGRESSION_CLOSE/verify_n5_support_unsat.py \
  --degree 6
```

For each root degree `1,2,3,4`, every family with nonzero root-weight spaces
must print `EMPTY`, followed by

```text
ROOT_DEGREE 1 SURVIVOR_FAMILIES []
ROOT_DEGREE 2 SURVIVOR_FAMILIES []
ROOT_DEGREE 3 SURVIVOR_FAMILIES []
ROOT_DEGREE 4 SURVIVOR_FAMILIES []
F55-CHAR5-PROGRESSION-LOW-DEGREE-AUDIT-DONE
```

The first script derives the monomial bases and landing coefficient equations
from the sixteen `(d,r)` pairs, then recomputes every projective saturation
chart with Singular.  The second script must print sixteen lines ending in
`SUPPORT NONE`, followed by

```text
F55-CHAR5-PROGRESSION-DEGREE35-SUPPORT-EMPTY-EXACT
GENERATED_CPP_SHA256 48e264628a0026fd697efcda72ab49d891f4b4c513def3d2e3c831db9408a80d
```

It regenerates the complete degree-35 support system and compiles a temporary
C++ exhaustive verifier.  It does not consume the exploratory Gröbner timeout
or the floating-point MILP preflight.

The final DPLL replay must end with

```text
TOTAL_NODES 9136
F55-CHAR5-PROGRESSION-N6-SUPPORT-UNSAT-EXACT
```
