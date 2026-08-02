# Replay

From this directory:

```sh
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  ../../goals_2026-08-01/Q_SCHUR_DESCENT/verify_q0.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  ../../goals_2026-08-01/Q_SCHUR_DESCENT/verify_zero_cycle_ledger.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  exact_schur_frame/verify_all.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  a5_valuation_elimination/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  run_f55_covariants.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  verify_f55_covariants.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  f55_degree6_degree7/verify_certificate.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  f55_degree8/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  f55_degree9/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  h_trace_two_laurent/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  h_trace_fourier_pair_k/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  h_trace_three_kummer_planes/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  h_trace_three_kummer_laurent/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  h_trace_four_kummer_laurent/verify_all.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  h_trace_plane_012_jacobian/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  f55_all_degree_boundary/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  schur_enq_v14/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  full_schur_palatinian/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  fixed_curve_bridge/verify_bridge_cases.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify_all.py
```

Expected terminal markers:

```text
Q_SCHUR_Q0_LEDGER_EXACT
Q_SCHUR_ZERO_CYCLE_LEDGER_EXACT
Q_SCHUR_EXACT_FRAME_INDEPENDENT_REPLAY_OK
Q_SCHUR_EXACT_FRAME_PACKET_VERIFY_ALL_OK
Q_SCHUR_A5_VALUATION_ELIMINATION_OK
Q_F55_ALL_PROJECTIVE_CHARACTERS_DEGREE_LE_5_EXACT
Q_F55_ALL_PROJECTIVE_CHARACTERS_INDEPENDENT_REPLAY_OK
F55_STANDALONE_CYCLOTOMIC_REPAIR_OK
F55_DEGREE6_DEGREE7_CERTIFICATE_INDEPENDENT_REPLAY_OK
F55_DEGREE8_SINGLETON_CERTIFICATE_INDEPENDENT_REPLAY_OK
F55_DEGREE9_SINGLETON_CERTIFICATE_INDEPENDENT_REPLAY_OK
H_TRACE_TWO_LAURENT_ALL_EXPONENT_EXCLUSION_OK
H_TRACE_FOURIER_TWO_BASIS_FULL_K_NEWTON_EXCLUSION_OK
H_TRACE_THREE_KUMMER_TEN_GENERIC_SMOOTH_OK
H_TRACE_THREE_KUMMER_LAURENT_MONOMIAL_ALL_EXPONENT_EXCLUSION_OK
H_TRACE_PLANE_012_FISHER_JACOBIAN_OK
H_TRACE_HILBERT_NEWTON_AUDIT_OK
Q_SCHUR_ENQ_V14_AUDIT_EXACT_NONTERMINAL
FULL_SCHUR_CHAR0_PALATINI_PACKET_OK
Q_SCHUR_FIXED_CURVE_BRIDGE_EXACT
Q_SCHUR_INDEX_ONE_PACKET_VERIFY_ALL_OK
```

The four-Kummer child replay emits
`Q_11_5_FOUR_KUMMER_PACKET_VERIFY_ALL_OK`.

The source-bound Q0 replays reconstruct the exact `D12` line orbit and both
degree-3/55 index ledgers.  Their scripts, payloads, and exact cyclotomic
group model are SHA-bound in `SOURCE_MANIFEST.json`.  The end-to-end replay
also checks the exact genuine-Schur frame and full 35-coefficient cubic table,
both exact `A5` landing maps and their valuation bridge, then reconstructs all
25 complete landing ideals in a temporary directory without importing the
producer, reruns Singular, and checks the degree-6/7/8/9 support
certificates, all four sparse trace exclusions, all ten three-Kummer
genus-one restrictions, the exact `C_012` Fisher invariants and Jacobian, the
exact all-degree boundary, the ENQ--`V14` audit, the full-Schur Palatini model,
and the fixed-curve bridge.
It also verifies the imported degree-3/55 ledger, `11:5`
normal form, provenance distinctions, decision nonclaims, and seal.

The degree-nine replay is intentionally expensive: it regenerates the 11 MB
instance in a temporary directory and exhausts all 26912397 deletion states.
The recorded independent terminal replay took `1:05:10.6` (`3910.6` seconds).
