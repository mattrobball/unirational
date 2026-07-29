# Theorem 6.8 — weak-factorization boundary

**Date:** 2026-07-29; **work order:** WP-2; **verdict:** **E2 — MINIMIZE**

**Status:** WP-2 accepted; trusted-boundary scoreboard updated by WP-3;
**STOP at director review before WP-4**

## 1. Binary result

The proposed replacement lemma (MONO) was **not proved**. No counterexample was
found either. The correct conclusion is therefore a delimited negative, not a
refutation: the current F-bundle interfaces, the graph of a birational
morphism, and the published comparison results checked below do not imply
atom-summand monotonicity for an arbitrary birational morphism of smooth
projective fourfolds.

Accordingly A7 survives as the fourfold special case of the weak factorization
theorem. Abramovich--Karu--Matsuki--Włodarczyk (AKMW) supplies the exact
projective statement. Włodarczyk's independent proof supplies a theorem-level
cross-check of the weak-factorization core, but its displayed statement only
asserts complete, not projective, intermediate varieties.

## 2. Exact use that must be supplied

The consumed passage is Proposition 3.7 of
[`REPAIRED_PROOF.md`](REPAIRED_PROOF.md). The
required passage is quoted in full:

> ### Proposition 3.7 — the target-specific weak-factorization consequence
>
> Let \(X\) be a smooth projective fourfold and let \(\alpha\) be a
> blowup-Hodge atom occurring in \(X\) with
> \(\operatorname{Coeff}_{t^2}P_\alpha(t)>0\). If \(X\) is rational, then
> \(\alpha\) occurs in the atomic composition of a smooth projective variety
> of dimension at most two.
>
> **Proof.** By A7, a birational map
> \(\mathbf P^4\dashrightarrow X\) has a weak
> factorization. Apply A6 at every step and move the contributions of backward
> blowups to the left. In the free commutative monoid on blowup-Hodge atoms
> this gives
> \[
> \operatorname{CF}_{\rm bl}(X)
> +\sum_{i\in\mathrm{back}}(r_i-1)\operatorname{CF}_{\rm bl}(Z_i)
> =\operatorname{CF}_{\rm bl}(\mathbf P^4)
> +\sum_{i\in\mathrm{forward}}(r_i-1)\operatorname{CF}_{\rm bl}(Z_i),
> \]
>
> where \(Z_i\) is a smooth center of codimension \(r_i\ge2\) in a smooth
> fourfold. Since \(\alpha\) has positive multiplicity on the left, it has
> positive multiplicity on the right.
>
> It cannot be supplied by \(\mathbf P^4\). Indeed,
> \(\operatorname{HP}_{\rm fold}(\mathbf P^4;t)=5\), and Corollary 3.4 gives
> \[
> 0=[t^2]\operatorname{HP}_{\rm fold}(\mathbf P^4;t)
> =\sum_C\deg(C/U_{\mathbf P^4})[t^2]P_{\bar C}(t).
> \]
>
> Every summand is a nonnegative integer, so every blowup-Hodge atom of
> \(\mathbf P^4\) has zero \(t^2\)-coefficient. Therefore \(\alpha\) occurs in
> some \(Z_i\) on the right. Since \(r_i\ge2\),
> \(\dim Z_i=4-r_i\le2\). ∎

Here every \(Z_i\) must be a smooth center in a smooth **projective**
fourfold, because GW-1 and GW-3 are invoked on the intermediate varieties and
centers. The proof then uses positivity in the free monoid, excludes
\(\mathbf P^4\) by its folded Hodge polynomial, and concludes that \(\alpha\)
is supplied by one of the centers. Both blowup directions are essential: the
backward contributions are exactly the terms moved to the left.

## 3. E1 audit — why MONO is unavailable

The candidate statement was:

\[
\tag{MONO}
f:Z\to X\text{ birational, smooth projective fourfolds}
\quad\Longrightarrow\quad
m_X(\alpha)>0,\ [t^2]P_\alpha(t)=1
\Rightarrow m_Z(\alpha)>0
\]

This is the minimum atom class requested by the work order. The three required
routes fail at different, precise points; none acquires an atom-comparison map
after the coefficient-one restriction is imposed.

### 3.1 F-bundle and blowup-tower route

GW-3 proves coefficientwise inclusion only when the morphism is itself the
blowup of a smooth center:

\[
\operatorname{CF}_{\rm bl}(\operatorname{Bl}_C Y)
=\operatorname{CF}_{\rm bl}(Y)+(r-1)\operatorname{CF}_{\rm bl}(C).
\]

HYZZ decomposes one given F-bundle; it supplies no comparison map between the
F-bundles of two birational varieties. Hironaka resolves
\(\mathbf P^4\dashrightarrow X\) by a diagram

\[
\mathbf P^4\longleftarrow Z\xrightarrow{f}X
\]

in which the left map is a tower of smooth blowups, but \(f\) is an arbitrary
birational morphism. Thus GW-3 computes \(\operatorname{CF}_{\rm bl}(Z)\) from
\(\mathbf P^4\) and the left-leg centers, but says nothing coefficientwise
about \(\operatorname{CF}_{\rm bl}(X)\) inside it. Making the other leg a
smooth-blowup tower, or replacing the diagram by a common smooth-blowup peak,
is directed/strong factorization, not Hironaka elimination and not an existing
certificate interface. AKMW explicitly separates its weak theorem from the
strong factorization conjecture on pp. 1--2 of the pinned artifact.

Weak factorization itself yields only a stable equality

\[
\operatorname{CF}_{\rm bl}(X)+B
=\operatorname{CF}_{\rm bl}(Z)+A,
\]

not \(m_X(\alpha)\le m_Z(\alpha)\). Center terms in \(A\) and \(B\) can
offset the coefficient of \(\alpha\).

### 3.2 Graph route

The graph of \(f\) gives the classical Hodge maps \(f^*\) and \(f_*\), with
\(f_*f^*=\operatorname{id}\), so \(H^\bullet(X)\) is a Hodge direct summand
of \(H^\bullet(Z)\). This does not identify atom summands. The retained atom
formalism has no action of arbitrary algebraic correspondences on A-model
F-bundles, and the classical projector \(f^*f_*\) is not known to be
horizontal or to commute with Euler quantum multiplication. HYZZ therefore
cannot turn its image into a union of spectral blocks. A Hodge summand may cut
across several atomic generalized-eigenbundles, and an isomorphic Hodge
representation is not an identification of blowup-Hodge atoms.

This is consistent with KKPY's own scope warning: atoms have no natural
morphisms, do not form a category, and are not suited to studying a specific
birational map (`tmp/sources/v2/brinv.tex`, source lines 154--156).

### 3.3 Literature route

The pinned blowup theorems compare quantum D-modules only for an actual smooth
blowup and use blowup-specific Fourier/localization and base-change machinery.
They do not cover an arbitrary birational morphism or its graph.

Iritani, *Gamma classes and quantum cohomology*, arXiv:2307.15938, §3,
pp. 13--15, gives the baseline general formulation. Its formal decomposition
for a discrepant birational transformation is posed as **Problem 3.3**, and
the corresponding analytic/K-theoretic statement as **Problem 3.4**. The
paper records results there only for specified toric transformations. See the
[local PDF](../tmp/pdfs/iritani-gamma-quantum-cohomology.pdf), SHA-256
`462f2e0d6eff6315d9fcc2e0db78f95f14558d532d118e31b74f2270c2e0ab8a`, and
its extracted text at `tmp/pdfs/iritani-gamma-quantum-cohomology.txt`, lines
760--813.

A newer positive result materially sharpens that 2023 boundary. Gu--Yu--Yu,
*Quantum cohomology of variations of GIT quotients and flips*,
arXiv:2508.15770v1, Theorem 1.2, proves a quantum-D-module decomposition for
smooth projective **simple reductive-\(G\) VGIT wall crossings**. Remark
1.3(3) deduces

\[
\operatorname{CF}(X_-)=\operatorname{CF}(X_+)
+(r_--r_+)\operatorname{CF}(S).
\]

This is an atom-level comparison for KKPY's published \(\operatorname{CF}\)
in that special class. It does not as stated establish the certificate's finer
\(\operatorname{CF}_{\rm bl}\)-MONO: KKPY's \(\operatorname{CF}\) also
quotients by projective-bundle equivalence, and Gu--Yu--Yu do not state the
cover-native Hodge-equivariant lift needed for the finer classes. Independently,
the result does not apply directly to an arbitrary birational morphism
\(Z\to X\), which is not assumed to be a simple VGIT wall crossing. The paper
supplies no directed factorization of an arbitrary morphism by such crossings;
obtaining one is the strong/directed-factorization gap identified in §3.1. The
same paper leaves general standard flips as Conjecture 1.8 and proves the
conjecture for their projective local models in Corollary 1.9 (plus further
specified cases). See the [local PDF](../tmp/pdfs/gu-yu-yu-vgit-flips.pdf),
SHA-256 `9c00f826cb13ad243bd2ad126e74733cacf650a385160a11adc785693c01a358`, and
the extracted text at `tmp/pdfs/gu-yu-yu-vgit-flips.txt`, lines 52--145 and
197--229.

Thus the current primary-source sweep found strong special-case comparisons,
but no published theorem that supplies (MONO) for arbitrary smooth projective
birational morphisms. A smooth birational morphism has
\(K_Z-f^*K_X\ge0\), so it lies in the direction of Iritani's problem, but the
available VGIT theorem does not cover it. This is a statement about the
searched proof boundary, not evidence that (MONO) is false.

## 4. E2 interface — the exact surviving A7

The authoritative `WF-4` row has been moved to the single interface table in
[`GW_INPUT.md`](GW_INPUT.md), Section 2. Its statement, AKMW hash, Włodarczyk
cross-check, exact use-sites, F3 cost, and minimal scope are recorded there.
This section retains the proof of the two elementary deductions from that row.

A smooth codimension-one center in a smooth variety is an effective Cartier
divisor, and its blowup is an isomorphism. Such steps can be deleted. A
nontrivial center in a fourfold therefore has codimension at least two, giving
\(\dim Z_i\le2\) without adding any hypothesis to WF-4.

The similarly titled Włodarczyk preprint `math/9904074`, *Birational
cobordisms and factorization of birational maps*, is only preparatory: it says
the weak theorem is proved in subsequent papers. It is not used as the
independent theorem citation. The independent artifact above is
`math/9904076v5`.

Here “independent” means independently developed proof route, not
author- or foundation-independence: Włodarczyk is the fourth AKMW author, and
both proofs use birational-cobordism input.

### Why F3 is honest

AKMW's proof uses canonical resolution/principalization, elimination of
indeterminacies, birational cobordisms and GIT, toroidal factorization,
torific ideals, and canonical-resolution gluing. Włodarczyk's independent
route replaces the torific-ideal gluing with stratified toroidal varieties,
stable valuations, and a \(\pi\)-desingularization algorithm, while retaining
Hironaka and birational cobordisms. No dimension-four elementary proof is
provided by either source, and the source sweep found no elementary
dimension-three or fourfold replacement. Recreating this machinery in the
main Lean development would dominate the target theorem, so WF-4 should remain
a single opaque interface.

## 5. E3 probe — no factorization-free reformulation

One pass was made over Grothendieck/Bittner-style presentations. Ordinary
scissor relations do show, without factorization, that birational smooth
projective \(n\)-folds sharing \(U\) differ by
\([X\setminus U]-[Y\setminus U]\), a class supported in lower dimension. But
the chemical formula is defined here only for smooth projective A-model
F-bundles; no compatible value on singular or nonproper complements is
available, so this observation does not produce an atom obstruction.

Alternatively, declaring the **chemical** blowup relation in a free group
makes that relation formal but does not relate an arbitrary birational pair.
Showing that the smooth-projective presentation is independent of choices
uses Bittner/weak-factorization machinery. Moreover, the usual
Grothendieck-ring blowup relation contains the exceptional projective bundle;
making the chemical formula descend through it would restore the
projective-bundle input that WP-1 deliberately removed. Imposing birational
equality by definition would instead discard the data the atomic obstruction
is meant to detect. Thus neither version supplies a cheaper replacement for
A7.

## 6. Program-wide trusted boundary after WP-3

The honest current display is

\[
\mathsf{TB}_G=
\underbrace{\{\mathrm{GW\!-\!1},\mathrm{GW\!-\!3},\mathrm{WF}_4\}}
_{\text{analytic GW and birational interfaces}}
\cup
\underbrace{\{\mathrm{SEP\!-\!CONV}\}}
_{\text{finite analytic split plus HYZZ strict-shrink convergence}}
\cup
\underbrace{\{\mathrm{HATOM\!-\!RAW},
\mathrm{NL\!-\!CUBIC},\mathrm{SURF\!-\!MIN}\}}
_{\text{Hodge-side and terminal birational interfaces}}.
\]

The formal separated-projector theorem is now internal and proved in
[`ATOM_CORE.md`](ATOM_CORE.md), Section 4. The only surviving analytic brace is
`SEP-CONV`: its finite $u=0$ block extension is isolated via a
non-archimedean analytic implicit-function step, and HYZZ Proposition 3.36
supplies convergence on a strict shrink conditional on that extension.
Completion injectivity is internal. Whole HYZZ Theorem 3.42, maximality,
product decomposition of the base, and the moving-base group-germ argument
have left the target graph.
`GW-2` and all other F0/F1/F2 repair lemmas are internal to the formalization
spine. The exact wording of all seven opaque packages and the one internal F2
row is in the single table of record in `GW_INPUT.md`.

## 7. Proposition-number reconciliation

The work-order census's “Proposition 5.31” is a misnumbering. The intended
statement is **Proposition 5.28**, source label `prop:Ginv1`, pinned-v2 printed
p. 62: every Hodge atom satisfies \(\rho_\alpha\ge1\), because its nonzero
unital atom algebra contains the Hodge-fixed unit. The exact source is
`tmp/sources/v2/brinv.tex`, lines 3576--3583, and the extracted artifact is
`tmp/pdfs/2508.05105v2.txt`, lines 4055--4060. There is no Proposition 5.31 in
the pinned v2 text.

Proposition 5.28 is used by the paper only downstream of Theorem 6.8, in
Corollary 6.12. It is F1, **FORMALIZE**, and contributes no permanent target
interface. `GW_INPUT.md` and the historical audit wording in `RESOLUTION.md`
have been corrected accordingly.

## 8. Pinned artifacts and finite replay

~~~text
55bbc2c58f29d4b9dbe965035f80f3844f6968eaf98076ac625132ac3b3977a5  tmp/pdfs/akmw-torification-factorization.pdf
2f7a0bce5871db86bf84f54c4562fc053c53a4313180a6eecb66587d21e4fcfe  tmp/pdfs/wlodarczyk-toroidal-weak-factorization.pdf
462f2e0d6eff6315d9fcc2e0db78f95f14558d532d118e31b74f2270c2e0ab8a  tmp/pdfs/iritani-gamma-quantum-cohomology.pdf
9c00f826cb13ad243bd2ad126e74733cacf650a385160a11adc785693c01a358  tmp/pdfs/gu-yu-yu-vgit-flips.pdf
~~~

The searchable `pdftotext -layout` extracts are retained beside the PDFs.
Replay with:

~~~sh
shasum -a 256 \
  tmp/pdfs/akmw-torification-factorization.pdf \
  tmp/pdfs/wlodarczyk-toroidal-weak-factorization.pdf \
  tmp/pdfs/iritani-gamma-quantum-cohomology.pdf \
  tmp/pdfs/gu-yu-yu-vgit-flips.pdf

pdfinfo tmp/pdfs/akmw-torification-factorization.pdf
pdfinfo tmp/pdfs/wlodarczyk-toroidal-weak-factorization.pdf
pdfinfo tmp/pdfs/iritani-gamma-quantum-cohomology.pdf
pdfinfo tmp/pdfs/gu-yu-yu-vgit-flips.pdf

rg -n 'Theorem 0\.1\.1|if X1 and X2 are projective' \
  tmp/pdfs/akmw-torification-factorization.txt
rg -n 'Conjecture 0\.0\.1|12\.4\. Proof' \
  tmp/pdfs/wlodarczyk-toroidal-weak-factorization.txt
rg -n 'Problem 3\.3|Problem 3\.4' \
  tmp/pdfs/iritani-gamma-quantum-cohomology.txt
rg -n 'Theorem 1\.2|CF\(X|Conjecture 1\.8|Corollary 1\.9' \
  tmp/pdfs/gu-yu-yu-vgit-flips.txt
~~~

Observed replay: the four SHA-256 values matched; `pdfinfo` parsed unencrypted
PDFs of 30, 70, 18, and 64 pages; fresh `pdftotext -layout` output was
byte-identical to all four retained extracts; and all theorem/problem searches
returned the displayed anchors. The Proposition 3.7 block above matched the
current certificate after whitespace normalization. `git diff --check`,
the separate new-file whitespace check, Markdown-link/table/fence checks, and
the control-character scan produced no diagnostics. The pre-existing sibling
Problem E modifications were not touched.

## 9. Gate

WP-2's E2 verdict and `WF-4` row were accepted. The current gate is WP-3:

1. is the replacement of whole HYZZ by the proved formal theorem plus
   `SEP-CONV` honest at the finite analytic split and convergence steps;
2. does `ATOM_CORE.md` close over exactly the seven displayed packages; and
3. is its Mathlib shopping list concrete enough to cost WP-4?

**STOP.** WP-4 has not begun.
