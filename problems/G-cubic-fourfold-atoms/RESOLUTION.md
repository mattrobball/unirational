# Problem G -- resolution log

## Current verdict

**2026-07-29 -- WP-0 COMPLETE; STOPPED AT DIRECTOR GATE.**

The dependency path for KKPY Theorem 6.8 has been mapped in
[`DEPENDENCY_MAP.md`](DEPENDENCY_MAP.md).  The v2 proof is **not valid as
printed**.  This is a proof-audit finding, not a refutation of the theorem.
No WP-1 work has started.

## 2026-07-29 -- WP-0 critical-path audit

### Source state

The official v1 and v2 PDFs and TeX sources were read directly.  Theorem 6.8
is on printed pp. 69--71 in both versions.  Its statement and proof are
byte-for-byte identical in the TeX sources.  The cubic matrix calculation in
Example 6.6(iii) is also identical.  V2 makes relevant upstream corrections
to the Hodge symmetry, fixed-locus blowup discussion, Hodge numerical
invariants, the proof text of Lemma 5.18, and the general formula
\(K=(N-d_{\mathrm{tot}})A\), but it does not change the headline proof.

### Confirmed findings

1. **Domain error.** Definition 3.32's setup requires the Novikov coordinate
   to have valuation in the open ample cone.  Theorem 6.8 evaluates at
   \(q=1\), whose valuation is zero, so the selected point is outside the
   defined base.  Choosing any positive-valuation \(q_0\) repairs the finite
   spectrum calculation:
   \[
   \chi_{K(q_0)}(\lambda)=\lambda^2(\lambda^3-729q_0),
   \]
   with generalized dimensions \(2,1,1,1\) on the five-dimensional
   Hodge-invariant/ambient subspace.
2. **Maximality gap.** Theorem 4.1 assumes a maximal F-bundle.  For a
   Noether--Lefschetz-general cubic, the full fiber has rank 27 while the
   Hodge-fixed base used on p. 70 has dimension 5.  Its restriction cannot
   be maximal, so the cited theorem does not apply.  Applying the theorem on
   the full base and restricting unique equivariant factors is plausible,
   but the required refinement lemma is not in v2.
3. **False rank inequality.** The printed minimum over cluster ranks is
   invalid.  The correct bound uses the particular containing cluster, or
   the maximum \(2\).
4. **Missing very-general implication.** Existence of one
   Noether--Lefschetz-general cubic does not by itself prove a very-general
   statement.  The countable Hodge-locus argument is omitted.
5. **False surface paragraph.** The list omits elliptic surfaces with
   \(p_g>1\) and applies nefness of \(K\) without first passing to a minimal
   model. An exact counterexample to the list is \(S=E\times C\), where \(E\)
   is elliptic and \(g(C)=g\ge2\): projection to \(C\) is an elliptic
   fibration, \(K_S=\operatorname{pr}_C^*K_C\), \(\kappa(S)=1\), and
   \(p_g(S)=g>1\). Conditional on atom blowup-additivity, point blowups add
   only point atoms, so the atom with nonzero \(t^2\)-coefficient descends to
   the minimal model; Peters, Propositions 2.2 and 6.2, then give the required
   nefness. This is not the argument printed.
6. **Highest unresolved risk.** The formal-to-analytic blowup decomposition,
   its claimed equivariance, fixed-locus connectedness, and the resulting
   correspondence of global spectral-cover components are not yet isolated
   as a complete proved theorem.  This interface is what supplies
   birational additivity of atoms.
7. **Representation-theory citation mismatch.** Milne, *Algebraic Groups*,
   Proposition 15.15 does not state local constancy of analytic families of
   representations, as Proposition 5.23 claims.  V2's corrected complex
   definition of \(\rho\) is also not propagated to the unchanged Theorem 6.8
   proof.  Local constancy and base change of invariants need separate lemmas.

The exact \(5\times5\) cubic matrix's characteristic polynomial was
independently replayed.  The coefficients \(6,15,6\) were cross-checked by
the algebraic elimination in `DEPENDENCY_MAP.md`, but that elimination does
not have a separate executable replay.  Nothing found points to the finite
matrix as the present failure point.

### External record

The dated, exact queries recorded in `DEPENDENCY_MAP.md`, Section 9.1, found
no public technical erratum, withdrawal, counterexample, detailed gap claim,
or MathOverflow critique of arXiv:2508.05105 in their returned indexed
results. This scoped negative result is not a correctness certificate or a
claim to have exhausted the web.

Guéré's v1 preprint [arXiv:2603.04518](https://arxiv.org/abs/2603.04518)
substantially reworks the argument in a distinct evaluation framework.  It
contains a reproof of the headline and states and argues for a stronger
K3-type necessary condition for rational cubic fourfolds.  This is
corroborative reworking, not independent validation: it remains dependent on
major shared inputs, especially Givental's computation, weak factorization,
and Iritani's blowup theorem.

### Verification record

The following local checks were run against the downloaded official
artifacts:

```text
$ shasum -a 256 tmp/pdfs/2508.05105v1.pdf tmp/pdfs/2508.05105v2.pdf tmp/pdfs/2508.05105v1-source.tar tmp/pdfs/2508.05105v2-source.tar
26033f81afa0acd2b97337fa73c74ef49a783897306f2b2a81905ce0ca74f918  tmp/pdfs/2508.05105v1.pdf
2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64  tmp/pdfs/2508.05105v2.pdf
33f71f79663de77d5c9d9cbb5eb040648aace3839e9f5e807bf364573c77eeb8  tmp/pdfs/2508.05105v1-source.tar
36a6447a2f402dce468e91ca76dd0c5439a14db088c5648431ccfee507bc709e  tmp/pdfs/2508.05105v2-source.tar

$ diff -u <(awk '/\\begin\{theorem\} \\label\{thm:cubic4\}/{p=1} p{print} p && /\\end\{proof\}/{exit}' tmp/sources/v1/brinv.tex) <(awk '/\\begin\{theorem\} \\label\{thm:cubic4\}/{p=1} p{print} p && /\\end\{proof\}/{exit}' tmp/sources/v2/brinv.tex)
[no output]

$ diff -u <(awk '/\\begin\{example\} \\label\{ex:quadrics_and_cubics\}/{p=1} p{print} p && /\\end\{example\}/{exit}' tmp/sources/v1/brinv.tex) <(awk '/\\begin\{example\} \\label\{ex:quadrics_and_cubics\}/{p=1} p{print} p && /\\end\{example\}/{exit}' tmp/sources/v2/brinv.tex)
[no output]

$ awk '/\\begin\{theorem\} \\label\{thm:cubic4\}/{p=1} p{print} p && /\\end\{proof\}/{exit}' tmp/sources/v1/brinv.tex | wc -l
95
$ awk '/\\begin\{theorem\} \\label\{thm:cubic4\}/{p=1} p{print} p && /\\end\{proof\}/{exit}' tmp/sources/v1/brinv.tex | shasum -a 256
01bd6cb7a612088a78cd5ba8f222cb504d3b65f8fba6d93d4f396ff5a3afebe5  -
$ awk '/\\begin\{theorem\} \\label\{thm:cubic4\}/{p=1} p{print} p && /\\end\{proof\}/{exit}' tmp/sources/v2/brinv.tex | wc -l
95
$ awk '/\\begin\{theorem\} \\label\{thm:cubic4\}/{p=1} p{print} p && /\\end\{proof\}/{exit}' tmp/sources/v2/brinv.tex | shasum -a 256
01bd6cb7a612088a78cd5ba8f222cb504d3b65f8fba6d93d4f396ff5a3afebe5  -

$ awk '/\\begin\{example\} \\label\{ex:quadrics_and_cubics\}/{p=1} p{print} p && /\\end\{example\}/{exit}' tmp/sources/v1/brinv.tex | wc -l
104
$ awk '/\\begin\{example\} \\label\{ex:quadrics_and_cubics\}/{p=1} p{print} p && /\\end\{example\}/{exit}' tmp/sources/v1/brinv.tex | shasum -a 256
da93eecab0bdf2fc460923d6530e292024abf11d1ee55e53242fa68faf7bbf21  -
$ awk '/\\begin\{example\} \\label\{ex:quadrics_and_cubics\}/{p=1} p{print} p && /\\end\{example\}/{exit}' tmp/sources/v2/brinv.tex | wc -l
104
$ awk '/\\begin\{example\} \\label\{ex:quadrics_and_cubics\}/{p=1} p{print} p && /\\end\{example\}/{exit}' tmp/sources/v2/brinv.tex | shasum -a 256
da93eecab0bdf2fc460923d6530e292024abf11d1ee55e53242fa68faf7bbf21  -

$ /opt/homebrew/bin/python3 -c 'import sympy as s; q,L=s.symbols("q L"); K=3*s.Matrix([[0,0,6*q,0,0],[1,0,0,15*q,0],[0,1,0,0,6*q],[0,0,1,0,0],[0,0,0,1,0]]); p=s.expand(K.charpoly(L).as_expr()); expected=L**2*(L**3-729*q); assert s.expand(p-expected)==0; print(expected)'
L**2*(L**3 - 729*q)
```

The official v2 PDF pages 69--71 were also rendered to images and visually
checked against the extracted text and TeX source.

### WP-0 acceptance audit

The work order's WP-0 requirements were checked individually against the
current artifacts:

| Requirement | Authoritative evidence | Result |
|---|---|---|
| Target-only dependency DAG | `DEPENDENCY_MAP.md`, Sections 2--5: 58 internal nodes and 24 external/missing source-use nodes | Complete for the printed proof, the indispensable foundational route, and each substantive unnumbered bridge. Every ledger ID occurs as exactly one Mermaid box; the graph/ledger set difference is empty; all solid edges form a DAG. Exactly E09, E13, and E15 are reachable only by their labeled auxiliary/insufficient/alternative dashed edges. Excluded material is identified explicitly. |
| One work-order class per node | `DEPENDENCY_MAP.md`, graph labels and ledgers | Complete. Each of the 82 nodes has exactly one class in \(\{L,GW,H,B,V\}\) and one cost in \(\{F0,\ldots,F4\}\); graph labels and ledger entries agree. |
| V1-to-v2 critical-path diff | `DEPENDENCY_MAP.md`, Section 8, plus the byte-identical target/source-block hashes above | Complete, including the separate Example 5.5, Example 5.7, and Lemma 5.18 proof edits. |
| Errata/review/commentary sweep | `DEPENDENCY_MAP.md`, Section 9 | Complete through 2026-07-29 for the documented queries, with exact replay links and the negative-search limitation stated. |
| First formalization-cost ranking | `DEPENDENCY_MAP.md`, Section 10 | Complete. |
| Three most likely hidden-gap sites | `DEPENDENCY_MAP.md`, Section 11 | Complete. |
| Skeptical-pass logging and immediate stop | `DEPENDENCY_MAP.md`, Section 7, and this resolution log | Complete; the proof defects are separated from unverified high-risk interfaces and from a theorem refutation. |
| No work beyond the gate | Repository inventory: no `GW_INPUT.md`, `FACTORIZATION.md`, `ATOM_CORE.md`, `GENERALITY.md`, or simplified certificate exists | Satisfied. |

This acceptance audit proves completion of WP-0 as a work package.  It does
not convert any edge marked F4 or “unverified” into a theorem, and therefore
does not certify Theorem 6.8.

### Gate state

WP-0's required deliverables are complete.  Per `WORKORDER.md`, work stops
here for director review.  The next action requires an explicit decision on
whether the maximality/equivariant-refinement and blowup-to-atom interfaces
must be repaired before WP-1, may be admitted as pinned assumptions, or halt
the program.

## 2026-07-29 — director gate review of WP-0: ACCEPTED, with graded verdict

Direct read of the primary text (v2, extracted from the hash-pinned PDF)
confirms every checkable claim of the audit at the use-site level:

- **7.1 CONFIRMED.**  `B_{X,q}` is defined verbatim as "the preimage of
  the ample cone in NS(X,ℝ) under the valuation map"; the ample cone is
  open and does not contain 0, and `q = 1` has valuation 0, so the
  proof's chosen base point is outside the domain as printed.  The
  auditor's repair (positive-valuation `q₀`) is numerically verified:
  the characteristic polynomial `λ⁵ − 3⁶λ²q` matches the printed
  `λ⁵ − 3⁶λ²` at `q = 1` and the cluster dimensions `(2,1,1,1)` are
  `q`-independent.
- **7.2 CONFIRMED as printed — the one substantive gap.**  The proof
  applies spectral decomposition (Theorem 4.1, maximality hypothesis via
  cyclic vector) to `(H,∇)/B_X^{Hod}`: rank 27 over a 5-dimensional
  base, where maximality cannot hold.  No equivariant-restriction lemma
  (decompose over the full maximal `B_X`, restrict Hodge-equivariantly)
  appears at the use-site.  Repair plausible (the audit's 7-step
  sketch); NOT certified.
- **7.3 CONFIRMED.**  The displayed bound is `min` over the four
  clusters, which with `(2,1,1,1)` yields `≤ 1`; the proof then uses
  `ρ_α ≤ 2`, i.e. the intended cluster-specific bound.  False as
  displayed, benign once 7.2 is repaired.
- **7.4 CONFIRMED.**  Only existence of NL-general cubics is asserted;
  the "very general" statement needs the countable-union structure
  (Hassett's divisors repair it).
- **7.5 CONFIRMED, with a simplification beyond the audit.**  The
  printed exhaustive list ("elliptic with κ = 1 and p_g = 1") is refuted
  by `E × C` (`κ = 1`, `p_g = g ≥ 2`, `K` nef).  Moreover the list is
  DISPENSABLE: the argument only needs `p_g(S) > 0 ⟹ κ(S) ≥ 0 ⟹ the
  minimal model has nef K`, then single-atom + `ρ ≥ 3 > 2`.  The repair
  deletes the classification rather than fixing it — first concrete
  simplification of the program.

**Gate decision.**  WP-0 accepted; STOP upheld in the graded sense: the
program does not proceed to WP-1..5 on the printed argument.  Authorized
next step **WP-0.5**, two bounded deliverables: (a)
`certificates/GAP_REPORT.md` — the referee-grade write-up of 7.1–7.5 at
certificate standard, quoting the primary text; (b) a bounded attempt at
the 7.2 repair lemma (decompose over the full maximal base where
Theorem 4.1 legitimately applies; show the decomposition restricts
Hodge-equivariantly to `B^{Hod}`, using exactness of invariants for the
proreductive Hodge group and compatibility with generalized eigenspaces),
under the house rule — if the lemma resists, report the precise
obstruction; do not force it.  If the repair lands, the simplification
program resumes on the repaired argument with 7.5's
delete-the-classification simplification incorporated.

Whether and when to communicate the findings to the authors is the
owner's decision, not a worker action.

## 2026-07-29 — owner's assessment; repair ordered

The owner judges the five printed defects not serious.  Work order 0.5
issued (`WORKORDER_0.5_REPAIR.md`): Codex repairs R1–R5 with the routes
pinned at the gate, primary deliverable a self-contained
`certificates/REPAIRED_PROOF.md` at certificate standard, secondary a
neutral `certificates/GAP_REPORT.md`.  Director gate on the repaired
proof; on acceptance the WP-1..5 simplification program resumes.

## 2026-07-29 — WP-0.5 repair complete; stopped at director gate

**Package verdict:** WP-0.5 is complete at its assigned scope, relative to
the imported interfaces A1–A10 stated in the proof certificate. The repaired
argument now closes R1–R5 for Theorem 6.8. This is not a foundational reproof
of the global atom formalism, and it does not upgrade the separately recorded
A-model blowup/atom interfaces from pinned inputs to verified theorems.

### Deliverables

- [`certificates/REPAIRED_PROOF.md`](certificates/REPAIRED_PROOF.md) is the
  primary, stand-alone repair certificate. It gives every R1–R5 before/after
  replacement, an exact imported-interface table, two new R2 lemmas, the
  repaired proof, and the downstream R1 substitutions.
- [`certificates/GAP_REPORT.md`](certificates/GAP_REPORT.md) is the neutral
  referee record. The `E × C` counterexample appears there and is absent
  from the repaired proof, as ordered.

### Repair audit

1. **R1 closed.** The inadmissible point `q = 1` is replaced by
   \(q_0=\boldsymbol y^a\), \(a\in\mathbf Q_{>0}\). The characteristic
   polynomial is
   \(\lambda^2(\lambda^3-729q_0)\), with invariant cluster dimensions
   \((2,1,1,1)\); Lemma 6.11 and Corollary 6.12 receive the same substitution.
2. **R2 closed in the form Theorem 6.8 needs.** HYZZ Theorem 3.42 supplies
   existence but, contrary to the route stated in the work order, has no
   uniqueness clause. The certificate therefore proves uniqueness by
   comparing horizontal idempotents and using the off-diagonal Sylvester
   isomorphism. This makes the full-base factors Hodge-equivariant; they are
   then pulled back to the fixed base without being called maximal.
3. **R2 step 5 is corrected, not asserted in its stronger requested form.**
   A connected global finite étale spectral component need not lie in one
   cluster after restriction to a small neighborhood: the connected cover
   \(z^2=t\) over \(\mathbf G_m\) splits into two branches near \(t=1\).
   The needed conclusion is pointwise. The tautological generalized-
   eigenbundle on the component has constant Hodge-representation type; a
   point above the local neighborhood lies in one cluster and supplies the
   rank bound. Thus the theorem-level localization is proved while the false
   stronger global label is expressly not certified.
4. **R3 closed.** The false minimum is replaced by the particular containing
   cluster, giving \(\rho_\alpha\le2\).
5. **R4 closed.** Hassett Theorem 3.1.2 supplies the countable union of proper
   special-cubic divisors. No extra Torelli or transcendental-irreducibility
   exceptional locus is used in Theorem 6.8.
6. **R5 closed.** The surface classification is deleted. Positive
   \(p_g\) gives a minimal model with nef canonical class, and point-blowup
   additivity carries the non-point atom to that model, where its invariant
   dimension is at least three.

### Verification record

The certificate replay was executed against the pinned local artifacts:

```text
$ /opt/homebrew/bin/python3 -c 'import sympy as s; q,L=s.symbols("q L"); K=3*s.Matrix([[0,0,6*q,0,0],[1,0,0,15*q,0],[0,1,0,0,6*q],[0,0,1,0,0],[0,0,0,1,0]]); p=s.expand(K.charpoly(L).as_expr()); expected=L**2*(L**3-729*q); assert s.expand(p-expected)==0; print(p)'
L**5 - 729*L**2*q

$ shasum -a 256 tmp/pdfs/2508.05105v2.pdf tmp/pdfs/2411.02266.pdf tmp/pdfs/peters-surface.pdf tmp/pdfs/givental-eqv.pdf
2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64  tmp/pdfs/2508.05105v2.pdf
a11a093f790890804c7d4f7559b30ed2a6da87811de46f2aa0d29026e343e6bd  tmp/pdfs/2411.02266.pdf
51f9c99621b3819aa85894a8cdee4a528b0894364fc22b40a651f1bae55ceed3  tmp/pdfs/peters-surface.pdf
985248cc3e6e166b9847b01552de2034429a624794dc0c53cad50beb1f4b50c9  tmp/pdfs/givental-eqv.pdf

$ rg -n 'thm:cubic4|thm:K-decomposition|lem:Ginvariants|lem:nefK|prop:non-rational' tmp/sources/v2/brinv.tex
[all five labels found]

$ git diff --check
[no output]
```

### Gate state

**STOP.** No WP-1–WP-5 simplification, author contact, or Lean work has
started. Director review of the repaired proof is required before the
original program resumes.

## 2026-07-29 — adversarial audit of the repaired proof: SURVIVES; gate ACCEPTED with punch list

Independent hostile pass (scratch under `/private/tmp/audit_g/`), on top of
the director's direct read of Lemma 3.2.  Every ranked attack failed, with
from-scratch re-derivations rather than trust: the order-`m` coefficient
computation is right under KKPY's and HYZZ's SHARED `u⁻²` convention and is
independently corroborated by HYZZ eq. (3.27); the Sylvester/block step is
valid for non-semisimple blocks (ring-coefficient version is HYZZ Lemma
3.28); HYZZ Thm 3.42 has NO uniqueness clause and the certificate does not
lean on one — its idempotent uniqueness stands alone; maximality of the
A-model bundle on the full `B_X` is confirmed from the text and by direct
dimension count; the `K`-matrix coefficients `6,15,6` were re-derived
uniquely from Givental's ODE; Hassett's Thm 3.1.2 is stated for INTEGRAL
HODGE classes, so R4 needs no Hodge conjecture in the direction used.

Two strengthenings beyond survival:
- the cover-native reading of `E^α` is FORCED, not chosen — the
  pushforward reading breaks KKPY Prop. 5.31, Rem. 5.29, and the
  Hochschild additivity used by Thm 6.8 itself;
- KKPY Prop. 5.23's printed proof is genuinely defective for
  multiplicity > 1; the certificate's Lemma 3.1 is the correct
  replacement (a sixth printed defect, found by the audit).
- R1 is load-bearing, not cosmetic: by KKPY Lemma 3.29 the quantum
  product is analytic only on the tube — `κ_b` is not defined at `q=1`
  at all.

**Punch list (N1–N8), all interface-hygiene or elision grade, none
mathematical:** N1 the Hochschild-additivity interface is used but
unlisted (derivable from the cover-native fiber decomposition — the item a
formalization would stall on first); N2 R5 needs the one-clause
`E^{η(S_min)} ≅ H^•(S_min)` identification (present in KKPY's printed
text, omitted from the interface table); N3 the reduction to connected
`S` (disjoint-union additivity); N4 Lemma 3.2(4) imports context its
hypotheses don't state (incl. density of `U_X`); N5 step (2) needs a
`G`-stable germ; N6 Hassett unpinned (no hash/local copy; page anchors
off — audit's fetched copy hashed
`ecc2e31a63f56d443aaa3534f0218b25a5b6ab6e1a84c82db5c7bac1789a1d21`);
N7 three true-but-asserted steps inside Lemma 3.2; N8 an inherited
KKPY sign inconsistency (`U₀ = −κ` under their own display), harmless
but to be recorded.

**Gate decision: ACCEPTED.**  WP-0.6 ordered: incorporate N1–N8 (fix
routes are in the audit record), then the certificate is final and the
WP-1..5 simplification program resumes on it — with R5's
classification-deletion and the cover-native formulation already banked
as simplifications.

## 2026-07-29 — WP-0.6 punch list complete; stopped at director gate

**Completion verdict:** all eight certificate-hygiene findings N1–N8 are
incorporated in `certificates/REPAIRED_PROOF.md` without weakening the
repaired theorem or crossing into WP-1–WP-5. The imported-interface table is
now A1–A15; every external input used in Sections 3–5 is either listed there
or proved in the certificate.

**Historical-line-number note:** the line references and A-row attributions
in this WP-0.6 entry refer to the certificate snapshot at the WP-0.6 gate.
WP-1 subsequently inserted Lemmas 3.5–3.6 and Proposition 3.7, narrowed A6,
and renumbered later lines. The current interface and use-site ledger is
`certificates/GW_INPUT.md`; the snapshot below is intentionally not rewritten.

### Per-item closure

1. **N1 — closed.** A11 at certificate line 64 now identifies the full
   A-model fiber with Betti cohomology and records the fiber-point atomic
   decomposition. Corollary 3.4, lines 381–430, derives the folded
   Hodge-polynomial and invariant-rank identities component by component,
   with
   \(m_X(\alpha)=\sum_{C:\bar C=\alpha}\deg(C/U_X)\) taken before the
   automorphism/global-atom quotient. R3 uses the derived identity at lines
   579–590.
2. **N2 — closed.** A6, line 59, includes the full-cohomology clause. R5,
   lines 633–641, explains that the single reduced eigenvalue makes the
   unique generalized eigenspace the entire fiber and obtains
   \(E^{\boldsymbol\eta(S_{\min})}\cong
   H_B^\bullet(S_{\min},\overline{\mathbf Q})\).
3. **N3 — closed.** Disjoint-union additivity is in A6, and R5 reduces an
   arbitrary disconnected variety to a connected component at lines
   599–612 before treating points, curves, and surfaces.
4. **N4 — closed.** The former context-dependent Lemma 3.2(4) is now the
   standalone Proposition 3.3, lines 278–365, with density, finite
   étaleness, surjectivity, and point-factor hypotheses stated explicitly.
   The cubic verification, including the exact density pin, is at lines
   526–533.
5. **N5 — closed.** A12, line 65, pins KKPY's analytic group-germ
   framework. Lemma 3.2(2), lines 242–257, compares action and projection
   pullbacks on common refinements and expressly avoids claiming that the
   full unbounded group preserves one affinoid representative.
6. **N6 — closed.** The Hassett artifact is stored at
   `tmp/pdfs/hassett-special-cubic-fourfolds.pdf`; its manifest entry is at
   lines 35–43 and A8/A14 give corrected artifact pagination. R4, lines
   666–693, quotes the integral-Hodge-lattice line and Theorem 3.1.2 and
   explains why the implication used is independent of the Hodge
   conjecture.
7. **N7 — closed.** Lemma 3.2(1), lines 162–240, proves resultant-unit
   persistence, characteristic-polynomial CRT projectors, the
   Sylvester/Nakayama reduction of any competing idempotent, and hence
   \(m\ge1\). Proposition 3.3, lines 300–346, proves the cover-native kernel
   is an idempotent image and therefore a vector subbundle; A15 lists the
   reduced-affinoid identity principle used in that proof.
8. **N8 — closed.** A13, line 66, and the sign convention at lines 108–129
   distinguish \(\kappa_{\mathrm{at}}=\operatorname{Eu}\star(-)\) from
   \(K_{\mathrm{res}}=-\kappa_{\mathrm{at}}\). R1 keeps the positive atom
   spectrum while recording the negated HYZZ residue spectrum and unchanged
   multiplicities at lines 465–504.

### Source and replay verification

The new local artifact is a valid 28-page PDF and has the ordered digest:

```text
ecc2e31a63f56d443aaa3534f0218b25a5b6ab6e1a84c82db5c7bac1789a1d21  tmp/pdfs/hassett-special-cubic-fourfolds.pdf
```

The complete five-artifact hash replay matches the manifest. The finite
matrix replay again returns

```text
L**5 - 729*L**2*q
```

and `git diff --check` returns no output.

The WP-0.6 delta in this problem directory is confined to
`certificates/REPAIRED_PROOF.md`, this `RESOLUTION.md` entry, and the new
Hassett PDF. `certificates/GAP_REPORT.md` and `DEPENDENCY_MAP.md` are
untouched. Pre-existing user changes in sibling Problem E remain untouched
and are not part of this work order.

### Gate state

**STOP.** WP-0.6 is complete at its assigned scope and awaits director
review of the diff. No WP-1–WP-5 work, author contact, or Lean work has
started.

## 2026-07-29 — WP-1 minimal GW input complete; stopped at director gate

**Completion verdict:** the repaired proof's Gromov--Witten exposure is
definitively reduced to **three interfaces**. The required inventory is
[certificates/GW_INPUT.md](certificates/GW_INPUT.md), and the reductions
which change the proof boundary are incorporated directly in
[certificates/REPAIRED_PROOF.md](certificates/REPAIRED_PROOF.md).

### Surviving rows

1. **GW-1 — F3, AXIOM-INTERFACE.** The full analytic, maximal,
   Hodge-equivariant genus-zero A-model package for the smooth projective
   varieties of dimension at most four reached by the proof. The full rank-27
   big cubic germ is load-bearing in R2; small-\(q\) polynomiality does not
   replace it.
2. **GW-2 — F2, FORMALIZE.** Only the cubic's three degree-one ambient line
   counts \((6,15,6)\). Beauville's Grassmannian formula is now the primary
   input; Givental's general Fano complete-intersection theorem is retained
   only as an independent cross-check.
3. **GW-3 — F3, AXIOM-INTERFACE.** Only the Hodge-compatible blowup
   decomposition for surface point blowups and for smooth fourfold blowups
   along centers of dimension at most two. Iritani is the underlying source,
   not an independent proof; Bayer checks only a point-blowup spectral
   shadow. No complete independent route was found.

### Interface reductions incorporated

- Certificate Lemma 3.5 derives the ambient matrix from Beauville's three
  line-incidence integrals and records a finite coefficient-extraction replay.
  The general Givental/quantum-Lefschetz theorem is deleted from the trusted
  boundary.
- Certificate Lemma 3.6 proves the nef-\(K\) single-atom statement directly
  from grading, virtual dimension, and the unit axiom. KKPY Lemma 5.24 is no
  longer imported.
- Certificate Proposition 3.7 introduces the finer blowup-Hodge-atom quotient
  and telescopes only the blowup formula along weak factorization. The
  positive-\(t^2\) cubic atom cannot come from \(\mathbf P^4\), so it must
  occur in a center of dimension at most two. This deletes KKPY Theorem 4.11,
  Iritani--Koto's projective-bundle theorem, and imported Proposition 5.30.
- Disjoint-union additivity is componentwise bookkeeping, not GW input.
- Primitive-class vanishing in KKPY Lemma 6.11 is downstream of Theorem 6.8
  and is deleted from this target's interface. If later needed, its conclusion
  at \(q_0\) follows from Lemma 3.5, Frobenius symmetry, grading, and
  primitivity.
- Deformation invariance has no separate certificate use-site and is deleted
  as an interface. Beauville invokes it internally in proving his all-smooth
  target statement; that dependence is recorded inside GW-2 rather than
  exposed as a family-transport API.
- The work order's “Proposition 5.31” has no referent in the pinned
  arXiv:2508.05105v2 artifact; Proposition 5.30 is followed by §5.5.

### New pinned source artifacts

~~~text
9d022796aefa01fd601820e415c5462bdfc255b3b4fe158af64b51f7bf0a83e3  tmp/pdfs/beauville-quantum-complete-intersections.pdf
0114923576b2ec3a78fc346fd9f61eb65cfe63f8cc7087881d11626cdb9883c3  tmp/pdfs/2604.10028v2.pdf
~~~

The corresponding extracted text files are retained beside the PDFs for
searchable provenance. The already pinned Iritani blowup v3 PDF has digest
\(c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b\).

### Verification record

The Beauville coefficient extraction returned

~~~text
[6, 15, 6]
~~~

and the matrix replay returned

~~~text
L**5 - 729*L**2*q
~~~

The ordered source-hash replay in certificates/GW_INPUT.md matched all six
expected digests. Control-character scans and git diff --check returned no
output.

Sibling Problem E modifications remain untouched and outside this work order.
No author contact, Lean implementation, or WP-2 factorization work was
performed.

### Gate state

**STOP.** WP-1 is complete at worker scope. Director review asks whether each
of the three rows is genuinely irreducible and each deletion genuinely
justified at its certificate use-site. WP-2 begins only after acceptance.

## 2026-07-29 — gates on WP-0.6 and WP-1: ACCEPTED; WP-2 ordered

WP-0.6: punch list incorporated (N1–N8; diff reviewed against the
acceptance criteria — interface table complete with hashes, no statement
weakened).  WP-1: `GW_INPUT.md` accepted — the program's GW exposure is
three rows (GW-1 bundle package, AXIOM-INTERFACE; GW-2 the three
Beauville numbers, FORMALIZE with Givental as cross-check; GW-3 the
two-case blowup formula via Iritani, AXIOM-INTERFACE), nine deletions
with use-site arguments including deformation invariance and the general
mirror theorem, Prop. 5.30 replaced in-certificate (D8) leaving A7 (weak
factorization) as the sole unexamined non-GW infrastructure input, and
the negative finding that the full rank-27 germ is genuinely required.
The "Prop. 5.31" bibliographic ghost is assigned to WP-2 housekeeping.
`WORKORDER_2.md` issued: decide A7's fate — E1 delete via
morphism-monotonicity (MONO) + Hironaka; E2 pin as the third permanent
axiom interface with the fourfold specialization; E3 timeboxed
restructure probe.
