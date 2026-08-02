# G7B replay

From repository root `problems/E-klein-cubic` (workspace root):

```sh
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/produce.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/verify_scaling.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/verify_cycles.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/make_seal.py
```

Expected:

```text
G7B_PRODUCE_OK
G7-PROJECTIVE-SCALING-PASS
G7-INDUCED-DOUBLE-CYCLE-PASS
G7B_VERIFY_SCALING_OK
G7B_VERIFY_CYCLES_OK
G7B_SEAL_OK
```

Primary STATUS exit: `G7-INDUCED-DOUBLE-CYCLE-PASS` (includes scaling).

Note: verifiers do **not** import `produce.py`; they rebuild cosets, rho-points,
Phi/F checks, scaling, and incidence independently.
