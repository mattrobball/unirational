# Gross--Popescu level-11 equivariance audit

Date: 2026-08-01.

## Binary conclusion

Gross--Popescu's birational model of `A_11^lev` does **not** provide a
`PSL_2(F_11)`-equivariant rational map

\[
\mathbf P(V_6)\dashrightarrow K_{\mathrm{Klein}}.
\]

The paper contains a genuine equivariant intertwining construction, but its
source, target, and direction are different from that required arrow.  The
last birational identification with the Klein cubic explicitly breaks
equivariance.

Primary source: M. Gross and S. Popescu, *The moduli space of
(1,11)-polarized abelian surfaces is unirational*,
[arXiv:math/9902017](https://arxiv.org/abs/math/9902017), especially pp. 5--9
and Remark 2.8 on p. 17 of the
[author PDF](https://www.math.stonybrook.edu/~sorin/eprints/moduli11.pdf).

## What the representations actually are

The 11-dimensional Weil/Schroedinger representation splits under the
involution into

\[
V=V_+\oplus V_-,\qquad \dim V_+=6,\quad \dim V_-=5.
\]

The central involution of `SL_2(F_11)` acts by `-1` on `V_+` and by `+1` on
`V_-`.  Thus, up to the harmless dual choice, `V_+` is the Schur six-space and
`V_-` is the honest Klein five-space.

Consequently a literal linear intertwiner `L:V_+ -> V_-` must vanish:

\[
L(-v)=L(zv)=zL(v)=L(v),
\]

so `2L=0`.  This does not obstruct a nonlinear projective rational map, since
the center disappears after projectivization; it only rules out interpreting
one of the displayed matrices as a linear `6 -> 5` solution.

The paper's actual operator is the 15-dimensional isomorphism

\[
\Phi:\bigwedge^2 V_+\;\xrightarrow{\sim}\;\operatorname{Sym}^2 V_-.
\]

It is encoded by a `6 x 6` skew-symmetric matrix `S(P)` whose entries are
quadratic forms in the five coordinates of
\(P\in\mathbf P(V_-^\vee)\).  It is not a
matrix for a map `V_+ -> V_-`.  The earlier `6 x 11` matrix `R5` likewise
records quadratic equations in the 11-dimensional theta representation; it
is not a `6 -> 5` intertwiner.

## Direction of the geometric maps

The quadratic matrix produces

\[
\mathbf P(V_-^\vee)
  \longrightarrow \mathbf P(\bigwedge^2V_+^*),
\qquad P\longmapsto S(P).
\]

On the invariant sextic Pfaffian hypersurface `D2` it has rank four and gives

\[
\Theta:D_2\setminus D_1\longrightarrow \operatorname{Gr}(2,V_+),
\qquad P\longmapsto\ker S(P).
\]

The closure of its image is the invariant `V14` threefold `X`.  Hence this
construction starts on a hypersurface in the **five-dimensional Klein
module**.  It does not start with a generic point of `P(V_+)`.

There is also a quadratic centre map from the Klein cubic to
`Gr(2,V_+)` in the smoothness argument, but the paper proves that its image is
disjoint from `X`; it is not a map from the Klein cubic onto `X`.

Finally Gross--Popescu identify `X` birationally with the Klein cubic by
intersecting the two families of ruling lines with a chosen generic
hyperplane

\[
\Pi\subset\mathbf P(V_+^*).
\]

Remark 2.8(1) states explicitly that the resulting birational isomorphism
depends on `Pi` and is **not compatible** with the `PSL_2(F_11)` action.
Therefore the equivariant map `D2 -> X` cannot be composed with this final
step to manufacture the required equivariant Klein-cubic map.

## What remains open after the audit

The paper proves a non-equivariant birational statement

\[
\mathcal A_{11}^{\mathrm{lev}}\dashrightarrow K_{\mathrm{Klein}},
\]

not `G`-unirationality of the Klein action.  Extracting a genuine rational
`G`-map from `P(V_6)` would require a new equivariant operation absent from
the construction, for example both a way to land a generic Schur point on
the Palatini/ruling incidence and an equivariant replacement for the chosen
hyperplane step.

The elementary representation check replays with

```sh
/usr/bin/python3 verify_gross_popescu_boundary.py
```

and ends with

```text
GROSS_POPESCU_EQUIVARIANCE_BOUNDARY_EXACT
```
