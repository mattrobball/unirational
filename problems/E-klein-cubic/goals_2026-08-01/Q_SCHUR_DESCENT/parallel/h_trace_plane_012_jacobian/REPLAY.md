# Replay

From
`/Users/worker/unirational/problems/E-klein-cubic/goals_2026-08-01` run:

```bash
python3 Q_SCHUR_DESCENT/parallel/h_trace_plane_012_jacobian/verify.py
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
