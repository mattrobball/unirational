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
