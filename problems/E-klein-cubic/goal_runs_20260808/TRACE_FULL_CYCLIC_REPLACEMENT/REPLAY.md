# Replay

From `/Users/worker/unirational/problems/E-klein-cubic`, run:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/TRACE_FULL_CYCLIC_REPLACEMENT/verify.py
```

Expected output:

```text
F55_ORDER 55
F55_CENTER_SIZE 1
PROJECTIVE_SOURCE_DIMENSION 4
KLEIN_TARGET_DIMENSION 3
PROJECTIVE_ISOGENY_DEGREE 11
PROJECTIVE_ISOGENY_SNF [1, 1, 1, 11]
NONTRIVIAL_FOURIER_RANK 4
F55-TRACE-FULL-CYCLIC-SPAN-REPLACEMENT-OK
```

The replay checks the finite group/projective-freeness input, the source and
target dimensions, the exact upstream isogeny certificate, and the Fourier
linear algebra.  The prescribed-source graph lemma is a characteristic-zero
differential argument proved in `THEOREM.md`; it is not replaced by a finite
calculation.

The two consumed trace-model inputs were also replayed directly:

```sh
/opt/homebrew/bin/python3 goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY/verify_isogeny.py
/opt/homebrew/bin/python3 goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/verify_torsor.py
```

Their relevant final markers are:

```text
H6_PROJECTIVE_11_ISOGENY_PASS
H6A_VERIFY_OK
H6_TORSOR_VERIFY_OK
```
