# Source ledger

## Binding sources

- `goals_after_35fa8f/GOAL_S19_MARKED_CURVE_CONTINUATION.md`, pinned state
  `35fa8f59b6a1423cc89300aeaceefe91552be5ba`;
- parent packet `CODEX_ROOT_20260801_7B4E`, especially
  `universal_marked_family.json` and its seal;
- `certificates/exact_weil_check.py`, the pinned exact Klein representation.

The repository commit consumed is
`37d61c19a108781cf74af837e24810a9f7f7c3be`.  Exact source hashes are stored
in the machine payloads and `SEAL.json`.

## Computation boundary

- exact cyclotomic arithmetic uses `Q(zeta_11)` in the basis
  `1,zeta,...,zeta^9`;
- modular reconnaissance uses `(p,zeta)=(397,256)`;
- the two-transversal chart audit uses `(p,zeta)=(67,64)` and Singular over
  the algebraic closure through minimal-prime membership;
- finite-field outputs are never substituted for a characteristic-zero
  curve, component, or emptiness theorem.
