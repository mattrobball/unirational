# Replay

The packet contains no broad coefficient search. Its executable checks are
finite arithmetic/character checks for the theorem-forced obstruction data.

From the packet directory:

```sh
python3 verify_boundary_obstruction.py
python3 verify_seal.py
```

Expected terminal markers:

```text
DEGREE25_MARKED_ELLIPTIC_FINITE_CHECKS_OK
DEGREE25_MARKED_ELLIPTIC_SEAL_OK
```

The first verifier checks:

- exponent-six marked-origin independence;
- the corrected residual `S3` permutation action and its marked fixed sets;
- commutation of `[-5]` with all residual generators;
- incompatibility of elliptic and line basepoint-free degrees;
- the exact invariant target calculation `38+9-2-4=41`;
- consistency of the sealed source dimensions and exit label.

The geometric inputs—smoothness, incidence, tangent characters, and the free
residual `C3` action—are pinned by blob hash in `SOURCE_AUDIT.md`; replay of
this small verifier does not pretend to re-prove those repository certificates.
