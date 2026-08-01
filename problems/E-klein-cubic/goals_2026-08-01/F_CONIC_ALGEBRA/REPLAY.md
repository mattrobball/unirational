# Replay

From `goals_2026-08-01/` run

```sh
/opt/homebrew/bin/python3 -u F_CONIC_ALGEBRA/produce_infinity_obstruction.py
/opt/homebrew/bin/python3 -u F_CONIC_ALGEBRA/verify_infinity_obstruction.py
/opt/homebrew/bin/python3 -u F_CONIC_ALGEBRA/produce_seal.py
/opt/homebrew/bin/python3 -u F_CONIC_ALGEBRA/verify.py
```

Required terminal markers:

```text
GOAL_F_INFINITY_OBSTRUCTION_PRODUCED
GOAL_F_INFINITY_EXACT_IDENTITIES_ACCEPT
GOAL_F_INFINITY_MODULAR_LIFT_ACCEPT
GOAL_F_CONIC_CRITERION_EMPTY_ACCEPT
GOAL_F_SEAL_WRITTEN
GOAL_F_EXACT_FIELD_LAYER_ACCEPT
GOAL_F_BOUNDED_SCREENS_SCOPED_ACCEPT
GOAL_F_CONIC_CRITERION_EMPTY_ACCEPT
```

The verifier recomputes the exact field-presentation layer, the reciprocal
leading-factor identity, the normalization and net identities, and the good
reduction used to lift the exact base scheme.  The finite-field calculation
is a good-reduction certificate for explicit characteristic-zero identities;
none of the bounded discovery screens is used as an emptiness argument.
