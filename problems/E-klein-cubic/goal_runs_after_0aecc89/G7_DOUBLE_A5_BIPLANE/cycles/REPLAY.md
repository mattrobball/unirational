# G7B REDO replay

From repository root `problems/E-klein-cubic` (workspace root):

```sh
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/produce.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/verify_scaling.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/verify_cycles.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/audit_induced_refutation.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/make_seal.py
```

Expected:

```text
G7B_PRODUCE_OK
G7-PROJECTIVE-SCALING-PASS
G7B_VERIFY_SCALING_OK
G7B_VERIFY_CYCLES_OK
G7B-INDUCED-CYCLE-REFUTED
G7B_AUDIT_OK
G7B_SEAL_OK
```

Primary STATUS exit: `G7-PROJECTIVE-SCALING-PASS` (G7.3 residual).

Notes:

- Verifiers do **not** import `produce.py`.
- `audit_induced_refutation.py` is a regression: the e0 construction must remain
  refuted; STATUS/SEAL must not re-claim `G7-INDUCED-DOUBLE-CYCLE-PASS` without
  a correct materialization that passes the hardened cycle verifier.
- Historical `cycles_WITHDRAWN_rho_e0.json` is non-consumable.
