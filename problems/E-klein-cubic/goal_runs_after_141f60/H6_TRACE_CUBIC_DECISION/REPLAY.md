# H6 residual replay

From `problems/E-klein-cubic`:

```sh
/opt/homebrew/bin/python3 -u goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/produce.py
/opt/homebrew/bin/python3 -u goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/verify_torsor.py
/opt/homebrew/bin/python3 -u goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/verify_decision.py
```

Decision push (H6.2–H6.4 extension):

```sh
/opt/homebrew/bin/python3 -u goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/phase_decision_push/produce_push.py
/opt/homebrew/bin/python3 -u goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/phase_decision_push/verify_push_torsor.py
/opt/homebrew/bin/python3 -u goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/phase_decision_push/verify_push_decision.py
```

Expected terminal markers:

```text
H6_PRODUCE_OK
H6_TORSOR_VERIFY_OK
H6_DECISION_VERIFY_OK
H6_PUSH_PRODUCE_OK
H6_PUSH_TORSOR_VERIFY_OK
H6_PUSH_DECISION_VERIFY_OK
H6-TORSOR-CLASS-PASS
HEADLINE-OPEN
```

Producer and verifiers are independent (verifiers rebuild dual maps, lattice
checks, and modular witnesses; they do not import producers).
