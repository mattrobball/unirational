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
    Two-prime (331, 661, both coprime to 660, identical row-for-row): the
    component-level rebuild of the terminus census, the 145 closure relations,
    the section-moduli table, Theorems 4, 5, 6, the block structure, the total
    count 69686233329838325760000, the witness sections, the Layer-2 dimension
    tables.
    NOT char 0: nothing is claimed beyond order 0; no jets, no algebraization,
    no map.
  tracked: true
  notes: |
    Stage 1 of the two-stage program. Classifies every morphism of decorated
    complexes of groups from the terminus complex F(Z), plus the order-0 delta
    for the corner refinement Z+, of the
    STANDARD_FORM_PW tower to the complex of the Klein cubic X, under the sealed
    constraint rows, for a dominant equivariant P(W) --> X.

    Headline: Problem E remains OPEN. Stage 1 does NOT close it: the moduli is
    non-empty, 69686233329838325760000 classes (63626560866374123520000 rigid,
    6059672463464202240000 in one-parameter families).

    New unconditional results:
      * Theorem 3 -- THREE forced sweeps, not one: D_{P_sigma}, D_{L^-_sigma}
        and the central-involution line over the D12-point all map ONTO L_sigma.
        Contains and strengthens the sealed H0-2.
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

    Exits: STAGE1-COMPLEX-MAPS-CLASSIFIED, STAGE1-SECTION-MODULI-SEALED,
    STAGE1-TYPE-II-EXCLUSION-ON-Z, STAGE1-THREE-FORCED-SWEEPS,
    STAGE1-NO-GENUS-BUYING-ADMISSIBLE, STAGE1-WITNESS-SECTION-VERIFIED,
    TERMINUS-CENSUS-INDEPENDENTLY-REPRODUCED, STAGE1-ORDER0-WINDOW-PARITY-ONLY.
    Machine markers: STAGE1_COMPLEX_MAPS_VERIFY_OK, ALLGREEN (95 checks,
    0 failures).
```

Audit note (2026-08-10): adversarial audit verdict REGISTER-WITH-EDITS; all
required edits applied (THEOREM.md sec. 14). This snippet reflects the
post-audit state.
