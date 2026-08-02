# R0 replay log

Consumed commit: `7030ddafb53acdea23070b0d9d20050b592ceb1b`

## Commands run

```sh
python3 -u goal_runs_after_35fa/G_UNIVERSAL/verify.py
# -> G2_UNIVERSAL_VERIFIER_ACCEPT / G2-FINITE-GENERATION-PASS

python3 -u goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/verify.py
# -> V3_VALUATION_RESIDUE_CLOSEOUT_OK

python3 -u goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/verify.py
# -> H5_INDEPENDENT_VERIFY_OK

python3 -u goal_runs_after_35fa/B_FIXED_FRAME_EXHAUSTIVENESS_20260802/verify.py
# FULL FAIL: AssertionError C5 threefold source pin absent
# (goals_after_bd610a/C5_PROJECTOR_INCIDENCE/STATUS.md text drifted;
#  string "dimension three and degree fourteen" absent)

# B independent payload subcheck (authorized by R0.2):
python3 -c "..."  # see scratch r0_replay/B_subcheck.log -> B_SUBCHECK_OK

# A0 full bulk projection NOT re-run (~1592s). Subcheck:
# verify_p25_bulk_projection_result.json: ok, 4140, 315
# UNREPLAYED:
python3 -u goal_runs_after_35fa/A0_CANONICAL_AUDIT/verify_p25_bulk_projection.py
```

## Markers

- **G_UNIVERSAL:** `{'result': 'PASS', 'marker': 'G2_UNIVERSAL_VERIFIER_ACCEPT'}`
- **V3:** `{'result': 'PASS', 'marker': 'V3_VALUATION_RESIDUE_CLOSEOUT_OK'}`
- **H5:** `{'result': 'PASS', 'marker': 'H5_INDEPENDENT_VERIFY_OK'}`
- **B_full_verify:** `{'result': 'FAIL', 'error': 'C5 threefold source pin absent (STATUS text drift)'}`
- **B_payload_subcheck:** `{'result': 'PASS', 'marker': 'B_SUBCHECK_OK'}`
- **A0_full_projection:** `{'result': 'NOT_RERUN', 'reason': '~1592s FLINT; result JSON subcheck used'}`
- **A0_result_subcheck:** `{'result': 'PASS', 'marker': 'A0_PROJECTION_RESULT_SUBCHECK_OK', 'n_Ti': 4140, 'n_comm': 315}`

## Policy

Mathematical exits are not taken from STATUS alone when a verifier fails. B exit `B-BRIDGE-REFUTED` is retained only after payload/seal subcheck and STATUS/SEAL agreement; full upstream pin replay is recorded as FAIL.
