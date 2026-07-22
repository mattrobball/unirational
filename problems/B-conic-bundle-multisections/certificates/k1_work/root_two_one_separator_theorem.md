# Exclusion of the one-separator root type `[2,1]`

## Statement

Work over an algebraically closed field of characteristic zero in the
square-free three-`t=2` row of
[`k1_frontier.md`](../k1_frontier.md).  Suppose two essential centers lie in
one proper-origin tree, the third lies in a different tree, and a `t=1`
center separates the two consecutive essential centers in the repeated
tree.  Then this incidence does not occur for a general class-`(2,3)`
equation `A`, for either a rank-three or a rank-two linear triple `sigma`.

The exact separator classification in Section 2 of
[`root_three_separator_theorem.md`](root_three_separator_theorem.md#2-a-separated-pair-has-exactly-one-negligible-center)
says that there is exactly one intervening center and that the repeated tree
has one of the two corrected-multiplicity patterns

\[
 F=(4,3,4)\quad\hbox{(three successive free centers)},
 \qquad
 S=(5,3,4)\quad\hbox{(free, then satellite)}.       \tag{0.1}
\]

Both patterns, including every proper or nonproper singleton tree, every
tangent or continuation alignment, and every position of the rank-two base
point, are treated below.  For a fixed canonical `sigma`, the rank-three
incidences have codimension at least nine and the rank-two incidences have
codimension at least eight.  These are strictly larger than the respective
projective matrix-orbit dimensions eight and seven.

Together with
[`adjacent_nested_pair_theorem.md`](adjacent_nested_pair_theorem.md), this
excludes the complete essential root type `[2,1]`: an adjacent repeated pair
is covered there, while every nonadjacent repeated pair is one of (0.1).

## 1. The exact strict-multiplicity configurations

At a canonical center `z`, write

\[
 m_z=\operatorname{mult}_z(B_z^{\mathrm{strict}}),\qquad
 e_z=\#\{\hbox{exceptional branch components through }z\},
 \qquad r_z=m_z+e_z.                            \tag{1.1}
\]

The singleton essential center belongs to a different proper-origin tree.
The no-essential-predecessor lemma in
[`contact_cubic_observation.md`](contact_cubic_observation.md#2-an-essential-center-with-no-essential-predecessor)
makes the following alternatives exhaustive.

* `P`: the singleton is a proper center `r`, with `m_r=r_r>=4`.
* `N`: a nonessential proper triple point `r` is followed by the singleton
  essential center `s` in a tangent direction `upsilon`, with

  \[
  (r_r,r_s)=(3,4),\qquad (m_r,m_s)=(3,3).       \tag{1.2}
  \]

There are likewise two forms of `F`.

* `F-P`: the earlier essential center is proper.  Writing the free chain as
  `p<w<v` and the tangent represented by `w` as `tau`, one has exactly

  \[
  (r_p,r_w,r_v)=(4,3,4),\qquad
  (m_p,m_w,m_v)=(4,3,3).                        \tag{1.3}
  \]

* `F-N`: the earlier essential center `u` is nonproper and minimal in its
  tree.  It is therefore first-near over a proper triple point `a`.  With
  the successive-free chain `a<u<w<v`,

  \[
  (r_a,r_u,r_w,r_v)=(3,4,3,4),\qquad
  (m_a,m_u,m_w,m_v)=(3,3,3,3).                 \tag{1.4}
  \]

In `S`, the earlier essential has corrected multiplicity five.  It cannot
be a nonproper minimal essential, because (1.2) would give corrected
multiplicity four.  Thus it is proper.  Write \(p<w<v\), where \(w\) is free
and
\[
 v=\bar E_p\cap\bar E_w
\]
is satellite.  Then

\[
 (r_p,r_w,r_v)=(5,3,4),\qquad
 (m_p,m_w,m_v)=(5,2,2).                        \tag{1.5}
\]

### 1.1 The degree-one cluster vanishing in `F`

The first cluster vanishing has a useful consequence which removes several
apparently exceptional collinearities.  In either `F` configuration, `tau`
is the unique line satisfying the repeated-tree part of `D`.

For `F-P`, in prime-exceptional notation,

\[
 E_p^*+E_v^*=\bar E_p+\bar E_w+2\bar E_v.
\]

The total transform of `tau`, which passes through `p,w`, dominates this
divisor whether or not its strict transform passes through `v`.  A different
line has total value only one at `E_v` and fails the coefficient two.

For `F-N`, one similarly has

\[
 E_u^*+E_v^*=\bar E_u+\bar E_w+2\bar E_v.
\]

A line through `a` has total value one along the descendant exceptional
chain.  It reaches value two precisely when it also passes through `u`, so
again the unique candidate is `tau`.

The singleton part of `D` asks a line to pass through its proper origin `r`:
this is clear in type `P`, while in type `N` a single total-transform weight
at `s` pushes down to the maximal ideal of `r`.  Consequently

\[
 H^0(O_Y(H-D))=0\quad\Longrightarrow\quad r\notin\tau
 \qquad\hbox{in every `F` case}.                \tag{1.6}
\]

This uses the complete cluster ideal.  Replacing the infinitely-near weight
by a naive strict-transform condition would miss (1.6).

## 2. Restriction and determinant bounds

We use the binary determinant bounds proved in Section 2 of
[`adjacent_nested_pair_theorem.md`](adjacent_nested_pair_theorem.md#2-binary-determinant-bounds-used-below).
If a smooth conic has forced contact `c` with the octic, its determinant
target has affine dimension `17-c`.  The required bad-locus bounds are

| conic contact `c` | `11` | `13` | `14` | `15` | `16` |
|---:|---:|---:|---:|---:|---:|
| rank three, pattern `(8,8,8)` | `16` | `14` | `13` | `12` | `11` |
| rank two, `b` off the conic, pattern `(10,8,6)` | `16` | `14` | `13` | `12` | `12` |
| rank two, `b` a marked point, pattern `(8,7,6)` | `15` | `13` | `12` | `11` | `10` |
| rank two, `b` unmarked on the conic | `13` | `11` | `10` | `9` | `9` |

In the last row the forced base-point square consumes two degrees of the
moving determinant target; when fewer than two remain, only determinant
zero survives.  In the rank-two off-conic row the exceptional
eleven-dimensional diagonal fiber is retained.  The dimensions of the
square subtargets for contacts `11,13,14,15,16` are respectively
`3,2,2,1,1`, which gives exactly the displayed bounds.

For a line with contact `6,7,8`, the rank-three and off-basepoint rank-two
bad dimensions are `9,8,7`.  When `b` is a marked point they are `8,7,6`,
and when `b` is unmarked on the line they are `6,5,5`.  Identically zero
determinant has dimension six off `b` and five through `b`.

Restriction to a reduced cubic has rank `36` in rank three.  In rank two it
has ranks `36,33,32` according as its plane multiplicity at `b` is `0,1,2`.
Restriction to a reduced quartic is injective in rank three, and in rank two
has ranks `42,39,38` in the same three cases.  Restriction to a reduced conic
has ranks `27,24,23`.  These are the exact restriction ranks established in
[`three_singleton_first_near_theorem.md`](three_singleton_first_near_theorem.md#12-restriction-ranks).

All component bounds, restriction-rank arithmetic, and codimensions below
are checked by
[`root_two_one_separator_local_checks.py`](root_two_one_separator_local_checks.py),
with recorded output in
[`root_two_one_separator_local_checks.log`](root_two_one_separator_local_checks.log).

## 3. The free pattern with a proper earlier essential: `F-P`

Let `v_tau` be the point reached by the strict transform of `tau` after the
second blowup.

### 3.1 The noncontinuation `v!=v_tau`

Choose coordinates `p=[0:0:1]`, `tau=(y=0)`.  The conics whose strict
transforms pass successively through `p,w,v` form a projective plane and can
be written

\[
 \alpha(yz+A x^2)+Bxy+Cy^2=0,\qquad A\ne0.     \tag{3.1}
\]

The nonzero value of `A` is exactly the noncontinuation condition.  Every
member with `alpha!=0` is smooth: a reducible member smooth at `p` would have
`tau` as a line component and hence would reach `v_tau`, not `v`.

Suppose first that the singleton is `P`.  By (1.6), `r` is off `tau`.
Choose a smooth member `Q` of (3.1) through `r`.  Then

\[
 I_p(B,Q)\ge4+3+3=10,\qquad I_r(B,Q)\ge4,
 \qquad I_p(B,\tau)\ge4+3=7.                  \tag{3.2}
\]

Thus `Q` has contact at least fourteen and `tau` has contact at least seven.
The reduced cubic \(Q\cup\tau\) is the first `F-P/P` test object.

Now let the singleton be `N`, and put `L=pr`.  If `upsilon!=L`, imposing the
tangent `upsilon` at `r` on (3.1) gives a nonzero conic; choose one and call
it `Q`.  It is smooth.  Indeed,
the only boundary solution with \(\alpha=0\) is \(\tau\cup L\), whose tangent at
`r` is `L`.  The contacts are

\[
 I_p(B,Q)\ge10,qquad I_r(B,Q)\ge3+3=6,
 \qquad I_p(B,\tau)\ge7.                       \tag{3.3}
\]

Hence the component contacts of \(\tau\cup Q\) are seven and sixteen.

If `upsilon=L`, the line `L` has contact `4+3+3=10` and is a component of
`B`.  Choose instead a general smooth conic `R` through `p,w,v,r`; it is not
tangent to `L` at `r` and has contact `10+3=13`.  The reduced cubic
\(L\cup R\) therefore has component bounds six and fourteen.  This treats
the tangent boundary rather than taking a nonexistent smooth limit of (3.3).

### 3.2 The continuation `v=v_tau`

Now `tau` follows all three centers in (1.3), so

\[
 I_p(B,\tau)\ge4+3+3=10>8,
\]

and `tau` is a component of `B`.  Condition (1.6) still gives `r` off
`tau`.

For a `P` singleton, the line `L=pr` has contact at least `4+4=8`.  The
reduced conic \(\tau\cup L\) has determinant targets zero and one-dimensional.

For an `N` singleton, if `upsilon=L`, then `L` has contact ten and is also a
component; use the two zero-determinant lines \(\tau\cup L\).  If
`upsilon!=L`, choose a smooth conic `Q` tangent to `tau` at `p` and to
`upsilon` at `r`.  Such conics form a pencil with smooth general member,
because neither prescribed tangent is the joining line `L`.  It need not
pass through `v`: its contact at the first two repeated-tree centers and the
singleton cluster is already

\[
 (4+3)+(3+3)=13.                               \tag{3.4}
\]

Thus \(\tau\cup Q\) has component bounds six and fourteen.

## 4. The free pattern with a nonproper earlier essential: `F-N`

Let `w_tau` be the continuation point of `tau` after the blowups at `a,u`.

### 4.1 A continuation is incompatible with square-freeness

Suppose `w=w_tau`.  The line follows `a,u,w`, so its contact with `B` is at
least nine and \(B=\tau C_7\).  If `v` is not the next continuation point of
`tau`, then

\[
 m_w(C_7)=3-1=2,\qquad m_v(C_7)=3,
\]

contradicting the fact that strict multiplicity cannot increase under a
blowup.  If `v` is the continuation point, then `C_7` has strict
multiplicity two at each of `a,u,w,v`, and hence

\[
 I_a(C_7,\tau)\ge2+2+2+2=8>7.
\]

This makes `tau` a second component of `B`, contrary to the square-free row.
Therefore

\[
 w\ne w_\tau.                                  \tag{4.1}
\]

### 4.2 A proper singleton

Under (4.1), conics following `a,u,w,v` form a projective pencil.  In local
coordinates its unique zero-linear-term boundary member is the doubled line
`tau^2`; every member with nonzero linear term is smooth because the
noncontinuation fixes a nonzero quadratic coefficient transverse to `tau`.
By (1.6), `r` is off `tau`, so the unique member `Q` through `r` is not the
boundary member and is smooth.  Its contact is

\[
 (3+3+3+3)+4=16,                               \tag{4.2}
\]

while `tau` follows `a,u` and has contact six.  Use the reduced cubic
\(\tau\cup Q\).

### 4.3 A nonproper singleton

Again put `L=ar`.  First suppose `upsilon!=L`.  Let

* `Q_1` be the unique conic following all four centers `a,u,w,v` and
  passing through `r`;
* `Q_2` be a conic following `a,u,w` and tangent to `upsilon` at `r`.

The preceding doubled-line boundary misses `r`, so `Q_1` is smooth.  The five
linear conditions defining `Q_2` have a nonzero solution, and its only
zero-linear-term boundary solution is \(\tau\cup L\); hence `upsilon!=L` lets
us choose `Q_2` smooth.  Thus both conics are smooth.  They each have contact
fifteen:

\[
 I(B,Q_1)\ge12+3=15,
 \qquad I(B,Q_2)\ge9+6=15.                     \tag{4.3}
\]

They share the length-three curvilinear cluster at `a` and the point `r`.
If they are distinct, Bezout shows that these account for their complete
intersection, so \(Q_1\cup Q_2\) is a reduced quartic with no unmarked common
point.  If they coincide, then `Q_1` is also tangent to `upsilon` and has
contact `12+6=18>16`; it is an irreducible conic component of `B`, already
excluded for a general `A` by
[`conic_factor_theorem.md`](conic_factor_theorem.md).

If `upsilon=L`, then `L` has contact `3+3+3=9` and is a component of `B`.
Use the reduced cubic \(L\cup Q_1\); unless the already-excluded conic-factor
case occurs, `Q_1` is transverse to `L` at `r`.  Its contact remains fifteen.

## 5. The satellite pattern `S`

Recall (1.5): `p,w,v` have strict multiplicities `5,2,2`, and `tau` follows
only `p,w`.  Thus every conic tangent to `tau` at `p` has contact at least
seven with the repeated tree.

### 5.1 A proper singleton

If `r` is off `tau`, put `L=pr`.  It has contact at least `5+4=9`, so it is
a component of `B`.  Choose a smooth conic `Q` tangent to `tau` at `p` and
passing through `r`.  Its contact is at least `7+4=11`.  Use the reduced
cubic \(L\cup Q\).

If `r` lies on `tau`, then `tau` has contact at least `7+4=11`, so write
\(B=\tau C_7\).  The residual contacts along `tau` are at least

\[
 (5-1)+(2-1)+(4-1)=8>7.
\]

Hence \(\tau^2\) divides \(B\), contrary to square-freeness.

### 5.2 A nonproper singleton

First suppose `r` is off `tau`, and again put `L=pr`.  If `upsilon=L`, the
line has contact `5+3+3=11`.  After removing it, the residual contact on `L`
is at least `4+2+2=8>7`, so \(L^2\) divides \(B\), impossible in the square-free
row.

If `upsilon!=L`, the line `L` has contact eight.  Choose a smooth conic `Q`
tangent to `tau` at `p` and to `upsilon` at `r`; neither tangent is `L`, so
a smooth member exists.  Its contact is

\[
 (5+2)+(3+3)=13.                               \tag{5.1}
\]

The reduced cubic \(L\cup Q\) has component bounds seven and fourteen.

Finally suppose `r` lies on `tau`.  If `upsilon=tau`, then after removing
the forced line the residual contact is at least

\[
 (5-1)+(2-1)+(3-1)+(3-1)=9>7,
\]

so \(\tau^2\) divides \(B\).  If `upsilon!=tau`, the line `tau` is still a
component, because its contact is at least `7+3=10`.  Choose a smooth conic
`Q` through `p` and tangent to `upsilon` at `r`, transverse to `tau` at `p`.
It has contact `5+(3+3)=11`, and \(\tau\cup Q\) is a reduced cubic.

## 6. Rank-three incidence counts

The configuration dimensions include all proper points, tangent directions,
and free infinitely-near points.  Auxiliary test curves are selected
rationally after a finite stratification and add no incidence parameters.
The complete calculation is

| case | restriction rank | component bad dimensions | configuration dimension | codimension |
|---|---:|---:|---:|---:|
| `F-P`, noncontinuation, `P` | `36` | `8+13` | `6` | `9` |
| `F-P`, noncontinuation, `N`, `upsilon!=L` | `36` | `8+11` | `7` | `10` |
| `F-P`, noncontinuation, `N`, `upsilon=L` | `36` | `6+14` | `6` | `10` |
| `F-P`, continuation, `P` | `27` | `6+7` | `5` | `9` |
| `F-P`, continuation, `N`, `upsilon=L` | `27` | `6+6` | `5` | `10` |
| `F-P`, continuation, `N`, `upsilon!=L` | `36` | `6+14` | `6` | `10` |
| `F-N`, noncontinuation, `P` | `36` | `9+11` | `7` | `9` |
| `F-N`, noncontinuation, `N`, `upsilon!=L` | `42` | `12+12` | `8` | `10` |
| `F-N`, noncontinuation, `N`, `upsilon=L` | `36` | `6+12` | `7` | `11` |
| `S`, `P` | `36` | `6+16` | `5` | `9` |
| `S`, `N`, `r` off `tau`, `upsilon!=L` | `36` | `7+14` | `6` | `9` |
| `S`, `N`, `r` on `tau`, `upsilon!=tau` | `36` | `6+16` | `5` | `9` |

Every omitted alignment in Sections 3--5 gave a squared line and was already
impossible in the square-free row.  Thus the rank-three minimum is nine,
strictly larger than the orbit dimension eight.

## 7. Rank-two base-point audit

Let `b` be the base point of the canonical rank-two triple.  The following
arrays give the codimensions in the exhaustive base-point positions.  For a
two-component cubic, the positions are, in order,

\[
 b\notin\Gamma,\quad
 b\text{ unmarked on the first component},\quad
 b\text{ unmarked on the second component},\quad
 b\text{ at the listed marked intersections or origins}.               \tag{7.1}
\]

When the two marked origins give different last entries, both are displayed.
For the quartic \(Q_1\cup Q_2\), the positions are off the quartic, unmarked
on one conic, and at `a` or `r`.  The conics intersect only at those two
marked origins, with total intersection multiplicities three and one, so
there is no missing common-point stratum.

| case | codimensions by the positions (7.1) |
|---|---|
| `F-P`, noncontinuation, `P` (`Q,tau,p,r`) | `9,10,10,9,9` |
| `F-P`, noncontinuation, `N`, `upsilon!=L` (`Q,tau,p,r`) | `9,10,10,10,10` |
| `F-P`, noncontinuation, `N`, `upsilon=L` (`L,R,p or r`) | `10,9,11,10` |
| `F-P`, continuation, `P` (`tau,L,p,r`) | `9,8,9,9,9` |
| `F-P`, continuation, `N`, `upsilon=L` (`tau,L,p,r`) | `10,9,9,10,10` |
| `F-P`, continuation, `N`, `upsilon!=L` (`tau,Q,p,r`) | `10,9,11,10,10` |
| `F-N`, noncontinuation, `P` (`Q,tau,a,r`) | `8,9,9,9,9` |
| `F-N`, noncontinuation, `N`, `upsilon!=L` (`Q_1,Q_2,a or r`) | `10,11,10` |
| `F-N`, noncontinuation, `N`, `upsilon=L` (`L,Q_1,a or r`) | `11,10,12,11` |
| `S`, `P` (`L,Q,p or r`) | `9,8,10,9` |
| `S`, `N`, off-line generic (`L,Q,p or r`) | `9,9,10,9` |
| `S`, `N`, root on `tau` (`tau,Q,p or r`) | `9,8,10,9` |

For illustration, the first row off the cubic is

\[
 36-13-8-6=9.
\]

If `b=p`, the two components are tangent there, the image rank is `32`, the
bad dimensions become `12,7`, and the marked configuration has dimension
four, again giving nine.  In the fourth row, an unmarked `b` on the zero
component gives

\[
 24-5-7-4=8,
\]

which is the global rank-two minimum.  All other entries follow from the
component table in Section 2 in exactly the same way.  The minimum eight is
strictly larger than the rank-two orbit dimension seven.

## 8. Conclusion

For either fixed canonical `sigma`, the 60-dimensional coefficient space of
equations `A` surjects onto the 42-dimensional restricted coefficient space.
Pullback preserves the codimensions above.  Sweeping by the rank-three or
rank-two projective matrix orbit still leaves positive codimension in
`P_A^59`.

The adjacent theorem treats the no-separator `[2,1]` skeleton.  The exact
separator classification leaves only `F` and `S`, and Sections 3--7 treat
both without discarding the nonproper singleton tangent, the nonproper
minimal earlier essential, any continuation boundary, or any rank-two
base-point position.  Hence no root type `[2,1]` survives for a general
class-`(2,3)` equation.
