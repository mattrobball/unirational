# Schur-plane `012` Sarkisov link

This directory contains the exact producer and independent verifier for the
selected link. The producer rebuilds the stored payload from the repository's
degree-eight Reynolds implementation. The verifier does not import the
producer; it reconstructs the frame, invariant cubic, projective smoothness,
all 55 line-incidence determinants, and the divisor ledger independently.

Local replay:

```sh
/opt/homebrew/bin/python3 M2_EQUIVARIANT_SARKISOV_CODEX_ROOT_20260801/links/schur_plane_012_dp3/verify_link.py
```

The top-level `verify.py` additionally checks the characteristic-zero frame
and exact cyclotomic subgroup certificates.

