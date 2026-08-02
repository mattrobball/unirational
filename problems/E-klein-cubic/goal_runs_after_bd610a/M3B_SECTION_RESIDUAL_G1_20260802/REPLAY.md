# M3B replay

```sh
cd problems/E-klein-cubic
python3 -u goal_runs_after_bd610a/M3B_SECTION_RESIDUAL_G1_20260802/produce_g1.py
python3 -u goal_runs_after_bd610a/M3B_SECTION_RESIDUAL_G1_20260802/verify.py
```

Expected markers:

```text
M3B_G1_PRODUCE_OK
M3B_G1_VERIFY_OK
M3B-G1-MODULAR-NONEMPTY-PASS
SECTION_QUESTION_STILL_UNDECIDED
HEADLINE-OPEN
```

Parent residual gate (optional smoke):

```sh
python3 -u goals_after_bd610a/M3_SARKISOV_SECTION/verify_residual_gate.py
```
