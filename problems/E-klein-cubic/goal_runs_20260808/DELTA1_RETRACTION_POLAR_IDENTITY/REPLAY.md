# Replay

From `problems/E-klein-cubic` run:

```sh
/opt/homebrew/bin/python3 \
  goal_runs_20260808/DELTA1_RETRACTION_POLAR_IDENTITY/verify.py
```

Expected terminal markers:

```text
PASS abstract polarized identities and line factorization
PASS square discriminant gives two degree-lowered landing roots
PASS primitive irreducible degree-nine retraction countermodel
PASS countermodel residual discriminant is nonsquare
PASS high-degree invariant nonsquare arithmetic
DELTA1-RETRACTION-POLAR-IDENTITY-PACKET-OK
```

The verifier uses exact rational polynomial arithmetic only.  The
countermodel is a strict theorem-boundary example; it is not a Klein-cubic
map and does not alter the `HEADLINE-OPEN` verdict.
