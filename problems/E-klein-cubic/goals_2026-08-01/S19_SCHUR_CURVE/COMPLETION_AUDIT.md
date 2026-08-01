# Requirement-by-requirement completion audit

## Governing target and exit

| Requirement | Authoritative evidence | Decision |
|---|---|---|
| Work in an isolated folder | every new file is under `goals_2026-08-01/S19_SCHUR_CURVE/` | PASS |
| Use the live repository rather than the pinned baseline alone | source hashes and consumed commit `80f24697dd8fcb1ee0e8fff86e3d8e38a9cfc09c` are recorded; ancestry against the live head is checked | PASS |
| Construct the exact target or prove a permitted exact exit | the target-qualified functor is empty by two universal contradictions | SCOPED EXIT |
| Use `S19-NO-CURVE-SCOPED` only if both branches are empty | the verifier reads the authoritative Rao file, finds exactly `epsilon_0` and `epsilon_1`, and checks uniform coverage | PASS |
| Do not promote route closure to a headline theorem | `STATUS.md`, the payload, verifier, and seal all say `HEADLINE_OPEN` | PASS |

## Work packages

| Package | Required role | Evidence and status |
|---|---|---|
| S0 | re-audit every bridge arrow and repair missing hypotheses before Hilbert work | `BRIDGE.md` records all arrows and identifies proper intersection/noncontainment as a binding hypothesis incompatible with the exact target; COMPLETE |
| S1 | construct universal marked data if a curve search is reached | not reached: the contradiction holds for every marked scheme and every base change, so coordinates cannot affect the empty conjunction; DISCHARGED BY UNIVERSAL OBSTRUCTION |
| S2 | decide both Rao branches | `HILBERT_COMPONENTS.md` proves the literal goal-qualified subfunctor empty for both authoritative live branches; COMPLETE FOR THE BINDING TARGET |
| S3 | analyze carriers if a branch survives | no literal goal-qualified branch survives; the proof is independent of carrier/Picard data; NOT TRIGGERED |
| S4 | construct and verify a curve if a component survives | no literal component survives; NOT TRIGGERED |

## Exact target clauses

| Clause | Evidence |
|---|---|
| `C subset X_F cap M` | this is the first input to the ideal and component contradictions |
| geometric integrality | gives the independent one-component contradiction with Q3 |
| degree 19 | cannot repair containment; no degree is used by the universal contradiction |
| marked degree-55 incidence | cannot repair containment; the contradiction holds for every `Z` |
| correct field and descent | proof is over `F` and is stable under all base changes |
| residual degree two | impossible because `C cap X_F=C` is one-dimensional rather than length 57 |
| all `BR-SCHUR19-POS` open conditions | Q3 and Q4 are contradicted by containment |

## Output contract

| Artifact | Present | Verified role |
|---|---:|---|
| `STATUS.md` | yes | exact first-line exit and theorem boundary |
| `BRIDGE.md` | yes | S0 bridge ledger and incompatibility |
| `HILBERT_COMPONENTS.md` | yes | exact two-branch emptiness proof |
| emptiness payload | yes | `emptiness_certificate.json` |
| producer | yes | deterministic `produce_certificate.py` |
| independent verifier | yes | `verify.py` does not import producer code and recomputes both contradictions and branch coverage |
| `SEAL.json` | yes | hashes all deliverables except itself |

## Prohibitions

- No non-unirationality claim is made.
- No very-general carrier replaces a special carrier.
- No geometric object is promoted without descent.
- No abstract degree-55 coordinates are treated as expanded coordinates.
- No positive curve is claimed, so substitution is not bypassed.
- No Magma dependency is used.

## Verification evidence

The producer check and independent verifier both exit zero.  The verifier
recomputes the source hashes, exact live branch set, ideal absorption,
dimension contradiction, component contradiction, scope boundary, and content
seal.  Its final marker is `S19_NO_CURVE_SCOPED_VERIFY_OK` followed by
`HEADLINE_OPEN`.
