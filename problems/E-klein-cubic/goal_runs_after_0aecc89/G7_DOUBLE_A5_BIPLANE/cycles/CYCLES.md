# G7.3 — induced double cycles (REDO residual)

## Materialization status: RESIDUAL

No well-defined G3-frame coordinates for the two degree-11 induced cycles are
installed. Primary residual gate:

```text
need L_H cocycle coordinates from H_A5 formula in G3 frame (no well-defined H-fixed cone lift; rho(g)·e0 refuted)
```

## Why not `rho(g_i)·e_0`

The withdrawn construction

```text
p_i = ρ(g_i)·e_0,   e_0 = (1:0:0:0:0)
```

is representative-dependent: `|Stab_G([e_0])|=11`, so `H ⊈ Stab([e_0])`.
Coset well-definedness fails; equivariance `ρ(g)p_i ~ p_{g·i}` fails 44/44.

See `INDUCED_CYCLE_REFUTATION.md` and `audit_induced_refutation.py`.
Historical artifact: `cycles_WITHDRAWN_rho_e0.json` (non-consumable).

## What is installed (structural)

For each A5 class:

1. Coset action `s_perm`, `t_perm` of image order 660 (from sealed H_A5 gens).
2. Binding to H_A5 `point.json` formula path (degree-11 Reynolds / frame map).
3. Abstract G4 induction theorem (L_H, Gal-stable unordered 11-set).
4. Explicit list of **required** checks for a future pass (well-definedness,
   equivariance, landing, descent proof object, Galois agreement, incidence).

## What is NOT installed

- No 22 correct G3-frame 5-tuples.
- No `defined_over_K_proj: true` Boolean without a proof object.
- No claim that constant-field W-orbits are the induced cycle (G4 boundary).

## Path to a correct pass

**A. H_A5 formula path (preferred):** transport sealed H_A5 point
`z = A^{-1} J Φ` along genuine coset / H-reduction / generic G-twist into the
G3A frame over `L_H`, or as an explicit Galois cocycle of 11 conjugates over
`K_proj`.

**B. H-fixed cone lift:** only if the affine cone vector is H-invariant up to
scalar on the open used (proved), so `gH ↦ [vector]` is well-defined.

Until then: exit is **not** `G7-INDUCED-DOUBLE-CYCLE-PASS`.
