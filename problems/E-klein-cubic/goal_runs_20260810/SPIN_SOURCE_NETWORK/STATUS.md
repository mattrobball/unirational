# Spin-source fixed network — status

**Date:** 2026-08-10; campaign layer 2026-08-11.
**Problem:** E (Klein cubic / `V14` twin) — the spin flank of [IX §6], plus
the general engine and one new example.
**Headline:** Problem E remains **OPEN**. The fixed-point flank is exhausted
(`SPIN-LINKING-LEMMA-FALSE`, `D10-FIXED-POINT-ROUTE-DEAD`), and as of
2026-08-11 the non-fixed-point flank — the ported Hodge-support census — is
**closed as METHOD-INSUFFICIENT**: every one of its five boxed cells carries
an explicit witness, so no obstruction of that shape exists
(`TOTAL_DEGENERATION.md` Thms W1, W2). What remains open is the boxed
`SPIN-CHAIN-OBSTRUCTION-UNDECIDED` and the three residuals of
`TOTAL_DEGENERATION.md` §6, all of which are statements about the map `phi`
rather than about the support decomposition of `Rp_*IC_Y`.

## Exit ledger

```text
SPIN-SOURCE-NETWORK-COMPUTED

SPIN-CHAIN-OBSTRUCTION-UNDECIDED

NEW-EXAMPLE-ASSESSED
SPIN-DP2-PSL27-UNDECIDED

V14-S3-NONEMPTY                 (2026-08-10)
V14-D10-EMPTY                   (2026-08-10)
V14-A4-NONEMPTY                 (2026-08-10)
V14-A5-EMPTY                    (2026-08-10)
V14-S3-D10-MEASUREMENT-OK       (2026-08-10)

SPIN-MULTIPLICITY-REFUTED       (2026-08-10)
SPIN-LINKING-LEMMA-FALSE        (2026-08-10)
D10-FIXED-POINT-ROUTE-DEAD      (2026-08-10)

SPIN-HODGE-SUPPORT-PROVED           (2026-08-10)
SPIN-SUPPORT-CENSUS-TABLED          (2026-08-10)
SPIN-HODGE-SUPPORT-ESCAPE-UNDECIDED (2026-08-10)

SPIN-ROUTE-CLOSED-METHOD-INSUFFICIENT (2026-08-11)

SPIN-HODGE-SUPPORT-METHOD-INSUFFICIENT (2026-08-11)
TOTAL-DEGENERATION-WITNESS-PROVED      (2026-08-11)
POINT-CELLS-UNCLOSABLE                 (2026-08-11)
POINTWISE-KERNEL-SELECTION-RULE-PROVED (2026-08-11)
BASE-LOCUS-DIMENSION-BOUND             (2026-08-11)

O3-OPEN-WITH-WITNESS        (2026-08-11)
V14-F55-EMPTY-UNCONDITIONAL (2026-08-11)
F55-STRATUM-MANDATORY       (2026-08-11)
O3-CM-TYPE-INDUCED          (2026-08-11)

O2-OPEN-WITH-WITNESS     (2026-08-11)
O2-IMAGE-SURFACE-REGULAR (2026-08-11)

O1-OPEN-WITH-WITNESS     (2026-08-11)
O5-OPEN-WITH-WITNESS     (2026-08-11)
MIN-LIVE-DEGREE-COMPUTED (2026-08-11)
```

`SPIN-CHAIN-OBSTRUCTION-PROVED` is **NOT** claimed. The chain system does not
close; the missing step is boxed verbatim in `KLEIN_SPIN_COMPLEX.md` §7 and
`THEORY_SPIN_ENGINE.md` §7, together with a proof (Thm 7.3 / K5 / F4) that
its naive form is FALSE at first order.

## One line per deliverable

1. **Part 1, general engine** (`THEORY_SPIN_ENGINE.md`) — DERIVED. Swapped
   pairs and the index-two stabiliser (Lem 1.2/1.3); the commutator-pairing
   criterion `P(V)^A != empty <=> Atilde abelian` and the `V_4`/`Q_8`
   corollary, valid for *every* faithful spin source (Prop 2.2, Cor 2.3);
   the whole stratum/incidence/stabiliser network from the character table of
   `Gtilde` (Prop 3.2); the spin carrier theorem for swapped pairs (Thm 4.1)
   and why it is non-obstructing alone (Cor 4.2); **new**: rigidity (Thm 5.1)
   and mandatory base locus (Thm 5.2); **new**: no scalar birth on spin
   sources (Thm 6.1) and first-order separation (Thm 7.3) — the two exact
   structural reasons the Problem-F engine does not transplant; the
   multiplicity reduction that discharges the "all spin sources" quantifier
   (Thm 7.4).
2. **Part 2, Klein** (`KLEIN_SPIN_COMPLEX.md`) — `U|_{Q_8} = 3H` for all 55
   four-groups so `P(U)^{V_4}` is empty; the complete incidence table of the
   110 eigenplanes (1980 meeting pairs, 352 distinct incidence points, 36-
   regular connected graph); Theorems K1-K4 (carriers, `Stab = C_6` exactly,
   rigidity, and the 352-point mandatory base locus) proved unconditionally
   on top of the sealed `FIX-IX-SEAL-PASS` data; K5/K6 show why the chain
   stops.
3. **Part 3, new example** (`NEW_EXAMPLE.md`) — `PSL(2,7)` on the Klein
   degree-two del Pezzo from the spin source `P(U) = P^3`: genuinely open
   (Problem F's `SPEC.md` restricts to linear sources; zero in-repo mentions
   of spin; CTZ's published definition excludes it), engine runs completely
   (42 lines, 56 `S_3`-points, 8-regular connected), two new unconditional
   theorems F1/F2, same boxed lemma. Payoff correctly scoped: it would
   complete Problem F over all projectively-linear sources but yields **no**
   new essential-dimension statement, since `ed_C(PSL(2,7)) = 2` is known
   (Duncan) and `P(spin)` is not weakly versal (Duncan-Reichstein Prop 9.1).
4. **Total degeneration, all nine point cells** (`TOTAL_DEGENERATION.md`) —
   a single witness `(Y_x, q|_{Y_x}, W_x) = (V14, id, H^3(V14,Q))` (Thm W1)
   satisfies every necessary condition the Hodge-support package imposes at
   a point support, in all nine cells `P0`-`P8`, evading all twelve
   cross-cutting kills; the pointwise-kernel selection rule (Thm W3) adds
   two new unconditional kills (`K-m`: constant channel dead on every
   `C_11`-stratum; `K-n`: every rank-one channel dead on every
   `F_55`-stratum), which narrow but do not empty the revived strata `S5`,
   `S8`, since their point layer is witnessed. Verdict: the Hodge-support
   method, ported or not, cannot decide the spin flank. Campaign exit
   `SPIN-ROUTE-CLOSED-METHOD-INSUFFICIENT`. Exits also
   `SPIN-HODGE-SUPPORT-METHOD-INSUFFICIENT`,
   `TOTAL-DEGENERATION-WITNESS-PROVED`, `POINT-CELLS-UNCLOSABLE`,
   `POINTWISE-KERNEL-SELECTION-RULE-PROVED`, `BASE-LOCUS-DIMENSION-BOUND`.
5. **Cell `(O3)`, the odd-order points** (`O3_ODD_ORDER_POINTS.md`) — an
   unconditional proof that `V14^{F_55} = V14^G = empty` (minimal faithful
   degree of `F_55` is `5 > 3`), giving 12 new mandatory `F_55` base points
   on `P(U)` (364 mandatory points total); the forced CM type at a
   `C_11`/`F_55` point is the quadratic-residue type of `Q(zeta_11)`, shown
   to be induced from `Q(sqrt(-11))`, so `Q(zeta_11)`-multiplication and
   `A ~ E_{-11}^5` are the same demand, realised canonically by `J(V14)` —
   no field-mismatch kill. Verdict: OPEN, with a witness. Exits
   `O3-OPEN-WITH-WITNESS`, `V14-F55-EMPTY-UNCONDITIONAL`,
   `F55-STRATUM-MANDATORY`, `O3-CM-TYPE-INDUCED`.
6. **Cell `(O2)`, the 352 mandatory incidence points**
   (`O2_MANDATORY_POINTS.md`) — the `dim Y_x = 2` branch is narrowed (Prop
   O2-3: `rho(V14) = 1` and `b_1(V14) = 0` force a smooth ample divisor of
   `V14` to have irregularity 0, so the required `E_{-11}` can only come
   from branching or singularities of the image surface, not the surface
   itself), and the `dim Y_x = 3` branch carries the Thm W1 witness.
   Verdict: OPEN, with a witness. Exits `O2-OPEN-WITH-WITNESS`,
   `O2-IMAGE-SURFACE-REGULAR`.
7. **Cells `(O1)` and `(O5)`, free supports and the multiplicity strata**
   (`O1_O5_FREE_AND_MULTIPLICITY.md`) — no character obstruction on a free
   support at any degree; the minimal live coordinate degree is computed
   exactly, closing the named task of `SUPPORT_CENSUS.md` §7.4 (`d = 4` for
   `V = U`, `d = 2` for `V = U^{(+)m}`, `m >= 2`, by the Cauchy
   multiplicity `C(m,2)`); capacity is shown to be a low-degree screen
   only, never an all-degree kill. Verdict: both OPEN, with a witness.
   Exits `O1-OPEN-WITH-WITNESS`, `O5-OPEN-WITH-WITNESS`,
   `MIN-LIVE-DEGREE-COMPUTED`.

## Load-bearing citations, not recomputed

* `V14^sigma` = smooth genus-1 sextic + 2 points; `V14^{D_12} = empty`;
  `C_G(sigma) = D_12` — `goal_runs_after_c53d89a/FIX_IX_SEAL`, exit
  `FIX-IX-SEAL-PASS`, char-0 smoothness DISCHARGED.
* `S^{C_2}` = genus-1 curve + 2 points —
  `problems/F-dp2-psl27/certificates/wp1_fixed_loci.py` / `WP1_FIXED_LOCI.md`.

## Named next tasks — BOTH NOW DONE, BOTH NEGATIVE (2026-08-10); a third named
task closed 2026-08-11

1. ~~**`V14^{S_3}` and `V14^{D_10}`**~~ — measured
   (`V14_S3_D10_MEASUREMENT.md`, exits `V14-S3-NONEMPTY`, `V14-D10-EMPTY`,
   `V14-A4-NONEMPTY`, `V14-A5-EMPTY`). `V14^{S_3}` is **not** empty, so route 2
   cannot close by emptiness; Thm V3 then rules the second-generation strata
   out as chain links.
2. ~~**Multiplicity 2**~~ — executed for all `m >= 1`
   (`MULTIPLICITY_ROUTE.md`, `THEOREM_SPIN_MULTIPLICITY.md`, exits
   `SPIN-MULTIPLICITY-REFUTED`, `SPIN-LINKING-LEMMA-FALSE`,
   `D10-FIXED-POINT-ROUTE-DEAD`). The linking Thm 7.4 predicts at `m >= 2`
   **does not exist**: the trivial multiplicity `m - 1` in `T_x` is exactly
   `dim Z` for the `K`-fixed component `Z` through the incidence point, so the
   normal representation `N_Z` has **zero** `K`-invariants at every `m`, and one
   `G`-equivariant blowup separates all 110 carriers into 110 distinct
   connected components of the involution-fixed locus. Separately, the
   resolution-free form of the `V14^{D_10} = empty` datum is also refuted: an
   explicit `G`-invariant centre makes the `D_10`-fixed locus empty.
3. ~~**minimal live coordinate degree**~~ (`SUPPORT_CENSUS.md` §7.4: "the
   smallest even `d` with `<S^d U^*, 10'> != 0`") — CLOSED
   (`O1_O5_FREE_AND_MULTIPLICITY.md`, `verify_min_degree.py` →
   `MIN_DEGREE_OK`, exit `MIN-LIVE-DEGREE-COMPUTED`). The answer is
   `d = 4` for `V = U` (`dim Hom(M^*, S^4 U^*) = 3`, all smaller even and
   all odd degrees vanish); for the multiplicity source `V = U^{(+)m}`,
   `m >= 2`, it drops to `d = 2` (multiplicity `C(m,2)` by Cauchy). Kill
   `K-g` (at `d = 2` the free component orbit dies) is therefore **vacuous**
   on the minimal source `U` and only in force from `m = 2` on.

**Net state of the box.** The SPIN-LINKING LEMMA is FALSE as boxed, both named
routes are closed, and the fixed-point flank is exhausted (Cor C of
`THEOREM_SPIN_MULTIPLICITY.md`): any future attack on the spin flank needs an
invariant that is not of fixed-point type.

## Exact checks

```text
python3 verify_spin_klein_network.py     -> SPIN_SOURCE_NETWORK_OK
python3 verify_spin_dp2_psl27.py         -> SPIN_DP2_PSL27_OK
python3 verify_v14_s3_d10.py             -> V14-S3-D10-MEASUREMENT-OK
python3 verify_spin_multiplicity.py      -> SPIN_MULTIPLICITY_OK
```

Both are exact, characteristic 0, integer / `Q(i)` arithmetic in dimension
`<= 12`; no sampling, no search, no modular reduction. The second
independently recomputes the whole `q = 11` network through a different code
path and reproduces the first exactly (`crosscheck_q11`).

## Boundaries respected

No withdrawn "every stratum stays RCC" claim is used (the carrier induction
of Thm 4.1 tracks a single stratum, exactly as Cor IX.1 does). No Chow
projectors. The spin statements quantify over all faithful spin sources
wherever they are stated to (Cor 2.3, Thms 4.1, 5.1, 5.2 are
multiplicity-free); where a statement is specific to the multiplicity-free
source `U`, that is said explicitly (Thm 7.3, K5, F4), and Thm 7.4 records
that killing `P(U)` alone is **not** the headline.

---

## Added 2026-08-10 — the non-fixed-point invariant: Hodge support

The fixed-point flank is exhausted (Cor N4 above).  The one non-fixed-point
invariant the repository owns — the ambient normalized-graph Hodge-support
theorem of `goal_runs_20260810/AMBIENT_HODGE_REES_BRIDGE/` — has now been
**ported to spin sources and onto the `V14`**:

* `THEOREM_SPIN_HODGE_SUPPORT.md` — Theorems S0-S3, Corollaries S4-S6.
  Exit `SPIN-HODGE-SUPPORT-PROVED`.
* `SUPPORT_CENSUS.md` — the exact 18-cell admissible-support table, five
  boxed OPEN families.  Exit `SPIN-SUPPORT-CENSUS-TABLED`.
* `verify_spin_hodge_census.py` — `SPIN_HODGE_CENSUS_OK`, 206 exact
  assertions, ~30 s, stdlib only.
* `ADVERSARIAL_TESTS.md` §§S1-S10, including the MANDATORY `D_12` test
  (PASSED) against Cor IX.6.

**What is new.**  `T = H^3(V14,Q)(1)` is identified for the first time
(`T = W_Q`, `End_G = Q(sqrt(-11))`, `J(V14) ~ E_{-11}^5`) from sealed data
plus one Lefschetz count — *not* by transport across Tschinkel--Zhang, which
would have been invalid.  The obstruction survives the fixed-point exhaustion
by construction: it lives on the normalized graph of `phi`, which equivariant
blowups of the source do not change.

**What is not.**  No census cell dies for all degrees and all spin sources,
so the headline consequence chain of Cor IX.5 is **not** triggered.  Problem
E's spin flank remains **OPEN**, now with a non-fixed-point invariant, an
exact necessary condition, and five boxed OPEN cells instead of no named
route.

---

## Added 2026-08-11 — the last cited input sealed, and cell `(O4)` split

* `SEAL_V14_BETTI.md` + `verify_v14_betti.py` (`V14_BETTI_OK`, 41
  assertions).  Exit **`V14-BETTI-SEALED`**.  `b_3(V14) = 10`,
  `h^{2,1}(V14) = 5`, `rho(V14) = 1` are no longer literature values:
  `rho = b_2 = 1` follows from Sommese's Lefschetz theorem for the ample
  rank-5 bundle `O(1)^{(+)5}` on `Gr(2,6)` (the sealed model makes `V14` a
  codimension-5 linear section), and `chi_top(V14) = -6` from exact Schubert
  calculus, whence `b_3 = 4 - chi = 10` and `h^{2,1} = 5`.  **Theorem S0 has
  no unsealed input left.**  Bonus regressions from the same computation:
  `deg = 14`, index 1, genus 8, `chi(O) = 1`, and `h^0(-K) = 10 = dim M`, so
  the sealed `P(M) = P^9` is the anticanonical space and the model is the
  classical `X_14`.
* `O4_EIGENPLANE_CURVES.md` + `verify_o4_census.py` (`O4_CENSUS_OK`, 92
  assertions).  Exit **`O4-SPLIT`**, and `O4-DEAD` is *not* claimed — it is
  now known to be unreachable.  Dead in the constant-coefficient channel:
  whole eigenplanes and whole eigen-lines, eigenplane curves of geometric
  genus 0, and `C_3`-stable plane cubics of nonzero weight (the `C_3` has a
  fixed point on such a cubic, forcing `j = 0`, CM by `Q(sqrt(-3))`, so no
  map from the `E_{-11}`-isotypic `T`).  Open, **with an explicit witness**:
  every eigenplane carries a Hesse-family cubic isomorphic to `E_{-11}` on
  which the residual `C_3` acts as a 3-torsion translation, satisfying
  (AHS-spin) exactly in every channel `psi_j`, `j != 3`.  The census's guess
  that `(O4)` was "finite and explicit enough to be decided" is retracted:
  the candidate family is positive-dimensional in every degree `>= 3` and
  `E_{-11}` is attained, not excludable.  Effort belongs on `(O2)` and
  `(O3)`.
* Capacity sharpened: refined Bézout bounds the **total degree** of the
  distinguished varieties, so an orbit of 110 plane cubics needs even
  `d >= 6`, not `d >= 4`.
* `ADVERSARIAL_TESTS.md` §S9' and §§T1-T7, including the mandatory `D_12`
  test against Cor IX.6 (PASSED: the surviving subcell is exactly the one the
  realised `D_12`-map may occupy) and the `j = 8192/11` overreach, explicitly
  not committed.

Headline unchanged: **OPEN**.

---

## Added 2026-08-11 — the residuals campaign: `RESIDUALS-PARTIAL`

The three residuals boxed in `TOTAL_DEGENERATION.md` §6 were attacked.  Step 0
was a dependency map, done and pushed first, and it re-scoped the campaign.

### Exit ledger (campaign layer)

```text
DEPENDENCY-MAP-COMPUTED               (2026-08-11)
O4-BLOCKS-HEADLINE-REGARDLESS         (2026-08-11)
FREE-LAYER-BLOCKS-HEADLINE-REGARDLESS (2026-08-11)
UNIQUE-JUMP-DIMENSION-RULE            (2026-08-11)
R2-SCOPE-IS-ALL-POINT-CELLS           (2026-08-11)
REDUCED-FRONTIER-BOXED                (2026-08-11)

R1-OPEN                               (2026-08-11)
R1-INDUCTION-REFUTED                  (2026-08-11)
R1-INITIAL-MAP-LANDS-IN-TARGET        (2026-08-11)
R1-TOTAL-DEGENERATION-RIGIDITY        (2026-08-11)
BASE-LOCUS-DIMENSION-BOUND-2          (2026-08-11)
R1-F55-FILTRATION-NARROWED            (2026-08-11)

R2-NARROWED-NOT-CLOSED                (2026-08-11)
R2-CYCLIC-COVERS-DEAD                 (2026-08-11)
R2-FIBRATION-REFORMULATION            (2026-08-11)
R2-F55-NO-HYPERPLANE-SECTION          (2026-08-11)

R3-METHOD-INSUFFICIENT                (2026-08-11)
CM-RIGIDITY-LEMMA-PROVED              (2026-08-11)
R3-HORIZONTAL-CM-SUBCASE-DEAD         (2026-08-11)
O4G-WITNESSED                         (2026-08-11)

RESIDUALS-PARTIAL                     (2026-08-11, campaign exit)
```

### One line per residual

* **Step 0** (`DEPENDENCY_MAP.md`) — `O4` **blocks the headline regardless**.
  `R1`/`R2` constrain the fibres of `p` over a point support; `R3` constrains
  nonconstant local systems; the Thm O4-5 witness is a constant-coefficient
  block on a positive-dimensional support, so all three miss it, and so does
  the positive-dimensional layer of the free cell `S0`/`(O1)`.  What `R1`-`R3`
  buy is the point layer plus the nonconstant-coefficient layer, leaving one
  boxed frontier organised by Prop D2 (one jump, one dimension).
* **`R1`** (`R1_TOTAL_DEGENERATION.md`) — **OPEN**, and the proposed unlock is
  **refuted**: total degeneration does not force a dominant induced map on the
  exceptional divisor, by an explicit `C_2`-equivariant counterexample
  `[u^2 : v]` whose graph fibre is the whole target while its initial map is
  constant.  New: the initial map always exists and lands in the `V14`
  (Lem R1-1); total degeneration pins `Y_x` completely (`= V14`
  anticanonically, analytic spread `4`); and, unconditionally,
  `dim Bs(phi) >= 2` for every even `d < 14` (Thm R1-4).
* **`R2`** (`R2_AMPLE_COVERS.md`) — **NARROWED, NOT CLOSED**, the only residual
  of the three whose status is genuinely undetermined.  New: every cyclic
  cover of a smooth `Z_x` branched along a nef-and-big class has `q = 0`
  (Thm R2-2), and at the 12 `F_55`-points `Z_x` cannot be a hyperplane section
  (Prop R2-4).  The residual is a singular image divisor, a non-cyclic cover,
  or a branch class outside the restriction of `Pic(V14)`.
* **`R3`** (`R3_CM_RIGIDITY.md`) — **METHOD-INSUFFICIENT**, with a two-line
  witness.  The CM-rigidity lemma is proved in the right generality
  (Lem R3-1, with the integral-structure hypothesis made explicit), but its
  hypothesis — CM acting on the *variation* — is not what the package forces;
  the package puts the CM on `IH^1`.  Witness: `L` = the anti-invariant
  summand of `f_*Q` for `f : E_{-11} -> P^1`, a nonconstant rank-one system of
  monodromy order two with `IH^1(P^1,L) = H^1(E_{-11})`.  Even granting the
  lemma's conclusion, "pass to the finite cover" lands on `FRONTIER-1`.

### Cascade

One census entry changes: subcell `O4g` becomes **witnessed**, so cells `S2`,
`S3` are "dead in the constant channel, residual `O4g` witnessed".  Two kills
are added (`K-p`, `K-q`), neither emptying anything.  The mandatory `D_12`
test passes on every verdict.  Headline unchanged: **OPEN**, and
`SPIN-ROUTE-CLOSED-METHOD-INSUFFICIENT` stands and is **not** upgradable by
this campaign.

### Exact checks (campaign layer)

```text
python3 verify_r0_dependency.py    -> R0_DEPENDENCY_OK     (323 assertions)
python3 verify_r1_degeneration.py  -> R1_DEGENERATION_OK   (117 assertions)
python3 verify_r2_covers.py        -> R2_COVERS_OK         (179 assertions)
python3 verify_r3_cm.py            -> R3_CM_OK             ( 90 assertions)
```
