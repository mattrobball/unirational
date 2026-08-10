# Replay

From `/Users/worker/unirational/problems/E-klein-cubic`:

```text
$ /opt/homebrew/bin/python3 goal_runs_20260808/UNIT_GLOBAL_COUPLING/verify.py
UNIT-GLOBAL-LINEAR-RECIPROCITY-EXACT
UNIT-GLOBAL-FULL-DECOMPOSITION-SOLUBLE-COUNTERPLACE
UNIT-GLOBAL-ALL-PARSHIN-FLAGS-SOLUBLE
UNIT-GLOBAL-COUPLING-AUDIT-OK
```

The script checks only the finite group, weight, and resolvent identities
used by the proofs.  Exactness of the divisor sequence, Maschke averaging,
and the Henselian induction are the analytic arguments in `THEOREM.md`.
