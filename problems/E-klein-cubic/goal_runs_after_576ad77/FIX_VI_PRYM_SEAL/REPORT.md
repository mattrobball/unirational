# FIX-VI-PRYM-SEAL — report

**EXIT: `FIX-VI-PRYM-SEAL-ALLGREEN`** — main run 24/24 PASS, independent verifier
24/24 PASS, verifier covers every main-run check name (`scripts/parity.py`).
Reproduce: `sh run_all.sh`. Logs: `results/checks.log`, `results/verifier.log`.

## Engines / wall time

| stage | engine | time |
|---|---|---|
| A / B / C | python3 + sympy 1.14.0, mpmath 1.3.0 (dps 60–80) | 0.1 / 0.0 / 0.1 s |
| independent geometry | Macaulay2 1.26.06 over `toField(QQ[y]/(y^2-33))` | 0.3 s |
| `verifier.py` | sympy + mpmath + M2 re-run | 0.7 s |

msolve deliberately unused (per brief). The main run models K = Q(√33,√−3) faithfully in
dimension 4 (basis 1, √33, √−3, √−99; sympy `Rational` coefficients), so every zero-test
is component-wise rational equality, never a `simplify()` heuristic. Floats appear only
in the stated numeric cross-checks.

## Checks — 24/24, all PASS

| brief items | checks (all PASS) |
|---|---|
| frame, 1, 2 | `trace_relations` `product_22` `restriction_identity` `omega_conic_factorisation` |
| 3, 4, 5 | `param_on_conic` `sextic_degree` `sextic_coeffs_agree` `tau_involution` `tau_preserves_roots` |
| 6, 7 | `evenness` `cubic_squarefree` |
| 8, 9, 10 | `j_plus_exact` `j_minus_exact` `j_plus_equals_j_minus` `s_pairing_numeric` `j_plus_numeric` `j_minus_numeric` |
| 11, 12 | `j_not_arrangement` `cm_minus_11` |
| 13, 14, 15 | `genus_Esigma` `j_Esigma_numeric` `six_intersection_points` `rh_arithmetic` `m2_independent_geometry` |

Headline exact values: **j(E₊) = j(E₋) = −32768**, both rational in K (route 1); numeric route 2 agrees to **≥ 66 digits** (main run 76; ≥ 40 required). **j(E_σ) = 8192/11** exactly, with S = −3/8, T = −13/256, S³−27T² = −729·11/65536 — the 11 enters via the quartic discriminant. For E_σ ∩ K_c the *b*-coordinates are the three cube roots of ρ = −(283+21√33)/256, reproduced independently by M2's elimination ideal `bb^3 + 21/256 y + 283/256`.

Verifier independence (shares no code with `scripts/`): different base point for the K_c parameterisation ((1,2) not (0,2)), hence a different sextic, a different involution τₙ = (n−4)/(n−1) and different fixed points 1±√−3; restriction identity by an x-resultant rather than reduction mod the conic; Aronhold I,J instead of S,T; j(E_σ) from an exact cross-ratio reduced mod β³ = −κ₊/κ₋; Eisenstein E4³/(E4³−E6²) instead of E4³/Δ for the CM value.

## Deviations / notes

1. **Normalisation, not a discrepancy.** sympy's `cancel` clears the 1/16 in κ±, so
   its sextic numerator is 16× (t-side) resp. 8× (n-side) the brief's closed form.
   Recorded in both runs; roots and all downstream claims are unaffected.
2. **M2 engine limit.** `radical` has no applicable strategy over
   `toField(QQ[y]/(y^2-33))` in M2 1.26. Reducedness is instead established by the
   stronger, directly relevant Jacobian-rank criterion: V(I + minors₂) is empty, i.e.
   all 6 intersection points are transverse.
3. **Two defects found in my own verification code and fixed** (inputs untouched): (a)
   the `mpmath.kleinj` cross-check used the wrong normalisation — mpmath returns j/1728,
   now calibrated in-script by kleinj(i)=1, kleinj(ρ)=0; (b) the verifier's numeric block
   mistranscribed a coefficient (−12·Kp in the n³ slot instead of n⁴), failing 4 checks
   until the polynomial was rebuilt from its factors by convolution. Both were caught by
   the checks, not worked around.
4. **Scope of the j-equality.** j(E₊) = j(E₋) = −32768 gives an isomorphism over K̄
   only; the quadratic-twist class over Q(√33,√−3) is *not* determined here.
5. **Not claimed** (cited anchors, unverified): the Prym isogeny decomposition itself
   (Beauville admissible-cover theory), Kollár's theorem, Roulleau Thm 2. Item 15 is
   arithmetic bookkeeping asserted as formulas, not geometry.
6. h(−11) = 1 by reduced-form enumeration (sole form (1,1,3)); with j numerically −32768
   to ≥ 60 digits and an algebraic integer of degree h = 1, H₋₁₁(X) = X + 32768. No
   Hilbert-class-polynomial library was used or needed.
