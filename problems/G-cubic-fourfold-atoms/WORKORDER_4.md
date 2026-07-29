# Problem G — work order 4: generality, the Hodge-side rows, and the Lean target statement

**Worker:** Codex.  **Authored:** 2026-07-29.  **Inputs:**
`certificates/ATOM_CORE.md` (the seven-package boundary and the schematic
Lean signatures), `GW_INPUT.md` §2 (table of record), the pinned Hassett
artifact.  **Deliverable:** `certificates/GENERALITY.md` plus table
edits.  **Gate:** director review; then WP-5 assembles the final
simplified certificate and the phase ends.

## PRIORITY PREFIX — audit rework (do this before the three parts)

The 2026-07-29 adversarial audit of the WP-1..3 layer (RESOLUTION.md entry)
found the mathematics sound and the boundary conservative-wrong.  Execute
its rework list first; Parts 2–3 below MUST build on the corrected state:

1. **Retire SEP-CONV via the Henselian route.**  The analytic local ring
   `𝒪_{S,b}` of a smooth k-analytic germ at a rigid point is Henselian
   (pin Bosch 1977 / BGR); ATOM_CORE's Step 1 runs verbatim over any
   Henselian local ring with residue field `k`, producing the `u = 0`
   idempotent decomposition analytically with canonical (hence
   `G`-equivariant) projectors.  Verify the audit's claim that no
   downstream consumer reads more than `u = 0` data (their grep:
   Prop 3.3, Lemma 3.2(4), Cor 3.4, R3), then: delete SEP-CONV from the
   package list; mark ATOM_CORE Theorem 4.1 Steps 2–5 and §5.1 as proved
   but not load-bearing for Theorem 6.8 (retain them — they are correct
   and the HYZZ-repair material has independent value); update the
   trusted base to SIX packages everywhere (ATOM_CORE §§1–2, GW_INPUT
   row + §7 count, FACTORIZATION §6 display).
2. **Upgrade FACTORIZATION §3.2** from "not known" to the audit's proofs:
   horizontality of `f^*f_*` forces `f^*` an isomorphism (the `u = 0`
   flatness identity makes a horizontal idempotent a multiplication
   operator fixing 1); Euler-commutation already fails for
   `Bl_pt ℙ⁴ → ℙ⁴` (`p(κ(1)) = 5H ≠ 5H − 3E`).  E1 is closed by proof.
3. **Name and pin the eight unnamed inputs** (audit §5): the Hodge
   numbers of `ℙ⁴`, point, curve; Hodge symmetry `h^{2,0} = h^{0,2}`;
   `c₁(T_X) = 3h` and `∫_X h⁴ = 3`; the algebra-automorphism clause in
   GW-1; the Fano-scheme-of-lines expected-dimension input behind the
   GW-2 FORMALIZE route (pin it as the classical theorem it is, or take
   the "state Beauville's three numbers directly" fallback both
   documents already offer and dissolve it); and DEFINE "isomorphism of
   cover-native data" (§7.3's first generator).
4. **Write down the flatness identity** that ATOM_CORE Theorem 4.1
   hypothesizes but never displays; correct D8's consumption list
   (add Cor 3.4 / GW-1 / HATOM-RAW and the `ℙ⁴` Hodge numbers).
5. **Hygiene:** rename one of the two "Theorem 4.1"s; fix the
   REPAIRED_PROOF §2 vs §7 table description; reconcile the
   `𝒪_S[[u]]`-vs-`B × D_u` typing note; record in GW-3's row that
   Iritani's *Notes* Prop 8 itself uses HYZZ reconstruction; fix the
   broken macro at REPAIRED_PROOF:187.

Then proceed to the three parts, against the SIX-package base.

## Mission, three parts

### Part 1 — can the theorem ever name ONE cubic?

Assess honestly, at referee standard, whether the argument can be made
effective: an EXPLICIT smooth cubic fourfold certified not rational.
The bottleneck is certifying `NL-CUBIC` for a named `X`: rank
`A(X) = 1`, i.e. no integral Hodge class in `H^{2,2}` beyond `h²`.
Assess the known routes and report which, if any, could ever close:

1. specialization/monodromy arguments producing explicit NL-general
   members (what is actually in the literature for cubic fourfolds, as
   opposed to surfaces in `ℙ³` — Terasoma-style arguments, explicit
   big-monodromy certificates);
2. characteristic-`p` / crystalline or reduction arguments certifying
   Picard/algebraic-cycle rank bounds for an explicit lift (the
   van Luijk method's `H^{2,2}` analogue — does anything like it exist
   in the middle cohomology of fourfolds?);
3. transcendence routes (periods of an explicit cubic — honest
   assessment: presumably hopeless, say so if so).

The expected answer is NO with precise reasons — that is fine and
valuable; a YES sketch would reshape the endgame.  Either way the
recommendation feeds Part 3's target statement.

### Part 2 — shrink the two Hodge-side rows if the use-sites allow

1. **`NL-CUBIC`**: the row currently carries the cubic Hodge diamond and
   Hassett's countable union.  Check each clause against its use-sites:
   is the full diamond consumed, or only `h^{3,1} = 1` plus the
   `H^{2,2}`-rank statement?  Is anything about the divisors' geometry
   used beyond "countable union of proper closed subvarieties of the
   parameter space"?  Tighten the row to exactly what is consumed.
2. **`HATOM-RAW`**: the row bundles the fixed base, the proreductive
   action, the étale spectral cover, the fiberwise primary
   decomposition, and "fixed vectors are exactly the rational Hodge
   classes".  Determine per clause: consumed where, needed in which
   degree (the fixed-vectors clause — full cohomology, or only `H⁴`?),
   and whether any clause is derivable from the others plus proved
   material (candidate: the primary-decomposition clause may follow
   from the certificate's own formal layer given the cover).  Split the
   row if that makes the trusted base smaller-in-content even at the
   cost of one more named hypothesis.

### Part 3 — fix the Lean target statement

`ATOM_CORE.md` §2 drafts two schematic signatures.  Decide and pin, with
reasons, the one the Lean phase will implement:

1. **The quantifier form.**  Recommend the countable-union form over the
   parameter space (the projective space of cubic forms, NOT a coarse
   moduli quotient — no stacks, no GIT in the trusted statement), with
   "very general" as a one-line corollary for the paper.  If Part 1
   surprises with a YES route, add the explicit-instance form as a
   stretch target.
2. **The shape of the parameter-space objects.**  `CubicModuli`,
   `ProperClosedDivisor`, `NLGeneral`, `IsRational` in the schematic
   signature all need concrete Lean-implementable definitions: propose
   each (e.g. `IsRational` via the sibling project's
   `HasUnirationalParametrization`-style birational-map machinery —
   check what B's `Unirationality.lean` already formalized and what
   transfers; rationality needs the birational form, not just dominance
   — say precisely what new definition work Lean will need).
3. **The corollary ladder.**  State the intended final theorem stack:
   core conditional theorem over the seven packages → countable-union
   statement → "very general" phrasing — each as one Lean declaration,
   mirroring how Problem B layered its headline and corollaries.

## Housekeeping

Update `GW_INPUT.md`'s table of record and `FACTORIZATION.md` §6's
display with any Part-2 shrinkage; the two must agree with
`ATOM_CORE.md` §2's package list at the end of this work order.

## House rules

Unchanged.  Part 1's honesty razor: an effectivity claim requires a
route sketched to the level a referee could check; "plausibly" is not a
YES.  Dated `RESOLUTION.md` entry; diff confined to `certificates/`,
`RESOLUTION.md`, `tmp/pdfs/`.

## Gate

Director review of `GENERALITY.md` + the synchronized tables.  Review
questions: is Part 1's verdict argued, not asserted; did Part 2 shrink
rows only where use-sites license it; is Part 3's target statement
implementable as written by a Lean-fluent reader.  On acceptance, WP-5
is the assembly pass and the simplification phase closes.
