# Completion audit

| requirement | result | evidence / boundary |
|---|---|---|
| Degree selection | complete | `DEGREE_RANKING.md`, `degree_ranking.json`; first `e>=7`, `e=1`, `e=5` representatives included |
| Exact full self-covariant source | complete | exact Reynolds labels in each `covariant_basis_seeds.json`; dimensions 189, 410, 637 match the exact Molien series; independence checked at two good fibres |
| Full COV0 equalizer and primitive quotient | not completed | plane restriction and common-line maps were computed at two fibres, but the complete characteristic-zero triple/point/`C3`/elliptic equalizer and primitive quotient remain |
| Global structured ansätze | complete for the named families | composition frame, invariant-gradient cross products, and their full mixed spans retain one global coefficient vector |
| Landing solve | exact and complete for the named families | cubic coefficient ranks plus zero quartic dual at two valid primes; integral proper-specialization bridge |
| Positive candidate certification | not applicable | no candidate survived; no claim of primitivity, dense-open definition, or Jacobian rank four |
| Independent verification | complete | `verify_ansatz.py`, `verify_cross_ansatz.py`, `verify_combined_ansatz.py`, `verify_global_modules.py`, orchestrated by `verify_all.py` |
| Output contract | complete in the user-mandated local folder | status, ranking, three degree directories, machine payloads, producers, verifiers, input manifest, and content seal |

## Exit audit

- `COV-EXPLICIT-HEADLINE-POSITIVE`: not reached; no candidate.
- `COV-STRUCTURED-DEGREES-EMPTY-SCOPED`: not reached; the full selected degree
  spaces were not eliminated.
- `COV-NEW-ANSATZ-STRUCTURAL`: reached; a new exact arrangement-native
  cross-gradient construction and its mixed composition span were built and
  eliminated, and all higher plane-order branches were excluded in the three
  selected degrees.
- `COV-UNDECIDED`: superseded by the structural exit, although the overarching
  positive headline remains open.

The goal packet's historical output path is superseded only by the user's
explicit instruction to isolate this agent's work in a new folder under the
active directory.  Nothing was written outside `COV_STRUCTURED_SEARCH/`.
