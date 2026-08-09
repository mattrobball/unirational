# Replay

From `problems/E-klein-cubic` run:

```sh
python3 -B goal_runs_20260808/OSCULATING_GENERAL_H/verify_mod7_point.py
python3 -B goal_runs_20260808/OSCULATING_GENERAL_H/verify_exhaustive_mod7.py
python3 -B goal_runs_20260808/OSCULATING_GENERAL_H/verify_exhaustive_mod11.py
```

Expected terminal markers are:

```text
F55-OSCULATING-GENERAL-H-NONDEGENERATE-COMPONENT-MOD7
F55-OSCULATING-NORMALIZED-FIBRE-F7-EXHAUSTIVE
F55-OSCULATING-NORMALIZED-FIBRE-F11-EXHAUSTIVE
```

The first verifier derives the contact equations, reconstructs all five
polynomials, checks degree, gcd, residual quotient, and the exact Jacobian
determinants.  The two exhaustive verifiers generate and compile direct
finite-field evaluators.  Their search spaces are exactly `7^10` and
`11^10` points in the analytically reduced covariant slice; they perform no
degree, support, or coefficient-height sweep.
