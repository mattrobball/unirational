# Goal R completion audit

## Binary route verdict

- `R-RATIONAL-CURVE-HEADLINE-POSITIVE`: **not achieved**.
- `R-HILBERT-COMPONENT-STRUCTURAL`: **achieved**.
- Problem E headline: **OPEN**.

This is a complete structural exit under Section 4 of
`../GOAL_R_RATIONAL_CURVES_ON_TWIST.md`, not a claim that the positive
mission or the ambient open problem has been solved.

## Acceptance map

| Goal package | Delivered result | Exact boundary |
|---|---|---|
| R0 — inventory | `HILBERT_INVENTORY.md` gives a justified cutoff \(e_0=5\), dimensions and Abel--Jacobi geometry, the twisted action, and residual components | no all-degree component classification |
| R1 — descend a Hilbert point | \({}^T J(K_{\rm proj})=0\) is certified; canonical degree-4/5 Abel--Jacobi maps force every descended point into their distinguished zero fibres | no point of those zero fibres was produced |
| R2 — marked/residual constructions | all conics are excluded; every integral genus-zero curve has an exact secant-to-point bridge; quartic elliptics and degree-5 genus-2 curves are excluded by residual lines; for an elliptic quintic, a \(\operatorname{Pic}^2\)-point plus the degree-5 polarization forces the genus-one torsor to split | the degree-55 incidence route and the elliptic-quintic point itself remain open |
| R3 — exact curve verification | no candidate curve was found, so ideal/normalization verification is inapplicable | no curve or point is claimed |

## New unconditional theorems

1. The genuine projective generic twist of the intermediate Jacobian has
   exactly one rational point, its origin.
2. The genuine twist contains no geometrically integral conic.
3. A point of the generalized twisted-cubic component forces a point of the
   original twist; the canonical moduli zero fibre is the original cubic.
4. In every degree, a geometrically integral curve with genus-zero
   normalization forces a point of the cubic by degree-two secant
   residuation, even if the normalization is nonsplit.
5. Rational quartic and quintic points are reduced to the distinguished
   zero fibres of canonical Aut\((X)\)-equivariant Abel--Jacobi maps.  The
   published general-fibre theorems do not point these fibres.
6. Smooth quartic elliptic curves and smooth degree-5 genus-2 curves are
   absent on the genuine twist because each canonically produces a line.

## Replay

Run from this directory:

```text
/opt/homebrew/bin/python3 produce_fixed_jacobian.py
/opt/homebrew/bin/python3 verify_fixed_jacobian.py
/opt/homebrew/bin/python3 produce_seal.py
/opt/homebrew/bin/python3 verify.py
```

Expected terminal markers:

```text
R_FIXED_JACOBIAN_ZERO_CERTIFIED
R_FIXED_JACOBIAN_INDEPENDENT_VERIFY_OK
R_HILBERT_COMPONENT_STRUCTURAL_SEALED_HEADLINE_OPEN
R_RATIONAL_CURVES_PACKET_VERIFY_OK
R-HILBERT-COMPONENT-STRUCTURAL
HEADLINE_OPEN
```

## Isolation and repository boundary

All authoritative work is contained in
`goals_2026-08-01/R_RATIONAL_CURVES_ROOT_JACOBIAN_ZERO/`.  The initially
chosen sibling folder acquired concurrent edits from another worker, so it
was left untouched and this collision-free folder was used instead.  No
repository commit was created and no unrelated working-tree change was
modified.
