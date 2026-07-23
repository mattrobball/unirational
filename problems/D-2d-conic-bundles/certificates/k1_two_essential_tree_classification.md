# Classification of the first repeated-root tree

## Status and scope

Work in the squarefree six-\(t=2\) row of
[`k1_double_decic_frontier.md`](k1_double_decic_frontier.md), and assume the
essential root partition is

\[
[2,1,1,1,1].
\]

Thus one proper-origin tree contains exactly two essential centers and four
other proper-origin trees contain one essential center each.  This note
classifies the complete **essential span**: every proper or infinitely-near
center on a path from a proper origin to an essential center, including all
intervening \(t=1\) centers and every possible free or satellite proximity.

There are exactly six parity-decorated repeated-tree cores.  After unloading
the two complete cluster ideals, the quartic vanishing and the already-proved
degree-one-through-four component exclusions reduce the seventy-five
initial core/singleton rows to twelve.  No row is asserted to occur for a
general determinantal branch.

A complete canonical resolution may also contain \(t=1\) centers in
terminal or side subtrees which contain no essential center.  Those centers
are not determined by the root partition and are not enumerated here.  They
have coefficient zero in both \(D\) and \(2D\), so adding them after the
essential span does not change either complete cluster ideal.  Forgetting
them enlarges any marked branch incidence and is therefore safe in a
negative incidence proof.  Section 7 records the exact remaining boundary.

## 1. Conventions

At a canonical center \(v\), write

\[
m_v=\operatorname {mult}_v(B_v^{\mathrm{strict}}),\qquad
e_v=\#\{\text{exceptional branch curves through }v\},\qquad
r_v=m_v+e_v.
\tag{1.1}
\]

An essential center has \(r_v=4\) or \(5\); every other center in the
canonical resolution has \(r_v=2\) or \(3\).  The exceptional curve created
at \(v\) is a branch component exactly when \(r_v\) is odd.  Strict
multiplicities satisfy the proximity inequalities

\[
m_u\geq\sum_{v\succ u}m_v.
\tag{1.2}
\]

The proper multiplicity-six exclusion is what restricts an essential proper
center to corrected multiplicity four or five.

Write \(E_v^*\) for the total transform of the exceptional curve created at
\(v\).  On the essential span,

\[
D=\sum_{v\text{ essential}}E_v^*.
\tag{1.3}
\]

For a consistent point basis \(\mu=(\mu_v)\), the colength of the
corresponding complete ideal is

\[
\ell(\mu)=\sum_v\binom{\mu_v+1}{2}.
\tag{1.4}
\]

## 2. The repeated essentials are comparable

The two essential centers in the repeated tree are linearly ordered.  If
they were incomparable, let \(a\) be the last common center of their paths
and let \(x,y\) be the first centers after the split.  Nonincrease of strict
multiplicity gives \(m_x,m_y\ge2\), because each path ends at an essential
center and an essential center has at most two exceptional branch components
through it.  Both \(x\) and \(y\) are proximate to \(a\), so

\[
m_a\ge m_x+m_y\ge4.
\]

Hence \(a\) would be a third essential center in the same proper-origin
tree, a contradiction.

We use twice the following minimal-essential lemma.  If a nonproper
essential center \(q\) has no essential predecessor, then it is the free
first-near point over a proper center \(p\), and

\[
(r_p,r_q)=(3,4),\qquad (m_p,m_q)=(3,3).
\tag{2.1}
\]

Indeed, if \(e_q=0\), its immediate predecessor has even corrected
multiplicity two and cannot support \(m_q\ge4\).  If \(e_q=1\),
nonincrease forces both strict multiplicities to be three, the predecessor
to have corrected multiplicity three, and that predecessor to be proper.
If \(e_q=2\), the satellite and its immediate predecessor are both
proximate to the creator of the older branch exceptional, forcing an
essential predecessor.  This proves (2.1).  It also shows that the center
in (2.1) cannot have an immediate essential successor: a free successor has
corrected multiplicity at most three, while a satellite successor violates
proximity at \(p\).

## 3. Exact separator classification

Let \(u<v\) be the consecutive essential centers.  If they are adjacent,
the preceding lemma makes \(u\) proper and \(v\) free.  Put
\(\epsilon_u=r_u\bmod2\).  Then

\[
m_u=r_u,\qquad m_v=r_v-\epsilon_u,\qquad m_u\ge m_v.
\]

The exact possibilities are

\[
 A_{44}:(r;m)=(4,4;4,4),\quad
 A_{54}:(5,4;5,3),\quad
 A_{55}:(5,5;5,4).
\tag{3.1}
\]

The formal fourth choice \((r_u,r_v)=(4,5)\) violates nonincrease.

Now suppose at least one \(t=1\) center lies between \(u\) and \(v\), and
let \(w\) be the immediate predecessor of \(v\).  The cases
\(e_v=0,1,2\) are exhaustive.

* If \(e_v=0\), then \(m_v\ge4>m_w\), impossible.
* If \(e_v=1\), then

  \[
  (m_w,e_w,r_w)=(3,0,3),\qquad
  (m_v,e_v,r_v)=(3,1,4).
  \]

  The predecessor of \(w\) must be \(u\): another \(t=1\) predecessor
  would have corrected multiplicity two and could not support
  \(m_w=3\).  Proximity excludes a satellite \(w\), and also excludes a
  satellite \(v\).  The exceptional over \(u\) is nonbranch, so \(r_u=4\).
  If \(u\) is proper this is type \(F_P\); if it is nonproper, (2.1) adds
  its unique proper predecessor and gives type \(F_N\).
* If \(e_v=2\), then

  \[
  (m_w,e_w,r_w)=(2,1,3),\qquad
  (m_v,e_v,r_v)=(2,2,4).
  \]

  The older branch exceptional is the one created at \(u\).  Proximity
  excludes any extra separator, forces \(w\) to be free over \(u\), and
  makes \(v\) the satellite proximate to both \(u\) and \(w\).  Both
  exceptional curves through \(v\) are branch components, so \(r_u=5\);
  in particular \(u\) is proper.  This is type \(S\).

Thus two or more intervening \(t=1\) centers are impossible.  The complete
list is the following.  A star marks an essential center; `B` means that the
exceptional created there is a branch component.

| core | centers and proximities | corrected \(r\) | exceptional count \(e\) | strict \(m\) | new exceptional |
|---|---|---|---|---|---|
| \(A_{44}\) | \(p^*<q^*\), free | \((4,4)\) | \((0,0)\) | \((4,4)\) | \((-,-)\) |
| \(A_{54}\) | \(p^*<q^*\), free | \((5,4)\) | \((0,1)\) | \((5,3)\) | \((B,-)\) |
| \(A_{55}\) | \(p^*<q^*\), free | \((5,5)\) | \((0,1)\) | \((5,4)\) | \((B,B)\) |
| \(F_P\) | \(p^*<w<v^*\), all free | \((4,3,4)\) | \((0,0,1)\) | \((4,3,3)\) | \((-,B,-)\) |
| \(F_N\) | \(a<u^*<w<v^*\), all free | \((3,4,3,4)\) | \((0,1,0,1)\) | \((3,3,3,3)\) | \((B,-,B,-)\) |
| \(S\) | \(p^*<w\) free; \(v^*\succ p,w\) | \((5,3,4)\) | \((0,1,2)\) | \((5,2,2)\) | \((B,B,-)\) |

There is no omitted fork, satellite, or longer-separator core.

## 4. Exact unloading and the two cluster vanishings

For each core, the raw total-transform weights of \(D\), their unloaded
point bases, and the local colengths are

| core | raw \(D\) weights | point basis of \(\mathcal J_D\) | point basis of \(\mathcal J_{2D}\) | local lengths \((\ell_D,\ell_{2D})\) |
|---|---|---|---|---|
| any \(A\) | \((1,1)\) | \((1,1)\) | \((2,2)\) | \((2,6)\) |
| \(F_P\) | \((1,0,1)\) | \((1,1,0)\) | \((2,1,1)\) | \((2,5)\) |
| \(F_N\) | \((0,1,0,1)\) | \((1,1,0,0)\) | \((1,1,1,1)\) | \((2,4)\) |
| \(S\) | \((1,0,1)\) | \((1,1,0)\) | \((2,1,1)\) | \((2,5)\) |

For example, along the free \(F_P\) chain the prime-exceptional
coefficients of \(2D\) are \((2,2,4)\).  The least consistent point basis
dominating them is \((2,1,1)\), whose prime coefficients are
\((2,3,4)\).  In type \(S\), the last center is proximate to both earlier
centers; \((2,1,1)\) gives prime coefficients \((2,3,6)\), dominating the
raw \((2,2,6)\).  The other rows are identical one-line unloadings.

A singleton tree has one of three parity-decorated cores:

| singleton | centers | \((r;m)\) | new exceptional | local lengths \((\ell_D,\ell_{2D})\) |
|---|---|---|---|---|
| \(P_4\) | proper essential \(z^*\) | \((4;4)\) | \(-\) | \((1,3)\) |
| \(P_5\) | proper essential \(z^*\) | \((5;5)\) | \(B\) | \((1,3)\) |
| \(N\) | proper \(a<z^*\), free | \((3,4;3,3)\) | \((B,-)\) | \((1,2)\) |

Let \(n\) be the number of \(N\) singleton trees among the four.  Every
simple local cluster has length equal to the number of essential centers, so

\[
\ell(O/\mathcal J_D)=2+4=6.
\tag{4.1}
\]

The first vanishing

\[
H^0(\mathcal J_D(2))=0
\tag{4.2}
\]

therefore says exactly that the length-six evaluation map on conics is an
isomorphism.  Geometrically its repeated-tree part is the length-two tangent
cluster at the proper origin, while every singleton contributes its proper
origin; a simple weight at a nonproper singleton does **not** impose its
tangent direction.

For the doubled cluster,

\[
\ell(O/\mathcal J_{2D})=
\begin{cases}
18-n,&A,\\
17-n,&F_P\text{ or }S,\\
16-n,&F_N.
\end{cases}
\tag{4.3}
\]

Since \(h^0(O_{\mathbf P^2}(4))=15\), the second vanishing forces

\[
\boxed{
n\le3\text{ for }A,\qquad
n\le2\text{ for }F_P,S,\qquad
n\le1\text{ for }F_N.}
\tag{4.4}
\]

Before using branch-component exclusions, (4.4) leaves seventy-five
unlabelled parity-decorated rows: forty-two adjacent rows, twenty-four
\(F_P/S\) rows, and nine \(F_N\) rows.

## 5. Universal degree-at-most-four pruning

The known absence of integral branch components of degrees one through four
gives a finite additional test.  Let \(G\) be a plane curve of degree
\(d\le4\).  At selected centers give \(G\) a consistent point basis
\(\mu\).  If

\[
\ell(\mu)=\sum_v\binom{\mu_v+1}{2}
<h^0(O_{\mathbf P^2}(d))=\binom{d+2}{2},
\tag{5.1}
\]

then a nonzero such \(G\) exists for every position of the marked cluster.
If \(G\) and the decic branch have no common component, Noether's
intersection formula gives

\[
10d=B\cdot G\ge\sum_vm_v\mu_v.
\tag{5.2}
\]

Thus any consistent \(\mu\) for which the right side exceeds \(10d\)
forces a forbidden component of degree at most four.

The accompanying checker enumerates every nonnegative point basis on the
marked essential span, subject to proximity and (5.1), for
\(d=1,2,3,4\).  The eliminations can also be read from the following small
set of witnesses.  Vectors are ordered as in the tables above; omitted trees
have zero weight.  Write \(k\) for the number of \(P_5\) singleton trees,
so the singleton multiset is \(N^nP_5^kP_4^{4-n-k}\).

First take no \(P_5\) singleton.  The rows eliminated beyond (4.4) are:

| rows | degree | selected point bases | forced contact |
|---|---:|---|---:|
| \(A_{54},n=0\) | 2 | \(A:(1,0)\), four \(P_4:(1)\) | 21 |
| \(A_{54},n=1\) | 3 | \(A:(2,1)\), \(N:(1,1)\), three \(P_4:(1)\) | 31 |
| \(A_{54},n=2\) | 4 | \(A:(2,1)\), two \(N:(1,1)\), two \(P_4:(2)\) | 41 |
| \(A_{55},n=0\) | 2 | \(A:(1,0)\), four \(P_4:(1)\) | 21 |
| \(A_{55},n=1\) | 2 | \(A:(1,1)\), three \(P_4:(1)\) | 21 |
| \(A_{55},n=2\) | 3 | \(A:(2,1)\), \(N:(1,0),(1,1)\), two \(P_4:(1)\) | 31 |
| \(A_{55},n=3\) | 3 | \(A:(1,1)\), three \(N:(1,1)\), \(P_4:(1)\) | 31 |
| \(S,n=0\) | 2 | \(S:(1,0,0)\), four \(P_4:(1)\) | 21 |

Every row containing a \(P_5\) singleton is also eliminated.  It is enough
to treat one \(P_5\), because changing another \(P_4\) to \(P_5\) only
increases the contact of the same witness.  Rows already excluded in the
preceding table need no new witness.  For the remaining cores the witnesses
are:

| core and \(n\) | degree | selected point bases | forced contact |
|---|---:|---|---:|
| \(A_{44},0\) | 2 | \(A:(1,0)\), \(P_5:(1)\), three \(P_4:(1)\) | 21 |
| \(A_{44},1\) | 2 | \(A:(1,1)\), \(P_5:(1)\), two \(P_4:(1)\) | 21 |
| \(A_{44},2\) | 3 | \(A:(1,1)\), \(N:(1,0),(1,1)\), \(P_5:(2)\), \(P_4:(1)\) | 31 |
| \(A_{44},3\) | 3 | \(A:(1,1)\), three \(N:(1,1)\), \(P_5:(1)\) | 31 |
| \(A_{54},3\) | 3 | \(A:(1,1)\), three \(N:(1,1)\), \(P_5:(1)\) | 31 |
| \(F_P,0\) | 2 | \(F_P:(1,0,0)\), \(P_5:(1)\), three \(P_4:(1)\) | 21 |
| \(F_P,1\) | 3 | \(F_P:(1,1,0)\), \(N:(1,1)\), \(P_5:(2)\), two \(P_4:(1)\) | 31 |
| \(F_P,2\) | 3 | \(F_P:(1,1,1)\), two \(N:(1,1)\), \(P_5:(1)\), \(P_4:(1)\) | 31 |
| \(F_N,0\) | 3 | \(F_N:(1,1,1,0)\), \(P_5:(2)\), three \(P_4:(1)\) | 31 |
| \(F_N,1\) | 3 | \(F_N:(1,1,1,1)\), \(N:(1,1)\), \(P_5:(1)\), two \(P_4:(1)\) | 31 |
| \(S,1\) | 2 | \(S:(1,0,0)\), \(N:(1,0)\), \(P_5:(1)\), two \(P_4:(1)\) | 21 |
| \(S,2\) | 3 | \(S:(1,0,0)\), two \(N:(1,1)\), \(P_5:(2)\), \(P_4:(1)\) | 31 |

All displayed colengths are respectively at most \(5,9,14\), so the conic,
cubic, or quartic exists by (5.1).

Exactly twelve rows survive this universal low-degree test.  In every one,
all proper singleton essentials have corrected multiplicity four:

| repeated core | \(n\) | singleton multiset | \(\ell(O/\mathcal J_{2D})\) | maximal forced contacts in degrees \(1,2,3,4\) |
|---|---:|---|---:|---|
| \(A_{44}\) | 0 | \(P_4^4\) | 18 | \((8,20,28,40)\) |
| \(A_{44}\) | 1 | \(N P_4^3\) | 17 | \((8,20,30,39)\) |
| \(A_{44}\) | 2 | \(N^2P_4^2\) | 16 | \((8,19,29,40)\) |
| \(A_{44}\) | 3 | \(N^3P_4\) | 15 | \((8,18,30,39)\) |
| \(A_{54}\) | 3 | \(N^3P_4\) | 15 | \((9,18,30,40)\) |
| \(F_P\) | 0 | \(P_4^4\) | 17 | \((8,20,30,39)\) |
| \(F_P\) | 1 | \(N P_4^3\) | 16 | \((8,19,29,40)\) |
| \(F_P\) | 2 | \(N^2P_4^2\) | 15 | \((8,18,30,39)\) |
| \(F_N\) | 0 | \(P_4^4\) | 16 | \((8,19,29,40)\) |
| \(F_N\) | 1 | \(N P_4^3\) | 15 | \((8,18,30,39)\) |
| \(S\) | 1 | \(N P_4^3\) | 16 | \((9,20,30,40)\) |
| \(S\) | 2 | \(N^2P_4^2\) | 15 | \((9,19,30,40)\) |

The last column is a boundary statement, not an existence theorem.  It says
that no further contradiction follows merely by asking for an arbitrary
degree-at-most-four curve through a consistent subcluster whose colength is
strictly smaller than the dimension of that degree's complete linear
system.  Special-position curves remain part of the later incidence audit.

## 6. Tangent-line alignment boundaries

Let \(\tau\) be the tangent line represented by the first nonproper center
in the repeated tree.  The no-line-component theorem gives the following
additional exact restrictions.

* In \(A_{44}\) and \(A_{54}\), the core contact on \(\tau\) is eight.
  No singleton origin lies on \(\tau\).
* In \(F_P\), the core contact is seven if \(v\) is not the continuation
  point of \(\tau\), and ten if it is.  In the latter case no singleton
  origin lies on \(\tau\).  In the former case at most one singleton lies
  there; it must be of type \(N\), and its marked tangent is not \(\tau\).
* In \(F_N\), if both \(w\) and \(v\) continue \(\tau\), the contact is
  twelve and the row is impossible.  If only \(w\) continues \(\tau\), the
  contact is nine and no singleton origin lies on it.  If \(w\) is not the
  continuation, the contact is six; at most one singleton origin lies on
  \(\tau\), either a \(P_4\) origin or an \(N\) origin transverse to its
  marked tangent.
* In \(S\), the satellite is not the continuation point of the plane line,
  and the core contact is seven.  At most one singleton origin lies on
  \(\tau\); it must be of type \(N\) and transverse to its marked tangent.

Each assertion is just the infinitely-near intersection formula followed by
Bezout: contact greater than ten would make \(\tau\) a branch component.

## 7. Exact remaining boundary

The
[`k1_quintic_factor_exclusion.md`](k1_quintic_factor_exclusion.md)
theorem proves that every retained reduced decic is integral.  In the notation of
[`k1_repeated_root_frontier.md`](k1_repeated_root_frontier.md), its
normalization genus satisfies

\[
G=n_5-n_2\ge0.
\tag{7.1}
\]

In the twelve rows above there are no \(P_5\) singleton trees.  Thus

\[
\begin{array}{c|c|c}
\text{cores}&n_5&\text{terminal corrected-double bound}\\ \hline
A_{44},F_P,F_N&0&n_2=0,\ G=0,\\
A_{54},S&1&n_2\in\{0,1\},\ G=1-n_2.
\end{array}
\tag{7.2}
\]

This is the exact point at which the present classification stops.  A full
canonical Enriques diagram is obtained from one of the twelve rows by adding
only \(t=1\) terminal or side subtrees, subject to terminal smoothness,
proximity, (7.2), and the degree-ten contact bounds.  Such additions do not
change the two complete-cluster vanishings proved above.  Conversely, every
essential center and every predecessor or separator needed to reach one is
already present in the six-core table; there is no further essential-span
diagram.

The next incidence proof may therefore mark only one of these twelve rows
and forget all terminal \(t=1\) decorations.  This forgetful map enlarges
the bad locus, so a codimension exclusion for the marked core excludes every
complete canonical extension of it.

All finite enumerations, unloadings, colengths, component-test witnesses,
and the twelve-row output are replayed by
[`k1_two_essential_tree_checks.py`](k1_two_essential_tree_checks.py).
