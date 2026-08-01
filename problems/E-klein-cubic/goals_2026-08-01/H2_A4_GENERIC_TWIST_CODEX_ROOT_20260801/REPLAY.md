# Replay

Prerequisites: `/opt/homebrew/bin/python3`, SymPy, and
`/opt/homebrew/bin/Singular`.

From `goals_2026-08-01`, run:

```sh
/opt/homebrew/bin/python3 H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801/canonical_model.py
/opt/homebrew/bin/python3 H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801/reduce_twist_uv.py
/opt/homebrew/bin/python3 H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801/exact_degree3_map.py
/opt/homebrew/bin/python3 H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801/source_intertwiner.py
/opt/homebrew/bin/python3 H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801/audit_upstream_transpose.py
/opt/homebrew/bin/python3 H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801/transpose_audit.py
/opt/homebrew/bin/python3 H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801/verify_exact_point.py
/opt/homebrew/bin/python3 H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801/verify.py
```

The two verifier commands must respectively end with:

```text
H2_A4_RATIONAL_POINT_VERIFIED
H2_A4_GENERIC_TWIST_VERIFY_OK
```

Build and independently check the content seal with:

```sh
/opt/homebrew/bin/python3 H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801/make_seal.py
/opt/homebrew/bin/python3 H2_A4_GENERIC_TWIST_CODEX_ROOT_20260801/verify_seal.py
```
