# Theorem search for the surviving residue twists

## Verdict

No theorem found in the primary sources below turns the surviving index-one
Klein cubic threefold twists over a complex surface field (or a complex
threefold field) into rational points.  The two closest routes fail at explicit
hypotheses:

```text
surface-field rational-simple-connectedness route:
    cubic degree d=3 in P^n=P^4
    known sufficient bound d^2 <= n:       9 <= 4  (false)
    advertised weaker bound d^2 <= n+1:   9 <= 5  (false)

Tsen--Lang C_i route (five homogeneous coordinates):
    trdeg 2: number of variables 5 > 3^2=9   (false)
    trdeg 3: number of variables 5 > 3^3=27  (false)
```

Index one does not repair either numerical failure.  The statement that a
smooth cubic hypersurface with a closed point of degree prime to three has a
rational point is precisely the still-conjectural Cassels--Swinnerton-Dyer
principle.  Here the degree-55 point would satisfy its premise.

This is a theorem-applicability audit, not a proof that no future theorem can
apply and not a proof that any residue twist is pointless.

## Setup being tested

Let `k/C` be finitely generated of transcendence degree `t=2` or `3`, and let
`Y/k` be one of the surviving unramified residue twists.  Geometrically, `Y` is
the smooth Klein cubic threefold in `P^4`; the installed packets give effective
closed points of degrees `3` and `55`, hence index one.  The remaining
decomposition groups are

```text
PSL(2,11), A5_class_1, A5_class_2, 11:5.
```

### Applicability table

| Candidate result | Exact useful hypothesis | Check for `Y` | Outcome |
|---|---|---|---|
| Graber--Harris--Starr | rationally connected generic fibre over a complex **curve** | `t<=1` only | Already eliminates residue transcendence degree at most one; it says nothing for `t=2,3`. |
| Tsen--Lang | a degree-`d` form over a `C_i` field has a zero when the number of variables is `>d^i` | `5>9` and `5>27` are both false | No point theorem for this cubic form. |
| Starr / de Jong--Starr low-degree RSC | for a hypersurface in `P^n`, `d^2<=n` (or the advertised `d^2<=n+1` variant) | `9<=4` and `9<=5` are false | The standard theorem does not prove the geometric fibre rationally simply connected. |
| de Jong--He--Starr over a surface | geometric generic fibre is rationally simply connected by chains of free lines and contains a very twisting surface (plus the stated spread/polarization hypotheses) | neither key geometric hypothesis is proved for the Klein cubic; the standard numerical theorem cannot supply them | Conditional route only for `t=2`; no conclusion at present. |
| Tian--Zong isotrivial weak approximation | isotrivial rationally connected family over the function field of a smooth projective complex **curve** | base dimension is `2` or `3` | No extension of the theorem to the fields at issue. |
| Projective-homogeneous corollary of de Jong--He--Starr | the variety is a form of `G/P` for a connected semisimple group | the Klein cubic is acted on by a finite group; it is not a positive-dimensional homogeneous `G/P` in this construction | The semisimple-torsor theorem does not apply. |
| Cassels--Swinnerton-Dyer | cubic hypersurface has a point over an extension of degree prime to `3` | the degree-55 point meets the premise | Conjectural, not an unconditional descent theorem. |

## 1. Rational simple connectedness over `C(surface)`

The de Jong--He--Starr surface theorem is genuinely relevant: after spreading
`Y` over a smooth projective surface, it would produce a rational section if
the geometric generic fibre satisfied their rational-simple-connectedness
hypothesis by chains of free lines and possessed a very twisting surface.  The
paper's principal unconditional application is to forms of projective
homogeneous varieties; a finite-group twist of the Klein cubic is not such a
form.

For complete intersections, the available theorem that supplies the missing
geometry assumes

\[
\sum_i d_i^2\le n.
\]

For one cubic in `P^4`, this reads `9<=4`.  Even the `d^2<=n+1` variant
mentioned in Starr's abstract reads `9<=5`.  Equivalently,

\[
\operatorname{ch}_2(T_Y)=\frac{(4+1)-3^2}{2}H^2=-2H^2,
\]

so this cubic lies on the wrong side of the standard low-degree/2-Fano
numerics.  This calculation does **not** prove that the Klein cubic fails every
possible notion of rational simple connectedness; it proves only that the
published numerical input needed for this route is unavailable.  A new,
cubic-specific proof of both the free-line-chain hypothesis and a very twisting
surface would be needed before applying the surface theorem.

For `t=3` there is an additional base-dimension failure: the cited theorem is
for a surface base.  Rational simple connectedness alone is not an installed
point theorem over the function field of a complex threefold.

Primary sources:

- A. J. de Jong, X. He, J. Starr, *Families of rationally simply connected
  varieties over surfaces and torsors for semisimple groups*,
  <https://arxiv.org/abs/0809.5224> (especially Corollary 12.2 in the published
  paper).
- J. Starr, *Hypersurfaces of low degree are rationally simply-connected*,
  <https://arxiv.org/abs/math/0602641>.
- M. DeLand, *Relatively Very Free Curves and Rational Simple Connectedness*,
  <https://arxiv.org/abs/1005.1250>.

## 2. `C_i` and index-one descent

Tsen--Lang makes a transcendence-degree-`t` function field over `C` a `C_t`
field.  Its direct hypersurface consequence needs strictly more than `d^t`
variables.  The Klein cubic is one cubic form in five variables, so it misses
the `C_2` threshold by five variables and the `C_3` threshold by twenty-three.
The theorem has no extra clause saying that an index-one zero-cycle compensates
for the missing variables.

The desired extra clause is not presently a theorem for cubic threefolds.
Voisin states the Cassels--Swinnerton-Dyer assertion as a conjecture and notes
that even the weaker question of a dimension-dependent bound on a prime-to-3
closed point for index-one cubic hypersurfaces is open; she says explicitly
that the cubic-threefold case remains open.  Her proved `1 or 4` alternative is
for **cubic surfaces**, so it cannot be substituted for the threefold residue
twist.

Primary sources:

- The Stacks Project, Tsen's theorem, <https://stacks.math.columbia.edu/tag/03RD>.
- C. Voisin, *Unboundedness of zero-cycles on higher dimensional Fano
  manifolds*,
  <https://webusers.imj-prg.fr/~claire.voisin/Articlesweb/unboundednessvraivrai.pdf>,
  Introduction, Question 1.2 and the sentence following Theorem 1.4.
- J. Harris, M. Roth, J. Starr, *Abel--Jacobi maps associated to smooth cubic
  threefolds*, <https://arxiv.org/abs/math/0202080>.  This gives partial results
  on rational-curve spaces, not the two de Jong--He--Starr hypotheses and not
  index-one-to-point descent.

## 3. Why finite isotriviality does not descend a point

Let `T/k` be the finite `D`-torsor defining a residue twist and let `X` be the
split Klein cubic.  For the associated variety

\[
Y=T\mathbin{\times^D}X,
\]

fpqc descent gives the exact identification

\[
Y(k)\;=\;\operatorname{Hom}_D(T,X).
\]

Thus `Y_T` is split and has `T`-points, but a `k`-point is an equivariant
descent datum, not merely a point after the finite trivializing extension.
Producing that equivariant map is the original finite-group twist/compression
problem.  Isotriviality therefore supplies no missing implication.

The closest isotrivial theorem found, Tian--Zong, proves weak approximation
over the function field of a smooth projective complex curve.  Its base is
one-dimensional, so it adds nothing beyond the already-soluble `t<=1` range.

Primary source: Z. Tian, H. Zong, *Weak Approximation for Isotrivial
Families*, <https://arxiv.org/abs/1003.3502>.

## Exact remaining positive interface

For residue transcendence degree two, this literature search leaves one
concrete possible theorem route:

1. prove directly for the geometric Klein cubic the precise de
   Jong--He--Starr free-line-chain hypothesis;
2. construct the required very twisting surface with the descended
   polarization;
3. verify these data in a spread of the particular finite-group twist.

Absent those new geometric inputs, or a proof of the applicable
Cassels--Swinnerton-Dyer case, the residue point problem is still open.  For
residue transcendence degree three, neither route is presently an applicable
point theorem.
