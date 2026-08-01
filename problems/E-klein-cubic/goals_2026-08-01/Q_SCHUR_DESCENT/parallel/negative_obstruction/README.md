# Negative-obstruction parallel audit

This directory is a read-only synthesis of the installed negative routes for
`GOAL_Q_SCHUR_INDEX_ONE_DESCENT.md`.  It writes no result into the sibling
packets it audits.

The main new theorem is a valuation narrowing for the actual Schur field:
every valuation of rational rank at least four is locally soluble.  More
generally, a local nonpoint can occur only for an unramified valuation whose
residue field has transcendence degree at least two and whose decomposition
group is one of

```text
PSL(2,11), A5 (embedding class 1), A5 (embedding class 2), 11:5.
```

This is a strict structural reduction, not pointlessness of the generic
Schur twist.  See `THEOREM.md` and `STATUS.md` for the proof boundary.

`THEOREM_SEARCH.md` audits the strongest nearby point theorems for the
surviving residue-transcendence-degree `2` and `3` cases.  It records the
exact rational-simple-connectedness and `C_i` numerical failures, and the
finite-isotrivial descent interface, without promoting them to a headline
verdict.

Replay from `goals_2026-08-01`:

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 \
  Q_SCHUR_DESCENT/parallel/negative_obstruction/verify.py
```

Expected marker:

```text
Q_NEGATIVE_OBSTRUCTION_INTERFACE_ACCEPT
```
