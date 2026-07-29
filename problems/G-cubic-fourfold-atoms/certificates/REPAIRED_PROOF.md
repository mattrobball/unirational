# Theorem 6.8 — repaired proof certificate

**Date:** 2026-07-29  
**Target:** Katzarkov–Kontsevich–Pantev–Yu (KKPY), *Birational
Invariants from Hodge Structures and Quantum Multiplication*, arXiv:2508.05105v2,
Theorem 6.8, printed pp. 69–71.  
**Repair verdict:** **R1–R5 repaired.** The main R2 lemma is proved below.
Its atom-localization conclusion is stated in the pointwise form actually
needed by the proof; a stronger global-cluster assertion is false in general
and is neither used nor certified.

This is a proof certificate relative to the exact external interfaces listed
below. It repairs the five defects in the printed proof; it does not re-prove
the construction of analytic A-model F-bundles, the global atom equivalence,
or the blowup theorem from their foundations.

## 1. Repaired statement

Let \(\mathcal C\) be the moduli space of smooth complex cubic fourfolds.
There is a countable collection of proper closed algebraic divisors
\(\{\mathcal C[K]\}\) such that every smooth cubic fourfold

\[
X\in \mathcal C\setminus\bigcup_K\mathcal C[K]
\]

is not rational. In particular, a very general smooth cubic fourfold is not
rational.

Here “very general” has its standard literal meaning: outside a countable
union of proper closed algebraic subsets.

## 2. Source control and formalization interface

The audited KKPY artifact and the three locally pinned auxiliary sources
have these SHA-256 digests:

```text
2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64  tmp/pdfs/2508.05105v2.pdf
a11a093f790890804c7d4f7559b30ed2a6da87811de46f2aa0d29026e343e6bd  tmp/pdfs/2411.02266.pdf
51f9c99621b3819aa85894a8cdee4a528b0894364fc22b40a651f1bae55ceed3  tmp/pdfs/peters-surface.pdf
985248cc3e6e166b9847b01552de2034429a624794dc0c53cad50beb1f4b50c9  tmp/pdfs/givental-eqv.pdf
```

The primary PDF is linked
[`here`](../tmp/pdfs/2508.05105v2.pdf).

The following are the exact imported interfaces. An eventual formalization
may replace each row independently.

| ID | Imported statement | Exact source and use |
|---|---|---|
| A1 | The analytic A-model F-bundle \((\mathcal H,\nabla)/B_X\) is maximal on the full base, and its quantum product, Euler field, and connection are Hodge-equivariant. | KKPY Definition 3.32, printed p. 31; Proposition 3.40, pp. 35–36; Definition 3.52, p. 42. |
| A2 | For multiplication by a group-fixed element in a finite-dimensional unital commutative superalgebra, the reduced spectrum on the whole algebra equals the reduced spectrum on its invariant subalgebra. | KKPY Lemma 5.19, printed p. 57. |
| A3 | A maximal non-archimedean F-bundle splits locally along invariant blocks having disjoint spectra. | KKPY Theorem 4.1, printed p. 43, citing Hinault–Yu–Zhang–Zhang (HYZZ), [Theorem 1.2/3.42](https://arxiv.org/abs/2411.02266), printed pp. 3 and 27–28. HYZZ Lemma 3.25 and Propositions 3.26, 3.29 provide the separated-block linear algebra used below. |
| A4 | On ambient cohomology of a cubic fourfold, quantum multiplication by the Euler field at the small base is the displayed matrix \(K(q)\). | KKPY Example 6.6(iii), printed pp. 68–69. Its input is Givental, [*Equivariant Gromov–Witten invariants*](https://arxiv.org/abs/alg-geom/9603021): Corollary 6.4, printed pp. 17–18, identifies the hypergeometric series with a horizontal quantum-connection section; Section 9, Theorem 9.1 and Corollary 9.2, printed p. 27, give the formula and differential equation (the hypothesis is \(3<5\)). |
| A5 | Local Hodge atoms are connected components of the unramified reduced spectral cover; each component is used as a covering of \(U_X\), and a point on it determines a geometric atomic F-bundle. The elementary equivalences defining global \(G\)-atoms identify the corresponding point-local geometric atomic F-bundles, so their fiber representation and Hodge polynomial descend to the global atom class. | KKPY Definition 5.10, printed p. 51; Definition 5.21 and Proposition 5.22, pp. 59–60; Definition 5.26, p. 62; Remark 5.29, p. 63. The representation is formulated below using the tautological generalized-eigenbundle on the cover itself. This removes the degree-\(>1\) ambiguity in the \(U_X\)-subbundle wording preceding Definition 5.26, and its local constancy is proved in Lemma 3.1 rather than delegated to KKPY Proposition 5.23. |
| A6 | Chemical formulas are additive under point blowup; a connected smooth projective variety with nef canonical class has one Hodge atom. | KKPY Section 5.2.6.2, additivity item (2), printed p. 55; Lemma 5.24, p. 61. For a surface point blowup, the center has codimension two, so exactly one point atom is added. |
| A7 | An atom of a fourfold which cannot occur in dimensions \(\le2\) obstructs rationality. | KKPY Proposition 5.30, printed p. 63. |
| A8 | Special cubic fourfolds form a countable union of irreducible algebraic divisors. | Hassett, [*Special Cubic Fourfolds*](https://www.math.brown.edu/bhassett/papers/cubics/cubic.pdf), Compos. Math. 120 (2000), Theorem 3.1.2, printed pp. 6–7. Theorem 3.2.3, printed p. 8, says that each discriminant-indexed \(\mathcal C_d\) is irreducible (possibly empty); Theorem 4.3.1, printed p. 11, gives the exact nonemptiness condition \(d>6\) and \(d\equiv0,2\pmod6\). |
| A9 | For a smooth projective surface, \(P_1=p_g\); positive plurigenera are birational invariants; a surface with a positive plurigenus has a minimal model, and on a minimal such surface the canonical class is nef. | Peters, [*An Introduction to the Theory of Compact Complex Surfaces*](../tmp/pdfs/peters-surface.pdf): the definitions of \(p_g=h^{0,2}\) and \(P_m=h^0(K_S^{\otimes m})\), printed pp. 5 and 7, together with Serre duality, Theorem 4.3, printed p. 12, give \(P_1=p_g\); Propositions 2.1 and 2.2 and the discussion immediately following Proposition 2.2, printed pp. 8–9, give the remaining assertions. |
| A10 | Finite-dimensional representations of a proreductive group in characteristic zero are semisimple. | Milne, [*Tannakian Categories*](https://www.jmilne.org/math/xnotes/tc.pdf), Proposition 2.23 and Remark 2.28, printed pp. 26–28. Exactness of invariants and the base-change statement in Lemma 3.1 are then proved below. |

The “component is a covering of \(U_X\)” clause in A5 is used literally:
it includes surjectivity. Density of \(U_X\) alone would not imply that every
spectral-cover component meets a chosen neighborhood.

## 3. Two repair lemmas

### Lemma 3.1 — invariants, base change, and constant invariant rank

Let \(F\) be a characteristic-zero field, \(G/F\) a proreductive algebraic
group, and \(V\) a finite-dimensional \(G\)-representation.

1. The functor \(V\mapsto V^G\) is exact.
2. For every field extension \(F'/F\),
   \((V^G)\otimes_FF'\cong(V\otimes_FF')^{G_{F'}}\).
3. If \(\mathcal A\) is a \(G\)-stable vector subbundle of the constant
   bundle \(V\otimes\mathcal O_T\), then \(\mathcal A^G\) is a direct-summand
   vector subbundle. Its rank is locally constant, hence constant when
   \(T\) is connected.
4. Over an algebraically closed extension, the isomorphism type of the
   \(G\)-representation \(\mathcal A_t\) is locally constant on \(T\).

**Proof.** The action on \(V\), and on every finite collection of
representations under discussion, factors through a finite-dimensional
reductive quotient \(G_0\). In characteristic zero, finite-dimensional
\(G_0\)-representations are semisimple. Thus every short exact sequence
splits equivariantly, proving exactness of invariants. The trivial isotypic
summand is preserved by extension of scalars, proving (2). The corresponding
Reynolds projector acts fiberwise on \(\mathcal A\); its image is
\(\mathcal A^G\), a direct summand whose rank is locally constant. Finally,
only finitely many irreducible \(G_0\)-types occur in \(V\). Their
multiplicities in \(\mathcal A_t\) are the ranks of the direct-summand
bundles \(\operatorname{Hom}_{G_0}(W,\mathcal A)\), so those multiplicities
are locally constant. This proves (4). If \(F\) is algebraically closed and
\(F'/F\) is an algebraically closed extension, the irreducible types in
\(V_{F'}\) are scalar extensions of those in \(V\); hence the resulting
abstract representation type has a model over \(F\). This is the case
\(F=\overline{\mathbf Q}\), \(F'=\mathbb K\) used below. ∎

### Lemma 3.2 — equivariant restriction of separated spectral factors (R2)

Let \(\mathbb K\) be an algebraically closed non-archimedean field of
characteristic zero, let \(G\) be proreductive, and let
\((\mathcal H,\nabla)/B\) be a \(G\)-equivariant F-bundle which is maximal
at a smooth rigid point \(b\in B^G\). Suppose

\[
\mathcal H_{(b,0)}=\bigoplus_{\lambda\in\Lambda}H_b^\lambda
\]

is the primary decomposition of \(\kappa_b\) into finitely many spectral
clusters, and distinct clusters have disjoint spectra. Then, after shrinking
the germ of \(B\) at \(b\):

1. the HYZZ decomposition on the full base is canonical among F-bundle
   decompositions lifting these primary blocks;
2. its summands and tangent distributions are \(G\)-equivariant;
3. its pullback to \(B^G\) is a direct-sum decomposition of the restricted
   F-bundle, with
   \[
   (H_b^\lambda)^G=(\mathcal H_{(b,0)}^G)^\lambda;
   \]
4. if \(C_\alpha\to U_X\) is an atom component in the sense of A5 and a
   fixed-locus neighborhood \(W\) meets \(U_X\), then \(C_\alpha\) has a
   point above \(W\cap U_X\). The atomic germ at such a point belongs to
   one local cluster \(\lambda(\alpha)\), and
   \[
   \rho_\alpha\le
   \operatorname{rank}(\mathcal H^\lambda_{u=0})^G.
   \]

The pulled-back factors in (3) need not be maximal over \(B^G\); maximality
is neither asserted nor needed after restriction.

**Proof.**

**(1) Apply the theorem only where maximality holds.** HYZZ Theorem 3.42
applies to the full germ \((B,b)\), not to \(B^G\), and produces an
F-bundle decomposition extending the displayed primary decomposition.

We now prove the canonicity that is needed for equivariance. At \(u=0\),
the cluster subbundles are the images of the unique primary idempotents of
\(\kappa\); locally these idempotents are obtained by the Chinese remainder
theorem from the pairwise coprime cluster factors of the minimal polynomial.
Suppose \(e\) and \(e'\) are the projection idempotents for two F-bundle
splittings that lift the same cluster. Both commute with the connection and
have the same reduction \(e_0\) modulo \(u\). Put \(d=e-e'\). In a local
trivialization write

\[
\nabla_{\partial_u}=\partial_u+u^{-2}U(u),\qquad U(u)=U_0+uU_1+\cdots .
\]

If \(d=u^m d_m+O(u^{m+1})\) with \(m\ge1\) minimal, the coefficient of
\(u^m\) in

\[
u^2\partial_ud+[U,d]=0
\]

is \([U_0,d_m]=0\). Disjoint cluster spectra imply that \(d_m\) is block
diagonal (equivalently, the off-diagonal Sylvester maps are invertible;
compare HYZZ Lemma 3.25). On the other hand, subtracting \(e^2=e\) and
\((e')^2=e'\), and taking the first nonzero \(u\)-coefficient, gives

\[
e_0d_m+d_me_0=d_m.
\]

For block-diagonal \(d_m\), this reads \(2d_m=d_m\) on the selected block
and \(0=d_m\) on every other block. Hence \(d_m=0\), a contradiction.
Thus \(e=e'\). Maximality identifies these canonical bundle blocks with
canonical tangent distributions, so the corresponding product germs are
canonical as well.

**(2) Equivariance.** The point \(b\), the connection, and \(\kappa_b\) are
\(G\)-fixed/equivariant. The fiberwise primary projector for a cluster is a
polynomial in \(\kappa_b\), so it is \(G\)-equivariant. A group element
therefore sends the lifted splitting to another splitting with the same
initial primary projectors. Uniqueness from (1) makes every summand and
tangent distribution \(G\)-equivariant.

**(3) Invariants and restriction.** Pull the full-base decomposition back
along \(B^G\hookrightarrow B\). This preserves direct sums and connections.
For a cluster projector \(p_\lambda(\kappa_b)\),

\[
\begin{aligned}
(H_b^\lambda)^G
 &=p_\lambda(\kappa_b)(\mathcal H_{(b,0)})\cap
   \mathcal H_{(b,0)}^G\\
 &=p_\lambda(\kappa_b)(\mathcal H_{(b,0)}^G)
  = (\mathcal H_{(b,0)}^G)^\lambda.
\end{aligned}
\]

The middle equality follows directly from equivariance of the projector;
Lemma 3.1 also shows that taking invariants preserves the whole direct-sum
decomposition and commutes with the scalar extensions used in Definition
5.26.

**(4) Pointwise atom localization.** Let \(\pi:C_\alpha\to U_X\) be the
component cover and let \(\ell_\alpha\in\mathcal O(C_\alpha)\) be its
tautological eigenvalue. On \(C_\alpha\), define the cover-native
generalized-eigenbundle

\[
\mathcal A_\alpha
=\ker\bigl((\pi^*\kappa-\ell_\alpha)^N\bigr),
\qquad N=\operatorname{rank}\mathcal H.
\]

Over the unramified locus this is a vector subbundle of
\(\pi^*\mathcal H_{u=0}\). It is \(G\)-stable because \(\kappa\) and the
tautological spectral equation are equivariant. Lemma 3.1 shows that its
fiber representation and invariant dimension are constant on the connected
space \(C_\alpha\). We take any fiber of \(\mathcal A_\alpha\) as the
representation \(E^\alpha\); this is exactly the point-fiber formulation in
Definition 5.21, Proposition 5.22, and Remark 5.29.

Now let \(W\) be the fixed-locus part of the neighborhood from (1), shrunk
to the connected component containing \(b\). Since \(U_X\) is dense,
\(W\cap U_X\ne\varnothing\).
By A5, \(C_\alpha\to U_X\) is a covering and therefore is surjective; hence
\(C_\alpha\) has a point \(x\) above \(W\cap U_X\). The spectral germ at
\(x\) lies in exactly one of the disjoint local cluster factors. The atomic
subbundle at \(x\) is consequently a \(G\)-stable direct factor inside that
cluster. Proposition 5.22 and A5 identify this fiber representation with
the representation of the global atom \(\alpha\). Lemma 3.1, including
scalar extension and constant invariant rank on connected \(W\), gives

\[
\rho_\alpha
=\dim_{\mathbb K}(\mathcal A_{\alpha,x})^G
\le \dim_{\mathbb K}(\mathcal H^\lambda_{(\pi(x),0)})^G
=\dim_{\mathbb K}(\mathcal H^\lambda_{(b,0)})^G
=\dim_{\mathbb K}(\mathcal H_{(b,0)}^G)^\lambda.
\]

This is the stated rank bound. ∎

**Sharp boundary of step (4).** One must not strengthen the conclusion to
say that a global connected component \(C_\alpha\) has one cluster label over
all of \(W\). Its pullback to \(W\) can be disconnected. The standard cover
\(z^2=t\) over \(\mathbf G_m\) is connected, while over a small neighborhood
of \(t=1\) it splits into the two local branches near \(z=\pm1\). The
pointwise statement above is all that Theorem 6.8 uses; moreover every cubic
cluster has invariant rank at most two, so the choice of local branch cannot
affect the final bound. Correspondingly, when \(\deg(C_\alpha/U_X)>1\), the
phrase before KKPY Definition 5.26 describing a subbundle on \(U_X\) “from
the eigenvalues parametrized by” \(C_\alpha\) cannot be read as a pushforward
sum: that sum can have larger invariant rank. The cover-native bundle
\(\mathcal A_\alpha\) is the precise formulation compatible with the
single-point fiber in KKPY Remark 5.29.

## 4. Repaired proof

Let \(X\) be a Noether–Lefschetz-general smooth cubic fourfold: its rational
Hodge classes are precisely the powers of the hyperplane class
\(h=c_1(\mathcal O_X(1))\). Its odd cohomology vanishes, its total even
cohomology has dimension \(27\), and

\[
\mathcal H_{(b,0)}^{\mathsf{Hod}}
=\bigoplus_{i=0}^4\mathbb K h^i.
\]

Let \((\mathcal H,\nabla)/B_X\) be the full maximal analytic A-model
F-bundle from A1.

### R1 — choose an admissible base point and recompute the spectrum

**Before (KKPY p. 69):** “Let \(b\in B_X\) be the rigid point with
coordinates \(q=1\), and \(t_i=0\)”; later the proof uses
“\(\mathbf K|_{q=1}\).”

**After:** Fix \(a\in\mathbf Q_{>0}\), put

\[
q_0=\boldsymbol y^a\in\mathbb K,
\qquad t_i=0,
\]

where \(\mathbb K\) is KKPY's algebraically closed non-archimedean field of
Puiseux series. Let \(b\) be this rigid point. Its valuation is the positive ample class
\(a h\), so \(b\in B_{X,q}\subset B_X\). The point is fixed by the Hodge
group because the Novikov direction is algebraic and all \(t_i\) vanish.

On the ambient invariant basis \((1,h,h^2,h^3,h^4)\), A4 gives

\[
K(q)=3\begin{pmatrix}
0&0&6q&0&0\\
1&0&0&15q&0\\
0&1&0&0&6q\\
0&0&1&0&0\\
0&0&0&1&0
\end{pmatrix}.
\]

A direct determinant calculation gives

\[
\det(\lambda I-K(q))
=\lambda^2(\lambda^3-3^6q).
\]

Thus at \(q=q_0\) the four spectral clusters are

\[
\Lambda=\{0, 9q_0^{1/3}, 9q_0^{1/3}\zeta,
9q_0^{1/3}\zeta^2\},
\]

where \(q_0^{1/3}=\boldsymbol y^{a/3}\) and \(\zeta\) is a primitive cube
root of unity. The generalized eigenspace dimensions on the invariant
ambient subspace are respectively

\[
2, 1, 1, 1.
\]

Lemma 5.19 (A2) identifies this set with the reduced spectrum of
\(\kappa_b=\operatorname{Eu}_b\star(-)\) on all of
\(\mathcal H_{(b,0)}\). All subsequent specializations in this proof are at
\(q_0\), never at \(q=1\).

### R2 — decompose the full maximal bundle, then restrict equivariantly

**Before (KKPY p. 70):** “By the spectral decomposition theorem Theorem
4.1 … the A-model F-bundle \((\mathcal H,\nabla)/B_X^{\mathsf{Hod}}\)
decomposes into an external direct sum of maximal F-bundles.”

**After:** Apply Lemma 3.2 with \(G=\mathsf{Hod}\) to the full bundle over
\(B_X\). Its hypotheses hold as follows.

1. By A1, the full bundle is maximal at \(b\); \(B_X\) is smooth there.
2. The primary generalized-eigenspace blocks of \(\kappa_b\) indexed by
   \(\Lambda\) have pairwise disjoint spectra.
3. The point \(b\), \(\kappa\), and the connection are Hodge-equivariant.
4. Lemma 3.2 proves canonicity and equivariance of the four full-base
   factors and pulls them back to a decomposition over
   \(B_X^{\mathsf{Hod}}\). It does **not** call the restricted factors
   maximal.
5. For every atom component, its tautological eigenbundle on the component
   has constant Hodge-representation type, and A5 plus Lemma 3.2 provide a
   representative local atomic germ in one of the four clusters.

At the repaired point, the compatibility with invariants is

\[
(H_b^\lambda)^{\mathsf{Hod}}
=(\mathcal H_{(b,0)}^{\mathsf{Hod}})^\lambda
=\left(\bigoplus_{i=0}^4\mathbb K h^i\right)^\lambda.
\]

This is the conclusion the printed proof needed from its invalid application
of Theorem 4.1.

### R3 — use the cluster containing the atom

**Before (KKPY p. 70):** the proof bounds an atom by
“\(\min_{\lambda}\operatorname{rank}(\mathcal H^\lambda_{u=0})^{\mathsf{Hod}}\).”

**After:** If \(\alpha\) is a Hodge atom of \(X\), choose the local cluster
\(\lambda(\alpha)\) supplied by R2. Then

\[
\rho_\alpha
\le
\dim_{\mathbb K}
\left(\bigoplus_{i=0}^4\mathbb K h^i\right)^{\lambda(\alpha)}
\le2.
\]

The three nonzero clusters contribute one invariant dimension each, while
the zero cluster contributes two. No minimum over unrelated clusters is
taken.

The primitive middle Hodge row is

\[
(h^{4,0}_{\rm prim},h^{3,1}_{\rm prim},h^{2,2}_{\rm prim},
h^{1,3}_{\rm prim},h^{0,4}_{\rm prim})=(0,1,20,1,0).
\]

Compatibility of the atomic composition with Hochschild grading, together
with nonnegativity of the coefficients in Definition 5.26, therefore gives
an atom \(\alpha\) with

\[
\operatorname{Coeff}_{t^2}P_\alpha(t)=1,
\qquad \rho_\alpha\le2.
\]

### R5 — pass to the minimal model; do not classify surfaces

**Before (KKPY p. 71):** “\(S\) must be either an abelian surface, a K3
surface, an elliptic surface with \(\kappa=1\) and \(p_g=1\), or a surface
of general type. But every such surface has a nef \(K_S\).”

**After:** The atom \(\alpha\) cannot occur in a point or a curve, because
their Hodge structures have no \(p-q=2\) part. Suppose it occurs in the
atomic composition of a connected smooth projective surface \(S\). Then

\[
1=\operatorname{Coeff}_{t^2}P_\alpha(t)\le p_g(S),
\]

so \(P_1(S)=p_g(S)>0\), and hence \(\kappa(S)\ge0\) by definition. Contract
the \((-1)\)-curves to the minimal model \(S_{\min}\). By A9,
\(K_{S_{\min}}\) is nef.

Each contraction reversed is a point blowup. By A6, a point blowup adds
only the point atom, whose Hodge polynomial is \(1\). Since
\(\operatorname{Coeff}_{t^2}P_\alpha=1\), \(\alpha\) is not a point atom;
therefore it is already an atom of \(S_{\min}\). Lemma 5.24 says that the
atomic composition of \(S_{\min}\) has the single atom
\(\boldsymbol\eta(S_{\min})\). Consequently

\[
\alpha=\boldsymbol\eta(S_{\min}).
\]

The independent algebraic classes

\[
1\in H^0(S_{\min}),\qquad
c_1(L)\in H^2(S_{\min})\quad(L\text{ ample}),\qquad
[\mathrm{pt}]\in H^4(S_{\min})
\]

are Hodge-group invariants. Hence

\[
\rho_\alpha=\rho_{\boldsymbol\eta(S_{\min})}\ge3,
\]

contradicting R3. Thus \(\alpha\) cannot occur in any smooth projective
variety of dimension at most two. Proposition 5.30 (A7) implies that \(X\)
is not rational.

### R4 — supply the very-general quantifier

**Before (KKPY p. 69):** “Such cubic fourfolds exist e.g. by Voisin’s proof
of the Torelli theorem for cubic fourfolds.”

**After:** Hassett Theorem 3.1.2 (A8) states that every special cubic
fourfold lies in an irreducible algebraic divisor \(\mathcal C[K]\), and
the relevant integral rank-two lattices \(K\) form a countable set.
Therefore

\[
\mathcal C_{\rm special}=\bigcup_K\mathcal C[K]
\]

is a countable union of proper closed algebraic divisors. Outside this union,
the middle rational Hodge classes are generated by \(h^2\); weak Lefschetz
and Poincaré duality show in the other degrees that the only rational Hodge
classes are the remaining powers of \(h\). This is precisely the
Noether–Lefschetz generality used above. The repaired argument applies to
every point of this complement.

No further Torelli or transcendental-irreducibility locus is consumed by
Theorem 6.8. The irreducibility assertion used later in KKPY Corollary 6.12
is not an input to this theorem and adds no exceptional locus here. This
proves the stated very-general theorem. ∎

## 5. Consequential R1 substitutions after Theorem 6.8

Although they are not used in the proof above, consistency requires the same
base point in the immediate downstream statements:

- Lemma 6.11: \(\kappa_b\) refers to the point \(q=q_0\), \(t_i=0\).
- Corollary 6.12: the three nonzero eigenvalues become
  \(9q_0^{1/3}\), \(9q_0^{1/3}\zeta\), and
  \(9q_0^{1/3}\zeta^2\).
- The two occurrences of \(K|_{q=1}\) in that corollary’s proof become
  \(K(q_0)\).

## 6. Replay record

The finite computation can be replayed without any project code:

```sh
/opt/homebrew/bin/python3 -c 'import sympy as s; q,L=s.symbols("q L"); K=3*s.Matrix([[0,0,6*q,0,0],[1,0,0,15*q,0],[0,1,0,0,6*q],[0,0,1,0,0],[0,0,0,1,0]]); p=s.expand(K.charpoly(L).as_expr()); expected=L**2*(L**3-729*q); assert s.expand(p-expected)==0; print(p)'
```

Expected output:

```text
L**5 - 729*L**2*q
```

The source pins can be replayed with:

```sh
shasum -a 256 tmp/pdfs/2508.05105v2.pdf tmp/pdfs/2411.02266.pdf tmp/pdfs/peters-surface.pdf tmp/pdfs/givental-eqv.pdf
rg -n 'thm:cubic4|thm:K-decomposition|lem:Ginvariants|lem:nefK|prop:non-rational' tmp/sources/v2/brinv.tex
```

## 7. Certificate boundary

- R1, R3, R4, and R5 are closed by explicit substitutions and arguments.
- R2 is closed for Theorem 6.8 by Lemmas 3.1–3.2, including the
  cover-native definition of the atom representation.
- The stronger claim that one global spectral-cover component has one local
  cluster label is expressly not certified; it is false in general and
  unnecessary.
- A5–A7 remain pinned interfaces to KKPY’s global atom formalism. This
  certificate does not silently upgrade a separate foundational audit of
  those interfaces.
- No WP-1–WP-5 simplification, author contact, or Lean work is included.
