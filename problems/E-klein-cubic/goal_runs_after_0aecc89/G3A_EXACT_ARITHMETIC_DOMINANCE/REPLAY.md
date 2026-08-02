# G3A replay

```sh
cd problems/E-klein-cubic
python3 -u goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/verify_field.py
python3 -u goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/verify_phi.py
python3 -u goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/verify_bridge.py
python3 -u goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/verify_all.py
```

Optional G2 smoke:

```sh
python3 -u goal_runs_after_35fa/G_UNIVERSAL/verify.py
```

Expected:

```text
G3A_FIELD_VERIFY_OK
G3A_PHI_VERIFY_OK
G3A_BRIDGE_VERIFY_OK
G3-DOMINANCE-AUTOMATIC
G3A_VERIFY_ALL_OK
G3A-ARITHMETIC-DOMINANCE-PASS
HEADLINE-OPEN
```
