# Replay — H6 decision push

From `problems/E-klein-cubic`:

```sh
/opt/homebrew/bin/python3 -u goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/phase_decision_push/produce_push.py
/opt/homebrew/bin/python3 -u goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/phase_decision_push/verify_push_torsor.py
/opt/homebrew/bin/python3 -u goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/phase_decision_push/verify_push_decision.py
```

Expected markers:

```text
H6_PUSH_PRODUCE_OK
H6_PUSH_TORSOR_VERIFY_OK
H6_PUSH_DECISION_VERIFY_OK
H6-TORSOR-CLASS-PASS
HEADLINE-OPEN
```

Verifiers do not import `produce_push.py`.
