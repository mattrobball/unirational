# Invalid scratch output

Every other file in this directory was generated before discovering that the
upstream covariant nullspace used `C*M=R*C` instead of the required
`C*M^T=R*C`.  These files are retained only as an audit trail, are not
authoritative, and are excluded from `SEAL.json`.

See `../BUG_AUDIT.md` and `../transpose_audit.py` for the corrected diagnosis.
