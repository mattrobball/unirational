# Replay

Command, from the Problem E directory:

```text
/opt/homebrew/bin/python3 \
  goal_runs_20260808/CYCLOTOMIC_EXT_AUDIT/verify.py
```

Observed output on 2026-08-08:

```text
EXT1_DIMS {0: 0, 1: 1, 2: 1, 3: 1, 4: 0}
EXTERIOR_COKERNEL_CHARS {1: [9], 2: [1, 3, 5], 3: [3, 4, 9], 4: [1]}
TOP_EXTERIOR F11(1) NOT F11(9)
TATE_H_ODD_I_MAP times 3 on Z/5
FIRST_MOD11_GROUP_COHOMOLOGY_INVARIANT_DEGREES 9 10
CYCLOTOMIC-EXT-EXTERIOR-AUDIT-OK
```

The verifier uses SymPy only for the already forced `4 x 4` determinant and
Smith form.  Every other check enumerates at most the sixteen exterior
subsets of four analytically determined characters.

