# Ambient extendability

The tangent-residual theorem separates two notions that must not be conflated.

## 1. Every selfmap extends projectively modulo the cubic equation

Let \(\varphi:X\dashrightarrow X\subset\mathbf P^4\) be a rational selfmap.
After removing a common divisorial fixed part, its coordinate system consists
of five sections

\[
s_0,\ldots,s_4\in H^0(X,\mathcal O_X(n))
\]

for some \(n\ge0\). The restriction sequence

\[
0\to\mathcal O_{\mathbf P^4}(n-3)
\xrightarrow{\cdot F}
\mathcal O_{\mathbf P^4}(n)
\to\mathcal O_X(n)\to0
\]

and \(H^1(\mathbf P^4,\mathcal O(n-3))=0\) show that each \(s_i\) lifts to a
homogeneous form \(P_i\) of degree \(n\).

Because the image of \(X\) lies in \(X\),

\[
F(P_0,\ldots,P_4)|_X=0.
\]

The ideal of \(X\) is principal, so

\[
\boxed{F(P)=F(x)A(x)}
\tag{1.1}
\]

for a homogeneous polynomial \(A\) of degree \(3n-3\).

Thus every selfmap has an ambient \(\mathbf P^4\dashrightarrow\mathbf P^4\)
representative preserving \(X\) set-theoretically. This is not an ambient
landing map.

## 2. The landing identity is a nonlinear normal-extension condition

Problem E requires

\[
\boxed{F(P)=0}
\tag{2.1}
\]

as a polynomial on all of \(W_5\). In the notation of (1.1), this is
\(A=0\).

Different lifts have the form

\[
P_i\longmapsto P_i+FQ_i.
\]

Substitution into the cubic changes \(A\) by nonlinear polar terms. Killing
\(A\) is therefore a genuine normal-extension problem, not a consequence of
projective normality or of the selfmap equation on \(X\).

The tangent-residual construction proves no solution of (2.1). It supplies
only a rational selfmap and hence (1.1).

## 3. Forced ambient base strata

The accepted ambient landing theorem says that every homogeneous
\(G\)-equivariant tuple satisfying (2.1) vanishes on every involution plus
plane \(W_+(t)\). Consequently each fixed elliptic \(E_t\) is contained in the
strict ambient base locus.

Therefore an ambient-extendable selfmap cannot be analyzed by ordinary
restriction of \(P\) to \(E_t\). Any nonconstant elliptic component map must
occur on a horizontal exceptional carrier selected by the normalized Rees
algebra. The strict \([-5]/\mathrm{id}\) network morphism is not itself a
homogeneous order-zero boundary map.

## 4. Syzygy distinction

For a general selfmap the only universal cubic syzygy is (1.1). For an ambient
landing map one has the stronger five-form syzygy (2.1). All useful
ambient-specific constraints must ultimately use this difference, for
example:

- the first nonzero normal jets along the forced plus-plane base components;
- relations among Rees valuations induced by one global identity;
- compatibility of exceptional carriers over the 55 involutions and 55
  \(V_4\) configurations;
- polar identities for the lifted tuple;
- exact base intersections in the carrier polarization formula.

## 5. Ambient theorem boundary

The arbitrary selfmap classification cannot close Problem E. The smallest
remaining target is:

> **Ambient-normal-extension theorem.** Classify the torsor-preserving quotient
> selfmaps whose lifted coordinate system can be modified so that \(A=0\) in
> (1.1), and compute the normalized-Rees horizontal carriers of every such
> solution.

A proof that no nonidentity pair has this property would give
`FULL-G-AMBIENT-SELFMAP-IDENTITY-THEOREM`. It is not proved here.
