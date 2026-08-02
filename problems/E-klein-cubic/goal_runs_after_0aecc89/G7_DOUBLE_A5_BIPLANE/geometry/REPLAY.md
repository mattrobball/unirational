# G7C replay

From repository root `problems/E-klein-cubic` (workspace root):

```sh
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/geometry/produce_geometry.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/geometry/verify_geometry.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/geometry/verify_point.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/geometry/make_seal.py
```

Expected:

```text
G7C_PRODUCE_OK
G7-RESIDUAL-GEOMETRY-PASS
G7C_VERIFY_GEOMETRY_OK
G7C_VERIFY_POINT_OK
G7C_SEAL_OK
```

Primary STATUS exit: `G7-RESIDUAL-GEOMETRY-PASS`.

Note: verifiers do **not** import `produce_geometry.py`; they recompute third
intersections, polarization identities, operation landing summaries, and
bridge absence independently from sealed G7A/G7B inputs and geometry JSON.
