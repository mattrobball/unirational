# Replay

From this directory run:

```sh
/opt/homebrew/bin/python3 -u verify.py
```

Requirements:

- Python 3 standard library;
- Singular on `PATH` (the verifier invokes all four stored programs);
- unchanged authoritative inputs under
  `goal_runs_after_35fa/H_11_5_TWIST/`.

Expected chart markers:

```text
KUMMER_P11_ALL_5_PROJECTIVE_CHARTS_EMPTY
KUMMER_P31_ALL_5_PROJECTIVE_CHARTS_EMPTY
R_BASIS_P11_ALL_5_PROJECTIVE_CHARTS_EMPTY
R_BASIS_P31_ALL_5_PROJECTIVE_CHARTS_EMPTY
```

Expected terminal marker and scope:

```text
H_TRACE_CONSTANT_FIVE_COORDINATE_TWO_BASIS_EXCLUSION_OK
SCOPE: two constant five-coordinate families only; no generic pointlessness theorem
```

The verifier is standalone: it reconstructs `Q(epsilon)`, the five `R_i`, the
35-term `H=R2*R3^2`, both complete coefficient ideals, and the exact Singular
sources.  It checks authoritative, producer, verifier, and generated-program
hashes before accepting the chart transcripts.
