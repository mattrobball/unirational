<!-- F55_TROPICAL_INSUFFICIENCY_20260811 -->

## 2026-08-11 F55 external round 6 adjudicated: the arithmetic reductions were already sealed, the tropical flank is closed as a method, the bottom is unchanged

Packet: `goal_runs_20260811/F55_TROPICAL_INSUFFICIENCY/`
(`verify_operator_identity.py`, `verify_saturation_supports.py`,
`verify_tropical_lift.py`, `crosscheck.m2`; markers
`F55_OPERATOR_IDENTITY_OK`, `F55_SATURATION_SUPPORTS_OK`,
`F55_TROPICAL_LIFT_REPLAY_OK`; ~4 min total). Branch
`agent/f55-arithmetic-round-20260811`. **F55 remains OPEN; Problem E remains
OPEN.** The round's own verdict — emptiness NOT proved — is correct and is
preserved.

**The three "PROVED reductions" were already ours.** The order-eleven lattice
defect is Lemma 1.2 of `F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md`, the
rational-to-Laurent reduction is Propositions 2.1–2.2, and the per-support
saturation criterion is Theorem 3.2 — all sealed 2026-08-08. Nothing is
double-sealed. What was genuinely missing is that the gate had no replayable
implementation, only work orders. It has one now: a from-scratch compiler that
builds every row twice (the Proposition 3.1 formula, and literal Laurent
expansion) and an exact Rabinowitsch/Buchberger decision of
`I_S : m_S^inf = (1)`, run on six supports and cross-checked in Macaulay2. The
substantive one is Coverage-C's deletion-minimal 16-point core: the compiler
independently reproduces its 1115 rows, its two filter results, its four rows
`f1,f2,f3,h` (five occurrences each, one per `sigma`-orbit) and its monomial
identity (2.2) exactly. The gate is also shown running **the other way** on
those same rows — delete `h` and `{f1,f2,f3}` acquires the exact torus point
`A8=-1, A9=2, A11=-2` (rest `1`), at which `h = -2`. No support with
`I_S : m_S^inf != (1)` exists for the authoritative twist `e_2`, and that is
not an accident: one would be a `K`-point and would settle Problem E
**positively**. A search over all two-point supports with both `m` and the
twist ranging over `{-1,0,1}^4` (6,480 exact saturations) found none.

**The "new content" is a restatement, and its universal quantifier is
false.** The insufficiency theorem — the necessary tropical/Newton condition
has an explicit integral-sloped convex lattice-polytope solution, so valuations
+ Newton polytopes + convexity + `coker(2+sigma) = Z/11` can never prove
emptiness — is `theory/FIX_IX_v14.md` §8.28 (Correction IX-k) and §8.30(A),
two engines, already the basis of the audit's "a replacement obstruction must
see information lost by Newton polytopes and divisorial valuations". Round 6
supplies §8.28's three moves and asserts that the 33-identity "lifts **every**
tropical value witness". It does not: the lifting criterion is
`33 | G(sigma)(d + m + e_2*)`, whose mod-3 half is automatic once the free
invariant term `m = sum_j d o sigma^j` is taken (`G = 1+x+x^2+x^3+x^4 mod 3`,
and `sum_i w_i = 0` on `N`) but whose mod-11 half is a genuine congruence on
`d` (`G mod 11 = (5,3,4,9,1)`), and §8.27 records 15 of 27 one-orbit variants
dying at exactly that layer. The universal form is dropped — insufficiency
needs one polytope, not all of them. **Three overclaims from this source across
seven rounds.**

**What the port adds.** Four lemmas the repository did not have, and a third
engine. (1) `nu(w) = -h(-w)` makes §8.28's *twice-min* and Proposition 3.3's
*twice-max* the same condition on the same Newton polytope, read at opposite
weights — the two formulations had never been connected and the clash was a
live trap. (2) A monomial fails the condition because a tie for all `w` forces
`(2+sigma)m = e_2`, and `lambda(e_2) = 4`. (3) No lattice polytope `P` makes
`2P + sigma P - e_2` `sigma`-invariant: applying `G(sigma)` to
`(2+sigma)h_P = h_Q + e_2^*` gives `33 h_P = 11 h_Q + <., G(sigma)e_2>`, so
`G(sigma)e_2 = (-6,-3,12,-12)` would have to lie in `11M`. Both blocking
lemmas are the order-eleven class in its third guise — and both stop at
*equality* of the five orbit values, while the condition only asks for a
**tie**, which is exactly the room the construction uses. (4) Adding a
`sigma`-invariant `g` shifts all five orbit values by the same `3Tg(w)`, so
convexification cannot disturb the tie set. And `verify_tropical_lift.py`
rebuilds `h` from the checked-in witness slopes by the 33-identity alone —
**no fan, no cell algebra, no wall list** — confirming integrality, the
defining identity, the twice-min read off `h` itself, both CRT layers and a
live negative control, on both witness families, 0 violations, minimum
multiplicity exactly 2. The working convention was re-derived from
33-integrality rather than assumed.

**The bottom is unchanged.** Round 6's boxed theorem (4) — `I_S : m_S^inf = (1)`
for every *primitive* finite support — is Coverage-C's Theorem 1.1 item 3
verbatim: quantifying over primitive rather than all finite supports is an
equivalence via Propositions 2.1–2.2 and Theorem 3.2. So (4) is
headline-equivalent, not a refinement and not a new decomposition, and carrying
it as a separate UNDECIDED row re-creates precisely the illusion Coverage-C was
written to withdraw. Its accompanying gap statement ("polar circuits cover only
diamonds or failed binomial cycles") is also *weaker* than ours: Coverage-C
**refutes** the cheap alternatives with `S_16` and adds two proved universal
circuits beyond them. Every ledger row checks out against the packet exits with
no silent upgrade or downgrade — `f5`/`f6` smooth, index one, point UNDECIDED
and pointlessness NOT PROVED; `H6-TORSOR-CLASS-PASS`; `G3D-UNDECIDED` with the
Clifford and spinor stages PARTIAL; `d <= 34` closed and `d' in {2,3,4,5}`
excluded in every degree; 27 open cells at `d = 35` — but **none of the
round's ten marker strings exists in the repository**, so importing its names
as-is would fork the ledger.

Exits: `F55-ROUND6-ADJUDICATED`,
`F55-ROUND6-THREE-REDUCTIONS-ALREADY-SEALED`,
`F55-ROUND6-UNIVERSAL-LIFTING-OVERCLAIM-REJECTED`,
`F55-TROPICAL-INSUFFICIENCY-PROVED` (ported, not new),
`F55-ALL-SUPPORT-COVERAGE-EQUIVALENT-TO-HEADLINE`,
`F55-COVERAGE-C-RESIDUAL-UNCHANGED`, `F55-QUESTION-OPEN`.
