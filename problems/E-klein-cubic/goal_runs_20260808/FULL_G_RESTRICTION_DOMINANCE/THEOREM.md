# Full-group restriction dominance and the remaining degree gate

**Date:** 2026-08-08  
**Field:** \(\mathbf C\)  
**Group:** \(G=\operatorname{PSL}_2(\mathbf F_{11})\)  
**Verdict:** restriction dominance is proved; degree one is not proved

Let \(W\) be the faithful irreducible five-dimensional Klein
representation and let

\[
 X=V(F)\subset \mathbf P(W),\qquad
 F=x_0^2x_1+x_1^2x_2+x_2^2x_3+x_3^2x_4+x_4^2x_0,
\]

be the smooth Klein cubic threefold.  Suppose that

\[
 f:\mathbf P(W)\dashrightarrow X
 \tag{0.1}
\]

is a dominant \(G\)-equivariant rational map.

## 1. The restriction theorem

**Theorem 1.1.**  The rational restriction

\[
 \varphi=f|_X:X\dashrightarrow X
 \tag{1.1}
\]

is defined at the generic point of \(X\) and is dominant.  In particular,
it is generically finite of a positive degree

\[
 \delta=[\mathbf C(X):\varphi^*\mathbf C(X)]\geq 1.
 \tag{1.2}
\]

**Proof.**  Represent (0.1) by homogeneous forms of one degree,

\[
 f=[P_0:\cdots:P_4],
\]

and cancel their common polynomial gcd.  If all \(P_i\) vanished on \(X\),
then the irreducible cubic \(F\) would divide every \(P_i\), contrary to
primitivity.  Thus (1.1) is defined at the generic point.

Put

\[
 Y=\overline{\varphi(X)}\subset X.
\]

It is an irreducible \(G\)-stable subvariety.  It cannot be a point: a
constant equivariant map would have image in \(X^G\), while \(X^G\) is
empty.  Indeed, a fixed projective point would give a one-dimensional
\(G\)-subrepresentation of the irreducible five-dimensional representation
\(W\).

The kernel of the action on positive-dimensional \(Y\) is normal in the
simple group \(G\).  It cannot equal \(G\), since that would put every point
of \(Y\) in \(X^G\).  Hence \(G\) acts faithfully on \(Y\).

Now compose the projectivization map and the two dominant maps:

\[
 W\dashrightarrow\mathbf P(W)
   \overset{f}{\dashrightarrow}X
   \overset{\varphi}{\dashrightarrow}Y.
 \tag{1.3}
\]

This is a dominant \(G\)-equivariant rational map from a faithful linear
representation to a faithful \(G\)-variety.  Thus \(Y\) is a compression in
the definition of essential dimension, and

\[
 \operatorname{ed}_{\mathbf C}(G)\leq\dim Y.
 \tag{1.4}
\]

Duncan--Reichstein record the unconditional lower bound
\(\operatorname{ed}_{\mathbf C}(G)\geq3\), deriving it from the fact that
\(G\) cannot act faithfully on a unirational surface.  Hence
\(\dim Y\geq3\).  Since \(Y\subset X\) and \(\dim X=3\), one has \(Y=X\).
This proves the theorem. \(\square\)

The use of the **full simple group** is essential here.  For a proper
subgroup, the kernel dichotomy and the essential-dimension lower bound need
not survive; this theorem does not upgrade the earlier subgroup restriction
audits.

## 2. Resolution and base-locus form of the conclusion

Resolve the ambient map equivariantly:

\[
 \pi:Z\longrightarrow\mathbf P(W),\qquad q:Z\longrightarrow X.
\]

Let \(\Gamma\) be the generic curve fibre of \(q\), put
\(a=\pi^*H\cdot\Gamma\), and write

\[
 \pi^*X=\widetilde X+\sum_\nu c_\nu E_\nu.
\]

Only exceptional divisors which dominate the target meet the generic fibre.
Theorem 1.1 gives the exact positive intersection identity

\[
 \boxed{\quad
 \delta=\widetilde X\cdot\Gamma
       =3a-\sum_\nu c_\nu(E_\nu\cdot\Gamma)>0.
 \quad}
 \tag{2.1}
\]

Thus the full-group argument supplies the strict inequality that was absent
in the \(C_{11}\rtimes C_5\) restriction audit.  It supplies no equality
\(\delta=1\): horizontal exceptional multisections still determine the
positive integer on the right side of (2.1).

## 3. What degree one would give

**Corollary 3.1 (conditional retraction).**  If \(\delta=1\), then
\(\varphi\) is birational.  Full-\(G\) birational superrigidity makes it a
biregular \(G\)-equivariant automorphism.  Since
\(\operatorname{Aut}(X)=G\), this automorphism centralizes \(G\), and the
center of \(G\) is trivial.  Therefore

\[
 \varphi=\operatorname{id}_X.
\]

Consequently the original map itself is a rational \(G\)-equivariant
retraction:

\[
 f|_X=\operatorname{id}_X.
 \tag{3.1}
\]

More generally, even without identifying the centralizer, the map
\(\varphi^{-1}\circ f\) would be a rational retraction.

If \(\varphi\) is a morphism, Beauville's endomorphism theorem forces
\(\delta=1\), because a smooth hypersurface of degree greater than two and
dimension greater than one has no endomorphism of degree greater than one.
Hence the only surviving branch has a nonempty base locus on \(X\).

No contradiction is claimed from (3.1).  A rational retraction would imply
retract rationality of \(X\), but the audited sources do not provide a
retract-irrationality theorem for this special cubic.  The
Clemens--Griffiths irrationality theorem alone is not such a theorem.

## 4. Why the audited rigidity theorem stops at \(\delta>1\)

Cheltsov--Shramov and Cheltsov--Krylov--Ma'u prove that the Klein cubic is
\(G\)-birationally superrigid.  Their definition controls
\(G\)-**birational** maps to Mori fibre spaces and, in particular,
\(G\)-birational selfmaps.  If \(\delta>1\), the normalized graph of
\(\varphi\) is a generically finite cover of the target, not a birational
Mori regularization.  The theorem therefore has no degree-one conclusion in
this case.

Equivalently, pulling back hyperplanes gives a \(G\)-invariant movable
system on \(X\).  Superrigidity controls its maximal singularities, but the
degree formula still contains the base-center correction terms in (2.1).
Canonicity inequalities do not identify their sum with \(3a-1\).

This limitation is real even before equivariance.  Chen--Stapleton explicitly
note that every smooth cubic hypersurface of dimension at least two is
unirational and therefore has many rational endomorphisms.  Concretely, if
\(p\in X\) is general, projection from \(p\) gives a generically finite
degree-two rational map \(X\dashrightarrow\mathbf P^3\).  Composing it with
a classical dominant unirational parametrization
\(\mathbf P^3\dashrightarrow X\) gives a dominant rational selfmap of
\(X\) of degree greater than one.  This example is not asserted to be
\(G\)-equivariant or ambient-extendable; it shows that a theorem about
ordinary rational selfmaps of cubic threefolds cannot close the gate.  The
degree-congruence results in that paper concern very general hypersurfaces in
different numerical ranges and do not force degree one for this special
cubic.

## 5. Why an \(H^3\) or motive scalar need not be nonzero

For a resolution of \(\varphi\), write

\[
 p:T\longrightarrow X,\qquad q:T\longrightarrow X.
\]

The relation \(q_*q^*=\delta\operatorname{id}\) makes \(q^*H^3(X,\mathbf
Q)\) inject into \(H^3(T,\mathbf Q)\).  It does **not** force its projection
to the original summand \(p^*H^3(X,\mathbf Q)\) to be nonzero: blowups of
curve centers add summands \(H^1(C)(-1)\).

The existing `D_EQUIVARIANT_MOTIVE/BLOWUP_CLOSURE.md` packet gives an exact
full-\(G\) counterconfiguration to any invariant-only argument of this kind.
It embeds a free orbit of 660 genus-11 Prym curves in \(\mathbf P(W)\), blows
up their disjoint union, and reproduces \(H^3(X)\) as a rational
\(G\)-Hodge and Chow-motive summand of the exceptional contribution.  That
packet explicitly does **not** assert that these curves are the base locus
of a landing map.  Its precise consequence is that a proof must constrain
the actual landing base ideal; Schur's lemma or the abstract blowup motive
alone cannot force a nonzero original-factor action.

## 6. Ambient extendability and exact stop

Ambient extendability says more than the existence of an arbitrary rational
selfmap: the same primitive homogeneous tuple \((P_0,\ldots,P_4)\) is
defined on \(\mathbf P(W)\), is \(G\)-equivariant, is dominant onto \(X\),
and satisfies the polynomial landing identity

\[
 F(P_0,\ldots,P_4)=0.
 \tag{6.1}
\]

No audited theorem converts (6.1), equivariance, and (2.1) into
\(\delta=1\).  No finite degree sweep can supply an unconditional substitute:
the installed primitive quartic \(G\)-endomorphism
\(c:\mathbf P(W)\to\mathbf P(W)\) is finite and surjective, and
precomposition \(f\circ c^n\) preserves ambient landing and produces
coordinate degrees growing by \(4^n\).  This does not prove that the
restriction degrees grow, but it rules out treating a bounded coordinate
search as an all-degree decision.

The remaining theorem-level gate is therefore exactly:

> Prove that every full-\(G\), ambient-extendable dominant rational selfmap
> arising from (0.1) has \(\delta=1\), using the actual base ideal in
> (6.1); or construct one with \(\delta>1\).

Nothing in this packet decides that gate or the headline equivariant
unirationality problem.

```text
FULL-G-RESTRICTION-DEFINED-AT-GENERIC-POINT
FULL-G-RESTRICTION-DOMINANT
FULL-G-RESTRICTION-DEGREE-POSITIVE
FULL-G-DEGREE-ONE-IMPLIES-RATIONAL-RETRACTION
FULL-G-MORPHISM-BRANCH-DEGREE-ONE
FULL-G-AMBIENT-RATIONAL-DEGREE-GREATER-ONE-GATE-OPEN
FULL-G-GLOBAL-QUESTION-OPEN
```
