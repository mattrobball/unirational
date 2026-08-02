# Homogeneous generic-point theorem

## 1. Abstract statement

Let `R` be a positively graded domain over an infinite field, let `M` be a
finite graded torsion-free `R`-module, and let

\[
q:M\longrightarrow R
\]

be a homogeneous polynomial law of degree `r`, so that
\(q(M_d)\subset R_{rd}\).  Let `K=Frac(R)` and let `K_0` be the degree-zero
subfield of homogeneous fractions.  Assume:

1. \(\tau\in K\) is a nonzero homogeneous element of degree one;
2. homogeneous vectors \(B_0,\ldots,B_{s-1}\in M\), of degrees \(e_i\), form a
   \(K\)-basis of \(M\otimes_RK\).

Define

\[
\Phi(a_0,\ldots,a_{s-1})=
q\!\left(\sum_i a_iB_i/\tau^{e_i}\right)
\]

as a homogeneous form of degree `r` over `K_0`.

### Theorem

The following are equivalent:

1. there are \(d\) and \(0\ne p\in M_d\) with \(q(p)=0\);
2. the projective hypersurface \(V(\Phi)\) has a \(K_0\)-rational point.

More precisely, the two constructions below are inverse after projectivizing
and identifying homogeneous invariant scalar multiples.

## 2. A homogeneous covariant gives a generic point

Take \(0\ne p\in M_d\) with \(q(p)=0\).  Since the `B_i` form a `K`-basis, write
uniquely

\[
p=\sum_i c_iB_i,\qquad c_i\in K.
\]

Each `c_i` is homogeneous of degree `d-e_i`.  One way to see this without any
choice of presentation is to apply the source-scaling action.  For every
scalar `lambda`, uniqueness of the frame expansion gives

\[
\lambda^d p
=\sum_i c_i(\lambda\cdot -)\lambda^{e_i}B_i,
\]

hence `c_i(lambda x)=lambda^{d-e_i}c_i(x)`.  Equivalently, Cramer's rule for
the homogeneous frame matrix gives the same degree.

Set

\[
a_i=c_i\tau^{e_i-d}.
\]

Every \(a_i\) has degree zero, so \(a_i\in K_0\), and not all \(a_i\) vanish.  The
identity

\[
\frac p{\tau^d}=
\sum_i a_i\frac{B_i}{\tau^{e_i}}
\]

and homogeneity of `q` give

\[
\Phi(a)=\frac{q(p)}{\tau^{rd}}=0.
\]

Thus \([a_0:\cdots:a_{s-1}]\) is a \(K_0\)-point of \(V(\Phi)\).

## 3. A generic point clears to one homogeneous covariant

Conversely, take a point \([a_0:\cdots:a_{s-1}]\in V(\Phi)(K_0)\).  Put

\[
b_i=a_i\tau^{-e_i}.
\]

The element `b_i` is a homogeneous fraction of degree `-e_i`; choose
homogeneous \(n_i,d_i\in R\), with \(d_i\ne0\), such that

\[
b_i=n_i/d_i,
\qquad \deg n_i=\deg d_i-e_i.
\]

Let

\[
h=\prod_i d_i,
\qquad H=\deg h,
\]

and define

\[
p=h\sum_i b_iB_i
 =\sum_i\left(n_i\prod_{j\ne i}d_j\right)B_i.
\]

The coefficient of `B_i` has degree `H-e_i`; therefore every summand has the
single degree \(H\), and \(p\in M_H\).  No highest-component extraction is used,
so no cancellation between source degrees is possible.  Since the frame is a
basis over \(K\), \(h\ne0\), and the projective coordinate vector is nonzero,
we have \(p\ne0\).  Finally,

\[
q(p)=h^r q\!\left(\sum_i a_iB_i/\tau^{e_i}\right)
=h^r\Phi(a)=0.
\]

This proves the equivalence.

## 4. Application to the Klein cubic

For the Klein problem,

\[
R=\operatorname{Sym}(W^*)^G,
\qquad M=(\operatorname{Sym}(W^*)\otimes W)^G,
\qquad q(p)=F(p),
\]

with `r=3`,

\[
B=(x,C,D,E,K_7),
\qquad e=(1,4,5,6,7),
\qquad \tau=f_3^2/f_5.
\]

Thus

\[
\exists d,\ 0\ne p\in M_d,\ F(p)=0
\quad\Longleftrightarrow\quad
V(\Phi)(K_{\rm proj})\ne\varnothing.
\]

This is an all-degree theorem: no degree is omitted and no bounded degree
search is assumed.

## 5. Scalar saturation and primitive representatives

Let \(s\in R_h\) be nonzero and homogeneous.  If \(p\in M_d\), then the normalized
coordinates of `sp` are

\[
a_i(sp)=(s/\tau^h)a_i(p).
\]

Because \(s/\tau^h\in K_{\rm proj}^*\), `p` and `sp` define the same projective generic
point.  Conversely, two denominator clearings of the same projective generic
point become equal after multiplication by nonzero homogeneous invariants.
Thus \(V(\Phi)(K_{\rm proj})\) parametrizes homogeneous rational
scalar-saturation lines in \(M\otimes_RK\).

For a point `ell`, its polynomial representatives are the nonzero homogeneous
elements of the lattice

\[
M\cap \ell \subset M\otimes_RK.
\]

Over a nonfactorial invariant ring this lattice need not have a unique
primitive generator.  “Primitive” is therefore a divisibility/incidence
condition on polynomial representatives, not the linear quotient by
`R_+M`.  Clearing denominators may select a nonprimitive representative, but
it cannot create or destroy the rational line.

This also explains why a finite list of primitive degrees is not supplied by
Noetherianity: one projective generic point can have polynomial
representatives in arbitrarily many degrees, while a least primitive degree,
when defined, is a height problem over `K_proj`.

## 6. Multiplication and precomposition

Invariant multiplication preserves landing:

\[
F(sp)=s^3F(p).
\]

If `u:W->W` is a homogeneous `G`-equivariant polynomial map of degree `e`,
then

\[
F(p\circ u)=(F\circ p)\circ u=0,
\qquad \deg(p\circ u)=e\deg p.
\]

Hence quartic or other homogeneous precomposition is represented in the
global universal object and cannot escape the all-degree equivalence.  When
`u` is dominant, the induced action on invariant function fields pulls the
projective generic point back along the corresponding degree-zero field
embedding.  No assertion that composition bounds the first primitive degree
is used.

## 7. Exact relation to the symbolic transition system

Every nonzero global homogeneous landing covariant has a finite true
symbolic order along the involution plus-plane arrangement.  Its restrictions
therefore determine a point of one exact stratum `L_{m,d}` and satisfy every
installed triple-line, point-link, marked-elliptic, and torsion condition.  In
particular,

\[
V(\Phi)(K_{\rm proj})\ne\varnothing
\quad\Longleftrightarrow\quad
\bigcup_{d,m}\mathcal L_{m,d}\ne\varnothing.
\]

The pair `(m,d)` belongs to a polynomial representative, not to its projective
rational line; invariant multiplication can shift both values.
Conversely, the theorem clears only a `K_proj`-point to an element of `M`; it
does not algebraize an arbitrary compatible-looking local inverse-limit
state.  This is exactly the global-image requirement missing from purely
local transition constructions.
