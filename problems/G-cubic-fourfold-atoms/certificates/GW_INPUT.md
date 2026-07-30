# Theorem 6.8 — single trusted-interface table

**Date:** 2026-07-29  
**Work orders:** WP-1, consolidated and minimized through WP-4
**Status:** WP-4 complete at worker scope; **STOP at director review before WP-5**

## 1. Consolidated result

This is the program's **one table of record**. It contains the three
Gromov--Witten rows isolated in WP-1, the weak-factorization package from
WP-2, and the three Hodge/terminal packages. Of its seven rows, `GW-2` is an
internal F2 theorem to formalize; the other six are the only opaque packages
in the top theorem of
[`ATOM_CORE.md`](ATOM_CORE.md).

WP-4 retires `SEP-CONV`: the analytic local ring at the rigid point is
Henselian, so characteristic-polynomial factorization and CRT produce the
canonical analytic projectors at $u=0$. Those are all the target consumers
read. The cubic connection is restricted to the five-dimensional Hodge-fixed
germ **before** it is split. Full-base maximality, the moving-base group-germ
argument, HYZZ convergence, and HYZZ's product-base conclusion are not
consumed by R2.

No primitive-class invariant, deformation-invariance theorem,
projective-bundle theorem, general Givental mirror theorem, imported nef-\(K\)
atom lemma, or full HYZZ theorem remains on the target path.

The cost scale is: F0 finite exact computation; F1 elementary formal argument;
F2 substantial but target-specific mathematics; F3 major foundational theory.

## 2. Definitive interface table

| ID | Tight statement actually consumed | Hash-pinned source | Exact use-sites in the repaired certificate | Honest minimal special case | Independent verification route | Cost | Lean-phase recommendation |
|---|---|---|---|---|---|---|---|
| GW-1 | For every smooth projective complex variety \(Y\) used in the argument, of dimension at most four, the genus-zero potential is analytic on the non-archimedean ample tube and defines the flat analytic A-model matrices with fiber \(H^\bullet_B(Y)\). The fixed germ and matrices are Hodge-equivariant, and on \(\mathcal H\vert_{u=0}\) the Hodge group acts by **unital algebra automorphisms** preserving the quantum product and Euler field. The product obeys the virtual-dimension grading and genus-zero unit/fundamental-class rule. For the cubic, the rank-27 connection restricts to the smooth connected five-dimensional fixed germ at \(b=(q_0,t=0)\). | KKPY arXiv:2508.05105v2, §3.5.1, Definition 3.25, Definition 3.32, Proposition 3.40, Definition 3.52; the algebra-action clause used in Lemma 5.19 is in `tmp/sources/v2/brinv.tex`, lines 3336–3344 (printed p. 57). [Local PDF](../tmp/pdfs/2508.05105v2.pdf), SHA-256 `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64`; source TeX SHA-256 `ec121169ccbe2d5ebd296a3b5b10cf3cb4f19488f09398b1d5cd57a7bee6a8ed`. | A1 and R1 instantiate the analytic matrices and admissible point; R2 splits \(U_0\) on their fixed-base restriction by the internal Henselian theorem; Lemma 5.19/A2 uses the now-explicit algebra-automorphism clause; Lemma 3.6 uses grading and the unit rule. | Only \(X,\mathbf P^4\), factorization fourfolds/centers, and surfaces/point blowups on R5. Full-base maximality is source data but is not consumed. | [Kontsevich--Manin](https://arxiv.org/abs/hep-th/9402147) checks the formal genus-zero axioms and WDVV conditional on GW classes, but not the non-archimedean analyticity or Hodge package. | F3 | **AXIOM-INTERFACE** for the stated analytic/Hodge data. **FORMALIZE (F1)** the algebra-action, grading, and unit deductions. Do not retain maximality as a theorem hypothesis. |
| GW-2 | For a smooth cubic fourfold \(X\subset\mathbf P^5\), small quantum multiplication by \(h\) on \((1,h,h^2,h^3,h^4)\) has exactly the corrections \((6,15,6)\): \(h\star h^2=h^3+6q\), \(h\star h^3=h^4+15qh\), and \(h\star h^4=6qh^2\). Equivalently, \(\ell_p=\frac13\int_{\operatorname{Gr}(2,6)}c_4(\operatorname{Sym}^3S^\vee)c_{3-p}(Q)c_{1+p}(Q)\). | Beauville, *Quantum cohomology of complete intersections*, equations (1.6), (2.1), and the Grassmannian coefficient lemma; [local PDF](../tmp/pdfs/beauville-quantum-complete-intersections.pdf), SHA-256 \(9d022796aefa01fd601820e415c5462bdfc255b3b4fe158af64b51f7bf0a83e3\). | A4; certificate Lemma 3.5; R1's matrix and spectrum; `ATOM_CORE.md` §§9–10; and the finite replay in Section 6 below. | Beauville's three target ambient invariants directly. No primitive insertion, other complete intersection, or separately exposed Fano-scheme expected-dimension theorem is needed. The Chern-root extraction and characteristic polynomial are F0. | Givental's Fano complete-intersection mirror theorem, specialized to \(n=5,l=3<5\), independently reproduces the same ambient ODE and matrix: [local PDF](../tmp/pdfs/givental-eqv.pdf), SHA-256 \(985248cc3e6e166b9847b01552de2034429a624794dc0c53cad50beb1f4b50c9\). This route is a cross-check, not an imported interface. | F2 | **FORMALIZE** the exact theorem `beauvilleCubicLineCorrections` directly from Beauville's calculation. The earlier stable-map/contracted-tail route and its hidden expected-dimension premise are dissolved; the matrix algebra is F0. |
| GW-3 | In exactly two cases—(i) a surface blown up at a point and (ii) a smooth projective fourfold blown up along a smooth center \(Z\) of dimension at most two—the analytic Hodge-equivariant atomic decomposition gives \(\operatorname{CF}_{\rm bl}(\operatorname{Bl}_Z Y)=\operatorname{CF}_{\rm bl}(Y)+(r-1)\operatorname{CF}_{\rm bl}(Z)\), where \(r=\operatorname{codim}_Y Z\), preserving the Hodge representations and their \(p-q\) grading. | These target cases of KKPY Theorem 4.5 and Proposition 5.22(2), in the same pinned v2 PDF. Their formal quantum-D-module input is Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3, Theorem 5.18; [local PDF](../tmp/pdfs/2307.13555.pdf), SHA-256 \(c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b\). Formal Hodge compatibility is supported by Iritani, *Notes on the decomposition theorem for blowups*, arXiv:2604.10028v2, Proposition 8 and Corollary 11; [local PDF](../tmp/pdfs/2604.10028v2.pdf), SHA-256 \(0114923576b2ec3a78fc346fd9f61eb65cfe63f8cc7087881d11626cdb9883c3\). Proposition 8 itself invokes HYZZ reconstruction, so it is not an independent escape from that machinery. | A6; the surface point-blowup passage in R5; and every step of certificate Proposition 3.7's weak-factorization telescope. | Exactly the two cases in the statement. No higher-dimensional case and no projective bundle is consumed. | Iritani is the source of KKPY's formal decomposition, and the *Notes* use HYZZ reconstruction, so neither is an independent cross-check. [Bayer](https://arxiv.org/abs/math/0403260) independently verifies a point-blowup semisimplicity/spectral shadow, but not the analytic Hodge-equivariant chemical formula. No complete independent route was found. | F3 | **AXIOM-INTERFACE.** Expose only the two target cases and the induced Hodge-graded atom correspondence. Do not formalize virtual localization/Fourier analysis inside the main development. |
| WF-4 | If a smooth projective complex fourfold \(X\) is birational to \(\mathbf P^4\), there is a finite chain through smooth projective complex fourfolds in which each step, in one orientation, is the blowup of a smooth irreducible center. Identity divisor blowups may be deleted, so every center has codimension at least two and dimension at most two. | AKMW, Theorem 0.1.1, internal pp. 1–2; [local PDF](../tmp/pdfs/akmw-torification-factorization.pdf), SHA-256 `55bbc2c58f29d4b9dbe965035f80f3844f6968eaf98076ac625132ac3b3977a5`. | A7; certificate Proposition 3.7 and its R4/R5 use. | Only the endpoint pair \(\mathbf P^4,X\), projective intermediates, and ordinary smooth-center blowups in both directions. | Włodarczyk's pinned proof independently checks smooth complete weak factorization but not AKMW's projective-intermediate clause; SHA-256 `2f7a0bce5871db86bf84f54c4562fc053c53a4313180a6eecb66587d21e4fcfe`. | F3 | **AXIOM-INTERFACE.** No strong/directed factorization and no arbitrary-morphism monotonicity. |
| HATOM-RAW | The Hodge group acts rationally and proreductively on the cohomological fiber data and supplies the \(p-q\) grading. The fixed Hodge base used for each target is connected and smooth/reduced; on a dense spectral locus its cover is finite étale and reduced. For a cubic, the degree-four fixed vectors are precisely the rational \((2,2)\)-classes; for a surface, the cycle classes \(1,c_1(L),[\mathrm{pt}]\) are fixed. | KKPY v2, Examples 5.5 and 5.7 (printed p. 49), the fixed-base and spectral-cover construction immediately before Definition 5.10 (p. 51), Lemma 5.25 (pp. 61–62), and Definition 5.26 (p. 62); same PDF/TeX hashes as GW-1. Proreductive semisimplicity: [Deligne–Milne](../tmp/pdfs/milne-tannakian-categories.pdf), Proposition 2.23 and Remark 2.28, SHA-256 `48f8af5249081217fc4a806414a764d9d69d66eff9092ddd8e2cf0ea078579e8`. | Internal Lemma 3.1, the Henselian characteristic-polynomial/CRT construction, Corollary 3.4, atom localization, the cubic fixed-space identification, and the three surface invariant classes. | Exactly the raw action/grading, fixed-base/cover geometry, cubic degree-four fixed-vector statement, and the three general surface cycle classes. Fiberwise primary decomposition is not imported: it is derived by CRT. Component surjectivity, exact invariants, rank constancy, \(\rho/P\) descent, and additivity are also internal. | Conrad's reduced-Jacobson input is separately pinned and internal: [local PDF](../tmp/pdfs/conrad-nonarchimedean-geometry.pdf), SHA-256 `5add29094b74385746c4d977290b2308d02cbe8aa6f085e6a99724f6939e309b`. | F3 raw Hodge package; F1/F2 deductions | **AXIOM-INTERFACE** only for the four clauses just listed. **FORMALIZE** proreductive exactness, Henselian/CRT projectors, cover bookkeeping, rank constancy, and descent. |
| NL-CUBIC | In the smooth cubic-form parameter space, the locus where the middle rational Hodge classes exceed \(\mathbf Qh^2\) is contained in a countable union of proper algebraic closed subsets (indeed Hassett divisors). Thus outside that union \(H^{2,2}(X)\cap H^4(X,\mathbf Q)=\mathbf Qh^2\). | Hassett, Definition 3.1.1 and Theorem 3.1.2, printed pp. 7–8; [local PDF](../tmp/pdfs/hassett-special-cubic-fourfolds.pdf), SHA-256 `ecc2e31a63f56d443aaa3534f0218b25a5b6ab6e1a84c82db5c7bac1789a1d21`. Pull the divisors back to the smooth locus of the projective space of cubic forms and take their closures in \(\mathbf P^{55}\); those closures are proper and have the same intersection with the smooth locus. | R4's very-general quantifier and the cubic fixed-space specialization in R1. | Only countability, proper closedness, and the rank-one middle rational Hodge conclusion. The coefficient \([t^2]=h^{3,1}=1\), the other elementary cubic Hodge numbers, and the ambient dimensions are internal `cubicBasicHodge` data, not part of this row. | No Torelli theorem, discriminant irreducibility, or transcendental irreducibility is consumed. | F3 Hodge-locus interface; finite dimension bookkeeping F0 | **AXIOM-INTERFACE** only for this minimal Hodge-locus statement; formalize the parameter-space pullback and coefficient deductions. |
| SURF-MIN | For a smooth projective surface, \(P_1=p_g\) and plurigenera are birational invariants. If a plurigenus is positive, a finite sequence of \((-1)\)-curve contractions leads to a smooth projective minimal model with nef canonical class; reversing the sequence gives ordinary point blowups. | Peters, definitions and Theorem 4.3, Propositions 2.1–2.2 and following discussion; [local PDF](../tmp/pdfs/peters-surface.pdf), SHA-256 `51f9c99621b3819aa85894a8cdee4a528b0894364fc22b40a651f1bae55ceed3`. | R5: pass from the selected surface to its nef minimal model and transport the selected non-point atom through the finite point-blowup chain. | No classification of surfaces. The nonzero classes \(1,c_1(L),[\mathrm{pt}]\) and their independence are internal Hodge/cycle lemmas. | The certificate avoids the false printed classification list. | F3 surface geometry; endpoint arithmetic F1 | **AXIOM-INTERFACE** for the finite contraction/minimal-model facts; formalize the GW-3 point-blowup telescope and three-class rank bound. |

## 3. Why the small product is still insufficient

The proof evaluates the Euler operator at \(t=0\), but it needs analytic
spectral factors on a neighborhood in the Hodge-fixed base in order to meet
every spectral-cover component. The small \(q\)-line supplies only the matrix
at the chosen point. The Henselian Primary-Projector Theorem applies directly
to \(\mathcal H|_{u=0}\) on the five-dimensional fixed germ.

Consequently:

- Fano grading and effectivity make the **small ambient product** polynomial
  in \(q\), but that proves only the value of the operator at \(b\).
- Analyticity on the fixed germ is consumed to interpret the local-ring CRT
  projectors as germs and then spread them after shrinking.
- The fiberwise Hodge action is still consumed, but uniqueness—not a
  moving-base argument—makes the fixed-base projectors equivariant.
- Full-base maximality is no longer consumed by R2.

The remaining analytic A-model facts stay bundled in GW-1. No convergence of
full-\(u\) horizontal projectors is used. The stronger formal and convergence
audits in `ATOM_CORE.md` §§ 4–5 are retained only as non-load-bearing work.

## 4. Deletions and internal derivations

### D1. General Givental/quantum-Lefschetz theorem — DELETE

The only use was the \(5\times5\) ambient matrix now supplied by GW-2 and
proved in certificate Lemma 3.5. The general theorem for Fano
complete intersections is strictly stronger. Its cubic specialization remains
an independent check of \(6,15,6\), not a premise.

### D2. Primitive-class vanishing (KKPY Lemma 6.11) — DELETE

The proof of Theorem 6.8 ends with R4's very-general conclusion. Lemma 6.11
appears only in the explicitly downstream consistency note and supplies no
edge to R1–R5.

The printed proof names a virtual-dimension count, the ambient nature of
\(h\) and the possible test class \(\psi\), and classical primitivity. Those
facts do not justify its final implication from an ambient classical cup
product vanishing to the vanishing of a positive-degree GW invariant. Thus
the printed proof does **not** run verbatim at \(q_0\) (or at \(q=1\)). It
does not explicitly use a divisor or deformation-invariance axiom; rather, it
is missing the positive-degree bridge supplied by the following replacement.

If the downstream lemma is later formalized, its conclusion at
\(q=q_0\) follows from cheaper existing data. For a primitive
\(\phi\in H^4_{\rm prim}(X)\), grading leaves only the classical and
degree-one parts of \(h\star\phi\). The classical part is
\(h\smile\phi=0\). The degree-one part is scalar, and Frobenius symmetry plus
Lemma 3.5 gives

\[
\langle h\star\phi,h^4\rangle
=\langle\phi,h\star h^4\rangle
=6q_0\langle\phi,h^2\rangle=0.
\]

Thus no standalone primitive GW vanishing, divisor axiom, or deformation
argument is needed. The printed inference from “the other insertions are
ambient” is not used as a proof interface.

### D3. Deformation invariance — DELETE

There is no family transport use-site. The argument fixes one smooth cubic
\(X\); GW-2 applies to every such \(X\), and R4 varies \(X\) only to state the
Noether--Lefschetz complement. No invariant is moved between fibers.

Beauville's proof of the all-smooth complete-intersection statement invokes
smooth-deformation invariance internally to reduce its line count to a general
member. That theorem-internal premise is absorbed into the target statement
GW-2; it is not a separate family-transport API consumed by the certificate.
A direct Lean proof of GW-2 may instead formalize the degree-one stable-map/
line-incidence description for a smooth cubic.

### D4. Small-\(q\) convergence/polynomiality as a separate axiom — DELETE

The degree rule inside Lemma 3.5 proves that the required small product has no
curve-degree-\(\ge2\) terms. That is enough for R1 but not R2. Analyticity on
the fixed germ remains inside GW-1; Henselian \(u=0\) effectivity is internal,
and small polynomiality is not another row.

### D5. Separate WDVV, divisor, smoothness, and Hodge rows — MERGE

Flatness/WDVV, the Novikov/divisor structure, smoothness, and Hodge
equivariance are different construction steps but the certificate consumes
them as one A-model object. They remain the single GW-1 package. Maximality and
full-\(u\) projector convergence have no target use-site; the \(u=0\) split is
internal.

### D6. Imported nef-\(K\) one-atom lemma — DERIVE, THEN DELETE

KKPY Lemma 5.24 is replaced by certificate Lemma 3.6. Virtual
dimension and the unit axiom imply that every quantum-product term weakly
raises cohomological degree when \(K_Y\) is nef. Hence
\(\operatorname{Eu}\star=-t_0\operatorname{id}+N\) with \(N\) strictly
degree-raising and nilpotent. The reduced spectrum has one element and the
whole fiber is the unique atom. This is F1 once the product exposed by GW-1 is
available; recommendation: **FORMALIZE**.

### D7. Projective-bundle decomposition and Iritani--Koto — DELETE

The certificate uses a finer quotient, the blowup-Hodge atoms, which imposes
only isomorphism/same-component, disjoint-union, and blowup correspondences.
It does not impose projective-bundle equivalence. Certificate Proposition 3.7
telescopes GW-3 along weak factorization. Since
\(\operatorname{HP}_{\rm fold}(\mathbf P^4;t)=5\), no atom of
\(\mathbf P^4\) has positive \(t^2\)-coefficient; the selected cubic atom must
therefore occur in a factorization center of dimension at most two. This
proves exactly the former use of the projective-bundle input without it.

Accordingly KKPY Theorem 4.11 and Iritani--Koto's projective-bundle theorem
are absent from the permanent interface.

### D8. KKPY Proposition 5.30 — DERIVE TARGET CASE, THEN DELETE

The general non-rationality criterion is replaced by certificate Proposition
3.7 and its final use in R5. The replacement consumes GW-3 and WF-4, GW-1 for
the A-model objects on intermediate varieties and centers, HATOM-RAW for their
atoms and weights, Corollary 3.4 for nonnegative folded-Hodge additivity, and
the internal identity \(\operatorname{HP}_{\rm fold}(\mathbf P^4;t)=5\).

### D9. Disjoint-union additivity — DELETE FROM GW

The chemical formula of a disconnected variety is componentwise by
definition; see Corollary 3.4 and the opening of R5. No enumerative theorem is
imported for this.

## 5. Atom-formalism census

| KKPY item in the work-order census | Classification after minimization |
|---|---|
| Definition 5.21 | Isomorphism and same-spectral-component bookkeeping for cover-native atomic data. Formal once GW-1 and the internal Henselian primary-projector/cover CRT construction provide the \(u=0\) local bundles. F1, **FORMALIZE**. |
| Proposition 5.22 | Item (1), disjoint union, is F0/formal. Item (2), smooth blowup, is exactly GW-3/F3. Item (3), projective bundle, is deleted by D7. |
| Proposition 5.23 | Its representation-local-constancy proof is not trusted for cover degree \(>1\); certificate Lemma 3.1 supplies the needed cover-native statement. Non-GW F1, **FORMALIZE**. |
| Lemma 5.24 | Replaced by certificate Lemma 3.6 as in D6. No surviving GW row beyond the already-exposed product in GW-1. F1, **FORMALIZE**. |
| Definition 5.26 and Remark 5.27 | Formation of \(P_\alpha(t)=\sum_d\dim(E_d^\alpha)t^d\) from ordinary grading-weight dimensions and, separately, \(\rho_\alpha=\dim(E^\alpha)^G\) from Hodge-group invariants is formal bookkeeping. F1, **FORMALIZE**. Weight spaces are not assumed $G$-stable. |
| Proposition 5.30 | Deleted and replaced by target-specific Proposition 3.7. Its weak-factorization premise is non-GW and belongs to WP-2; its blowup premise is GW-3. |
| Proposition 5.28 (mislisted as “Proposition 5.31” in WORKORDER_1) | Every Hodge atom satisfies \(\rho_\alpha\ge1\), because its nonzero unital atom algebra contains the Hodge-fixed unit. This is Proposition 5.28, source label `prop:Ginv1`, pinned-v2 printed p. 62 (`tmp/sources/v2/brinv.tex`, lines 3576–3583). It is F1, **FORMALIZE**. It is not consumed by the repaired proof of Theorem 6.8; its paper use is downstream in Corollary 6.12, so it contributes no permanent interface. |

The non-GW inheritance is costed separately:

| Non-GW item | Cost and Lean recommendation |
|---|---|
| Formal part formerly imported through HYZZ | The separated horizontal-projector theorem over \(k[[t_1,\ldots,t_n]][[u]]\) is proved in `ATOM_CORE.md` §4. F2 infrastructure, **FORMALIZE**, but non-load-bearing for Theorem 6.8. |
| Certificate Lemma 3.1 | F1 semisimple-representation and base-change argument; **FORMALIZE**. |
| Certificate Lemma 3.2 | F2 Henselian factorization, CRT, uniqueness, equivariance, and analytic spreading on \(\mathcal H\vert_{u=0}\); **FORMALIZE**. |
| Certificate Proposition 3.3 | F2 finite-étale spectral-cover/CRT localization and rank bound; **FORMALIZE**. |
| A2, A13, A15, Corollary 3.4, Lemmas 3.5–3.6, Proposition 3.7 | All are internal F0/F1/F2 nodes; exact statements, proofs, and file homes are in `ATOM_CORE.md`. |

These are finite-free-module splitting, representation theory, cover CRT, and
linear algebra over formal/analytic local rings. No F-bundle abstraction is
needed in the formal core.

## 6. Source and finite replay

The source pins used by this audit replay as:

~~~sh
shasum -a 256 \
  tmp/pdfs/2508.05105v2.pdf \
  tmp/sources/v2/brinv.tex \
  tmp/pdfs/beauville-quantum-complete-intersections.pdf \
  tmp/pdfs/2307.13555.pdf \
  tmp/pdfs/2604.10028v2.pdf \
  tmp/pdfs/akmw-torification-factorization.pdf \
  tmp/pdfs/berkovich-etale-cohomology.pdf \
  tmp/pdfs/fresnel-van-der-put-rigid-analytic-geometry.pdf \
  tmp/pdfs/2411.02266.pdf \
  tmp/pdfs/vezzani-nonarch-implicit-function.pdf \
  tmp/pdfs/milne-tannakian-categories.pdf \
  tmp/pdfs/conrad-nonarchimedean-geometry.pdf \
  tmp/pdfs/hassett-special-cubic-fourfolds.pdf \
  tmp/pdfs/peters-surface.pdf \
  tmp/pdfs/popa-hodge-theory-singularities.pdf
~~~

Expected ordered digests:

~~~text
2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64  tmp/pdfs/2508.05105v2.pdf
ec121169ccbe2d5ebd296a3b5b10cf3cb4f19488f09398b1d5cd57a7bee6a8ed  tmp/sources/v2/brinv.tex
9d022796aefa01fd601820e415c5462bdfc255b3b4fe158af64b51f7bf0a83e3  tmp/pdfs/beauville-quantum-complete-intersections.pdf
c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b  tmp/pdfs/2307.13555.pdf
0114923576b2ec3a78fc346fd9f61eb65cfe63f8cc7087881d11626cdb9883c3  tmp/pdfs/2604.10028v2.pdf
55bbc2c58f29d4b9dbe965035f80f3844f6968eaf98076ac625132ac3b3977a5  tmp/pdfs/akmw-torification-factorization.pdf
bd864c89ed8b6e8f27a90f459837221549db75afa75554ab51414e17771066af  tmp/pdfs/berkovich-etale-cohomology.pdf
54bac91f89abcd9a42645b1a07624222aeb570048ed224e4cd79a328fd7ef915  tmp/pdfs/fresnel-van-der-put-rigid-analytic-geometry.pdf
a11a093f790890804c7d4f7559b30ed2a6da87811de46f2aa0d29026e343e6bd  tmp/pdfs/2411.02266.pdf
bf53f2958e17de3ece49c27d433f98f9a55086fedd4c7cbb65e9bb15682e8f4d  tmp/pdfs/vezzani-nonarch-implicit-function.pdf
48f8af5249081217fc4a806414a764d9d69d66eff9092ddd8e2cf0ea078579e8  tmp/pdfs/milne-tannakian-categories.pdf
5add29094b74385746c4d977290b2308d02cbe8aa6f085e6a99724f6939e309b  tmp/pdfs/conrad-nonarchimedean-geometry.pdf
ecc2e31a63f56d443aaa3534f0218b25a5b6ab6e1a84c82db5c7bac1789a1d21  tmp/pdfs/hassett-special-cubic-fourfolds.pdf
51f9c99621b3819aa85894a8cdee4a528b0894364fc22b40a651f1bae55ceed3  tmp/pdfs/peters-surface.pdf
28cce3fa0cbd3c25491d1416f8e40a89362b6b1c14420789b3cd83e9c3f7f860  tmp/pdfs/popa-hodge-theory-singularities.pdf
~~~

The two F0 checks are recorded verbatim in `REPAIRED_PROOF.md`, Section 6. They
return \([6,15,6]\) and
\(\lambda^5-729\lambda^2q=\lambda^2(\lambda^3-3^6q)\).

## 7. Program exposure and gate

The top theorem now has exactly six opaque packages:
`GW-1`, `GW-3`, `WF-4`, `HATOM-RAW`, `NL-CUBIC`, and `SURF-MIN`.
`GW-2` and every other F0/F1/F2 item are internal to the
formalization spine. Whole HYZZ Theorem 3.42 and full-base maximality are not
on the dependency graph.

**STOP.** Director review should check the six-package closure and the Lean
target in `GENERALITY.md`. WP-5 begins only after that gate.
