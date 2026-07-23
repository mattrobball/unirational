# Integral cubic and quartic components over isolated quadratic bases

## Statement and exact boundary

Let \(\sigma=(\sigma _0,\sigma _1,\sigma _2)\) be a primitive quadratic
triple with a nonempty zero-dimensional base scheme, and put

\[
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma .
\]

Let \(T\) be an integral plane curve of degree \(j=3\) or \(4\).  For a
general symmetric quartic matrix \(A\), the following statements hold.

1. If \(T\mid B_\sigma\), the nonzero rank-one restriction along \(T\)
   cannot have positive quotient degree.
2. The rank-zero restriction along \(T\) is absent as well.
3. If \(T^2\mid B_\sigma\) and the nonzero rank-one restriction has
   quotient degree zero, then \(\sigma\) has rank two and \(B_\sigma\) is
   a pure square.

The qualification in item 3 is essential.  For \(j<5\), a plane quartic
can vanish on \(T\), so quotient degree zero for a mere component
\(T\mid B_\sigma\) is not being excluded.  The extra second-order
divisibility is what forces the relevant quartic coefficient to vanish
identically.

Consequently the primitive isolated-base square-factor rows \(e=3,4\)
are absent (with the usual maximal-square, squarefree-residual
convention).  Reducible square roots route to the already unconditional
degree-two theorem
[`k2_isolated_degree2_square_exclusion.md`](k2_isolated_degree2_square_exclusion.md),
while the degree-zero integral boundary belongs only to the disconnected
pure-square row.

## 1. The coefficient image before and after base contact

Write

\[
V=\operatorname {Sym}^2(k^3)\otimes H^0(O_{\mathbf P^2}(4)),
\qquad \dim V=90.
\]

If \(t=0\) is the equation of \(T\), the matrices whose six entries
vanish on \(T\) form

\[
N_T=t\,\operatorname {Sym}^2(k^3)\otimes
H^0(O_{\mathbf P^2}(4-j)).
\tag{1.1}
\]

Thus

\[
\dim N_T=
6h^0(O(4-j))=
\begin{cases}
18,&j=3,\\
6,&j=4.
\end{cases}
\tag{1.2}
\]

There is also the eighteen-dimensional polynomial relation space

\[
P(\sigma)\tau=\operatorname {sym}(\sigma\tau),
\qquad \tau\in H^0(O(2))^3.
\tag{1.3}
\]

These two pieces of the kernel are disjoint.  Indeed, if
\(P(\sigma)\tau\in N_T\), then over the function field of the integral
curve \(T\) one has \(P(\sigma)\tau=0\).  The map \(P(\sigma)\) is
injective over that field because \(\sigma\ne0\) there.  Hence every
component of \(\tau\) vanishes on \(T\).  But \(\deg\tau_i=2<j\), so
\(\tau=0\).  This explicitly accounts for the kernel special to
degrees three and four; it must be removed before the base-contact
saturation loss is applied.

It follows that the starting coefficient images have dimensions

\[
I_j=90-\dim N_T-18,
\qquad
\boxed{I_3=54,\quad I_4=66.}
\tag{1.4}
\]

Now resolve the base ideal and write

\[
R=2H-M,
\qquad
0\longrightarrow\mathscr K\longrightarrow O^3
\xrightarrow{\ \sigma\ }O(R)\longrightarrow0.
\tag{1.5}
\]

For a simple base cluster put

\[
M=\sum_{i=1}^lE_i,
\qquad
a_i=\operatorname {mult}_{p_i}(T_i),
\qquad
s=\sum_i a_i.
\tag{1.6}
\]

The centers may be proper, free, or satellite.  At a multiplicity-two
base point put \(a=\operatorname {mult}_pT\) and \(s=2a\).  In both
cases division by the common zero divisor of the restricted triple gives

\[
F=\mathscr K^\vee|_{\overline T},
\qquad
f:=\deg F=R\cdot\widetilde T=2j-s.
\tag{1.7}
\]

The bundle \(F\) is globally generated, so \(f\ge0\).

We next apply the conductor-safe saturated-relation estimate at the
correct level, namely to the image remaining after quotienting by
\(N_T\).  At one proper support let \(A_T\) be the local ring of the
integral curve and choose a generic constant component
\(g\in(\sigma_0,\sigma_1,\sigma_2)A_T\) with minimum valuation on every
normalization branch.  If the total base contact over this support is
\(b\), then

\[
\operatorname {length}_{A_T}(A_T/(g))=b.
\tag{1.8}
\]

For

\[
L=\bigl(\operatorname {im}P(\sigma)_{K_T}\bigr)
\cap\operatorname {Sym}^2(A_T^3),
\]

projection to the \((00),(01),(02)\) entries gives on the three relation
columns

\[
\begin{pmatrix}
2g&0&0\\
\sigma_1&g&0\\
\sigma_2&0&g
\end{pmatrix}.
\tag{1.9}
\]

Exactly as in the integral-quintic cluster theorem, the induced map from
\(L/\operatorname {im}P(\sigma)\) to the cokernel of (1.9) is injective.
The triangular cokernel has length \(3b\), without any normality or
Smith-form assumption.  Summing over the proper supports, including the
branch valuations contributed by free and satellite successors, gives

\[
\operatorname {length}
\bigl(L/\operatorname {im}P(\sigma)\bigr)\le3s.
\tag{1.10}
\]

Since (1.10) measures only the *additional* saturated relations modulo
the eighteen polynomial relations in (1.3), while (1.1) has already been
removed, the actual coefficient image on the resolved curve has dimension
at least

\[
\boxed{I_{j,s}=I_j-3s.}
\tag{1.11}
\]

## 2. Rank-one forms and normalization bounds

Assume \(T\mid B_\sigma\) and that the restricted quadratic form is
nonzero.  It has rank one on the normalization.  Let
\(M_T\subset F\) be its saturated image line and put

\[
m=\deg M_T,
\qquad
d=\deg(F/M_T)=f-m.
\tag{2.1}
\]

The quotient is globally generated, so \(d\ge0\).  The rank-one section
lies in \(M_T^2\otimes O_{\overline T}(4H)\), and therefore
\(m\ge-2j\).  In particular \(d\le f+2j\).  The standard Quot estimate
bounds the affine dimension of the fixed-\((\sigma,T,m)\) rank-one
stratum by

\[
\boxed{
D_j(f,m)=
\max\{f-2m+1,0\}+\max\{2m+4j+1,0\}.}
\tag{2.2}
\]

For \(d>0\), the quotient supplies a pencil of degree at most \(d\) on
\(\overline T\).  The needed equigeneric improvements are

\[
\begin{array}{c|rrrr}
j&d\ge4&d=3&d=2&d=1\\ \hline
3&0&0&0&1\\
4&0&0&1&3
\end{array}
\tag{2.3}
\]

where an entry is the lower bound \(\delta_d\) for the delta invariant of
\(T\).  A degree-one pencil makes the normalization rational.  A smooth
plane quartic is canonically embedded and hence nonhyperelliptic, which
gives the additional quartic \(d=2\) entry.  No stronger assertion is
used for a cubic with \(d=2\), or for a quartic with \(d=3\).

## 3. Marked cluster dimensions and exhaustive margins

Put

\[
N_3=9,\quad p_a(3)=1,
\qquad
N_4=14,\quad p_a(4)=3,
\tag{3.1}
\]

where \(N_j\) is the dimension of the projective family of degree-\(j\)
plane curves.  For a selected simple base cluster define

\[
\delta_B=\sum_i\binom{a_i}{2},
\qquad
\epsilon(a_i)=
\begin{cases}
0,&a_i=0,\\
1,&a_i=1,\\
2,&a_i\ge2.
\end{cases}
\tag{3.2}
\]

The all-proper length-\(l\) triple stratum has dimension \(17-l\).
Combining the equigeneric bound with the marked incidence gives

\[
(17-l)+N_j-\max\{\delta_B,\delta_d\}
-\sum_i\epsilon(a_i)
\tag{3.3}
\]

as an upper bound for the moving curve-and-triple parameters.  This bound
also covers every free or satellite diagram.  Replacing a proper center
by a free successor lowers the base-cluster dimension by one, and its
chosen point on the exceptional curve is finite once the curve and its
predecessors are fixed.  A satellite lowers the base-cluster dimension by
two and has no parameter.  These losses compensate for the corresponding
loss of marked-proper incidence in (3.2).

An integral degree-\(j\) plane curve has multiplicity at most \(j-1\) at
every selected center, and multiplicity cannot increase under blowup.
Thus the exhaustive simple-cluster ledger is

\[
l=1,2,3,4,
\qquad 0\le a_i\le j-1,
\qquad 0\le s=\sum_i a_i\le2j.
\tag{3.4}
\]

The all-zero tuple is included, so curves disjoint from the base scheme
are not omitted.  Tuples violating \(\delta_B\le p_a(j)\) are empty; all
remaining proximity restrictions only shrink the enumerated superset.

Subtracting the maximum of (2.2), the parameter bound (3.3), and the
triple dimension from (1.11) gives the following exact minima of this
ledger:

\[
\begin{array}{c|rrrr}
\multicolumn{5}{c}{j=3}\\
l&d\ge4&d=3&d=2&d=1\\ \hline
1&8&8&8&7\\
2&8&8&8&8\\
3&8&8&8&8\\
4&8&8&8&8
\end{array}
\qquad
\begin{array}{c|rrrr}
\multicolumn{5}{c}{j=4}\\
l&d\ge4&d=3&d=2&d=1\\ \hline
1&9&9&8&7\\
2&9&9&9&8\\
3&9&9&9&9\\
4&9&9&9&9.
\end{array}
\tag{3.5}
\]

At a multiplicity-two base point use

\[
s=2a,
\qquad
\delta_B=\binom a2,
\qquad
\epsilon(a)=1\ (a=1),\quad2\ (a\ge2),
\tag{3.6}
\]

with \(a=0\) for a curve missing the base point.  The rank-three and
rank-two triple strata have dimensions ten and nine.  Their minima are

\[
\begin{array}{c|c|rrrr}
j&\dim\{\sigma\}&d\ge4&d=3&d=2&d=1\\ \hline
3&10&10&10&10&10\\
3&9 &11&11&11&11\\
4&10&9&9&9&9\\
4&9 &10&10&10&10.
\end{array}
\tag{3.7}
\]

All margins in (3.5)--(3.7) are strict.  Hence every positive-quotient
rank-one component row is absent for a general \(A\).

There is no omitted zero restriction.  Using the same marked ledger but
subtracting only the moving curve and triple parameters from
\(I_j-3s\), the minimum codimensions are

\[
\begin{array}{c|cc}
j&\text{simple cluster}&\text{multiplicity-two base}\\ \hline
3&23&26\\
4&28&29.
\end{array}
\tag{3.8}
\]

Thus the rank-zero restriction is absent with ample margin.

## 4. The degree-zero quotient and the second-order condition

It remains to identify, but not overstate, the \(d=0\) boundary.  The
globally generated degree-zero quotient \(F/M_T\) is trivial.  Dualizing
gives a constant relation among the divided triple on \(\overline T\).
Multiplying back by its common divisor shows that the corresponding
constant linear combination of the plane quadrics vanishes on the
integral curve \(T\).  Since \(j>2\), it vanishes on the whole plane.
Thus \(\sigma\) has rank two.

After a constant component change,

\[
\mathscr K=O\oplus O(-R),
\qquad
\mathscr K^\vee=O\oplus O(R).
\tag{4.1}
\]

The constant relation is the global \(O\)-summand of \(\mathscr K\), and
the rank-one image line is its annihilator \(O(R)|_{\overline T}\), even
when \(f=0\).  Write the pushed-down rank-two form as

\[
q=\begin{pmatrix}a&b\\b&c\end{pmatrix},
\qquad a\in H^0(O_{\mathbf P^2}(4)),
\qquad \det q=B_\sigma.
\tag{4.2}
\]

Its pullback is the resolved form in (4.1), with the fixed exceptional
square removed.  Thus (4.2) is the plane polynomial identity relevant at
the generic point of \(T\); no exceptional divisor changes the following
\(T\)-adic order calculation.

At the generic point of \(T\), rank one supported on the second summand
means \(a,b\in(t)\) and \(c\notin(t)\), where \(t\) is a local equation
of \(T\).  Write \(a=ta_1\) and \(b=tb_1\).  If one assumes only
\(T\mid B_\sigma\), there is no reason for \(a_1\) to vanish; this is the
degree-zero component boundary retained in the statement.

For a square-root component one has the stronger condition
\(T^2\mid B_\sigma\).  Then

\[
B_\sigma=ac-b^2=t a_1c-t^2b_1^2
\]

forces \(t\mid a_1\), since \(c\) is a unit modulo \(t\).  Hence the
plane quartic \(a\) is divisible by \(T^2\).  Because \(2j>4\), one has
\(a=0\), and therefore

\[
\boxed{B_\sigma=-b^2.}
\tag{4.3}
\]

This is a disconnected pure square.  It is not an exclusion of every
degree-zero cubic or quartic component of a rank-two determinant.

## 5. Factor routing for \(e=3,4\)

Suppose \(B_\sigma=G^2C\), with \(C\) the reduced residual factor.
If \(\deg G=3\), then either \(G\) is integral or it has a degree-two
divisor (a quadratic factor or two linear factors counted with
multiplicity).  The integral case is excluded by Sections 2--4: positive
quotient degree and rank zero are absent, while degree zero makes the
whole determinant a pure square.  A degree-two divisor \(H\mid G\)
would give \(H^2\mid B_\sigma\), contrary to the isolated degree-two
theorem.

If \(\deg G=4\), an integral quartic is treated in the same way.  A
factorization of type \(3+1\) contains an integral cubic and is likewise
excluded.  Every remaining factorization has a degree-two divisor and
again contradicts the degree-two theorem.  This exhausts the isolated
\(e=3,4\) square-factor rows.

The coefficient dimensions, all cluster ranges, the margins in
(3.5)--(3.8), and the factor-degree routing are replayed by
[`k2_isolated_cubic_quartic_component_checks.py`](k2_isolated_cubic_quartic_component_checks.py).
