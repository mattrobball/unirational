# REFEREE REPORT — `goal_runs_20260812/E_LEDGER/`

Hostile-referee pass, clean context, 2026-08-12. Object: `THEOREM.md` and
everything it stands on. Authorities checked against:
`DATA_SPEC_PIPELINE_FLUSH_20260812.md` Lane 1 and
`theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §3.1. Named targets R1–R6 of
the referee brief. Nothing existing was modified; this report and the
`referee_*.py` scripts are the only additions.

**Headline unchanged: Problem E remains OPEN; nothing in this report
excludes any degree.**

## Replay

Full replay in an isolated scratch copy (packet untouched):
`python3 scripts/pipeline.py && python3 verifier.py` →
**214 checks, 0 failures** (A=9, B=8, C=9, D=16, E=6, F=160, G=6),
`E_LEDGER_VERIFY_OK` / `ALLGREEN`, and the regenerated
`results/e_ledger.json` is **identical** to the committed one. python3
stdlib only; no gap/gp/sage/magma; no git.

## Referee scripts (all new, all passing)

| script | what it does independently of the packet's code |
|---|---|
| `referee_chow.py` | R1: recomputes all 15 blowup numbers from the **product model** `E = P^δ × P^{r−1}`, `ξ = η − h` (a route the packet does not use), plus Segre closed form, `(H−E)⁴ = 0` with a sign-flip control, the local forms, and `E·D³ = μ³`. 23/23. |
| `referee_planes.py` | R3 machine fact: own linear algebra; 55 involutions, 55 distinct plus-planes, one `G`-orbit, `|Stab| = 12`, **1485 pairs: 1320 point / 165 line, none disjoint**, at both primes; `G` simple by normal closures. 20/20. |
| `referee_arith.py` | R2/R4: subgroup orders re-derived by an independent sweep (= Dickson's list `{1,2,3,4,5,6,10,11,12,55,60,660}`); Lemma F over **every divisor of 660**; p = 2 failure set exactly `{2,6,10}`; all coefficient tables; the complete `d = 35` arithmetic including hypothesis-necessity controls. 28/28. |
| `referee_lp.py` | R5/R6 from the stored JSON only: 19 rows = the certified incidence vectors at both primes; **all 28 stored LP duality certificates re-verified by an independent checker**; optima, pinning, `d ≥ 7`, the degree-9 gap example; E4 rank 4 at six specialisations + the minor; **the `e_j ∈ rowspace` forced-entry test the packet did not run** (all 46 columns pass). 31/31. |
| `referee_e3_witness.py` | R5 geometry: own arrangement rebuild (940/220/55 in 14 orbits, `orbit × |Stab| = 660`), all **19 witness lines re-verified per prime** with an independent implementation of the `V_min` rule, `z` genuinely off the arrangement; negative-control corroboration (no sampled tuple covers all sampled `z`; both sporadic-hit mechanisms observed and classified). 14/14. |

Total: 116 referee checks, 0 failures, on top of the packet's 214.

---

## Verdicts

### R1 — blowup Chow anchors: **CONFIRMED**

The table (point `H³E = H²E² = HE³ = 0`, `E⁴ = −1`; line `HE³ = 1`,
`E⁴ = 3`; plane `H²E² = −1`, `HE³ = −2`, `E⁴ = −3`; `H⁴ = 1`;
discrepancies 3/2/1) is reproduced by a **third, packet-independent route**:
for a linear centre, `N = O(1)^r` is a twist of a trivial bundle, so
`E = P^δ × P^{r−1}` with `ξ = η − h` in Fulton's sub-bundle convention;
every entry agrees. Both packet cross-check routes verified as claimed:
Fulton's Segre closed form `deg(H^{4−b}E^b) = (−1)^{δ+1} C(b−1, b−4+δ)`
(all 12 entries), and `(H−E)⁴ = 0` (all three centres; a deliberate sign
flip breaks it, so the identity genuinely pins the signs). The derived
local forms `s(point) = m⁴`, `s(line) = 4dm³ − 3m⁴`,
`s(plane) = 6d²m² − 8dm³ + 3m⁴` and `t = 0 / m³ / 3dm² − 2m³` recomputed
exactly. `E·D³ = μ³` at an isolated point centre confirmed (feeds R6).

### R2 — the filter lemma: **CONFIRMED**

The in-packet proof is valid and uses exactly what it says: Lagrange plus
`v_p(660) = 1` for `p ∈ {3,5,11}` gives `v_p(n) = 1 − v_p(|S|)`, hence
`p | n ⟺ p ∤ |S|`. The referee verified it over **all 24 divisors of
660** (the proof never needs the subgroup classification, as claimed).
Sharpness at `p = 2` is exactly right: `v₂(660) = 2` and the equivalence
fails precisely at the subgroup orders with `v₂ = 1`, which among realised
orders is `{2, 6, 10}` — no more, no fewer. The machine-derived subgroup
order set equals Dickson's classical list; the packet's 2-generation sweep
argument is sound (every subgroup class of `PSL(2,11)` — cyclic, dihedral,
`V4`, `A4`, `F55`, `A5`, `G` — is 2-generated).

### R3 — FLAG E2-G-ORBIT: **CONFIRMED** (packet) · the extraction document **needs a correction banner** (exact fix below)

**The machine fact is verified independently at both primes**: all
`C(55,2) = 1485` pairs of plus-planes meet — 1320 in a point, 165 in a
line — so the union is connected; it is one `G`-orbit, hence `G`-stable;
and `STAGE2_ODD_ORDER_PINNING/THEOREM.md:171` Prop 1.3 puts all 55 planes
in `Bs(T)` at every degree (citation checked). (Note: *that* two 2-planes
in `P⁴` meet is automatic — `3 + 3 − 5 ≥ 1`; the machine content is the
1320/165 refinement and the single-orbit fact.)

**Adjudication.** Two indexings of the same identity must be separated.

1. *As §3.1 derives it* — contributions indexed by `G`-orbits of
   **connected components** of `Bs(T°)` — the packet is right and no
   argument rescues the unconditional form: the `s_j` are free integers, a
   `G`-stabilised component enters every congruence with coefficient
   `n = 1`, and §3.1's parenthetical "`G` (excluded: proper components)"
   is a non sequitur — a proper subvariety can perfectly well be
   `G`-stable, and the connected `G`-stable plus-plane union is a live
   candidate the moment it lies in `Bs(T°)` (which Prop 1.3 forces
   whenever `gcd(T) = 1`). Under this indexing **H-PROPER stands as a
   required hypothesis**, exactly as the packet flags. Worse, and worth
   recording: if the plus-planes are in `Bs(T°)`, H-PROPER is not merely
   unproved but **false**, the component containing them has stabiliser
   `G` (order divisible by 11), and the first clause of §4's `d = 35`
   conditional is then false too — the conditional survives as a
   statement but risks being **vacuous** in the main (`gcd = 1`) case.

2. *The rescue that does exist* (this is the correction the extraction
   document should carry): re-index the expansion of
   `0 = (d°H − Σ m_E E)⁴` by `G`-orbits of **monomials in the irreducible
   exceptional divisors** (multisets `M` of ≤ 4 divisor indices). Each
   orbit contributes `(660/|Stab(M)|) · v_M` with `v_M ∈ Z`, and Lemma F
   applies verbatim to `|Stab(M)|`. A multiset of ≤ 4 divisors has
   `Stab(M) = G` only if **every divisor in it is individually
   `G`-fixed**: `G` is simple (referee-verified via normal closures), so
   its action on ≤ 4 objects is trivial. For census divisors that is
   impossible — the minimal census orbit size is 55 — so on the census
   side the `G` row is gone **unconditionally**, and in general it is gone
   under the strictly weaker

   > **HYPOTHESIS H-IRR:** no irreducible component of a blowup centre
   > (equivalently, no π-exceptional prime divisor) is `G`-invariant.

   H-PROPER ⇒ H-IRR (a `G`-invariant irreducible centre lies in a
   `G`-stable component), but not conversely: the plus-plane union is
   `G`-stable yet **reducible**, its 55 divisors form one orbit of size
   55, and under the monomial indexing it contributes with coefficient
   `55 ≡ 0 (mod 11)`, `≡ 0 (mod 5)`, `≡ 1 (mod 3)` — i.e. it is *killed*
   mod 11 and mod 5 and lands in exactly the `P_σ` row §3.1's mod-3 table
   already prints. The connectivity fact loses all its bite. (Also, no
   `G`-invariant irreducible subvariety can hide *inside* the union: an
   irreducible `C` in a union of 55 transitively-permuted planes lies in
   one plane, `G`-stability then puts it in all 55, and
   `∩(all 55) = ∅` since `W` is an irreducible `G`-module — so H-IRR is
   threatened only by genuinely new `G`-invariant irreducible centres
   among the unknown extra orbits, which nothing sealed provides.)

   Under this indexing the `d = 35` corollary's hypothesis reads: *the
   only exceptional divisors with `11 | |Stab|` are the 60 first-blowup
   divisors over the `C11`-points* (plus ND, unchanged: the aggregate over
   the monomials on an isolated ND point divisor is exactly the derived
   `s(point) = μ⁴`). Prop 1.3 does **not** threaten this form (plus-plane
   divisors have `|Stab| = 12`), so the flagship conditional stops being
   vacuity-prone. Mixed census/extra cross-monomials fold into the same
   `|S|`-classes (an order-11 element fixing a multiset fixes each divisor
   in it), so the displayed coefficient tables are unchanged.

**Exact fix for `theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §3.1** (and
the same tables in Group E, "E2"): add a banner —

> CORRECTION (E_LEDGER referee, 2026-08-12). The parenthetical "`G`
> (excluded: proper components)" is not a proof. Indexed by `G`-orbits of
> connected components of `Bs(T°)`, a `G`-stabilised component survives
> every reduction with coefficient 1 (FLAG E2-G-ORBIT; the connected,
> `G`-stable union of the 55 plus-planes is in `Bs(T)` at every degree by
> STAGE2 Prop 1.3, and is such a component whenever it lies in `Bs(T°)`);
> the displayed tables then require H-PROPER. The tables as displayed are
> restored by re-indexing the expansion by `G`-orbits of monomials in the
> irreducible exceptional divisors, under the strictly weaker H-IRR (no
> `G`-invariant irreducible centre): a ≤ 4-element multiset has full
> stabiliser only if each divisor in it is `G`-fixed (`G` simple), which
> is impossible on the census side (minimal orbit size 55). Corollary 2's
> hypothesis should be read divisor-wise ("the only 11-heavy exceptional
> divisors are the 60 `C11`-point divisors"), which Prop 1.3 does not
> threaten. Corollary 1's second clause needs the same re-reading.

The packet's own text needs **no correction**: both forms it reports are
true as stated, the flag is load-bearing exactly as claimed, and it
exercises neither branch. Recommended (non-blocking): record the H-IRR
form as a third branch of FLAG E2-G-ORBIT at next touch.

### R4 — the `d = 35` conditional: **CONFIRMED**

All arithmetic independently verified: `35 ≡ 2 (mod 11)`; fourth powers
mod 11 = QRs `{1,3,4,5,9}` (so 2 is not one); `35⁴ ≡ 5`; `5⁻¹ ≡ 9`;
`s(C11) ≡ 1 − 9·s(F55)` checked for **all** values of `s(F55)` mod 11;
`μ⁴ ≡ 1 ⟺ μ ≡ ±1 (mod 11)` by enumeration. The mod-5 remark is right and
needed: `5 | 35` makes the right side `0`, not the Fermat value 1 (the
authority's `≡ 1` at line 228 is correctly scoped to `p ∤ d°`; the packet
instantiates correctly). Hypothesis necessity checked by controls:
dropping `3 | μ` grows the candidate set to
`{1,10,12,21,23,32,34}`, dropping the mod-11 clause grows it to the 11
multiples of 3 — so both clauses of the `{12, 21}` narrowing bite, and
within the mod-11 statement the 11-heavy-component clause (which subsumes
H-PROPER and `s(F55) = 0`) and the ND clause are each indispensable. The
`3 | μ` step itself is sound: `E·D³ = μ³` (referee-rederived) `= 3(E·C)`
with `E·C ∈ Z`, and 3 is prime. `μ ≤ 35` comes from the certified E3 row
`d ≥ m_i`. One caveat, inherited from R3 and already visible in §7.1:
as component-indexed, the first clause is at risk of being *false* (not
just open) if the plus-planes lie in `Bs(T°)`; the divisor-wise reading
above removes the risk. The packet asserts only the conditional, with
hypotheses named in the same sentence, at every occurrence — checked
against §4, §6, §8 and the spec's Lane-1 pin.

### R5 — the E3 LP: **CONFIRMED** (one explanatory parenthetical in §5.3 mis-attributed; exact rewording below; no number or claim affected)

The 19 certified rows are exactly the 14 one-orbit rows, `d ≥ 2m_P`,
`d ≥ 3m_P`, and the three line-orbit+plane rows, with identical incidence
vectors at both primes; all 19 stored witness lines re-verified per prime
by an independent implementation of the `V_min` rule (own linear algebra,
own arrangement rebuild), including `z` on the line, `z` off the
arrangement, line inside no member. Lemma E3-L's combination filter is
arithmetically right (`Σ(dim V_i + 1) − 5(k−1) ≥ 2` admits exactly the
four listed types; all 11 controls fail it) and the controls' stored
outcomes stand (best tuple 4/12 < 12, so nothing sampled is covering).

One correction to the *explanation* in §5.3: its parenthetical says "the
sporadic hits are the degenerate cases where the two centres meet, and
Lemma E3-T then collapses the incidence to the shared deeper stratum".
That cannot be what the machine counted: `control()` registers a hit only
when `witness()` returns an **exact** target match, and a collapsed
incidence fails the match by construction — a collapse can never be a
hit. The referee's own controls exhibit both mechanisms separately at
`p = 331`: tuple-members-meeting cap hits whose incidence collapses
(counted as *non*-hits, 3 cases for 4-plane tuples), and genuinely clean
witnesses at **special `z`** — `z` on the tuple's proper transversal
locus, e.g. the span-`P³` of two skew line-centres (2 cases; max
per-tuple coverage 1/3 of the sampled `z`). The sporadic control hits are
the second phenomenon. Exact fix for §5.3's parenthetical: "the sporadic
hits are sampled general points that land on the tuple's proper
transversal locus, where a clean member exists; a covering family needs
one through *every* point, and no control tuple came close". The negative
*claims* (NOT_COVERING throughout) are unaffected and confirmed.

All 28 stored duality certificates (14 objectives × 2 blocks) re-verified
by an independent exact checker — weak duality pins every optimum, so no
solver is trusted. `max x_P = 1/3` (⌊35/3⌋ = 11), other 13 optima = 1,
cone coupling changes nothing, pinned system feasible at `d = 35` (E3
excludes no degree), and the binding row is `ell_V + P_σ ≥ 6 + 1`, giving
`d ≥ 7` exactly as recorded. **FLAG E3-DEGREE is honestly scoped**: the
degree-9 example is arithmetically exact (`min(55, 9·12/2 − 1) = 53`
points, `d ≥ (53/9)m_P ≈ 5.9·m_P > 3·m_P`, against a 54-dimensional
system, so irreducibility is genuinely the missing piece), and every use
of the LP in the packet carries the outer-approximation consequence; no
statement of the form "the movable cone permits x" appears. Pinned-table
citations spot-checked at source (B(C11)/B(C5)/B(D10)/B(D12) at
`STAGE2_ODD_ORDER_PINNING`, Prop 2.1 at `STAGE2_SECOND_ORDER:129`,
`CONE_ORDER_AUDIT` CONFIRMED-AT-GENERAL-DEGREE for `ell_V ≥ 6`,
`FIX_II_jets.md:42` for the cone coupling) — all as quoted, and the
`T`/`T°` import is fenced by FLAG E-REDUCED.

### R6 — E4: **CORRECTED** (conclusion true; justification repaired)

Rank: **CONFIRMED**. The 4×46 linear part has rank exactly 4 — referee
recomputation at six integer specialisations (rank ≤ 4 is trivial from
4 rows, so specialisation lower bounds close the gap), and the packet's
certifying minor on `(s_G, t_G, ē_{pt_C11}, g)` is non-singular
(det = `2m₁ ≠ 0`; at `m ≡ 1` it is 2). Variable count 62 and the four
equations match the declaration; R3/R4 coefficients agree with C1 as
reproduced in group B.

No-forced-entries: the packet's stated justification — rank 4 < 46
columns, "so no variable is forced" — is a **non sequitur** (a rank-1
system can force a variable; `e4_system.py` sets `forced = []`
unconditionally when rank < #cols, and verifier check G3 only re-reads
that constant, so the claim was never actually tested). **Exact fix**: a
variable `x_j` is forced by the linear part iff `e_j` lies in the row
space; `referee_lp.py` runs this test for all 46 columns at all six
specialisations — none is in the row space, so the packet's *conclusion*
is true and now machine-certified. No number in the packet changes.
Recommended (non-blocking): fold the `e_j` test into `e4_system.py` /
verifier G3 at next touch. The ND corollary's conditional status and the
`{12, 21}` set are verified under R4.

---

## Minor observations (no action required)

1. §7.1 presents "every pair of plus-planes meets" as a machine fact;
   meeting at all is automatic in `P⁴` (the packet itself uses this in
   §7.2). The non-trivial machine content is the 1320/165 split, the
   single-orbit fact, and Prop 1.3 — all verified.
2. Lemma E3-L's "for every z" existence claim is correct even at special
   `z` (if `z` lies on a centre the constraint for that centre is free),
   though only generic `z` is ever used.
3. The E3 rows implicitly require the resolution tower to dominate the
   wonderful model so that `m_i` pairs against the census divisor
   realising `ord_{D_i}`; this is the authority's "choosable
   `G`-equivariant tower" and is fenced by FLAG E-REDUCED — inherited
   from §3.1, not a packet defect.
4. Verifier group totals, exit-ledger lines, and the registration
   snippet's verification-class text were checked against the artefacts;
   no discrepancy.

## Seal recommendation

**The packet may seal.** Every number replayed (214/0 twice, byte-identical
results) and 116 independent referee checks passed. The three findings are:
(i) R6's no-forced-entries justification was inadequate — conclusion now
independently certified, fix specified; (ii) §5.3's parenthetical
explanation of the sporadic control hits is mis-attributed — rewording
supplied, no claim affected; (iii) the extraction document
`theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §3.1 **does** need the
correction banner given under R3 — the packet's FLAG E2-G-ORBIT is
confirmed as load-bearing, H-PROPER is genuinely required for §3.1's form
as derived, and the sharper H-IRR/monomial form should be recorded so the
`d = 35` conditional is not left resting on a hypothesis that Prop 1.3
plausibly falsifies.

**Problem E remains OPEN. No degree is excluded; nothing here cuts any of
the 22 live `d = 35` cells.**
