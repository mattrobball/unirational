# Replay

```sh
cd problems/E-klein-cubic
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_WAVE2_LAURENT_PROJ/produce.py
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_WAVE2_LAURENT_PROJ/seal.py
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_WAVE2_LAURENT_PROJ/verify.py
```

Expected final line:

```text
H5_WAVE2_INDEPENDENT_VERIFY_OK
```

Resource note: produce and verify use only stdlib Python modular arithmetic;
RSS is well under 8GiB (single-process, no large matrices).
