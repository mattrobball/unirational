# Normalized graph geometry

Let \(\varphi:X\dashrightarrow X\) be any dominant \(G\)-equivariant rational
selfmap. Choose a smooth equivariant resolution of its normalized graph

\[
X\xleftarrow{p} Z\xrightarrow{q}X,
\]

with \(p\) birational and \(q\) generically finite of degree \(\delta\).

## 1. Exact canonical and ramification formulae on a smooth graph resolution

Since \(X\) is smooth,

\[
K_Z=p^*K_X+\sum_E a_EE,
\qquad a_E>0
\tag{1.1}
\]

for the \(p\)-exceptional prime divisors on a resolution obtained by smooth
blowups. Since \(q\) is generically finite in characteristic zero,

\[
K_Z=q^*K_X+R_q,
\qquad R_q\ge0.
\tag{1.2}
\]

Write \(H=\mathcal O_X(1)\), so \(-K_X=2H\), and let

\[
q^*H=np^*H-\sum_E m_EE.
\tag{1.3}
\]

Then

\[
\boxed{
R_q=2(n-1)p^*H+\sum_E(a_E-2m_E)E.
}
\tag{1.4}
\]

The cubic degree is

\[
\boxed{
3\delta=\left(np^*H-\sum_E m_EE\right)^3.
}
\tag{1.5}
\]

Neither (1.4) nor canonicality of the scaled mobile pair makes the exceptional
terms vanish.

## 2. Invariant Picard rank

There is no unconditional equality \(\rho(Z)^G=1\). Every \(G\)-orbit of
exceptional divisors contributes to the invariant Néron--Severi space through
its orbit sum, subject to relations. Passing to the finite Stein model can
contract some of these classes, but there is no theorem forcing invariant
rank one.

The tangent-residual construction makes this failure existentially sharp.
For its nonidentity map, \(\delta\ge3\). If the normalized finite Stein model
were terminal, \(\mathbf Q\)-factorial, \(G\)-Fano, and of invariant Picard
rank one, the accepted conditional superrigidity theorem would force
\(\delta=1\). Hence at least one of those properties fails for every such
section-selected map.

## 3. Singularities of the Stein model

Normalization of a graph is finite over the target only after Stein
factorization. Normality alone gives neither canonical nor terminal
singularities. The existing weighted-projective countermodel already shows
this abstractly. The new existence theorem shows that a non-Mori outcome must
occur for an actual full-\(G\) selfmap of the Klein cubic.

This does not identify which defect occurs. Possibilities include:

- noncanonical singularities;
- failure of \(\mathbf Q\)-factoriality;
- non-Fano canonical class;
- invariant Picard rank greater than one.

A relative MMP can change the model and its finite map; it does not preserve
all four desired properties automatically.

## 4. Horizontal and vertical Rees valuations

For a chosen homogeneous representative of \(\varphi\), the normalized blowup
of its base ideal selects divisorial Rees valuations. A valuation is
horizontal for a fixed stratum when its centre dominates that stratum, and
vertical when it lies over a proper subset. This distinction depends on the
actual ideal and is not determined by the abstract graph degree or by the
fixed-stratum character census.

The tangent-residual selfmaps are selected on the free quotient. Their base
ideals may contain every nonfree stratum. Thus the fixed curves can contribute
only through horizontal exceptional valuations on later models. This is an
actual realization of the category that the fixed-network packet had left
open.

## 5. Generic-field description

Let \(K=\mathbf C(X)^G\), \(L=\mathbf C(X)\). The graph extension is the
injective endomorphism

\[
\varphi^*:L\hookrightarrow L
\]

commuting with \(G\), together with its restriction \(K\hookrightarrow K\).
Equivalently it is a quotient selfmap preserving the generic \(G\)-torsor.
This gives an exact generic classification but no terminal/Fano conclusion.

## 6. Boundary

The graph geometry route cannot prove degree one for arbitrary selfmaps,
because actual degree-\(>1\) equivariant selfmaps exist. Its remaining valid
role is ambient-specific: prove that the normalized graph of a global landing
ideal has additional singularity, Picard, or Rees properties not shared by
the tangent-residual examples.
