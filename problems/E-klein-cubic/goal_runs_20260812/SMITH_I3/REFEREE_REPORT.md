# REFEREE REPORT — SMITH_I3 (hostile pass, clean context, 2026-08-12)

**Headline discipline honoured: Problem E remains OPEN; nothing in this
report excludes any degree or cuts any cell.**

Scope: `THEOREM.md`, all four scripts, `verifier.py`, both results JSONs,
`REGISTRATION_SNIPPET.md`, adjudicated against
`DATA_SPEC_SMITH_I3_20260812.md` and
`theory/SCHEME_MAP_CONSEQUENCES_20260812.md` (§3.2, I3, §6), with first-hand
reads of every cited sealed artefact. Independent machine checks:
`scripts/referee_spotchecks.py` (new file, this pass) — **all green**
(`REFEREE_SPOTCHECKS_OK`); the packet verifier replays **95/95 PASS,
ALLGREEN**. No existing file was modified (the verifier replay regenerates
`results/verifier_output.json` deterministically with identical content, per
the packet's own §6 replay instructions).

Verdict summary: **S1 CONFIRMED · S2 CONFIRMED · S3 CORRECTED · S4 CORRECTED
(one sub-item; the rest confirmed) · S5 CONFIRMED · S6 CONFIRMED (one
precision nit). The packet may SEAL after the two text corrections below.
No computed number changes anywhere.**

---

## S1 — the semistability test's mathematical core: **CONFIRMED**

* **Gordan/convexity reformulation.** Re-derived independently: with
  `w = α − e_c`, `Σ_i w_i = d − 1` is constant on the support, so for
  traceless `r`, `⟨r, w⟩ = ⟨r, w − t⟩` with `t = ((d−1)/5)(1,…,1)`, and
  `π(w) = w − t` *is* the orthogonal projection to `{Σ = 0}`. Gordan's
  strict alternative then gives: destabiliser exists ⟺ `0 ∉ conv(πS)` ⟺
  `t ∉ conv S`. The restriction of `r` to the hyperplane is harmless
  (`⟨r, v⟩ = ⟨π(r), v⟩` for `v` in the hyperplane), and rational solutions
  scale to integer ones by degree-1 homogeneity. Correct. Note the verdict
  is invariant under `r ↦ −r`, so the packet's sign convention (all weights
  `> 0` under the pinned action) and the classical `lim_{t→0} λ(t)·T = 0`
  convention agree on UNSTABLE/SEMISTABLE; the anchors pin the reported
  destabiliser's sign, which is all they need to pin.
* **Exactness of the simplex certificate.** Phase-I over `Fraction`,
  Bland's rule (terminates, no cycling); both certificate types are
  *self-verifying inside `hm_test`* (semistable: `Σλ = 1` and the
  combination hits `t` are asserted; unstable: the integer `r` is asserted
  traceless with min weight `> 0`). Cross-validated here against a
  structurally independent decision procedure (Carathéodory subsets ≤ 6 +
  exact Gaussian elimination): agreement on **300/300 random supports** and
  on both anchors, with certificates re-verified including `λ ≥ 0`
  (`referee_spotchecks.py` R1).
* **Both calibration anchors.** Anchor (i): support and certificate
  hand-checked — `(1/5) Σ_{i∈Z/5}(2e_i + e_{i+1}) = (3/5)(1,…,1) = t` at
  `d = 4`; the element `(α_F + e_c, c)` indeed has `w = α_F`. Anchor (ii):
  one-point hull, never `t` for `d ≥ 2`; the found destabiliser equals the
  pinned `(4,−1,−1,−1,−1)`, min weight `4(d−1) = 136` at `d = 35`; also
  UNSTABLE at `d = 4`. Both PASS and both are the *correct* expected
  verdicts.
* Minor verifier gap (non-fatal, closed by R1): check `A2` re-verifies
  `Σλ = 1` and the barycentre hit but not `λ ≥ 0` on the published
  certificate. `λ ≥ 0` does hold.

## S2 — Theorem I3 and the SUBSUMED verdict: **CONFIRMED**

* **The proof is correctly written.** Kempf's optimal destabilising
  parabolic `P(T)` with functoriality `P(g·T) = gP(T)g^{-1}` `[EXT]`;
  `g·T = T` exactly for `g ∈ G` (covariant), `G ⊂ SL(W)` because `G` is
  perfect (no nontrivial characters, so `det∘ρ = 1`); `N_{SL(W)}(P) = P`;
  parabolic = stabiliser of a proper flag; contradiction with
  irreducibility of `W`. One micro-step is implicit but standard: `P(T)` is
  a *proper* parabolic because the optimal 1-PS is nontrivial, hence
  non-central in `SL(5)`. Corollary I3′ (apply to `a` and `−a`) is exact,
  and consistent (sign-flipped but equivalent) with the theory note's
  `min (a_j − ⟨a,α⟩) ≤ 0 ≤ max` form.
* **Every cited location verified first-hand.**
  `slicelib.py:276-299` (`seed_exponents`, raw `(α, c0)` compositions) ✓;
  `produce_d34.py:90-109` (`basis_seeds` — every independence test runs on
  `jet_rows(...)` output, i.e. on Reynolds images) ✓; `slicelib.py:302-314`
  (`jet_rows` docstring: `R(s)(v) = Σ_g ρ(g)^{-1} s(ρ(g)v)`) ✓;
  `layer0_A/C_p331.npy` (637 rows, degree 35) ✓; `D35_AUDIT/scripts/
  reynolds.py` (`eval_jet`: "Jet coefficients of Reynolds images of seeds")
  ✓; `D35_LANDING/scripts/landlib.py` (`eval_seeds_at_points`: "Evaluate
  all 637 Reynolds seeds", via `jet_rows`) ✓; RT lane genuinely
  non-monomial (`RESTRICTED_TRANSFER.md` is Rees-graph/Hodge-module
  restriction) ✓; `REMAINING_GOALS_NOTE.md:71` (COV structured terminal)
  and `SPEC.md:588` (invariant-coefficient ansätze) ✓;
  `layer0_base.py:11,201` (`"C13": "automatic (Reynolds G-orbit support on
  seeds)"`) ✓.
* The zero-image caveat is handled (I3 is stated for *nonzero* covariants;
  a zero Reynolds image is never a candidate tuple; `hm_test` refuses an
  empty support explicitly). The verdict **SUBSUMED**, with the
  637/637-unstable seeds correctly classified as Reynolds *arguments* and
  not a leak, is exactly the spec's pinned verdict shape. The eigenbasis
  corollary's numbers all reproduce independently (R5): both frames, both
  degrees, thresholds 13/14 and 19/20–20/21, ranges [3,27]/[3,28]/[6,30]/
  [6,31], both `r` traceless, both non-vacuous.

## S3 — the order-11 congruence chain: **CORRECTED** (statement/proof of
Lemma U(a); every number survives)

* **Confirmed:** `n_x = 4` on `Z` (census `Z^{C11}` = 20 = 4 rows × 5;
  independent PSL(2,11) replay in R3: exactly 5 cosets of `G/C11` fixed by
  `C11`, residual `C5` of `N_G(C11)` (order 55) free and transitive on
  them, 12 Sylow-11s); `χ(q^{-1}x) ≡ 4 (mod 11)` at all five points *on
  `Z`*; F3 closes `5·4 = 20`; the refinement bookkeeping `Δ ≡ 0 (mod 5)`;
  menu-constancy (the count argument is assignment-free, so it is constant
  over the whole `F_odd` menu, not just the `C11` factor); the
  mutual-congruence lemma's transitivity half. Indeed the argument gives
  *more* than stated: any `n ∈ N_G(C11)` maps `q^{-1}(x)` biholomorphically
  onto `q^{-1}(n·x)`, so the five full-fibre Euler characteristics are
  outright **equal** on every model — the stated "congruent to one another
  mod 11" is true and strictly weaker.
* **Refuted as stated:** Lemma U(a)'s finiteness claim for **any** smooth
  `G`-equivariant model, and its proof step "again isolated, again with
  pairwise distinct weights. The property is inherited at every stage."
  The inheritance is **false at the first wonderful blowup**: at the
  eigenpoint of character `r = 1` the tangent weights are `{2,3,4,8}`
  (distinct); the stage-1 fixed point on the eigenline of weight 2 has
  tangent weights `{1,2,2,6}`, and on the eigenline of weight 4 it has
  `{4,4,9,10}` — repeated weights (R2, arithmetic check; the mechanism is
  `w_j = 2w_L`). Those points are still *isolated* (all weights nonzero),
  which is why `Z`'s census 20 is untouched — but blowing up the `G`-orbit
  of such a repeated-weight fixed point (a legitimate smooth `G`-stable
  centre, available above any model on which `q` is a morphism) produces
  `P(N)^{C11} ⊇ P(2-dim eigenspace) = P^1`: an infinite `C11`-fixed locus.
  So finiteness cannot be quantified over all models.
* **Exact fix (no downstream change).** Restate Lemma U as: *(a′) `q` maps
  `Z̃^{C11}` into the 5-point set `X^{C11}`; (b) the residual `C5` acts
  transitively on `X^{C11}` and equivariantly on `Z̃^{C11}`, so the five
  `C11`-fixed fibre pieces are pairwise isomorphic; hence
  `χ(Z̃^{C11}) = 5·χ((q|_{Z̃^{C11}})^{-1}(x))` and `5 | χ(Z̃^{C11})`. On
  `Z` the census gives finiteness (20 isolated points) and the count
  `n_x = 4`.* All of §5.2, the F3 closure, the `Δ/5` refinement law and
  the model-independent equality of the five congruences survive verbatim
  (they only ever used (a′) + (b) + the census). The same correction is
  needed in `REGISTRATION_SNIPPET.md` item (d), which repeats the
  over-broad form ("on ANY smooth G-equivariant model ... is finite").

## S4 — order 5 and order 2: **CORRECTED** (one scope error in the
`L^X_σ` branch; everything else confirmed)

* **Order 5 — CONFIRMED.** Independent recount (R4): `n_x = 5` at every
  one of the four points for **all 64** `(μ_a, μ_b, μ_0)` entries; base
  term `35·a_k ≡ 0 (mod 5)` for every row; `{±μ_0, ±2μ_0} = {1,2,3,4}`
  exactly; the row arithmetic `10 × 132/66 = 20` backed by the independent
  group replay (exactly 2 cosets of `G/C5` fixed by `C5`, 66 Sylow-5s);
  F3 closes `4·5 = 20`. The residual `C2` two-orbit structure `{1,4},{2,3}`
  (sealed permutation re-read) correctly disqualifies the transitivity
  shortcut, and the row-by-row count is right. Scope (computed on `Z`,
  refinement deltas not claimed) is carried by §8.
* **Order 2, `E^X_σ` branch — CONFIRMED.** Lemma R is sound: census
  rationality per stratum + Lüroth (a dominant rational map `P^n ⇢ E`
  restricted to a general line is still dominant, extends to a morphism
  `P^1 → E`, impossible for genus 1; `j = 8192/11` re-read from the sealed
  ledger). The escape clause has exactly the right scope: any σ-fixed
  stratum dominating `E^X_σ` is *forced irrational by Lemma R itself*, and
  only non-admissible centres can supply one (sealed I-C/A4: on admissible
  models every stratum is rational — consumed by citation, legitimately).
  Remark (non-blocking): the coupling sentence "that centre is exactly a
  G1 Hodge-carrier at the `C2` row" is plausible (`H¹(E)` injects into
  `H¹` of any dominating stratum) but its character-pairing half is not
  proven here; it is decorative — both branches are carried and neither is
  claimed shut, as required.
* **Order 2, `L^X_σ` branch — CORRECTED (scope).** The display
  `χ(q^{-1}(x)) ≡ χ(F_1) + χ(F_2) + n_3 (mod 2)` overreaches its citation.
  `STAGE1_COMPLEX_MAPS` Theorem 3 (read verbatim) forces the three
  `D12`-rows **onto** `L_σ` and says "**No other row is forced to be
  non-constant**" — it does *not* exclude further σ-fixed components of
  `Z^σ` (up to 79 curve and 11 surface components besides the three, plus
  whatever the actual model adds) from dominating `L^X_σ` in a given
  realisation; Lemma R is silent there (`L^X_σ` is rational). **Exact
  fix:** widen the display to
  `χ(q^{-1}(x)) ≡ χ(F_1) + χ(F_2) + n_3 + Σ_j χ(F_j) (mod 2)`, the sum
  over any further σ-fixed components dominating `L^X_σ` (none forced,
  none excluded), or keep the three-term form under that explicit
  hypothesis. The branch is already reported PARAMETRIC with unpinned
  `χ(F_1), χ(F_2), n_3` (and the C1-is-an-identity finding is correct —
  verified against `CONSTRAINT_ADDITIONS_20260811.md`), so no number,
  check, or exit changes; `f2f3_congruences.py`'s `order2` docstring
  ("therefore the disjoint union of the generic fibres of those three
  rows") needs the same one-line widening.

## S5 — the menu handling: **CONFIRMED**

Factorisation `36 252 160 = 10·4·4·4·238·238` re-checked against both
sealed menu files (`vectors_d35.json` product and `F_odd_counts.json`
record `d_mod_330 = 35`); the menu is a genuine Cartesian product over six
independent centres, each order's verdict depends only on its own
factor(s), and `covered × free = F_odd` holds for every reported factor —
so the factored report covers all `22 × 36 252 160 = 797 547 520` pairs
without collapsing anything. Order-11 constancy is assignment-free (holds
across the *entire* menu); order-5 constancy recounted across all 64. The
`C11` menu rebuilt here independently (one line, `w = 35·9 + μc mod 11`)
matches the sealed vectors entry-for-entry; defined-row vector
`[2,0,2,2,2,3,3,2,2,2]`, max 3, consistent with STAGE2 Thm 2.1;
`35 ≡ 2 (mod 11)` a non-residue ⟹ exactly 10 entries ✓. No cell→menu
linkage exists in the pattern files (fields re-inspected: none present), so
the spec's own fallback ("treat the FULL menu as admissible and say so")
is correctly applied.

## S6 — the two executor flags: **CONFIRMED** (one precision nit)

1. **Shared σ-band — CONFIRMED at both primes.** All 22 live cells carry
   one `group_key` and the identical band
   (`m_L [35]`, `m_P [1]`, `a35_L [[35,0]]`, `a35_P [[34,1]]`,
   `min_m = max_m = 1`); unique-per-cell is only `content_hash`. The spec's
   "each cell's σ-band pattern is UNIQUE" is contradicted by the files; the
   executor's stop-and-flag (key by `(id, content_hash@p331)`, consume the
   band as shared) is the correct DATA_SPEC-conform behaviour. *Nit:* the
   shared key itself is prime-dependent — `0bbfc90a9b60` at `p = 331`,
   `5912f413854e` at `p = 661` (R7). §7.1 should qualify the key with
   "at p = 331", exactly as it already does for `content_hash`.
2. **`sol_hash` — CONFIRMED.** No field named `sol_hash` exists anywhere in
   `D35_AUDIT` (grep over the tree; per-cell fields are
   `content_hash`/`sealed_hash`). `sol_hash` occurs only in
   `goal_runs_20260812/ARCJET_AUDIT` and `goal_runs_20260812/
   D35_EXTENDED_SIEVE`, keying pattern/depth data unrelated to the σ-band.
   The spec's "key by `sol_hash`" is unexecutable against `D35_AUDIT` as
   written; the flag is right and the director should amend the spec text.

## Additional observations (none blocking)

* The blowup-delta parenthetical ("number of eigen-directions of `N`") is
  exact only when the normal weights are distinct; in general
  `χ(P(N)^g_fibre) = Σ_λ dim N_λ = rank N` over a fixed point. It is used
  nowhere quantitatively in this packet (refinements are explicitly not
  closed), so no consequence — but the parenthetical should not survive
  into any packet that *does* run the delta.
* Order-6 (F3-only, no mod-p claim), order-3 parametric bookkeeping
  (`62 + 32 = 94`, `χ(S_i) ≥ 3` for smooth rational surfaces), the
  receiver constants, both residual permutations, `nconj` 12/66, the
  on-X weight sets, the 756/22 split, and the 22 id/hash lists were all
  re-read from the sealed artefacts and match (R3–R7).
* The disambiguation table for the `E_σ` overload (§1) is used
  consistently throughout; no bare `E_σ` appears.
* §7.4's zero/all-dead audit wiring and §8's "Not claimed" list are
  complete and accurate; the packet claims exactly what it proves and
  computes, on the scopes it names.

## Seal recommendation

**The packet may seal after two text corrections (no numeric or code-result
change):**

1. Lemma U(a) restated in the χ-form / `Z`-scoped form above (THEOREM.md
   §5.1 and `REGISTRATION_SNIPPET.md` (d)); the false "pairwise distinct
   weights inherited" sentence removed.
2. The `L^X_σ` branch display widened by the unforced-rows term (THEOREM.md
   §5.4 and the `order2` docstring), or given the explicit three-rows-only
   hypothesis.

Optional (nit-level): add the `λ ≥ 0` check to verifier `A2`; qualify the
shared `group_key` with its prime.

**Problem E remains OPEN. This report excludes no degree and cuts no cell.**

*Referee artefacts:* `scripts/referee_spotchecks.py` (all green;
`REFEREE_SPOTCHECKS_OK`). No existing file modified.
