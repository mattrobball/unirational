# Verification record

Date: 2026-08-01.

## Standalone verification

Command:

```sh
/opt/homebrew/bin/python3 -u \
  goal_runs_after_35fa/KLS_MINIMALITY/verify.py
```

Observed checks:

```text
PASS seal artifacts=14
PASS source hashes=17 manifest_commit=37d61c19a108781cf74af837e24810a9f7f7c3be current_head=37d61c19a108781cf74af837e24810a9f7f7c3be
PASS category split, singleton landing ledger, and strict open scope
PASS exact smoothness of Klein cubic on five projective charts
PASS exact homogeneous discrepancy and split-conductor countermodels
KLS2_NO_FINITE_REDUCTION_PACKET_VERIFIED
```

The smoothness check recomputes a unit Gröbner basis for the gradient ideal
on each chart `x_i=1`; it does not read a stored smoothness boolean.

## Deep historical replay

Command:

```sh
/opt/homebrew/bin/python3 -u \
  goal_runs_after_35fa/KLS_MINIMALITY/verify.py --deep
```

The deep run observed all nine required terminals and ended with
`KLS2_NO_FINITE_REDUCTION_PACKET_VERIFIED`:

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

The degree-nine proper-multiple checks were recomputed under their 2 GiB
caps.  These markers verify the historical scopes only; they do not eliminate
`LANDING_SMOOTH_H1` or prove a finite broad KLS ledger.
