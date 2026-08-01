# Exact degree-55 equivariant multisection

## Statement

Let

\[
 G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad
 E=\mathbf C(W),\qquad K_0=E^G,
\]

and let \(X/K_0\) be the generic twist of the Klein cubic.  In the exact
Hilbert--90 frame \([x,C,D,E,K]\), put

\[
 \Pi=\{a_3=a_4=0\},\qquad \Gamma=X\cap\Pi.
\]

The Goal M packet proves that \(\Gamma\) is a smooth plane cubic and that
blowing up \(\Gamma\) resolves the pencil through \(\Pi\):

\[
 X\xleftarrow{\pi}Y=\operatorname{Bl}_{\Gamma}X
   \xrightarrow{f}B=\mathbf P^1_{K_0},\qquad f=[a_3:a_4].
\]

Let \(H=D_{12}\) be the full stabilizer of an involution-minus-line
\(\ell\) on the split Klein cubic.  Then the normalization of the twist of
the orbit \(G\ell\) is a connected rational degree-55 multisection of
\(f\).  More precisely, with \(L=E^H\), there is a \(K_0\)-morphism

\[
 m\colon M=\mathbf P^1_L\longrightarrow Y
\]

such that \(f\circ m\) is the natural finite etale morphism
\(B_L\to B\), of degree

\[
 [L:K_0]=[G:H]=660/12=55.
\]

After extension to \(E\), the map is the disjoint normalization of 55
degree-one multisection components, and \(G\) permutes those components
transitively.  Thus the multisection is `G`-equivariant before twisting and
is defined over the invariant field after twisting.

## Proof

### 1. The connected orbit of lines descends

The exact characteristic-zero line certificate constructs an honest
two-dimensional \(H\)-subrepresentation \(U_-\subset W\) whose
projectivization \(\ell=\mathbf P(U_-)\) lies on the Klein cubic.  Testing
all 660 group elements proves that its full setwise stabilizer is exactly
\(H=D_{12}\).  Hence its orbit has 55 distinct lines.

The generic torsor \(\operatorname{Spec}E\to\operatorname{Spec}K_0\) is
connected and Galois with group \(G\).  Twisting the transitive
\(G\)-set \(G/H\) gives

\[
 \operatorname{Spec}L=\operatorname{Spec}E^H,
 \qquad [L:K_0]=55.
\]

Over \(L\), twisting the honest \(H\)-module \(U_-\) gives a rank-two
vector space.  Its projectivization is therefore \(\mathbf P^1_L\), with a
natural morphism to \(X\).  After extension to \(E\), this is the
normalization of the union of the 55 conjugate lines.  This construction is
semilinearly \(G\)-equivariant by descent, rather than a choice of one line
over \(K_0\).

### 2. The exact center plane misses every orbit line

The certified projective `xCD` theorem says that the smooth plane cubic
\(\Gamma_{\mathrm{proj}}\) has no point over

\[
 K_{\mathrm{proj}}=\mathbf C(\mathbf P(W))^G.
\]

The accepted generic-torsor field comparison is
\(K_0\simeq K_{\mathrm{proj}}(u)\), and the affine `xCD` center is the base
change of that projective center.  A point on a proper genus-one curve over
the purely transcendental extension would specialize to a
\(K_{\mathrm{proj}}\)-point.  Consequently

\[
 \Gamma(K_0)=\varnothing. \tag{1}
\]

Suppose an orbit line met \(\Pi\).  Incidence with the \(K_0\)-plane
\(\Pi\) is Galois invariant, while the 55 geometric lines form one
transitive orbit, so every conjugate line would meet \(\Pi\).  No such line
is contained in \(\Pi\), because then the smooth plane cubic
\(X\cap\Pi=\Gamma\) would contain a line.  Each intersection is therefore
one point, and descent gives an effective zero-cycle on \(\Gamma\) of
degree 55.

On the other hand, a line in \(\Pi\) cuts a \(K_0\)-rational divisor of
degree 3 on \(\Gamma\).  Since

\[
 37\cdot3-2\cdot55=1,
\]

the two cycles give a \(K_0\)-rational divisor class of degree one.  For a
smooth genus-one curve, Riemann--Roch gives a nonzero section of every
degree-one line bundle, hence an effective divisor of degree one and thus a
\(K_0\)-point.  This contradicts (1).  Therefore every one of the 55 orbit
lines is disjoint from \(\Pi\), and in particular from \(\Gamma\).

### 3. Projection makes the orbit a degree-55 multisection

Because the lines miss the blowup center, their strict transforms in \(Y\)
are unchanged.  On any one of them, \(a_3\) and \(a_4\) are two linear
forms with no common zero.  They are therefore linearly independent and
give an isomorphism

\[
 [a_3:a_4]|_{\ell_g}\colon \ell_g\xrightarrow{\sim}B_E.
\]

Descending these 55 isomorphisms gives

\[
 M=\mathbf P^1_L=B_L\longrightarrow Y,
 \qquad f\circ m=B_L\longrightarrow B.
\]

The latter map is finite etale of exact degree \([L:K_0]=55\).  Thus
\(M\) is a connected rational multisection of exact degree 55.  This proves
the requested `section OR multisection` assertion through the second
alternative.

## Boundary

The theorem does not turn \(M\to B\) into a section over \(K_0\).  Indeed,
the constants of \(M\) are \(L\), not \(K_0\).  It also does not claim that
the 55 geometric lines are pairwise disjoint; normalization is used, and
pairwise intersections at finitely many fibres do not affect the generic
degree.

