G7-PROJECTIVE-SCALING-PASS

# Goal G7B REDO status — scaling sealed; induced materialization residual

**Primary exit:** `G7-PROJECTIVE-SCALING-PASS`  
**G7.3 materialization:** residual (not `G7-INDUCED-DOUBLE-CYCLE-PASS`)  
**Refutation marker:** `G7B-INDUCED-CYCLE-REFUTED` (e0 construction)  
**Headline:** OPEN  
**Stages:** G7.2 sealed; G7.3 residual  

## Decision

### G7.2 — projective scaling (PASS)

Installed cone-lift method (first-nonzero chart → 1) and multihomogeneous
operation contracts (third intersection bidegree (2,2); incidence sums require
audited lifts). Silent sums of independently scaled homogeneous representatives
are forbidden and are demonstrated to fail under independent rescaling.
Sample F=0 points exercise the interface only — they are **not** induced-cycle
coordinates.

### G7.3 — both induced cycles (RESIDUAL)

Correct materialization requires a well-defined coset → point map:

- **H_A5 formula path:** transport sealed `z = A^{-1} J Φ` into the G3A frame
  over `L_H` / Galois cocycle of 11 conjugates over `K_proj`; or
- **H-fixed cone lift:** prove H stabilizes the projective line of the lift.

**Forbidden / refuted:** `p_i = ρ(g_i)·e_0` with `e_0=(1:0:0:0:0)`:
`|Stab_G([e_0])|=11`, well-definedness fails, equivariance 44/44 fails.

Named residual:

```text
need L_H cocycle coordinates from H_A5 formula in G3 frame (no well-defined H-fixed cone lift; rho(g)·e0 refuted)
```

**Correct G3-frame coordinates installed:** **0** of 22.

Abstract coset actions (image 660), H_A5 binding, G4 induction theorem, and
abstract biplane incidence `N` on coset modules are retained as structure.
`defined_over_K_proj` is **not** asserted as a bare Boolean without a proof
object the verifier rebuilds.

## Supersession / consumption ban

- Prior `G7-INDUCED-DOUBLE-CYCLE-PASS` is **superseded and non-consumable**.
- `cycles_WITHDRAWN_rho_e0.json` is historical only.
- Do **not** treat any stored e0-orbit 5-tuples as H_A5-induced cycles.
- G7C residual geometry on e0 points is **not** induced-cycle geometry.
- G3P.3 Springer still needs genuine G3-frame induced points.

## Nonclaims

- No `K_proj`-point of `X_gen` (headline OPEN).
- No G7C cross-ops / residual geometry in this packet.
- Does not reseal H_A5, G4, G7A, or G3A.

## Peak resource

Producer wall ≈ 1.54 s; peak RSS ≈ 34.3 MB.

## Replay

See `REPLAY.md`. Markers: `G7B_VERIFY_SCALING_OK`, `G7B_VERIFY_CYCLES_OK`,
`G7B_AUDIT_OK`, `G7B-INDUCED-CYCLE-REFUTED`.
