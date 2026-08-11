# STAGE1_TIGHTEN — status

**Problem E headline: OPEN.** No degree is excluded by this packet.

| | |
|---|---|
| opened | 2026-08-11 |
| main document | `THEOREM.md` |
| replay | `python3 verifier.py` (both primes) |
| markers | `STAGE1_TIGHTEN_VERIFY_OK` / `ALLGREEN` |

## Deliverables

1. **Saturation theorem** (`Θ = 6`) — discharges `STAGE1_COMPLEX_MAPS` §15.6(1).
   The stratum-coherent count `1 088 847 395 778 723 840 000` is now certified as
   the all-multidegree count.
2. **Residue-indexed count.** The covariant degree enters the order-0 `σ`-band
   through exactly two rows (the dimension-3 divisors, the only ones whose slots
   exhaust `W`). `σ`-band factor `K(0 mod 6) = 10 752`, `K(2) = K(4) = 672`
   against the degree-blind `43 008`. Combined with `STAGE2`'s `3⁸` and the new
   `D10`-row split `23 → 13 or 10`:
   `917 070 336` (`d ≡ 0`), `57 316 896` (`d ≡ 2, 4`).

## Open / flagged

* **The odd residues return 0** and are **not claimed** (§2.5). Four audit
  targets and a recommended independent rebuild are stated there. This is the
  packet's single most important caveat.
* `STAGE2`'s `3⁸` and `STAGE1`'s component indexing are consumed, not rebuilt.
