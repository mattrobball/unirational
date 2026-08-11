## 2026-08-10 The sextic on the V14 and the plane cubic on the Klein are the same curve

Packet: `goal_runs_20260810/PHI_SEXTIC_ISOGENY/`; verifier ALLGREEN (fresh
primes 419, 617), exact char 0 over `K = Q(zeta_11)`.

**Theorem 1.** `j(C_sigma) = 8192/11 = j(E_sigma)` exactly. The genus-one
sextic `V14 cap P(M_+)` and the Klein plane cubic `X cap P(W_sigma^+)` are
ISOMORPHIC over `C` — the modular relation is `Phi_1`, degree 1, not a higher
isogeny. Neither has CM. Independently re-derives FIX-A0's sealed `8192/11`
from `Pf6` on `Lambda^4 U`.

**Theorem 2.** The isomorphism can be chosen equivariant for the residual
`S3 = C_G(sigma)/<sigma>`: `rho` is a translation by a 3-torsion point on each
curve, `tau` an inversion, and the distinguished order-3 subgroups correspond.
Verified at 12 split primes by an explicit pointwise check of `F(g.P)=g.F(P)`.

**Theorem 3.** `X^sigma` has no `S3`-fixed point, so `Phi|_{C_sigma}` is never
constant; it either maps onto `E_sigma` with degree a square `n^2`, `3` not
dividing `n`, or onto `L_sigma = P^1` with degree divisible by 3 (both occur).

**Theorem 4.** The two isolated `sigma`-points of the `V14` must go to the two
`rho`-fixed points of the line `L_sigma`.

Exits: `PHI-SEXTIC-ISOGENY-VERDICT-POS`, `PHI-SEXTIC-S3-ISOMORPHIC`,
`PHI-RESTRICTION-CLASSIFIED`, `PHI-ISOLATED-POINTS-TO-LINE`.

Not claimed: any explicit `Phi`; `G`-equivariance beyond the residual `S3`;
the conditional degree remark. `PHI-ODD-DEGREE-RAMIFICATION-FORCED` is NOT
claimed — the ramification corollary was conditional on non-isogeny, and the
verdict is positive. Headline status unchanged: OPEN.
