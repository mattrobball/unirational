# The integral-quintic square row away from an isolated base scheme

## Statement

Let \(\sigma\) be a primitive quadratic triple with a nonempty
zero-dimensional base scheme \(Z\), and let

\[
B_\sigma=\sigma^t\operatorname {adj}(A)\sigma .
\]

For a general symmetric quartic matrix \(A\), there is no connected
degree-five square-factor row

\[
B_\sigma=T^2C,
\qquad T\text{ an integral quintic},
\qquad 0\ne C\text{ a reduced conic},
\tag{0.1}
\]

when \(T\cap Z=\varnothing\).  Thus every isolated-base integral-quintic
square survivor must pass through the base scheme.

The condition \(T\cap Z=\varnothing\) is essential in this note.  When
\(T\) contains a base center, relations on its strict transform can have
exceptional poles and the injectivity argument below needs a separate
cluster-by-cluster audit.

**Subsequent sharpening.**  That audit is completed in
[`k2_isolated_quintic_base_cluster_exclusion.md`](k2_isolated_quintic_base_cluster_exclusion.md),
which, together with the transverse-proper certificate, closes the
connected isolated-base integral-quintic square-root row.  Its degree-zero
quotient boundary is routed only to a disconnected pure square.

## 1. Exact restriction away from the base scheme

Because \(\sigma\) is primitive, its three entries have no common plane
factor.  Over the polynomial ring, the kernel of restriction of a
symmetric \(3\)-by-\(3\) quartic matrix to the hyperplane
\(L_\sigma=0\) consists exactly of the symmetrized products

\[
L_\sigma L_\tau,
\qquad \tau\in H^0(O(2))^3.
\]

Thus the equation space induces a 72-dimensional space of quadratic forms,
just as on the base-point-free locus:

\[
90-3h^0(O(2))=90-18=72.
\tag{1.1}
\]

Let \(T\) be an integral quintic disjoint from \(Z\).  Along \(T\), the
triple generates \(O_T(2)\), so the symmetric restriction sequence is

\[
0\longrightarrow3O_T(2)\longrightarrow6O_T(4)
\longrightarrow\mathcal Q_T\longrightarrow0.
\tag{1.2}
\]

Both relevant plane restriction maps are isomorphisms:

\[
H^0(O(2))\xrightarrow{\sim}H^0(O_T(2)),
\qquad
H^0(O(4))\xrightarrow{\sim}H^0(O_T(4)).
\tag{1.3}
\]

Indeed, their kernels and cokernels are controlled by \(O(-3)\) and
\(O(-1)\), respectively.  It follows from (1.2)--(1.3) that restriction
of the 72-dimensional quotient (1.1) to \(T\) is injective: every relation
on \(T\) is \(\sigma\tau_T\), the quadratic triple \(\tau_T\) extends to
the plane, and a quartic matrix whose entries vanish on a quintic is zero.

On the normalization \(\nu:\overline T\to T\), put

\[
F=\nu^*(\mathscr K^\vee|_T),
\qquad N=\nu^*O_T(4).
\]

Since \(T\) misses the base scheme,

\[
\deg F=10,
\qquad \deg N=20,
\tag{1.4}
\]

and \(F\) is globally generated.

## 2. The strict rank-one margins

If \(T\mid B_\sigma\), let \(M\subset F\) be the saturated image line of
the nonzero restricted rank-one form and put \(m=\deg M\).  The same Quot
calculation as in
[`k2_basepointfree_quintic_component_exclusion.md`](k2_basepointfree_quintic_component_exclusion.md)
gives

\[
D_m=\max\{11-2m,0\}+\max\{2m+21,0\}.
\tag{2.1}
\]

There is no omitted rank-zero restriction stratum.  The injectivity proved
in Section 1 says that a form whose restriction to \(T\) is zero is already
zero in the 72-dimensional quotient.  Equivalently the original equation
is a multiple of \(L_\sigma\), so its discriminant is zero; it cannot give
the nonzero residual conic in (0.1).

The quotient \(F/M\) is globally generated of degree \(10-m\).  Hence:

- for \(m\le6\), \(D_m\le33\) and \(T\) moves in dimension at most 20;
- for \(m=7\), \(D_m=35\), the normalization has gonality at most three,
  so \(T\) is singular and moves in dimension at most 19;
- for \(m=8\), \(D_m=37\), the normalization has gonality at most two,
  hence genus at most three, and \(T\) moves in dimension at most 17;
- for \(m=9\), \(D_m=39\), the normalization is rational, and \(T\)
  moves in dimension at most 14.

The exhaustive base-scheme classification in
[`k2_primitive_base_scheme_reduction.md`](k2_primitive_base_scheme_reduction.md)
shows that every nonempty isolated-base triple stratum has dimension at
most sixteen.  The four moving margins in the 72-dimensional form space
are therefore

\[
\begin{array}{c|c|c|c}
m&D_m&\dim\{T\}&72-D_m-\dim\{T\}-16\\ \hline
m\le6&\le33&20&\ge3\\
7&35&19&2\\
8&37&17&2\\
9&39&14&3.
\end{array}
\tag{2.2}
\]

All are strict.

## 3. The degree-zero quotient boundary

It remains to treat \(m=10\).  Then \(F/M\) is a globally generated
degree-zero line bundle, hence is trivial.  Dualizing gives a nonzero
constant relation among the restrictions of \(\sigma_0,\sigma_1,\sigma_2\)
to \(T\).  Since the relation is a plane quadric vanishing on an integral
quintic, it holds on the whole plane.  Thus \(\sigma\) has rank two.

After a constant component change, the resolved rank-two kernel is

\[
\mathscr K=O\oplus O(-R),
\qquad
\mathscr K^\vee|_T=O_T\oplus O_T(R),
\qquad \deg O_T(R)=10.
\tag{3.1}
\]

The degree-ten image line is necessarily the \(O_T(R)\) summand.  Write
the quadratic form globally on the base resolution as

\[
q=
\begin{pmatrix}a&b\\b&c\end{pmatrix},
\qquad
a\in H^0(O(4H)).
\]

Support of \(q|_T\) on \(O_T(R)^2\) says \(a|_T=b|_T=0\).  Since \(a\)
is a plane quartic and \(T\) is an integral quintic, \(a=0\).  Therefore

\[
\det q=-b^2
\tag{3.2}
\]

is a pure square.  Its generic double algebra splits; it cannot have a
nonzero reduced residual conic as in (0.1).  This removes the final
rank-one boundary and proves the statement.

The restriction dimension and four margins are replayed by
[`k2_isolated_quintic_offbase_checks.py`](k2_isolated_quintic_offbase_checks.py).
