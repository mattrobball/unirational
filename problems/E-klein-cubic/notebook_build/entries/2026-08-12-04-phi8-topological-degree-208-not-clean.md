## 2026-08-12 The canonical tangent-residual self-map has topological degree 208, which is not a norm: phi_8 cannot be CLEAN

Packet: `goal_runs_20260812/SELFMAP_DETECTION/PHI8_DEGREE.md`
(`verify_phi8_degree.py`, 149 checks, `RESULT: PASS`, `EXIT=0`, ~175 s; exact
integers, `Fraction`, `F_p`, and msolve over `Q` and `F_p`; no floating point).
Problem E remains **OPEN**; no branch closes.

**The number.** `SELFMAP_AUDIT.md` §7 (B1) left `delta(phi_8)` uncomputed with
two named obstacles. Both are settled, and

```
        delta(phi_8) = 208 = 2^4 * 13,      delta(phi_9) = 288 = 2^5 * 3^2
```

exactly, by two independent routes that agree, at six targets, at two primes and
in characteristic zero.

**Obstacle (i) settled against the audit's expectation.** The degeneracy locus
`D_8 = {x in X : V_8(x) ^ x = 0}` is **not** a finite set. It is
one-dimensional: its one-dimensional part is a reduced curve of degree `72` (two
random hyperplane slices give 72 distinct points each), the saturated ideal has
Hilbert polynomial `72d + 147`, which forces an extra zero-dimensional part of
length at least 75, and over `F_23` the rational points of `D_8` are a single
`G`-orbit of size 60 at which `V_8` vanishes identically. The expected dimension
*is* zero — `V_8` is a section of `T_X(7)` with `int_X c_3(T_X(7)) = 1401` — so
the locus is excess, the line congruence `x |-> l_{x,V_8(x)}` is not a morphism,
and every naive Chern-class count is void.

**Obstacle (ii) settled.** In the incidence scheme `Z_y = {x : y in l_x}` the
always-present solution `x = y` has multiplicity exactly `2`: the differential of
`x |-> y mod span(x,V_8(x))` has rank 2 because `V_8(y)` lies in the affine
tangent space (that is the tangency `grad F . V_8 = 0 (mod F)`) and is not
proportional to `y`; equivalently `l_y . X = 2y + phi_8(y)`. Route A measures it:
`210` (minimal polynomial) against `209` (distinct points), and `208`/`208` once
`x = y` is also removed.

**Route A** localizes the determinantal incidence scheme away from the excess
curve by inverting a random combination of the ten `2x2` minors of `[x ; V_8]`,
and finds `209` points with one double point. **Route B** parametrizes
`y ~ x + t V_8(x)` with `t != 0` and `Q(x,V_8) != 0` — the second constraint is
what certifies each solution is a genuine preimage under the degree-`25` tuple
`R`, since `F(x+tV) = t^2(Q + tF(V))` on `X` — and finds `208`. Both are solved
in all five **flag** charts, so the fiber count is complete rather than sampled;
charts 1--4 are empty every time. `210 - 2 = 208`.

**The detection test fires.** `13` is inert in `Q(sqrt(-11))` (`13 mod 11 = 2`,
a non-residue) and `v_13(208) = 1` is odd, so `208` is **not** represented by
`x^2 + xy + 3y^2`; likewise `288` with `v_2 = 5` and `2` inert. By
`THEOREM_RESTRICTED_DICHOTOMY.md` Theorem 3.1 neither `phi_8` nor `phi_9` can be
CLEAN, and the same holds for every odd iterate of `phi_8` and for
`phi_8 o phi_9`. Hence, via (S2) of `THEOREM_DETECTION_PRINCIPLE.md`: **if the
retraction branch is nonempty then the normalized graph of `phi_8` must carry a
CARRIER block** on a proper irreducible `T` inside `Bs(J_{phi_8})` with
`dim T <= 1` and the `(AHS-Gamma)` Hom condition. Before today both halves of
the lever were open; one is now closed, and the retraction branch is a pure
CARRIER question on an explicitly computed curve.

**What is not claimed.** CARRIER is **not** excluded — the primary
decomposition, genera and CM data of `Bs(J_{phi_8}) = D_8 ∪ {l_x ⊂ X}` are not
computed, and the sealed `j = 8192/11` non-CM data belongs to the `V14` fixed
network, not to this base locus, so it does not apply. `delta = 208` is
unconditional as a lower bound; the matching upper bound holds for a target off
an at-most-two-dimensional bad locus, and six independent targets (three
rational, three random over `F_p`, `p ~ 10^6`) all give `208`. No named target
is *proved* generic; that is the single caveat.

**Two by-products.** `V_8` and `V_9` are boxed over `Q` with integer
coefficients (40 and 60 terms per component, max `|coefficient|` 24 and 406),
closing blowup point (B5); their `iota`-covariance is certified in
characteristic zero by eleven primes above `10^18` together with an explicit
archimedean height bound. And a tool warning that cost a full cycle: **msolve's
parser does not understand parentheses** — `(3)*x1^2*x2` is silently mis-read
and the solver then reports "no solution" for systems with obvious solutions.
The first run of the degeneracy computation said "empty", which would have given
`delta = 1753` — and `1753 = 1^2 + 1*24 + 3*24^2` **is** a norm, so the format
bug would have produced a CLEAN-compatible verdict and buried the lever. Every
system is now emitted fully expanded, and block (C) of the verifier carries a
live regression test for the mis-parse.

Exits: `MINIMAL-EQUIVARIANT-TANGENT-FIELD-BOXED-OVER-Q`,
`DEGENERACY-LOCUS-ONE-DIMENSIONAL-DEGREE-72`,
`TANGENCY-DOUBLE-POINT-MULTIPLICITY-TWO`, `PHI8-DELTA-COMPUTED`,
`PHI9-DELTA-COMPUTED`, `PHI8-NOT-CLEAN`, `PHI9-NOT-CLEAN`,
`RETRACTION-BRANCH-CARRIER-ONLY`, `CARRIER-EXCLUSION-NOT-ACHIEVED`.
`Problem E headline: OPEN.`
