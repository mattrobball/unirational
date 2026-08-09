# Replay

From `/Users/worker/unirational/problems/E-klein-cubic` run

```text
/opt/homebrew/bin/python3 \
  goal_runs_20260808/DELTA3_S3_RESOLVENT_AUDIT/verify.py
```

Expected final marker:

```text
DELTA3-S3-RESOLVENT-AUDIT-OK
```

The replay enumerates `S3`, checks that its center and outer automorphism
group are trivial, verifies the CM norm-three identity, reconstructs the
three cyclic localization witnesses, checks their common positive integral
lift, and evaluates the displayed invariant sextic witness on the Klein
cubic.

