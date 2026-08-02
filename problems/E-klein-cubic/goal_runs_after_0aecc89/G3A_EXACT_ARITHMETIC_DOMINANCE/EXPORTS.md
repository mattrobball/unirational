# Exports

| Consumer | Path |
|---|---|
| Python field API | `src/field_api.py` |
| Python Phi API | `src/phi_api.py` |
| Field table (bound) | `tmp/kproj_arithmetic/normalized_kproj_table.json` |
| Phi coefficients (bound) | `goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json` |
| Compact Phi ledger | `phi_exact.json` |
| Field model JSON | `field_model.json` |
| Dominance ledger | `dominance_bridge.json` |

Sparse Magma/Macaulay2 consumers should load the normalized 12×12 table JSON
(78 products) rather than expanding unrelated Pfaffian or target-branch
objects.  The affine un-normalized table
`tmp/kproj_arithmetic/affine_multiplication_table.json` remains available for
graded lifts.
