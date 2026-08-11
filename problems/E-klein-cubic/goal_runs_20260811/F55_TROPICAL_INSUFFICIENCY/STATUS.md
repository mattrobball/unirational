# F55 arithmetic round 6 — adjudication and port

**Date:** 2026-08-11
**Branch:** `agent/f55-arithmetic-round-20260811` off `origin/main` at `50ec5d2e`
**Source adjudicated:** external ChatGPT-derived round 6, `round6_arithmetic.md`
(UNAUDITED on arrival; full text quoted in `SOURCES.md`)

## 0. Headline — unchanged

```text
F55-QUESTION-OPEN
TRACE-CUBIC-K-POINT-UNDECIDED
PROBLEM-E-HEADLINE-OPEN
```

The source's own verdict — *emptiness NOT proved* — is correct and is preserved
verbatim. Nothing in this packet claims the headline, in either direction.

## 1. Exit markers

```text
F55-ROUND6-ADJUDICATED
F55_OPERATOR_IDENTITY_OK
F55_SATURATION_SUPPORTS_OK
F55_TROPICAL_LIFT_REPLAY_OK
F55-TROPICAL-INSUFFICIENCY-PROVED           (already sealed in-repo; ported,
                                             re-scoped and independently
                                             replayed here — not new)
F55-ROUND6-THREE-REDUCTIONS-ALREADY-SEALED
F55-ROUND6-UNIVERSAL-LIFTING-OVERCLAIM-REJECTED
F55-ALL-SUPPORT-COVERAGE-EQUIVALENT-TO-HEADLINE
F55-COVERAGE-C-RESIDUAL-UNCHANGED
F55-QUESTION-OPEN
```

Carried through unchanged from the packets they belong to (not re-proved here):

```text
F55-PC-PROOF-REDUCTION-COMPLETE
F55-PC-CHEAP-COVERAGE-REFUTED
F55-PC-HIGHER-CIRCUITS-PASS
F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE
F55-LADDER-D6-EMPTY-ALL-TWISTS
F55-LADDER-D7-UNDECIDED
G5-F5-CUBIC-MODEL-PASS
G5-F6-CUBIC-MODEL-PASS
G5-RESIDUE-TORSOR-MODEL-PASS
H6-TORSOR-CLASS-PASS
H6-PROJECTIVE-11-ISOGENY-PASS
V3-RESIDUE-NORMAL-FORM-PASS
G3D-UNDECIDED
```

## 2. The five checks, in one line each

| # | check | verdict |
|---|---|---|
| 1 | operator identity `(x+2)G(x) = x^5+32`, `33` mod `x^5-1`; Smith forms `(1,1,1,1,33)` on `Z^5` and `(1,1,1,11)` on `M` | **CONFIRMED, exactly** |
| 2 | the three "PROVED reductions" | **all three ALREADY SEALED** in `F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md` (Lemma 1.2, Props 2.1–2.2, Thm 3.2); nothing new to seal. The gate is now replayable — six worked supports, both directions |
| 3 | the tropical-insufficiency theorem | **RESTATEMENT**, not new. The result is sealed in `theory/FIX_IX_v14.md` §§8.28, 8.30. The source's *universal* form ("lifts **every** tropical value witness") is an **OVERCLAIM** and is rejected. The correct statement is ported and independently replayed here |
| 4 | the boxed missing theorem (4) | **the SAME statement as Coverage-C's residual**, hence headline-equivalent. Not a refinement, not a new decomposition. The lane's bottom is **unchanged** |
| 5 | ledger rows and alternatives (a)/(b)/(c) | statuses **all consistent** with the packet exits; **no** silent upgrade or downgrade found. Two presentational faults: none of the source's marker strings exists in the repo, and one row is recorded as if it were smaller than the headline |

Detail: `ADJUDICATION.md`.

## 3. What this packet adds

Nothing that moves the headline. Three things that did not previously exist:

1. **The gate made replayable.** `verify_saturation_supports.py` compiles the
   Proposition 3.1 rows two independent ways and decides
   `I_S : m_S^inf = (1)` exactly for six supports, including Coverage-C's
   deletion-minimal 16-point core. It reproduces Coverage-C's rows `f1,f2,f3,h`
   and its monomial identity (2.2) from scratch, and runs the gate **the other
   way** — deleting the load-bearing row and exhibiting an exact torus point.
   Cross-checked against Macaulay2 (`crosscheck.m2`).
2. **An independent fan-free replay of the lifting construction.**
   `verify_tropical_lift.py` rebuilds `h` from the repo's checked-in witness
   slopes by the 33-identity alone — no fan, no cell algebra, no wall list —
   and verifies integrality, the defining identity, the twice-min condition
   read off `h` itself, the CRT split, and a live negative control, on both
   witness families. This is a second, independent confirmation of §8.28's
   load-bearing step by a third engine.
3. **Two polytope-level blocking lemmas, stated and verified** (`G1`, `G2` in
   `verify_operator_identity.py`): the order-eleven class blocks the two cheap
   ways to satisfy the tie condition, and blocks *only* those.

## 4. What remains open — stated without softening

```text
F55-ALL-SUPPORT-COVERAGE      UNDECIDED  (= the headline; see COVERAGE_RELATION.md)
F5-RESIDUE-CUBIC-POINTLESS    UNDECIDED  (repo: point UNDECIDED, pointless NOT PROVED)
F6-RESIDUE-CUBIC-POINTLESS    UNDECIDED  (repo: point UNDECIDED, pointless NOT PROVED)
GENERIC-EVEN-CLIFFORD         UNDECIDED  (repo: G3D-POLAR-CLIFFORD-PARTIAL,
                                          G3D-SPINOR-DISCRIMINANT-PARTIAL)
X_gen(K_proj) EMPTY           UNDECIDED  (repo: PROBLEM-E-HEADLINE-OPEN)
PROBLEM-E-NEGATIVE            UNDECIDED
```

The tropical flank is **closed as a method**, not as a question: no argument
built from divisorial valuations, Newton polytopes, convexity/integrality of
support functions and `coker(2+sigma) = Z/11` can prove F55 pointlessness,
because the full necessary condition has an explicit lattice-polytope solution.
A negative proof must retain coefficient-level cancellation. That was already
the repo's position before this round; this round does not change it.

## 5. Verifier exits (verbatim, from `logs/`)

```text
F55_OPERATOR_IDENTITY_OK
F55_SATURATION_SUPPORTS_OK
F55_TROPICAL_LIFT_REPLAY_OK
S2 saturation is unit: true
S3 saturation is unit: true
S4 saturation is unit: true
S5 saturation is unit: true
```
