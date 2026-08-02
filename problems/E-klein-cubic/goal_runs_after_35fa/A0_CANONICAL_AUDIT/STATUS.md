A0-CANONICAL-AUDIT-PASS

# A0 canonical implementation audit — final status

**Exit:** `A0-CANONICAL-AUDIT-PASS`  
**Headline:** OPEN (A0 is process, not Problem E)  
**Closed:** 2026-08-02

## Decision

Mandatory practical verifiers passed. The P25 verifier gap (4140/315
quartic nonmembership counts read from JSON only) is repaired by an
**independent sparse random-column projection FLINT certificate**:

| Quantity | Independent result | Expected |
|---:|---:|---:|
| `n_Ti_out_certified` | **4140** | 4140 |
| `n_comm_out_certified` | **315** | 315 |
| `rank_pi_G` | 25530 | full column rank of projected G |
| Projection-zero remainders | 0 | — |

Source: `verify_p25_bulk_projection_result.json`  
Log: `replay_p25_bulk_projection.log` (`DONE ok=1`, ~1592 s)

Soundness: a nonzero projected remainder certifies the original vector is
outside \(S_1\cdot V_0\). All 4140 + 315 tests produced nonzero remainders.

## Full deg-0 RREF abandoned

A full dense FLINT RREF of the **25530 × 91390** matrix
(`solve_deg0_flint`) was launched and reached `computing rref...` with no
further progress for ~1 h. That job was **killed** as a multi-hour resource
trap and is **not required** for A0 pass: the projection certificate already
independently establishes the 4140/315 map without reading stored booleans.

Log of killed job: `replay_p25_flint_full.log` (incomplete; nonverdict).

## Other replays

| Packet | Result |
|---|---|
| P25 structural 126 cubics | PASS (`replay_p25v0_structural.log`) |
| P25 support hygiene | PASS (`replay_p25v1.log`) |
| C CODEX_ROOT | PASS (`replay_c_codex.log`) |
| COV root + structured | PASS |
| F / D / H | PASS |

## Authority repairs

- C: canonical = `C_PFAFFIAN_FANO_CODEX_ROOT/`
- COV: exit semantics repaired to higher-order / named-ansatz only (not full degree empty)
- P25: 4140/315 may be consumed after this independent certificate

See `CANONICAL_STATE.md`, `REPLAY.md`, `SUPERSEDED_ARTIFACTS.md`, `SEAL.json`.
