# Replay

Run from `problems/E-klein-cubic`:

```bash
python3 goals_2026-08-01/F_CONIC_ALGEBRA/verify_field_presentation.py
python3 goals_2026-08-01/F_CONIC_ALGEBRA/verify_infinity_obstruction.py
python3 goals_2026-08-01/V_VALUATION_TROPICAL/verify_inertia_centralizers.py
python3 goal_runs_after_35fa/V_GENUINE_VALUATION/verify_ramification.py
python3 goal_runs_after_35fa/V_GENUINE_VALUATION/verify.py
```

Expected terminal markers from the V2 packet are:

```text
PASS exact Cramer valuations nu(u)=-1, nu(t)=2, nu(vcoord)=0
PASS scaled affine mu3 cover has (e,f)=(3,1) and is disjoint from the genuine G-cover
PASS fixed residual index 3 is scope-separated from genuine residual index 1
V2-FIXED-FRAME-PLACE-NONTRANSFERABLE
```

The verifiers read the accepted sparse matrix directly, reconstruct the
Cramer determinants independently, hash-check every pinned stable upstream
input, audit the locally snapshotted incidence, residual-index, and candidate
ledgers, and finally check the local seal.  They do not import a producer.
