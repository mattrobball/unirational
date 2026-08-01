# Replay

From `problems/E-klein-cubic/goals_2026-08-01` run:

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 \
  Q_SCHUR_DESCENT/parallel/negative_obstruction/verify.py
```

The verifier checks every consumed repository input by SHA-256, independently
recomputes the degree-3/degree-55 Bezout identity, imports the exact
all-rank inertia statements from Goal V's machine-readable payload, checks
the five-dimensional Abhyankar rank table, and binds the current exhaustive
proper-subgroup boundary.

Expected final marker:

```text
Q_NEGATIVE_OBSTRUCTION_INTERFACE_ACCEPT
```

For the follow-up primary-theorem applicability audit, run:

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 \
  Q_SCHUR_DESCENT/parallel/negative_obstruction/verify_theorem_search.py
```

Expected final marker:

```text
Q_RESIDUE_THEOREM_SEARCH_ACCEPT
```

The Graber--Harris--Starr theorem is a cited mathematical input, not a finite
calculation.  The verifier checks that its application and the nonterminal
scope are present; it does not purport to machine-prove that external
theorem.
