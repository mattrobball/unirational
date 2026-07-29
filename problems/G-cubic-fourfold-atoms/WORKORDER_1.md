# Problem G — work order 1: the minimal Gromov–Witten input

**Worker:** Codex.  **Authored:** 2026-07-29.  **Prerequisite:** the
WP-0.6-final `certificates/REPAIRED_PROOF.md` (if 0.6 is still in flight,
work against the accepted certificate plus the audit record and rebase on
the final interface table before reporting).  **Deliverable:**
`certificates/GW_INPUT.md`.  **Gate:** director review; then WP-2
(factorization) per `WORKORDER.md`.

## Mission

The formalization-killer for this program is Gromov–Witten theory at full
strength.  Produce the DEFINITIVE pinned list of what the repaired proof
of Theorem 6.8 consumes from the (GW) sector — each item with its exact
statement, its exact use-sites in the certificate, the honest minimal
special case, an independent verification route, and a formalization-cost
class (F0 = finite exact computation … F3 = major theory).  **The success
metric is the shortness and the cheapness of the list.**  Where an item
can be DERIVED inside the certificate from cheaper items, do so and
delete it from the interface.

## What the audit trail already established — start from this, verify, complete

The three passes (WP-0 map, repair, adversarial audit) suggest the
enumerative content on the critical path is far smaller than "quantum
cohomology of a fourfold."  Candidate final list, to be confirmed or
corrected:

1. **Givental's small quantum ODE for the cubic fourfold.**  Used once,
   to produce the operator `K` with matrix coefficients `6, 15, 6` on the
   ambient 5-dimensional subspace; everything downstream
   (`det(λI − K(q)) = λ²(λ³ − 3⁶q)`, cluster dims `(2,1,1,1)`) is finite
   linear algebra ALREADY IN the certificate, re-derived independently
   three times (KKPY Example 6.6(iii); DEPENDENCY_MAP §6 elimination;
   the audit's from-scratch sympy derivation with uniqueness of
   `6,15,6`).  Pin: the exact statement of the mirror/Quantum-Lefschetz
   theorem consumed (Givental, hypothesis `l = 3 < 5 = n`), which
   PROJECTION of it is used (the ODE for the ambient part only — the
   proof never needs primitive-class invariants beyond Lemma 6.11's
   vanishing), and whether the hypersurface-in-projective-space special
   case has a cheaper self-contained proof in the literature
   (quantum Lefschetz for Fano hypersurfaces of index ≥ 2).
2. **Lemma 6.11-type vanishing** (`κ_b` kills primitive classes at the
   chosen point).  Its printed proof is a virtual-dimension count plus
   the divisor/ambient argument — pin exactly which GW axioms it uses
   (dimension axiom; the fact that `P` and `ψ` are ambient) and whether
   at the R1 point `q₀` the same proof runs verbatim.
3. **Existence, flatness, and analyticity of the A-model F-bundle on the
   ample tube** (KKPY §3.5.2, Lemma 3.29).  This is the packaging of
   genus-0 GW theory: WDVV (flatness), divisor axiom and Fano grading
   (the `q`-structure), effectivity/finiteness in each degree
   (convergence — for a Fano of index 3 the small products are
   POLYNOMIAL in `q`; determine whether the proof needs analyticity
   beyond that polynomiality on the locus the certificate actually
   visits: the small base with `t_i = 0`).  Decompose this item: which
   sub-facts are consumed AT the certificate's use-sites versus which
   belong to the general construction that could be axiomatized as one
   interface.  Note: the certificate's §4 works entirely on the small
   base with the Euler direction — check whether the BIG base (all 27
   directions) is ever consumed except through HYZZ maximality, and
   whether maximality itself can be taken as an interface property of
   the constructed bundle rather than re-derived.
4. **The blowup formula** (KKPY Theorem 4.5 / `CF(X̂) = CF(X) +
   (r−1)CF(Z)`), consumed twice: the point-blowup case inside R5, and
   with centers of dimension ≤ 2 inside the rationality obstruction
   (Prop. 5.30's tower argument).  Pin: is KKPY's proof of 4.5
   self-contained modulo the F-bundle formalism, or does it import
   external GW machinery (deformation to the normal cone, Iritani's
   blowup theorem)?  Record Iritani's independent proof as the
   cross-check either way.  The centers-of-dim-≤-2-in-fourfolds special
   case is the only case consumed — say what that saves, but leave the
   AKMW-vs-Hironaka question strictly to WP-2.
5. **Deformation invariance: likely NOT on the path — confirm.**  The
   argument runs at a fixed `X`; Givental applies to every smooth cubic
   directly.  If no use-site needs invariants transported across the
   family, strike deformation invariance from the interface and record
   the finding — that is exactly the kind of deletion this order exists
   to find.
6. **What is NOT GW at all.**  HYZZ Theorem 3.42 and the certificate's
   Lemmas 3.1–3.2 are formal F-bundle/linear algebra over a base — cost
   class them separately (they are WP-3's inheritance, not GW
   interface).  The atom-formalism rows (Defs 5.21/5.26, Props
   5.22/5.30/5.31, Lemma 5.24) get classified per row: which are formal
   consequences of the bundle package, which secretly consume GW facts
   (Lemma 5.24's proof — nef `K` ⟹ single eigenvalue — check what it
   uses: the grading/divisor axiom on `Eu⋆`?).

## Method and honesty rules

For every candidate deletion or special-casing, the justification is a
USE-SITE argument: quote the certificate line, show the weaker input
suffices there.  No strengthening of any statement; no new mathematics
beyond derivations that shrink the interface.  Independent verification
routes must be genuinely independent (different proof or different
computation, not the same citation twice).  House rules as always; dated
`RESOLUTION.md` entry; a genuine discovery that some item is IRREDUCIBLY
heavy (no special case, no cheap proof, no independent route) is a
first-class finding — record it with the exact reason, because it becomes
a permanent axiom-interface module in the Lean phase.

## Deliverable format (`certificates/GW_INPUT.md`)

One table row per surviving interface item: statement (verbatim or
tightened), source with hash-pinned citation, use-sites (certificate
line references), minimal special case, independent verification route,
cost class, Lean-phase recommendation (FORMALIZE vs AXIOM-INTERFACE).
Then a section of DELETIONS: every candidate input that turned out not
to be consumed, with the use-site argument.  Then the summary count:
the program's GW exposure in one paragraph.

## Gate

Director review of `GW_INPUT.md`.  The review question is single:
*is every row genuinely irreducible, and is every deletion genuinely
justified at its use-site?*  Then WP-2.
