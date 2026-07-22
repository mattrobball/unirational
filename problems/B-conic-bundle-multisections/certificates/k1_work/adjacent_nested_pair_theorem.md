# Exclusion of an adjacent nested pair in the three-`t=2` row

## Statement

Work over an algebraically closed field of characteristic zero.  Consider the
square-free octic row of [`k1_frontier.md`](../k1_frontier.md), so the complete
canonical resolution has exactly three essential centers with `t=2`, all
other centers have `t=1`, and both cluster systems

\[
 H^0(O_Y(H-D))=H^0(O_Y(2H-2D))=0
 \tag{0.1}
\]

vanish.  This note excludes the following genuine infinitely-near subrow for
a general class-`(2,3)` equation `A`:

- one essential center `p` is proper;
- a second essential center `q` is the point immediately over `p` in a
  tangent direction `tau`; and
- the third essential center `r` is proper.

The conclusion holds for both rank-three and rank-two linear triples
`sigma`.  More precisely, after fixing a canonical `sigma`, the union of this
bad locus has codimension at least nine in its 42-dimensional restricted
coefficient space.  The rank-three and rank-two projective matrix orbits have
dimensions eight and seven, respectively, so neither swept incidence can
dominate the coefficient space of `A`.

The same method also excludes the smallest free root type `[3]`: three
successive essential centers `p<q<s`, with `p` proper, `q` first-near, and
`s` a free point immediately over `q`.  In that case the two cluster
vanishings force `s` not to be the continuation point of the tangent line,
and the fixed-`sigma` codimension is at least ten.

Finally, it excludes the adjacent root type `[2,1]` with the same
proper-rooted adjacent pair when the singleton is nonproper.  Such a
singleton has the forced first-near corrected sequence
`(3,4)`.  If its tangent is not the joining line of the two proper origins,
the fixed-`sigma` codimension is ten.  In the aligned stratum it is nine for
rank three and at least eight for rank two, still larger than the respective
orbit dimensions.

The first subrow is a nonempty Enriques-diagram type, not a formal boundary
artifact.  A
square-free octic realizing corrected multiplicities `(4,4)` at `p<q` and
`4` at `r`, with both vanishings (0.1), is constructed in
[`contact_cubic_observation.md`](contact_cubic_observation.md#1-the-line-vanishing-does-not-separate-the-proper-origins).

The theorem does not classify a later essential descendant separated from
its essential predecessor by negligible centers, nor a root type `[3]` with
a satellite step or such a separation between essential centers.

## 1. The cluster condition and the tangent test cubic

In the total-transform basis the essential divisor in this subrow is

\[
 D=E_p+E_q+E_r,
 \]

where `q` is proximate to `p`.  The weights `(1,1)` at `p<q` satisfy the
proximity inequality, so no unloading changes this part of `D`.  A line in
`|H-D|` would have to be the line `pr`, while its strict transform would also
have to pass through `q`.  Therefore the first vanishing in (0.1) says

\[
 r\notin\tau .                                  \tag{1.1}
\]

Conversely, a conic in `|2H-2D|` has multiplicity at least two at `p`, at
least two at `q`, and at least two at `r`.  The first two conditions force the
conic to be the doubled tangent line `tau^2`; the condition at `r` then fails
exactly when (1.1) holds.  Thus, for this diagram, the two vanishings are
equivalent to (1.1).

Choose a smooth conic `Q` through `r` and tangent to `tau` at `p`, and put

\[
 \Gamma=Q\cup\tau .                             \tag{1.2}
\]

Such conics form a projective plane.  Since `r` is not on `tau`, a general
member is smooth and does not contain `tau`.  The reduced cubic `Gamma` has
the two components tangent at `p`.

Let `m_v` denote the multiplicity of the strict plane branch at a canonical
center `v`, and `r_v` its corrected multiplicity.  At the proper center `p`,
`m_p=r_p` is four or five.  If `r_p=4`, the exceptional curve is not inserted
in the branch and essentiality of `q` gives `m_q>=4`.  If `r_p=5`, that
exceptional curve is inserted and essentiality gives `m_q>=3`.  Hence in
both cases

\[
 m_p+m_q\ge8.                                  \tag{1.3}
\]

The infinitely-near intersection formula, applied to both `tau` and the
smooth conic `Q`, now gives

\[
 I_p(B,\tau)\ge8,
 \qquad I_p(B,Q)\ge8.                           \tag{1.4}
\]

At the proper essential center `r`, one also has `I_r(B,Q)>=4`.  Since the
restrictions of an octic to `tau` and `Q` have degrees eight and sixteen,
respectively,

\[
 B|_\tau\in k\,p^8,
 \qquad
 B|_Q\in p^8r^4 H^0(O_{\mathbf P^1}(4)).        \tag{1.5}
\]

Zero restriction, corresponding to a component of `B`, is included in both
linear spaces.

The conic `Q` is an auxiliary test curve and does not add parameters.  Over
the five-dimensional configuration space `(p,tau,r)`, the conics satisfying
the three linear conditions form a projective-plane bundle.  On a finite
stratification of the base it has a rational section, and (1.5) holds for
every member.  Choosing such a section therefore bounds the original
incidence without replacing it by the larger incidence in which `Q` is an
independent moving variable.

## 2. Binary determinant bounds used below

For nonnegative integers `A,B,C` with `A+C=2B`, write

\[
 V_{A,B,C}=H^0(O(A))\oplus H^0(O(B))\oplus H^0(O(C)),
 \qquad (a,b,c)\longmapsto ac-b^2.
\]

The following affine bounds include all diagonal boundaries:

| `(A,B,C)` | fixed nonzero determinant | determinant zero |
|---:|---:|---:|
| `(8,8,8)` | at most `10` | at most `10` |
| `(10,8,6)` | at most `10`, except at most `11` for a square | at most `11` |
| `(8,7,6)` | at most `9` | at most `9` |
| `(5,4,3)` | at most `6` | at most `6` |
| `(3,3,3)` | at most `5` | at most `5` |

Here is a uniform proof of the nonzero columns.  On `c!=0`, first choose
`c`, and solve

\[
 b^2=-f\pmod c .                                \tag{2.1}
\]

Restriction of degree-`B` forms to the zero scheme of `c` is surjective.
This follows from `H^1(O(B-C))=0` in every degree pattern in the table.

The local compensation can be computed exactly.  Suppose `c` has
multiplicity `m` at a fixed root of `f`, and write `f=z^k u` in
`k[z]/(z^m)`, with `u` a unit when `k<m`.  The solution scheme of

\[
 w^2=-z^k u\pmod {z^m}
\]

is empty if `k<m` is odd.  If `k<m` is even, write `k=2h`: the unit square
root is a finite choice modulo `z^(m-k)`, and precisely its last `h`
coefficients are free.  If `k>=m`, the equation is `w^2=0` and says
`ord(w)>=ceil(m/2)`, leaving `floor(m/2)` free coefficients.  Thus the local
dimension is

\[
 \delta(m,k)=
 \begin{cases}
  k/2,&k<m\text{ even},\\
  \lfloor m/2\rfloor,&k\ge m,
 \end{cases}                                    \tag{2.2}
\]

whenever the local scheme is nonempty.  In particular `delta(m,k)<=m`.
Prescribing multiplicity `m` of `c` at this fixed root imposes `m` linear
conditions on `c`.  The roots of the fixed nonzero `f` are finite, while at
all other roots of `c` the right side is a unit and has only finitely many
square roots.  The Chinese remainder theorem and a stratification by the
root multiplicities of `c` therefore show that every positive-dimensional
local square-root freedom is compensated by at least the same codimension
in the choice of `c`.  Consequently

\[
 \dim\{(a,b,c):ac-b^2=f,\ c\ne0\}
 \le (C+1)+(B-C+1)=B+2.                         \tag{2.3}
\]

The entry `a` is then determined.  On `c=0`, the equation is `b^2=-f` and
`a` is arbitrary.  This has dimension `A+1` when `f` is a square and is
empty otherwise.  It only exceeds (2.3) for `(10,8,6)`, where it has
dimension eleven.  For `f=0`, the exhaustive UFD factorization

\[
 (a,b,c)=h(u^2,uv,v^2)
\]

together with `(a,0,0)` and `(0,0,c)` gives the last column.  These are the
same zero-fiber counts used in
[`conic_factor_theorem.md`](conic_factor_theorem.md) and
[`proper_three_center_theorem.md`](proper_three_center_theorem.md).

We need the following consequences.  If `U` is the five-dimensional space
`p^8r^4H^0(O(4))` inside degree-sixteen forms, then

\[
 \begin{aligned}
 \dim\{V_{8,8,8}:\det\in U\}&\le15,\\
 \dim\{V_{10,8,6}:\det\in U\}&\le15.
 \end{aligned}                                  \tag{2.4}
\]

For the second line, the nonsquare part has dimension at most `10+5=15`.
The squares in `U` are the squares of
`p^4r^2H^0(O(2))`, so they form a three-dimensional cone; even the
eleven-dimensional square boundary therefore contributes at most fourteen.
The zero fiber has dimension eleven.  Similarly,

\[
 \dim\{V_{8,7,6}:\det\in U'\}\le14             \tag{2.5}
\]

for every five-dimensional `U'`.  Finally, the preimages of a fixed
one-dimensional determinant space in `V_{5,4,3}` and `V_{3,3,3}` have
dimensions at most seven and six, while their zero fibers have dimensions
six and five.

The exact arithmetic in this section and every dimension and codimension
calculation derived from the geometric restriction-image ranks proved below
are checked by
[`adjacent_nested_pair_local_checks.py`](adjacent_nested_pair_local_checks.py),
with recorded output in
[`adjacent_nested_pair_local_checks.log`](adjacent_nested_pair_local_checks.log).

## 3. Rank three

Fix the canonical rank-three triple and put

\[
 E=\Omega^1_{\mathbf P^2}(1),\qquad
 \mathcal Q=\operatorname{Sym}^2(E^\vee)\otimes O(3),\qquad
 W_3=H^0(\mathcal Q),
\]

so `dim W_3=42` and `B=det(q)`.  The symmetric-square Euler resolution gives

\[
 H^1(\mathcal Q(-3))=0,
 \qquad h^0(\mathcal Q(-3))=6.
\]

Consequently restriction to the reduced cubic (1.2) is surjective onto a
36-dimensional space:

\[
 W_3\longrightarrow H^0(\Gamma,\mathcal Q|_\Gamma). \tag{3.1}
\]

On the normalization of `tau`, the coefficient degrees are `(5,4,3)`, and
(1.5) together with Section 2 bounds the bad restriction locus by seven.
On the normalization of `Q`, one has

\[
 E^\vee|_Q\simeq O(1)\oplus O(1),
 \qquad \mathcal Q|_Q\simeq O(8)^3,
\]

so (1.5) and (2.4) bound the bad locus by fifteen.

Because `Gamma` is reduced, restriction to its normalization is injective.
The gluing conditions at its tangential double point can only lower
dimension.  Thus
the bad locus in the target of (3.1) has dimension at most

\[
 7+15=22,
\]

and its fixed-configuration codimension is at least `36-22=14`.  The ordered
configuration `(p,tau,r)` moves in dimension

\[
 2+1+2=5.
\]

For a fixed rank-three `sigma`, its union therefore has codimension at least

\[
 14-5=9>8.                                      \tag{3.2}
\]

## 4. Rank two

Fix the canonical rank-two triple with base point `b`, and work on
`Z=Bl_b(P^2)`.  With `H` the pullback of a line and `E_b` the exceptional
curve, the restricted coefficient space is

\[
 \begin{aligned}
 W_2={}&H^0(O(5H-2E_b))\oplus H^0(O(4H-E_b))
       \oplus H^0(O(3H)),\\
 &\dim W_2=42,
 \qquad \pi^*B=E_b^2\det(q).
 \end{aligned}                                  \tag{4.1}
\]

For the strict transform of a cubic having multiplicity `mu=0,1,2` at `b`,
the restriction image ranks are

\[
 \begin{array}{c|ccc}
 \mu&0&1&2\\ \hline
 \operatorname{rank}(W_2\to W_2|_{\widetilde\Gamma})&36&33&32.
 \end{array}                                    \tag{4.2}
\]

Indeed, after subtracting `3H-mu E_b`, the three kernel bundles are

\[
\begin{array}{c|ccc|c}
\mu&\text{first}&\text{second}&\text{third}&(h^0\text{ values})\\ \hline
0&2H-2E_b&H-E_b&0&(3,2,1)\\
1&2H-E_b&H&E_b&(5,3,1)\\
2&2H&H+E_b&2E_b&(6,3,1).
\end{array}
\]

All relevant `H^1` groups vanish in the first two rows.  In the last row
`h^1(O(2E_b))=1`, so the 33-dimensional component/gluing target has a
one-dimensional cokernel and the actual image has rank 32.

Choose `Q` rationally as in Section 1 and, when neither marked point is `b`,
avoid `b`.  The four exhaustive positions of `b` give the following table.
The columns `Q bad` and `tau bad` are affine dimension upper bounds in the
normalization component spaces; ignoring their gluing only enlarges the bad
locus.

| position of `b` | configuration dimension | image rank | `Q` pattern and bad dimension | `tau` pattern and bad dimension | final codimension |
|---|---:|---:|---:|---:|---:|
| `b` on neither component | `5` | `36` | `(10,8,6)`, `15` | `(5,4,3)`, `7` | `36-15-7-5=9` |
| `b in tau`, `b!=p` | `4` | `33` | `(10,8,6)`, `15` | `(3,3,3)`, `5` | `33-15-5-4=9` |
| `b=p` | `3` | `32` | `(8,7,6)`, `14` | `(3,3,3)`, `6` | `32-14-6-3=9` |
| `b=r` | `3` | `33` | `(8,7,6)`, `14` | `(5,4,3)`, `7` | `33-14-7-3=9` |

Here are the divisor calculations behind the table.

- Away from `b`, the conic and line patterns are `(10,8,6)` and `(5,4,3)`,
  and (1.5) gives the five- and one-dimensional determinant spaces already
  used in (2.4).
- If `b` lies on `tau` away from `p`, then `Q.tau=2p` ensures `b` is not on
  `Q`.  The forced basepoint square at `b`, together with the order-eight
  zero at `p`, makes `B|_tau` identically zero.  After removing that square,
  the `(3,3,3)` determinant is zero, whose locus has dimension five.
- If `b=p`, removing the basepoint square changes the conic condition to
  `p^6r^4H^0(O(4))` in degree fourteen.  Equation (2.5) gives dimension
  fourteen.  On `tau`, the residual degree-six determinant belongs to the
  one-dimensional space `k p^6`, giving dimension six.  The two components
  are tangent at `b`, so the cubic has multiplicity two there and the actual
  image rank is 32.
- If `b=r`, the conic condition becomes
  `p^8r^2H^0(O(4))` in degree fourteen, again giving dimension fourteen by
  (2.5).  The line avoids `b` and contributes seven.

Thus the fixed-rank-two union has codimension at least nine in every
basepoint stratum, strictly greater than the seven-dimensional projective
rank-two orbit.

## 5. A free chain of three adjacent essential centers

There is a parallel exclusion for a minimal root type `[3]`.  Suppose the
three essential centers form a successive free chain

\[
 p<q<s,
\]

where `p` is proper, `q` represents the tangent direction `tau`, and `s` is
a free point on the exceptional curve created over `q`.  Let `s_tau` be the
point reached by the strict transform of the line `tau` after the second
blowup.

The weights of `D=E_p+E_q+E_s` are already antinef.  A line in `|H-D|`
must be `tau` and exists precisely when `s=s_tau`.  A conic in `|2H-2D|`
has multiplicity two at both `p` and `q`, hence is `tau^2`; its strict
transform also reaches `s_tau`.  Thus the two vanishings in (0.1) are both
equivalent in this diagram to

\[
 s\ne s_\tau.                                   \tag{5.1}
\]

Choose a smooth conic `Q` whose successive strict transforms pass through
`q` and `s`.  These conics again form a projective plane, and a general one
is smooth.  Condition (5.1) says that `Q` is not the doubled line `tau`; in
fact `Q` and `tau` are tangent at `p` and have no other intersection.  Put
\(\Gamma=Q\cup\tau\) as before.

Write `epsilon_v=1` when the corrected multiplicity `r_v` is five and zero
when it is four.  Because the chain is free, the only exceptional branch
through the next center is the one inserted at its immediate predecessor.
Therefore

\[
 \begin{aligned}
 m_p&=4+\epsilon_p,\\
 m_q&=4+\epsilon_q-\epsilon_p,\\
 m_s&=r_s-\epsilon_q\ge4-\epsilon_q.
 \end{aligned}
\]

It follows that

\[
 m_p+m_q\ge8,
 \qquad m_p+m_q+m_s\ge12.                      \tag{5.2}
\]

The line follows the first two centers and the conic follows all three, so
the infinitely-near intersection formula gives

\[
 B|_\tau\in k\,p^8,
 \qquad B|_Q\in p^{12}H^0(O_{\mathbf P^1}(4)).  \tag{5.3}
\]

These determinant target spaces have the same dimensions one and five as in
(1.5).  Hence the component bad dimensions are again seven and fifteen.
For rank three the cubic restriction target has dimension 36, so the fixed
configuration codimension is fourteen.  The chain `(p,q,s)` moves in
dimension `2+1+1=4`, leaving fixed-`sigma` codimension

\[
 14-4=10.                                       \tag{5.4}
\]

For rank two there are only three basepoint positions after choosing `Q` to
avoid `b` whenever possible:

| position of `b` | configuration dimension | image rank | `Q` bad | `tau` bad | final codimension |
|---|---:|---:|---:|---:|---:|
| `b` on neither component | `4` | `36` | `15` | `7` | `36-15-7-4=10` |
| `b in tau`, `b!=p` | `3` | `33` | `15` | `5` | `33-15-5-3=10` |
| `b=p` | `2` | `32` | `14` | `6` | `32-14-6-2=10` |

In the last row, removing the basepoint square changes the degree-fourteen
conic target to `p^10H^0(O(4))`; (2.5) gives dimension fourteen.  The line
target is again the one-dimensional space `k p^6`.  This proves the claimed
rank-two exclusion of the free adjacent `[3]` chain.

## 6. An adjacent pair and an isolated first-near singleton

The preceding argument also covers the other smallest `[2,1]` skeleton.
Keep the adjacent essential pair `p<q` with tangent `tau`, but suppose the
third essential center `s` is nonproper and has no essential predecessor in
its separate proper-origin tree.  The lemma in
[`contact_cubic_observation.md`](contact_cubic_observation.md#2-an-essential-center-with-no-essential-predecessor)
then gives a proper point `r` and a tangent direction `upsilon` such that

\[
 (m_r,m_s)=(3,3),\qquad (r_r,r_s)=(3,4),        \tag{6.1}
\]

with `s` the first point over `r`.

Unloading the single weight at `s` replaces it by a simple weight at `r`,
whereas the adjacent weights at `p<q` remain unchanged.  A line in `|H-D|`
would therefore have to be `tau` and contain `r`.  Moreover, the doubled
weights at `p<q` force any conic in `|2H-2D|` to be `tau^2`.  Hence both
cluster systems vanish simultaneously exactly when

\[
 r\notin\tau.                                   \tag{6.2}
\]

Let `L=pr`.  First suppose `upsilon!=L`.  Choose a smooth conic `Q` tangent
to `tau` at `p` and to `upsilon` at `r`.  These four linear conditions leave
a projective pencil, whose general member is smooth under (6.2) and
`upsilon!=L`.  The contact estimates are

\[
 I_p(B,Q)\ge8,\qquad I_r(B,Q)\ge m_r+m_s=6,
\]

and therefore

\[
 B|_\tau\in k\,p^8,
 \qquad B|_Q\in p^8r^6H^0(O_{\mathbf P^1}(2)).  \tag{6.3}
\]

The conic determinant target now has dimension three, so its bad preimage
has dimension at most thirteen for `(8,8,8)` and `(10,8,6)`, and at most
twelve for `(8,7,6)`.  In the `(10,8,6)` case the square target has dimension
two: its roots are `p^4r^3H^0(O(1))`, so the eleven-dimensional square
boundary still contributes only thirteen.

The configuration `(p,tau,r,upsilon)` moves in dimension six.  The rank-three
count and the four rank-two counts are

\[
 36-(7+13)-6=10
\]

and

\[
\begin{array}{c|c|c|c|c|c}
\text{position of }b&\dim\text{ config}&\text{image rank}&Q\text{ bad}&
\tau\text{ bad}&\text{final codim}\ \hline
b\notin Q\cup\tau&6&36&13&7&10\\
b\in\tau,\ b\ne p&5&33&13&5&10\\
b=p&4&32&12&6&10\\
b=r&4&33&12&7&10.
\end{array}                                     \tag{6.4}
\]

As before, if `b` is unmarked and not on `tau`, choose the auxiliary conic
from its pencil so that it avoids `b`.

It remains to treat the special alignment `upsilon=L`.  Every conic with the
two requested tangent conditions is then reducible, so using it together
with `tau` would repeat a component.  Instead restrict directly to the
reduced conic

\[
 \Delta=\tau\cup L.
\]

Along `L`, the proper essential center `p` contributes at least four and the
`(3,4)` cluster at `r<s` contributes at least six.  Thus `B|_L=0`, while
`B|_tau` still lies in `k p^8`.  For rank three the restriction target has
dimension 27: the symmetric-square Euler resolution gives
\(H^1(\mathcal Q(-2))=0\) and \(h^0(\mathcal Q(-2))=15\).  The bad product has
dimension at most `7+6=13`.  This gives

\[
 27-13-5=9,                                     \tag{6.5}
\]

because `(p,tau,r)` moves in dimension five.

For rank two, restriction to the strict transform of a plane conic of
multiplicity `mu=0,1,2` at `b` has image rank `27,24,23`, respectively.
Indeed, after subtracting `2H-mu E_b`, the three kernel-summand `h^0` values
are `(7,5,3)`, `(9,6,3)`, and `(10,6,3)`.  In the last row the
24-dimensional component target has a one-dimensional cokernel, just as in
the multiplicity-two cubic calculation of Section 4.
The complete special-alignment table is

\[
\begin{array}{c|c|c|c|c|c}
\text{position of }b&\dim\text{ config}&\text{image rank}&
\tau\text{ bad}&L\text{ bad}&\text{final codim}\ \hline
b\notin\Delta&5&27&7&6&9\\
b\in\tau,\ b\ne p&4&24&5&6&9\\
b\in L,\ b\ne p,r&4&24&7&5&8\\
b=p&3&23&6&5&9\\
b=r&3&24&7&5&9.
\end{array}                                     \tag{6.6}
\]

The minimum is eight, still strictly greater than the rank-two orbit
dimension seven.  This excludes the adjacent-pair plus isolated-first-near
subrow in both the generic and aligned tangent strata.

## 7. Incidence conclusion and diagrams left at this stage

For fixed `sigma`, the coefficient map from the 60-dimensional space of
class-`(2,3)` equations `A` onto `W_3` or `W_2` is surjective.  Pullback
therefore preserves all the displayed codimension bounds.  Their minima are
nine in rank three and eight in rank two, strictly larger than the respective
orbit dimensions eight and seven.  Adding the matrix orbit still leaves
positive codimension in `P_A^59`.  This proves the stated exclusions.

The calculation also identifies why the two cluster vanishings do not reduce
the entire frontier to the already excluded three-proper-center case.  The
root partition `[2,1]` above satisfies both vanishings and occurs for reduced
octic curves.  What this note excludes is its smallest adjacent nested form
with a proper singleton, together with the smallest free adjacent `[3]`
chain and the `[2,1]` type with an isolated first-near singleton.  Combining
this note with the three-proper-center theorem, the cases left at that stage
were organized at the essential-skeleton level as follows:

1. Root type `[1,1,1]`, with at least one nonproper essential center.  Every
   such center is an immediate `(3,4)` first-near center by the
   no-essential-predecessor lemma.
2. Root type `[2,1]`, with at least one `t=1` center separating the two
   essentials in the repeated tree.  An adjacent pair whose minimal
   essential is proper is covered by Sections 1 and 6.  If that minimal
   essential is nonproper, it is a `(3,4)` center over a proper triple point.
   The immediate-successor corollary in
   [`contact_cubic_observation.md`](contact_cubic_observation.md#2-an-essential-center-with-no-essential-predecessor)
   proves that it cannot be followed immediately by an essential center.
   Thus every repeated pair left at that stage was genuinely separated.
3. Root type `[3]`, except for the proper-root successive-free adjacent chain
   of Section 5.  This includes satellite steps, `t=1` separations, branching,
   and chains with a nonproper minimal essential center.

These patterns have different unloaded degree-one and degree-two cluster
ideals, so replacing them by three noncollinear proper origins is not valid.
They are subsequently excluded by
[`three_singleton_first_near_theorem.md`](three_singleton_first_near_theorem.md),
[`root_two_one_separator_theorem.md`](root_two_one_separator_theorem.md), and
[`root_three_completion_theorem.md`](root_three_completion_theorem.md), with
the separator lemmas cited there.
