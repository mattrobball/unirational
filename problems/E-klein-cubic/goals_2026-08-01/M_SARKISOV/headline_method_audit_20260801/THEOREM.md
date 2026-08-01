# Why the degree-55 multisection does not resolve the headline

## Setup

Let

\[
 E=\mathbf C(W),\quad K_0=E^G,\quad
 G=\operatorname{PSL}_2(\mathbf F_{11}),\quad H=D_{12},\quad L=E^H.
\]

The exact packet `../section_or_multisection_20260801/` constructs, for the
discovered Mori fibration

\[
 f:Y=\operatorname{Bl}_{\Gamma}X\longrightarrow
 B=\mathbf P^1_{K_0},
\]

a connected rational multisection

\[
 m:M=B_L=\mathbf P^1_L\longrightarrow Y,
 \qquad [L:K_0]=[G:H]=55.
\]

After extension to \(E\), its normalization is the disjoint union of the 55
orbit-line branches and each branch maps isomorphically to \(B_E\).

## Theorem A: the multisection cover has no rational section

The finite etale cover

\[
 p:B_L\longrightarrow B
\]

has no rational right inverse over \(B\).

Indeed, a rational section would give at the generic point a
\(K_0(t)\)-algebra retraction

\[
 L(t)\longrightarrow K_0(t)
\]

of the inclusion \(K_0(t)\subset L(t)\).  Restricting to \(L\) embeds the
finite algebraic extension \(L/K_0\) into \(K_0(t)\).  But \(K_0\) is
algebraically closed in the purely transcendental extension \(K_0(t)\).
The image of \(L\) would therefore lie in \(K_0\), forcing \(L=K_0\), in
contradiction with \([L:K_0]=55\).

Consequently the tautological section after pullback to \(M\) cannot descend
by choosing one branch.  The same conclusion follows from equivariance: the
55 branches form the transitive \(G\)-set \(G/H\), which has no
\(G\)-fixed element because \(H\ne G\).

This proves an obstruction to the installed descent mechanism.  It does not
assert that \(Y/B\) has no unrelated section.

## Theorem B: equivariant binary folding also stops

A \(G\)-invariant pairing of the branches of a transitive set \(G/H\)
corresponds to an index-two overgroup of \(H\).  The exact subgroup
certificate enumerates all such overgroups in \(G\) and proves that
\(D_{12}\) has none.  Hence one cannot pair the 55 branches equivariantly and
apply conjugate-pair third intersection to reduce this orbit.

This is deliberately scoped to branch pairing/binary secant folding.  A new
simultaneous construction involving the entire orbit would be a new
covariant, not a descent of the installed multisection.

## Theorem C: the first independent section has degree four

Write \(H_X=\pi^*\mathcal O_X(1)\), let \(E_\Gamma\) be the exceptional
divisor, and put

\[
 F=H_X-E_\Gamma=f^*\mathcal O_B(1).
\]

Let \(R\subset Y\) be a rational section not contained in
\(E_\Gamma\), and set \(d=H_X\cdot R\).  Since \(F\cdot R=1\),

\[
 E_\Gamma\cdot R=d-1. \tag{1}
\]

The intersection with the exceptional divisor pushes forward to a
\(K_0\)-zero-cycle of degree \(d-1\) on the center curve \(\Gamma\).
The exact `xCD` theorem proves \(\Gamma(K_0)=\varnothing\), while its plane
hyperplane divisor has degree three.  Thus \(\operatorname{ind}(\Gamma)=3\),
and (1) implies

\[
 d\equiv1\pmod3. \tag{2}
\]

An exceptional section would require a \(K_0\)-point of \(\Gamma\), so none
exists.  The case \(d=1\) would be a \(K_0\)-line on the genuine generic
twist, excluded by the binding no-line theorem.  Therefore every possible
section satisfies

\[
 d\ge4,\qquad d\equiv1\pmod3.
\]

The first gate is the degree-four scheme written explicitly in
`QUARTIC_SECTION_GATE.md`.

## Headline logic

A rational section gives a \(K_0\)-point of \(X\), and hence the positive
Problem E headline.  The degree-55 multisection instead gives points only
after \(L/K_0\), so it does not meet the acceptance criterion.

Conversely, the current fibration supplies no theorem

\[
 X(K_0)\ne\varnothing\Longrightarrow f\text{ has a rational section}.
\]

A \(K_0\)-point lies on one member of the hyperplane pencil and does not
itself sweep out a horizontal curve.  Therefore even a future proof that
this particular fibration has no section would not be a negative headline
proof without a new converse bridge.

On the positive side, the generic cubic-surface fibre has a degree-55 point.
The strongest applicable general theorem currently gives only

\[
 \text{rational point}\quad\text{or}\quad\text{effective degree-4 point}.
\]

Promoting a point of degree prime to three to a rational point on a cubic
surface is the Cassels--Swinnerton-Dyer conjectural implication in general.
The discovered multisection does not decide its surviving quartic branch.

## Exact verdict

The headline is neither proved nor refuted.  What is proved is the requested
method-level impossibility statement:

\[
 \boxed{\text{the installed degree-55 multisection cannot itself be
 descended or folded into a headline section}.}
\]

Any positive continuation must construct an independent section, starting
with the quartic gate, or produce a point by another route.  Any negative
continuation must prove pointlessness directly or supply the missing
point-to-section converse.

