# Free-separator exclusions in root type `[3]`

## Statement

Work over an algebraically closed field of characteristic zero in the
square-free three-`t=2` row of
[`k1_frontier.md`](../k1_frontier.md).  The exact separator classification in
[`root_three_separator_theorem.md`](root_three_separator_theorem.md) leaves
two free-chain subrows to which a conic through the marked chain can apply.

The first is the edge pattern `A-F`, a successive-free chain

\[
 z_0<z_1<z_2<z_3
 \tag{0.1}
\]

with corrected multiplicities and strict multiplicities

\[
 (r_0,r_1,r_2,r_3)=(4+\epsilon,4,3,4),
 \qquad
 (m_0,m_1,m_2,m_3)=(4+\epsilon,4-\epsilon,3,3),
 \tag{0.2}
\]

where `epsilon` is zero or one.  The essential centers are
`z_0,z_1,z_3`; the first pair is adjacent, and `z_2` is their unique free
separator from `z_3`.

The second is the proper-minimal `F-F` pattern, a successive-free chain

\[
 z_0<z_1<z_2<z_3<z_4
 \tag{0.3}
\]

with

\[
 (r_0,r_1,r_2,r_3,r_4)=(4,3,4,3,4),
 \qquad
 (m_0,m_1,m_2,m_3,m_4)=(4,3,3,3,3).
 \tag{0.4}
\]

Here `z_0,z_2,z_4` are essential and `z_1,z_3` are their free separators.

Let `tau` be the tangent line represented by `z_1`, and let
`z_{2,tau}` be its continuation point after the second blowup.  On the
nonaligned locus

\[
 z_2\ne z_{2,\tau},
 \tag{0.5}
\]

the incidence calculation below gives the following bounds.  For a fixed
canonical linear triple `sigma`, the `A-F` locus has codimension at
least eleven in both ranks.  The proper-minimal `F-F` locus has codimension at
least eleven in rank three and at least ten in rank two.  These bounds exceed
the projective matrix-orbit dimensions eight and seven.

On the aligned locus `z_2=z_{2,tau}`, the tangent line itself belongs to the
complete linear cluster system `H^0(O_Y(H-D))`; thus this locus is absent from
the rationality row.  Consequently all `A-F` chains and all proper-minimal
`F-F` chains are excluded for a general `A`.  The same unloading argument
excludes a nonproper-minimal `F-F` chain whenever its initial tangent line
follows the first free separator.  It also excludes `A-S` whenever the tangent
line of its adjacent pair follows the satellite separator's intermediate
center.  The complementary `A-S` and nonproper-minimal `F-F` chains are not
covered here.

## 1. Conics through the free clusters

Take local coordinates `z_0=(0,0)` and `tau=(y=0)`.  After scaling its
nonzero linear term, a conic tangent to `tau` has local equation

\[
 Q:\ y+A x^2+Bxy+Cy^2=0.
 \tag{1.1}
\]

After the first two blowups, `A` specifies `z_2`; condition (0.5) is
\(A\ne0\).  The coefficient `B` then specifies `z_3`, and `C` specifies `z_4`.
The homogeneous conic matrix has determinant `-A/4`, so every resulting
conic is smooth.

For the length-four chain (0.1), the first four cluster conditions leave a
projective pencil of smooth conics.  For the length-five chain (0.3), they
determine a unique smooth conic.  In both cases

\[
 Q\cdot\tau=2z_0,
 \qquad \Gamma=Q\cup\tau
 \tag{1.2}
\]

is a reduced cubic with two components tangent at `z_0`.

For `A-F`, choose `Q` rationally from its pencil on a finite stratification of
the five-dimensional chain space.  It adds no incidence parameters and, in
rank two, can be chosen to avoid the fixed base point whenever that point is
not `z_0`; if the base point lies on `tau` away from `z_0`, avoidance is
automatic from (1.2).  For `F-F`, the conic is unique and the chain space has
dimension six.  Rank two then has one additional codimension-one stratum in
which its fixed base point lies on `Q` away from `z_0`.

## 2. Contact orders

For `A-F`, (0.2) gives

\[
 \sum_{i=0}^3m_i=14,
 \qquad m_0+m_1=8.
 \tag{2.1}
\]

The conic follows the whole chain, while `tau` leaves it at `z_2` under
(0.5).  The infinitely-near intersection formula therefore gives

\[
 B|_Q\in z_0^{14}H^0(O_{\mathbf P^1}(2)),
 \qquad B|_\tau\in k z_0^8.
 \tag{2.2}
\]

For proper-minimal `F-F`, (0.4) gives

\[
 \sum_{i=0}^4m_i=16,
 \qquad m_0+m_1=7,
 \tag{2.3}
\]

and hence

\[
 B|_Q\in k z_0^{16},
 \qquad B|_\tau\in z_0^7H^0(O_{\mathbf P^1}(1)).
 \tag{2.4}
\]

Zero restriction, corresponding to a branch component, is included in all
four target spaces.

## 3. Component determinant bounds

Use the exact binary fixed-fiber bounds proved in Section 2 of
[`adjacent_nested_pair_theorem.md`](adjacent_nested_pair_theorem.md).

For `A-F`, the conic determinant target in (2.2) has affine dimension three.
Its preimage has dimension at most thirteen for coefficient degrees
`(8,8,8)` and `(10,8,6)`.  In the latter pattern, the exceptional
eleven-dimensional square fiber causes no increase: the squares in the
target are the squares of `z_0^7H^0(O(1))`, a two-dimensional cone.  When the
rank-two base point equals `z_0`, removal of its forced square changes the
degrees to `(8,7,6)` and the determinant target to
`z_0^12H^0(O(2))`, whose preimage has dimension at most twelve.

The line target for `A-F` has preimage dimensions seven for `(5,4,3)`, five
for the determinant-zero `(3,3,3)` locus when the rank-two base point lies on
`tau` away from `z_0`, and six for the one-dimensional residual determinant
target when the base point is `z_0`.

For `F-F`, the conic target is one-dimensional.  Its preimage has dimension
at most eleven for `(8,8,8)`.  For `(10,8,6)`, that target consists of
squares, so the exceptional square fiber gives dimension at most twelve.
When the base point is `z_0`, the residual `(8,7,6)` target is
`k z_0^14` and has preimage dimension at most ten.  If the base point lies on
the unique `Q` away from `z_0`, its forced double zero makes the conic
restriction identically zero; the residual `(8,7,6)` zero locus has dimension
at most nine.

The line target for `F-F` has preimage dimension eight for `(5,4,3)`.  If the
rank-two base point lies on `tau` away from `z_0`, its forced square together
with the order-seven zero makes the restriction identically zero, giving the
five-dimensional `(3,3,3)` zero locus.  If the base point is `z_0`, the
residual degree-six determinant has order at least five and its preimage has
dimension at most seven.

## 4. Rank three

For the canonical rank-three triple, restriction to the reduced cubic
`Gamma` is surjective onto a 36-dimensional space.  Ignoring the gluing at
the tangential intersection only enlarges the product of the two component
bad loci.

For `A-F`, the chain moves in dimension five, so the fixed-`sigma`
codimension is at least

\[
 36-13-7-5=11.
 \tag{4.1}
\]

For proper-minimal `F-F`, the chain moves in dimension six and the bound is

\[
 36-11-8-6=11.
 \tag{4.2}
\]

Both exceed the rank-three orbit dimension eight.

## 5. Rank two

The restriction image of the rank-two coefficient space on `Gamma` has rank
36 when its base point `b` is off `Gamma`, rank 33 when `b` lies on one
component away from `z_0`, and rank 32 when `b=z_0`.  The configuration and
component bounds give, for `A-F`,

\[
\begin{array}{c|c|c|c|c|c}
\text{position of }b&\dim\text{ config}&\text{image rank}&Q\text{ bad}&
\tau\text{ bad}&\text{final codim}\\ \hline
b\notin\Gamma&5&36&13&7&11\\
b\in\tau,\ b\ne z_0&4&33&13&5&11\\
b=z_0&3&32&12&6&11
\end{array}
\tag{5.1}
\]

and, for proper-minimal `F-F`,

\[
\begin{array}{c|c|c|c|c|c}
\text{position of }b&\dim\text{ config}&\text{image rank}&Q\text{ bad}&
\tau\text{ bad}&\text{final codim}\\ \hline
b\notin\Gamma&6&36&12&8&10\\
b\in Q,\ b\ne z_0&5&33&9&8&11\\
b\in\tau,\ b\ne z_0&5&33&12&5&11\\
b=z_0&4&32&10&7&11.
\end{array}
\tag{5.2}
\]

The minima eleven and ten are greater than the rank-two orbit dimension
seven.  The arithmetic in (4.1)--(5.2) is checked in
[`root_three_free_separator_local_checks.py`](root_three_free_separator_local_checks.py),
with recorded output in
[`root_three_free_separator_local_checks.log`](root_three_free_separator_local_checks.log).

The 60-dimensional coefficient space of equations `A` surjects onto the
42-dimensional fixed-`sigma` coefficient space.  Pullback preserves all the
displayed codimensions, and adding the matrix orbit still leaves positive
codimension in `P_A^59`.

## 6. The aligned locus and the exact remaining obstruction

The aligned locus is already incompatible with the first vanishing in the
rationality row.  Write `E_i^*` for the full total-transform exceptional class
created at `z_i`, and \(\bar E_i\) for its prime strict transform.  Along a
successive free chain,

\[
 E_i^*=\bar E_i+\bar E_{i+1}+\cdots+\bar E_n.
 \tag{6.1}
\]

For `A-F`,

\[
 D=E_0^*+E_1^*+E_3^*
  =\bar E_0+2\bar E_1+2\bar E_2+3\bar E_3.
 \tag{6.2}
\]

If `z_2=z_{2,tau}`, the line `tau` follows `z_0,z_1,z_2`.  Its total pullback
has exceptional valuation vector at least `(1,2,3,3)`, which dominates the
coefficient vector `(1,2,2,3)` in (6.2).  Hence

\[
 0\ne\tau\in H^0(O_Y(H-D)),
 \tag{6.3}
\]

contrary to the cluster vanishing.

For proper-minimal `F-F`,

\[
 D=E_0^*+E_2^*+E_4^*
  =\bar E_0+\bar E_1+2\bar E_2+2\bar E_3+3\bar E_4.
 \tag{6.4}
\]

The same aligned line has exceptional valuations at least `(1,2,3,3,3)`,
again coefficientwise larger than those in (6.4).  Thus it too gives a
nonzero section of `O_Y(H-D)`.

There is an analogous partial reduction for `F-F` starting at the forced
nonproper minimal essential center.  Write `p<z_0<z_1<\cdots<z_4`, where `p`
is the preceding proper triple point and `z_0,z_2,z_4` are essential.  If the
plane tangent line determined by `z_0` follows the first separator `z_1`, its
exceptional valuations on \(\bar E_0,\ldots,\bar E_4\) are at least
`(2,3,3,3,3)`.  These dominate the same vector `(1,1,2,2,3)` in (6.4), so this
aligned subcase also violates `H^0(O_Y(H-D))=0`.

The same unloading test removes the aligned part of `A-S`.  Write its chain as
`z_0<z_1<z_2<z_3`, where `z_0,z_1,z_3` are essential, `z_2` is free, and
`z_3=E_{z_2}\cap E_{z_1}` is satellite.  In the prime basis,

\[
 D=E_0^*+E_1^*+E_3^*
  =\bar E_0+2\bar E_1+2\bar E_2+5\bar E_3.
 \tag{6.5}
\]

If the tangent line of the adjacent pair `z_0<z_1` follows `z_2`, its
exceptional valuations are `(1,2,3,5)`: the last entry is the sum of the
valuations two and three on the exceptional curves meeting at `z_3`.  This
dominates `(1,2,2,5)`, so the line again lies in `H^0(O_Y(H-D))`.

The complementary `A-S` locus and the nonproper-minimal `F-F` chain require
arguments beyond this free-curvette calculation.  They are both excluded in
[`root_three_completion_theorem.md`](root_three_completion_theorem.md): the
first by residual proximity after removing its forced tangent-line component,
and the second by retaining constant-term gluing between a tangent line and
the unique conic through its first five centers.
