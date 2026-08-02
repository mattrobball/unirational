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
  a5_degree11_cycle_next/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  degree11_secant_descent_agent/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  incidence_splitting/verify_a5_rnc_chart.py

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
  full_trace_tropical_obstruction_next/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  c012_oneparam_section_agent/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  f55_all_degree_boundary/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  schur_enq_v14/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  full_schur_palatinian/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  full_schur_palatinian_point_next/verify_seal.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  full_schur_palatinian_point_next/verify.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  full_schur_palatinian_point_next/verify_degree9_projective_emptiness.py

env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \
  full_schur_palatinian_point_next/verify_three_frame_slice.py

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
Q_SCHUR_EFFECTIVE_DEGREE11_ZERO_CYCLE_VERIFIED
A5_DEGREE11_ALL_SIX_SECANT_DESCENT_AUDIT_OK
Q_SCHUR_A5_DEGREE11_RNC_INCIDENCE_EXACT
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
H_TRACE_CONSTANT_FIVE_COORDINATE_TWO_BASIS_EXCLUSION_OK
C012_ONE_PARAMETER_BOUNDED_STOP_OK
H_TRACE_HILBERT_NEWTON_AUDIT_OK
Q_SCHUR_ENQ_V14_AUDIT_EXACT_NONTERMINAL
FULL_SCHUR_CHAR0_PALATINI_PACKET_OK
FULL_SCHUR_PALATINIAN_POINT_NEXT_STRICT_SEAL_OK
FULL_SCHUR_TEN_PENCIL_IRREDUCIBILITY_REPLAY_OK
FULL_DEGREE9_CHAR0_PALATINI_LANDING_EXCLUSION_REPLAY_OK
FULL_SCHUR_CANONICAL_THREE_FRAME_SLICE_REPLAY_OK
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
the effective degree-11 cycle, six-root quadric/secant audit, and exact RNC
incidence gate, then reconstructs all 25 complete landing ideals in a
temporary directory without importing the
producer, reruns Singular, and checks the degree-6/7/8/9 support
certificates, all sparse and constant trace exclusions, all ten three-Kummer
genus-one restrictions, both exact `C_012` packets, the exact all-degree
boundary, the ENQ--`V14` audit, both full-Schur Palatini packets, and the
fixed-curve bridge.
It also verifies the imported degree-3/55 ledger, `11:5`
normal form, provenance distinctions, decision nonclaims, and seal.

The degree-nine replay is intentionally expensive: it regenerates the 11 MB
instance in a temporary directory and exhausts all 26912397 deletion states.
The recorded independent terminal replay took `1:05:10.6` (`3910.6` seconds).
