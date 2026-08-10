# Replay

Run:

```sh
/opt/homebrew/bin/python3 verify.py
```

Expected final marker:

```text
OSCULATING-HERMITE-GEOMETRY-REPLAY-OK
```

The replay uses exact polynomial arithmetic and dual numbers over `F_7`.
It performs no search.  It checks both the earlier boundary point and the
nonboundary covariant point, including contact, residual quotient, full
degree, common gcd, fibre Jacobians, root-direction Jacobian and the
second-polar constant `33`.
