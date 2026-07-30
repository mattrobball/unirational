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

Let \(\mathcal U\subset\mathbf P^{55}_{\mathbf C}\) be the smooth locus in
the projective parameter space of cubic equations in six variables. There is
a countable collection of proper closed algebraic subsets
\(D_n\subset\mathbf P^{55}\) such that every smooth cubic fourfold represented by

\[
X\in \mathcal U\setminus\bigcup_nD_n
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
bf53f2958e17de3ece49c27d433f98f9a55086fedd4c7cbb65e9bb15682e8f4d  tmp/pdfs/vezzani-nonarch-implicit-function.pdf
bd864c89ed8b6e8f27a90f459837221549db75afa75554ab51414e17771066af  tmp/pdfs/berkovich-etale-cohomology.pdf
54bac91f89abcd9a42645b1a07624222aeb570048ed224e4cd79a328fd7ef915  tmp/pdfs/fresnel-van-der-put-rigid-analytic-geometry.pdf
c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b  tmp/pdfs/2307.13555.pdf
0114923576b2ec3a78fc346fd9f61eb65cfe63f8cc7087881d11626cdb9883c3  tmp/pdfs/2604.10028v2.pdf
9d022796aefa01fd601820e415c5462bdfc255b3b4fe158af64b51f7bf0a83e3  tmp/pdfs/beauville-quantum-complete-intersections.pdf
51f9c99621b3819aa85894a8cdee4a528b0894364fc22b40a651f1bae55ceed3  tmp/pdfs/peters-surface.pdf
985248cc3e6e166b9847b01552de2034429a624794dc0c53cad50beb1f4b50c9  tmp/pdfs/givental-eqv.pdf
ecc2e31a63f56d443aaa3534f0218b25a5b6ab6e1a84c82db5c7bac1789a1d21  tmp/pdfs/hassett-special-cubic-fourfolds.pdf
48f8af5249081217fc4a806414a764d9d69d66eff9092ddd8e2cf0ea078579e8  tmp/pdfs/milne-tannakian-categories.pdf
5add29094b74385746c4d977290b2308d02cbe8aa6f085e6a99724f6939e309b  tmp/pdfs/conrad-nonarchimedean-geometry.pdf
28cce3fa0cbd3c25491d1416f8e40a89362b6b1c14420789b3cd83e9c3f7f860  tmp/pdfs/popa-hodge-theory-singularities.pdf
```

The primary PDF is linked
[`here`](../tmp/pdfs/2508.05105v2.pdf).

The following is an expanded proof-local dependency and source ledger. It
mixes opaque packages, internal lemmas, and retired historical nodes. The only
authoritative top-level imported-interface table is `GW_INPUT.md` § 2.

| ID | Dependency/status | Exact source and use |
|---|---|---|
| A1 | **Opaque `GW-1`.** The analytic A-model matrices exist on the required non-archimedean germ, restrict to the connected smooth Hodge-fixed germ, and are Hodge-equivariant. On \(\mathcal H\vert_{u=0}\), the Hodge group acts by unital algebra automorphisms preserving the quantum product and Euler field. The product satisfies the virtual-dimension grading and genus-zero unit/fundamental-class rule used in Lemma 3.6. Full-base maximality is not consumed. | KKPY §3.5.1, Definition 3.25 and the unit paragraph, Definition 3.32, Proposition 3.40, Definition 3.52; the algebra-action clause used in Lemma 5.19 is explicit in `tmp/sources/v2/brinv.tex`, lines 3336–3344 (printed p. 57). |
| A2 | For multiplication by a group-fixed element in a finite-dimensional unital commutative superalgebra, the reduced spectrum on the whole algebra equals the reduced spectrum on its invariant subalgebra. | KKPY Lemma 5.19, printed p. 57. |
| A3 | **Internal HP theorem.** Over the Henselian analytic local ring \(\mathcal O_{S,b}\), pairwise separated closed-fiber blocks of \(K_{\mathrm{res}}\) have unique complete orthogonal commuting projectors on \(\mathcal H\vert_{u=0}\); after one shrink these are analytic subbundles, and canonicity gives Hodge equivariance. No full-\(u\) horizontal projector is consumed. | `ATOM_CORE.md`, Henselian Primary-Projector Theorem. Henselianity is Berkovich Theorem 2.1.5, printed pp. 39–40, independently corroborated by Fresnel–van der Put Proposition 7.1.8(1), printed pp. 199–200; hashes listed above. HYZZ convergence is retained only as a non-load-bearing audit. |
| A4 | **Internal `GW-2` target.** For a smooth cubic fourfold, the three degree-one ambient corrections to multiplication by \(h\) are \((6,15,6)\); the grading excludes higher-degree corrections. No separate Fano-scheme expected-dimension premise is exposed. | Prove `beauvilleCubicLineCorrections` directly from Beauville's equations (1.6), (2.1), and Grassmannian coefficient lemma, pp. 2–7; hash listed above. Any expected-dimension/deformation step belongs inside that F2 proof. Givental remains only an independent check. |
| A5 | The fixed analytic base \(B_X^G\) is connected and smooth. Its dense nonempty Zariski-open maximal-distinct-eigenvalue locus \(U_X\) carries the finite étale reduced spectral cover \(\widetilde U_X\). Raw local atoms are its connected components, with only isomorphism, same-component, disjoint-union, and smooth-blowup generators retained for the blowup-Hodge quotient. No representation or Hodge-polynomial descent is assumed here. | KKPY §5.2.2 and Definition 5.10, printed p. 51; §5.2.6.2, pp. 54–55; Definition 5.21 and the relevant parts of Proposition 5.22, pp. 59–60; proof of Theorem 6.8, p. 70 (density). Component surjectivity is now derived from irreducibility and finite étaleness; cover-native bundles and numerical descent are internal in `ATOM_CORE.md` §7. |
| A6 | **Opaque `GW-3`.** The blowup-Hodge-atom formula \(\operatorname{CF}_{\rm bl}(\operatorname{Bl}_Z Y)=\operatorname{CF}_{\rm bl}(Y)+(r-1)\operatorname{CF}_{\rm bl}(Z)\), compatibly with Hodge representations and \(p-q\) gradings, holds only for a surface blown up at a point and a fourfold blown up along a smooth center of dimension at most two. | KKPY Theorem 4.5 and Proposition 5.22(2); Iritani, *Quantum cohomology of blowups*, Theorem 5.18. Iritani's later Notes, Proposition 8 and Corollary 11, support formal Hodge compatibility, but Proposition 8 explicitly invokes HYZZ reconstruction on pp. 7–8 and is not an independent HYZZ-free proof. Hashes listed above. |
| A7 | If a smooth projective complex fourfold \(X\) is birational to \(\mathbf P^4\), there is a finite weak factorization from \(\mathbf P^4\) to \(X\) through smooth projective complex fourfolds, each step or inverse step being a blowup in a smooth center. After identity blowups of Cartier divisors are deleted, the centers have codimension at least two and hence dimension at most two. | Abramovich–Karu–Matsuki–Włodarczyk, *Torification and factorization of birational maps*, Theorem 0.1.1, internal pp. 1–2; [local PDF](../tmp/pdfs/akmw-torification-factorization.pdf), SHA-256 `55bbc2c58f29d4b9dbe965035f80f3844f6968eaf98076ac625132ac3b3977a5`. Włodarczyk's independent smooth-complete proof is statement 0.0.1 and §12.4 of [*Toroidal varieties and the weak Factorization Theorem*](../tmp/pdfs/wlodarczyk-toroidal-weak-factorization.pdf), SHA-256 `2f7a0bce5871db86bf84f54c4562fc053c53a4313180a6eecb66587d21e4fcfe`; it cross-checks the weak theorem but not AKMW's projective-intermediate clause. The target-specific atom consequence is Proposition 3.7 below; KKPY Proposition 5.30 is not imported. |
| A8 | **Opaque `NL-CUBIC`.** In the smooth cubic-form parameter space, outside a countable union of proper algebraic closed subsets, \(H^{2,2}(X)\cap H^4(X,\mathbf Q)=\mathbf Qh^2\). | Hassett, Definition 3.1.1 and Theorem 3.1.2, pp. 7–8, pulled back to the smooth locus in \(\mathbf P^{55}\); hash listed above. Irreducibility of the divisors, discriminant data, and nonemptiness are not consumed. |
| A9 | For a smooth projective surface, \(P_1=p_g\) and positive plurigenera are birational invariants. If a plurigenus is positive, finitely many \((-1)\)-curve contractions lead to a smooth projective minimal model with nef canonical class; reversing this sequence gives ordinary point blowups. | Peters, [*An Introduction to the Theory of Compact Complex Surfaces*](../tmp/pdfs/peters-surface.pdf): the definitions of \(p_g=h^{0,2}\) and \(P_m=h^0(K_S^{\otimes m})\), printed pp. 5 and 7, together with Serre duality, Theorem 4.3, printed p. 12, give \(P_1=p_g\); Propositions 2.1 and 2.2 and the discussion immediately following Proposition 2.2, printed pp. 8–9, give the contraction sequence, minimality, and nefness assertions. |
| A10 | Finite-dimensional representations of a proreductive group in characteristic zero are semisimple. | Deligne–Milne, [local *Tannakian Categories* PDF](../tmp/pdfs/milne-tannakian-categories.pdf), Proposition 2.23 and Remark 2.28, printed pp. 26–28; SHA-256 `48f8af5249081217fc4a806414a764d9d69d66eff9092ddd8e2cf0ea078579e8`. Exactness and base change are internal Lemma 3.1. |
| A11 | **Opaque `HATOM-RAW`.** The Hodge action is rational and proreductive with its \(p-q\) grading; the fixed base is connected smooth/reduced and its spectral cover is finite étale reduced. Only for a cubic in degree four are fixed vectors identified with rational \((2,2)\)-classes; the general cycle classes \(1,c_1(L),[\mathrm{pt}]\) are fixed. Fiberwise primary decomposition, component surjectivity, exact invariants, rank constancy, and \(\rho/P\) descent are internal. | KKPY Examples 5.5 and 5.7, p. 49; fixed base and cover before Definition 5.10, p. 51; Lemma 5.25, pp. 61–62; Definition 5.26, p. 62. Internal Henselian/cover CRT is in `ATOM_CORE.md` §§ 4, 6–7. |
| A12 | **RETIRED FROM THE TARGET GRAPH IN WP-3.** The moving-base analytic group germ was used by the older full-base restriction route. The new separated-projector theorem applies directly on the fixed base, where uniqueness makes the fiberwise-equivariant projectors equivariant. | Historical source: KKPY §5.2.1, Example 5.8 and following paragraph, printed p. 50; §5.2.2, p. 51. |
| A13 | KKPY's atom operator is \(\kappa_{\mathrm{at}}=\operatorname{Eu}\star(-)\), whereas the displayed A-model connection has \(-u^{-2}\kappa_{\mathrm{at}}\); hence its literal residue is \(K_{\mathrm{res}}=-\kappa_{\mathrm{at}}\). | KKPY Definition 3.12, printed p. 21; the A-model connection (3.30), printed p. 31; the cubic connection (6.9) in the proof of Theorem 6.8, p. 69. The sign reconciliation is recorded below; no new theorem is imported. |
| A14 | **Internal `cubicBasicHodge`.** The proof uses only \(h^{3,1}(X)=1\) and the elementary ambient Hodge dimensions needed for the five hyperplane powers; the full Hodge diamond is not a theorem hypothesis. | Hassett §2.1, pp. 3–4, supplies proof material. The finite dimension and coefficient deductions are internal. |
| A15 | On a reduced affinoid rigid space, an analytic function or matrix which vanishes at every rigid point is zero. | Conrad, [local *Several approaches to non-archimedean geometry* PDF](../tmp/pdfs/conrad-nonarchimedean-geometry.pdf), Theorem 1.1.5 and the paragraph after Example 1.2.2, printed pp. 4–5; SHA-256 `5add29094b74385746c4d977290b2308d02cbe8aa6f085e6a99724f6939e309b`. This is internalized as the reduced-Jacobson lemma in `ATOM_CORE.md` §7. |

The elementary proof inputs are also named rather than silently folded into
matrix arithmetic: `foldedHodgePolynomial_projectiveSpace_four`,
`foldedHodgePolynomial_point`, `curve_foldedHodge_coeff_two_eq_zero`,
`surface_foldedHodge_coeff_two_eq_pg`, `c1_tangent_cubicFourfold`,
`integral_hyperplane_pow_four`, and `beauvilleCubicLineCorrections`. Popa
§ 1.1, equation (1.1.1), and the projective-space example (pp. 2–3) support
the first four; Peters pp. 5–6 supports the surface notation; Beauville § 2
and Hassett § 2.1 support the final three. Their exact hashes are displayed
above or in `ATOM_CORE.md` §§ 9–11.

An **isomorphism of cover-native data** means an isomorphism of connected
base germs, an isomorphism of their finite-étale cover components over the
base map preserving the tautological eigenvalue, and a grading-preserving
Hodge-equivariant vector-bundle isomorphism intertwining the Euler operator,
multiplication, and distinguished unit. This preserves cover degree,
\(P_\alpha\), and \(\rho_\alpha\); it is the relation used below.

A connected component of a finite étale cover has open-and-closed nonempty
image in the connected base, hence is surjective. This deduction replaces the
older clause that assumed component surjectivity inside A5.

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

**Coefficient-ring typing.** The analytic bundle lives over
\(S\times D_u\) with structure sheaf \(\mathcal O_{S\times D_u}\); its
restriction at \(u=0\) is a finite locally free \(\mathcal O_S\)-module. Only
its formal completion along \(u=0\) is modeled over \(\mathcal O_S[[u]]\).
The load-bearing lemma below uses the analytic \(\mathcal O_S\)-module.

### Historical WP-0.6 full-base uniqueness audit — non-normative

**WP-3 status.** This entire subsection is retained only as an audit trail. It
is not a lemma, is not imported by Proposition 3.3, and has no edge to the
current proof. Its full-base/maximal formulation and references to HYZZ
Theorem 3.42 and A12 are superseded by Lemma 3.2 immediately below.

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
M=(\mathcal H|_{u=0})_b=\bigoplus_iM_i,\qquad
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

### Lemma 3.2 — fixed-base primary projectors at \(u=0\) (R2)

Let \(\mathbb K\) be an algebraically closed non-archimedean field of
characteristic zero. Let \(S\) be a connected smooth analytic germ at \(b\),
let \(G\) act trivially on \(S\), and let
\(\mathcal H_0:=\mathcal H|_{u=0}\) be a finite locally free
\(\mathcal O_S\)-module. Let
\(K_{\mathrm{res}}\in\operatorname{End}_{\mathcal O_S}(\mathcal H_0)\)
commute with the rational \(G\)-action. Suppose

\[
(\mathcal H_0)_b=\bigoplus_{\lambda\in\Lambda}H_b^\lambda
\]

is a primary decomposition for \(\kappa_{\mathrm{at},b}\), with pairwise
coprime block characteristic polynomials. Equivalently these are the
\(-\lambda\)-blocks of \(K_{\mathrm{res},b}\). Then, after shrinking \(S\):

1. there is a unique complete family of orthogonal analytic idempotents
   \(e_{\lambda,0}\) commuting with \(K_{\mathrm{res}}\) and lifting the
   displayed blocks;
2. their images give a direct sum over the **same** base \(S\);
3. every projector and summand is \(G\)-equivariant; and
4. at \(b\),
   \[
   (H_b^\lambda)^G=((\mathcal H_0)_b^G)^\lambda.
   \]

There is no assertion about full-\(u\) horizontality, maximality, or a product
base.

**Proof.** The analytic local ring \(R=\mathcal O_{S,b}\) is Henselian by
Berkovich Theorem 2.1.5 (also Fresnel–van der Put Proposition 7.1.8(1)).
Factor the characteristic polynomial of \(K_{\mathrm{res}}\) uniquely into
monic lifts \(F_\lambda\) of the pairwise coprime closed-fiber block
polynomials. Pairwise resultants remain units. For
\(G_\lambda=\prod_{\mu\ne\lambda}F_\mu\), choose Bézout polynomials
\(a_\lambda F_\lambda+b_\lambda G_\lambda=1\) and set

\[
e_{\lambda,0}=b_\lambda(K_{\mathrm{res}})
G_\lambda(K_{\mathrm{res}}).
\]

CRT and Cayley–Hamilton give a complete orthogonal family whose image is
\(\ker F_\lambda(K_{\mathrm{res}})\). Unit-resultant Sylvester maps kill the
off-diagonal blocks of any competing lift, and Nakayama forces its diagonal
idempotents to be the required identity or zero; hence the family is unique.
The finitely many matrix entries and identities are represented on one common
analytic shrink, proving (1) and (2).

Transport by \(G\) gives another commuting family lifting the same blocks, so
uniqueness proves (3). Equivariance then gives

\[
(H_b^\lambda)^G
=e_{\lambda,0}((\mathcal H_0)_b^G)
=((\mathcal H_0)_b^G)^\lambda,
\]

and Lemma 3.1 shows that invariants preserve the complete direct sum. ∎

### Proposition 3.3 — pointwise localization of an atom

Retain Lemma 3.2 and put \(S=B^G\). Assume in addition that

1. \(U_X\subset S\) is dense and open;
2. the reduced \(\kappa_{\mathrm{at}}\)-spectral cover
   \(\pi:\widetilde U_X\to U_X\) is finite étale;
3. \(U_X\) is connected; and
4. the raw point factors on \(C_\alpha\) carry the data used to define the
   blowup-Hodge atom
   \(\alpha\) as in
   A5 and A11.

Let \(W\subset S\) be a connected neighborhood of \(b\) on which the
equivariant cluster splitting is defined. Then every \(C_\alpha\) has a
point \(x\) above \(W\cap U_X\). Its atomic germ lies in one local cluster
\(\lambda(\alpha,x)\), and

\[
\rho_\alpha\le
\operatorname{rank}((\mathcal H^\lambda)|_{u=0})^G.
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
\(W\cap U_X\ne\varnothing\). The image of a connected component
\(C_\alpha\) under a finite étale map is nonempty, open (étaleness), and
closed (finiteness). Connectedness of \(U_X\) therefore makes
\(C_\alpha\to U_X\) surjective, so there is an \(x\in C_\alpha\) above this
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

**Proof.** Choose \(b\in U_X\). Proposition 3.3's cover CRT, applied to the
Hodge realization and raw grading supplied by A1/A11, gives the cover-native
primary decomposition

\[
\mathcal H_{(b,0)}
=\bigoplus_{x\in\widetilde U_{X,b}}\mathcal A_x.
\]

Finite étaleness gives \(\#C_b=\deg(C/U_X)\). All points of a connected
component \(C\) give the same Hodge representation by Lemma 3.1 and A5.
Taking ordinary \(p-q\) weight dimensions in the displayed direct sum gives
the first identity; taking Hodge-group invariants, which is exact by Lemma
3.1, gives the second. Regrouping all components which represent the same
blowup-Hodge atom gives \(m_X(\alpha)\). In particular, this sum-of-degrees
convention cannot be replaced by the degree of one component after an
automorphism quotient.
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
component, and its unique generalized eigenspace is the full fiber. A1 gives
that fiber as the Betti Hodge representation, with the action and grading
from A11. ∎

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
middle Hodge classes are \(\mathbf Qh^2\), where
\(h=c_1(\mathcal O_X(1))\), by A8. The degree-four fixed-vector clause of
A11 and the internal elementary cubic Hodge data A14 identify the complete
fixed subspace as

\[
\mathcal H_{(b,0)}^{\mathsf{Hod}}
=\bigoplus_{i=0}^4\mathbb K h^i.
\]

Let \((\mathcal H,\nabla)/B_X\) be the analytic A-model bundle from A1. No
maximality property is used.

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

### R2 — restrict to the fixed germ, then split by separated projectors

**Before (KKPY p. 70):** “By the spectral decomposition theorem Theorem
4.1 … the A-model F-bundle \((\mathcal H,\nabla)/B_X^{\mathsf{Hod}}\)
decomposes into an external direct sum of maximal F-bundles.”

**After WP-4:** First restrict the rank-27 analytic connection from A1 to
\(S=B_X^{\mathsf{Hod}}\). No maximality assertion is made or needed on this
five-dimensional base.

1. The primary generalized-eigenspace blocks of
   \(\kappa_{\mathrm{at},b}\) indexed by \(\Lambda\) have pairwise disjoint
   spectra. By A13 the residue blocks are the same blocks labelled by
   \(-\Lambda\).
2. Restrict to the analytic bundle \(\mathcal H_0=\mathcal H|_{u=0}\).
   Berkovich's theorem makes \(\mathcal O_{S,b}\) Henselian. Lemma 3.2/HP
   factors the characteristic polynomial of \(K_{\mathrm{res}}\), applies
   CRT, and gives four canonical analytic commuting projectors after one
   shrink of \(S\). No completion or convergence in \(u\) is invoked.
3. Since the Hodge group acts trivially on \(S\) and equivariantly on
   \(K_{\mathrm{res}}\), transporting a projector gives another lift of the
   same closed block; Henselian uniqueness makes all four projectors
   Hodge-equivariant. A12 and the older moving-base argument are not used.
4. The hypotheses of Proposition 3.3 hold: by A5,
   \(B_X^{\mathsf{Hod}}\) is a connected smooth analytic base, and \(U_X\) is
   its dense nonempty Zariski-open maximal-eigenvalue locus (density is stated
   explicitly for this cubic in the proof of KKPY Theorem 6.8, printed p. 70),
   and \(\widetilde U_X\to U_X\) is finite étale. A connected smooth analytic
   base is irreducible, so its nonempty Zariski-open \(U_X\) is connected.
   Every cover component is then surjective because its image is nonempty,
   open, and closed. A11 gives the raw action, grading, and cover data;
   Proposition 3.3's CRT constructs the pointwise primary factors and their
   cover-native bundles, while Corollary 3.4 proves the numerical atom
   bookkeeping. Thus every atom is represented in one of the four local
   clusters.

At the repaired point, the compatibility with invariants is

\[
(H_b^\lambda)^{\mathsf{Hod}}
=(\mathcal H_{(b,0)}^{\mathsf{Hod}})^\lambda
=\left(\bigoplus_{i=0}^4\mathbb K h^i\right)^\lambda.
\]

This is the conclusion needed from the printed proof's invalid application of
KKPY Theorem 4.1. Whole HYZZ Theorem 3.42, full-\(u\) convergence,
full-base maximality, and maximality of the factors are absent.

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

so \(P_1(S)=p_g(S)>0\), and hence \(\kappa(S)\ge0\) by definition. By A9,
contract finitely many \((-1)\)-curves to the smooth projective minimal model \(S_{\min}\), where
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
eigenspace is therefore the entire A1 fiber; with the A11 action, its
representation is

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

**After:** Hassett Definition 3.1.1 and Theorem 3.1.2 (artifact pp. 7–8)
show that cubics with a middle integral Hodge lattice of rank at least two lie
in a countable union of proper algebraic Hodge divisors. Pull those loci back
to the smooth locus \(\mathcal U\subset\mathbf P^{55}\) of cubic equations
and take their closures \(D_n\) in \(\mathbf P^{55}\). Each closure is
proper, and \(D_n\cap\mathcal U\) is the original relatively closed pullback.
Outside \(\bigcup_nD_n\), clearing denominators gives

\[
H^{2,2}(X)\cap H^4(X,\mathbf Q)=\mathbf Qh^2.
\]

Together with the internal elementary cubic Hodge data A14, this is precisely
the fixed-subspace generality used above. The repaired argument applies to
every parameter in this complement.

No Torelli theorem, irreducibility of Hassett divisors, discriminant
irreducibility, or transcendental-irreducibility locus is consumed. This
proves the stated parameter-space very-general theorem. ∎

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
shasum -a 256 tmp/pdfs/2508.05105v2.pdf tmp/pdfs/berkovich-etale-cohomology.pdf tmp/pdfs/fresnel-van-der-put-rigid-analytic-geometry.pdf tmp/pdfs/2411.02266.pdf tmp/pdfs/vezzani-nonarch-implicit-function.pdf tmp/pdfs/2307.13555.pdf tmp/pdfs/2604.10028v2.pdf tmp/pdfs/beauville-quantum-complete-intersections.pdf tmp/pdfs/peters-surface.pdf tmp/pdfs/popa-hodge-theory-singularities.pdf tmp/pdfs/givental-eqv.pdf tmp/pdfs/hassett-special-cubic-fourfolds.pdf tmp/sources/v2/brinv.tex
rg -n 'thm:cubic4|thm:K-decomposition|lem:Ginvariants|lem:nefK|prop:non-rational' tmp/sources/v2/brinv.tex
```

## 7. Certificate boundary

- R1, R3, R4, and R5 are closed by explicit substitutions and arguments.
- R2 is closed by the internal Henselian Primary-Projector Theorem, Lemma 3.1,
  and Proposition 3.3, relative only to the analytic bundle in `GW-1` and the
  raw cover/Hodge data in `HATOM-RAW`. No projector-convergence interface
  survives.
- The stronger claim that one global spectral-cover component has one local
  cluster label is expressly not certified; it is false in general and
  unnecessary.
- The single current interface table is `GW_INPUT.md`. It exposes exactly six
  top-level opaque packages: `GW-1`, `GW-3`, `WF-4`, `HATOM-RAW`, `NL-CUBIC`,
  and `SURF-MIN`. A4/`GW-2` is an internal F2 theorem.
- Whole HYZZ Theorem 3.42, full-base maximality, A12's moving-base action,
  projective-bundle atom relations, KKPY Proposition 5.30, a separate
  imported nef-\(K\) lemma, primitive-class vanishing, and deformation
  invariance are not target interfaces.
- N1–N8 and the WP-1–WP-4 reductions are incorporated. The full formal spine,
  source pins, and Mathlib gap list are in `ATOM_CORE.md`; the parameter-space
  Lean target is in `GENERALITY.md`. No WP-5 assembly, author contact, or Lean
  implementation is included.
