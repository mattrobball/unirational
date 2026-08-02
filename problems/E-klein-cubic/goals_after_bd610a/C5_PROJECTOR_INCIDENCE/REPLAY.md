# Replay

From this directory, regenerate every local exact payload and the seal:

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u produce.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u build_corrected_incidence.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u build_generic_pluecker_incidence.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u morita_generic_build.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u morita_generic_split_build.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u make_seal.py
```

Then run the independent replays:

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_incidence.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_corrected_incidence.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_generic_pluecker_incidence.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u morita_generic_verify.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u morita_generic_split_verify.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_modular_seed_p23.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_morita_seed_p23.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_projective_mixed_reduction.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_degree16_fano_exclusion.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_descent_compatible_ansatz.py
```

The load-bearing terminal markers are:

```text
C5_CONVENTION_GATE_FAIL_INDEPENDENTLY_VERIFIED
C5_CORRECTED_INCIDENCE_GEOMETRY_INDEPENDENTLY_VERIFIED
C5_GENERIC_PLUECKER_INCIDENCE_INDEPENDENTLY_VERIFIED
C5-MORITA-GENERIC-390-COEFFICIENT-DAG-INDEPENDENTLY-VERIFIED
MORITA-GENERIC-SPLIT-DAG-VERIFIED
C5_MODULAR_SEED_P23_OK
C5-MORITA-SEED-P23-INDEPENDENTLY-VERIFIED
C5_PROJECTIVE_MIXED_REDUCTION_OK
C5_DEGREE16_FANO_EXCLUSION_INDEPENDENTLY_VERIFIED
ALL CHECKS PASS -- BOUNDED AUDIT ONLY; NO ALL-DEGREE VERDICT
```

The upstream exact packets may be replayed independently with:

```sh
(cd ../../goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT && \
  /opt/homebrew/bin/python3 -u verify_compressed_algebra.py)
(cd ../../goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT && \
  /opt/homebrew/bin/python3 -u verify_involution.py)
(cd ../../goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT && \
  /opt/homebrew/bin/python3 -u verify_distinguished_five_plane.py)
(cd ../../goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3 && \
  /opt/homebrew/bin/python3 -u verify_c2_morita.py)
```

Those checks rebuild the lazy algebra, the `15/21` involution split, the
rank-five distinguished section, and the auxiliary Morita data.  The
auxiliary projector itself is not a Fano point.
