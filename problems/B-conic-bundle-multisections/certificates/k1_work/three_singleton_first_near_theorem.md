# Exclusion of the three-singleton first-near row

## Statement

Work over an algebraically closed field of characteristic zero in the
square-free, three-`t=2` row of [`k1_frontier.md`](../k1_frontier.md).  Assume
that the three essential centers lie in three distinct proper-origin trees,
so the essential root type is `[1,1,1]`, and that at least one essential
center is nonproper.  Then the row does not occur for a general class-`(2,3)`
equation `A`, for either a rank-three or a rank-two linear triple `sigma`.

More precisely, fix a canonical `sigma`.  After the point and tangent
configuration moves, every rank-three incidence below has codimension at
least nine in the 42-dimensional restricted coefficient space.  Every
rank-two incidence has codimension at least eight, and in the case of three
nonproper centers at least nine.  These bounds are strictly larger than the
projective rank-three and rank-two matrix-orbit dimensions eight and seven.

Together with [`proper_three_center_theorem.md`](proper_three_center_theorem.md),
this excludes every root type `[1,1,1]` in the last class-`(1,1)` frontier.
The proof retains all first-near tangent data; no nonproper center is replaced
by an ordinary proper point.

All dimensions are affine.  The conditions are homogeneous cones, so their
codimensions are unchanged after projectivizing.

## 1. Geometry of the singleton trees

Let `p_1,p_2,p_3` be the distinct proper origins of the three trees.  The
vanishing

\[
 H^0(O_Y(H-D))=0
 \tag{1.1}
\]

says that these origins are noncollinear.  An essential center in a singleton
tree has one of the following two forms.

* `P`: the essential center is its proper origin, and the strict branch has
  multiplicity at least four there.
* `N`: the essential center is the first point over a nonessential proper
  origin `p`, in a tangent direction `tau`.  The no-essential-predecessor
  lemma of
  [`contact_cubic_observation.md`](contact_cubic_observation.md#2-an-essential-center-with-no-essential-predecessor)
  gives the exact strict multiplicities

  \[
  (m_p,m_q)=(3,3),\qquad (r_p,r_q)=(3,4).
  \tag{1.2}
  \]

Thus a smooth test curve through an `N` origin has contact at least six if
its tangent is `tau`, and at least three otherwise.  A test curve through a
`P` origin has contact at least four.

We also record the elementary conic geometry used throughout.  Put three
noncollinear origins at the coordinate vertices.  Every conic through them
has equation

\[
 a yz+b zx+c xy=0.                              \tag{1.3}
\]

It is smooth exactly when `abc!=0`.  At each vertex, one of the two relevant
coefficients vanishes exactly when the tangent is one of the two sides of
the origin triangle.  Consequently a prescribed tangent at one vertex and
passage through the other two vertices gives a pencil with smooth general
member unless the prescribed tangent is a side.  Prescribed tangents at two
vertices and passage through the third give a unique smooth conic whenever
neither tangent is any side through its vertex.

We will repeatedly use the following square-free consequence of (1.2).

**Component-direction lemma.**  If a line `L` is a component of the
square-free octic `B` and passes through an `N` origin `p`, then `L=tau`.

Indeed, if `L!=tau`, write `B=L C`.  At `p`, square-freeness and (1.2) give
`m_p(C)=2`.  The strict transform of `L` misses the marked first-near point
`q`, so `m_q(C)=m_q(B)=3`, contradicting
`m_q(C)<=m_p(C)`.  Notice that this uses the exact pair `(3,3)`, not only the
corrected value four.

The second cluster vanishing has one additional concrete consequence when
all three centers are `N`.  Locally a doubled total-transform weight at a
first-near point pushes down to `(x^2,y)`, the length-two tangent scheme
`Z_i=(p_i,tau_i)`.  Hence

\[
 H^0(O_Y(2H-2D))=0
 \quad\Longleftrightarrow\quad
 H^0(I_{Z_1+Z_2+Z_3}(2))=0.
\tag{1.4}
\]

Both sides of the evaluation map have dimension six, so evaluation of
conics on `Z_1+Z_2+Z_3` is then an isomorphism.

### 1.1 Conic and line determinant bounds

For a smooth conic avoiding the rank-two base point, the rank-three and
rank-two coefficient patterns are respectively

\[
 V_{888},\qquad V_{10,8,6};
\]

if the conic passes simply through that base point, the rank-two pattern is
`V_{8,7,6}`.  On a line the corresponding patterns are `V_{5,4,3}` and,
when the line passes through the base point, `V_{3,3,3}`.  Section 2 of
[`adjacent_nested_pair_theorem.md`](adjacent_nested_pair_theorem.md#2-binary-determinant-bounds-used-below)
proves the following fixed-determinant and zero-fiber bounds, including all
diagonal boundaries:

| pattern | fixed nonsquare | fixed square | zero |
|---:|---:|---:|---:|
| `888` | `10` | `10` | `10` |
| `10,8,6` | `10` | `11` | `11` |
| `8,7,6` | `9` | `9` | `9` |
| `5,4,3` | `6` | `6` | `6` |
| `3,3,3` | `5` | `5` | `5` |

The contact types needed below therefore give these bad-locus dimensions:

| marked contact on a smooth conic | determinant-target dimension | rank three | rank two, `b` off conic | rank two, `b` a marked point |
|---|---:|---:|---:|---:|
| `6+4+4=14` | `3` | `13` | `13` | `12` |
| `6+6+4=16` | `1` | `11` | `12` | `10` |
| `6+3+4=13` | `4` | `14` | `14` | `13` |
| `6+6+3=15` | `2` | `12` | `12` | `11` |

For the `(10,8,6)` pattern, the square subcones in the four rows have
dimensions `2,1,2,1`, respectively.  Thus the eleven-dimensional square
boundary never exceeds the displayed bound.  Passing through `b` removes
the forced base-point square from `B`; both the determinant degree and the
required contact drop by two, so the target dimension stays unchanged.

On a line, contact `8,7,6` gives bad dimensions `7,8,9` in `V_{5,4,3}`.
At a marked base point the corresponding `V_{3,3,3}` bounds are `6,7,8`.
Identically zero determinant has dimensions six and five.  If `b` is an
unmarked point of the line, its forced square either makes contact seven or
eight identically zero, or changes contact six into a one-dimensional target
in `V_{3,3,3}`, of bad dimension six.

All arithmetic in this note is checked in
[`three_singleton_first_near_local_checks.py`](three_singleton_first_near_local_checks.py),
with recorded output in
[`three_singleton_first_near_local_checks.log`](three_singleton_first_near_local_checks.log).

### 1.2 Restriction ranks

For rank three put

\[
 \mathcal Q=\operatorname{Sym}^2(\Omega^1_{\mathbf P^2}(1)^\vee)
                  \otimes O(3),\qquad W_3=H^0(\mathcal Q),
 \qquad \dim W_3=42.
\]

The symmetric Euler resolution gives

\[
 0\longrightarrow O(-2)^3\longrightarrow O(-1)^6
 \longrightarrow\mathcal Q(-4)\longrightarrow0,
\]

so `H^0(\mathcal Q(-4))=0`.  Restriction to every reduced quartic used below
is therefore injective.  Restriction to a reduced cubic is surjective onto a
36-dimensional target, as proved in the adjacent-pair theorem.

For rank two work on `Z=Bl_b(P^2)`.  With `H` the pullback of a line and
`E_b` the exceptional curve,

\[
 W_2=H^0(O(5H-2E_b))\oplus H^0(O(4H-E_b))\oplus H^0(O(3H)),
 \qquad \dim W_2=42.
 \tag{1.5}
\]

If a reduced plane quartic has multiplicity `mu=0,1,2` at `b`, subtracting
`4H-mu E_b` from the three summands in (1.5) gives kernel dimensions

\[
\begin{array}{c|c|c}
\mu&\text{three kernel line bundles}&\text{total }h^0\\ \hline
0&(H-2E_b,-E_b,-H)&0\\
1&(H-E_b,0,-H+E_b)&2+1+0=3\\
2&(H,E_b,-H+2E_b)&3+1+0=4.
\end{array}
\]

Thus the quartic restriction-image ranks are

\[
 42,\quad39,\quad38.                            \tag{1.6}
\]

For a reduced cubic of multiplicity `0,1,2` at `b`, the corresponding image
ranks are

\[
 36,\quad33,\quad32.                            \tag{1.7}
\]

These are ranks of the actual restriction maps.  In every component count
below we then inject the actual target into the direct sum of the
normalization component spaces.  Ignoring matching conditions only enlarges
the bad locus.

## 2. One nonproper singleton

Let `p` be `N`, with tangent `tau`, and let `r,s` be `P`.  The configuration
dimension is `2+1+2+2=7`.

### 2.1 The unaligned pencil

Suppose `tau` is neither `pr` nor `ps`.  Conics tangent to `tau` at `p` and
passing through `r,s` form a pencil without a fixed component.  After a
finite stratification of the configuration base, choose two distinct smooth
members `Q_1,Q_2`; this auxiliary choice is rational and adds no incidence
parameter.  They have no common component and each satisfies

\[
 B|_{Q_i}\in p^6r^4s^4H^0(O_{\mathbf P^1}(2)). \tag{2.1}
\]

For rank three, quartic injectivity and the first row of the conic table give

\[
 42-2\cdot13-7=9.                              \tag{2.2}
\]

For rank two, if `b` is not a marked origin, choose both pencil members to
avoid it.  The same calculation gives nine.  If `b=p,r`, or `s`, the union
has multiplicity two at `b`, each strict conic contributes at most twelve,
and the marked configuration has dimension five.  Hence

\[
 38-2\cdot12-5=9.                              \tag{2.3}
\]

### 2.2 A tangent side

Suppose `tau=pr`; the case `tau=ps` is symmetric.  Put

\[
 T=pr\cup ps\cup rs.
\]

The first edge has contact `6+4>8` and is a component of `B`.  The other two
edges have contacts seven and eight.  The rank-three bad dimensions are
therefore `6,8,7`, and the aligned configuration has dimension six:

\[
 36-(6+8+7)-6=9.                               \tag{2.4}
\]

The exhaustive rank-two calculation is

| position of `b` | config. dim. | image rank | component bad dimensions | codimension |
|---|---:|---:|---:|---:|
| off `T` | `6` | `36` | `6+8+7` | `9` |
| in `pr`, unmarked | `5` | `33` | `5+8+7` | `8` |
| in `ps`, unmarked | `5` | `33` | `6+5+7` | `10` |
| in `rs`, unmarked | `5` | `33` | `6+8+5` | `9` |
| `p` | `4` | `32` | `5+7+7` | `9` |
| `r` | `4` | `32` | `5+8+6` | `9` |
| `s` | `4` | `32` | `6+7+6` | `9` |

The minimum is eight, strictly larger than the rank-two orbit dimension.

## 3. Two nonproper singletons

Let `p,q` be `N`, with tangents `tau_p,tau_q`, and let `r` be `P`.  The
unconstrained configuration dimension is eight.

First dispose of alignments along the mutual side `pq`.  If, for example,
`tau_p=pq` but `tau_q!=pq`, then contact `6+3>8` forces `pq` to be a component
of `B`, contradicting the component-direction lemma at `q`.  If both tangents
equal `pq`, write `B=pq\,C_7`.  At each endpoint, (1.2) gives

\[
 I_p(C_7,pq)\ge4,\qquad I_q(C_7,pq)\ge4.
\]

Indeed, after removing the line, `C_7` has strict multiplicity two both at
the origin and at the marked first-near point, so the infinitely-near
intersection formula contributes at least `2+2` at each endpoint.

This exceeds `deg C_7=7`, so `pq` divides `C_7`, contradicting
square-freeness.  Therefore the only possible tangent-side alignments are
`tau_p=pr` and `tau_q=qr`.

### 3.1 No tangent-side alignment

Let `Q` be the unique conic tangent at `p,q` in the marked directions and
passing through `r`.  It is smooth because neither tangent is a side of the
origin triangle.  It has contact `6+6+4=16`.  Conics tangent at `p` and
passing through `q,r` form a pencil.  Choose a smooth member `R!=Q`; it is
not tangent to `tau_q` at `q`, and has contact `6+3+4=13`.  The two conics
have no common component.  Quartic injectivity gives the rank-three bound

\[
 42-(11+14)-8=9.                               \tag{3.1}
\]

For rank two the exhaustive positions are as follows.  An auxiliary `R` is
chosen to avoid an unmarked `b` whenever possible.

| position of `b` | config. dim. | image rank | `Q` bad | `R` bad | codimension |
|---|---:|---:|---:|---:|---:|
| off `Q\cup R` | `8` | `42` | `12` | `14` | `8` |
| unmarked on the fixed `Q` | at most `7` | `39` | `9` | `14` | at least `9` |
| `p,q`, or `r` | `6` | `38` | `10` | `13` | `9` |

The first row, although one condition weaker than the rank-three count, is
still strictly beyond the seven-dimensional rank-two orbit.

### 3.2 Exactly one tangent-side alignment

Suppose `tau_p=pr`; all other cases are symmetric.  The line `L=pr` has
contact ten, so `B|_L=0`.  Choose a smooth conic `R` tangent to `tau_q` at
`q` and passing through `p,r`.  It has contact `6+3+4=13` and no component
in common with `L`.  On the reduced cubic `L\cup R`, the rank-three count is

\[
 36-(6+14)-7=9.                                \tag{3.2}
\]

For rank two:

| position of `b` | config. dim. | image rank | `L` bad | `R` bad | codimension |
|---|---:|---:|---:|---:|---:|
| off `L\cup R` | `7` | `36` | `6` | `14` | `9` |
| in `L`, unmarked | `6` | `33` | `5` | `14` | `8` |
| `p` or `r` | `5` | `32` | `5` | `13` | `9` |
| `q` | `5` | `33` | `6` | `13` | `9` |

### 3.3 Both tangent-side alignments

The only remaining double alignment is

\[
 tau_p=pr,\qquad tau_q=qr.
\]

The two spoke lines are components of `B`; the third edge `pq` has contact
six.  The rank-three triangle count is

\[
 36-(6+6+9)-6=9.                               \tag{3.3}
\]

For rank two:

| position of `b` | config. dim. | image rank | component bad dimensions | codimension |
|---|---:|---:|---:|---:|
| off the triangle | `6` | `36` | `6+6+9` | `9` |
| in a spoke, unmarked | `5` | `33` | `5+6+9` | `8` |
| in `pq`, unmarked | `5` | `33` | `6+6+6` | `10` |
| `r` | `4` | `32` | `5+5+9` | `9` |
| `p` or `q` | `4` | `32` | `5+6+8` | `9` |

This exhausts the two-`N` case.

## 4. Three nonproper singletons

Now all three origins are `N`; the configuration dimension is nine.  No
marked tangent can be a side of the origin triangle.  Indeed, suppose
`tau_i=p_ip_j`.  If `tau_j!=p_ip_j`, contact `6+3>8` makes that side a
component of `B`, contrary to the component-direction lemma at `p_j`.  If
`tau_j=p_ip_j`, the conic

\[
 p_ip_j\cup tau_k
\]

contains all three length-two schemes `Z_i,Z_j,Z_k`, contrary to (1.4).

By the evaluation isomorphism (1.4), there is a unique conic `Q_12`
containing `Z_1+Z_2+p_3`, and a unique conic `Q_13` containing
`Z_1+Z_3+p_2`.  The absence of all side tangencies makes both conics smooth.
They are distinct: equality would give a conic through all three `Z_i`,
again contradicting (1.4).  Hence they have no common component.  Moreover,
`Q_12` is not tangent to `tau_3` at `p_3`, and similarly for `Q_13`; otherwise
it alone would contain the full cluster.  Each therefore has contact
`6+6+3=15`.

Quartic injectivity and the last row of the conic table give

\[
 42-2\cdot12-9=9                               \tag{4.1}
\]

for rank three.  For rank two:

| position of `b` | config. dim. | image rank | component bad dimensions | codimension |
|---|---:|---:|---:|---:|
| off `Q_12\cup Q_13` | `9` | `42` | `12+12` | `9` |
| unmarked on one conic | at most `8` | `39` | `9+12` | at least `10` |
| one of `p_1,p_2,p_3` | `7` | `38` | `11+11` | `9` |

The two conics have intersection multiplicity at least two at `p_1` and
pass through `p_2,p_3`; Bezout leaves no unmarked point common to both.
Thus the table is exhaustive.

## 5. Incidence conclusion

For a fixed canonical rank-three or rank-two `sigma`, the coefficient map
from the 60-dimensional space of class-`(2,3)` equations onto `W_3` or `W_2`
is surjective.  Pullback therefore preserves every displayed codimension.
The rank-three minimum is nine and the rank-two minimum is eight, strictly
larger than the corresponding projective matrix-orbit dimensions eight and
seven.  Sweeping over `sigma` cannot dominate `P_A^59`.

Sections 2--4 cover respectively one, two, and three nonproper singleton
trees, including every allowable tangent alignment.  The all-proper case is
the proper-three-center theorem.  Hence no essential root type `[1,1,1]`
survives for a general `A`.
