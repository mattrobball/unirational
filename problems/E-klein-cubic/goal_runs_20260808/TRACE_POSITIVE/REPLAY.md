# Replay

Run from the repository root:

```bash
python3 problems/E-klein-cubic/goal_runs_20260808/TRACE_POSITIVE/verify_char5_subfrobenius.py
python3 problems/E-klein-cubic/goal_runs_20260808/TRACE_POSITIVE/verify_char5_degree5.py
/opt/homebrew/bin/python3 problems/E-klein-cubic/goal_runs_20260808/TRACE_POSITIVE/verify_char5_as_cyclic_countermodel.py
```

Expected terminal markers:

```text
F55-CHAR5-ALL-DEGREE-LT5-COVARIANTS-DOMINANT
F55-CHAR5-DEGREE5-LANDING-EMPTY
F55-CHAR5-AS-CYCLIC-PROGRESSION-COUNTERMODEL-OK
```

The first replay requires SymPy and `/opt/homebrew/bin/Singular`; the second
requires `/opt/homebrew/bin/Singular`.  Both construct their complete exact
ideals in temporary directories.  They do not import historical search
artifacts and do not enumerate degrees above the stated finite boundary.

The degree-five replay should also print:

```text
BASIS_SIZE=11
EQUATION_COUNT=350
INPUT_SHA256=5d6ce3b5d178847d19538b52ddf6c1a81deea58900335dd37b7d5c3d5754e0ce
GB_SIZE=637
DIM=0
VDIM=555
PROJECTIVE_LANDING_EMPTY=1
```
