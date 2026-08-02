G3A-ARITHMETIC-DOMINANCE-PASS

# Goal G3A status — exact arithmetic and dominance bridge

**Exit:** `G3A-ARITHMETIC-DOMINANCE-PASS`  
**Headline:** OPEN (structural; not a Problem-E decision)  
**Parent structural input:** `G2-FINITE-GENERATION-PASS`  
**Consumed commit:** `7030ddafb53acdea23070b0d9d20050b592ceb1b`

## Decision

1. **Field.** Exact rank-12 `K_proj/P0` arithmetic over `QQ(t3,t6,t8,t11)` with
   certified structure constants, inverses recording `det L_v` opens, and
   independent hostile checks (`verify_field.py`).
2. **Phi.** All 35 coefficients independently reconstructed against
   `generic_cubic.json` with weight/normalization identities
   (`verify_phi.py` → `phi_exact.json`).
3. **Smoothness.** Settled by twisting the smooth Klein cubic; specialized
   Jacobian consistency check only.
4. **Dominance.** `G3-DOMINANCE-AUTOMATIC` — a later exact `K_proj`-point of
   `V(Phi)` yields a dominant equivariant map with no extra rank-four gate
   (`DOMINANCE_BRIDGE.md`, `dominance_bridge.json`).

No point search was performed.

## Replay

See `REPLAY.md`. Marker: `G3A_VERIFY_ALL_OK`.
