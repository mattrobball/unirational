# Exclusion of integral quintic branch components

## Statement

Let

\[
X=(x^tA(y)x=0)\subset \mathbf P^2_x\times\mathbf P^2_y
\]

be a general hypersurface of bidegree \((2,4)\), and let

\[
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma
\]

be the degree-ten branch attached to a rank-two or rank-three section
\(\sigma\) of class \((1,1)\).  Then no integral plane quintic divides
\(B_\sigma\).

Together with the degree-one-through-four factor exclusions in
[`k1_double_decic_frontier.md`](k1_double_decic_frontier.md), this has the
following useful consequence:

\[
\boxed{\text{Every reduced branch remaining in the }k=1\text{ frontier is
integral.}}
\tag{0.1}
\]

Indeed, a reducible degree-ten curve with no component of degree at most four
must be the union of two integral quintics.

All dimensions below are affine except for the explicitly projective
parameter spaces of quintics.  The loci are homogeneous cones, so the
codimensions are unchanged after projectivizing.

## 1. The rank-one cone bound

We use the genus-free estimate proved in Section 5 of
`k1_double_decic_frontier.md`.  If \(\mathscr F\) is a globally generated
rank-two bundle of degree \(f\) on a smooth curve and \(N\) is a line bundle
of degree \(n\), then the affine cone of quadratic forms

\[
q\in H^0(\operatorname {Sym}^2\mathscr F\otimes N),
\qquad \det(q)=0,
\]

has dimension at most

\[
R(f,n)=
\max_{\lceil-n/2\rceil\le m\le f}
\left(
\max\{f-2m+1,0\}+\max\{2m+n+1,0\}
\right).
\tag{1.1}
\]

For the values needed here,

\[
\begin{array}{c|ccccc}
f&5&4&3&2&1\\ \hline
R(f,20)&31&29&27&25&23.
\end{array}
\tag{1.2}
\]

If the plane quintic is singular, pull the restricted quadratic form to its
normalization.  Pullback of sections from an integral curve is injective, and
the estimate uses only degree and global generation.  Thus (1.1) applies to
every integral quintic, not only a smooth one.

## 2. Rank three

Fix a rank-three \(\sigma\).  As in the earlier factor exclusions, put

\[
E=\Omega^1_{\mathbf P^2}(1),\qquad
\mathcal Q=\operatorname {Sym}^2(E^\vee)\otimes O(4).
\]

The symmetric Euler resolution is

\[
0\longrightarrow3O(3)\longrightarrow6O(4)
\longrightarrow\mathcal Q\longrightarrow0,
\tag{2.1}
\]

and \(h^0(\mathcal Q)=60\).  For any quintic Cartier divisor \(T\), twist
(2.1) by \(O(-5)\):

\[
0\longrightarrow3O(-2)\longrightarrow6O(-1)
\longrightarrow\mathcal Q(-5)\longrightarrow0.
\]

Since \(H^0(O(-2))=H^0(O(-1))=H^1(O(-2))=0\), one has

\[
H^0(\mathcal Q(-5))=0.
\tag{2.2}
\]

Restriction to \(T\) is therefore injective.  On the normalization of an
integral quintic,

\[
\deg(E^\vee|_T)=5,
\qquad
\deg O_T(4)=20,
\]

and \(E^\vee\) is globally generated.  The condition \(T\mid B_\sigma\) is
exactly \(\det(q|_T)=0\), whose fixed-\(T\) locus has dimension at most
\(R(5,20)=31\).  Integral quintics move in \(\mathbf P^{20}\).  Hence the
fixed-\(\sigma\) codimension is at least

\[
60-31-20=9>8=\dim O_3.
\tag{2.3}
\]

After allowing the projective rank-three matrix orbit, the incidence still
has positive codimension in the space of quartic equations.

## 3. Rank two away from the base point

Fix a rank-two \(\sigma\), and let \(b\) be its base point.  On
\(Z=\operatorname {Bl}_b\mathbf P^2\), write \(H\) for the pullback of a
line, \(E_b\) for the exceptional curve, and \(R=H-E_b\).  The complete
quadratic-form space is

\[
\begin{split}
W_2={}&H^0(O(6H-2E_b))\\
&\oplus H^0(O(5H-E_b))
\oplus H^0(O(4H)),
\end{split}
\tag{3.1}
\]

of dimension sixty.

If an integral quintic \(T\) avoids \(b\), subtracting \(5H\) from the
three summands in (3.1) gives

\[
H^0(H-2E_b)=H^0(-E_b)=H^0(-H)=0.
\]

Restriction is injective.  The resolved kernel dual is
\(O\oplus O(R)\), of degree five on \(T\), and the twisting bundle
\(O(4H)|_T\) has degree twenty.  Therefore the same calculation gives

\[
60-R(5,20)-20=9>7=\dim O_2.
\tag{3.2}
\]

## 4. Rank two through the base point

Suppose now that \(T\) has multiplicity \(\mu\ge1\) at \(b\), so its strict
transform has class

\[
\widetilde T=5H-\mu E_b.
\]

The kernels of restriction from the three summands of (3.1) are

\[
H^0(H+(\mu-2)E_b),\qquad
H^0((\mu-1)E_b),\qquad
H^0(-H+\mu E_b).
\tag{4.1}
\]

For \(\mu=1,2,3,4\), their dimensions and the resulting restriction ranks
are

\[
\begin{array}{c|c|c}
\mu&\text{kernel dimensions}&\text{image rank}\\ \hline
1&(2,1,0)&57\\
2&(3,1,0)&56\\
3&(3,1,0)&56\\
4&(3,1,0)&56.
\end{array}
\tag{4.2}
\]

The divisor \(R=H-E_b\) is base-point-free on \(Z\).  Hence, on the
normalization of \(\widetilde T\), the bundle
\(O\oplus O(R)\) is globally generated and has degree \(5-\mu\), while
\(O(4H)\) still has degree
twenty.  Quintics of multiplicity at least \(\mu\) at the fixed point \(b\)
form a projective linear system of dimension

\[
20-\binom{\mu+1}{2}.
\tag{4.3}
\]

Combining (1.2), (4.2), and (4.3) gives

\[
\begin{array}{c|c|c|c|c}
\mu&\text{image}&R(5-\mu,20)&\dim\{T\}&\text{codimension}\\ \hline
1&57&29&19&9\\
2&56&27&17&12\\
3&56&25&14&17\\
4&56&23&10&23.
\end{array}
\tag{4.4}
\]

The table is applied to the stratum of exact multiplicity \(\mu\); using the
closed system of multiplicity at least \(\mu\) in (4.3) only enlarges that
stratum and therefore gives a valid upper bound.

Every entry is larger than the rank-two orbit dimension seven.  An integral
quintic cannot have multiplicity five at a point: its equation would be a
homogeneous binary quintic in affine coordinates centered there and hence
would factor over \(\mathbf C\).  Thus (3.2) and (4.4) exhaust all rank-two
base-point positions.

## 5. Incidence conclusion

For either rank orbit, the locus of pairs \((A,\sigma)\) for which an
integral quintic divides \(B_\sigma\) has image of positive codimension in
the space of quartic equations.  Therefore it is absent for a general
\(A\).

The arithmetic in (1.2), (2.3), and (4.2)--(4.4), together with the
degree-ten component consequence (0.1), is replayed by
[`k1_quintic_factor_checks.py`](k1_quintic_factor_checks.py).
