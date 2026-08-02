G3H-SEMILINEAR-G3-FRAME-PASS

# Goal G3H status — A5 semilinear Springer

**Primary exit:** `G3H-SEMILINEAR-G3-FRAME-PASS`  
**Headline:** OPEN  
**Consumed commit:** `d1f43d6e393618412dfbe223e9f828a64509f629`  
**Pinned main (target):** `eb21458bea684d2399ad18f003e2be8ebdd161ce`

## Phase markers

| Phase | Marker | Status |
|---|---|---|
| 1 G7B quarantine | `G3H-G7B-QUARANTINE-PASS` | PASS |
| 2 Cubic compression | `G3H-CUBIC-COMPRESSION-PASS` | PASS |
| 3 Semilinear landing | `G3H-SEMILINEAR-LANDING-PASS` | PASS |
| 4 G3 frame | `G3H-SEMILINEAR-G3-FRAME-PASS` | PASS |
| 5 Quadratic Springer | `G3H-QUADRATIC-SPRINGER-REDUCTION-PASS` | NO |
| 5 interface decision | `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED` | PASS |
| 5n a_i dual expansion | `G3H-AI-EXPANSION-DUAL-PASS` | PASS |
| 5n secondary beta tables | `G3H-AI-SECONDARY-TABLE-OPEN` | RESIDUAL |
| 5n L_i-point on K_proj quadric | `G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN` | RESIDUAL |
| 5n Springer map-back | `G3H-SPRINGER-MAPBACK-OPEN` | RESIDUAL |

## Decision

1. **Quarantine–landing–frame (phases 1–4).** Unchanged; sealed.
2. **Expand a_i.** Dual-trace / Vandermonde power-basis calculus installed for
   both A5 classes (`G3H-AI-EXPANSION-DUAL-PASS`). Fully cancelled secondary
   numerators of the beta_{r,k} remain residual (`G3H-AI-SECONDARY-TABLE-OPEN`).
3. **Polar data.** A=Phi(q), second-polar L, first-polar M fully
   secondary-expanded over K_proj. C,D installed as L_i-polynomials in a_i
   with those structure constants.
4. **L_i-point hunt.** No certified L_i-point on a K_proj quadratic from (q,a_i).
5. **Springer.** Checklist items 2 and 4 open; scoped no-go reaffirmed. Illegal
   cubic odd-degree descent rejected. No map-back; no headline.

## Theorem boundary

- Not a Problem-E headline.
- Does not claim X_gen(K_proj) nonempty.
- Does not rehabilitate e0 coset orbits.
- Dual-trace expansion is exact as a determination of beta_{r,k} in K_proj;
  cancelled secondary tables of those beta are residual.
- See `phase5_springer_next/` and `THEOREM_BOUNDARY.md`.

## Resources

- Peak RSS (phase5_next producer): 66.0 MB
- Wall time (phase5_next producer): 0.33 s
- Python: 3.14.6

## Replay

See `REPLAY.md` (includes phase5_next).
