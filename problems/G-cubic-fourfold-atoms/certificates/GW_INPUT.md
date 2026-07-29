# Theorem 6.8 — minimal Gromov--Witten input

**Date:** 2026-07-29  
**Work order:** WP-1  
**Status:** complete at worker scope; **STOP at director review before WP-2**

## 1. Binary result

The repaired proof has exactly **three** surviving Gromov--Witten interfaces.
Two are irreducibly heavy F3 axiom interfaces. The remaining cubic-specific
enumerative input is F2 and should be formalized. No primitive-class invariant,
deformation-invariance theorem, projective-bundle theorem, general Givental
mirror theorem, or imported nef-\(K\) atom lemma remains on the target path.

The cost scale is: F0 finite exact computation; F1 elementary formal argument;
F2 substantial but target-specific mathematics; F3 major foundational theory.

## 2. Definitive surviving interface

| ID | Tight statement actually consumed | Hash-pinned source | Exact use-sites in the repaired certificate | Honest minimal special case | Independent verification route | Cost | Lean-phase recommendation |
|---|---|---|---|---|---|---|---|
| GW-1 | For every smooth projective complex variety \(Y\) used in the argument, of dimension at most four, the genus-zero potential is analytic on the non-archimedean ample tube and its third derivatives define a flat analytic A-model F-bundle with fiber \(H^\bullet_B(Y)\). The maximal slice \(B_Y\) is smooth; Euler multiplication and the connection are Hodge-equivariant. The product obeys the virtual-dimension grading and the genus-zero unit/fundamental-class axiom. For the cubic \(X\), this is the **full rank-27 big germ** at \(b=(q_0,t=0)\), not merely the small \(q\)-line or the rank-5 Hodge-fixed locus. | KKPY arXiv:2508.05105v2, §3.5.1 and Definition 3.25 for virtual dimension and the unit axiom, then Definition 3.32, Proposition 3.40, Definition 3.52, and the construction around Lemma 3.29; [local PDF](../tmp/pdfs/2508.05105v2.pdf), SHA-256 \(2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64\). Source TeX SHA-256 \(ec121169ccbe2d5ebd296a3b5b10cf3cb4f19488f09398b1d5cd57a7bee6a8ed\). | A1 at line 57; the admissible ample-tube point at lines 628–631; bundle instantiation at lines 612–613; full-base maximality and Hodge equivariance needed by HYZZ at lines 680–693. The same package underlies the atom fibers and the grading/unit argument of Lemma 3.6, lines 509–561. | Only \(Y=X,\mathbf P^4\), the smooth fourfolds and centers in a weak factorization, and the surfaces/point blowups reached in R5. The full big germ is required only for the cubic HYZZ step, but the A-model/atom construction is still needed for every listed \(Y\). | [Kontsevich--Manin](https://arxiv.org/abs/hep-th/9402147) independently checks the formal genus-zero axioms and the WDVV/flatness package conditional on GW classes. It does **not** independently establish KKPY's non-archimedean analyticity, maximal slice, or Hodge-equivariance. No complete independent route was found. | F3 | **AXIOM-INTERFACE** for existence, analyticity, flatness, maximality, and Hodge equivariance. **FORMALIZE (F1)** the virtual-dimension and unit-axiom deductions exposed to Lemma 3.6. Do not split the heavy construction into several permanent axioms. |
| GW-2 | For a smooth cubic fourfold \(X\subset\mathbf P^5\), small quantum multiplication by \(h\) on \((1,h,h^2,h^3,h^4)\) has only the degree-one corrections \(\ell_0,\ell_1,\ell_2=(6,15,6)\): \(h\star h^2=h^3+6q\), \(h\star h^3=h^4+15qh\), and \(h\star h^4=6qh^2\). Equivalently, \(\ell_p=\frac13\int_{\operatorname{Gr}(2,6)}c_4(\operatorname{Sym}^3S^\vee)c_{3-p}(Q)c_{1+p}(Q)\). | Beauville, *Quantum cohomology of complete intersections*, equations (1.6), (2.1), and the Grassmannian coefficient lemma; [local PDF](../tmp/pdfs/beauville-quantum-complete-intersections.pdf), SHA-256 \(9d022796aefa01fd601820e415c5462bdfc255b3b4fe158af64b51f7bf0a83e3\). | A4 at line 60; derivation and exact expansion in Lemma 3.5, lines 444–507; the only theorem-level use is the R1 matrix and spectrum, lines 633–672. The two finite replays are at lines 884–908. | Three genus-zero, degree-one ambient line-incidence numbers for a cubic fourfold. No primitive insertion and no other complete intersection is needed. Once Beauville's formula is admitted, the Chern-root coefficient extraction and characteristic polynomial are F0. | Givental's Fano complete-intersection mirror theorem, specialized to \(n=5,l=3<5\), independently reproduces the same ambient ODE and matrix: [local PDF](../tmp/pdfs/givental-eqv.pdf), SHA-256 \(985248cc3e6e166b9847b01552de2034429a624794dc0c53cad50beb1f4b50c9\). This route is a cross-check, not an imported interface. | F2 | **FORMALIZE.** State the three target invariants directly; formalize the degree-one stable-map/line-incidence identification and the Grassmannian coefficient extraction. The matrix algebra is F0. Keep the general mirror theorem outside the trusted boundary. |
| GW-3 | In exactly two cases—(i) a surface blown up at a point and (ii) a smooth projective fourfold blown up along a smooth center \(Z\) of dimension at most two—the analytic Hodge-equivariant atomic decomposition gives \(\operatorname{CF}_{\rm bl}(\operatorname{Bl}_Z Y)=\operatorname{CF}_{\rm bl}(Y)+(r-1)\operatorname{CF}_{\rm bl}(Z)\), where \(r=\operatorname{codim}_Y Z\), preserving the Hodge representations and their \(p-q\) grading. | These target cases of KKPY Theorem 4.5 and Proposition 5.22(2), in the same pinned v2 PDF. Their formal quantum-D-module input is Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3, Theorem 5.18; [local PDF](../tmp/pdfs/2307.13555.pdf), SHA-256 \(c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b\). Formal Hodge compatibility is supported by Iritani, *Notes on the decomposition theorem for blowups*, arXiv:2604.10028v2, Proposition 8 and Corollary 11; [local PDF](../tmp/pdfs/2604.10028v2.pdf), SHA-256 \(0114923576b2ec3a78fc346fd9f61eb65cfe63f8cc7087881d11626cdb9883c3\). | A6 at line 62; point blowups in R5 at lines 790–793; all fourfold blowups in the target-specific weak-factorization argument at lines 563–598, whose conclusion is used at lines 825–827. | Exactly the two cases in the statement. No higher-dimensional case and no projective bundle is consumed. | Iritani is the source of KKPY's formal decomposition, so it is **not** an independent cross-check. [Bayer](https://arxiv.org/abs/math/0403260) independently verifies a point-blowup semisimplicity/spectral shadow, but not the analytic Hodge-equivariant chemical formula. No complete independent route was found. | F3 | **AXIOM-INTERFACE.** Expose only the two target cases and the induced Hodge-graded atom correspondence. Do not formalize virtual localization/Fourier analysis inside the main development. |

## 3. Why GW-1 cannot be replaced by the small product

The proof evaluates the Euler operator at the small point \(t=0\), but R2 does
not remain on the small line. At certificate lines 680–693, HYZZ is applied to
the full maximal germ over \(B_X\) and only afterwards pulled back to the
Hodge-fixed base. The small \(q\)-line has dimension one and the Hodge-fixed
base has invariant dimension five, whereas the bundle has rank 27. Neither
restricted base is the maximal rank-27 germ required by the decomposition
theorem.

Consequently:

- Fano grading and effectivity make the **small ambient product** polynomial
  in \(q\), but that proves only the value of the operator at \(b\).
- Analyticity in all big directions, flatness, and maximality are still
  consumed to extend the spectral factors as F-bundles.
- Hodge equivariance is still consumed to restrict those full-base factors
  equivariantly.

These subfacts are therefore bundled into GW-1 rather than masquerading as
several independently verified rows.

## 4. Deletions and internal derivations

### D1. General Givental/quantum-Lefschetz theorem — DELETE

The only use was the \(5\times5\) ambient matrix now supplied by GW-2 and
proved in certificate Lemma 3.5, lines 444–507. The general theorem for Fano
complete intersections is strictly stronger. Its cubic specialization remains
an independent check of \(6,15,6\), not a premise.

### D2. Primitive-class vanishing (KKPY Lemma 6.11) — DELETE

The proof of Theorem 6.8 ends at certificate line 866. Lemma 6.11 appears only
in the explicitly downstream consistency note at lines 868–880 and supplies
no edge to R1–R5.

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
curve-degree-\(\ge2\) terms. That is enough for R1 but not R2. Full big-base
analyticity remains inside GW-1, so small polynomiality is not a fourth row.

### D5. Separate WDVV, divisor, smoothness, maximality, and Hodge rows — MERGE

Flatness/WDVV, the Novikov/divisor structure, analytic convergence, smoothness,
maximality, and Hodge equivariance are different construction steps but the
certificate consumes them as one A-model object at lines 612–613 and 680–693.
None becomes cheaper by being named separately; they are the single GW-1 axiom
module.

### D6. Imported nef-\(K\) one-atom lemma — DERIVE, THEN DELETE

KKPY Lemma 5.24 is replaced by certificate Lemma 3.6, lines 509–561. Virtual
dimension and the unit axiom imply that every quantum-product term weakly
raises cohomological degree when \(K_Y\) is nef. Hence
\(\operatorname{Eu}\star=-t_0\operatorname{id}+N\) with \(N\) strictly
degree-raising and nilpotent. The reduced spectrum has one element and the
whole fiber is the unique atom. This is F1 once the product exposed by GW-1 is
available; recommendation: **FORMALIZE**.

### D7. Projective-bundle decomposition and Iritani--Koto — DELETE

The certificate uses a finer quotient, the blowup-Hodge atoms, which imposes
only isomorphism/same-component, disjoint-union, and blowup correspondences.
It does not impose projective-bundle equivalence. Proposition 3.7, lines
563–598, telescopes GW-3 along weak factorization. Since
\(\operatorname{HP}_{\rm fold}(\mathbf P^4;t)=5\), no atom of
\(\mathbf P^4\) has positive \(t^2\)-coefficient; the selected cubic atom must
therefore occur in a factorization center of dimension at most two. This
proves exactly the former use of the projective-bundle input without it.

Accordingly KKPY Theorem 4.11 and Iritani--Koto's projective-bundle theorem
are absent from the permanent interface.

### D8. KKPY Proposition 5.30 — DERIVE TARGET CASE, THEN DELETE

The general non-rationality criterion is replaced by certificate Proposition
3.7 and the final use at lines 825–827. The replacement consumes only GW-3
and the weak factorization statement A7. A7 is a non-GW input reserved for
WP-2.

### D9. Disjoint-union additivity — DELETE FROM GW

The chemical formula of a disconnected variety is componentwise by
definition; see certificate lines 440–442 and 767–780. No enumerative theorem
is imported for this.

## 5. Atom-formalism census

| KKPY item in the work-order census | Classification after minimization |
|---|---|
| Definition 5.21 | Isomorphism and same-spectral-component bookkeeping for geometric atomic F-bundles. Formal once GW-1 and HYZZ provide the bundle and local splitting. F1, **FORMALIZE**. |
| Proposition 5.22 | Item (1), disjoint union, is F0/formal. Item (2), smooth blowup, is exactly GW-3/F3. Item (3), projective bundle, is deleted by D7. |
| Proposition 5.23 | Its representation-local-constancy proof is not trusted for cover degree \(>1\); certificate Lemma 3.1 supplies the needed cover-native statement. Non-GW F1, **FORMALIZE**. |
| Lemma 5.24 | Replaced by certificate Lemma 3.6 as in D6. No surviving GW row beyond the already-exposed product in GW-1. F1, **FORMALIZE**. |
| Definition 5.26 and Remark 5.27 | Formation of \(\rho_\alpha\) and \(P_\alpha(t)\) from a Hodge representation is formal representation/Hodge bookkeeping. F1, **FORMALIZE**. |
| Proposition 5.30 | Deleted and replaced by target-specific Proposition 3.7. Its weak-factorization premise is non-GW and belongs to WP-2; its blowup premise is GW-3. |
| Proposition 5.28 (mislisted as “Proposition 5.31” in WORKORDER_1) | Every Hodge atom satisfies \(\rho_\alpha\ge1\), because its nonzero unital atom algebra contains the Hodge-fixed unit. This is Proposition 5.28, source label `prop:Ginv1`, pinned-v2 printed p. 62 (`tmp/sources/v2/brinv.tex`, lines 3576–3583). It is F1, **FORMALIZE**. It is not consumed by the repaired proof of Theorem 6.8; its paper use is downstream in Corollary 6.12, so it contributes no permanent interface. |

The non-GW inheritance is costed separately:

| Non-GW item | Cost and Lean recommendation |
|---|---|
| HYZZ Theorem 3.42 | F3 analytic F-bundle decomposition theory; **AXIOM-INTERFACE** for WP-3 unless that work order elects to formalize the full theorem. |
| Certificate Lemma 3.1 | F1 semisimple-representation and base-change argument; **FORMALIZE**. |
| Certificate Lemma 3.2 | F2 equivariant/canonical separated-block descent over analytic local rings, relative to HYZZ existence; **FORMALIZE**. |
| Certificate Proposition 3.3 | F2 finite-étale spectral-cover/CRT localization and rank bound; **FORMALIZE**. |

These are F-bundle splitting, representation theory, and linear algebra over
analytic local rings. They belong to WP-3, not to the three-row GW boundary.

## 6. Source and finite replay

The source pins used by this audit replay as:

~~~sh
shasum -a 256 tmp/pdfs/2508.05105v2.pdf tmp/sources/v2/brinv.tex tmp/pdfs/beauville-quantum-complete-intersections.pdf tmp/pdfs/givental-eqv.pdf tmp/pdfs/2307.13555.pdf tmp/pdfs/2604.10028v2.pdf
~~~

Expected ordered digests:

~~~text
2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64  tmp/pdfs/2508.05105v2.pdf
ec121169ccbe2d5ebd296a3b5b10cf3cb4f19488f09398b1d5cd57a7bee6a8ed  tmp/sources/v2/brinv.tex
9d022796aefa01fd601820e415c5462bdfc255b3b4fe158af64b51f7bf0a83e3  tmp/pdfs/beauville-quantum-complete-intersections.pdf
985248cc3e6e166b9847b01552de2034429a624794dc0c53cad50beb1f4b50c9  tmp/pdfs/givental-eqv.pdf
c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b  tmp/pdfs/2307.13555.pdf
0114923576b2ec3a78fc346fd9f61eb65cfe63f8cc7087881d11626cdb9883c3  tmp/pdfs/2604.10028v2.pdf
~~~

The two F0 checks are recorded verbatim at certificate lines 884–908. They
return \([6,15,6]\) and
\(\lambda^5-729\lambda^2q=\lambda^2(\lambda^3-3^6q)\).

## 7. Program exposure and gate

The program's definitive GW exposure is **three interfaces**: one full
analytic Hodge-equivariant genus-zero A-model package (F3), one cubic-specific
triple of degree-one line counts (F2), and one target-special
Hodge-compatible smooth-blowup decomposition (F3). Only the line counts are
recommended for direct formalization. The two F3 rows are permanent,
explicit axiom interfaces unless later work supplies genuinely independent
foundations.

**STOP.** Director review asks one binary question: is each of the three rows
irreducible, and is every deletion justified at its certificate use-site?
Only after acceptance does WP-2 begin.
