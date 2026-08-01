# Q Schur descent run

This directory contains only the work for `GOAL_Q_SCHUR_INDEX_ONE_DESCENT.md`.
No sibling goal-run artifacts are modified.

The binding completion boundary is binary: either certify a rational point on
the genuine generic Schur twist and the versal bridge, or certify pointlessness
of that same twist by an obstruction that remains valid at index one.  Scoped
computations are recorded as such and are not promoted to a headline result.

Current packet map:

- `ZERO_CYCLE_LEDGER.md` and `OBSTRUCTION_LEDGER.md`: exact Q0 audit;
- `QUARTIC_FRONTIER.md`: point-or-primitive-quartic theorem boundary,
  splitting-field audit, and cubic-resolvent descent;
- `BIRATIONAL_MODELS.md`: nonexhaustive model ledger;
- `COVARIANT_ATTACK.md`: exact degree-12 landing computations and their scope;
- `COMPLETION_AUDIT.md`, `completion_audit.json`, and
  `verify_completion_audit.py`: requirement-level verdict and consistency
  certificate for the surviving proof gaps;
- `parallel/negative_obstruction/`: exhaustive local-obstruction interface;
- `parallel/quartic_descent/`: primitive quartic and linked-quintic audit;
- `parallel/root_secant/`: exact counterexamples to universal resolvent
  collinearity;
- `parallel/curve_incidence/`: rational-curve incidence counts and their
  specialization boundary;
- `parallel/incidence_generality/` and `parallel/incidence_splitting/`: exact
  generic-resolvent dominance and the independent eight-curve splitting gap;
- `parallel/fixed_curve_bridge/`: the exact implication from an actual
  descended odd-degree stable map or Hilbert point to a point of the twist;
- `parallel/constructive_point/`: constant-Krylov exclusions and the
  Gross--Popescu equivariance audit;
- `REPLAY.md`: commands and terminal markers.

There is deliberately no `SEAL.json`: neither permitted binary exit has been
proved.
