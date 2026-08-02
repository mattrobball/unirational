# Requirement-level completion audit

| Goal C5 requirement | Evidence | Verdict |
|---|---|---|
| Canonically merge exact algebra inputs and quarantine the bad RUR | `INPUT_MANIFEST.json`; every consumed path has a SHA-256 hash; the historical bad blob is recorded as unnamed/absent and no modular RUR is consumed | proved for the selected inputs; no duplicate disagreement |
| Deterministic exact lazy algebra API | `canonical_algebra.py`, `canonical_algebra_api.json`, upstream C0/C1/five-plane verifiers | proved at the accepted lazy Cramer-circuit scope; no expanded multiplication tensor |
| Prove the installed left/right convention equivalence | `CONVENTION_AND_EQUIVALENCE.md`, `verify.py` | refuted: the proposed self-adjoint-idempotent equivalence is false |
| Build the literal self-adjoint idempotent incidence | `projector_incidence.json` indexes all `36+36+1+180` equations with none discarded | exact unit ideal; not the genuine Fano incidence |
| Correct genuine-Fano incidence | `CORRECTED_INCIDENCE.md`, `corrected_incidence.json`, exact QQ ideal-equality replay | exhaustive intrinsic model and complete lazy equation/chart inventory; coefficients remain source-circuit descriptors rather than a serialized expanded `K_proj` polynomial system |
| Structural reduction and finite-fibre data | `corrected_incidence_geometry.json`; seven Singular inputs/transcripts; `verify_corrected_incidence.py`; `MODULAR_SEED_P23.md`; `MORITA_SEED_P23.md` | exact theorem at `331,463,419`: smooth geometrically integral dimension-three degree-fourteen sections; exact smooth installed and Morita-coordinate seeds at `23` |
| Exact genuine Fano point | `STATUS.md`, repository-wide candidate audit | not achieved; no accepted candidate satisfies all five equations |
| Exact emptiness of the genuine Fano scheme | `EMPTY.md` | not achieved; only the misencoded projector scheme is empty |
| `BR-FANO-POS` headline bridge | `BRIDGE_FANO_POS.md` | not applicable |

The exact inconsistency is

```text
S_x=1,
e^2-e=0,
eS_xe=0,
Trd(e)-2=0.
```

Its degree-zero unit certificate is replayed independently.  The corrected
model repairs the convention and exposes the full genuine geometry, but it
does not supply a `K_proj`-point or a characteristic-zero saturation
certificate.  Because Goal C5's point/empty branch remains unresolved, and
because the corrected generic coefficient system is retained only as lazy
source circuits, `C5-EXECUTABLE-FULL-INCIDENCE` is not promoted.

The strongest honest authorized exit is therefore `C5-UNDECIDED`, with the
decisive subtype `C5_CONVENTION_GATE_FAIL`.  Neither the full user objective
nor the Klein-cubic headline is complete.
