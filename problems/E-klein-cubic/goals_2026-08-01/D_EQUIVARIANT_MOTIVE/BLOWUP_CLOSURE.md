# Equivariant blowup closure and explicit surviving model

## 1. Theorem

There exists a smooth projective \(G\)-fourfold \(V\), obtained from
\(\mathbf P(W)\) by a blowup along a smooth \(G\)-stable centre, such that:

1. \(H^3(X,\mathbf Z)\) admits a primitive \(G\)-equivariant lattice
   embedding into \(H^3(V,\mathbf Z)\);
2. \(H^3(X,\mathbf Q)\) is a direct summand of \(H^3(V,\mathbf Q)\) as a
   polarizable rational \(G\)-Hodge structure, with polarization recovered up
   to a positive rational scalar;
3. \(h(X)_{\mathbf Q}\) is a direct summand of \(h(V)_{\mathbf Q}\) in the
   category of rational \(G\)-Chow motives.

Consequently the integral \(G\)-lattice and rational \(G\)-motive of the Klein
cubic lie in the unrestricted smooth equivariant-blowup closure required by
D2.

The theorem does not assert that this centre occurs in the base locus of a
landing covariant. Its role is exact: an invariant-only obstruction must
exclude the centre using actual base-locus geometry. Without that additional
restriction, the invariant is reproducible.

## 2. The Prym curve

Choose a general line \(\ell\subset X\). Projection from \(\ell\) makes the
blowup of \(X\) a conic bundle over \(\mathbf P^2\). Its discriminant
\(\Gamma\) is a smooth plane quintic, so

\[
g(\Gamma)=\frac{(5-1)(5-2)}2=6.
\]

The two components of a singular conic define a connected étale double cover

\[
\widetilde\Gamma\longrightarrow\Gamma,
\qquad g(\widetilde\Gamma)=2g(\Gamma)-1=11.
\]

The classical cylinder correspondence identifies

\[
J(X)\simeq\operatorname{Prym}(\widetilde\Gamma/\Gamma).
\]

Let \(\iota\) be the deck involution. With rational coefficients,
\((1-\iota)/2\) is the Prym projector. The Chow--Künneth middle factor of the
cubic therefore gives correspondences

\[
a:h^3(X)(-1)\longrightarrow h^1(\widetilde\Gamma),
\qquad
b:h^1(\widetilde\Gamma)\longrightarrow h^3(X)(-1)
\]

with \(b a=\mathrm{id}\). The same statement holds for rational Hodge
structures. The denominator two is retained explicitly; no integral Prym
splitting is claimed.

## 3. A free orbit of the curve in the source

Choose a sufficiently positive line bundle on \(\widetilde\Gamma\) and a
general five-dimensional generating subspace of sections. It gives an
embedding

\[
i:\widetilde\Gamma\hookrightarrow\mathbf P(W)
\]

which may be chosen so that

\[
i(\widetilde\Gamma)\cap g i(\widetilde\Gamma)=\varnothing
\qquad(1\ne g\in G).
\tag{3.1}
\]

Here is the dimension argument. For fixed \(g\ne1\) and distinct \(x,y\),
two-point evaluation from the high-degree embedding parameter space is
dominant, while the graph of \(g\) has codimension four in
\(\mathbf P^4\times\mathbf P^4\). Allowing \((x,y)\) to vary contributes
dimension two, so the bad embeddings remain a proper closed subset. On the
diagonal, the condition is \(i(x)\in\operatorname{Fix}(g)\). The exact Klein
eigenspace census says every nonidentity projective fixed locus has
codimension at least two; allowing \(x\) to vary still leaves positive
codimension. Avoiding the finitely many bad closed subsets, one for each
\(g\ne1\), proves (3.1).

Write \(C=i(\widetilde\Gamma)\). Then

\[
D=\coprod_{g\in G}gC\subset\mathbf P(W)
\]

is a smooth \(G\)-stable centre with exactly \(660\) components and trivial
component stabilizer. Set

\[
V=\operatorname{Bl}_D\mathbf P(W).
\]

The centre has codimension three. The integral blowup formula and its motivic
version contribute

\[
H^1(D,\mathbf Z)(-1)\subset H^3(V,\mathbf Z),
\qquad
h^1(D)(1)\subset h(V).
\tag{3.2}
\]

The same centre can be added as a further refinement of a hypothetical
resolved map: choose the high-degree embedding to avoid the finitely many
preceding centres, lift the free orbit isomorphically, and blow it up. Thus
the data below are not invariant under harmless refinement of a resolution.

## 4. Integral \(G\)-lattice reproduction

Put

\[
L=H^3(X,\mathbf Z),\qquad M=H^1(C,\mathbf Z).
\]

Then \(L\simeq\mathbf Z^{10}\) and \(M\simeq\mathbf Z^{22}\). Choose any
primitive embedding of abelian groups \(j:L\hookrightarrow M\).
Transporting cohomology along the orbit identifications gives

\[
H^1(D,\mathbf Z)\simeq\mathbf Z[G]\otimes_{\mathbf Z}M,
\]

where \(G\) acts by left multiplication on the regular factor. Define

\[
\Phi:L\longrightarrow\mathbf Z[G]\otimes M,
\qquad
\Phi(x)=\sum_{g\in G}[g]\otimes j(g^{-1}x).
\tag{4.1}
\]

For \(h\in G\), the \(g\)-coordinate of \(\Phi(hx)\) is
\(j(g^{-1}hx)\), while the \(g\)-coordinate of \(h\Phi(x)\) is

\[
j((h^{-1}g)^{-1}x)=j(g^{-1}hx).
\]

Thus \(\Phi\) is \(G\)-equivariant. Projection to the identity component,
followed by an abelian-group retraction of the primitive map \(j\), is a
\(\mathbf Z\)-linear left inverse. Hence \(\Phi(L)\) is primitive as an
abelian sublattice. In particular, reduction modulo every prime remains an
injective map of \(G\)-modules.

This proves assertion 1. It deliberately claims a lattice embedding, not an
integral Chow-motive projector or compatibility with Steenrod operations.

## 5. Rational \(G\)-Hodge and motive reproduction

Use the Prym correspondence \(a\) instead of the arbitrary lattice embedding
\(j\). On the direct sum indexed by \(G\), define

\[
I(x)=\sum_{g\in G}[g]\otimes a(g^{-1}x)
\]

and

\[
R([g]\otimes y)=\frac1{660}\,g\,b(y),
\]

extended linearly over all components. Both maps are \(G\)-equivariant, and

\[
R I(x)=\frac1{660}\sum_{g\in G}g\,b a(g^{-1}x)=x.
\tag{5.1}
\]

The maps are morphisms of rational Hodge structures, and the identical
calculation is valid for Chow correspondences. Thus \(h^3(X)\) is a rational
\(G\)-motive summand of \(h^1(D)(1)\), which is a blowup summand of \(h(V)\).

The induced positive form on \(I(H^3(X,\mathbf Q))\) is the sum of the
\(G\)-translates of the Prym form. On the complex irreducible \(W^*\), a
\(G\)-invariant positive Hermitian form is unique up to positive scalar.
Accordingly this realizes exactly the rational polarized-Hodge strength
forced by the relative-dimension-one splitting, not an integral principal
polarization.

The remaining summands of \(h(X)\) are

\[
\mathbf1,\mathbf L,\mathbf L^2,\mathbf L^3.
\]

They already occur in \(h(\mathbf P^4)\), with trivial \(G\)-action on the
hyperplane-generated classes. This proves assertions 2 and 3.

The displayed construction uses denominators \(2\) for the Prym projector and
\(660\) for the equivariant retraction. \(\mathbf Z[1/1320]\) is therefore a
safe explicit coefficient ring for the displayed projector. No assertion at
the bad primes \(2,3,5,11\) is smuggled into the rational statement.

## 6. Why this defeats the chosen obstruction

The D2 closure was required to include nonlinear positive-genus centres. The
curve \(D\) is such a centre, and it supplies

\[
\operatorname{rank}H^1(D,\mathbf Z)
=660\cdot2\cdot11=14520.
\]

More importantly, (4.1) reproduces the exact integral \(G\)-lattice, while
(5.1) reproduces the exact rational \(G\)-Hodge structure and motive. Hence a
character, rank, Chern-number, rational-motive, or unpolarized
integral-lattice comparison cannot put the target outside the unrestricted
source closure.

A future obstruction would have to prove that every base-locus resolution
excludes this kind of orbit centre, or control an integral equivariant
operation that is both forced through the uncontrolled degree \(n\) and not
present in the closure. Neither condition follows from dominance alone.
