# Artifact inventory

- `STATUS.md` — exact exit and smallest remaining theorem.
- `BRIDGE.md` — `BR-SUBGROUP-NEG`, generic torsors, Hilbert--90 frames, and
  exact twist equations.
- `VALUATION_INDEX.md` — H-A through H-D results and theorem boundaries.
- `A5_class_1/`, `A5_class_2/`, `FROB_11_5/`, `D12/`, `A4/`, `D10/` — one
  status directory per selected subgroup class.
- `a5_twist_payload.json` — concrete generators, two nonconjugate class
  audit, exact-formula frames, good-reduction matrices, and twist
  coefficients.
- `a5_low_degree_search.json`, `a5_degree5_7_search.json`, and
  `a5_degree8_9_search.json` — complete homogeneous A5 landing schemes
  through degree nine.
- `degree4_function_field.json` — geometric factorization certificate for
  the complete degree-four two-column function-field line.
- `a5_covariant_line_search.json` — all ten lines of a full five-column
  covariant frame, including cubic constant-extension factorizations.
- `11_5_twist_payload.json` — exact maximal Frobenius-subgroup twist and
  index payload.
- `subgroup_sweep_payload.json` — machine-readable decisions, index
  witnesses, valuation outcomes, and smallest unresolved twist.
- `build_a5_twists.py`, `low_degree_search.py`,
  `a5_degree5_7_search.py`, `a5_degree8_9_search.py`,
  `probe_degree4_function_field.py`, `a5_covariant_line_search.py`, and
  `build_11_5_twist.py` — deterministic producers.
- `verify.py` — independent reconstruction, including a second-prime frame
  check and exact contained-line checks.
- `SOURCES.md` — literature and local exact inputs.
- `SEAL.json` — content hashes, excluding itself and transient bytecode.

Every artifact produced by this worker is contained in this directory.
