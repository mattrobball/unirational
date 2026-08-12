# NOTEBOOK registration snippet — `SMITH_I3`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.** No git operation was performed; nothing outside
`goal_runs_20260812/SMITH_I3/` was written.

```yaml
- path: problems/E-klein-cubic/goal_runs_20260812/SMITH_I3/
  entry: E56
  kind: goal_run
  verification_class: exact rational / integer arithmetic, prime-free
    throughout (no modular reduction is used or needed); the Hilbert-Mumford
    support test is an exact Phase-I simplex over Fraction with Bland's rule
    and produces a printed certificate on both verdicts (a convex combination
    when semistable, a primitive integer traceless 1-PS with all weights
    strictly positive when unstable); every receiver and census constant is
    consumed BY CITATION and re-read from the sealed artefact by the verifier
    where machine-readable; the C11/C5a/C5b/D10 menus are independently
    rebuilt from the sealed master formula and matched entry-for-entry
    against GLOBAL_COHERENCE results/vectors_d35.json
  primary_exit: SMITH-I3-PIPELINE-VERDICT-SUBSUMED
  superseded_by: null
  char0_scope: |
    Char-0 unconditional, complete proofs in THEOREM.md:
    (a) Theorem I3 -- every nonzero G-covariant T in (Sym^d W* (x) W)^G is
        SL(W)-semistable.  Kempf's canonical destabilising parabolic P(T) is
        functorial in the point; G fixes T, so G is contained in N(P(T)) =
        P(T), so G preserves a proper flag of W, contradicting
        irreducibility.  [T1] + [EXT: Kempf 1978].
    (b) Corollary I3' (the support form) and its exact convex-hull
        reformulation via Gordan: T is semistable iff the barycentre
        ((d-1)/5)*(1,1,1,1,1) lies in conv{alpha - e_c}.
    (c) The single-monomial classification: x^alpha (x) e_c is semistable iff
        alpha - e_c = ((d-1)/5)*(1,1,1,1,1), so 5 must divide d-1.  At
        d = 34 and d = 35 EVERY single-monomial seed is unstable; at d = 36
        exactly five are.
    (d) Lemma U (chi-form per the director correction: q maps the C11-fixed tower into the five points; residual C5 transitivity gives chi(Z^{C11}) = 5*chi(F_x); finiteness read on Z from the census) (order-11 uniformity): on ANY smooth G-equivariant model
        dominating P(W), Ztilde^{C11} is finite (five distinct C11-characters
        on W force isolated fixed points at every blowup stage) and the fibre
        count n_x of q restricted to it is constant over X^{C11}, because the
        residual C5 of N_G(C11) = C11:C5 acts transitively on the five
        receiver points.  Hence 5 divides #Ztilde^{C11} and the five
        order-11 fibre congruences are equal to one another on every model.
    (e) Lemma R: no component of Z^sigma dominates E^X_sigma (every stratum
        of Z is rational + Luroth vs genus 1), giving the order-2
        E^X_sigma congruence unconditionally on Z and on every admissible
        refinement.
    (f) The Smith lemma itself is [EXT] (chi_c congruent to chi_c of the
        fixed locus mod p for a C_p-action).
    Exact finite computation (prime-free): both calibration anchors; the
    exact test on all 637 sealed d=35 layer-0 seeds; the C11 eigenbasis
    level thresholds at d = 34, 35 in both generator frames; the rebuild of
    the C11 / C5a / C5b / D10 menus at d = 35; the order-11 and order-5
    fibre counts and their exact F3 closures against the census.
    NOT claimed: any exclusion, any cut of the 22 live d = 35 cells, any
    value of chi(Ztilde^g) for the actual model, any order-3 numeric
    congruence, any order-6 mod-p claim.
  tracked: true
  notes: |
    Director-commissioned execution of DATA_SPEC_SMITH_I3_20260812.md against
    theory/SCHEME_MAP_CONSEQUENCES_20260812.md sec.3.2 (F2/F3) and its
    Group I item I3.

    Headline: Problem E remains OPEN.  This packet EXCLUDES NO DEGREE and
    cuts none of the 22 live d = 35 cells.

    CALIBRATION.  Both anchors of DATA_SPEC sec.1 PASS before any use.
    (i) F*x with F = sum x_i^2 x_{i+1} tests SEMISTABLE at d = 4, with the
    exact convex certificate lambda = 1/5 on the five diagonal support
    elements, whose combination is the barycentre (3/5)*(1,1,1,1,1) on the
    nose.  (ii) x_0^d e_0 tests UNSTABLE, and the test FINDS the pinned
    destabiliser r = (4,-1,-1,-1,-1) with minimum weight 4(d-1) = 136 at
    d = 35; it is still UNSTABLE at d = 4, so the verdict is not an artefact
    of the degree.  The verifier refuses to run groups B and C if group A is
    not all-green.

    I3 VERDICT: SUBSUMED.  Every pipeline stage that TESTS an object tests a
    Reynolds image R(s) = sum_g rho(g)^{-1} s(rho(g) v)
    (D34_GUIDED_SWEEP/slicelib.py:302-314), which is a G-covariant by
    construction, so Theorem I3 makes the filter vacuous there -- exactly the
    slot the sibling prefilter C13 already occupies at
    PAIR_ATTACK_D35/scripts/layer0_base.py:201 ("C13: automatic (Reynolds
    G-orbit support on seeds)").  NO STAGE ADMITS A NON-SEMISTABLE CANDIDATE
    TUPLE.  Locations checked first-hand: slicelib.py:276-299
    (seed_exponents), produce_d34.py:90-109 (basis_seeds),
    PAIR_ATTACK_D35/results/layer0_A_p331.npy + layer0_C_p331.npy,
    D35_AUDIT/scripts/reynolds.py:18, D35_LANDING/scripts/landlib.py:64,
    the RT lane (RT_SPLIT_AND_DICHOTOMY / AMBIENT_HODGE_REES_BRIDGE
    RESTRICTED_TRANSFER.md -- "restricted" there means restriction of a Hodge
    module from ambient P^4 to X, it enumerates no monomial supports), and
    the ansatz fronts (REMAINING_GOALS_NOTE.md:71, SPEC.md:588 -- invariant
    COEFFICIENT ansaetze, already equivariant).  The seed enumerators DO emit
    unstable supports -- all 637 stored d=35 seeds test UNSTABLE, and at
    d = 34 / d = 35 every single-monomial seed is unstable because 5 does not
    divide d-1 -- but a seed is an argument of the Reynolds operator, not a
    candidate tuple, so admitting them is correct, not a leak.

    I3 NON-VACUOUS CONTENT, recorded for L16.  In a C11-eigenbasis with
    integer character representatives v, the traceless 1-PS
    r = 5v - (sum v)*(1,1,1,1,1) turns I3' into a two-sided LEVEL condition on
    the C11-residue level k := (<v,alpha> - v_c)/11: the support must contain
    a level with 55k <= (sum v)(d-1) and one with 55k >= (sum v)(d-1).
    Evaluated: QR frame v = (1,3,4,5,9) gives r = (-17,-7,-2,3,23) and needs
    a level k <= 13 and a level k >= 14 at BOTH d = 34 and d = 35 (attainable
    range [3,27] resp. [3,28]); the other generator frame v = (2,6,7,8,10)
    gives r = (-23,-3,2,7,17), needing k <= 19 / k >= 20 at d = 34 and
    k <= 20 / k >= 21 at d = 35.  Both are non-vacuous and independent.  No
    current stage runs a residue-enumerated support, so the corollary has NO
    LIVE CONSUMER today.

    F2/F3 AT d = 35.
    ORDER 11 -- CLOSED.  Z^{C11} = 20 points (census, 4 G-orbits of 60 with
    #/fixedK 5).  By Lemma U (chi-form per the director correction: q maps the C11-fixed tower into the five points; residual C5 transitivity gives chi(Z^{C11}) = 5*chi(F_x); finiteness read on Z from the census), n_x = 20/5 = 4 at each of the five C11-fixed
    points of X, so chi(q^{-1}(x)) == 4 (mod 11) there, and -- model
    independently -- the five fibre Euler characteristics are congruent to one
    another mod 11.  F3 closes exactly: 5*4 = 20 = chi(Z^{C11}).  On a further
    model #Ztilde^{C11} = 20 + Delta with 5 | Delta and n_x = 4 + Delta/5; the
    EQUALITY among the five congruences survives every refinement.  The
    result is CONSTANT across all 10 C11 menu entries -- the entry decides
    which row lands on which receiver point, never the count.  Byproduct: the
    10 menu entries are reconstructed from the sealed master formula and
    matched exactly, recovering their mu-labels (mu = 1..10, since 35 == 2
    mod 11 is a non-residue), and the maximum number of DEFINED C11 rows over
    the whole menu is 3, never 4 -- an independent reproduction of
    STAGE2_ODD_ORDER_PINNING Thm 2.1.
    ORDER 5 -- CLOSED.  X^{C5} = 4 points; the residual C2 of D10/C5 has TWO
    orbits {1,4},{2,3}, so Lemma U (chi-form per the director correction: q maps the C11-fixed tower into the five points; residual C5 transitivity gives chi(Z^{C11}) = 5*chi(F_x); finiteness read on Z from the census) is unavailable and the count is done row by
    row: the ten immune C5 rows each give 132/66 = 2 components for one fixed
    C5 (10*2 = 20 = census), and since 5 | 35 the receiver weight is
    w = mu*c (mod 5).  Each (a)- and (b)-block deposits 2 points over every
    receiver point and the two D10-rows deposit 1 each, so n_x = 5 at all four
    points for ALL 64 menu entries: chi(q^{-1}(x)) == 0 (mod 5).  F3 closes
    exactly: 4*5 = 20 = chi(Z^{C5}).
    ORDER 6 -- F3 cross-check only (6 is not prime, no mod-p claim):
    n_x = 38/2 = 19 and 2*19 = 38 = chi(Z^{C6}).
    ORDER 2 -- one branch CLOSED, one PARAMETRIC.  X^sigma = E^X_sigma
    (genus 1, chi 0) u L^X_sigma (chi 2).  By Lemma R, chi(q^{-1}(x)) == 0
    (mod 2) for all but finitely many x in E^X_sigma, unconditionally on Z and
    on every ADMISSIBLE refinement.  The escape is a sigma-fixed IRRATIONAL
    stratum dominating E^X_sigma; Group G forces an irrational centre to
    exist, so this branch is LIVE, and if it is the escape that centre is
    exactly a G1 Hodge-carrier at the C2 row (Res_{C2} W = 3(+1) (+) 2(-1)).
    Both branches carried; neither claimed shut.  Over L^X_sigma,
    STAGE1_COMPLEX_MAPS Thm 3 pins exactly three surjecting rows (D_{P_sigma},
    D_{L'_sigma}, the central-involution line in E_{pt_D12}), giving
    chi(q^{-1}(x)) == chi(F_1) + chi(F_2) + n_3 (mod 2) -- reported
    PARAMETRICALLY because no sealed bound at d = 35 pins those three.
    ORDER 3 -- PARAMETRIC.  X^{C3} = 6 points; Z^{C3} has 80 components in
    dims 0/1/2 (62/16/2).  Every component is contracted to one receiver
    point, so the congruences need component Euler characteristics, not
    counts: chi(Z^{C3}) = 94 + chi(S_1) + chi(S_2) with chi(S_i) >= 3 not
    pinned by the census.  The 238 x 238 = 56644 A4 menu pairs are classified
    by the receiver labels their eight immune C3 rows name; no numeric
    congruence claimed.

    MENU DISCIPLINE.  No cell -> menu-subset linkage exists anywhere in the
    record, so per DATA_SPEC sec.2 the FULL menu is admissible for every cell:
    22 * 36 252 160 = 797 547 520 (cell, menu-entry) pairs, none collapsed.
    The menu is a product of six independent centres
    (C11 10 x C5a 4 x C5b 4 x D10 4 x A4a 238 x A4b 238 = F_odd(35)), so the
    report is FACTORED, not collapsed: each order's value is stated on every
    entry of its relevant factor together with the exact free multiplicity of
    the rest, and covered x free-multiplicity = F_odd(35) is machine-checked
    for every reported factor.

    SPEC DIVERGENCE, flagged, branch not patched by judgement.  (1) DATA_SPEC
    sec.2 says "each cell's sigma-band pattern is UNIQUE".  It is not: all 22
    live cells share ONE group_key 0bbfc90a9b60 and identical m/a35 options
    (min_m = max_m = 1, m_options_L [35], m_options_P [1], a35_L_options
    [[35,0]], a35_P_options [[34,1]]).  What is unique per cell is the
    content_hash of the embedded finite-field data.  (2) There is no field
    named sol_hash in D35_AUDIT; the identity fields are content_hash and
    sealed_hash (sol_hash appears only in the later ARCJET_AUDIT /
    D35_EXTENDED_SIEVE scripts, keying an unrelated depth menu).  Cells are
    therefore keyed by (id, content_hash@p331); the id set matches the sealed
    survivors22 exactly and agrees between p = 331 and p = 661, while the
    content hashes differ between primes (they encode mod-p embedding data).
    No conclusion in this packet depended on per-cell sigma-band variation.

    NAMED REMAINDERS.  chi(Z^sigma) and chi(Z^{C3}) are NOT determined by the
    census, which fixes only component counts by dimension (C2 {0:146, 1:80,
    2:11, 3:2}; C3 {0:62, 1:16, 2:2}); F3's global form is therefore closed
    here only at orders 5, 6, 11, where every component is a point.  No sealed
    genus bound binds at d = 35 -- C1 of CONSTRAINT_ADDITIONS_20260811.md is
    an IDENTITY package (2g-2 = 65nu + sum(a_E - 2m_E)e_E, d*nu = sum m_E e_E)
    in unpinned a_E, m_E, e_E, nu -- so every fibre unknown is carried
    parametrically and no bound is invented.  J1's hypotheses were not checked
    and neither of its branches is assumed: F2/F3 are holomorphy-free,
    twist-free and connectedness-free, so nothing here is conditional on them.

    ZERO / ALL-DEAD AUDIT.  Nothing in this packet returns a zero or an
    all-dead outcome: n_x = 4 and n_x = 5 are positive at every receiver
    point, all 22 cells stay live, every menu factor is non-empty.  The check
    is wired into the verifier (C33) so a future replay cannot silently
    produce one without tripping it; if it ever does, an ODDZERO-standard
    audit is mandatory before any claim.

    Exits: SMITH-I3-ANCHORS-PASS, SMITH-I3-SEMISTABILITY-THEOREM,
    SMITH-I3-SUPPORT-TEST-EXACT, SMITH-I3-EIGENBASIS-COROLLARY,
    SMITH-I3-PIPELINE-VERDICT-SUBSUMED, SMITH-I3-ORDER11-CONGRUENCE,
    SMITH-I3-ORDER5-CONGRUENCE, SMITH-I3-ORDER2-DICHOTOMY,
    SMITH-I3-ORDER3-PARAMETRIC, SMITH-I3-MENU-UNCOLLAPSED,
    SMITH-I3-SPEC-DIVERGENCE-FLAGS, SMITH-I3-NO-DEGREE-EXCLUSION.
    Machine markers: SMITH_I3_VERIFY_OK, ALLGREEN (95 checks, 0 failures,
    0 skips; groups A = 10, B = 50, C = 35).
```

## Honesty tiering

| tier | content |
|---|---|
| `[T1]` complete proof here, prime-free | Theorem I3 (modulo `[EXT]` Kempf); Corollary I3′ and its Gordan reformulation; the single-monomial classification; Lemma U (chi-form per the director correction: q maps the C11-fixed tower into the five points; residual C5 transitivity gives chi(Z^{C11}) = 5*chi(F_x); finiteness read on Z from the census) (order-11 finiteness + uniformity); Lemma R (no rational component dominates `E^X_σ`); the order-11 and order-5 fibre counts and their F3 closures; the order-2 `E^X_σ` congruence on `Z` and on admissible refinements |
| `[T2]` machine-verified, exact | both calibration anchors with certificates; the exact test on all 637 sealed `d = 35` seeds; the eigenbasis level thresholds in both frames at `d = 34, 35`; the rebuild of the `C11`/`C5a`/`C5b`/`D10` menus matching the sealed vectors entry-for-entry; the census/receiver constant re-reads; the per-cell × menu bookkeeping |
| `[T3]` stated with an explicitly flagged gap | the order-2 `L^X_σ` congruence (parametric in `χ(F_1), χ(F_2), n_3`); the order-3 congruences (parametric in `χ(S_1), χ(S_2)`); F3's global form at orders 2 and 3 (`χ(Z^g)` not determined by the census) |
| `[EXT]` external-classical import, named at point of use | Kempf instability (optimal destabilising parabolic, canonical); Smith theory; Lüroth; Gordan's theorem of the alternative |

## Downstream edits this packet implies (for the director, NOT made here)

1. `theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §6 proposes rows **L15**
   (Smith mod-p shadow, F2/F3) and **L16** (semistability/support prefilter,
   I3). Both now have executable specifications: L16's is §3.1 of this
   packet's `THEOREM.md` (the eigenbasis level test) with the verdict
   **SUBSUMED at every current stage**; L15's is §5 with orders 11 and 5
   **closed**, order 2 **half-closed**, order 3 **parametric**.
2. `DATA_SPEC_SMITH_I3_20260812.md` §2's "each cell's σ-band pattern is
   UNIQUE … key by `sol_hash`" needs adjudication against `D35_AUDIT`
   (patterns are shared; the field is `content_hash`). See §7.1 of
   `THEOREM.md`.
3. If order 2 / order 3 F3 are wanted closed, the missing input is named
   precisely: the Euler characteristics (not the counts) of the 11 surface +
   2 threefold components of `Z^σ` and the 2 surface components of `Z^{C3}`.
4. No headline changes anywhere: this packet, like the packets it consumes,
   excludes no degree.
