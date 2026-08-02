# Replay

From
`/Users/worker/unirational/problems/E-klein-cubic/goals_2026-08-01` run:

```bash
python3 Q_SCHUR_DESCENT/parallel/h_trace_plane_012_torsor_next/verify.py
```

Requirement: Python 3 with SymPy.  The computation is exact, requires no
network access, and typically finishes in under one minute.

Expected final marker:

```text
H_TRACE_PLANE_012_FISHER_COVER_AND_U1_LOCAL_POINT_OK
```

The verifier checks five source hashes, reconstructs the `C_012` coefficient
substitution from 27 ordered trace terms, recomputes and hashes the generic
`H` and `Theta` covariants, checks the full Hesse-family normalization and
syzygy, reconstructs the exact trace residues, verifies the simple Hensel
root, and checks the first coefficient of the resulting `U1`-adic point.

Fisher's general theorem identifying the covariant recipe as the canonical
covering is imported rather than reproved.  The full expanded `C_012`
syzygy and global torsor triviality are not replay claims.
