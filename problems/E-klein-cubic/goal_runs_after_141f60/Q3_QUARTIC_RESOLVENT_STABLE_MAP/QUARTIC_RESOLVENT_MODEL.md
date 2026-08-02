# QUARTIC_RESOLVENT_MODEL — Goal Q3.0

**Marker:** `Q3-QUARTIC-RESOLVENT-MODEL-PASS`  
**Field:** `K_Schur = C(P(V6))^PSL2(F11)`  
**Pinned baseline:** `141f6042f628f984771fc79d8d16beb12cedcb94`

## Primitive full-span quartic

In the no-point branch of the genuine Schur twist, Voisin's theorem plus
imprimitivity / span exclusions leave a single integral degree-four point whose
Galois closure is `A4` or `S4`, spanning a `P3` hyperplane section.  The cases
are kept separate until a common argument is proved.

Linear disjointness from the Schur splitting field follows from simplicity of
`PSL(2,11)` (order 660):
the only common quotient order with `A4` or `S4` is `1`.

## Pairings and cubic resolvent

The three pairings of four letters are

```text
01|23,  02|13,  03|12
```

Exact group computation:

| | A4 | S4 |
|---|---:|---:|
| order | 12 | 24 |
| vertex orbit | 4 | 4 |
| edge orbit | 6 | 6 |
| pairing orbit | 3 | 3 |
| pairing image | C3 (order 3) | S3 (order 6) |
| kernel | V4 (order 4) | V4 (order 4) |
| resolvent Galois | C3 | S3 |

Exact sequences:

```text
1 → V4 → A4 → C3 → 1
1 → V4 → S4 → S3 → 1
```

For conjugates `P0..P3`, residual points `Q_ij` on chords, and
`R_π = third(Q_ij, Q_kl)`, the triple `(R_π)` is defined over the cubic
resolvent algebra and carries the displayed Galois action.  Universal
collinearity of the three `R_π` is false (root_secant packet).

## Degree-eight incidence

Harris–Roth–Starr: smooth twisted-cubic locus dimension 6.  Three-marked
incidence dimension 9.  Zinger: evaluation to `X^3` has generic degree **8**.
After the three marked points split, the generic fibre remains **one integral
degree-eight field** — not split by the cubic closure alone.

The installed Schur resolvent triple is **not** proved to lie in the
enumerative general locus (Voisin specialization does not preserve avoidance).

## GTC Hilbert compactification

Boundary types recorded: line+conic; three lines; double line+line; nonreduced
GTC; embedded-point strata.  Bayer et al. map `Tbar → M_X → Bl_0 J(X)` with
exceptional fibre `X` is Aut-equivariant and descends to the Schur twist.
An actual `K_Schur`-point of `Tbar` forces a point (fixed_curve_bridge Theorem B).
Coarse Kontsevich points with nontrivial stabilizers may have residual gerbes.

## Galois-commuting maps

All pairing, residual, and incidence constructions are Gal(¯K/K)-equivariant
by construction (they are defined over `K_Schur` from Gal-orbits of the
quartic).  Machine checks: pairing homomorphism kernels/images and orbit sizes.

```text
Q3-QUARTIC-RESOLVENT-MODEL-PASS
```
