# Adjudication of external round 6 (F55 arithmetic closure attempt)

**Date:** 2026-08-11
**Source:** `round6_arithmetic.md`, external ChatGPT-derived, UNAUDITED on
arrival. Prior calibration: this source's rounds have been mostly right, each
needing supplied proofs, with two dropped overclaims across six rounds.
**Baseline:** `origin/main` at `50ec5d2e`.
**Overall:** the round's own verdict — *no valid proof of emptiness obtained* —
is correct and is preserved. One overclaim is dropped (that makes three across
seven rounds). Nothing else in the round is wrong; almost nothing in it is new.

---

## Check 1 — the operator identity and the two cokernels

**Verdict: CONFIRMED, exactly.** (`verify_operator_identity.py`,
`F55_OPERATOR_IDENTITY_OK`)

| claim | result |
|---|---|
| `(x+2)(x^4-2x^3+4x^2-8x+16) = x^5+32` | exact, in `Z[x]` |
| hence `(2+sigma)G(sigma) = 33` mod `sigma^5 = 1` | exact |
| `det` of the circulant of `2+sigma` on `Z^5` is `33` | exact; Smith form `(1,1,1,1,33)` |
| on `Z^5/Z(1,...,1)` the order is `11` | exact; `det = 11`, Smith form `(1,1,1,11)` |

Also verified, since it is what makes the identity load-bearing:
`G(1) = 11`, so `33 = 3 * 11` splits as (augmentation)×(augmentation-lattice);
`M^{sigma^d} = 0` for `d = 1,2,3,4`; `lambda = (1,9,4,3,5) mod 11` is
well-defined on `M`, annihilates `(2+sigma)M`, and `lambda(e_2) = 4 != 0`;
`(2+sigma)^{-1}e_2 = (-2/11, -1/11, 4/11, -4/11)` has order exactly `11` in
`(M x Q)/M`; and `G(sigma)e_2 = (-6,-3,12,-12) = 33 (2+sigma)^{-1}e_2`.

This is the source's cleanest contribution: `(2.1)` is a *better* handle on
`coker(2+sigma)` than the determinant computation of Lemma 1.2, because it
gives the inverse explicitly. The repository already had it — the identity is
stated and independently director-checked in `theory/FIX_IX_v14.md` §8.28 — but
it lived only inside the value-form campaign and is now stated in the trace
model.

## Check 2 — the three "PROVED reductions"

**Verdict: ALL THREE ALREADY SEALED. Nothing to double-seal.**

| round-6 name | repository home | status |
|---|---|---|
| order-eleven lattice defect | `F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md`, **Lemma 1.2** (with Lemmas 1.1, 1.3) | sealed 2026-08-08 |
| rational-to-Laurent reduction | same note, **Proposition 2.1** (invariant denominator clearing) and **Proposition 2.2** (primitive support-minimal representative) | sealed 2026-08-08 |
| per-support saturation criterion (2) | same note, **Theorem 3.2** (with the exact compiler, Proposition 3.1) | sealed 2026-08-08 |

The round adds no proof to any of the three and states them slightly more
loosely (it omits Lemma 1.3, which is what rules out a common
exponent-translation gauge, and it does not mention that the compiler
coefficients are ordinary integers — the point that removes the five projective
twists and all fifth-root bookkeeping from the all-degree problem).

**What was genuinely missing and is supplied here:** the criterion had no
replayable implementation in the repository — only work orders
(`WORKORDER_F55_PC2/PC5`) and the Coverage-C adjudicator, which checks filters
rather than running the gate. `verify_saturation_supports.py` now compiles the
rows two independent ways, decides `I_S : m_S^inf = (1)` exactly for six
supports, reproduces Coverage-C's `S_16` rows and identity (2.2) from scratch,
and runs the gate in both directions. Details and results:
`SATURATION_CRITERION.md`.

## Check 3 — the tropical-insufficiency theorem (the load-bearing check)

**Verdict: RESTATEMENT of a sealed repository result, with an added universal
quantifier that is FALSE at face value. Ported at the correct strength; the
overclaim is REJECTED.**

The result — *the necessary tropical/Newton condition has an explicit
integral-sloped convex lattice-polytope solution, so that flank cannot prove
emptiness* — is `theory/FIX_IX_v14.md` §8.28 (Correction IX-k) and §8.30(A)
(Correction IX-n), on two independent engines, and is already the basis of the
audit's §3 statement that *"a replacement obstruction must see information lost
by Newton polytopes and divisorial valuations"*.

Round 6 supplies the same three moves — solve over `Q` by the 33-identity, then
add a large invariant convex function, then read off a lattice polytope — which
are §8.28's three moves. The one step it states without proof, *"the 33-identity
lifts every tropical value witness"*, is where it goes wrong:

* the lifting criterion is `33 | G(sigma)(d + m + e_2*)` cellwise;
* mod 3 it is automatic once the free invariant term `m = sum_j d o sigma^j` is
  taken (`G = 1+x+x^2+x^3+x^4 mod 3`, and `sum_i w_i = 0` on `N`);
* mod 11 it is a **genuine congruence on `d`** — congruence (3) — because
  `G mod 11 = (5,3,4,9,1)` is not constant;
* and §8.27 records **15 of 27** one-orbit `(e)`-variants dying at that layer
  alone, with no residue solving it. Those value patterns do not lift.

Read charitably, with "value witness" meaning a solution of the *full*
value-form system including congruence (3), the statement is true and is
exactly §8.28 — but that reading has to be declared. More to the point, the
universal quantifier is **not needed**: insufficiency requires one lattice
polytope satisfying the condition, and the repository has one. The claim is
therefore recorded at instance strength and the universal form is dropped.

**What is supplied here that did not exist:**

1. **Lemma 1 (convention reconciliation).** §8.28's *twice-min* and Proposition
   3.3's *twice-max* are the same condition on the same Newton polytope, read
   at opposite weights (`nu(w) = -h(-w)`). Nothing in the repository connected
   them, and the clash was a live trap.
2. **Lemma 2 / Lemma 3 (the two blocking lemmas, in polytope language).** A
   monomial fails because a tie for all `w` would force `(2+sigma)m = e_2`; a
   `sigma`-invariant `Q = 2P + sigma P - e_2` fails because (2.2) forces
   `G(sigma)e_2` into `11M`, and `(-6,-3,12,-12)` is not divisible by `11`.
   Both are the order-eleven class, and both stop exactly at *equality of the
   five orbit values*; the condition only asks for a **tie**.
3. **Lemma 4 (why convexification is free)** and its one-line proof:
   `(2+sigma)(Tg) = 3Tg` for `sigma`-invariant `g`, so all five orbit values
   shift by the same number and the argmin index set is untouched.
4. **An independent third-engine replay**, `verify_tropical_lift.py`, fan-free:
   it rebuilds `h` from the repository's checked-in witness slopes by the
   33-identity alone and verifies integrality, the defining identity, the
   twice-min read off `h` itself, both CRT layers, and a live negative control,
   on both witness families, at ~3,600 generic lattice points each with all
   five `sigma`-translates. 0 violations throughout; multiplicity of the
   minimum exactly 2. Marker `F55_TROPICAL_LIFT_REPLAY_OK`.

Full statement: `THEOREM_TROPICAL_INSUFFICIENCY.md`. Register: this is a
method-exhaustion theorem, filed alongside the repository's other insufficiency
results, and it does not bear on whether `X_gen(K_proj)` is empty.

## Check 4 — the boxed missing theorem (4) and Coverage-C

**Verdict: (4) is the SAME statement as Coverage-C's residual — not a
refinement, not a different decomposition. The lane's bottom is UNCHANGED.**

`COVERAGE_RELATION.md` carries the proof: quantifying over primitive supports
rather than all finite supports is an equivalence, via Propositions 2.1–2.2 and
Theorem 3.2. Coverage-C already proved that the all-support statement is
equivalent to F55 pointlessness (`F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE`).

Two further findings:

* Round 6 lists `F55-ALL-SUPPORT-COVERAGE`, `X_GEN(K_PROJ)-EMPTY` and
  `PROBLEM-E-NEGATIVE` as three separate UNDECIDED rows. They are one
  statement; carrying the first separately re-creates precisely the illusion
  Coverage-C was written to withdraw.
* Round 6's gap statement — "polar circuits cover only supports containing a
  clean polar diamond or a failed binomial cycle" — is **weaker than the
  repository's own position** and must not overwrite it. Coverage-C §2
  *refutes* the cheap alternatives with the explicit deletion-minimal 16-point
  core `S_16`, and §§3–4 add two proved universal circuits (the four-row polar
  rectangle, the three-row completion) beyond diamonds and binomial cycles.
  Round 6 also omits alternative (iv) of Coverage Theorem C entirely.

## Check 5 — ledger rows and the alternatives (a)/(b)/(c)

**Verdict: statuses ALL CONSISTENT with the packet exits. No silent upgrade or
downgrade. Two presentational faults.**

| round-6 row | round-6 status | repository exit | consistent? |
|---|---|---|---|
| `F55-ORDER-ELEVEN-LATTICE-DEFECT` | PROVED | Lemma 1.2, polar-circuit note | yes |
| `F55-RATIONAL-TO-LAURENT-REDUCTION` | PROVED | Props 2.1–2.2 | yes |
| `F55-EXACT-SUPPORT-SATURATION-CRITERION` | PROVED | Theorem 3.2 | yes |
| `F55-TROPICAL-OBSTRUCTION-INSUFFICIENT` | PROVED | `FIX_IX_v14.md` §8.28, §8.30 | yes, at instance strength (see check 3) |
| `F55-ALL-SUPPORT-COVERAGE` | UNDECIDED | `F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE` | yes, but it is the headline (check 4) |
| `F5-RESIDUE-CUBIC-POINTLESS` | UNDECIDED | `G5_FULL_RESIDUE_CUBICS/STATUS.md`: `f5` point **UNDECIDED**, pointless **NOT PROVED** | yes |
| `F6-RESIDUE-CUBIC-POINTLESS` | UNDECIDED | same, `f6` | yes |
| `GENERIC-EVEN-CLIFFORD-POINT-OBSTRUCTION` | UNDECIDED | `G3D_DIRECT_ARITHMETIC/STATUS.md`: exit `G3D-UNDECIDED`; `G3D-POLAR-CLIFFORD-PARTIAL`, `G3D-SPINOR-DISCRIMINANT-PARTIAL`, `G3D-LINE-27-ALGEBRA-PARTIAL` | yes |
| `X_GEN(K_PROJ)-EMPTY` | UNDECIDED | recorded once as `PROBLEM-E-HEADLINE-OPEN` | yes |
| `PROBLEM-E-NEGATIVE` | UNDECIDED | same | yes |

Round 6's supporting claims, checked one by one:

* *"Both residue cubics smooth full five-coordinate index-one cubics"* —
  **confirmed**: `G5_FULL_RESIDUE_CUBICS/SMOOTHNESS.md` records
  `G5-F5-CUBIC-MODEL-PASS`, `G5-F6-CUBIC-MODEL-PASS` and "both residue cubics
  have index one", with the explicit warning "**Index one is not a rational
  point**".
* *"neither pointlessness nor a point proved"* — **confirmed**:
  `POINT_SEARCH.md` records `UNDECIDED` / `NOT PROVED` for both sites.
* *"Degree-11 trace-hyperplane torsor installed exactly; its K-point question
  is its smallest remaining theorem"* — **confirmed**:
  `H6_TRACE_CUBIC_DECISION/TRACE_HYPERPLANE_TORSOR.md` exits
  `H6-TORSOR-CLASS-PASS`, consuming `H6-PROJECTIVE-11-ISOGENY-PASS`; headline
  `OPEN (structural; not a Problem-E decision)`; the recorded equivalence is
  `Y(K) nonempty <=> exists nonzero a in E with Phi(a) = 0`.
* *"d <= 34 excluded"* — **confirmed** (`HANDOFF_2026-08-11.md` §1: every
  degree `d <= 34` closed; first open window `d = 35`).
* *"d' = 2,3,4,5 excluded uniformly, so nonidentity restricted maps have
  d' >= 6"* — **confirmed**: `RT_ACTUAL_LANDING/EXCLUSION_DPRIME_2_3.md`
  (sealed, every degree) and `D35_K30_K31_CELLS.md` Theorem 1.1 (`d' = 4` and
  `d' = 5` impossible in every ambient degree).
* *"27 open cells at d = 35"* — **confirmed**
  (`RT_ACTUAL_LANDING/STATUS.md`: "Open cells at `d = 35`: **27**").
* *"the sealed equivalence ... emptiness would give ed_C(PSL2(F11)) = 4;
  literature has ed in {3,4}"* — **confirmed** against `NOTEBOOK.md`
  (`ed_C(PSL(2,11)) = 3 or 4`; `ed_C(PSL_2(F_11)) = 3 <=> the Klein cubic is
  G-unirational`).

The two presentational faults:

1. **None of the round's ten marker strings exists in the repository.** All ten
   were grepped; only `X_GEN(K_PROJ)-EMPTY` appears anywhere, and only inside
   the round-5 adjudication as a quotation of an earlier external source, where
   it is explicitly folded into `PROBLEM-E-HEADLINE-OPEN`. Importing the
   round's names as-is would fork the ledger. This packet uses repository
   names and states the mapping.
2. **`F55-ALL-SUPPORT-COVERAGE` is carried as if it were smaller than the
   headline.** It is not (check 4).

One omission worth noting, since it is the only F55 movement since the
polar-circuit note: round 6 does not mention
`F55-LADDER-D6-EMPTY-ALL-TWISTS` / `F55-LADDER-D7-UNDECIDED`
(`goal_runs_20260810/F55_LADDER_COMPLETION`), which closed `d = 6` for all five
twists. Nothing in round 6 conflicts with it.

## Alternatives (a) / (b) / (c)

The round's three unresolved alternatives are the repository's live F55 lanes,
correctly stated and correctly left open:

* **(a) `f5` residue cubic pointless** — `G5-F5-CUBIC-MODEL-PASS`, pointless
  NOT PROVED. Open.
* **(b) `f6` residue cubic pointless** — `G5-F6-CUBIC-MODEL-PASS`, pointless
  NOT PROVED. Open.
* **(c) complete the `K_proj` line/cube/Clifford obstruction** — `G3D` exits
  `G3D-UNDECIDED` with the Clifford, spinor-discriminant and 27-line-algebra
  stages PARTIAL. Open. (Note the recorded in-repo bug: `G3D/STATUS.md`'s
  embedded phase-ledger JSON marks the Witt/spinor phases PASS, contradicting
  its own prose and `SEAL.json`; `SEAL.json` governs. That bug is *not*
  introduced by this round and is not repaired here.)

None of the three is advanced by round 6.

## Net

```text
already sealed in-repo  : the three reductions; the tropical insufficiency result
newly proved here       : Lemma 1 (convention reconciliation), Lemma 2, Lemma 3
                          (the two polytope-level blocking lemmas), Lemma 4
                          (invariant shift preserves the tie set), and the
                          primitive/all-support equivalence of COVERAGE_RELATION
newly replayable here   : the Theorem 3.2 gate (six supports, both directions,
                          two engines); the lifting construction (fan-free,
                          third engine, both witness families)
unverifiable / rejected : "the 33-identity lifts EVERY tropical value witness"
headline                : UNCHANGED, OPEN
```
