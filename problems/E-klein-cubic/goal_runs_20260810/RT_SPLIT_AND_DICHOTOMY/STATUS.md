# RT split, restricted dichotomy, and support escape — status

Problem E remains **OPEN**.

## Exit ledger

```text
RESTRICTED-DICHOTOMY-PROVED
RESTRICTED-CARRIER-BRANCH-PROVED
RESTRICTED-CLEAN-CM-NORM-PROVED

CLEAN-CASE-TRANSFER-UNDECIDED

POINT-SUPPORT-CHARACTERIZED
SUPPORT-ESCAPE-UNDECIDED

SXX-LOCAL-REES-UNDECIDED
```

## One-line boundary for each task

1. **Restricted graph:** the canonical unit--trace projector for
   `pi:Gamma->X` gives an intrinsic CARRIER/CLEAN dichotomy.  In the CLEAN
   branch the exceptional correction vanishes and
   `u_phi^dagger u_phi=delta` on `V`; hence
   `delta=x^2+xy+3y^2`.
2. **Support not contained in `X`:** Artin vanishing proves the required
   cohomology injection for exactly `j_0>=0`, and finite normalization causes
   only additional proper-support summands.  CT1 is nevertheless false in the
   exact normalized toric model `I=(x,y)(x,y,t)`; the divisor over
   `S=(x,y)` is disjoint from the dominant transform `t=0`.
3. **Point/free support:** refined Bézout kills no orbit-size cell in the
   unconditional live window `d>=31`.  A point block is necessarily the
   `j_0=-1` channel and forces a weight-three stabilizer subrepresentation in
   fiber intersection cohomology, without any finiteness assertion for the
   target map of that fiber.
4. **`S subset X`:** the unit-minor branch normalizes to the toric blowup of
   `(F,h^m)` and its base-change map is the Gysin map from `S`; the requested
   `psi_h` of an already isolated vertical strict-support block is actually
   zero.  The rank-one/degenerate Rees branch and nonvanishing of the Gysin
   map remain unproved.
5. **Fixed carriers:** held.  No type-I/type-II enumeration is resumed.

## Exact checks

```text
python3 verify_norm_sieve.py
python3 verify_degree_accounting.py
python3 verify_local_rees.py
```

All three use exact integer arithmetic and pass.
