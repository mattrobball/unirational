# Source ledger

## Binding local sources

- `goals_after_35fa8f/GOAL_S19_MARKED_CURVE_CONTINUATION.md`: work order and
  exact exit contract.
- `certificates/exact_weil_check.py`: exact `Q(zeta_11)` Klein
  representation and 660-element Cayley consistency.
- `tmp/schur_degree19_structural_design_audit/`: hostile audit of the
  degree-55 Hilbert function and the hyperplane-selected scope.
- `tmp/schur_degree19_nonacm_attack_audit/`: hostile audit of the two
  smooth-rational Rao ledgers, the unique quintic carrier, and the precise
  Noether--Lefschetz/liaison boundary.
- `certificates/schur_krylov/`: earlier semilinear/Krylov reduction; consumed
  only as a boundary, not as a curve certificate.

## Literature boundary

Brevik--Nollet, *Noether--Lefschetz theorem with base locus*,
<https://arxiv.org/abs/0806.1243>, concerns very-general surfaces containing
a base locus.  This packet does not promote such a statement to control the
special carrier selected by an unknown curve.  The binding local hostile
audit additionally records failure of the relevant global-generation
hypothesis in this quintic family.

No external theorem is used for the normal-bundle splitting bounds in
`PROOF_REPORT.md`; the argument there follows directly from the Euler,
normal, and conormal sequences on `P1`.

