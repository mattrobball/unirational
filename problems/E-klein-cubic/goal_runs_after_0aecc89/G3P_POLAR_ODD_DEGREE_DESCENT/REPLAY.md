# G3P replay

```sh
cd problems/E-klein-cubic
python3 -u goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/produce.py
python3 -u goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/verify_polars.py
python3 -u goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/verify_quadrics.py
python3 -u goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/verify_point.py
python3 -u goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/verify_all.py
```

Expected markers:

```text
G3P_PRODUCE_OK
G3P_POLARS_VERIFY_OK
G3P_QUADRICS_VERIFY_OK
G3P_POINT_BOUNDARY_OK
G3P_VERIFY_ALL_OK
G3P-POLAR-SYSTEM-PASS
HEADLINE-OPEN
```
