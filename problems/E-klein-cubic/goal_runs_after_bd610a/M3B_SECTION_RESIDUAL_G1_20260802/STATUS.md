M3B-G1-MODULAR-NONEMPTY-PASS

# Goal M3B status — residual G1 degree-4 section gate

**Exit:** `M3B-G1-MODULAR-NONEMPTY-PASS`  
**Headline:** OPEN  
**Section question over \(K_{\mathrm{Schur}}\):** still UNDECIDED  
**Parent exit (unchanged):** `M3-INTEGRAL-DEGREE4-MULTISECTION`  
**Consumed commit:** `7030ddafb53acdea23070b0d9d20050b592ceb1b`

## Decision

Gate G1 (saturated \(H\)-degree-4 section scheme) is now executable at the
sealed good primes \(p=23\) and \(p=67\):

- 13 cubics in 19 projective coefficients expanded from the exact Reynolds
  frame reduction;
- sealed parent residual witnesses are gcd-free, kill all 13 equations, and
  have Jacobian rank 13.

Thus G1 is **nonempty over those finite fields**.  This is **not** a
characteristic-zero / \(K_{\mathrm{Schur}}\) section and is not
headline-positive.

## Remaining

Decide whether the same locus is nonempty over \(K_{\mathrm{Schur}}\), or
produce any other \(K\)-section (exceptional / higher \(d\equiv 1\pmod 3\)).

## Replay

See `REPLAY.md`. Independent marker: `M3B_G1_VERIFY_OK`.
