# WP-Z — director gate report

**Author:** director session.
**Date:** 2026-07-30.
**Order:** `WORKORDER_STRATA_LIFTING_BLOCKERS.md`, Part VII.
**Base:** `617443f`.

## Ranking selected

Of the four rankings the order permits, the evidence selects exactly one:

> **4. All three survive** — document the exact survivors and reassess the
> positive Pfaffian construction rather than launching another unstructured
> negative sweep.

Rankings 1-3 are explicitly **not** selected: no nonlinear lifting
obstruction is active, the target-branch mod-3 gate is not near closure, and
no Hodge-center numerical contradiction is visible.  Per the order's closing
instruction, no route is promoted merely because its computation is largest.

**Headline: OPEN.**  Nothing below claims otherwise.

## What was run, and what each route returned

| Route | Result | Marker |
|---|---|---|
| WP-R0 category repair | corrected; state space `>=` legacy; **no** negative from the repair | `ALL WP-R0 VERIFICATIONS PASSED` |
| WP-L1 polar tower to `3m+3` | universal equations certified for arbitrary `(m,d)` | `ALL WP-L1 VERIFICATIONS PASSED` |
| WP-L2 obstruction tower | **Exit L-P** — no family killed | `WP_L2_TOWER_SEALED` |
| WP-E1 `Pic^0` obstruction | order-twelve trace recovered; does **not** kill live families | `WP_E1_PICARD_SEALED` |
| WP-H1 Hodge centers | necessity confirmed; **40** surviving `(H,rho)`; no budget violation | `WP_H1_HODGE_VERIFY_OK` |
| WP-T1 mod-3 class group | **NOT DECIDED**; slice critical locus is positive-dimensional | `TARGET_BRANCH_MOD3_VERIFIER_ACCEPT` |

## The exact survivors

**Lifting families** (all three corrected WP-5 survivors live, through the
first two nonautomatic free-module stages):

```text
based_minus_lines_odd_m
residual_e1_swap_both
residual_e_ge7_generic_swap_both
```

Formal parameters `(a_m, b_{m+1} in ker L_1, a_{m+2})`; next obstruction
module `omega_3` as a sheaf on the rank-drop/special fibres.  These are
**formal states, not covariants** (house rule 3).

**Hodge channels:** 40 surviving `(H,rho)` pairs; every strata subgroup type
retains a channel with `Hom_H(H^{2,1}|_H, rho) != 0`.  Genus, orbit size,
plane-degree floor and cohomological weight are tabulated per channel in
`certificates/hodge_centers/character_screen.json`; all envelopes exceed 5.

**Mod-3 gate:** neither the vanishing of the three-primary defect nor a
dangerous class.  The local all-orders identity `P in (P_A,P_B,P_Y)_m`
remains open.

## Why the negative program has stalled — the structural reading

This is the part worth carrying forward.  Each route now has a *certified
reason* for stopping, and they agree:

1. **No linear obstruction can exist.**  WP-5 established that residual
   plane jets grow as `O(d^2)` while equalizer targets grow as `O(d)`, so the
   linear inverse limit is nonzero for every odd `m` and all large `d`.  This
   is permanent, not pending more computation.
2. **The nonlinear tower does not bite at the first two stages** for any
   family, and the tower has not been shown periodic (`L-F` unproved), so
   finitely many stages cannot currently be leveraged into an all-degree
   statement.
3. **The one genuine `Pic^0` obstruction we possess is ansatz-specific.**
   The order-twelve quadratic trace is a real theorem — the class lives in
   `E[3] subset Pic^0` and its independence is proved — but the residue
   ledger shows only the `(4,4,4)` term is `q`-free, which is exactly why it
   closes the old Fable ansatz and not these families.
4. **The Hodge screen is a necessary condition with wide slack.**  Linear
   and point centers give `H^1 = 0`, so a lift must manufacture
   positive-genus curves or irregular surfaces — but 40 channels remain and
   no numerical budget is violated.
5. **The mod-3 gate is blocked by geometry, not by resources.**  The slice
   critical locus is positive-dimensional (dimension 1, degree 14, exact over
   `QQ`), which is why the pointwise local-identity route cannot close it.

Taken together: the Klein cubic resists every structural negative attack we
have been able to pose, and we now know *why* in each case rather than
merely that each attempt failed.

## Directed next step

Per ranking 4, the negative program should **not** be extended by another
unstructured sweep.  The reassessment target is the positive Pfaffian
construction, whose gate is a single well-posed arithmetic question:

> does the residual genus-one curve carry a `K_proj`-point?

Accepted context for that route (from the concurrent track): Brauer class
period `=` index `=` 2; a rank-two idempotent exists abstractly; `alpha_R in
R^x/(R^x)^3` is explicit; `D3` and `D5` are both closed as local
obstructions, `D5` by an exact constant point; `[K_proj : C(A,B,Y,Z)] = 6`
with `S6` monodromy and no proper intermediate fields; cheap escapes (rational
flex, rational 3-torsion, anisotropic member, support `<= 2`, all 455
support-3 slices) are all excluded.

Two guards recorded before any headline claim on that route:

1. the CFOSS `w1`-injectivity citation must be pinned;
2. the "common isotropic line `=>` headline positive" conditional must be
   re-verified end to end against its source chain.

## Boundary

No obstruction to `G`-unirationality of the Klein cubic was found by this
work order.  No formal state produced here is a landing covariant, and no
result here bears on `ed_C(G)` in either direction.  **Problem E remains
OPEN.**
