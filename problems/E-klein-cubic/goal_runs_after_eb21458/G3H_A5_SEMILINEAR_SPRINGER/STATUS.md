G3H-SEMILINEAR-G3-FRAME-PASS

# Goal G3H status — A5 semilinear Springer

**Primary exit:** `G3H-SEMILINEAR-G3-FRAME-PASS`  
**Headline:** OPEN  
**Phase5 BLS:** `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED` (Route-1 **KILL** via Q_q)  
**Consumed commit:** `d6862836f2c6198ec1ed95a6627b70f168260beb`  
**Pinned main (target):** `eb21458bea684d2399ad18f003e2be8ebdd161ce`

## Phase markers

| Phase | Marker | Status |
|---|---|---|
| 1 G7B quarantine | `G3H-G7B-QUARANTINE-PASS` | PASS |
| 2 Cubic compression | `G3H-CUBIC-COMPRESSION-PASS` | PASS |
| 3 Semilinear landing | `G3H-SEMILINEAR-LANDING-PASS` | PASS |
| 4 G3 frame | `G3H-SEMILINEAR-G3-FRAME-PASS` | PASS |
| 5 Quadratic Springer | `G3H-QUADRATIC-SPRINGER-REDUCTION-PASS` | NO |
| 5 interface decision | `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED` | PASS (KILL) |
| 5n a_i dual expansion | `G3H-AI-EXPANSION-DUAL-PASS` | PASS |
| 5bls secondary beta | `G3H-AI-SECONDARY-TABLE-OBSTRUCTION` | PASS (obstruction) |
| 5bls L_i-point | `G3H-LI-POINT-ON-KPROJ-QUADRATIC-CLOSED-NO` | PASS (NO) |
| 5bls Springer map-back | interface-killed (G3P residual) | KILL |

## Decision

1. **Phases 1–4.** Unchanged; sealed.
2. **Secondary beta tables.** Dual-trace calculus retained. Cancelled secondary
   12-vectors blocked by exact obstruction `DEGREE-33-REYNOLDS-SECONDARY-EXPANSION`.
   Gate `G3H-AI-SECONDARY-TABLE-OPEN` closed as obstruction.
3. **L_i-point on Q_q.** NO for the attempted family: non-containment
   X_gen not subset Q_q; D=0 not forced; Springer quadratic-form
   theorem gives Q_q(L_i) <=> Q_q(K_proj) (G3P residual).
   Gate `G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN` closed NO.
4. **Springer.** Checklist items 2 and 4 fail with proofs. Route-1 via Q_q
   **killed** as an interface. No map-back; no headline; illegal cubic descent rejected.

## Theorem boundary

- Not a Problem-E headline.
- Does not claim X_gen(K_proj) empty or nonempty.
- Does not claim Q_q(K_proj)=empty.
- Does not rehabilitate e0 coset orbits.
- See `phase5_beta_li_springer/` and package `THEOREM_BOUNDARY.md`.

## Resources

- Peak RSS (phase5_bls producer): 64.1 MB
- Wall time (phase5_bls producer): 0.12 s
- Python: 3.14.6

## Replay

See `REPLAY.md` (includes phase5_beta_li_springer).
