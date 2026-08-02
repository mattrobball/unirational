# G3C replay

```sh
cd problems/E-klein-cubic
python3 -u goal_runs_after_0aecc89/G3C_LINE_CONIC_FANO/produce.py
python3 -u goal_runs_after_0aecc89/G3C_LINE_CONIC_FANO/verify.py
```

Optional G3A smoke:

```sh
python3 -u goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/verify_all.py
```

Expected:

```text
G3C_PRODUCE_OK
G3C_VERIFY_OK
G3C-UNDECIDED
HEADLINE-OPEN
```

(If a point is found, expect `G3C-POINT-PASS` and `POINT.md`.)
