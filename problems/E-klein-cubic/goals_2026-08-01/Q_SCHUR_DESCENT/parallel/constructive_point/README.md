# Constructive-point subtask

No `K_proj` or `K_Schur` point was found.

- `KRYLOV_ANSATZ.md` records two new, exact, full-five-coordinate but
  coefficient-restricted `K_proj` exclusions.
- `GROSS_POPESCU_AUDIT.md` closes the tempting level-11 moduli/intertwiner
  shortcut at the precise equivariance boundary.
- `probe_kproj_krylov.py` produces the exact finite-field systems and result
  JSON files.
- `verify_kproj_krylov.py` semantically replays the stored rows, ranks,
  homogeneous ideals, `msolve` leading ideal, and Hilbert functions.
- `verify_gross_popescu_boundary.py` checks the central-character and
  dimension facts that distinguish a nonexistent linear `6 -> 5` map from
  the actual `15 -> 15` intertwiner.

These artifacts are scoped negative results.  They do not cross the
unrestricted rational-point boundary in either invariant field.
