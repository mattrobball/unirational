# Field and model binding (wave 2)

Consumes sealed H4

```text
goal_runs_after_35fa/H_11_5_TWIST/   exit H-11_5-NORM-MODEL-PASS
```

and parent wave 1

```text
goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/   exit H5-UNDECIDED
```

by path+SHA-256 in `INPUT_MANIFEST.json`. Lattice checks and the `p=89`
coefficient table of `Phi` are independently rebuilt in `verify.py`.

Equation:

```text
Phi(a) = Tr_{E/K}(r2^{-1} a^2 sigma(a)) = sum_i Z(r_i)^2 Z(r_{i+1}) / r_{i+2}.
```
