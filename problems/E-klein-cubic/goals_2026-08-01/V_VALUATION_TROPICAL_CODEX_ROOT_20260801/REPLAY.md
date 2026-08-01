# Exact replay

Run from `problems/E-klein-cubic/goals_2026-08-01` with the repository's
accepted exact-twist inputs present.

## Rebuild payloads

```sh
/opt/homebrew/bin/python3 -u \
  V_VALUATION_TROPICAL_CODEX_ROOT_20260801/produce_axis_divisors.py
/opt/homebrew/bin/python3 -u \
  V_VALUATION_TROPICAL_CODEX_ROOT_20260801/produce_hessian_line.py
```

The axis producer uses Macaulay2 only for discovery/certification of the
saved gradient-ideal dimensions.  It has no Magma dependency.

## Independent verification

```sh
/opt/homebrew/bin/python3 -u \
  V_VALUATION_TROPICAL_CODEX_ROOT_20260801/verify_axis_divisors.py
/opt/homebrew/bin/python3 -u \
  V_VALUATION_TROPICAL_CODEX_ROOT_20260801/verify_hessian_line.py
/opt/homebrew/bin/python3 -u \
  V_VALUATION_TROPICAL_CODEX_ROOT_20260801/verify_tropical_rank_one.py
```

The axis verifier independently uses Singular, exact interpolation, and the
accepted literal Hilbert--90 reconstruction.  The Hessian verifier rebuilds
the symbolic identities without importing its producer.  The tropical
verifier reconstructs the exact support and checks the universal finite
combinatorics behind the rank-one Newton-edge proof.

## Packet and seal

```sh
/opt/homebrew/bin/python3 -u \
  V_VALUATION_TROPICAL_CODEX_ROOT_20260801/verify.py
```

Required terminal marker:

```text
V_VALUATION_TROPICAL_PACKET_ACCEPT
```
