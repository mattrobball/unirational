# Replay

From `problems/E-klein-cubic`:

```sh
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/produce.py
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/seal.py
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/verify.py
```

Expected markers:

```text
H5_PRODUCE_OK
H5_SEAL_OK
H5_INDEPENDENT_VERIFY_OK
```

`produce.py` rewrites JSON payloads deterministically up to modular sampling
seeds fixed in source.  After changing durable files, re-run `seal.py` before
`verify.py` if a seal check is added later; the current verifier binds
`INPUT_MANIFEST` hashes and payload invariants, not `SEAL.json` self-reference.
