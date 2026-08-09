# Replay

From the repository root:

```sh
python3 problems/E-klein-cubic/goal_runs_20260808/C11_DEGREE8_TANGENT/verify.py
```

Expected final marker:

```text
C11_DEGREE8_TANGENT_VERIFY_OK
```

The verifier first checks the three source hashes in `SOURCES.md`, then uses
only exact integer arithmetic.  It independently checks the weight identities,
all 110 affine-character pairs, cancellation and parameter-inversion
equivalence, birationality of the monomial maps, the five degree-eight
pullbacks, the canonical residual divisor, the saturated tangency monomials,
and the order-five semilinear orbit on curve types.
