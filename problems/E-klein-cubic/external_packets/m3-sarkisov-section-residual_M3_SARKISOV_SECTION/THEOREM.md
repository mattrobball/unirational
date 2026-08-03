# M3 theorem — residual Galois and the section-component boundary

## Set-up

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad
E=\mathbf C(\mathbf P(V_6)),\qquad K=E^G,
\]

and let \(X_T/K\) be the genuine Schur twist of the Klein cubic.  In the
installed degree-eight Hilbert--90 frame write

\[
X_T=\{\Phi(a_0,\ldots,a_4)=0\}\subset \mathbf P^4_K,
\qquad C=C_{012}=X_T\cap\{a_3=a_4=0\}.
\]

The M2 link is

\[
X_T\xleftarrow{\ \pi\ }Y=\operatorname{Bl}_C(X_T)
\xrightarrow{\ f\ }\mathbf P^1_K,
\]

with graph equation

\[
Y=\{\Phi(a)=0,\ a_3t-a_4s=0\}\subset\mathbf P^4\times\mathbf P^1.
\]

Put \(H=\pi^*\mathcal O_{X_T}(1)\), let \(D\) be the exceptional divisor,
and put \(L=H-D=f^*\mathcal O_{\mathbf P^1}(1)\).

## Theorem

The following statements hold.

### 1. Exact section-class decomposition at the bottom

Let \(\Gamma\subset Y\) be a rational section and put
\(d=H\cdot\Gamma\).

1. If \(\Gamma\subset D\), then \(d=0\), and the scheme of such sections is
   exactly the center cubic \(C\).  In particular, an exceptional section is
   the same as a point of \(C(K)\).
2. If \(\Gamma\not\subset D\), then \(d\ge1\),
   \[
   D\cdot\Gamma=d-1,
   \]
   and the section has graph coordinates
   \[
   a_i=A_i(s,t)\quad(i=0,1,2),\qquad
   a_3=sU(s,t),\qquad a_4=tU(s,t),
   \]
   where \(A_i\) has degree \(d\), \(U\) has degree \(d-1\), and
   \(\Phi(A_0,A_1,A_2,sU,tU)=0\) identically.
3. The nonexceptional \(d=1\) and \(d=2\) section loci are empty over \(K\).
   Their blowdowns would be respectively a \(K\)-line and a geometrically
   integral \(K\)-plane conic on \(X_T\), excluded by the binding no-line and
   no-conic theorems.
4. The first nonexceptional live scheme is therefore \(d=3\).  Before the
   morphism/open saturation, it is cut out by the ten coefficients of the
   binary nonic
   \[
   \Phi(A_0,A_1,A_2,sU,tU)
   \]
   in \(\mathbf P^{14}\): the three binary cubics \(A_i\) contribute twelve
   coefficients and the binary quadratic \(U\) contributes three.

### 2. The degree-three scheme has a genuine geometric component

At each of the two split reductions

\[
(p,\zeta_{11})=(23,2),\qquad(67,9),
\]

the exact Schur/Weil representation and degree-eight Reynolds frame admit a
good source point for which:

- the frame determinant and scalar invariant are nonzero;
- \(C_{012}\) is geometrically smooth;
- all 55 involution lines avoid the center;
- the degree-three section equations have a basepoint-free point at which the
  \(10\times15\) relative Jacobian has rank ten.

The nonzero \(10\times10\) minors are `6 mod 23` and `44 mod 67` in the
stored witnesses.  Thus the relative affine section scheme is standard
smooth of dimension five there, and its projectivization has local dimension
four.  Consequently the geometric degree-three section scheme has a
horizontal component.  This is a component theorem, not a descended
\(K\)-point.

### 3. Residual Galois does not turn the quartic alternative into a section

The splitting field of the installed 55-line multisection is
\(E(q)/K(q)\), with Galois group \(G\).  The stabilizer of one line is
\(D_{12}\), and the 55-point action has subdegrees

\[
1,3,3,6,6,6,6,12,12.
\]

The unordered-pair orbits have sizes

\[
165,165,165,330,330,330.
\]

Moreover, \(G\) has no subgroup of index four.  Indeed, a transitive
four-point action gives a homomorphism \(G\to S_4\); simplicity makes its
kernel trivial or all of \(G\), while an injection is impossible because
\(|G|=660>24\).  Therefore a degree-four residue field contained in
\(E(q)\) cannot occur.

It follows that, if the section branch of the accepted section-or-integral-
quartic theorem fails, the resulting quartic point is necessarily defined
by a new extension of \(K(q)\), not by selecting a component inside the
55-line splitting field.  The residual-Galois argument alone does not force
a section.

### 4. Every binary secant of the 55 line sections is nonterminal

For every unordered pair of the 55 horizontal line sections, take the third
intersection point of their fibrewise secant with the cubic surface.  The
producer and independent verifier compute all 1,485 pairs at both split
primes above.  On the six pair orbits, the numbers of distinct secant outputs
are

\[
330,330,55,165,165,330
\]

at both primes, in the deterministic orbit ordering stored in the payload.
In particular, every orbit image has at least 55 elements; no pair orbit
collapses to a singleton section.  A generic identity between two outputs
would remain an identity after every good specialization, so the displayed
separations exclude a characteristic-zero singleton collapse.

This closes the natural binary-secant residual route from the 55-line
multisection.  It does not exclude residual constructions involving extra
choices, higher arity, tangencies, or unrelated section components.

## Exact remaining boundary

No rational section and no integral quartic multisection is constructed in
this packet.  The live section alternatives are:

1. a point of the exceptional center cubic \(C_{012}(K)\);
2. a \(K\)-point of the nonexceptional degree-three component;
3. a section of higher \(H\)-degree.

If all section components are pointless, the accepted cubic-surface theorem
supplies an integral degree-four multisection, but its residue field is not
contained in the 55-line splitting field.  Hence the Klein-cubic headline
remains **OPEN**.
