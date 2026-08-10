# Replay

Command:

```sh
/opt/homebrew/bin/python3 \
  problems/E-klein-cubic/goal_runs_20260808/CHAR5_FINITE_CUTOFF/verify.py
```

Expected output:

```text
F55-CHAR5-FROBENIUS-COUNTERTOWER-EXACT
F55-CHAR5-NO-FINITE-DIFFERENTIAL-CUTOFF
F55-CHAR5-LANDING-CUTOFF-OPEN
```

The replay verifies the finite arithmetic identities underlying the all-`n`
proof.  The all-`n` assertions themselves are proved symbolically in
`THEOREM.md`; the script samples levels `1,...,6` and checks Lucas' theorem
through each complete sub-`5^n` Hasse range.  It also checks the explicit
order-five invariant-coefficient recurrence for the `Psi_M` submodule on
several characteristic-five samples; the polynomial identity itself follows
from the displayed common characteristic polynomial.
