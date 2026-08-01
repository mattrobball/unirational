# Completion audit against Goal D2

| Requirement | Evidence | Verdict |
|---|---|---|
| Consume the post-`35fa8f` packet | `STATUS.md` records pinned and live commits; `THEOREM_AUDIT.md` uses the new D2 requirements | proved |
| Do not reuse Goal D's refuted invariant | Goal D is used only as a countermodel and multiplier boundary; the selected class is the broader additive stack/Mackey candidate | satisfied |
| D2.0: define a precise invariant | `INVARIANT_DEFINITION.md` gives four exact axioms | proved |
| Defined on quotient stack/twist | restriction-natural Mackey class and torsorwise formulation are explicit | proved for the selected candidate |
| Relative-dimension-one functoriality | candidate families are tested against `r i = n id`; no false retraction is asserted | audited; requirement fails |
| Stable under actual blowups | stack operations and cobordism corrections require centre data; no unsupported invariance theorem is claimed | audited; requirement fails |
| Not annihilated by `n` | `COUNTERMODELS.md` realizes every positive multiplier | requirement fails |
| Sensitive after index one | `SYLOW_DETECTION.md` proves the additive candidate is zero | requirement fails |
| Early stopping rule | no large computation or bounded centre sweep was launched after D2.0 failed | satisfied |
| Every named candidate direction audited | `THEOREM_AUDIT.md` sections 2--8 | proved |
| D2.1 free-orbit centre tested | `ADMISSIBLE_CENTRE_CLOSURE.md` section 2 | proved |
| Do not equate unrestricted and admissible closure | boundary stated explicitly | satisfied |
| Exact calculations | CRT idempotents, Sylow indices/inverses, index certificate, scaling exponent in `invariant_payload.json` | proved |
| Independent verifier | `verify.py` recomputes arithmetic, candidate boundary, and hashes | proved after replay |
| Exact exit | first line of `STATUS.md` is `D2-NO-VALID-BRIDGE` | proved |
| Headline boundary | `OPEN` in status and payload | satisfied |
| No Magma | Python standard library only | satisfied |
| Required output path | all durable artifacts lie in `goal_runs_after_35fa/D2_STACK_INVARIANT/` | proved after copy audit |
| Seal without self-hash/timestamp | `seal.py` hashes the complete required set and excludes `SEAL.json` | proved after replay |

## Scope audit

`D2-NO-VALID-BRIDGE` means no candidate in the audited directions meets all
D2.0 requirements at the consumed state.  It does not mean that all future
nonadditive invariants are impossible.  The precise surviving design target is
recorded in `STATUS.md`.
