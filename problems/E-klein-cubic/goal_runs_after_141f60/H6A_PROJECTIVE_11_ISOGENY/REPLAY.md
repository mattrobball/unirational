# H6A replay

```sh
cd problems/E-klein-cubic
python3 -u goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY/produce_isogeny.py
python3 -u goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY/verify_isogeny.py
```

Optional H4 smoke:

```sh
python3 -u goal_runs_after_35fa/H_11_5_TWIST/verify.py
```

Expected:

```text
H6A_PRODUCE_ISOGENY_OK
H6A_VERIFY_OK
H6_PROJECTIVE_11_ISOGENY_PASS
HEADLINE-OPEN
```
