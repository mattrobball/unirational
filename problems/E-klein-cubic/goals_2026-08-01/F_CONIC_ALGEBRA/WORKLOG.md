# Goal F worklog

All new work for `GOAL_F_CONIC_INTERSECTION_ALGEBRA.md` is isolated in this
directory.  Upstream artifacts under `../certificates/` and `../tmp/` are
read-only inputs.

## Path choice

The goal packet's historical output contract names
`problems/E-klein-cubic/goal_runs/F_CONIC_ALGEBRA/`, while the active
commission directs this worker to make a folder in
`goals_2026-08-01/`.  The active instruction is followed here:

```text
problems/E-klein-cubic/goals_2026-08-01/F_CONIC_ALGEBRA/
```

## Binding target

Over `F=C(A,B,Y,Z)`, install the exact degree-six field `K_proj/F`, then
either:

1. construct a nondegenerate `F`-conic whose scheme-theoretic intersection
   algebra with the exact fixed-frame cubic is `K_proj`, together with an
   explicit selected embedding and exact verification in the original
   cubic; or
2. prove the full conic criterion empty, with a certificate covering all
   conics.

Finite searches, specializations, discriminant matches, and a verifier that
only reads stored conclusions do not meet this target.

## Consumed repository state

- pinned mathematical baseline: `715faf441289e2589b9325311b6613ea0331bf88`
- live repository commit at start: `2140419410cfff2f7d7dcca166acef8c16a0d41b`
- pre-existing unrelated untracked path observed: `C_PFAFFIAN_FANO/`
- accepted exact inputs are referenced in `INPUTS.md`; they are not copied or
  modified here.

## Audit status

The pre-existing Path F packet ends at `EXISTENCE-UNDECIDED`.  It supplies an
exact criterion and a line-specialized sextic, but no generic conic, no
generic algebra isomorphism, and no emptiness certificate.  It is therefore
an input, not a resolution of this goal.

### Coordinate correction

The fixed-frame cubic coefficient attached to `FZ` is
`T=Z-11*A^2/18`, not `Z`.  An initial discovery-only finite-field screen was
run with `Z`; its output was discarded.  `model.py` now applies the exact
`T` substitution before every cubic evaluation, and all retained screen
outputs are regenerated from the corrected model.

## Terminal route

The successful route is the `u=infinity` factor of the exact primitive
sextic.  After changing to the true linear-system coordinate
`T=Z-11*A^2/18`, the nontrivial leading factor is an irreducible cubic `D`.
Its dense affine normalization has function field `C(r,rho,T)`.  On that
field the residual cubic is the generic member of a three-dimensional net
over `C(r)`.

The net base scheme is exactly one geometrically integral degree-three
point.  The universal net incidence is normal, and class-group localization
shows that its horizontal degree subgroup is `3Z`.  Thus the residual cubic
has index three.  The reciprocal sextic has a simple residue root at this
divisor, so proper specialization proves `C(K_proj)=empty`.

The earlier monomial screens, constant-basis ansatz, graph-divisor probes,
finite-field local candidates, and cleared source-hyperplane compactification
remain discovery-only or rejected routes.  None enters the terminal proof.
