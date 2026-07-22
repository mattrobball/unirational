# Program limits: all divisor classes and arithmetic descent

## Scope

This note records three shortcuts that did not settle the question before the
tangent--residual construction in
[`../all_smooth_tangent_residual_theorem.md`](../all_smooth_tangent_residual_theorem.md).
That theorem now proves unirationality for every smooth member and bypasses
every limitation below.  The scope here is the independent audit of the
following strategies
for a smooth general

\[
X=X_{2,3}\subset \mathbf P^2_x\times\mathbf P^2_y:
\]

1. whether Enriques' criterion reduces unirationality to a bounded set of
   divisor classes, or in particular to degree-two multisections;
2. whether stable irrationality, the intermediate Jacobian, or unramified
   invariants can obstruct unirationality uniformly in every multisection
   degree; and
3. whether an arbitrary finite extension of \(K=\mathbf C(t)\) closes the
   arithmetic gap in the degree-eight construction.

The outcome is negative in all three cases.  The Enriques equivalence is
correct, but neither it nor period-index theory bounds the divisor class.  In
fact the standard torsion Galois unramified-cohomology groups that could
furnish an all-prime degree obstruction vanish on this smooth threefold.
Finally, an arbitrary finite extension of \(\mathbf C(t)\) does not by itself
complete the direct spread-out construction: that certificate needs a
rational function field \(\mathbf C(s)\), and producing such an extension is
itself a rational-multisection problem for the contact-curve fibration.  This
did not exclude another construction; the tangent--residual theorem is exactly
such an independent construction.

## 1. The Enriques equivalence is sound

Let \(\pi:X\to\mathbf P^2_y\) be the conic bundle.

If \(S\subset X\) is horizontal and its normalization is rational, then over
\(\mathbf C(S)\) the pullback of the generic conic has the tautological point.
It is therefore a projective line, so

\[
X\times_{\mathbf P^2_y}S\dashrightarrow S\times\mathbf P^1
\]

is birational.  Projection to \(X\) proves unirationality.

Conversely, suppose

\[
f:\mathbf P^3\dashrightarrow X
\]

is dominant.  The composite \(\pi f:\mathbf P^3\dashrightarrow\mathbf P^2\)
is dominant and has one-dimensional general fiber.  A general plane
\(H\simeq\mathbf P^2\subset\mathbf P^3\) meets that general fiber, so
\((\pi f)|_H\) is dominant.  If \(S=\overline{f(H)}\), then \(S\) is
horizontal and is dominated by \(H\).  In characteristic zero a unirational
surface is rational after resolution (Castelnuovo).  Thus the normalization
of \(S\) is rational.

Since \(X\) is smooth, \(S\) is a Cartier divisor.  Grothendieck--Lefschetz
and the restriction sequence give

\[
\operatorname{Pic}(X)=\mathbf ZH_x\oplus\mathbf ZH_y,
\qquad [S]=aH_x+bH_y,
\qquad a,b\geq0.
\]

For completeness, the signs can be read off without knowing the whole
effective cone.  Intersecting with a general conic fiber of \(\pi\) gives
\(2a\geq0\); intersecting with a general plane-cubic fiber of the other
projection gives \(3b\geq0\) (and gives zero if that projection does not
dominate).  Horizontality is equivalent to \(a\geq1\), and

\[
\deg(S/\mathbf P^2_y)=S\cdot[\text{conic fiber}]=2a.
\]

There is no defect in the equivalence used in `SPEC.md`.

## 2. What generic unirationality would imply about a divisor class

There is a useful boundedness statement, but it is existential rather than
effective.

Let \(\mathcal X\to B\) be the universal smooth family over the relevant open
of \(B=\mathbf P^{59}\).  If the geometric generic fiber is unirational, a
dominant rational map to it is defined after some finite extension of
\(\mathbf C(B)\).  After replacing \(B\) by a generically finite cover and
shrinking, the map spreads out.  Applying the general-plane construction
above produces a relative horizontal divisor.  Its class is locally constant,
and hence is one fixed pair

\[
(a,b),\qquad a\geq1, b\geq0.
\]

Equivalently, after a generically finite base change, some component of a
rational-map parameter space dominates a fixed component of the relative
Hilbert scheme of horizontal divisors of one Hilbert polynomial, and that
Hilbert component dominates \(B\).  Here rationality is carried by the
rational-map family; it is not being treated as a formal Hilbert-scheme
stratum.

The same conclusion follows if a nonempty Zariski open of complex fibers is
assumed unirational: rational maps and Hilbert polynomials form countably many
parameter spaces, and an irreducible variety over the uncountable field
\(\mathbf C\) is not covered by countably many proper closed subsets.

This does **not** provide a numerical bound on \((a,b)\).  It says that a
positive theorem has one finite certificate somewhere in the countable list;
it does not say where.  Consequently, exclusions in finitely many classes
cannot prove non-unirationality.

## 3. A rational multisection does not reduce to degree two

Put \(K=\mathbf C(\mathbf P^2_y)\) and let \(\alpha\in\operatorname{Br}(K)[2]\)
be the class of the generic conic.  A rational horizontal divisor of degree
\(2a\) supplies a degree-\(2a\) field extension \(L/K\) and a point of the
conic over \(L\), hence

\[
\operatorname{res}_{L/K}(\alpha)=0.
\]

Restriction--corestriction gives only

\[
2\mid[L:K].
\]

Here the displayed divisibility uses that the generic conic is nonsplit, so
that \(\alpha\) has order two; if it were split, there would already be a
rational section.  Restriction--corestriction does not produce a quadratic
intermediate field \(K\subset M\subset L\).
Even-degree extensions can be primitive (for example, covers with full
symmetric monodromy) and have no proper intermediate field.  The fact that
every conic has closed points of degree two does not help: the corresponding
quadratic splitting surface over \(\mathbf P^2_y\) need not be rational.
Rationality of the original degree-\(2a\) covering surface transfers to a
quadratic covering surface only if one constructs additional geometry, such
as a suitable intermediate quotient; field degree and period-index alone do
not do this.

Therefore even a complete nonexistence theorem for degree-two rational
multisections would not settle non-unirationality.  The April and June 2026
public announcements of the Ji--Diller--Riedl work say only that they study
degree-two rational multisections; they do not state a reduction of arbitrary
degree to degree two:

- <https://bicmr.pku.edu.cn/content/show/35-3877.html>
- <https://webhomes.maths.ed.ac.uk/cheltsov/obihiro/abstracts.pdf>

## 4. Ordinary unramified cohomology gives no all-class obstruction

For this particular smooth threefold one can determine the relevant groups
without a degeneration.

Let \(Y=\mathbf P^2\times\mathbf P^2\).  Since \(X\subset Y\) is a smooth
ample divisor of complex dimension three, the integral Lefschetz hyperplane
theorem gives

\[
H_2(X,\mathbf Z)\simeq H_2(Y,\mathbf Z)\simeq\mathbf Z^2.
\]

The same Lefschetz theorem gives
\(\pi_1(X)\simeq\pi_1(Y)=0\), so the positive-degree normalized unramified
group in degree one is zero as well.

The universal-coefficient sequence then shows that \(H^3(X,\mathbf Z)\) is
torsion-free: its possible torsion is
\(\operatorname{Ext}^1(H_2(X,\mathbf Z),\mathbf Z)=0\).

Also \(H^2(X,\mathcal O_X)=0\).  This follows directly from

\[
0\to\mathcal O_Y(-2,-3)\to\mathcal O_Y\to\mathcal O_X\to0,
\]

because \(\mathcal O_{\mathbf P^2}(-2)\) is acyclic.  The exponential
sequence therefore injects the cohomological analytic Brauer group
\(H^2(X_{\rm an},\mathcal O_X^*)_{\rm tors}\) into
\(H^3(X,\mathbf Z)_{\rm tors}=0\).  Over \(\mathbf C\), comparison identifies
the algebraic cohomological Brauer group with this torsion group.  Hence

\[
\boxed{\operatorname{Br}(X)=0.}
\]

The next possible invariant vanishes for a much more general reason.
Colliot-Th\'el\`ene and Voisin prove that for every smooth projective uniruled
complex threefold

\[
H^3_{\mathrm{nr}}(X,\mathbf Q/\mathbf Z(2))=0.
\]

See their Theorem 1.2:
<https://arxiv.org/abs/1005.2778>.  The result uses Voisin's integral Hodge
theorem for degree-four classes on uniruled threefolds:
<https://arxiv.org/abs/math/0412279>.

Finally, \(\mathbf C(X)\) has torsion cohomological dimension three, so there
are no higher torsion Galois-cohomology groups from which ordinary
unramified invariants could be drawn.  Thus, in the standard torsion Galois
unramified-cohomology range relevant to stable birational geometry, this
smooth \(X\) supplies no prime-order invariant of that kind.

This does not prove unirationality.  It proves that an attempted uniform
negative proof based on the ordinary Brauer group or higher ordinary
unramified cohomology cannot work here.

## 5. What the stable-irrationality degeneration does not say about map degree

A dominant generically finite rational map of degree \(N\) from a rational
threefold yields an \(N\)-decomposition of the diagonal.  Equivalently,
normalized unramified invariants are killed by \(N\): after resolving the map
\(f:Z\to X\), one has

\[
f_*f^*=N.
\]

The B\"ohning--Graf von Bothmer proof for even \(n\) uses a direct
Artin--Mumford-type degeneration with a nonzero two-torsion unramified Brauer
class.  The case relevant here, \(n=3\), is different: they degenerate

\[
H_{2,3}\rightsquigarrow H_{2,2}\cup H_{0,1}
\]

and use the Colliot-Th\'el\`ene--Totaro \(CH_0\) specialization lemma.  See
Sections 2--3 of <https://arxiv.org/abs/1605.03029>.  Their argument proves
that a very general \((2,3)\) member is not universally \(CH_0\)-trivial,
equivalently that the decomposition-of-diagonal certificate with coefficient
one fails.  The cited proof does **not** by itself show that an arbitrary
\(N\)-decomposition for this odd-degree family must satisfy \(2\mid N\); that
would require an additional \(N\)-specialization argument through the
reducible fiber.

Even where a direct Artin--Mumford specialization does apply, its explicitly
exhibited invariant is two-primary and can at most force evenness by that
invariant.  Such evenness would be completely compatible with the Enriques
certificate here: every horizontal divisor has degree \(2a\), and its
base-change construction gives a parametrization of even degree \(2a\).

There is an additional conceptual limitation.  The threefold \(X\) is
rationally connected, so \(CH_0(X)=\mathbf Z\).  Bloch--Srinivas already
implies the existence of

\[
M\Delta_X=M(X\times x)+Z,
\]

for some nonzero integer \(M\), with \(Z\) supported over a proper closed
subset of the first factor.  Thus existence of *some* multiple decomposition,
which is necessary for unirationality, is automatic independently of
unirationality.  The decomposition-of-diagonal proof used for this family
rules out coefficient \(1\), not all coefficients.

To contradict every possible unirational degree by specialization, one would
need a family of constraints with no common nonzero annihilator: for example,
divisibility by infinitely many primes, unbounded powers of one prime, or an
invariant of infinite exponent.  The explicitly exhibited Artin--Mumford
class in the degeneration method is two-primary; where the relevant
\(N\)-specialization argument applies, it supplies only evenness.  The cited
paper establishes no all-degree mechanism for this \((2,3)\) family, and the
standard ordinary unramified groups of the smooth fiber vanish as in Section
4.

## 6. Why the intermediate Jacobian remains silent

Suppose again that a resolution of a unirational map gives a generically
finite morphism

\[
f:Z\to X,
\qquad \deg f=N,
\]

where \(Z\) is obtained from \(\mathbf P^3\) by blowing up smooth centers.
Then

\[
f_*f^*=N\operatorname{id}:H^3(X,\mathbf Q)\to H^3(X,\mathbf Q).
\]

Consequently \(H^3(X,\mathbf Q)\) is a direct summand of
\(H^3(Z,\mathbf Q)\).  Blowup formulas express the latter as a direct sum of
\(H^1(C_i,\mathbf Q)(-1)\) for the curve centers \(C_i\).  Therefore the
intermediate Jacobian of \(X\) need only be an **isogeny factor** of a product
of Jacobians.

That disposes of the classical intermediate-Jacobian obstruction: every
complex abelian variety is an isogeny factor of a Jacobian.  Indeed, a
sufficiently ample smooth complete-intersection
curve in the abelian variety generates it, the induced map from its Jacobian
is surjective, and Poincar\'e complete reducibility splits it up to isogeny.
The principal-polarization product obstruction used for rationality is much
stronger and is not preserved in the required form under a generically finite
map.  The unirational cubic threefold is the standard warning.  This argument
does not purport to eliminate every conceivable refined cycle or polarization
constraint.

## 7. Finite base change in the degree-eight route

Let \(T=\mathbf P^1_t\), \(K=\mathbf C(T)\), and let \(C_Q/K\) denote the
admissible contact curve (ordered or unordered) in the degree-eight
construction.  After taking a proper model, a closed point of \(C_Q\) has a
finite residue extension

\[
L/K=\mathbf C(B)/\mathbf C(T),
\]

where \(B\to T\) is a finite cover by a smooth projective complex curve.
Such closed points exist after some finite extension whenever the admissible
open of the geometric contact curve is nonempty: choose a closed point of
that open, not merely a boundary point of a proper compactification.

Every field \(\mathbf C(B)\) is \(C_1\), so over \(L\) the final conic in the
CGM construction has a point.  This proves the relevant degree-eight surface
is \(L\)-unirational.  It does **not** by itself prove that the original
threefold over \(\mathbf C\) is unirational.  Spreading the parametrization
gives a rational-surface fibration over \(B\); its natural source is birational
to a projective-space bundle over \(B\), which is rational only when
\(B\simeq\mathbf P^1\).

Thus the direct spread-out certificate requires a base change of the special
form

\[
\boxed{L=\mathbf C(s),\qquad \mathbf C(t)\hookrightarrow\mathbf C(s)
\text{ finite}.}
\]

Equivalently, one needs a rational multisection
\(\mathbf P^1_s\to\mathscr C\) of a spread-out contact-curve fibration
\(\mathscr C\to\mathbf P^1_t\).  A closed point over a finite algebraic
extension gives a multisection \(B\), not necessarily a rational one.

This distinction cannot be removed by passing to a further rational finite
extension.  If \(g(B)>0\), an inclusion

\[
\mathbf C(B)\hookrightarrow\mathbf C(s)
\]

would induce a dominant morphism \(\mathbf P^1\to B\), impossible by
Riemann--Hurwitz.  Therefore the statement "the contact curve is
geometrically nonempty" is far weaker than the rational-base-change statement
needed by the construction.

Allowing \(\mathbf C(s)/\mathbf C(t)\) would indeed be enough for this route,
but proving that such an extension supplies an admissible contact point is
another rational-multisection problem.  It does not close the arithmetic gap;
it repackages it.  This argument concerns the direct spread of the CGM
certificate and does not rule out additional descent geometry that might use
a positive-genus extension in some different way.

## 8. Consequences for the current program

1. The equivalence between unirationality and a rational horizontal surface
   is correct.
2. If the general member is unirational, one fixed class \((a,b)\) occurs in
   a dominating rational-map/Hilbert family after finite parameter-base
   change, but no known argument bounds that class.
3. Degree-two searches, even if completed for every \(b\), do not exclude
   rational multisections of degree \(4,6,\ldots\).
4. The published stable-irrationality proof rules out coefficient one; it
   does not establish a divisibility obstruction for every possible
   unirational degree.  Its explicitly exhibited Artin--Mumford invariant is
   only two-primary in the cases where the direct specialization applies.
5. The ordinary Brauer and higher ordinary unramified-cohomology routes are
   unavailable on the smooth general threefold: the relevant groups vanish.
6. The direct degree-eight certificate needs a \(K\)-point or a point after a
   **rational** finite cover of \(\mathbf P^1_t\).  An arbitrary finite
   splitting field does not supply that certificate without additional
   descent geometry.

Accordingly, none of these routes could have supplied a resolution by itself.
The needed new positive construction is now the tangent-residual/Lattès
argument, which produces a rational horizontal surface for every smooth
member.  The finite divisor-class census and the existing stable-rationality
invariants still do not have comparable scope.
