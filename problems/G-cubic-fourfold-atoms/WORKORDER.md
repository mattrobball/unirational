# Problem G — work order: simplification of the cubic-fourfold irrationality proof

**Phase:** pre-formalization simplification.  **Worker:** Codex (goal-plan
harness).  **Director gate:** after WP-0 and after every WP thereafter.
**Authored:** 2026-07-29.

## Source

Katzarkov–Kontsevich–Pantev–Yu, *Birational Invariants from Hodge
Structures and Quantum Multiplication*, arXiv:2508.05105 (v1 2025-08-07,
**v2 2026-03-06** — work from v2, and WP-0 includes a v1→v2 diff; if the
proof of the headline moved between versions, that is a finding, not a
nuisance).  Headline consumed here:

> **Target theorem.**  A very general cubic fourfold is not rational.

The engine: "Hodge atoms" — spectral decomposition of quantum
multiplication (Euler-field action on an F-bundle built from genus-0
Gromov–Witten theory), each spectral piece carrying a Hodge structure,
with blowup additivity supplying birational invariance; irrationality
follows because the transcendental K3-type atom of a very general cubic
fourfold cannot arise from the atoms available to any blowup tower over
\(\mathbf P^4\).

## Mission

**Simplify, simplify, simplify — with formalization as the cost
function.**  The end state of the program is a Lean 4 / Mathlib
formalization in the house pipeline (natural-language certificate first,
then Lean, then comparator packaging, as in Problem B).  Every
simplification is judged by one question: *does it reduce the total cost
of a machine-checked proof?*  Concretely that means: prefer linear and
commutative algebra over analysis; prefer finite explicit computations
over structural theory; quarantine every genuinely analytic or
enumerative input behind a NAMED, PINNED assumption with an exact
literature citation; and shrink the assumption list relentlessly.

This phase produces natural-language artifacts only.  The deliverable
standard is the house certificate style (compare
`../B-conic-bundle-multisections/certificates/all_smooth_tangent_residual_theorem.md`):
self-contained, complete proofs at referee level, every external input
explicitly pinned.

## Skeptical posture — this doubles as a referee pass

The paper is a 2025 preprint, revised 2026, claiming one of the most
famous open problems in the field.  Treat every step on the critical path
as unverified until read.  The house rule applies with full force: never
transcribe a lemma you believe might be false — stop and log the doubt
with the exact location.  A genuine gap found in the paper is a
first-class deliverable of this work order, reported to the director
immediately and logged in `RESOLUTION.md` before any further
simplification work.  WP-0 includes a literature sweep for published
errata, reviews, seminar notes, or counterclaims concerning 2508.05105.

## Work packages

### WP-0 — map the critical path (GATE: nothing else starts first)

1. Extract the exact dependency DAG of the proof of the target theorem
   ONLY — not the whole paper.  Every lemma, proposition, and external
   citation on the path, one node each, with statement numbers from v2.
2. Classify every node:
   - **(L)** linear/commutative algebra, finite combinatorics — cheap to
     formalize;
   - **(GW)** Gromov–Witten / symplectic input — expensive; must end up
     behind pinned assumptions;
   - **(H)** Hodge/lattice theory (including the very-generality /
     Noether–Lefschetz input);
   - **(B)** birational-geometry infrastructure (resolution of
     indeterminacy, weak factorization, MMP);
   - **(V)** "very general" bookkeeping (countable unions, Baire).
3. v1→v2 diff on the critical path; literature sweep for errata and
   independent commentary.
4. Deliverable: `DEPENDENCY_MAP.md` with the DAG, the classification, a
   first formalization-cost ranking, and the three steps the worker
   judges most likely to hide a gap.  STOP at the gate; the director
   reviews before WP-1.

### WP-1 — minimal Gromov–Witten input

The formalization-killer is quantum cohomology at full strength.  Pin
down the MINIMUM the proof consumes:

1. Which structural properties of the genus-0 theory are used
   (associativity/WDVV, divisor axiom, deformation invariance, Iritani-
   or other blowup formulas, convergence/formality of the relevant
   family)?  For each: exact statement, exact use-site, and whether the
   use-site needs the general theorem or only a special case.
2. Which SPECIFIC invariants of the cubic fourfold enter (which degrees,
   which insertions)?  Is the spectral input derivable from a finite
   explicit computation (e.g. small quantum multiplication by the
   hyperplane class in a fixed basis), and is there an independent
   verification route for each number used?
3. Deliverable: `GW_INPUT.md` — the pinned assumption list for the
   (GW)-sector, each item with citation, use-site, special-case
   opportunity, and a formalization-cost class.  The success metric is
   the SHORTNESS of this list.

### WP-2 — the factorization question (highest single leverage)

Determine whether the argument needs weak factorization (AKMW) or
survives on one-sided resolution of indeterminacy (Hironaka only):

1. If atoms enjoy a summand/monotonicity property under blowup — not
   only the additivity equality — then "X rational ⟹ some smooth blowup
   tower over \(\mathbf P^4\) dominates X" may suffice, and AKMW leaves
   the assumption list.  Determine whether the paper's additivity gives
   such a monotonicity, or can be strengthened to it cheaply.
2. Dimension-4 specifics: any factorization actually used passes through
   centers of dimension ≤ 2; record every place the argument can be
   specialized from "smooth projective varieties" to "smooth projective
   fourfolds, centers of dim ≤ 2" and what that saves.
3. Deliverable: `FACTORIZATION.md` with a definite answer (AKMW needed /
   avoidable / avoidable-at-cost-X) and the rewritten argument in the
   avoidable case.

### WP-3 — the linear-algebra core, F-bundle language stripped

Restate the atom formalism at the minimum level of structure the proof
uses:

1. Expected shape: finite-dimensional modules over an explicit base
   (formal disk / Henselian local ring), an operator (Euler action /
   quantum multiplication by the canonical direction), its generalized
   eigenspace decomposition, and the induced filtration data — no
   ∞-categories, no D-modules, no nc-Hodge packaging unless a use-site
   PROVES they are consumed.
2. Rewrite the blowup-additivity statement and its proof in that
   language, at certificate standard, flagging exactly where (GW) and
   (B) assumptions enter.
3. Deliverable: `ATOM_CORE.md` — self-contained, complete proofs, pinned
   assumptions only at the flagged interfaces.

### WP-4 — Hodge input and very-generality

1. Pin the exact lattice-theoretic statement consumed about a very
   general cubic fourfold (irreducibility of the transcendental part /
   no associated K3 in the relevant sense), with the classical citation
   and the cleanest known proof route.
2. Decide the minimal generality of the headline worth formalizing, in
   order of preference: (i) one EXPLICIT smooth cubic fourfold proved
   irrational (requires an effective very-generality substitute — assess
   honestly whether the argument can ever be effective); (ii) "outside a
   countable union of explicitly described divisors"; (iii) "very
   general" as stated.  Deliverable: `GENERALITY.md` with the assessment
   and the recommended target statement for the Lean phase.

### WP-5 — the simplified certificate (the phase's end product)

Assemble WP-1..4 into
`certificates/cubic_fourfold_irrationality_simplified.md`: the complete
simplified argument, self-contained modulo the pinned assumption list,
each assumption named, cited, and cost-classed.  Then iterate: each
further simplification pass must state what it removed, why the removal
is sound, and log failed attempts as delimitations (a failed
simplification, precisely recorded, is a result).  The certificate is
done when the director judges the assumption list minimal and every
non-assumption step formalizable-on-sight.

## House rules — unchanged from Problems B/E/F

Binary honesty about what is proved vs assumed; never state a lemma you
believe might be false; exact citations with statement numbers; dated
`RESOLUTION.md` log entries per session; failed routes and doubts are
deliverables; director gates between WPs; nothing here modifies any
other problem directory.

## What this phase is NOT

No Lean is written in this phase.  No new mathematics is attempted beyond
simplification and gap-checking of the existing argument.  If WP-0 or the
skeptical pass surfaces a genuine gap in 2508.05105, the program halts at
the director gate and the finding is written up at certificate standard —
that outcome is worth more than a formalization of a broken proof.
