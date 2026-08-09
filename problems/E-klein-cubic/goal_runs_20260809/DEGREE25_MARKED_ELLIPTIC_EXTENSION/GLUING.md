# Scheme-theoretic gluing on the complete reduced network

## 1. Complete incidence list

The corrected exact `V4` geometry gives precisely two kinds of intersections
among positive-dimensional fixed-locus components.

| point type | branches through the point | number of points |
|---|---|---:|
| type I | one elliptic `E_t` and two fixed lines | 165 |
| type II | three elliptics, no fixed line | 165 |

For a fixed involution, `E_t` contains 3 type-I and 9 type-II points, while
`L_t` contains 6 type-I and no type-II points. The fixed elliptic and fixed line
for the same involution are disjoint. The exact site inventory adds no further
elliptic intersections, and the `C3` projective eigenlines are not components
of `X`—they meet `X` in reduced length-three schemes only.

## 2. Local V4 characters

At either type of marked point the exact stabilizer is a `V4`, and

\[
T_xX\simeq\chi_1\oplus\chi_2\oplus\chi_3
\]

with the three distinct nontrivial characters. Each of the three incident
fixed curves has tangent equal to one of these character lines. Since the
field has characteristic zero, the finite `V4` action is formally linearizable
at the smooth point `x in X`. In equivariant formal coordinates `(u,v,w)`, the
three branches are therefore the three coordinate axes.

Consequently

\[
\widehat O_{D,x}
 \simeq k[[u,v,w]]/(uv,uw,vw).
\]

This applies at type I and at type II; only the labels of the three axes differ.
Every pairwise scheme-theoretic intersection is `Spec k`, and the triple
intersection is also `Spec k`. There are no embedded nilpotents and no tangent
compatibility conditions.

## 3. Gluing criterion

The local ring above is the fiber product of the three branch rings over their
common residue field:

\[
k[[u]]\times_k k[[v]]\times_k k[[w]].
\]

Hence morphisms from the local union to a separated target are exactly triples
of branch morphisms with the same value at the closed point. Globally, the
normalization description gives the same equalizer statement at every node.

On every type-I point, `[-5]` on the elliptic and the identities on both lines
all fix the point. On every type-II point, all three `[-5]` maps fix the point.
Thus the branch maps agree on the full scheme-theoretic overlaps, not merely
on an incomplete set of geometric incidences.

## 4. Result

The component maps glue uniquely to

\[
\lambda_D:D\longrightarrow X.
\]

The conjugation calculation in `BOUNDARY_MAP.md` makes the glued morphism
`G`-equivariant. Therefore

```text
DEGREE25-BOUNDARY-MAP-PASS
```

is proved without an ambient polynomial lift.
