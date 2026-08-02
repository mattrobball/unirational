# Replay

From this packet directory run:

```sh
PYTHONDONTWRITEBYTECODE=1 python3 verify.py
```

Expected terminal marker:

```text
Q2_1_DESCENT_OBSTRUCTION_AUDIT_ACCEPT
```

The verifier checks the exact `3/55` Bezout identity, source blob bindings,
nonterminal goal status, scoped exit, valuation survivor list, theorem
markers, and Git blob SHA-1 seal.  It does not machine-prove the cited
Grothendieck--Lefschetz or Jodi Black theorems; those are named mathematical
inputs whose hypotheses are stated in the theorem file.
