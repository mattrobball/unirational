# KLS2 minimality-to-discrepancy goal run

This directory is the isolated output for
`goals_after_35fa8f/GOAL_KLS2_MINIMALITY_TO_DISCREPANCY.md`.

The exact accepted exit is `KLS2-NO-FINITE-REDUCTION`.  It closes the proposed
minimality-to-discrepancy/conductor reduction at the strength stated in KLS2;
it does **not** decide the Klein cubic headline.

The human proof and scope audit are in `MINIMALITY.md`,
`DISCREPANCY_THEOREM.md`, `COUNTEREXAMPLE_AUDIT.md`, and
`COMPLETION_AUDIT.md`.  Machine-readable ledgers are
`MINIMALITY_MODEL.json`, `CONFIGURATIONS.json`, and `ELIMINATIONS.json`.
`SOURCE_MANIFEST.json` pins all imported evidence, `SEAL.json` hashes this
packet, and `VERIFICATION.md` records both replay commands.

Run:

```sh
/opt/homebrew/bin/python3 -u goal_runs_after_35fa/KLS_MINIMALITY/verify.py
/opt/homebrew/bin/python3 -u goal_runs_after_35fa/KLS_MINIMALITY/verify.py --deep
```
