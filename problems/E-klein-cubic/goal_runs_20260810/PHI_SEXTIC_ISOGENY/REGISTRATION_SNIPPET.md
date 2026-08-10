# Proposed NOTEBOOK.md registration (do not apply here — director applies)

Two concurrent sessions could race on `NOTEBOOK.md` and
`notebook_build/manifest.json`, so neither file was touched by this packet.
Below: the proposed dated section (20 lines) and the proposed manifest record.

## Dated section — insert in `problems/E-klein-cubic/NOTEBOOK.md`

```markdown
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
```

## Manifest record — append to `notebook_build/manifest.json` `records`

```json
{
 "path": "goal_runs_20260810/PHI_SEXTIC_ISOGENY",
 "entry": "E56",
 "kind": "goal_run",
 "verification_class": "ALGEBRAIC-RECOMPUTE",
 "primary_exit": "PHI-SEXTIC-ISOGENY-VERDICT-POS",
 "superseded_by": null,
 "char0_scope": "Theorem 1 (j(C_sigma) = j(E_sigma) = 8192/11) is EXACT char 0 over K = Q(zeta_11), both curves, two independent j routes each; Theorems 2-4 are analytic plus a mod-p decision at 12 split primes p = 1 mod 11 (67..727), which is decisive for Theorem 2 by the good-reduction / 3-torsion-injectivity / Isom-torsor argument stated in REPORT.md section 4; independent brute-force sweeps of P^2(F_p) at every prime and of P^5(F_23) for the sextic",
 "tracked": "main",
 "notes": "Rebuilds BOTH genus-one curves inside one program from the FIX-IX-SEAL Weil model: C_sigma = V14 cap P(M_+) via a tau-adapted 4+2 split of M_+, the 3 tau-odd quadrics as a 3x2 matrix A(v), Cramer parametrisation nu(s,t) of the twisted cubic C_sigma/tau, and the branch quartic R(s,t) (three independent normalisations agree), giving C_sigma: c^2 = R(s,t); E_sigma = {Pf6 = 0} cap P(Ann(M)^{sigma,+}) in tau-adapted coordinates, where Pf6 = z^2 L(u) + C(u) IS a Weierstrass equation. VERDICT POSITIVE and stronger than isogeny: the two curves are ISOMORPHIC (j equal exactly), and S3-equivariantly so. Consequences: Phi|_{C_sigma} is never constant (X^sigma has no S3-fixed point); its degree is n^2 with 3 not dividing n onto E_sigma, or divisible by 3 onto L_sigma; and the two isolated sigma-points of V14 are forced onto the two rho-fixed points of L_sigma. The task's conditional PHI-ODD-DEGREE-RAMIFICATION-FORCED corollary is explicitly NOT claimed, its non-isogeny hypothesis having failed. By-products: independent re-derivation of FIX-A0's j = 8192/11, of L_sigma lying on X, and of the faithful S3 on P(W^-). Formula layer self-tested on known curves (binary-quartic j vs cross-ratio, Weierstrass j, the whole extraction pipeline on |6.O| models of y^2 = x^3+ax+b, Phi_2 on genuine 2-isogenous pairs). Headline unchanged: OPEN."
}
```
