R0-CANONICAL-REFRESH-PASS

# Goal R0 status — canonical live-ledger refresh

**Exit:** `R0-CANONICAL-REFRESH-PASS`  
**Headline:** OPEN (R0 is process only; not a Problem E decision)  
**Consumed commit:** `7030ddafb53acdea23070b0d9d20050b592ceb1b`

## Decision

Live orientation and machine-readable state now match post-G2 / post-V3 /
post-B reality:

- G3 is the primary arithmetic headline target on `V(Phi)`.
- G2 structural and V3 mechanics are sealed, not open missions.
- B is terminal at `B-BRIDGE-REFUTED` and absent from active dispatch.
- C5 live text points at the corrected alternating-form / Plücker model.
- T3 points at local-runner directories, not scratch alone.
- H5 sealed run (`H5-UNDECIDED`) and A0 PASS are recorded; M3 conflict markers
  were already cleared at `5d7e686`.

## Replay summary

| Check | Result |
|---|---|
| G_UNIVERSAL/verify.py | PASS (`G2_UNIVERSAL_VERIFIER_ACCEPT`) |
| V3 verify.py | PASS (`V3_VALUATION_RESIDUE_CLOSEOUT_OK`) |
| H5 verify.py | PASS (`H5_INDEPENDENT_VERIFY_OK`) |
| B full verify.py | FAIL (C5 STATUS pin string drift) |
| B payload/seal subcheck | PASS |
| A0 full projection | NOT re-run (~1592s); result JSON subcheck PASS (4140/315) |

## Deliverables

See this directory: INPUT_MANIFEST.json, CANONICAL_STATE.md, canonical_state.json,
SUPERSEDED_STATUS.md, REPLAY.md, verify.py, SEAL.json, STATUS.md.

Live ledger edited: `REMAINING_GOALS_NOTE.md` only. Historical seals untouched.
