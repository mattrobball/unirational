# Replay

From this directory, regenerate the canonical manifest, the literal
unit-ideal certificate, the corrected incidence, all seven Singular
transcripts, and the seal; then run both independent verifiers:

```sh
/opt/homebrew/bin/python3 -u produce.py
/opt/homebrew/bin/python3 -u build_corrected_incidence.py
/opt/homebrew/bin/python3 -u make_seal.py
/opt/homebrew/bin/python3 -u verify.py
/opt/homebrew/bin/python3 -u verify_corrected_incidence.py
/opt/homebrew/bin/python3 -u verify_modular_seed_p23.py
/opt/homebrew/bin/python3 -u verify_morita_seed_p23.py
/opt/homebrew/bin/python3 -u verify_incidence.py
```

The terminal markers are:

```text
C5_CONVENTION_GATE_FAIL_INDEPENDENTLY_VERIFIED
C5_CORRECTED_INCIDENCE_GEOMETRY_INDEPENDENTLY_VERIFIED
C5_MODULAR_SEED_P23_OK
C5-MORITA-SEED-P23-INDEPENDENTLY-VERIFIED
```

The upstream exact packets can be replayed independently with:

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

Those commands rebuild the lazy algebra, the `15/21` involution split, the
rank-five distinguished section, and the auxiliary Morita chart seed.  The
seed is disjoint from the genuine first Fano hyperplane and supplies no
common line.
