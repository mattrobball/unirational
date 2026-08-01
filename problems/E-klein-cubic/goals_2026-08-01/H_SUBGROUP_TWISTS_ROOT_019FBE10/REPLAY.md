# Replay

Run from `problems/E-klein-cubic/goals_2026-08-01`:

```sh
/opt/homebrew/bin/python3 -u H_SUBGROUP_TWISTS_ROOT_019FBE10/produce.py
/opt/homebrew/bin/python3 -u H_SUBGROUP_TWISTS_ROOT_019FBE10/a4_direct_search.py
/opt/homebrew/bin/python3 -u H_SUBGROUP_TWISTS_ROOT_019FBE10/seal.py
/opt/homebrew/bin/python3 -u H_SUBGROUP_TWISTS_ROOT_019FBE10/verify.py
```

The final markers are:

```text
H_SUBGROUP_TWISTS_PRODUCER_OK
H_A4_DIRECT_SEARCH_OK
H_SUBGROUP_TWISTS_SEAL_OK
H_SUBGROUP_TWISTS_INDEPENDENT_VERIFY_OK
```

The verifier recomputes the group actions and frames, finds second determinant
witnesses different from the producer's, expands the twisted cubic
coefficients again, reconstructs both soluble subgroup lines, reruns the
upstream exact fixed-locus census, and checks every sealed content hash.
