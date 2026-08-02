G7-INDUCED-DOUBLE-CYCLE-PASS

# Goal G7B status — projective scaling + double induced cycles

**Primary exit:** `G7-INDUCED-DOUBLE-CYCLE-PASS`  
**Also achieved:** `G7-PROJECTIVE-SCALING-PASS`  
**Headline:** OPEN (structural; not a Problem-E decision)  
**Stages:** G7.2, G7.3 only (no G7C geometry)

## Decision

### G7.2 — projective scaling

Installed cone lifts (first-nonzero chart → 1) for all 22 geometric points
together with multihomogeneous operation contracts (third intersection bidegree
(2,2); incidence sums require audited lifts). Silent sums of arbitrary
homogeneous representatives are forbidden and are demonstrated to fail under
independent rescaling.

### G7.3 — both induced cycles

1. Both H_A5 maximal A5 classes: faithful degree-11 coset actions (image 660).
2. Explicit G3-frame coordinates for all 22 points over `Q(ζ₁₁)`:
   `ρ(g_i)·(1:0:0:0:0)` on `V(F)`, `F` = split `Φ`.
3. All 22 raw and chart-normalized substitutions: `F_Klein = 0`.
4. Cycles defined over `K_proj`, reduced on an explicit open, degree 11 each.
5. Incidence correspondence `N` between the two etale coset algebras, aligned
   with G7A design and rebuilt from conjugate intersections.

## Nonclaims

- No `K_proj`-point of `X_gen` (headline OPEN).
- No G7C cross-ops / residual geometry.
- Does not reseal H_A5, G4, G7A, or G3A.
- Split-model coordinates: abstract induced point is over `L_H`; materialization
  is the Gal-orbit on `V(F)` in the normalized G3 frame.

## Peak resource

Producer wall ≈ 0.42 s; peak RSS ≈ 36.2 MB.

## Replay

See `REPLAY.md`. Markers: `G7B_VERIFY_SCALING_OK`, `G7B_VERIFY_CYCLES_OK`.
