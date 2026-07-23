# Squared lines away from an isolated quadratic base scheme

## Statement

Let \(\sigma\) be a primitive quadratic triple with a nonempty
zero-dimensional base scheme \(Z\).  Suppose that a line \(L\) avoids
\(Z\).  For a general symmetric quartic matrix \(A\), the condition

\[
L^2\mid B_\sigma
\]

is absent in every first-neighborhood stratum except the following one:

\[
\mathscr K^\vee|_L\simeq O_L\oplus O_L(2),
\quad
q_0=(0,0,c_8),
\quad
q_1=(0,b_5,c_7).
\tag{0.1}
\]

Here \(q=q_0+tq_1\pmod {t^2}\) and \(t=0\) is the line.  The surviving
unbalanced high-diagonal boundary has moving margin \(-1\), so it is not
excluded.  In particular, every isolated-base squared-line survivor is
either of type (0.1) away from the base scheme or has its line pass through
a base center.

## 1. The same 39-dimensional first-neighborhood target

Because \(L\cap Z=\varnothing\), the triple generates \(O(2)\) on the
first neighborhood \(2L\).  Plane restriction gives

\[
h^0(O_{2L}(4))=h^0(O(4))-h^0(O(2))=9,
\]

and

\[
h^0(O_{2L}(2))=h^0(O(2))-h^0(O)=5.
\]

Both restriction maps are onto.  The symmetric relation sequence therefore
shows that the equation space maps onto a target of dimension

\[
6\cdot9-3\cdot5=39.
\tag{1.1}
\]

The balanced and unbalanced bad-target dimensions are exactly those in
[`k2_basepointfree_line_square_reduction.md`](k2_basepointfree_line_square_reduction.md):

\[
\begin{array}{c|c}
\text{stratum}&\text{bad dimension in the target}\\ \hline
\text{balanced rank one of moving degree }s&20-2s\\
\text{balanced zero leading form}&18\\
\text{unbalanced nonboundary}&\le18\\
\text{unbalanced low diagonal}&15\\
\text{unbalanced high diagonal}&23\\
\text{unbalanced zero leading form}&18.
\end{array}
\tag{1.2}
\]

## 2. The isolated-base parameter gain

Every nonempty isolated-base triple stratum has dimension at most sixteen.
Thus balanced pairs \((\sigma,L)\) move in dimension at most eighteen.
Even the extremal balanced row \(s=0\) now has strict margin

\[
39-20-18=1.
\tag{2.1}
\]

All other balanced rows have still larger margin.

For rank-three triples, the unbalanced lines for a fixed primitive net form
a proper subset of the dual plane.  Here is the needed linear-net lemma.
Let

\[
V\subset H^0(O_{\mathbf P^2}(2)),\qquad \dim V=3.
\]

If restriction \(V\to H^0(O_L(2))\) were dependent for every line \(L\),
then every line would divide some nonzero member of \(V\).  The resulting
factor incidence maps onto the two-dimensional dual plane.  Since one
conic has at most two line factors, its image in \(\mathbf P(V)\) is
two-dimensional; hence every conic in \(\mathbf P(V)\) is reducible.  The
elementary classification of planes of reducible ternary quadrics gives
two possibilities:

\[
V=\ell_0 H^0(O(1)),
\qquad\text{or}\qquad
V=\operatorname {Sym}^2 U
\quad(\dim U=2).
\tag{2.2}
\]

In the first case the net has the common factor \(\ell_0\), contrary to
primitivity.  In the second case the rational map is composite with the
pencil \(\mathbf P(U)\); after coordinates it is the binary net
\(\langle x^2,xy,y^2\rangle\).  A line not through the base point
\((x=y=0)\) restricts \(x,y\) to a basis of \(H^0(O_L(1))\), so the three
binary quadrics restrict independently.  Thus this second case also has
balanced lines and cannot satisfy the assumption that every line is
unbalanced.

Consequently the unbalanced lines form a proper closed subset of the dual
plane, of dimension at most one.  Hence the universal rank-three
unbalanced pair locus has dimension at most

\[
16+1=17.
\]

For a rank-two triple every line is unbalanced, but the triple stratum has
dimension thirteen, so these pairs have dimension only \(13+2=15\).
The uniform bound seventeen therefore applies.

Using (1.2), the unbalanced moving margins are

\[
\begin{array}{c|c}
\text{stratum}&39-\dim(\text{bad})-17\\ \hline
\text{nonboundary}&\ge4\\
\text{low diagonal}&7\\
\text{high diagonal}&-1\\
\text{zero leading form}&4.
\end{array}
\tag{2.3}
\]

Thus precisely the high-diagonal boundary (0.1) survives this incidence
calculation.

> **Subsequent sharpening.**  The base-aligned frontier theorem excludes
> this high-diagonal row for a rank-three one-point base by embedding its
> transformed form space as a codimension-four subspace of the settled
> \(k=1\) space.  The only off-base survivor is a rank-three net with two
> distinct base points; lines meeting the base are reduced to six explicit
> cluster positions.  See
> [`k2_isolated_line_square_base_aligned_frontier.md`](k2_isolated_line_square_base_aligned_frontier.md).

The target dimension and all margins are replayed by
[`k2_isolated_line_square_offbase_checks.py`](k2_isolated_line_square_offbase_checks.py).
