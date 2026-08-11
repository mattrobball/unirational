# NOTEBOOK registration snippet — `STAGE1_COMPLEX_MAPS`

Paste into the repository manifest. Fields follow the manifest schema
(`path` / `entry` / `kind` / `verification_class` / `primary_exit` /
`superseded_by` / `char0_scope` / `tracked` / `notes`).

```yaml
- path: problems/E-klein-cubic/goal_runs_20260810/STAGE1_COMPLEX_MAPS/
  entry: THEOREM.md
  kind: classification
  verification_class: two-engine (exact Z[zeta_6] character theory + F_p linear
    algebra and brute-force group theory at two split primes 331, 661)
  primary_exit: STAGE1-COMPLEX-MAPS-CLASSIFIED
  superseded_by: null
  char0_scope: |
    Char-0 unconditional: the definition of a Stage-1 morphism and constraints
    (A1)-(A5); the geometric cores of Theorems 1, 2, 3, 7, 8 (their 80-row census
    quantification is two-prime; only the two divisorial rows carry
    model-free conclusions -- see THEOREM.md sec. 2 preamble and sec. 14); Theorem 9(i) (the H0-1 parity, exact in
    Z[zeta_6]); Theorem 9(ii) for d <= 45 (exact in Z[zeta_6]).
    Also char-0 unconditional: Theorem 15.1 (EVALUATION RIGIDITY) -- a two-line
    character argument, no computation.
    Two-prime (331, 661, both coprime to 660, identical row-for-row): the
    component-level rebuild of the terminus census, the 145 closure relations,
    the section-moduli table, Theorems 4, 5, 6, 8, the block structure, BOTH
    counts (arc-consistent 69686233329838325760000 and stratum-coherent
    1088847395778723840000), the per-chain evaluation-surjectivity verdicts,
    Theorems 3' and 5', the witness sections, the Layer-2 dimension tables.
    NOT char 0: nothing is claimed beyond order 0; no jets, no algebraization,
    no map.
  tracked: true
  notes: |
    Stage 1 of the two-stage program. Classifies every morphism of decorated
    complexes of groups from the terminus complex F(Z), plus the order-0 delta
    for the corner refinement Z+, of the
    STANDARD_FORM_PW tower to the complex of the Klein cubic X, under the sealed
    constraint rows, for a dominant equivariant P(W) --> X.

    Headline: Problem E remains OPEN. Stage 1 does NOT close it: the set of
    STRATUM-COHERENT ORDER-0 BOUNDARY PATTERNS is non-empty, with
    1088847395778723840000 patterns (994165013537095680000 rigid,
    94682382241628160000 in one-parameter families), factoring as
    2^11 * 21 * 23 * 6^8 * 4^10 * 5^4.

    THE COUNT IS OF BOUNDARY PATTERNS, NOT A MODULI OF MAPS (THEOREM.md sec.
    15.4). Imposing only value-set consistency (arc consistency) gives
    69686233329838325760000; evaluation coherence -- the requirement that the
    value of every row below a swept row be the EVALUATION of one and the same
    Layer-2 component -- divides that by exactly 64 = 2^6. The earlier figure
    69686233329838325760000 is superseded as the headline number and retained
    only as the pre-coherence intermediate.

    New unconditional results:
      * Theorem 3 -- THREE forced sweeps, not one: D_{P_sigma}, D_{L^-_sigma}
        and the central-involution line over the D12-point all map ONTO L_sigma.
        Contains and strengthens the sealed H0-2.
      * Theorem 15.1 (EVALUATION RIGIDITY) -- for every sweep row S and every
        connected component of its Layer-2 moduli M_S, the value at each deeper
        row is CONSTANT on that component (an eigenline of W^-_sigma pinned by
        characters).  Machine-confirmed: 0 rigidity failures over all rows, all
        components, all children, both primes.
      * Theorem 3' -- FIVE MORE forced sweeps from evaluation coherence, so
        EIGHT rows sweep in every coherent section: M^V_tau (the corner packet's
        T3 centre), the two C2-curves over the A4-points and the two over the
        D12-points.  Arc consistency alone admitted a 3-sweep section; no such
        section is stratum-coherent.
      * Theorem 5' -- 12 of the 18 V4-rows are RIGID (a unique type-I vertex);
        only two of them were rigid before coherence.
      * Evaluation-surjectivity verdicts: 13 of the 15 sweep rows have surjective
        joint evaluation maps; the two dim-3 divisors do NOT (images 128 of
        262144 and 64 of 128).  Separately, 38 of the 48 computed components of
        M_{D_{P_sigma}} are legal equivariant sweeps of L_sigma that cannot be
        the restriction of ANY global section -- a cut on Layer 2, not on the
        pattern count.
      * The COHERENCE-IMMUNE factor is isolated: 6^8 * 4^10 * 5^4 =
        1100753141760000 (the 22 rows whose exact stabilizer has ODD order --
        8 C3-rows, 10 C5-rows, 4 C11-rows -- whose only proper parent is the
        free stratum), plus the factor 23 from the D10 C2-line.  Nothing at
        order 0 can pin them; that is the measurement of where Stage-2's work
        lives.
      * Theorem 4 -- the type-II exclusion holds at ALL 18 V4-rows of the
        terminus (2970 components), with no external import. (F2) concerned Z+'s new divisor E_s^V -- zero rows of Z; Theorem 4
        proves the same exclusion for all 18 V4-rows of Z with no external
        import; (F2) remains the only coverage of Z+'s new rows, conditional on
        the EXTERNAL-UNVERIFIED thm:pairs / prop:rcc_total.
      * Theorem 1 -- no admissible refinement of Z ever buys genus, so the
        genus-buying extension variable is identically off and no non-free
        stratum can dominate an E_sigma, at any refinement.
      * Theorem 7 -- exactly one row (the C2-line over a D10-point) can land in
        the open part of an E_sigma; sections avoiding it exist, but no section
        avoids the elliptic curves set-theoretically.
      * Theorem 9(i) -- the sealed H0-1 parity (minus half odd, plus half even
        along a plus-plane) re-derived by pure character theory in Z[zeta_6].
      * Theorem 9(ii) -- N(d,m) > 0 for every odd m <= d (all d; audit-derived closed formula, THEOREM.md sec. 14): the order-0
        leading-datum count imposes NO exclusion beyond the parity. At the first
        open window (d,m,r,n) = (34,1,6,28) the space is 397-dimensional.

    Independent re-derivations obtained as by-products:
      * TERMINUS_STRATA_PW's census re-derived from scratch at component level
        by different code (940/220/55 arrangement, 4901 flags, 11076 components,
        80 rows, 145 closure relations) -- exit
        TERMINUS-CENSUS-INDEPENDENTLY-REPRODUCED.
      * PHI_SEXTIC_ISOGENY Theorem 4 reproduced verbatim on the target side
        (X^{C6} = the two rho-fixed points of L_t, freely swapped by D12/C6).
      * RECEIVER_LEDGER_X named remainder 2 settled in the negative: no
        exact-C3 point lies on any E_sigma (E_sigma is pointwise sigma-fixed).

    Correction consumed, not re-derived: Correction H1-D (FIX_H1_coupling.md
    section 8; NOTEBOOK.md:499, 605, 3177) -- d >= 3r - 2m, n >= 2e, own-point
    vanishing only, cutoff d <= 30, first window d = 34. theory/
    FIX_V_construction.md sections 1-2 still print the withdrawn pre-correction
    numbers (7r - 6m, "first (1,7)-window d = 43"); under the corrected bound the
    (1,7) profile is admissible from d >= 19 and the (3,6) profile from d >= 12.
    HANDOFF_2026-08-06.md lines 55-63 also still carry the withdrawn
    "n >= 6(r-m)" clause a few lines below its own correction.

    Inputs not on main at the time of writing: TERMINUS_STRATA_PW (branch
    agent/terminus-strata-pw-20260810) and RECEIVER_LEDGER_X (branch
    agent/receiver-ledger-x-20260810). Both were read read-only; the two derived
    data files this packet needs are carried in inputs/ with provenance.

    Exits: STAGE1-COMPLEX-MAPS-CLASSIFIED, STAGE1-BOUNDARY-PATTERNS-SEALED,
    STAGE1-EVALUATION-RIGIDITY, STAGE1-TYPE-II-EXCLUSION-ON-Z,
    STAGE1-EIGHT-FORCED-SWEEPS, STAGE1-NO-GENUS-BUYING-ADMISSIBLE,
    STAGE1-WITNESS-SECTION-VERIFIED, TERMINUS-CENSUS-INDEPENDENTLY-REPRODUCED,
    STAGE1-ORDER0-WINDOW-PARITY-ONLY,
    STAGE1-COHERENCE-IMMUNE-FACTOR-ISOLATED.
    (STAGE1-SECTION-MODULI-SEALED and STAGE1-THREE-FORCED-SWEEPS are RENAMED,
    not withdrawn: the first because the count is of boundary patterns, not a
    moduli; the second because the coherence layer raises three to eight.)
    Machine markers: STAGE1_COMPLEX_MAPS_VERIFY_OK, ALLGREEN (123 checks,
    0 failures; 61 per prime including the 14-check evaluation-coherence
    series H1-H14, plus one cross-prime identity check).
```

Audit note (2026-08-10): adversarial audit verdict REGISTER-WITH-EDITS; all
required edits applied (THEOREM.md sec. 14).

Second correction order (2026-08-10, user-mandated): the published count treated
the constraint blocks as independent, which is correct for value-set consistency
but not for the stratum-local part of single-morphism coherence. The evaluation
layer is now imposed and the count re-issued (THEOREM.md sec. 15); the headline
number changes from 69686233329838325760000 to 1088847395778723840000 and is
re-labelled "stratum-coherent order-0 boundary patterns". This snippet reflects
the post-correction state.
