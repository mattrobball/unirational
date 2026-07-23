# One nonproper singleton away from an isolated base scheme

## Statement

Let \(\sigma\) be a primitive quadratic triple with a nonempty
zero-dimensional base scheme \(Z\), and let
\(B=\sigma^t\operatorname {adj}(A)\sigma\) be reduced.  The two
one-nonproper-singleton strata excluded on the base-point-free locus in

- [`k2_profile327_one_nonproper_singleton_exclusion.md`](k2_profile327_one_nonproper_singleton_exclusion.md), and
- [`k2_profile3324_one_nonproper_singleton_exclusion.md`](k2_profile3324_one_nonproper_singleton_exclusion.md)

are also absent on the isolated-base locus provided that the proper support
of \(Z\) is disjoint from every selected deleted-adjoint cubic and from the
marked tangent line of the nonproper singleton.

Consequently, an isolated-base survivor in either one-nonproper-singleton
stratum must have an explicit branch/base alignment: some proper base
support lies on a selected deleted cubic or on the marked tangent line.
This note deliberately does not claim that such aligned strata occur or
exclude them.

## 1. Restriction ranks off the base support

If a reduced plane curve \(C\) avoids the proper support of \(Z\), then
\(\sigma|_C\) generates \(O_C(2)\), and the usual symmetric sequence

\[
0\longrightarrow3O_C(2)\longrightarrow6O_C(4)
\longrightarrow\mathcal Q_C\longrightarrow0
\tag{1.1}
\]

is exact.  For a line, integral conic, or reduced cubic, every section in
the relation term extends from \(C\) to the plane.  Indeed, the relevant
restriction maps in degree two are onto, and their \(H^1\)'s vanish.
After subtracting the extended relation, a quartic matrix vanishing on
\(C\) is divisible by its equation.  Therefore the coefficient-image
ranks are exactly the base-point-free ranks

\[
21,\qquad39,\qquad54
\tag{1.2}
\]

on a line, an integral conic, and a reduced cubic, respectively.  The same
argument on reduced unions gives ranks thirty-nine, fifty-four, and
sixty-six on two lines, a line plus a conic, and two conics.

On a line avoiding the base support,
\(\mathscr K^\vee|_L\) has degree two and hence has the same balanced or
unbalanced splitting as before.  On an integral conic it has degree four.
Thus all determinant-fiber and six-jet estimates in the two companion
certificates apply without change.  No exceptional pole occurs because no
selected curve meets a proper base support.

## 2. Incidence margins improve

Every nonempty isolated-base triple stratum has projective dimension at
most sixteen, rather than seventeen.  Hence each integral selected-cubic
or selected-conic margin in the two base-point-free proofs improves by one.
In particular, all of their already strict margins remain strict.

It remains only to replace the base-point-free low-degree factor-pair
lemma.  Off the base support, the restriction ranks from Section 1 and the
worst zero-determinant fibers give the following uniform margins after the
curves and the isolated-base triple move:

\[
\begin{array}{c|c|c|c|c}
\text{components}&\text{image}&\text{bad}&\text{moving}&\text{margin}\\ \hline
L_1\cup L_2&39&9+9&4+16&1\\
L\cup Q&54&9+17&2+5+16&5\\
Q_1\cup Q_2&66&17+17&10+16&6.
\end{array}
\tag{2.1}
\]

The estimates forget every node-matching condition and therefore include
tangent intersections.  They also include every balanced/unbalanced line
boundary and the zero matrix.

The adjoint, contact, and block-cover parts of the companion proofs are
intrinsic to the reduced branch and are unaffected by the isolated base
scheme.  Their selected curves avoid the base support by hypothesis, so
Section 1 supplies the identical coefficient estimates, while (2.1)
supplies the final factor-pair exclusion.  This proves the statement.

The restriction ranks and the three strict margins are replayed by
[`k2_one_nonproper_singleton_offbase_checks.py`](k2_one_nonproper_singleton_offbase_checks.py).
