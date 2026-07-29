# Problem G — formalization program: irrationality of the very general cubic fourfold

**Status: PHASE 0 (simplification) — work order authored 2026-07-29, not
yet dispatched.**

Source: Katzarkov–Kontsevich–Pantev–Yu, *Birational Invariants from Hodge
Structures and Quantum Multiplication*, arXiv:2508.05105 (v2, 2026-03-06).
Target theorem: **a very general cubic fourfold is not rational**, via
Hodge atoms — spectral pieces of quantum multiplication carrying Hodge
structures, birationally controlled through blowup additivity.

This packet's eventual goal is a Lean 4 / Mathlib formalization in the
house pipeline (natural-language certificate → Lean → comparator), as in
Problem B.  The current phase is *simplification only*: Codex reduces the
argument to a certificate-standard document with a minimal pinned
assumption list, optimized for formalization cost.  The phase doubles as
a skeptical referee pass — the source is a recent preprint claiming a
famous open problem, and a confirmed gap would be a first-class outcome.

## Start here

- [`WORKORDER.md`](WORKORDER.md) — the Codex-facing work order: five work
  packages (dependency map; minimal GW input; the AKMW-avoidance
  question; the F-bundle-free linear-algebra core; Hodge/very-generality
  minimization) with director gates.
- `RESOLUTION.md` — created by the first worker; dated log.
- `certificates/` — receives `DEPENDENCY_MAP.md`, `GW_INPUT.md`,
  `FACTORIZATION.md`, `ATOM_CORE.md`, `GENERALITY.md`, and the phase's
  end product `cubic_fourfold_irrationality_simplified.md`.

## House rules

Inherited unchanged from Problems B/E/F: binary honesty, no lemma stated
that the writer believes might be false, exact citations, dated logs,
failed routes recorded as deliverables, director gates between work
packages.
