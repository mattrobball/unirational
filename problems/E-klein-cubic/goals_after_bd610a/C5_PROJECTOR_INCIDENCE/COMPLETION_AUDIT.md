# Requirement-level completion audit

| Goal C5 requirement | Evidence | Verdict |
|---|---|---|
| Canonically merge exact inputs and quarantine the bad RUR | `INPUT_MANIFEST.json`; every consumed path has a SHA-256 hash; the historical namespace-mutated blob is not consumed | proved; no duplicate disagreement |
| Deterministic exact algebra API | `canonical_algebra.py`, `canonical_algebra_api.json`, upstream independent verifiers | proved at the accepted exact lazy-circuit scope |
| Installed left/right convention gate | `CONVENTION_AND_EQUIVALENCE.md`, `PROJECTOR_INCIDENCE.md`, `verify.py` | the proposed self-adjoint-idempotent equivalence is refuted by an exact unit certificate |
| Literal equation inventory | `projector_incidence.json` indexes all `36+36+1+180` equations | proved complete; the ideal is the unit ideal and is not the genuine Fano scheme |
| Correct genuine-Fano equivalence | `CORRECTED_INCIDENCE.md`, `corrected_incidence.json`, exact QQ ideal equality | proved: square-zero plus all five traces is the reduced degree-14 Pluecker section |
| Generic split equation system | `generic_pluecker_incidence.json`, builder, independent verifier | proved: five fully serialized hyperplanes, fifteen Pluecker quadrics, fifteen charts, fresh-prime replay |
| Intrinsic `K_proj` equation system | `morita_generic.md`, `morita_generic_dag.json`, builder, finite verifier | formula and complete inventory proved, but source leaves are prose descriptors and the verifier does not interpret every stored trace term generically |
| Independent split/Morita wiring | `morita_generic_split.md`, `morita_generic_split_dag.json`, builder, finite verifier | intended formulas agree at the accepted fibre; serialized split-transform nodes and generic source leaves are not independently interpreted |
| No discarded component/chart | fifteen Pluecker charts plus three normalized generic Morita charts | proved: geometric cover after splitting and every `K_proj`-line covered while generic `D` is division |
| Structural reduction | `corrected_incidence_geometry.json`; seven Singular jobs; two `p=23` seed verifiers | proved at `331,463,419`: smooth geometrically integral dimension-three degree-fourteen fibres; smooth seeds at `23` |
| Bounded descent-compatible searches | `DEGREE16_FANO_EXCLUSION.md`, `DESCENT_COMPATIBLE_ANSATZ_AUDIT.md`, independent verifiers | exact exclusions through homogeneous degree 16 and for the stated degree-17 sparse/short-word classes; explicitly not all-degree |
| Exact genuine Fano point | `STATUS.md`, `morita_generic.md` | not achieved; the simple residue point gives only an etale/formal lift |
| Exact rational-point obstruction or genuine-scheme emptiness | `EMPTY.md`, `THEORETIC_DESCENT_BOUNDARY.md` | not achieved; the genuine scheme is geometrically nonempty and pairwise descent does not solve all five forms |
| `BR-FANO-POS` headline | `BRIDGE_FANO_POS.md` | not applicable without a `K_proj`-point |

The literal inconsistency is

```text
S_x=1,  e^2-e=0,  e*S_x*e=0,  Trd(e)-2=0.
```

The repaired incidence is closed after splitting by a fully serialized
generic Pluecker system.  The intended descended Morita formulas are
convention-compatible and invariant, but their serialized leaves are not yet
an executable exact `K_proj` circuit, and record-level corruptions can escape
the named finite verifiers.

Accordingly the strongest listed and verified exit is

```text
C5-UNDECIDED
```

The missing gate is an exact generic source resolver/interpreter (or explicit
descent data) that consumes every serialized Morita record.  Modular seeds,
bounded covariant searches, and pairwise isotropy do not close that gate or
produce the Klein-cubic positive headline.
