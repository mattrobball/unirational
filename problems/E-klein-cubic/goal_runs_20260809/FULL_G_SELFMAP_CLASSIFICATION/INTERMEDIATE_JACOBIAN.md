# Intermediate Jacobian and graph correspondences

Let

\[
X\xleftarrow{p}Z\xrightarrow{q}X
\]

be a smooth resolution of the graph of a dominant rational selfmap
\(\varphi\), with \(q\) generically finite of degree \(\delta\).

## 1. The correspondence endomorphism is honest

The graph cycle defines a homomorphism of principally polarized abelian
varieties

\[
u_\varphi=p_*q^*:J(X)\longrightarrow J(X).
\tag{1.1}
\]

Equivalently, on integral cohomology modulo torsion it is the map induced by

\[
H^3(X)\xrightarrow{q^*}H^3(Z)\xrightarrow{p_*}H^3(X).
\]

This construction is independent of the chosen graph resolution. It is a
correspondence map; it is not obtained by pretending that a rational map is a
morphism on \(X\).

Because the graph is \(G\)-stable, \(u_\varphi\) commutes with \(G\). Thus

\[
u_\varphi\in\operatorname{End}_G(J(X)).
\]

## 2. Why the clean norm identity is not valid

For a finite morphism \(f:X\to X\), one has a clean trace identity on
cohomology and hence a polarization relation tied to \(\deg f\). For a
rational map resolved by \(p\), the blowup formula gives additional summands

\[
H^3(Z)\simeq p^*H^3(X)
\oplus\bigoplus_i H^1(C_i)(-1)
\tag{2.1}
\]

from curve centres (with the corresponding iterated-blowup refinements).
The injection \(q^*H^3(X)\hookrightarrow H^3(Z)\) can have nonzero projection
to these exceptional summands.

Consequently

\[
q_*q^*=\delta\operatorname{id}_{H^3(X)}
\]

does not imply

\[
u_\varphi^\dagger u_\varphi=[\delta]
\tag{2.2}
\]

on \(J(X)\). The missing term is a positive/indefinite correspondence
factoring through Jacobians of the actual curve centres. Abstract Schur
arguments cannot discard it.

The repository's blowup-closure counterconfiguration already showed that an
exceptional orbit of curves can carry a copy of the required \(G\)-Hodge
structure. The tangent-residual theorem now proves that degree-greater-than-one
full-\(G\) selfmaps actually exist, so any universal use of (2.2) to force
\(\delta=1\) is necessarily false.

## 3. The Klein intermediate Jacobian

The Klein cubic has the highly symmetric principally polarized intermediate
Jacobian described through the period lattice of the Fano surface. In
particular the existing degree-three audit uses a model isogenous to
\(E^5\), with \(E\) carrying multiplication by

\[
\nu=\frac{-1+\sqrt{-11}}2,
\qquad \nu\bar\nu=3.
\]

Thus even the clean Rosati equation

\[
\alpha^\dagger\alpha=[3]
\]

has an exact integral solution. This prevents the degree-three branch from
being excluded by a scalar norm screen, even before exceptional corrections
are restored.

A complete computation of \(\operatorname{End}_G(J(X))\) is not required for
the present conclusion. Whatever that ring is, the graph correspondence of
the section-selected maps belongs to it, and the degree is not recovered from
\(u_\varphi\) without controlling the exceptional projector.

## 4. Fano surface of lines

The tangent-residual construction is itself naturally related to lines: its
indeterminacy consists of tangent directions whose lines are contained in
\(X\). This locus is the pullback of the universal line incidence over the
Fano surface. Resolving it introduces precisely the type of curve/surface
exceptional data capable of contributing to (2.1).

For the degree-one retraction branch, the accepted polar identity also
produces a rational section of the six-sheeted line-incidence cover over a
base divisor. These line correspondences are abundant in unbounded divisor
class and do not by themselves force a contradiction.

## 5. Valid remaining target

The intermediate Jacobian can still constrain a specified ambient landing
ideal if one proves that its actual base centres contribute no relevant
\(G\)-isotypic exceptional summand, or computes the correction exactly. No
such theorem follows from equivariance, Picard rank one, or the abstract graph.

Hence the intermediate-Jacobian route does not classify arbitrary
\(G\)-selfmaps and cannot repair Targets A or B. Its unresolved useful form is
an ambient-base-ideal theorem identifying the exceptional correction to
(2.2).
