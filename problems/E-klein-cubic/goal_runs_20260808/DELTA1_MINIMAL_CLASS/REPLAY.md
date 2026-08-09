# Replay

From `/Users/worker/unirational` run:

```sh
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/DELTA1_MINIMAL_CLASS/verify.py
```

Expected terminal markers:

```text
KLEIN-IJ-PERIOD-GRAM-MATRIX-EXACT
KLEIN-IJ-PRINCIPAL-HERMITIAN-INVERSE-INTEGRAL
KLEIN-IJ-MINIMAL-CLASS-RANK-ONE-DECOMPOSITION-EXACT
DELTA1-VOISIN-MINIMAL-CLASS-OBSTRUCTION-PASSES
```

The replay is finite exact arithmetic.  It reconstructs the period Gram
matrix from the displayed cyclotomic basis, rather than trusting a stored
success flag or a numerical period approximation.

`FIXED_PLANE_RETRACTION.md` is a proof-only addendum. Its coefficientwise
divisibility statement uses the already replayed H0-1 odd-order theorem and
formal arcs on the smooth Klein cubic; it makes no additional stored CAS
claim.
