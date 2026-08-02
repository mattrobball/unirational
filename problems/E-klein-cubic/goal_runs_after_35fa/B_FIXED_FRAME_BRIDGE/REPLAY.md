# Replay

From this directory run:

```bash
python3 produce.py
python3 produce_seal.py
/opt/homebrew/bin/python3 verify.py
```

The verifier uses the Homebrew Python because the system Python does not ship
SymPy in this environment.  The final command is independent of the producer.
It hash-checks all pinned
inputs and output artifacts, replays the authoritative Goal F verifier,
checks the Pfaffian scope failure and current repaired target simple-fold
payload directly, and symbolically verifies the formal diagonal-section
counterexample.  The historical fold verifier is not invoked because it
still requires the superseded `T2=PLAN_ONLY` status; the current repaired
fold payload and seal instead record `T2-UNDECIDED`.

Expected final markers:

```text
B_OBJECT_DICTIONARY_ACCEPT
B_PROJECTOR_COMPLEMENT_SECTION_ACCEPT
B_PROJECTOR_PROJECTIVIZATION_ACCEPT
B_AUXILIARY_SCOPE_BOUNDARY_ACCEPT
B_BRANCH_VALUATIONS_DISTINCT_ACCEPT
B_TARGET_FOLD_SEALED_INPUT_ACCEPT
B_REMAINING_GATE_AND_F_SCOPE_ACCEPT
B_FORMAL_SECTION_EXACT_ALGEBRA_ACCEPT
B_FORMAL_SECTION_INDEX_PROOF_LEDGER_ACCEPT
B_GOAL_F_UPSTREAM_REPLAY_ACCEPT
B_UNDECIDED_VERIFIER_ACCEPT
```
