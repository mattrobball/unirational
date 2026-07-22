# Tangent residuals prove unirationality for every smooth `(2,3)` member

## Theorem

Let

\[
X=\{F(x,y)=0\}\subset \mathbf P^2_x\times\mathbf P^2_y
\]

be a smooth hypersurface of bidegree `(2,3)` over an algebraically closed
field of characteristic zero.  Then there is a line
\(L\subset\mathbf P^2_y\) for which the vertical surface

\[
S_L=X\cap(\mathbf P^2_x\times L)
\]

is rational and fiberwise tangent residuals in the plane-cubic fibration
\(X\to\mathbf P^2_x\) map \(S_L\) birationally to a horizontal divisor

\[
T_L\sim aH_x+H_y,\qquad 1\leq a\leq10.
\]

Consequently \(T_L\to\mathbf P^2_y\) has degree \(2a\), and base change
of the conic bundle along the rational normalization of \(T_L\) gives a
dominant rational map

\[
\mathbf P^3\dashrightarrow X
\]

of even degree \(2a\leq20\).  In particular,

\[
\boxed{\text{every smooth `(2,3)` hypersurface in }
\mathbf P^2\times\mathbf P^2\text{ is unirational}.}
\]

For a general equation the three residual-line coefficients are coprime,
so \(a=10\) and the degree is exactly `20`, as proved in
[`tangent_residual_theorem.md`](tangent_residual_theorem.md).  The point of
the argument below is to show that for an arbitrary smooth equation one can
choose `L` so that \(a>0\), even though a fixed `L` can have a nontrivial
common factor and hence \(a<10\).

## 1. The generic plane cubic is smooth and nonconstant

Write \(\rho:X\to\mathbf P^2_x\) for the first projection and put

\[
K=k(\mathbf P^2_x),\qquad C=X_K\subset\mathbf P^2_{y,K}.
\]

The morphism \(\rho\) is dominant.  Since `X` is smooth and the ground
field has characteristic zero, generic smoothness makes `C` a smooth plane
cubic over `K`.  (A fiber equal to the whole \(\mathbf P^2_y\) cannot occur
on a smooth `X`: at such a fiber the two derivatives in independent
\(x\)-directions are plane cubics and have a common zero, which would be a
singular point of `X`.)

The embedded cubic `C` is not constant.  Indeed, if

\[
C=C_0\times_k K\subset\mathbf P^2_{y,K}
\]

for a plane cubic \(C_0=\{f_0(y)=0\}\) over `k`, then
\(F(x,y)=\lambda(x)f_0(y)\) in \(K[y]\).  Comparing one nonzero
coefficient shows that \(\lambda\) is a quadratic form in `x`, and hence

\[
F(x,y)=Q(x)f_0(y)
\]

in \(k[x,y]\).  The two components meet, so this hypersurface is singular,
contrary to the hypothesis.

## 2. The full residual-line map of a smooth cubic

Let \(C\subset\mathbf P^2\) be a smooth plane cubic over a field of
characteristic zero.  If `p` is a point of `C`, write

\[
T_pC\cdot C=2p+g(p).
\]

After choosing a flex as origin, the chord-and-tangent law gives
\(g(p)=-2p\).  In particular `g` is a finite morphism of degree four and
preserves collinearity.  If a line `L` cuts

\[
L\cdot C=p+q+r,
\]

then \(g(p)+g(q)+g(r)=0\), so the three residual points are collinear.  This
defines a morphism

\[
\delta_C:(\mathbf P^2)^\vee\longrightarrow(\mathbf P^2)^\vee,
\qquad
L\longmapsto \overline{g(p)g(q)g(r)}.
\tag{2.1}
\]

It is the degree-four Lattès map attached to `C`.

### Lemma 2.1 (the residual-line map determines the cubic)

The critical-value curve of \(\delta_C\) is exactly the dual sextic
\(C^\vee\).  Consequently \(\delta_C\) determines the embedded cubic
`C` by projective biduality.

### Proof

Over an algebraic closure, choose a flex as origin and consider

\[
\pi:C\times C\longrightarrow(\mathbf P^2)^\vee,
\qquad
(p,q)\longmapsto\overline{pq},
\]

where the value on the diagonal is the tangent line.  If
\(r=-p-q\), a general fiber consists of the six orderings of two elements
of the line section \(p+q+r\).  Thus `pi` is the quotient by the natural
\(S_3\)-action.  Its ramification is the union of the three reflection
curves on which two of \(p,q,r\) coincide, and its branch curve is the
discriminant of nonreduced line sections, namely \(C^\vee\).

The étale map

\[
\mu=[-2]\times[-2]:C\times C\longrightarrow C\times C
\]

commutes with the \(S_3\)-action and satisfies

\[
\pi\circ\mu=\delta_C\circ\pi.
\tag{2.2}
\]

The ramification formula for the two sides of (2.2) gives

\[
\pi^*R_{\delta_C}=\mu^*R_\pi-R_\pi.
\tag{2.3}
\]

For each pair of indices, the inverse image under `mu` of the reflection
curve \(p_i=p_j\) is the union of the four curves
\(p_i-p_j=\varepsilon\), with \(\varepsilon\in C[2]\).  Subtracting
\(R_\pi\) removes the component \(\varepsilon=0\), so (2.3) says precisely
that the ramification of \(\delta_C\) is covered by the translates with
\(0\ne\varepsilon\in C[2]\).  Under \(\delta_C\), every one of these curves
maps to the locus where the corresponding two residual points coincide,
which is \(C^\vee\).  Conversely a general tangent section has such a lift
for every chosen nonzero two-torsion difference.  Thus the reduced
critical-value curve is exactly \(C^\vee\).

Finally \((C^\vee)^\vee=C\), so the critical values recover `C`.  This is
also the standard description of this Lattès map; see McMullen--Mukamel--
Wright, Section 2, equation (2.6), and Dabija--Jonsson, Section 4.3.  \(\square\)

The quotient proof is algebraic, so the lemma applies to the generic cubic
over `K`, not only to a single complex fiber.

## 3. A constant-values descent lemma

We will use the following elementary observation with
\(K=k(s,t)=k(\mathbf P^2_x)\).

### Lemma 3.1

Let

\[
\varphi:\mathbf P^n_K\longrightarrow\mathbf P^m_K
\]

be a morphism.  If \(\varphi(z)\in\mathbf P^m(k)\) for a Zariski-dense set
of points \(z\in\mathbf P^n(k)\), then `varphi` is defined over `k`.

### Proof

After restricting to source and target affine charts on which a dense subset
of the constant-value points remains, write the coordinate ratios of
`varphi` as rational functions
\(R_i(z)\in K(z_1,\ldots,z_n)\).  For every `k`-derivation
\(D:K\to K\), the rational function \(D(R_i)\) vanishes at the dense set
of constant points in the hypothesis, and hence is zero.  The common
constants in \(K(z_1,\ldots,z_n)\) for the `k`-derivations of the purely
transcendental extension `K/k` are
\(k(z_1,\ldots,z_n)\); therefore every `R_i` lies in that field.  This
descends the rational map.  Its descended coordinate forms have no common
zero because their base change to `K` is the given morphism, so the morphism
itself is defined over `k`.  \(\square\)

Apply this to \(\delta_C\) for the generic cubic of Section 1.  The map
\(\delta_C\) cannot be defined over `k`: if it were, its critical-value
curve would be defined over `k`; Lemma 2.1 and biduality would then make
the embedded cubic `C` constant, contradicting Section 1.  Lemma 3.1
therefore gives a constant line

\[
L\in(\mathbf P^2_y)^\vee(k)
\]

such that \(\delta_C(L)\notin(\mathbf P^2_y)^\vee(k)\).  More precisely,
let `Z` be the `k`-Zariski closure of the constant lines having constant
image.  Lemma 3.1 says that \(Z\ne(\mathbf P^2_y)^\vee\).  If `B` is any
proper closed bad locus over `K`, then \(Z_K\cup B\) is still proper.  Its
complement contains a constant
point: expand finitely many defining `K`-coefficients in a finite
`k`-linearly independent set and use that `k` is infinite.  Thus `L` can be
chosen simultaneously outside `Z` and the open-condition bad loci below.

## 4. Choosing `L` and constructing the horizontal surface

Choose the constant line `L` above also so that:

1. \(S_L\) is integral and its generic conic over \(k(L)\) is smooth;
2. \(C\cap L\) is reduced; and
3. \([-2]\) is injective on the three points of \(C\cap L\).

These are nonempty open conditions on `L`.  Smoothness of `X` first rules
out a whole \(\mathbf P^2_x\) fiber of \(X\to\mathbf P^2_y\): at such a
fiber the two derivatives in independent `y`-directions are plane quadrics
and have a common zero, which would be singular on `X`.  Hence a line not
contained in the conic discriminant has a geometrically integral generic
conic; there is no vertical surface component, so `S_L` is integral.  For
(2), avoid the dual sextic.  After base change to an algebraic closure, the
bad lines in (3) are the union, over the three nonzero points
\(\varepsilon\in C[2]\), of the curves swept out by the chords
\(\overline{p,p+\varepsilon}\).  Their union is Galois invariant and hence a
proper closed `K`-locus.  Section 3 supplies a constant `L` outside their
union and with nonconstant residual line.

Projection \(S_L\to L\simeq\mathbf P^1\) has a smooth conic as generic
fiber.  Tsen's theorem gives a point over \(k(L)\), and hence

\[
k(S_L)\simeq k(t)(z).
\]

Thus \(S_L\) is rational.  Fiberwise tangent residuals define

\[
\tau_L:S_L\dashrightarrow X.
\]

Conditions (2)--(3) say that over the generic point of
\(\mathbf P^2_x\), this map sends the three points of \(C\cap L\)
injectively to the three points of
\(C\cap\delta_C(L)\).  Its image `T_L` is therefore an irreducible surface,
\(S_L\dashrightarrow T_L\) is birational, and \(T_L\to\mathbf P^2_x\)
has degree three.

It remains to prove horizontality.  Its image in \(\mathbf P^2_y\) cannot
be a point, because every fiber of \(X\to\mathbf P^2_y\) is one-dimensional
whereas `T_L` is a surface.  Suppose instead that the image were a curve.
Grothendieck--Lefschetz
for the smooth ample divisor `X` gives

\[
\operatorname{Pic}(X)=\mathbf ZH_x\oplus\mathbf ZH_y.
\]

Writing \([T_L]=aH_x+bH_y\), a general conic fiber over a point outside
the image curve is disjoint from `T_L`, so \(2a=0\).  Its degree three over
\(\mathbf P^2_x\) gives \(3b=3\).  Hence

\[
[T_L]=H_y.
\]

The restriction sequence and
\(H^1(\mathbf P^2\times\mathbf P^2,\mathcal O(-2,-2))=0\) show that every
section of \(\mathcal O_X(0,1)\) is the restriction of a linear form on
\(\mathbf P^2_y\), so `T_L` would be the inverse image of a
constant line \(M\subset\mathbf P^2_y\).  On the generic cubic this says

\[
\delta_C(L)=M\in(\mathbf P^2_y)^\vee(k),
\]

contrary to the choice of `L`.  Thus `T_L` is horizontal.

## 5. Its class and the degree bound

Put coordinates \(L=\{W=0\}\).  The universal resultant identity from
[`tangent_residual_theorem.md`](tangent_residual_theorem.md) produces the
residual line

\[
q_L(x,y)=q_U(x)U+q_V(x)V+q_W(x)W,
\]

where \(q_U,q_V,q_W\) are homogeneous of degree ten in `x`.  For the
present special equation they may have a common factor.  Write

\[
h=\gcd(q_U,q_V,q_W),\qquad e=\deg h,
\]

and divide it out.  The primitive residual equation cuts a divisor `D` of
class \((10-e)H_x+H_y\).  Its generic fiber over \(\mathbf P^2_x\) is
exactly the three-point image of \(S_L\), so `T_L` is its unique component
dominating \(\mathbf P^2_x\).  We already know
\([T_L]=aH_x+H_y\).  Every other effective component of `D` has
nonnegative `H_x`- and `H_y`-coefficients, while the total `H_y`-coefficient
of `D` is already exhausted by `T_L`.  The nonnegativity follows by
intersecting an effective prime divisor with general conic and cubic fibers.
Hence

\[
1\leq a\leq10-e\leq10.
\]

Here the first inequality is horizontality, equivalently the nonconstancy of
\(\delta_C(L)\).  Therefore

\[
\deg(T_L/\mathbf P^2_y)=2a\leq20.
\]

The normalization of `T_L` is rational because it is birational to
`S_L`.  After base change to this normalization, the conic bundle has its
tautological point and is birational to
\(\widetilde T_L\times\mathbf P^1\).  Projection back to `X` is dominant
of degree \(2a\), which proves the theorem.

## 6. Scope beyond smooth members

There is first a broader case that needs none of the Lattès argument.  Let
`X` be an integral `(2,3)` member whose generic plane cubic over
\(k(\mathbf P^2_x)\) is geometrically integral but singular.  Its unique
geometric singular point is rational over that function field in
characteristic zero.  Projection from the singular point makes the cubic
rational, so

\[
k(X)=k(\mathbf P^2_x)(t).
\]

Thus `X` itself is rational.  The genuinely difficult case is the smooth
generic cubic treated above.

Smoothness was used in three precise places: generic smoothness of the two
fibrations, Grothendieck--Lefschetz for `Pic(X)`, and the contradiction to a
constant factorization.  The same proof therefore applies to any integral
`(2,3)` hypersurface for which:

1. the generic plane cubic and the generic conic are smooth;
2. a general constant line section `S_L` is integral;
3. `X` is normal and locally factorial with
   \(\operatorname{Pic}(X)=\mathbf ZH_x\oplus\mathbf ZH_y\), and the
   effective-cone and ambient-section statement used for class `(0,1)` holds;
   and
4. the generic embedded cubic is not constant.

This gives a useful extension to suitable mildly singular factorial
members.  No claim is made here for every singular member; nonfactorial or
generically geometrically reducible/nonreduced cubic fibrations require
separate arguments.

## References for the Lattès lemma

- C. T. McMullen, R. E. Mukamel, A. Wright, *Cubic curves and totally
  geodesic subvarieties of moduli space*, Section 2, especially equation
  (2.6), Ann. of Math. 185 (2017), 957--990:
  <https://doi.org/10.4007/annals.2017.185.3.6>.
- M. Dabija, M. Jonsson, *Algebraic webs invariant under endomorphisms*,
  Publ. Mat. 54 (2010), 137--148, Section 4.3:
  <https://doi.org/10.5565/PUBLMAT_54110_07>.
