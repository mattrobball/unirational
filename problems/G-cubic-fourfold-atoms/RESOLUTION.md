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
