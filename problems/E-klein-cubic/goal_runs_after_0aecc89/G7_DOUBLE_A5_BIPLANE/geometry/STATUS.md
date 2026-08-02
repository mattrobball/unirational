G7-RESIDUAL-GEOMETRY-PASS

# Goal G7C status — cross operations and residual geometry

**Primary exit:** `G7-RESIDUAL-GEOMETRY-PASS`  
**Headline:** OPEN (not a Problem-E decision)  
**Stages:** G7.4, G7.5, G7.6  
**Consumed:** G7A `G7-CROSS-CLASS-PROJECTOR-PASS`, G7B `G7-INDUCED-DOUBLE-CYCLE-PASS`, G3A `G3A-ARITHMETIC-DOMINANCE-PASS`

## Decision

### G7.4 — operation space

Enumerated the full finite design-generated operation space through cubic arity
(116 operations): incidence/complementary transforms,
augmentation projectors (`1+10`), first/second/third moment contractions with
`B`, design-weighted third sums, isotypic notes. **None** land on the cubic.
Scale-safe G7B chart lifts used for all sums; silent unnormalized sums forbidden.

### G7.5 — third intersections

All **121** ordered pairs computed with
`r = B(p,q,q)p − B(p,p,q)q` (polarization `B(x,x,x)=F`):

- 55 incident + 66 nonincident;
- 109 nonzero residuals on `V(F)`;
- 4 lines contained in the split cubic;
- 6 coinciding `p_i=q_j` pairs;
- 97 unique residual projective points;
- **0** Q-rational residual third points;
- neighbor secants from `2-(11,5,2)`: no rational thirds.

### G7.6 — effective degree two / bridge

No effective length-two subscheme over `K_proj`, no `K_proj`-point or line on
`X_gen`, no plane conic + residual line. `BRIDGE_DOUBLE_A5_POS` **not**
installed. Split-model classical lines/points on `V(F)` are not promoted.

## Nonclaims

- Not `G7-POINT-HEADLINE-POSITIVE`.
- Not `G7-EFFECTIVE-DEGREE2-HEADLINE-POSITIVE`.
- Does not reseal G7A, G7B, G3A, H_A5, or G4.
- CH_0 / signed deg-1 is not effective deg-2.

## Peak resource

Producer wall ≈ 5.18 s; peak RSS ≈ 36.2 MB.

## Replay

See `REPLAY.md`. Markers: `G7C_VERIFY_GEOMETRY_OK`, `G7C_VERIFY_POINT_OK`.
