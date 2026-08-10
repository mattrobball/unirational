# Replay

```text
$ cd /Users/worker/unirational/problems/E-klein-cubic
$ /opt/homebrew/bin/python3 goal_runs_20260808/TRACE_POSITIVE/verify_analytic.py
F55-TRACE-ANALYTIC-LEMMAS-OK
$ python3 goal_runs_20260808/TRACE_COBOUNDARY/verify.py
F55-TRACE-COBOUNDARY-RANK3-BOUNDARY-OK
```

The command performs only fixed-size integer and sparse-polynomial checks.
It also checks the forty fixed Fourier minors, the ten pair congruences, and
the five deletion budgets from the rank-three addendum.  There is no CAS
search.
