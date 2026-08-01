# Verification record

Date: 2026-08-01.

## Local packet verification

Run from `goals_2026-08-01/`:

```sh
/opt/homebrew/bin/python3 -u KLS_MINIMALITY/producer.py
/opt/homebrew/bin/python3 -u KLS_MINIMALITY/verify.py
```

The verifier checks the final seal and source hashes, both elimination
payloads, all configuration scope flags, the exact symbolic `e=5`
countermodel (`h=Q^3`, `beta=2`, `A_E=0`), the degree-11 consistency ledger,
the unbounded conductor-pullback model, and the upward degree direction of
quartic precomposition.

## Deep source replay

Run:

```sh
/opt/homebrew/bin/python3 -u KLS_MINIMALITY/verify.py --deep
```

The 2026-08-01 deep run observed all nine required terminal strings:

```text
STRICT NONVERDICT no KLS solution or universal nonvanishing is proved
STRICT NONVERDICT singular/noncanonical KLS image branch remains open
STRICT NONVERDICT minimal contraction and Klein unirationality remain open
KLS_ACTUAL_CONDUCTOR_GEOMETRY_EXACT
KLS_ACTUAL_CONDUCTOR_GEOMETRY_AUDIT_ACCEPTED
KLS_SQUAREFREE_PROPER_P22_BRANCH_EXCLUDED
KLS_PROPER_MULTIPLE_STRUCTURE_AUDIT_ACCEPT
KLS_DISCREPANCY_NEXT_GATE_EXACT
KLS_DISCREPANCY_NEXT_GATE_HOSTILE_AUDIT_ACCEPT
```

The strict nonverdict strings are load-bearing.  This replay does not certify
a finite classification, universal KLS nonexistence, or the headline
negative conclusion.
