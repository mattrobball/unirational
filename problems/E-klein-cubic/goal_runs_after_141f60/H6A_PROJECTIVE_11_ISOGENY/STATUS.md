H6-PROJECTIVE-11-ISOGENY-PASS

# Goal H6A status — projective degree-11 torus isogeny (H6.0)

**Exit:** `H6-PROJECTIVE-11-ISOGENY-PASS`  
**Headline:** OPEN (structural; not a Problem-E decision)  
**H4 input:** `H-11_5-NORM-MODEL-PASS`  
**Consumed commit:** `7030ddafb53acdea23070b0d9d20050b592ceb1b`

## Decision

Installed and independently verified:

1. Group-ring identity `(2+sigma)B = 11 - N`.
2. Degree-11 isogeny `phi([a])=[a^2 sigma(a)]` on the projective norm torus
   (`det` on the augmentation lattice).
3. Dual operator and inverse-up-to-`[11]`.
4. Scalar-vs-projective split `33=3*11`.
5. **Kernel / Galois module:** etale `mu_11`, coker `Z/11Z` with `C5` acting
   by multiplication by unit `9` (order 5); geometric exponents
   `c=(5,3,4,9,1)`; resolvent `X^11-1` with `sigma(X)=X^9`.
6. **H4 field binding:** sealed `field_model.json` / `norm_model.json` loaded;
   product-one `psi` samples rebuilt.

## Out of scope

H6.1 trace-hyperplane torsor, constructive lanes, valuation obstruction, and
point/pointless headlines.

## Replay

See `REPLAY.md`. Marker: `H6A_VERIFY_OK`.
