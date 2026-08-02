# Replay — H5 fibration probe

```sh
cd /Users/worker/unirational/problems/E-klein-cubic
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_FIBRATION_PROBE_20260802/produce.py
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_FIBRATION_PROBE_20260802/verify.py
```

Expected verifier terminal line:

```text
H5_FIBRATION_PROBE_VERIFY_OK
```

The verifier does **not** import `produce.py`.  It reloads H4 hashes, rebuilds
`G` and residual binary forms, and replays every row of `SAMPLES.json`.
