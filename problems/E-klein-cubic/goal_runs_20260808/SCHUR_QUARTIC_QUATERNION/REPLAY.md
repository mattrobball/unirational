# Replay

From `problems/E-klein-cubic` run:

```sh
/opt/homebrew/bin/python3 \
  goal_runs_20260808/SCHUR_QUARTIC_QUATERNION/audit.py
```

Expected final marker:

```text
SCHUR-QUARTIC-QUATERNION-AUDIT-OK
```

The replay invokes the sibling exact Pfaffian/rank-chart verifier.  It uses
one analytically selected smooth point and theorem-forced matrices only; it
does not search degrees, supports, coefficient boxes, or parameter values.
