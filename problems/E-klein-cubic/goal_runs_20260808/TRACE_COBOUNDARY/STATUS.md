# Status

```text
F55-TRACE-NO-PROPER-CONJUGATE-SUBSUM
F55-TRACE-CYCLIC-SPAN-AT-LEAST-THREE
F55-TRACE-RANK3-PAIRWISE-COPRIME-CASE-EXCLUDED
F55-TRACE-RANK3-PAIR-DIVISOR-ESCAPE
F55-TRACE-RANK-THREE-AND-FOUR-OPEN
F55-GLOBAL-QUESTION-OPEN
```

The theorem and rank-three addendum are all-support and all-degree.  They use only exact UFD
factorization, the order-eleven cokernel row, and a three-term
or four-term Mason--Stothers argument after an analytically chosen generic torus coset.
It contains no support enumeration.

Replay the convention and local-boundary checks with:

```sh
cd /Users/worker/unirational/problems/E-klein-cubic
python3 goal_runs_20260808/TRACE_COBOUNDARY/verify.py
```

Expected final marker:

```text
F55-TRACE-COBOUNDARY-RANK3-BOUNDARY-OK
```

The replay is a regression check, not a machine proof of the Laurent
power-pencil lemma.
