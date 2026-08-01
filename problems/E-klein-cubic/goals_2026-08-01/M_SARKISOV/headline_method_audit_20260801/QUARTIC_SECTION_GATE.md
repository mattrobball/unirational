# First independent section gate

Let

\[
 \Phi(a_0,a_1,a_2,a_3,a_4)=0
\]

be the exact descended cubic equation and use homogeneous coordinates
\([s:t]\) on the pencil base.  A nonexceptional section whose image in
\(X\subset\mathbf P^4\) has degree \(d\) is represented by binary forms

\[
 A_0,A_1,A_2\in K_0[s,t]_d,qquad q\in K_0[s,t]_{d-1},
\]

with

\[
 [a_0:a_1:a_2:a_3:a_4]
   =[A_0:A_1:A_2:sq:tq]. \tag{1}
\]

The five forms must have no common zero.  Conversely, any such tuple
satisfying

\[
 \Phi(A_0,A_1,A_2,sq,tq)=0 \tag{2}
\]

lands in the graph model of the blowup and gives a section.

The center-index and no-line arguments force \(d\ge4\) and
\(d\equiv1\pmod3\).  At the first value \(d=4\), write

\[
 A_i=\sum_{j=0}^4 A_{ij}s^{4-j}t^j,qquad
 q=\sum_{j=0}^3 q_js^{3-j}t^j.
\]

There are 19 scalar coefficients, modulo common scaling.  Substitution in
(2) gives a binary form of degree 12, so its 13 coefficients give 13 cubic
equations over \(K_0\).  The first section scheme is therefore the common-
zero-free open inside

\[
 \left\{[A_{ij},q_j]\in\mathbf P^{18}_{K_0}:
 [s^{12-k}t^k]\,\Phi(A_0,A_1,A_2,sq,tq)=0,
 \ 0\le k\le12\right\}. \tag{3}
\]

The cubic \(q\) records the length-three intersection of the section curve
with the center plane.  This should not be confused with the *degree-four
multisection* allowed by the cubic-surface zero-cycle theorem: (3) seeks a
base-degree-one section whose image has projective degree four.

No \(K_0\)-point of (3) is currently known, and no emptiness theorem is
claimed.  A point of (3) would give a rational section and immediately close
Problem E positively.

