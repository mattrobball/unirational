# WP-3 structural certificate: all odd degrees excluded, even degree at least 24

Date: 2026-07-28.

## Verdict and exact boundary

Let \(V\) be the determinant-one three-dimensional Klein representation of
\(G=\operatorname{PSL}_2(\mathbf F_7)\), and put

\[
F=x^3y+y^3z+z^3x,\qquad
S=\{w^2=F\}\subset\mathbf P(1,1,1,2).
\]

Suppose a homogeneous \(G\)-covariant

\[
p=(p_0,p_1,p_2):V\longrightarrow V,\qquad \deg p_i=d,
\]

and a \(G\)-invariant polynomial \(h\) of degree \(2d\) satisfy

\[
F(p_0,p_1,p_2)=h^2. \tag{1}
\]

If the induced rational map

\[
\mathbf P(V)\dashrightarrow S,\qquad [v]\longmapsto[p(v):h(v)]
\]

is dominant, then, after removing the common polynomial factor of the
three coordinates of \(p\), its degree is even and at least \(24\).
Equivalently:

- every primitive odd-degree landing covariant is impossible, in every
  degree;
- every primitive even-degree landing covariant has \(d\geq24\).

Thus the homogeneous \(V\)-covariant model has no solution of degree at
most \(23\).  The exhaustiveness lemma below shows that this is not merely
one optional construction route: every hypothetical \(G\)-unirationality
map can be put in this form.  The argument does **not** exclude all higher
even degrees, and therefore is not a resolution of Problem F.

## 1. Why the homogeneous covariant model is exhaustive

The generic-twist criterion recorded in [RESOLUTION.md](../RESOLUTION.md)
reduces \(G\)-unirationality of \(S\) to a dominant rational \(G\)-map

\[
f:\mathbf P(V)\dashrightarrow S.
\]

Represent the composite \(\pi f:\mathbf P(V)\dashrightarrow\mathbf P(V)\)
by a primitive homogeneous triple \(p=(p_0,p_1,p_2)\) of some common
degree \(d\).  For \(g\in G\), the triples \(p(gv)\) and \(g p(v)\)
represent the same projective rational map.  Two primitive homogeneous
triples of the same degree representing the same rational map differ by a
nonzero constant.  Hence

\[
p(gv)=\lambda_g\,g p(v).
\]

The constants \(\lambda_g\) form a character of \(G\).  Since
\(G=\operatorname{PSL}_2(\mathbf F_7)\) is perfect, this character is
trivial, and \(p\) is an honest \(G\)-covariant.

With this normalization, the weighted coordinate of \(f\) is a homogeneous
rational function \(h\) of degree \(2d\) satisfying \(h^2=F(p)\).  Write
\(h=a/b\) in lowest terms in the UFD \(\mathbf C[x,y,z]\).  Since
\(b^2\mid a^2\), the denominator \(b\) is constant; thus \(h\) is a
polynomial.  Equivariance makes it a semi-invariant, and perfectness of
\(G\) again makes it invariant.  Therefore every hypothetical positive
solution is represented by (1).

## 2. Primitive reduction

Work over \(\mathbf C\).  Let \(a=\gcd(p_0,p_1,p_2)\).  The divisor of
\(a\) is \(G\)-stable, so \(a\) is a semi-invariant.  Since \(G\) is
perfect, it has no nontrivial characters; after scalar normalization,
\(a\) is \(G\)-invariant.  Unique factorization applied to (1) gives
\(a^2\mid h\).  Thus

\[
p=a p',\qquad h=a^2h',\qquad F(p')=(h')^2,
\]

and \(p'\) is again a \(G\)-covariant.  We may consequently assume
\(\gcd(p_0,p_1,p_2)=1\).  This matters because multiplication by the
degree-21 Klein anti-invariant can change the displayed parity while
leaving the projective rational map unchanged.

For a primitive covariant, no reflection line is contained in the
indeterminacy locus.  If the equation of one such line divided all
\(p_i\), equivariance would make all 21 conjugate equations divide all
\(p_i\), contrary to primitivity.

The case \(h=0\) cannot give a dominant landing map.  Then the projective
image of \(p\) lies in the smooth Klein quartic \(F=0\).  A rational map
from the rational surface \(\mathbf P^2\) to a genus-three curve is
constant, and a \(G\)-equivariant constant would be a \(G\)-fixed point
of the Klein quartic; no such point exists.  Hence below \(h\ne0\).

## 3. Involution lines and their centralizers

Fix an involution \(t\in G\).  In the exact representation checked in
[wp1_fixed_loci.py](wp1_fixed_loci.py),

\[
V=E_+\oplus E_-,\qquad \dim E_+=1,\quad\dim E_-=2,
\]

where \(t\) acts as \(+1\) on \(E_+\) and as \(-1\) on \(E_-\).  Put
\(L_t=\mathbf P(E_-)\).  The 21 involutions give 21 distinct conjugate
lines, whose reduced union has equation \(X=0\), with \(\deg X=21\).

The exact group closure gives

\[
|C_G(t)|=8,
\]

with element-order census \(1,2,2,2,2,2,4,4\), and an element \(r\) of
order four satisfying \(r^2=t\).  Hence \(C_G(t)\simeq D_8\).  The
\(D_8\)-module \(E_-\) has no invariant line.  Indeed, a hypothetical
invariant line would afford a character \(\chi\).  Every character of
\(D_8\) kills its commutator \(r^2=t\), whereas \(t\) acts on \(E_-\)
as \(-1\).

The fixed-locus certificate also proves

\[
S^t=\pi^{-1}(L_t)\;\sqcup\;\{s_t^+,s_t^-\}, \tag{2}
\]

where \(\pi^{-1}(L_t)\) is a smooth genus-one curve and the two isolated
points lie over \(\mathbf P(E_+)\).  In particular,
\(F|_{E_+}\ne0\).

## 4. All primitive odd degrees are impossible

Assume \(d\) is odd.  For \(v\in E_-\), homogeneity and equivariance give

\[
t p(v)=p(tv)=p(-v)=-p(v),
\]

so the base image of \(L_t\) lies in \(L_t\).  Primitivity ensures that
the rational map is defined at the generic point of \(L_t\).  Its
restriction therefore gives a rational map

\[
L_t\simeq\mathbf P^1\dashrightarrow\pi^{-1}(L_t).
\]

The target is proper, so the map extends across the finitely many base
points on \(L_t\).  A map from \(\mathbf P^1\) to a smooth genus-one curve
is constant.  Denote its value by \(s\).  Every element of \(C_G(t)\)
stabilizes \(L_t\); equivariance of the constant restriction gives
\(g s=s\) for all \(g\in C_G(t)\).  Projecting to \(L_t\) would produce
a \(D_8\)-invariant line in \(E_-\), a contradiction.

Thus no primitive odd-degree covariant can satisfy (1) and induce a
dominant map.

## 5. The Jacobian bound in even degree

Now let \(d\) be even, and write

\[
J_p=\det\left(\frac{\partial p_i}{\partial x_j}\right),
\qquad \deg J_p=3(d-1).
\]

Dominance makes \(J_p\ne0\) in characteristic zero.

For \(v\in E_-\),

\[
t p(v)=p(tv)=p(-v)=p(v),
\]

hence \(p(E_-)\subset E_+\).  Along the two-dimensional vector plane
\(E_-\), both tangent derivatives of \(p\) are multiples of one fixed
vector spanning \(E_+\).  The full differential has rank at most two at
a general point of \(E_-\), so the equation of \(L_t\) divides \(J_p\).
This holds for all 21 lines, and hence

\[
X\mid J_p. \tag{3}
\]

On \(E_-\), write \(p(v)=a_t(v)e_t\), where \(e_t\) spans \(E_+\).
Since \(p\) is primitive, \(a_t\ne0\), and the fixed-locus calculation
gives \(F(e_t)\ne0\).  Equation (1) restricts to

\[
h(v)^2=F(e_t)a_t(v)^4\ne0.
\]

Thus no reflection-line equation divides \(h\), and

\[
\gcd(X,h)=1. \tag{4}
\]

It remains to retain the multiplicities in \(h\mid J_p\).  Let \(r\) be
an irreducible factor of \(h\), of multiplicity \(m\).  At the generic
point of \(r=0\), the three \(p_i\) do not vanish simultaneously, by
primitivity, and \(p\) lies on the smooth quartic \(F=0\).  After
permuting coordinates, \(F_{u_0}(p)\) is a unit in the corresponding
discrete valuation ring.  The chain rule gives

\[
F_{u_0}(p)J_p
=\pm\det D\bigl(F(p),p_1,p_2\bigr)
=\pm\det D\bigl(h^2,p_1,p_2\bigr).
\]

Every entry in the first row on the right is divisible by
\(r^{\,2m-1}\).  Therefore

\[
v_r(J_p)\ge 2m-1\ge m.
\]

This proves \(h\mid J_p\), with multiplicities.  Combining this with
(3) and (4) yields

\[
Xh\mid J_p.
\]

Comparing degrees gives

\[
3(d-1)\ge21+2d,
\]

and hence

\[
\boxed{d\ge24}.
\]

More precisely,

\[
J_p=Xh\,k,\qquad \deg k=d-24.
\]

The quotient \(k\) is \(G\)-invariant; since its degree is even, the
classical invariant-ring decomposition places it in
\(\mathbf C[F,D,C]\).  At the first still-possible degree \(d=24\),
\(k\) must be a constant.  This Jacobian identity is a useful additional
equation for the remaining search, but it does not by itself exclude
\(d=24\) or higher even degrees.

It does immediately exclude \(d=26\).  In that degree \(k\) would be a
nonzero invariant of degree \(2\), but
\(\mathbf C[V]^G=\mathbf C[F,D,C,X]\) has no degree-two piece.  Thus,
after the separate exact degree-24 exclusion, the first degree left open
by the structural argument alone is \(d=28\).  The separate exact
[degree-28 certificate](WP3_DEGREE28_EXCLUSION.md) excludes that space as
well.  The subsequent exact
[degree-30](WP3_DEGREE30_EXCLUSION.md) and
[degree-32](WP3_DEGREE32_EXCLUSION.md) certificates exclude the next two
spaces, so the bounded frontier recorded here is superseded by the all-degree path obstruction; see WP3_ALL_DEGREE_PATH_OBSTRUCTION.md.

## 6. Replay boundary

No floating-point or probabilistic calculation enters this argument.  Its
exact computational inputs can be replayed with

    python3 certificates/wp1_fixed_loci.py

This verifies the Klein action, the involution eigenspaces, the smooth
genus-one fixed component, and \(F|_{E_+}\ne0\).  The same exact
168-element multiplication table gives: the centralizer of the chosen
\(J\) has eight elements; two have order four and square to \(J\); and
its commutator subgroup is \(\{1,J\}\).
