# Status

The full-group restriction question has a theorem-level answer:

* every dominant
  \(\operatorname{PSL}_2(\mathbf F_{11})\)-equivariant rational map
  \(\mathbf P(W)\dashrightarrow X\) restricts to a dominant generically
  finite rational selfmap \(X\dashrightarrow X\);
* the proof uses primitivity, simplicity/no fixed point, and the exact lower
  bound \(\operatorname{ed}_{\mathbf C}(G)\geq3\);
* if the restriction has degree one, full-\(G\) superrigidity and the trivial
  centralizer make it the identity, so the ambient map is a rational
  \(G\)-retraction;
* if the restriction is a morphism, Beauville forces this degree-one branch;
* the surviving case is a degree-greater-than-one rational selfmap with
  nonempty invariant base locus which also satisfies the ambient landing
  identity.

No audited rigidity, endomorphism, cohomological, or invariant-divisor
theorem excludes the surviving case.  A bounded covariant calculation is
not an all-degree verdict because finite quartic precomposition produces
unbounded coordinate degrees conditional on one landing map.

```text
FULL-G-RESTRICTION-DOMINANT
FULL-G-DEGREE-ONE-IMPLIES-RATIONAL-RETRACTION
FULL-G-AMBIENT-RATIONAL-DEGREE-GREATER-ONE-GATE-OPEN
FULL-G-GLOBAL-QUESTION-OPEN
```

Replay from `problems/E-klein-cubic`:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/FULL_G_RESTRICTION_DOMINANCE/verify.py
```
