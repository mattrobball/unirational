# Inner projection of a genus-6 Mukai sixfold

Command:

```sh
M2 --script experiments/mukai_inner_projection.m2
```

The script certifies over `QQ` that the selected quadric section of the cone
over `Gr(2,5)` is a smooth sixfold in `P^10`.  Projection from the displayed
rational point has a six-dimensional image in `P^9` whose coordinate
elimination ideal is generated in degrees

```text
2, 2, 3, 3, 3.
```

Both source and image ideals are certified prime.  The saturated Jacobian-rank
locus of the codimension-three image has projective dimension two, so this is
also an exact certificate that the projected sixfold is singular.

The seven-dimensional line family survives in this explicit projection; this
uses a geometric argument in addition to the script.  Write `X` for the smooth
source and `H` for its hyperplane class.  Adjunction on the index-six cone gives
`-K_X = 4H`.  Mori's `dim(X)+1` bound supplies a covering family of rational
curves `C` with `-K_X.C <= 7`, so `H.C = 1`: these curves are lines.  A general
member of a covering family is free.  Its normal bundle therefore has vanishing
`H^1`, rank five, and degree two, so the corresponding component `B` of
`F_1(X)` has dimension

```text
h^0(N_{C/X}) = deg(N_{C/X}) + rank(N_{C/X}) = 2 + 5 = 7.
```

Let `p` be the displayed projection center.  The general member of `B` does
not pass through `p`, since otherwise the covering family would make `X` a
cone with vertex `p`.  Projection therefore defines a rational map from a
dense open of `B` to the line scheme of the image.  If its general fiber were
positive-dimensional, infinitely many source lines would project to the same
line.  They all lie in the projective plane obtained as the closure of that
target line's inverse image; this is also the span of `p` and any one of the
source lines.  Infinitely many lines in a plane are dense, so this plane would
lie in `X`.  Since `B`
covers `X`, the line from `p` to a general point of `X` would then lie in `X`,
again making the smooth non-linear `X` a cone.  Thus the projection is
generically finite on `B`, and its image is a seven-dimensional family of
lines on the projected sixfold.

It nevertheless cannot lie on a smooth degree-9 hypersurface.  If its five
ideal generators are `G_i`, every degree-9 member of the ideal is
`F = sum A_i G_i`, with every `A_i` of positive degree.  Five ample divisors
on a projective sixfold have a common zero.  At such a zero all `G_i` and all
`A_i` vanish, so `dF = 0`.  Hence every degree-9 hypersurface containing this
projected sixfold is singular.

The script itself certifies the center incidence, source smoothness and
integrality, image dimension and integrality, image singular-locus dimension,
and the five generator degrees; the line-family assertion uses the preceding
characteristic-zero argument.  Nothing here makes a global statement about
arbitrary projected Mukai varieties.  It eliminates this explicit,
geometrically natural ansatz.
