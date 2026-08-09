# Audit of the equivariant minimal-class refinement

**Date:** 2026-08-08  
**Field:** \(\mathbf C\)  
**Group:** \(G=\operatorname {PSL}_2(\mathbf F_{11})\), \(|G|=660\)  
**Verdict:** the retraction forces an equivariant diagonal, but the proposed
primitive orbit-lattice obstruction has no proved bridge

Let \(X\) be the Klein cubic threefold, let

\[
 A=J(X),\qquad \gamma=\frac{\theta^4}{4!}\in H^8(A,\mathbf Z),
\]

and use the actual product presentation \(A\simeq E^5\),
\(E=\mathbf C/\mathbf Z[\nu]\), from Roulleau.  The sibling packet
`../DELTA1_MINIMAL_CLASS/` proves exactly that \(\gamma\) corresponds to the
integral Hermitian matrix

\[
 B=M^{-1}\in \operatorname {Herm}_5(\mathbf Z[\nu])
\tag{0.1}
\]

and is the class of an integral signed sum of elliptic subgroup curves.

This note audits the additional word *equivariant*.  Three different notions
must not be identified:

1. an invariant cohomology class which is algebraic;
2. a fixed element of \(CH_1(A)\);
3. an integral cycle represented by a sum of full \(G\)-orbits of a prescribed
   family of curves.

They agree after tensoring with \(\mathbf Q\) in the elementary averaging
step relevant here, but they need not agree integrally.

## 1. What a genuine rational \(G\)-retraction does force

Assume that there is a rational \(G\)-map

\[
 r:\mathbf P(W)\dashrightarrow X,
 \qquad r|_X=\operatorname {id}_X.
\tag{1.1}
\]

The action on \(X\) is generically free: it is faithful, and the union of the
fixed loci of the finitely many nonidentity elements is a proper closed
subset.

**Theorem 1.1.**  Hypothesis (1.1) implies that \(X\) has a
\(G\)-equivariant integral decomposition of the diagonal in the precise sense
of Kresch--Tschinkel, Definition 4.2.

**Proof.**  Let \(T/K\) be any \(G\)-torsor.  Twisting (1.1) gives

\[
 {}^T X\longrightarrow {}^T\mathbf P(W)\dashrightarrow {}^T X
\]

with composite the identity.  Since \(W\) is an honest linear
representation, \({}^T\mathbf P(W)\simeq\mathbf P^4_K\).  Hence every twist
\({}^T X\) is retract rational and therefore has an integral decomposition of
the diagonal.  Kresch--Tschinkel, Theorem 4.4, says that this all-torsors
condition is equivalent to a \(G\)-equivariant integral decomposition of the
diagonal of \(X\).  \(\square\)

This is stronger than the statement in the repository that mere
\(G\)-unirationality does not force an equivariant diagonal: the extra
left-inverse identity in (1.1) is essential.

Kresch--Tschinkel's \(CH_*^G\) is the Borel/Edidin--Graham equivariant Chow
group, not the fixed subgroup \(CH_*(X)^G\).  Evaluation on a fibre gives a
map from the former into the latter, but the paper does not identify the two.
In particular, an equivariant diagonal on \(X\) does not by notation alone
produce an equivariant cycle on the different variety \(J(X)\); that requires
an additional functorial Abel--Jacobi construction.

Forgetting equivariance in Theorem 1.1 gives an ordinary integral
decomposition.  Voisin's Theorem 4.1 and Corollary 4.4 therefore imply only
the established ordinary conclusion

\[
 \gamma\in \operatorname {cl}(CH_1(A)).
\tag{1.2}
\]

Neither Kresch--Tschinkel nor Voisin states an equivariant Abel--Jacobi
refinement which sends their equivariant diagonal to a primitive integral
fixed lift of \(\gamma\) in \(CH_1(A)^G\).  Voisin's proof chooses support
curves, correspondences, and reference points, and obtains equality (49) in
cohomology.  The Abel--Jacobi maps change by translations when the reference
points change.  This is harmless in cohomology, but it is not harmless in an
integral Chow group.  Thus

\[
 \boxed{\text{(1.1) }\Longrightarrow\gamma\text{ has a lift in }CH_1(A)^G}
\tag{1.3}
\]

is an additional theorem which is not supplied by either cited source.

## 2. The exact integral obstruction to a fixed Chow lift

Let

\[
 \Lambda=H^8(A,\mathbf Z)\cap H^{4,4}(A),
 \qquad \Lambda_{\rm alg}=\operatorname {cl}(CH_1(A))\subseteq\Lambda,
 \qquad K=CH_1(A)_{\mathrm{hom}}.
\]

By definition of \(\Lambda_{\rm alg}\), the cycle class map gives an exact
sequence of integral \(G\)-modules

\[
 0\longrightarrow K\longrightarrow CH_1(A)
 \xrightarrow{\operatorname {cl}}\Lambda_{\rm alg}\longrightarrow0.
\tag{2.1}
\]

Taking fixed subgroups begins the exact sequence

\[
 CH_1(A)^G\longrightarrow\Lambda_{\rm alg}^G
 \xrightarrow{\partial}H^1(G,K).
\tag{2.2}
\]

If \(z\in CH_1(A)\) satisfies \(\operatorname {cl}(z)=\gamma\), then
\(\partial(\gamma)\) is represented by the cocycle

\[
 g\longmapsto g_*z-z.
\tag{2.3}
\]

Consequently, \(\gamma\) has an integral fixed Chow lift if and only if
\(\partial(\gamma)=0\).  This obstruction lies in the homologically trivial
Chow group, not in the Hermitian lattice.

What follows without any new theorem is the norm statement

\[
 N_G(z)=\sum_{g\in G}g_*z\in CH_1(A)^G,
 \qquad \operatorname {cl}(N_G(z))=660\gamma.
\tag{2.4}
\]

Thus \(660\gamma\) has an integral fixed lift and \(\gamma\) has a fixed
\(\mathbf Q\)-cycle lift.  Division by \(660\) is not legitimate in integral
Chow.  Equivalently, (2.4) only shows that \(\partial(\gamma)\) is
\(660\)-torsion.

## 3. The invariant Hermitian lattice is already exhausted

The analytic \(G\)-representation on the tangent space of \(A\) is the
irreducible five-dimensional Klein representation.  If
\(P\in\operatorname {GL}_5(\mathbf Z[\nu])\) is the matrix of an element of
\(G\), then

\[
 P^*MP=M,
 \qquad PBP^*=B.
\tag{3.1}
\]

**Theorem 3.1.**  Writing \(\gamma\) as \(B\) in the rational Hermitian
model,

\[
 \Lambda^G=\mathbf Z B.
\tag{3.2}
\]

**Proof.**  Rationally, Poincare duality identifies the invariant Hodge line
in degree eight with the dual of the invariant divisor line.  Equivalently,
if \(C\) is an invariant Hermitian matrix, then (3.1) implies that \(CM\)
commutes with the irreducible complex representation of \(G\).  Schur's
lemma gives the rational invariant line \(\mathbf QB\).

The class \(\gamma\) is primitive in integral cohomology.  Indeed, in a
symplectic basis with \(\theta=\sum_{i=1}^5x_i\wedge y_i\), the expansion of
\(\theta^4/4!\) is the sum of the five monomials obtained by omitting one
pair \(x_i\wedge y_i\), each with coefficient one.  Since \(B\) represents
\(\gamma\), the integral points of the invariant rational line are exactly
\(\mathbf ZB\).  \(\square\)

In particular, because \(B\) is algebraic, also
\(\Lambda_{\rm alg}^G=\mathbf ZB\).  Inside the smaller lattice generated by
elliptic subgroup curves, the same integral conclusion follows from the
explicit primitivity of \(B\) in \(\operatorname {Herm}_5(\mathbf Z[\nu])\)
(its diagonal coordinates include \(19\) and \(22\)).

Therefore any refinement which only asks for the invariant *cohomology*
class forced by a retraction has no obstruction to find: its primitive target
is \(B\), and \(B\) is already algebraic unconditionally.  A saturation
calculation inside \(\Lambda^G\) cannot see the boundary map (2.2).

For orientation, if \(C_a=a_*[E]\) is an elliptic subgroup curve and
\(q(a)=a^*Ma\), Schur averaging gives the exact identity

\[
 \sum_{g\in G}\operatorname {cl}(g_*C_a)
 =132q(a)B.
\tag{3.3}
\]

Indeed the left side is a scalar multiple \(cB\); pairing with \(M\) gives
\(5c=660q(a)\).  Formula (3.3) concerns the full norm, with stabilizer
multiplicities.  A sum over distinct orbit members divides by a stabilizer
and requires a separate stabilizer classification.

## 4. Why elliptic orbit sums are not an exhaustive target

Let \(\mathcal E\) be the free abelian group on the elliptic subgroup curves
\(C_a\subset E^5\), and put

\[
 L_{\mathcal E}:=\operatorname {cl}(\mathcal E)\subseteq\Lambda.
\tag{4.1}
\]

The rank-one Hermitian lemma identifies \(L_{\mathcal E}\) with the lattice
of integral Hermitian matrices and proves that it contains \(B\).  No claim
that this equals every integral Hodge class is needed here.

It does **not** prove

\[
 \operatorname {cl}(\mathcal E^G)=L_{\mathcal E}^G=\mathbf ZB.
\tag{4.2}
\]

Taking invariants is not an exact functor over \(\mathbf Z\).  The elementary
counterconfiguration is

\[
 \mathcal E_0=\mathbf Ze_0\oplus\mathbf Ze_1,
 \quad s(e_0)=e_1,
 \quad \Lambda_0=\mathbf Zb,
 \quad \operatorname {cl}(e_0)=\operatorname {cl}(e_1)=b.
\tag{4.3}
\]

Here \(\operatorname {cl}(\mathcal E_0)=\Lambda_0\) and
\(b\in\Lambda_0^G\), but

\[
 \operatorname {cl}(\mathcal E_0^G)=2\mathbf Zb.
\tag{4.4}
\]

This is precisely the integral orbit-sum gap which averaging cannot remove.

There is a second, geometric gap.  In Voisin's proof, the curves whose images
in \(J(X)\) yield the minimal class are Abel--Jacobi images of curves cut out
inside resolutions of the support divisor.  They are arbitrary curves; no
part of Theorem 3.1 or Theorem 4.1 makes them elliptic curves, subgroup
curves, or translates of subgroup curves.  Hence even a future proof of a
primitive fixed lift in \(CH_1(A)^G\) would not put that lift in
\(\mathcal E^G\) without a further reduction theorem.

## 5. Exact verdict and CAS boundary

The theorem-forced conclusions are:

1. a rational \(G\)-retraction forces the Kresch--Tschinkel equivariant
   integral diagonal;
2. after forgetting \(G\), it forces ordinary algebraicity of \(B\), which
   already holds unconditionally;
3. directly, integral averaging gives a fixed lift of \(660B\), not of
   \(B\);
4. a primitive fixed Chow lift is controlled by
   \(\partial(B)\in H^1(G,CH_1(A)_{\mathrm{hom}})\);
5. elliptic subgroup curves span the full Hermitian class lattice, but their
   integral orbit sums are not proved to exhaust either \(CH_1(A)^G\) or the
   cycles arising in Voisin's construction.

There is therefore no theorem-forced finite elliptic-orbit lattice whose
saturation or gcd decides the hypothetical retraction.  No such CAS
computation was run.  Computing it would decide only an auxiliary
elliptic-orbit ansatz, not the retraction obstruction.

```text
DELTA1-G-RETRACTION-IMPLIES-KT-EQUIVARIANT-DIAGONAL
DELTA1-INVARIANT-HERMITIAN-LATTICE-EQUALS-Z-TIMES-B
DELTA1-INTEGRAL-TRANSFER-GIVES-660-TIMES-MINIMAL-CLASS
DELTA1-PRIMITIVE-FIXED-CHOW-LIFT-NOT-FORCED-BY-CITED-THEOREMS
DELTA1-ELLIPTIC-ORBIT-EXHAUSTION-NOT-PROVED
DELTA1-ELLIPTIC-ORBIT-GCD-NOT-A-THEOREM-FORCED-TARGET
DELTA1-EQUIVARIANT-MINIMAL-CLASS-OBSTRUCTION-DOES-NOT-CLOSE-RETRACTION
```
