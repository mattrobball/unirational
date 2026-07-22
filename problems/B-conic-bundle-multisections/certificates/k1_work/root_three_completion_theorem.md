# Complete exclusion of root type `[3]`

## Statement

Work over an algebraically closed field of characteristic zero in the
square-free three-`t=2` row of
[`k1_frontier.md`](../k1_frontier.md).  For a general class-`(2,3)` equation
`A`, no rank-two or rank-three linear triple `sigma` has a rationality-row
branch octic whose three essential centers lie in one proper-origin tree.
In other words, essential root type `[3]` does not occur for general `A`.

The exact separator theorem
[`root_three_separator_theorem.md`](root_three_separator_theorem.md) reduces
the proof to `A-F`, `A-S`, and `F-F`:

- `A-F` and the proper-minimal `F-F` chain are completely excluded by the
  unloading and incidence proof in
  [`root_three_free_separator_theorem.md`](root_three_free_separator_theorem.md);
- `A-S` is incompatible with proximity after its forced tangent-line
  component is removed;
- a nonproper-minimal `F-F` chain is excluded by a tangent-line/curvette-conic
  incidence.  Constant-term gluing at the tangential intersection is the one
  extra condition needed in rank three.

All codimensions below are affine codimensions in the 42-dimensional
fixed-`sigma` restricted coefficient space.  They are unchanged on pulling
back to the 60-dimensional space of equations `A` and on projectivizing.

## 1. Unloading and exceptional valuations

For clarity, here is the cluster calculation used repeatedly.  Write

\[
 D=\sum_v d_vE_v^*
\]

in the full total-transform basis, where `d_v=1` at an essential center and
zero otherwise.  If `lambda_v` is the coefficient of the prime exceptional
\(\bar E_v\) in `D`, then

\[
 \lambda_v=d_v+\sum_{u:\,v\succ u}\lambda_u.    \tag{1.1}
\]

For a plane curve `G`, let `mu_v(G)` be the strict multiplicity of its
successive transform and let `nu_v(G)` be the coefficient of \(\bar E_v\) in
`f^*G`.  The identical recurrence is

\[
 \nu_v(G)=\mu_v(G)+
          \sum_{u:\,v\succ u}\nu_u(G).          \tag{1.2}
\]

Thus `G` gives a section of `O_Y(dH-D)` exactly when its degree is `d` and
`nu_v(G)>=lambda_v` at every center.  Equations (1.1)--(1.2) are also a
convenient explicit form of unloading; no raw infinitely-near weight is being
mistaken for an independent proper-point condition.

For `A-F`, the raw weights along its free chain are `(1,1,0,1)`, so the prime
coefficients are `(1,2,2,3)`.  If the initial tangent line follows the
separator, its valuations are `(1,2,3,3)`, and it belongs to `|H-D|`.
The required vanishing therefore forces the nonalignment used by the
free-separator incidence theorem.

For proper-minimal `F-F`, the raw weights are `(1,0,1,0,1)`, with prime
coefficients `(1,1,2,2,3)`.  The same aligned tangent line has valuations
`(1,2,3,3,3)`, so it too is forbidden by `H^0(O_Y(H-D))=0`.  Hence
[`root_three_free_separator_theorem.md`](root_three_free_separator_theorem.md)
already covers every `A-F` and every proper-minimal `F-F` chain.

## 2. The satellite edge `A-S` is impossible

The exact corrected and strict multiplicities in `A-S` are

\[
 (r_0,r_1,r_2,r_3)=(5,5,3,4),\qquad
 (m_0,m_1,m_2,m_3)=(5,4,2,2).                  \tag{2.1}
\]

Indeed, `S` can start only at the corrected quintuple center `z_1`.  If the
proper adjacent predecessor `z_0` had corrected multiplicity four, its
exceptional would be nonbranch and `z_1` would have strict multiplicity five,
contradicting `m_{z_0}=4>=m_{z_1}=5`.  Hence `r_0=5`, the exceptional over
`z_0` is a branch component, and `m_1=4`; the remaining entries are given in
equation (2.4) of
[`root_three_separator_theorem.md`](root_three_separator_theorem.md).

Here `z_0<z_1` is the adjacent essential pair, `z_2` is the free separator,
and \(z_3=\bar E_{z_2}\cap\bar E_{z_1}\) is the satellite essential
center.  The raw weights `(1,1,0,1)` now have prime coefficients

\[
 (\lambda_0,\lambda_1,\lambda_2,\lambda_3)
 =(1,2,2,5),                                    \tag{2.2}
\]

where the last value uses both proximity parents.

Let `tau` be the tangent line represented by `z_1`.  If `z_2` is its
continuation point, the valuations of `tau` are `(1,2,3,5)`: after the blowup
at `z_2`, the strict transform of `tau` goes to a free point, but the
exceptional valuation at the satellite is the sum `3+2`.  Equations
(1.1)--(1.2) would put `tau` in `|H-D|`.  Hence the linear vanishing forces
`z_2` away from that continuation.

Nevertheless

\[
 I_{z_0}(B,\tau)\geq m_0+m_1=9>8,
\]

so `tau` is a component of the octic.  The branch is square-free, so write
`B=tau+R` with `tau` not a component of `R`.  At `z_1` the strict
multiplicity of `R` is `4-1=3`, while `tau` misses both `z_2` and `z_3`, so

\[
 m_{z_2}(R)=m_{z_3}(R)=2.
\]

Both `z_2` and the satellite `z_3` are proximate to `z_1`.  The proximity
inequality for `R` would require

\[
 3=m_{z_1}(R)\geq m_{z_2}(R)+m_{z_3}(R)=4,
\]

a contradiction.  Thus `A-S` is empty already at the plane-curve level.

## 3. The last nonproper-minimal `F-F` chain

By the minimal-essential lemma, this chain consists of six successive free
centers

\[
 x_0<x_1<x_2<x_3<x_4<x_5,                     \tag{3.1}
\]

with

\[
 (r_0,r_1,r_2,r_3,r_4,r_5)=(3,4,3,4,3,4),
 \qquad m_i=3\quad(0\leq i\leq5).              \tag{3.2}
\]

The proper center `x_0` is negligible; `x_1,x_3,x_5` are essential.  Thus
the raw weights of `D` are `(0,1,0,1,0,1)`, and their prime coefficients are

\[
 (0,1,1,2,2,3).                                \tag{3.3}
\]

Let `tau` be the tangent line through `x_0,x_1`.  If it also followed `x_2`,
its valuations would be `(1,2,3,3,3,3)`, which dominate (3.3).  The linear
cluster vanishing therefore forces `tau` to leave the chain at `x_2`.

There is then a unique conic `Q` whose strict transforms pass through
`x_0,...,x_4`.  In local coordinates `x_0=(0,0)`, `tau=(y=0)`, it has the
form

\[
 y+A x^2+Bxy+Cy^2=0.                           \tag{3.4}
\]

The centers `x_2,x_3,x_4` determine `A,B,C`, and the nonalignment just proved
is \(A\ne0\).  The homogeneous conic matrix has determinant `-A/4`; hence `Q`
is smooth.  Moreover `Q` and `tau` are tangent at `x_0` and have no other
intersection.

The conic cannot continue through `x_5`.  Indeed, the raw weights of `2D`
are `(0,2,0,2,0,2)`, whose prime coefficients are

\[
 (0,2,2,4,4,6).                                \tag{3.5}
\]

If `Q` followed all six centers, its valuations would be
`(1,2,3,4,5,6)`, which dominate (3.5), contradicting
`H^0(O_Y(2H-2D))=0`.

Put

\[
 \Gamma=Q\cup\tau.                             \tag{3.6}
\]

The chain moves in dimension `2+5=7`.  The infinitely-near intersection
formula and (3.2) give

\[
 B|_Q\in x_0^{15}H^0(O_{\mathbf P^1}(1)),
 \qquad
 B|_\tau\in x_0^6H^0(O_{\mathbf P^1}(2)).      \tag{3.7}
\]

Both target spaces include zero restriction.

## 4. The rank-three gluing bound

For the canonical rank-three triple, restriction to the reduced cubic
`Gamma` is surjective onto a 36-dimensional vector space.  On `Q` the binary
coefficient degrees are `(8,8,8)`.  The determinant target in (3.7) has
dimension two, so the fixed-determinant bounds of
[`adjacent_nested_pair_theorem.md`](adjacent_nested_pair_theorem.md#2-binary-determinant-bounds-used-below)
give a bad-locus bound `10+2=12`.  On `tau` the degrees are `(5,4,3)` and the
three-dimensional target gives `6+3=9`.

Adding `12+9` would discard all six gluing equations at the tangential
length-two intersection and leave only equality with the eight-dimensional
rank-three orbit.  The following elementary constant-term lemma retains one
more condition.

**Gluing lemma.**  Inside the product of the two normalization restriction
spaces, the pairs satisfying (3.7) and having the same quadratic-form value
at `x_0` have dimension at most twenty.

To prove it, call the common symmetric `2 x 2` value `M`.  The determinant
contact conditions imply `det(M)=0`.

If `M=0`, every entry on both components is divisible by the linear form of
`x_0`.  After division, the conic degrees become `(7,7,7)` and its determinant
target becomes `x_0^13H^0(O(1))`, of dimension two.  Fixed nonzero and zero
determinants in `(7,7,7)` have dimension at most nine, so this part has
dimension at most eleven.  On the line the divided degrees are `(4,3,2)` and
the target is `x_0^4H^0(O(2))`, of dimension three.  Its fixed and zero
fibers have dimension at most five, giving dimension at most eight.  The
`M=0` product therefore has dimension at most nineteen.

Now let `M` have rank one.  Such nonzero values move in a two-dimensional
cone.  For fixed `M`, a constant congruence on the equal-degree conic triple
puts `M` in the chart \(a(x_0)\ne0\).  For a fixed determinant, choose `a` with
its value at `x_0` fixed.  The congruence

\[
 b^2\equiv-f\pmod a
\]

has only the usual locally compensated square-root freedom; forms `b` of the
same degree differ modulo `a` by a scalar multiple of `a`, and the prescribed
value `b(x_0)` fixes that scalar.  Thus the fixed-determinant fiber has
dimension at most eight, rather than ten.  The two-dimensional determinant
target gives a conic bound ten.  The zero determinant gives the same bound
directly from `h(u^2,uv,v^2)`.

For the line degrees `(5,4,3)`, if \(c(x_0)\ne0\), the identical calculation
with `c` gives fixed-determinant dimension at most four.  If `c(x_0)=0`, then
rank one forces \(b(x_0)=0\) and \(a(x_0)\ne0\); choosing `a` gives the weaker but
sufficient bound five.  After the three-dimensional determinant target is
added, the line contribution is at most eight.  Hence the rank-one-value
stratum has dimension at most

\[
 10+8+2=20.                                    \tag{4.1}
\]

This proves the lemma.  First-derivative gluing can only cut the locus
further.  The fixed-`sigma` rank-three codimension is therefore at least

\[
 36-20-7=9>8.                                  \tag{4.2}
\]

## 5. Rank two

Let `b` be the base point of the canonical rank-two triple.  No gluing
improvement is needed in rank two.  The restriction image ranks on `Gamma`
are `36`, `33`, and `32` according as `b` is off `Gamma`, on one component
away from `x_0`, or equal to the tangential point `x_0`.

The exhaustive bounds are

\[
\begin{array}{c|c|c|c|c|c}
\text{position of }b&\dim\text{ config}&\text{image rank}&Q\text{ bad}&
\tau\text{ bad}&\text{codim}\ \\ \hline
b\notin\Gamma&7&36&12&9&8\\
b\in Q,\ b\ne x_0&6&33&9&9&9\\
b\in\tau,\ b\ne x_0&6&33&12&6&9\\
b=x_0&5&32&11&8&8.
\end{array}                                    \tag{5.1}
\]

Here are the component bounds.  Away from `b`, the conic degrees are
`(10,8,6)`.  The two-dimensional target in (3.7) has preimage dimension at
most twelve; its square subcone is one-dimensional, so the exceptional
eleven-dimensional square fiber causes no increase.  If `b` lies on `Q`
away from `x_0`, its forced double zero together with the order-fifteen zero
at `x_0` exceeds degree sixteen, so the determinant is zero; after removing
the base-point square, the `(8,7,6)` zero locus has dimension nine.  If
`b=x_0`, removal of that square gives degrees `(8,7,6)` and the
two-dimensional target `x_0^13H^0(O(1))`, for a bound eleven.

On `tau`, the off-base-point bound is nine.  If `b` lies on `tau` away from
`x_0`, removing its forced square leaves a `(3,3,3)` determinant in the
one-dimensional space `k x_0^6`, giving dimension six.  If `b=x_0`, the
residual determinant belongs to the three-dimensional space
`x_0^4H^0(O(2))`, giving dimension eight.

Every entry in the last column of (5.1) exceeds the seven-dimensional
rank-two matrix orbit.  Together with (4.2), this excludes the final
nonproper-minimal `F-F` chain and completes root type `[3]`.

The recurrence and codimension arithmetic are checked in
[`root_three_completion_local_checks.py`](root_three_completion_local_checks.py),
with recorded output in
[`root_three_completion_local_checks.log`](root_three_completion_local_checks.log).
