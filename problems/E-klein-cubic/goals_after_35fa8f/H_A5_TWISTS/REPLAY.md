# Replay

Requirements: Python 3 with SymPy, and Singular 4.x.  Set `SINGULAR` if the
binary is not on `PATH` and is not `/opt/homebrew/bin/Singular`.

From this directory, the complete replay is

```sh
/opt/homebrew/bin/python3 verify_all.py
```

The component commands are

```sh
/opt/homebrew/bin/python3 build_canonical_model.py
/opt/homebrew/bin/python3 build_minimal_model.py
/opt/homebrew/bin/python3 independent/verify_canonical_reynolds.py
/opt/homebrew/bin/python3 independent/verify_points.py
/opt/homebrew/bin/python3 independent/verify_degree33_evaluation.py
/opt/homebrew/bin/python3 common/verify_exact_points_direct.py
/opt/homebrew/bin/python3 make_seal.py --check
```

To regenerate both class-specific point inputs, transcripts, and JSON
payloads before verifying them, run

```sh
/opt/homebrew/bin/python3 common/produce_exact_points.py
/opt/homebrew/bin/python3 independent/verify_points.py
/opt/homebrew/bin/python3 make_seal.py --check
```

Expected final markers are

```text
H3_A5_CANONICAL_MODEL_OK
H3_A5_MINIMAL_DEGREE10_OK
CANONICAL_A5_PENCIL_REYNOLDS_VERIFY_OK
H3_EXACT_DEGREE11_INDEPENDENT_VERIFY_OK
H3_DEGREE33_EXACT_EVALUATION_VERIFY_OK
H3_EXACT_BOTH_A5_POINTS_VERIFIED
H3_A5_TWISTS_VERIFY_ALL_OK
H3_A5_TWISTS_SEAL_OK
```
