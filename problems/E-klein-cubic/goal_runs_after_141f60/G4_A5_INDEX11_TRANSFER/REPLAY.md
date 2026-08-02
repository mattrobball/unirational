# G4 replay

From repository root `problems/E-klein-cubic` (or this workspace root):

```sh
python3 -u goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/produce.py
python3 -u goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/verify_induction.py
python3 -u goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/verify_operations.py
python3 -u goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/verify_point.py
```

Optional binding checks:

```sh
python3 -u goal_runs_after_35fa/H_A5_TWISTS/common/verify_exact_points_direct.py
python3 -u goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/verify_phi.py
```

After `produce.py`, re-run `make_seal.py` if artifact hashes must be refreshed:

```sh
python3 -u goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/make_seal.py
```

Expected markers:

```text
G4_PRODUCE_OK
G4_INDUCTION_VERIFY_OK
G4_OPS_VERIFY_OK
G4_POINT_BOUNDARY_OK
G4-INDUCED-DEGREE11-POINT-PASS
HEADLINE-OPEN
```
