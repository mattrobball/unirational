# Exact replay

Run all theorem certificates from the repository root:

```bash
python3 research/equivariant-unirationality-new-applications/verify_dihedral_conic_bundle.py
python3 research/equivariant-unirationality-new-applications/verify_dihedral_sylow_exact.py
python3 research/equivariant-unirationality-new-applications/verify_fermat_dp2_s3.py
python3 research/equivariant-unirationality-new-applications/verify_new_applications.py
```

Expected markers:

```text
DIHEDRAL_CONIC_BUNDLE_CERTIFICATE: PASS
DIHEDRAL_SYLOW_PRIME_POWER_AUDIT: PASS
FERMAT_DP2_S3_CERTIFICATE: PASS
ODD_DIHEDRAL_CONIC_BUNDLE_AUDIT: PASS
FERMAT_DP2_S3_AUDIT: PASS
NEW_APPLICATIONS_EXACT_CHECKS: PASS
```

`verify_dihedral_sylow_exact.py` deliberately includes nonsquarefree values
`n=9,25,27` and verifies the **full** prime-power Sylow rotation subgroup, not
only its order-`p` subgroup.

These scripts certify finite group structure, subgroup types, fixed-point
witnesses, branch squarefreeness/genus bookkeeping, and deeper fixed-locus
emptiness.  They do not replace the controlled equivariant-resolution proof in
`GENERALIZATIONS.md`.
