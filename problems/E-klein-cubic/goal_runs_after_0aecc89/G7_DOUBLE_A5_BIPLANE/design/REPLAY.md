# G7A replay

From repository root `problems/E-klein-cubic` (workspace root):

```sh
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/produce.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/verify_design.py
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/make_seal.py
```

Or verifier-only after artifacts exist:

```sh
python3 -u goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design/verify_design.py
```

Expected:

```text
G7A_PRODUCE_OK
G7-PALEY-BIPLANE-IDENTIFIED
G7-CROSS-CLASS-PROJECTOR-PASS
G7A_VERIFY_DESIGN_OK
G7A_SEAL_OK
```

Primary STATUS exit: `G7-CROSS-CLASS-PROJECTOR-PASS` (includes biplane identification).

Note: `verify_design.py` does **not** import `produce.py`; it regenerates
\(G\), both A5 classes, incidence, identities, and projectors independently.
