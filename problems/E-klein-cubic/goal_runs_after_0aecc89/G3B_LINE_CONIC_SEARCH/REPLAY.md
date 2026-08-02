# G3B replay

```sh
cd problems/E-klein-cubic
python3 -u goal_runs_after_0aecc89/G3B_LINE_CONIC_SEARCH/produce_g3b.py
python3 -u goal_runs_after_0aecc89/G3B_LINE_CONIC_SEARCH/verify.py
```

Optional G3A smoke:

```sh
python3 -u goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/verify_all.py
```

Expected:

```text
G3B_PRODUCE_OK
G3B_VERIFY_OK
G3B-UNDECIDED
HEADLINE-OPEN
```
