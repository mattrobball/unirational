# Exact separator classification for root type `[3]`

## Statement

Work over an algebraically closed field of characteristic zero in the
square-free three-`t=2` row of
[`k1_frontier.md`](../k1_frontier.md).  Thus the complete canonical
resolution has exactly three essential centers, of corrected multiplicity
four or five, and every other center has corrected multiplicity two or three.

In a proper-origin tree containing all three essential centers, the essential
centers are linearly ordered: an essential fork is impossible.  Between two
consecutive comparable essential centers there are only three possibilities.

1. They are adjacent (`A`).
2. There is exactly one free negligible center, with corrected sequence

   \[
   (4,3,4).                                      \tag{0.1}
   \]

   Call this edge `F`.
3. There is exactly one free negligible center followed by a satellite
   essential center, with corrected sequence

   \[
   (5,3,4).                                      \tag{0.2}
   \]

   Call this edge `S`.

In particular, **two or more negligible centers cannot lie between
consecutive essential centers**.  The only two-edge essential skeletons not
already removed by the adjacent-chain theorem are

\[
 A-F,\qquad A-S,\qquad F-F.                     \tag{0.3}
\]

The patterns `F-A`, `S-A`, `F-S`, `S-F`, and `S-S` are impossible.  This
supersedes any formal `t`-only one- and two-separator enumeration.
The incidence exclusion of all three genuine survivors (0.3) is given in
[`root_three_completion_theorem.md`](root_three_completion_theorem.md).

## 1. Multiplicity and proximity conventions

At a canonical center `v`, put

\[
 m_v=\operatorname{mult}_v(B_v^{\mathrm{strict}}),\qquad
 e_v=\#\{\text{prime exceptional branch curves through }v\},
 \qquad r_v=m_v+e_v.                            \tag{1.1}
\]

At most two exceptional curves pass through a point, so `e_v` is zero, one,
or two.  The exceptional curve created at `v` belongs to the corrected branch
exactly when `r_v` is odd.  The strict multiplicities obey

\[
 m_u\geq\sum_{w\succ u}m_w,                    \tag{1.2}
\]

where the sum is over all later centers proximate to `u`.  In particular,
strict multiplicity cannot increase along an immediate-predecessor path.

An essential center has `r=4` or `5`; a negligible center has `r=2` or `3`.
The lemma in
[`contact_cubic_observation.md`](contact_cubic_observation.md#2-an-essential-center-with-no-essential-predecessor)
will also be used: if a minimal essential center is nonproper, it is the first
point above a proper center and the strict/corrected sequence is

\[
 (m_p,m_q)=(3,3),\qquad (r_p,r_q)=(3,4).        \tag{1.3}
\]

Such a center cannot have an immediate essential successor.

## 2. A separated pair has exactly one negligible center

Let `u<v` be consecutive essential centers on an immediate-predecessor path.
Assume that at least one negligible center lies strictly between them, and let
`w` be the immediate predecessor of `v`.

If `e_v=0`, then `m_v>=4`, whereas `m_v<=m_w<=3`, a contradiction.

Suppose `e_v=1`.  Then

\[
 3\leq m_v\leq m_w\leq r_w\leq3.
\]

Consequently

\[
 (m_w,e_w,r_w)=(3,0,3),\qquad
 (m_v,e_v,r_v)=(3,1,4).                         \tag{2.1}
\]

Because `e_w=0`, the exceptional created at the predecessor of `w` is
nonbranch.  If that predecessor were negligible, its corrected multiplicity
would be two and could not support `m_w=3`.  It is therefore `u`, so there is
only one intervening center.

The center `w` is free.  Indeed, if it were also proximate to an older center
`z`, then the exceptional over `z` would be nonbranch (because `e_w=0`).  The
essential center `u` has `m_u>=3` in this situation, while both `u` and `w`
are proximate to `z`.  Thus (1.2) would give `m_z>=m_u+m_w>=6`, impossible
because every center in this row has strict multiplicity at most five.

The center `v` is free as well.  Otherwise it is the satellite
\(\bar E_w\cap\bar E_u\).  Here \(\bar E_w\) is a branch curve by
`r_w=3`, while \(\bar E_u\) is nonbranch by `e_w=0`; both `w` and `v` are then
proximate to `u`, and

\[
 m_u\geq m_w+m_v=6,
\]

again impossible.  Since `w` is free and has `e_w=0`, the new exceptional
over `u` is nonbranch, hence `r_u=4`.  This proves the free pattern

\[
 (r_u,r_w,r_v)=(4,3,4),\qquad(m_w,m_v)=(3,3).  \tag{2.2}
\]

Now suppose `e_v=2`.  The new exceptional over `w` and one older exceptional
through `w` are both branch curves.  Thus `r_w=3`, `e_w>=1`, and
`m_w<=2`.  Essentiality and nonincrease force

\[
 (m_w,e_w,r_w)=(2,1,3),\qquad
 (m_v,e_v,r_v)=(2,2,4).                         \tag{2.3}
\]

Let the older branch exceptional be \(\bar E_z\).  Both `w` and `v` are
proximate to `z`, so `m_z>=4`; hence `z` is essential.  It must equal `u`.
If it were earlier than `u`, then the path remains on \(\bar E_z\) through
`u`, and `u,w,v` would all be proximate to `z`, giving
`m_z>=m_u+m_w+m_v>=6`.

There can be no additional center between `u` and `w`: such a center has
strict multiplicity at least two and, together with `w` and `v`, would force
`m_u>=6`.  Nor can `w` be satellite to `u` and another older center `y`.
In that case both `u` and `w` are proximate to `y`, while proximity at `u`
already gives `m_u>=m_w+m_v=4`, so `m_y>=6`.  Therefore `w` is the
free first point over `u`, and `v` is the satellite
\(\bar E_w\cap\bar E_u\).  Since both of those curves are branch,
`r_u` is odd.  We obtain

\[
 (r_u,r_w,r_v)=(5,3,4),\qquad(m_w,m_v)=(2,2).  \tag{2.4}
\]

The cases `e_v=0,1,2` are exhaustive.  They prove both the exact-one assertion
and the two separator types (0.1)--(0.2).

## 3. Essential forks are impossible

Suppose two essential descendants lie on different branches, and let `a` be
the last common center of their paths.  If `x,y` are the first centers after
the split, nonincrease gives `m_x,m_y>=2`, so (1.2) gives `m_a>=4`; hence
`a` itself is essential.  There can be no earlier essential center, since
`a` and the two branch descendants already account for all three.  If `a`
were nonproper, the minimal-essential lemma would give `m_a=3`, contradicting
`m_a>=4`.  Thus `a` is proper, and `x,y` are distinct free points above it.
The other two essential centers lie on the two branches.

Each branch consumes too much proximity multiplicity at `a`:

- an adjacent essential child is free and has strict multiplicity at least
  three;
- an `F` branch begins with its strict-multiplicity-three separator;
- an `S` branch contributes both its strict-multiplicity-two separator and
  its strict-multiplicity-two satellite target, and both are proximate to
  `a`.

Thus two non-`S` branches already contribute at least six to the right side
of (1.2).  An `S` branch contributes four and any other branch at least three;
two `S` branches contribute eight.  Every alternative exceeds
`m_a<=r_a<=5`.  Therefore the essential centers are linearly ordered.

## 4. The exact two-edge list

After either `F` or `S`, the later essential center has corrected
multiplicity four and its newly created exceptional is nonbranch.

After `F`, its strict multiplicity is three.  A free immediate successor has
corrected multiplicity at most three.  The only possible satellite immediate
successor would lie at the intersection with the branch exceptional created
by the separator, but then the separator would have to support two proximate
strict-multiplicity-three centers, contradicting its own strict multiplicity
three.  Thus `F-A` is impossible.

After `S`, the target has strict multiplicity two.  Neither a free nor a
satellite immediate successor can have corrected multiplicity four, so
`S-A` is impossible.

An `S` edge can start only at corrected multiplicity five, while every
separator edge ends at corrected multiplicity four.  Hence `F-S` and `S-S`
are impossible.  An `F` edge begins with a strict-multiplicity-three
separator, which cannot follow the strict-multiplicity-two target of `S`;
hence `S-F` is impossible.  The only separated patterns left are therefore
`A-F`, `A-S`, and `F-F`.

It remains to identify the all-adjacent pattern.  Its minimal essential center
`p` is proper by the no-immediate-successor part of the minimal-essential
lemma, and its first essential successor `q` is free.  Write
`r_p=4+epsilon_p`, `r_q=4+epsilon_q`, and
`r_s=4+epsilon_s`.  If the immediate essential successor `s` of `q` were the
satellite at \(\bar E_q\cap\bar E_p\), then

\[
 m_q=4+\epsilon_q-\epsilon_p,
 \qquad
 m_s=4+\epsilon_s-\epsilon_p-\epsilon_q.
\]

Both `q` and `s` are proximate to `p`, but

\[
 m_q+m_s=8+\epsilon_s-2\epsilon_p
 >4+\epsilon_p=m_p
\]

for both `epsilon_p=0` and `epsilon_p=1`.  Thus `s` is free.  The
all-adjacent pattern `A-A` is exactly the proper-root successive-free chain
excluded in Section 5 of
[`adjacent_nested_pair_theorem.md`](adjacent_nested_pair_theorem.md).
