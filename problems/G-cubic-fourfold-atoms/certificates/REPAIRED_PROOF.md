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
the construction of analytic A-model F-bundles or the Hodge-compatible blowup
formula from their Gromov--Witten-theoretic foundations.

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

The audited KKPY artifact and the locally pinned auxiliary sources
have these SHA-256 digests:

```text
2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64  tmp/pdfs/2508.05105v2.pdf
a11a093f790890804c7d4f7559b30ed2a6da87811de46f2aa0d29026e343e6bd  tmp/pdfs/2411.02266.pdf
c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b  tmp/pdfs/2307.13555.pdf
0114923576b2ec3a78fc346fd9f61eb65cfe63f8cc7087881d11626cdb9883c3  tmp/pdfs/2604.10028v2.pdf
9d022796aefa01fd601820e415c5462bdfc255b3b4fe158af64b51f7bf0a83e3  tmp/pdfs/beauville-quantum-complete-intersections.pdf
51f9c99621b3819aa85894a8cdee4a528b0894364fc22b40a651f1bae55ceed3  tmp/pdfs/peters-surface.pdf
985248cc3e6e166b9847b01552de2034429a624794dc0c53cad50beb1f4b50c9  tmp/pdfs/givental-eqv.pdf
ecc2e31a63f56d443aaa3534f0218b25a5b6ab6e1a84c82db5c7bac1789a1d21  tmp/pdfs/hassett-special-cubic-fourfolds.pdf
```

The primary PDF is linked
[`here`](../tmp/pdfs/2508.05105v2.pdf).

The following are the exact imported interfaces. An eventual formalization
may replace each row independently.

| ID | Imported statement | Exact source and use |
|---|---|---|
| A1 | The analytic A-model F-bundle \((\mathcal H,\nabla)/B_X\) is maximal on the full base, and its quantum product, Euler field, and connection are Hodge-equivariant. The product satisfies the virtual-dimension grading and the genus-zero unit/fundamental-class axiom used in Lemma 3.6. | KKPY §3.5.1, virtual dimension and GW-class properties, printed pp. 22–23; Definition 3.25 and the unit-axiom paragraph, p. 29; Definition 3.32, p. 31; Proposition 3.40, pp. 35–36; Definition 3.52, p. 42. |
| A2 | For multiplication by a group-fixed element in a finite-dimensional unital commutative superalgebra, the reduced spectrum on the whole algebra equals the reduced spectrum on its invariant subalgebra. | KKPY Lemma 5.19, printed p. 57. |
| A3 | A maximal non-archimedean F-bundle splits locally along invariant blocks having disjoint spectra. Over a coefficient ring, an endomorphism whose commutator with the spectral operator is block diagonal is itself block diagonal. | KKPY Theorem 4.1, printed p. 43, citing Hinault–Yu–Zhang–Zhang (HYZZ), [Theorem 1.2/3.42](https://arxiv.org/abs/2411.02266), printed pp. 3 and 27–28. HYZZ Lemmas 3.25 and 3.28 and Propositions 3.26, 3.29, printed pp. 21–23, provide the separated-block linear algebra used below. |
| A4 | For a smooth cubic fourfold, the three degree-one ambient corrections to multiplication by \(h\) are the Grassmannian line-incidence numbers \(\ell_0,\ell_1,\ell_2\) in Lemma 3.5 below; the grading excludes higher-degree corrections. | Beauville, [*Quantum cohomology of complete intersections*](../tmp/pdfs/beauville-quantum-complete-intersections.pdf), equations (1.6) and (2.1) and the Grassmannian coefficient lemma, artifact pp. 2–7; local SHA-256 `9d022796aefa01fd601820e415c5462bdfc255b3b4fe158af64b51f7bf0a83e3`. Givental's pinned Corollaries 6.3–6.4 and Theorem 9.1/Corollary 9.2 supply an independent mirror-theorem check, but are no longer imported by this certificate. |
| A5 | The fixed base \(B_X^G\) is connected and smooth. Its maximal-distinct-eigenvalue locus \(U_X\) carries the finite étale reduced spectral cover \(\widetilde U_X\); local Hodge atoms are its connected components, each used as a surjective cover of \(U_X\), and a point on a component determines a geometric atomic F-bundle. Passing only through isomorphism, same-component transport, disjoint-union, and smooth-blowup correspondences defines the **blowup-Hodge atom** used in this certificate; its fiber representation and Hodge polynomial descend to that finer class. For the cubic in R2, \(U_X\) is open and dense in \(B_X^{\mathsf{Hod}}\). | KKPY §5.2.2 and Definition 5.10, printed p. 51; the disjoint-union and blowup equivalences in §5.2.6.2, pp. 54–55; Definition 5.21 and the corresponding parts of Proposition 5.22, pp. 59–60; Definition 5.26, p. 62; Remark 5.29, p. 63; proof of Theorem 6.8, p. 70 (density for the cubic). The representation is formulated below using the tautological generalized-eigenbundle on the cover itself. This removes the degree-\(>1\) ambiguity in the \(U_X\)-subbundle wording preceding Definition 5.26, and its local constancy is proved in Lemma 3.1 rather than delegated to KKPY Proposition 5.23. |
| A6 | The blowup-Hodge-atom formula \(\operatorname{CF}_{\rm bl}(\operatorname{Bl}_Z Y)=\operatorname{CF}_{\rm bl}(Y)+(r-1)\operatorname{CF}_{\rm bl}(Z)\), compatibly with Hodge representations and their \(p-q\) gradings, holds in the only two cases used here: (i) \(Y\) is a surface and \(Z\) is a point; (ii) \(Y\) is a smooth projective fourfold and \(Z\) is a smooth center of dimension at most two, with \(r=4-\dim Z\). | These are the corresponding special cases of KKPY Theorem 4.5 and §5.2.6.2, blowup item (2), printed pp. 43–47 and 55; proof of Proposition 5.22, blowup item (2), pp. 59–60. KKPY extracts the analytic statement from Iritani, [*Quantum cohomology of blowups*](../tmp/pdfs/2307.13555.pdf), Theorem 5.18, artifact pp. 58–59, SHA-256 `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`. Iritani, [*Notes on the decomposition theorem for blowups*](../tmp/pdfs/2604.10028v2.pdf), Proposition 8 and Corollary 11, artifact pp. 7 and 10, proves formal universal-Hodge equivariance; SHA-256 `0114923576b2ec3a78fc346fd9f61eb65cfe63f8cc7087881d11626cdb9883c3`. In case (i), exactly one point atom is added. |
| A7 | If a smooth projective complex fourfold \(X\) is birational to \(\mathbf P^4\), there is a finite weak factorization from \(\mathbf P^4\) to \(X\) through smooth projective complex fourfolds, each step or inverse step being a blowup in a smooth center. After identity blowups of Cartier divisors are deleted, the centers have codimension at least two and hence dimension at most two. | Abramovich–Karu–Matsuki–Włodarczyk, *Torification and factorization of birational maps*, Theorem 0.1.1, internal pp. 1–2; [local PDF](../tmp/pdfs/akmw-torification-factorization.pdf), SHA-256 `55bbc2c58f29d4b9dbe965035f80f3844f6968eaf98076ac625132ac3b3977a5`. Włodarczyk's independent smooth-complete proof is statement 0.0.1 and §12.4 of [*Toroidal varieties and the weak Factorization Theorem*](../tmp/pdfs/wlodarczyk-toroidal-weak-factorization.pdf), SHA-256 `2f7a0bce5871db86bf84f54c4562fc053c53a4313180a6eecb66587d21e4fcfe`; it cross-checks the weak theorem but not AKMW's projective-intermediate clause. The target-specific atom consequence is Proposition 3.7 below; KKPY Proposition 5.30 is not imported. |
| A8 | With \(A(X)=H^{2,2}(X)\cap H^4(X,\mathbf Z)\), special cubic fourfolds form a countable union of irreducible algebraic divisors. | Hassett, [*Special Cubic Fourfolds*](../tmp/pdfs/hassett-special-cubic-fourfolds.pdf), Compos. Math. 120 (2000): the \(A(X)\) paragraph immediately after Definition 3.1.1 and Theorem 3.1.2, artifact pp. 7–8. Theorem 3.2.3, artifact p. 9, gives irreducibility; the exclusions and Theorem 4.3.1, artifact p. 14, give nonemptiness, summarized as the exact condition \(d>6\), \(d\equiv0,2\pmod6\) in Theorem 1.0.1, artifact p. 2. Local SHA-256: `ecc2e31a63f56d443aaa3534f0218b25a5b6ab6e1a84c82db5c7bac1789a1d21`. |
| A9 | For a smooth projective surface, \(P_1=p_g\); positive plurigenera are birational invariants; a surface with a positive plurigenus has a minimal model, and on a minimal such surface the canonical class is nef. | Peters, [*An Introduction to the Theory of Compact Complex Surfaces*](../tmp/pdfs/peters-surface.pdf): the definitions of \(p_g=h^{0,2}\) and \(P_m=h^0(K_S^{\otimes m})\), printed pp. 5 and 7, together with Serre duality, Theorem 4.3, printed p. 12, give \(P_1=p_g\); Propositions 2.1 and 2.2 and the discussion immediately following Proposition 2.2, printed pp. 8–9, give the remaining assertions. |
| A10 | Finite-dimensional representations of a proreductive group in characteristic zero are semisimple. | Milne, [*Tannakian Categories*](https://www.jmilne.org/math/xnotes/tc.pdf), Proposition 2.23 and Remark 2.28, printed pp. 26–28. Exactness of invariants and the base-change statement in Lemma 3.1 are then proved below. |
| A11 | At \(b\in U_X\), \(\mathcal H_{(b,0)}\cong H_B^\bullet(X,\overline{\mathbf Q})\otimes_{\overline{\mathbf Q}}\mathbb K\) as a Hodge representation, and this full fiber is the direct sum of geometric atomic factors indexed by the points of \(\widetilde U_{X,b}\). A component occurs with its cover degree, and its polynomial records the dimensions in Hochschild degree \(p-q\); these data descend to the finer blowup-Hodge atom class. | KKPY Example 5.4, printed p. 49; Definition 5.10, p. 51; the fiber-point decomposition immediately before Definition 5.21, p. 59; Lemma 5.25, pp. 61–62; Definition 5.26 and Remark 5.27, p. 62, restricted to the equivalences retained in A5. Corollary 3.4 derives the resulting additivity identity rather than importing it. |
| A12 | The relevant analytic action is the germ of \(G_{\mathbb K}^{\mathrm{an}}\) along its compact subdomain \(G_{\mathbb K}^{\beth}\). The norm-defined A-model base pieces are preserved by this germ, and every neighborhood of the fixed locus admits a smaller local-group neighborhood acting on it. | KKPY §5.2.1, Example 5.8 and the following action paragraph, printed p. 50; §5.2.2, printed p. 51. |
| A13 | KKPY's atom operator is \(\kappa_{\mathrm{at}}=\operatorname{Eu}\star(-)\), whereas the displayed A-model connection has \(-u^{-2}\kappa_{\mathrm{at}}\); hence its literal residue is \(K_{\mathrm{res}}=-\kappa_{\mathrm{at}}\). | KKPY Definition 3.12, printed p. 21; the A-model connection (3.30), printed p. 31; the cubic connection (6.9) in the proof of Theorem 6.8, p. 69. The sign reconciliation is recorded below; no new theorem is imported. |
| A14 | A smooth cubic fourfold has the displayed Hodge diamond; outside middle degree its cohomology is generated by the powers of the hyperplane class, and its odd cohomology vanishes. | Hassett, [*Special Cubic Fourfolds*](../tmp/pdfs/hassett-special-cubic-fourfolds.pdf), §2.1, Hodge-diamond display and the discussion of \(h\), artifact pp. 3–4; same local SHA-256 as A8. |
| A15 | On a reduced affinoid rigid space, an analytic function or matrix which vanishes at every rigid point is zero. | Brian Conrad, [*Several approaches to non-archimedean geometry*](https://math.stanford.edu/~conrad/papers/aws.pdf), Theorem 1.1.5 and the paragraph after Example 1.2.2, printed pp. 4–5: affinoid algebras are Jacobson, so pointwise vanishing means nilpotence, hence vanishing in the reduced case. |

The “component is a covering of \(U_X\)” clause in A5 is used literally:
it includes surjectivity. Density of \(U_X\) alone would not imply that every
spectral-cover component meets a chosen neighborhood.

The blowup-Hodge atom quotient is deliberately finer than KKPY's Hodge-atom
quotient: projective-bundle elementary equivalences are not imposed. All
statements below start with actual spectral-cover components and use only the
relations retained in A5. Proposition 3.7 proves the exact weak-factorization
consequence needed for this target. Thus neither KKPY Theorem 4.11 nor the
Iritani–Koto projective-bundle theorem is an interface of this certificate.

## 3. Repair lemmas and consequences

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

### Sign convention for the spectral operator (N8)

We separate two operators that KKPY denote by the same symbol. Write

\[
\kappa_{\mathrm{at}}:=\operatorname{Eu}\star(-),\qquad
K_{\mathrm{res}}:=\left.u^2\nabla_{\partial_u}\right|_{u=0}.
\]

The displayed A-model connection in A13 gives

\[
\nabla_{\partial_u}
=\partial_u-u^{-2}\kappa_{\mathrm{at}}+u^{-1}(\text{grading}),
\qquad K_{\mathrm{res}}=-\kappa_{\mathrm{at}}.
\]

Thus HYZZ's residue blocks have spectra obtained by negating the atom
spectra. Negation changes neither generalized-eigenspace blocks, their
commutants, disjointness, nor their multiplicities. We retain KKPY's positive
atom labels throughout R1 and write HYZZ's local normal form as
\(U_0=K_{\mathrm{res}}=-\kappa_{\mathrm{at}}\).

### Lemma 3.2 — equivariant restriction of separated spectral factors (R2)

Let \(\mathbb K\) be an algebraically closed non-archimedean field of
characteristic zero, let \(G\) be proreductive, and let
\((\mathcal H,\nabla)/B\) be a \(G\)-equivariant F-bundle which is maximal
at a smooth rigid point \(b\in B^G\). Interpret the action in the analytic
germ category along the fixed locus. Suppose

\[
\mathcal H_{(b,0)}=\bigoplus_{\lambda\in\Lambda}H_b^\lambda
\]

is the primary decomposition of \(\kappa_{\mathrm{at},b}\) into finitely
many spectral clusters, and distinct clusters have disjoint spectra.
Equivalently, these are the \(-\lambda\)-clusters of
\(K_{\mathrm{res},b}\). Then, after shrinking the germ of \(B\) at \(b\):

1. the HYZZ decomposition on the full base is canonical among F-bundle
   decompositions lifting these primary blocks;
2. its summands and tangent distributions are \(G\)-equivariant as germs;
3. its pullback to \(B^G\) is a direct-sum decomposition of the restricted
   F-bundle, with
   \[
   (H_b^\lambda)^G=(\mathcal H_{(b,0)}^G)^\lambda.
   \]

The pulled-back factors in (3) need not be maximal over \(B^G\); maximality
is neither asserted nor needed after restriction.

**Proof.**

**(1) Apply the theorem only where maximality holds, and prove
canonicity.** HYZZ Theorem 3.42 applies to the full germ \((B,b)\), not to
\(B^G\), and produces an F-bundle decomposition extending the displayed
primary decomposition. Fix one such splitting. Put

\[
R=\mathcal O_{B,b},\qquad
M=(\mathcal H_{u=0})_b=\bigoplus_iM_i,qquad
K=K_{\mathrm{res}}|_M,
\]

where the \(M_i\) are the stalks of its cluster blocks, and set
\(f_i(T)=\det(T-K|_{M_i})\in R[T]\). The reductions of \(f_i\) and \(f_j\)
at \(b\) have disjoint root sets for \(i\ne j\). Hence every
\(\operatorname{Res}(f_i,f_j)\) is outside the maximal ideal of \(R\), so
it is a unit. After shrinking the analytic representative, these resultants
remain units at every point. In particular, the block spectra remain
disjoint over the whole shrunken germ. Equivalently, each off-diagonal
Sylvester map

\[
\operatorname{Hom}_R(M_j,M_i)\longrightarrow\operatorname{Hom}_R(M_j,M_i),
\qquad X\longmapsto K_iX-XK_j,
\]

is an isomorphism; this is the ring-coefficient form of HYZZ Lemmas 3.25
and 3.28.

The \(f_i\) are therefore pairwise comaximal. The Chinese remainder theorem
gives \(p_i(T)\in R[T]\) with

\[
p_i\equiv1\pmod{f_i},\qquad p_i\equiv0\pmod{f_j}\quad(j\ne i).
\]

By Cayley–Hamilton, \(p_i(K)\) is the identity on \(M_i\) and zero on every
other \(M_j\); it is the reference primary projector. Let \(e'_{i,0}\) be
the \(u=0\) projector of another F-bundle splitting lifting the same closed
fiber block. Horizontality gives \([K,e'_{i,0}]=0\). The invertible
off-diagonal Sylvester maps force \(e'_{i,0}\) to be block diagonal. Its
restriction to each block is idempotent, so its image and kernel are finite
projective and their ranks are locally constant. At \(b\), the restriction
is the identity on the selected block and zero on all others. After a
connected shrink, Nakayama's lemma forces the same identities over \(R\).
Consequently

\[
e'_{i,0}=p_i(K)=e_{i,0}.
\]

Now let \(e,e'\) be the full horizontal projectors for two lifted
splittings of that block and put \(d=e-e'\). The equality just proved gives
\(d\in u\operatorname{End}(M)[[u]]\). In a local trivialization write

\[
\nabla_{\partial_u}=\partial_u+u^{-2}U(u),\qquad
U(u)=U_0+uU_1+\cdots,\qquad
U_0=K_{\mathrm{res}}=-\kappa_{\mathrm{at}}.
\]

If \(d=u^m d_m+O(u^{m+1})\) with \(m\ge1\) minimal, the coefficient of
\(u^m\) in

\[
u^2\partial_ud+[U,d]=0
\]

is \([U_0,d_m]=0\). The same Sylvester isomorphisms make \(d_m\) block
diagonal. Subtracting \(e^2=e\) and \((e')^2=e'\), and taking the first
nonzero \(u\)-coefficient, gives

\[
e_0d_m+d_me_0=d_m.
\]

On the selected block this reads \(2d_m=d_m\), and on every other block it
reads \(0=d_m\). Hence \(d_m=0\), a contradiction. Thus \(e=e'\).
Maximality identifies these canonical bundle blocks with canonical tangent
distributions, so the corresponding product germs are canonical as well.

**(2) Equivariance in the germ category.** The point \(b\), the connection,
and the closed-fiber primary projectors are \(G\)-fixed/equivariant. Given a
representative of the analytic action and a representative neighborhood on
which the splitting is defined, compare the action-pullback of the splitting
with its projection-pullback on a common refinement. They have the same
prescribed closed-fiber projectors, so (1) identifies them on that refinement.
This proves equivariance of every projector, summand, and tangent distribution
as an analytic germ.

For the A-model application, A12 supplies precisely these representatives:
\(G_{\mathbb K}^{\beth}\) is compact, the base pieces are norm-defined and
preserved by the germ along it, and every neighborhood of the fixed locus
supports an action after shrinking the local-group neighborhood. Such
representatives are cofinal as the base neighborhood shrinks. No assertion
is made that the full unbounded group \(G(\mathbb K)\) preserves one affinoid
representative.

**(3) Invariants and restriction.** Pull the full-base decomposition back
along \(B^G\hookrightarrow B\). This preserves direct sums and connections.
For a cluster projector \(p_\lambda(\kappa_{\mathrm{at},b})\),

\[
\begin{aligned}
(H_b^\lambda)^G
 &=p_\lambda(\kappa_{\mathrm{at},b})(\mathcal H_{(b,0)})\cap
   \mathcal H_{(b,0)}^G\\
 &=p_\lambda(\kappa_{\mathrm{at},b})(\mathcal H_{(b,0)}^G)
  = (\mathcal H_{(b,0)}^G)^\lambda.
\end{aligned}
\]

The middle equality follows directly from equivariance of the projector;
Lemma 3.1 also shows that taking invariants preserves the whole direct-sum
decomposition and commutes with the scalar extensions used in Definition
5.26. ∎

### Proposition 3.3 — pointwise localization of an atom

Retain Lemma 3.2 and put \(S=B^G\). Assume in addition that

1. \(U_X\subset S\) is dense and open;
2. the reduced \(\kappa_{\mathrm{at}}\)-spectral cover
   \(\pi:\widetilde U_X\to U_X\) is finite étale;
3. every connected component \(C_\alpha\subset\widetilde U_X\) maps
   surjectively to \(U_X\); and
4. point factors on \(C_\alpha\) represent the blowup-Hodge atom
   \(\alpha\) as in
   A5 and A11.

Let \(W\subset S\) be a connected neighborhood of \(b\) on which the
equivariant cluster splitting is defined. Then every \(C_\alpha\) has a
point \(x\) above \(W\cap U_X\). Its atomic germ lies in one local cluster
\(\lambda(\alpha,x)\), and

\[
\rho_\alpha\le
\operatorname{rank}(\mathcal H^\lambda_{u=0})^G.
\]

**Proof.** First we justify the cover-native subbundle used in the statement.
Let \(N=\operatorname{rank}\mathcal H\), let
\(\ell_\alpha\in\mathcal O(C_\alpha)\) be the tautological atom eigenvalue,
and set

\[
\mathcal A_\alpha
=\ker\bigl((\pi^*\kappa_{\mathrm{at}}-\ell_\alpha)^N\bigr).
\]

The assertion that this kernel is a vector subbundle is étale-local. Make
an étale base change which splits the reduced cover into distinct branches
\(\ell_1,\ldots,\ell_r\). Their pairwise differences are units. Hence the
polynomials

\[
g_i(T)=(T-\ell_i)^N
\]

are pairwise comaximal. The product \(\prod_i g_i(\kappa_{\mathrm{at}})\)
vanishes at every rigid point by Cayley–Hamilton on the generalized
eigenspaces, and therefore vanishes as an analytic endomorphism by A15
because the étale chart is reduced. CRT supplies polynomials \(q_i(T)\)
which are \(1\) modulo \(g_i\) and \(0\) modulo every \(g_j\), \(j\ne i\). The
endomorphisms \(q_i(\kappa_{\mathrm{at}})\) are orthogonal idempotents
summing to \(1\). On their respective images,
\((\kappa_{\mathrm{at}}-\ell_i)^N=0\); on the image of \(q_j\) for
\(j\ne i\), the operator

\[
\kappa_{\mathrm{at}}-\ell_i
=(\ell_j-\ell_i)+(\kappa_{\mathrm{at}}-\ell_j)
\]

is a unit plus a nilpotent and is invertible. Thus

\[
\ker(\kappa_{\mathrm{at}}-\ell_i)^N
=\operatorname{im}q_i(\kappa_{\mathrm{at}}).
\]

It is the image of an idempotent, hence a direct-summand vector subbundle of
locally constant rank. These intrinsic kernels patch under étale descent;
the tautological branch on \(C_\alpha\) gives \(\mathcal A_\alpha\). It is
\(G\)-stable, and Lemma 3.1 makes its fiber representation and invariant
dimension constant on connected \(C_\alpha\). A5 identifies any fiber with
the representation \(E^\alpha\).

Because \(U_X\) is dense and \(W\) is nonempty open,
\(W\cap U_X\ne\varnothing\). Surjectivity of
\(C_\alpha\to U_X\) supplies \(x\in C_\alpha\) above a point of this
intersection. The tautological eigenvalue at \(x\) lies in exactly one of
the disjoint local spectral clusters (for \(K_{\mathrm{res}}\), the label is
negated). Hence \((\mathcal A_\alpha)_x\) is a \(G\)-stable direct factor in
that cluster. Lemma 3.1, including constant invariant rank on connected
\(W\), gives

\[
\rho_\alpha
=\dim_{\mathbb K}(\mathcal A_{\alpha,x})^G
\le \dim_{\mathbb K}(\mathcal H^\lambda_{(\pi(x),0)})^G
=\dim_{\mathbb K}(\mathcal H^\lambda_{(b,0)})^G
=\dim_{\mathbb K}(\mathcal H_{(b,0)}^G)^\lambda.
\]

This is the rank bound. ∎

**Sharp boundary of Proposition 3.3.** One must not strengthen the conclusion
to say that a global connected component \(C_\alpha\) has one cluster label
over all of \(W\). Its pullback to \(W\) can be disconnected. The standard
cover \(z^2=t\) over \(\mathbf G_m\) is connected, while over a small
neighborhood of \(t=1\) it splits into the two local branches near
\(z=\pm1\). The pointwise statement above is all that Theorem 6.8 uses;
moreover every cubic cluster has invariant rank at most two, so the choice
of local branch cannot affect the final bound. Correspondingly, when
\(\deg(C_\alpha/U_X)>1\), the phrase before KKPY Definition 5.26 describing
a subbundle on \(U_X\) “from the eigenvalues parametrized by” \(C_\alpha\)
cannot be read as a pushforward sum: that sum can have larger invariant
rank. The cover-native bundle \(\mathcal A_\alpha\) is the precise
formulation compatible with the single-point fiber in KKPY Remark 5.29.

### Corollary 3.4 — atomic additivity of the folded Hodge polynomial (N1)

For a connected smooth projective \(X\), define

\[
\operatorname{HP}_{\mathrm{fold}}(X;t)
:=\sum_{p,q}h^{p,q}(X)t^{p-q}.
\]

Then, with the first sum taken over actual connected components before any
automorphism or blowup-Hodge-atom quotient,

\[
\operatorname{HP}_{\mathrm{fold}}(X;t)
=\sum_{C\in\pi_0(\widetilde U_X)}
  \deg(C/U_X)P_{\bar C}(t)
=\sum_\alpha m_X(\alpha)P_\alpha(t),
\]

where

\[
m_X(\alpha)
:=\sum_{C:\,\bar C=\alpha}\deg(C/U_X).
\]

Likewise,

\[
\dim H_B^\bullet(X,\overline{\mathbf Q})^{\mathsf{Hod}}
=\sum_C\deg(C/U_X)\rho_{\bar C}.
\]

**Proof.** Choose \(b\in U_X\). By A11, the cover-native primary
decomposition is

\[
\mathcal H_{(b,0)}
=\bigoplus_{x\in\widetilde U_{X,b}}\mathcal A_x.
\]

Finite étaleness gives \(\#C_b=\deg(C/U_X)\). All points of a connected
component \(C\) give the same Hodge representation by Lemma 3.1 and A5.
Taking \(p-q\) weight dimensions in the displayed direct sum gives the first
identity; taking Hodge-group invariants, which is exact by Lemma 3.1, gives
the second. Regrouping all components which represent the same blowup-Hodge atom
gives \(m_X(\alpha)\). In particular, this sum-of-degrees convention cannot
be replaced by the degree of one component after an automorphism quotient.
All coefficients and multiplicities are nonnegative integers. For a
disconnected variety, the same statements apply componentwise by the
definition of its chemical formula. ∎

### Lemma 3.5 — the cubic ambient matrix from lines

Let \(X\subset\mathbf P^5\) be a smooth cubic fourfold and
\(h=c_1(\mathcal O_X(1))\). On the ambient basis
\((1,h,h^2,h^3,h^4)\), small quantum multiplication by \(h\) is

\[
A(q)=
\begin{pmatrix}
0&0&6q&0&0\\
1&0&0&15q&0\\
0&1&0&0&6q\\
0&0&1&0&0\\
0&0&0&1&0
\end{pmatrix}.
\]

**Proof.** The Fano index is \(3\), so the degree rule permits only a
degree-one correction in multiplication by \(h\) on the five ambient powers;
all corrections of curve degree at least two would have negative output
degree. In Beauville's notation the possible corrections are

\[
h\star h^2=h^3+\ell_0q,\qquad
h\star h^3=h^4+\ell_1qh,\qquad
h\star h^4=\ell_2qh^2.
\]

Specializing A4's Grassmannian formula to a cubic gives, for
\(p=0,1,2\),

\[
\ell_p=\frac13\int_{\operatorname{Gr}(2,6)}
c_4(\operatorname{Sym}^3S^\vee)c_{3-p}(Q)c_{1+p}(Q).
\]

If \(a,b\) are the Chern roots of \(S^\vee\), put
\(s_j(a,b)=\sum_{i=0}^j a^{j-i}b^i=c_j(Q)\). Then

\[
c_4(\operatorname{Sym}^3S^\vee)
=(3b)(a+2b)(2a+b)(3a),
\]

and Beauville's coefficient lemma reads

\[
\int_{\operatorname{Gr}(2,6)}P(a,b)
=[a^5b^5]\left(-\frac12(a-b)^2P(a,b)\right).
\]

Direct expansion gives

\[
\begin{array}{c|ccc}
p&0&1&2\\ \hline
\int c_4s_{3-p}s_{1+p}&18&45&18\\
\ell_p&6&15&6.
\end{array}
\]

The remaining two columns are classical multiplication by \(h\). This is the
displayed matrix. Since \(c_1(T_X)=3h\), small quantum multiplication by the
Euler field is \(K(q)=3A(q)\). ∎

### Lemma 3.6 — nef canonical class gives one blowup-Hodge atom

Let \(Y\) be a connected smooth projective variety with nef canonical class.
Then the reduced spectrum of Euler quantum multiplication has one element.
Consequently \(Y\) has one blowup-Hodge atom
\(\boldsymbol\eta(Y)\), its generalized eigenspace is the whole fiber, and

\[
E^{\boldsymbol\eta(Y)}\cong
H_B^\bullet(Y,\overline{\mathbf Q}).
\]

**Proof.** Reduced spectra are unchanged by the odd nilpotent directions, so
work on the underlying even A-model base. For a nonzero genus-zero correlator
contributing \(T^r\) to \(T_i\star T_j\), the virtual-dimension rule gives

\[
\deg T^r
=\deg T_i+\deg T_j
 +\sum_a(\deg T_{i_a}-2)
 -2c_1(T_Y)\mathbin{\cdot}\beta.
\]

For \(\beta\ne0\), the unit axiom removes degree-zero insertions. All remaining
even insertions have degree at least two, while nefness of \(K_Y\) gives
\(c_1(T_Y)\cdot\beta=-K_Y\cdot\beta\le0\). For \(\beta=0\), the only term is
the classical product. Hence every quantum product term has

\[
\deg T^r\ge\deg T_i+\deg T_j.
\]

At an even base point \(\gamma\), the Euler field is

\[
\operatorname{Eu}_\gamma
=-t_0\mathbf1+c_1(T_Y)
 +\sum_{\deg T_i>2}\frac{\deg T_i-2}{2}t_iT_i;
\]

degree-two coordinates have coefficient zero. Every non-scalar summand has
positive degree, so its quantum multiplication strictly raises the finite
cohomological-degree filtration. Thus

\[
\operatorname{Eu}_\gamma\star(-)=-t_0\operatorname{id}+N_\gamma
\]

with \(N_\gamma\) nilpotent. The reduced spectrum therefore consists only of
\(-t_0\). Connectedness of the fixed base from A5 gives one spectral-cover
component, and its unique
generalized eigenspace is the full fiber. A11 identifies that fiber with the
full Betti Hodge representation. ∎

### Proposition 3.7 — the target-specific weak-factorization consequence

Let \(X\) be a smooth projective fourfold and let \(\alpha\) be a
blowup-Hodge atom occurring in \(X\) with
\(\operatorname{Coeff}_{t^2}P_\alpha(t)>0\). If \(X\) is rational, then
\(\alpha\) occurs in the atomic composition of a smooth projective variety of
dimension at most two.

**Proof.** By A7, a birational map
\(\mathbf P^4\dashrightarrow X\) has a weak factorization. Apply A6 at every
step and move the contributions of backward blowups to the left. In the free
commutative monoid on blowup-Hodge atoms this gives

\[
\operatorname{CF}_{\rm bl}(X)
+\sum_{i\in\mathrm{back}}(r_i-1)\operatorname{CF}_{\rm bl}(Z_i)
=\operatorname{CF}_{\rm bl}(\mathbf P^4)
+\sum_{i\in\mathrm{forward}}(r_i-1)\operatorname{CF}_{\rm bl}(Z_i),
\]

where \(Z_i\) is a smooth center of codimension \(r_i\ge2\) in a smooth
fourfold. Since \(\alpha\) has positive multiplicity on the left, it has
positive multiplicity on the right.

It cannot be supplied by \(\mathbf P^4\). Indeed,
\(\operatorname{HP}_{\rm fold}(\mathbf P^4;t)=5\), and Corollary 3.4 gives

\[
0=[t^2]\operatorname{HP}_{\rm fold}(\mathbf P^4;t)
=\sum_C\deg(C/U_{\mathbf P^4})[t^2]P_{\bar C}(t).
\]

Every summand is a nonnegative integer, so every blowup-Hodge atom of
\(\mathbf P^4\) has zero \(t^2\)-coefficient. Therefore \(\alpha\) occurs in
some \(Z_i\) on the right. Since \(r_i\ge2\),
\(\dim Z_i=4-r_i\le2\). ∎

## 4. Repaired proof

Let \(X\) be a Noether–Lefschetz-general smooth cubic fourfold: its rational
Hodge classes are precisely the powers of the hyperplane class
\(h=c_1(\mathcal O_X(1))\). By A14, its odd cohomology vanishes, its total
even cohomology has dimension \(27\), and

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

On the ambient invariant basis \((1,h,h^2,h^3,h^4)\), Lemma 3.5 gives the matrix
of \(\kappa_{\mathrm{at}}\), denoted

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
\(\kappa_{\mathrm{at},b}=\operatorname{Eu}_b\star(-)\) on all of
\(\mathcal H_{(b,0)}\). The HYZZ residue spectrum is \(-\Lambda\), with the
same blocks and dimensions, by the N8 convention above. All subsequent
specializations in this proof are at \(q_0\), never at \(q=1\).

### R2 — decompose the full maximal bundle, then restrict equivariantly

**Before (KKPY p. 70):** “By the spectral decomposition theorem Theorem
4.1 … the A-model F-bundle \((\mathcal H,\nabla)/B_X^{\mathsf{Hod}}\)
decomposes into an external direct sum of maximal F-bundles.”

**After:** Apply Lemma 3.2 with \(G=\mathsf{Hod}\) to the full bundle over
\(B_X\). Its hypotheses hold as follows.

1. By A1, the full bundle is maximal at \(b\); \(B_X\) is smooth there.
2. The primary generalized-eigenspace blocks of
   \(\kappa_{\mathrm{at},b}\) indexed by \(\Lambda\) have pairwise disjoint
   spectra; the residue blocks are the same blocks labelled by \(-\Lambda\).
3. The point \(b\), \(\kappa_{\mathrm{at}}\), and the connection are
   Hodge-equivariant. A12 supplies the analytic Hodge-group germ on every
   sufficiently small representative.
4. Lemma 3.2 proves canonicity and equivariance of the four full-base
   factors and pulls them back to a decomposition over
   \(B_X^{\mathsf{Hod}}\). It does **not** call the restricted factors
   maximal.
5. The extra hypotheses of Proposition 3.3 hold: by A5,
   \(B_X^{\mathsf{Hod}}\) is connected and smooth, \(U_X\) is the dense
   open maximal-eigenvalue locus (density is stated explicitly for this
   cubic in the proof of KKPY Theorem 6.8, printed p. 70),
   \(\widetilde U_X\to U_X\) is finite étale, and every component is a
   surjective cover. A5 and A11 identify its point factors with the relevant
   blowup-Hodge atom. Proposition 3.3 therefore supplies a representative local atomic
   germ in one of the four clusters.

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

The ambient powers of \(h\) have \(p-q=0\), so this row gives

\[
\operatorname{Coeff}_{t^2}\operatorname{HP}_{\mathrm{fold}}(X;t)=1.
\]

Corollary 3.4 now gives the explicit nonnegative identity

\[
1=\sum_{C\in\pi_0(\widetilde U_X)}
\deg(C/U_X)\operatorname{Coeff}_{t^2}P_{\bar C}(t).
\]

Hence some atom \(\alpha\) has

\[
\operatorname{Coeff}_{t^2}P_\alpha(t)=1,
\qquad \rho_\alpha\le2.
\]

### R5 — pass to the minimal model; do not classify surfaces

**Before (KKPY p. 71):** “\(S\) must be either an abelian surface, a K3
surface, an elliptic surface with \(\kappa=1\) and \(p_g=1\), or a surface
of general type. But every such surface has a nef \(K_S\).”

**After:** Let \(Y\) be any smooth projective variety of dimension at most
two whose atomic composition contains \(\alpha\), and write
\(Y=\bigsqcup_jY_j\) as its connected-component decomposition. By the
componentwise definition of the chemical formula,

\[
\operatorname{CF}(Y)=\sum_j\operatorname{CF}(Y_j).
\]

All multiplicities are nonnegative, so \(\alpha\) occurs in some connected
component \(Y_j\). Corollary 3.4 shows that a connected point or curve has
total \(t^2\)-coefficient zero and therefore cannot contain \(\alpha\).
Thus the component is a connected smooth projective surface; rename it
\(S\). The same corollary gives

\[
1=\operatorname{Coeff}_{t^2}P_\alpha(t)\le p_g(S),
\]

so \(P_1(S)=p_g(S)>0\), and hence \(\kappa(S)\ge0\) by definition. Contract
the \((-1)\)-curves to the minimal model \(S_{\min}\). By A9,
\(K_{S_{\min}}\) is nef.

Each contraction reversed is a point blowup. By A6, a point blowup adds
only the point atom, whose Hodge polynomial is \(1\). Since
\(\operatorname{Coeff}_{t^2}P_\alpha=1\), \(\alpha\) is not a point atom;
therefore it is already an atom of \(S_{\min}\). By Lemma 3.6, the atomic
composition of \(S_{\min}\) has the single atom
\(\boldsymbol\eta(S_{\min})\). Consequently

\[
\alpha=\boldsymbol\eta(S_{\min}).
\]

The proof of Lemma 3.6 says that
\(\kappa_{\mathrm{at}}\) has one reduced eigenvalue. Its unique generalized
eigenspace is therefore the entire fiber, and A11 (via KKPY Lemma 5.25)
identifies its representation as

\[
E^{\boldsymbol\eta(S_{\min})}
\cong H_B^\bullet(S_{\min},\overline{\mathbf Q}).
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
variety of dimension at most two. Proposition 3.7 implies that \(X\)
is not rational.

### R4 — supply the very-general quantifier

**Before (KKPY p. 69):** “Such cubic fourfolds exist e.g. by Voisin’s proof
of the Torelli theorem for cubic fourfolds.”

**After:** The pinned Hassett artifact first defines the integral Hodge
lattice (the paragraph immediately after Definition 3.1.1, artifact p. 7):

> “Let \(A(X)=H^{2,2}(X)\cap H^4(X,\mathbf Z)\).”

Theorem 3.1.2 then states (artifact pp. 7–8):

> “Every special cubic fourfold is contained in some \(\mathcal C[K]\), which is an irreducible algebraic divisor.”

Here \(\mathcal C[K]\) is defined by the inclusion of a positive-definite
saturated rank-two lattice \(K\), containing \(h^2\), in \(A(X)\). Thus if
\(A(X)\) has rank at least two, choosing such a saturated \(K\) puts \(X\)
in \(\mathcal C[K]\). This implication is purely about the integral Hodge
lattice and uses no Hodge conjecture; Hassett invokes that conjecture only
to identify these Hodge classes with algebraic-cycle classes. The relevant
integral lattices \(K\) form a countable set. Therefore

\[
\mathcal C_{\rm NL}:=\bigcup_K\mathcal C[K]
\]

is a countable union of proper closed algebraic divisors. Outside this union,
\(A(X)\) has rank one, so clearing denominators shows that the middle
rational Hodge classes are generated by \(h^2\); A14 shows in the other
degrees that the only rational Hodge classes are the remaining powers of
\(h\). This is precisely the
Noether–Lefschetz generality used above. The repaired argument applies to
every point of this complement.

No further Torelli or transcendental-irreducibility locus is consumed by
Theorem 6.8. The irreducibility assertion used later in KKPY Corollary 6.12
is not an input to this theorem and adds no exceptional locus here. This
proves the stated very-general theorem. ∎

## 5. Consequential R1 substitutions after Theorem 6.8

Although they are not used in the proof above, consistency requires the same
base point in the immediate downstream statements:

- Lemma 6.11: \(\kappa_{\mathrm{at},b}\) refers to the point \(q=q_0\),
  \(t_i=0\).
- Corollary 6.12: the three nonzero atom-operator eigenvalues become
  \(9q_0^{1/3}\), \(9q_0^{1/3}\zeta\), and
  \(9q_0^{1/3}\zeta^2\).
- The two occurrences of the positive atom-operator matrix
  \(K|_{q=1}\) in that corollary’s proof become \(K(q_0)\). The connection
  residue has the negative of these eigenvalues.

## 6. Replay record

The two finite computations can be replayed without any project code. First,
Beauville's Grassmannian coefficient formula gives the three line-incidence
numbers:

```sh
/opt/homebrew/bin/python3 -c 'import sympy as s; a,b=s.symbols("a b"); cj=lambda n:sum(a**(n-i)*b**i for i in range(n+1)); top=s.prod(j*a+(3-j)*b for j in range(4)); integ=lambda p:s.Poly(s.expand(-s.Rational(1,2)*(a-b)**2*top*cj(3-p)*cj(1+p)),a,b).coeff_monomial(a**5*b**5); vals=[s.simplify(integ(p)/3) for p in range(3)]; assert vals==[6,15,6]; print(vals)'
```

Expected output:

```text
[6, 15, 6]
```

Then their ambient matrix has the required characteristic polynomial:

```sh
/opt/homebrew/bin/python3 -c 'import sympy as s; q,L=s.symbols("q L"); K=3*s.Matrix([[0,0,6*q,0,0],[1,0,0,15*q,0],[0,1,0,0,6*q],[0,0,1,0,0],[0,0,0,1,0]]); p=s.expand(K.charpoly(L).as_expr()); expected=L**2*(L**3-729*q); assert s.expand(p-expected)==0; print(p)'
```

Expected output:

```text
L**5 - 729*L**2*q
```

The source pins can be replayed with:

```sh
shasum -a 256 tmp/pdfs/2508.05105v2.pdf tmp/pdfs/2411.02266.pdf tmp/pdfs/2307.13555.pdf tmp/pdfs/2604.10028v2.pdf tmp/pdfs/beauville-quantum-complete-intersections.pdf tmp/pdfs/peters-surface.pdf tmp/pdfs/givental-eqv.pdf tmp/pdfs/hassett-special-cubic-fourfolds.pdf tmp/sources/v2/brinv.tex
rg -n 'thm:cubic4|thm:K-decomposition|lem:Ginvariants|lem:nefK|prop:non-rational' tmp/sources/v2/brinv.tex
```

## 7. Certificate boundary

- R1, R3, R4, and R5 are closed by explicit substitutions and arguments.
- R2 is closed for Theorem 6.8 by Lemmas 3.1–3.2 and Proposition 3.3,
  including the cover-native definition of the atom representation.
- The stronger claim that one global spectral-cover component has one local
  cluster label is expressly not certified; it is false in general and
  unnecessary.
- A1 and A6 retain the two irreducibly heavy Gromov--Witten interfaces: the
  full analytic Hodge-equivariant A-model package and the Hodge-compatible
  blowup formula. A4 retains only the cubic's three degree-one line-incidence
  numbers. Their definitive WP-1 audit is `GW_INPUT.md`.
- A5 and A11 retain only the spectral-cover/Hodge-atom bookkeeping used here;
  A7 is weak factorization. Projective-bundle atom relations, KKPY Proposition
  5.30, a separate imported nef-\(K\) lemma, primitive-class vanishing, and
  deformation invariance are not interfaces of this certificate.
- N1–N8 and the WP-1 reductions are incorporated at certificate standard. No
  WP-2–WP-5 work, author contact, or Lean implementation is included.
