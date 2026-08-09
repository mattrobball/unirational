# Replay index

From `problems/E-klein-cubic`, the principal exact replays are:

```sh
/opt/homebrew/bin/python3 \
  goal_runs_20260808/C11_DEGREE8_TANGENT/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/OSCULATING_GENERAL_H/verify_mod7_point.py

(cd goal_runs_20260808/OSCULATING_COVARIANT_COVER && \
  /opt/homebrew/bin/python3 verify_exact.py)

/opt/homebrew/bin/python3 \
  goal_runs_20260808/CHAR5_PROGRESSION_LOW_DEGREE/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/CHAR5_N5_SUPPORT_CERTIFICATE/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/CHAR5_PROGRESSION_CLOSE/verify_n5_support_unsat.py \
  --degree 6

/opt/homebrew/bin/python3 \
  goal_runs_20260808/CHAR5_PROGRESSION_CLOSE/N7_STATIC_CERTIFICATE/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/CHAR5_THREE_RESIDUE_BOUNDARY/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/CHAR5_THREE_RESIDUE_LIFTS_N8/verify_all.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/FULL_G_RESTRICTION_DOMINANCE/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/FULL_G_GRAPH_DEGREE_LOCALIZATION/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/FULL_G_C3_C5_GRAPH_LOCALIZATION/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/FULL_G_V4_SECOND_LAYER_CSP/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/DELTA1_MINIMAL_CLASS/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/DELTA1_EQUIVARIANT_DIAGONAL_OBSTRUCTION_AUDIT/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/DELTA1_RETRACTION_POLAR_IDENTITY/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/GENERIC_FIBER_STEIN_MORI/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/FULL_G_SUPERRIGID_SELFMAP_AUDIT/verify.py

/opt/homebrew/bin/python3 \
  goal_runs_20260808/DELTA3_S3_RESOLVENT_AUDIT/verify.py
```

Terminal markers and their strict scopes are documented in the corresponding
packet replay files.  Numerical homotopy output in
`OSCULATING_COVARIANT_COVER/NUMERICAL_PROBE.md` is deliberately not part of
the exact replay contract.  The degree-fifty three-residue replay is also
kept explicitly below proof-certificate grade because it has no DRAT/RUP
trace.
