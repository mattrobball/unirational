# Replay

From the root of the containing `Q_SCHUR_INDEX_ONE` packet, run:

```bash
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  h_trace_plane_012_jacobian/verify.py
```

Requirement: Python 3 with SymPy available.  The replay is exact, uses no
network access, and typically takes about one minute.

Expected final marker:

```text
H_TRACE_PLANE_012_FISHER_JACOBIAN_OK
```

The verifier checks the six source hashes, reconstructs `C_012` from its 27
ordered trace terms, calibrates Fisher's normalization on the Hesse family,
computes the Hessian and two mixed Hessians, extracts `c4,c6`, reduces them
in `Q[epsilon]/(epsilon^4+epsilon^3+epsilon^2+epsilon+1)`, and checks the
canonical tables, term counts, and SHA-256 digests in `payload.json`.
