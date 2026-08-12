# NOTEBOOK registration snippet — `E_LEDGER`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.**

```yaml
- path: problems/E-klein-cubic/goal_runs_20260812/E_LEDGER/
  entry: E56
  kind: goal_run
  verification_class: |
    prime-free intersection theory (Chow ring of P(N) from the Grothendieck
    relation, cross-checked against Fulton's Segre closed form and against
    the projection identity (H-E)^4 = 0) + a prime-free group-theoretic
    lemma (Lagrange and v_p(660) = 1) + exact rational LP with stored primal
    and dual certificates re-verified by exact duality + an independent
    rebuild of the 940/220/55 arrangement at two split primes 331, 661 from
    the shared raw 660-matrix model psl211.py (no STAGE1/STAGE2/TERMINUS
    code imported)
  primary_exit: E-LEDGER-FILTER-LEMMA-PROVED
  superseded_by: null
  char0_scope: |
    Char-0 unconditional: the blowup intersection table for linear centres of
    P^4 (point: H^3E = H^2E^2 = HE^3 = 0, E^4 = -1; line: HE^3 = 1, E^4 = 3;
    plane: H^2E^2 = -1, HE^3 = -2, E^4 = -3; discrepancies 3, 2, 1), derived
    three ways; the reproduction of the sealed C1 relation family (relative
    canonical, projection pairing d.nu = sum m_E e_E, genus package, and the
    level-3 and level-4 rows) as polynomial identities; the derived local
    forms s(point) = mu^4, s(line) = 4dm^3 - 3m^4, s(plane) = 6d^2m^2 -
    8dm^3 + 3m^4 and their level-3 analogues; LEMMA F (the mod-p filter:
    for p in {3,5,11} and S <= PSL(2,11), p divides 660/|S| iff p does not
    divide |S|), proved from Lagrange and v_p(660) = 1 alone, with the p = 2
    control showing the hypothesis is sharp; the three E2 congruence
    coefficient tables; Lemma E3-L (which line families through EVERY point
    exist, by the dimension formula) and Lemma E3-T (a line's strict
    transform on the wonderful model scores only at the minimal member of the
    arrangement containing each intersection point); the exact LP optimum
    max m_{P_sigma}/d = 1/3 with its duality certificate; the rank 4 of the
    E4 linear part with an explicit non-singular 4x4 minor.
    Two-prime finite exact computation: the independent rebuild of the
    arrangement (940 points / 220 lines / 55 planes in 14 G-orbits, orbit
    sizes matching the sealed census, orbit size x |Stab| = 660 throughout);
    the derived set of subgroup orders {1,2,3,4,5,6,10,11,12,55,60,660}; the
    plus-plane pair census (1320 meet in a point, 165 in a line, 0 disjoint);
    the 19 certified covering-family witnesses and the 11 negative controls,
    identical at 331 and 661.
    NOT claimed: any degree exclusion; the E2 congruences in the form
    section 3.1 displays them (they need HYPOTHESIS H-PROPER -- see FLAG
    E2-G-ORBIT); mu = +-1 (mod 11) at d = 35 (conditional, two clauses);
    mu in {12,21} (conditional, three clauses); that the LP's feasible set is
    the movable cone (it is an OUTER approximation -- FLAG E3-DEGREE).
  tracked: true
  notes: |
    Lane 1 of DATA_SPEC_PIPELINE_FLUSH_20260812.md, executed against
    theory/SCHEME_MAP_CONSEQUENCES_20260812.md sec. 3.1 (E2/E3/E4) with
    theory/CONSTRAINT_ADDITIONS_20260811.md C1 as the fatal cross-check.

    Headline: Problem E remains OPEN.  This packet excludes no degree and
    cuts none of the 22 live d = 35 cells.  The first open window stays at
    d = 35.

    THE THREE FATAL GATES ARE GREEN.  (a) Calibration: E^4 = -1 and
    H^3E = H^2E^2 = HE^3 = 0 on Bl_pt P^4 come OUT of the implementation
    (Chow ring of P(N), Grothendieck relation, normalisation
    int xi^{r-1} h^delta = 1), and the whole three-row table is confirmed by
    two independent routes.  (b) The mod-p filter lemma is PROVED in-packet
    from orbit sizes 660/|Gamma_S|: it needs only Lagrange and the fact that
    p^2 does not divide 660 for p in {3,5,11} -- no subgroup classification.
    The p = 2 control fails at |S| in {2,6,10}, which is exactly why the
    spec's prime list is {11,5,3}.  (c) C1 is reproduced at one degree lower
    as five polynomial identities in (d, m).

    E2.  Every coefficient section 3.1 prints is reproduced: mod 11 --
    C11 (60 = 5), F55 (12 = 1); mod 5 -- C5 (132 = 2), D10 (66 = 1),
    F55 (12 = 2), A5 (11 = 1); mod 3 -- C3 (220 = 1), S3/C6 (110 = 2),
    A4/D12 (55 = 1), A5 (11 = 2).  Census orbits surviving the filter:
    p = 11 -> pt_C11 only; p = 5 -> pt_D10, pt_C5(a), pt_C5(b); p = 3 -> the
    nine orbits with 3 | |Stab|.

    FLAG E2-G-ORBIT (load-bearing, branch STOPPED).  Section 3.1 drops the
    |S| = 660 row as "G (excluded: proper components)".  Lemma F does not
    exclude it: 11, 5, 3 all divide 660, so a G-stabilised connected
    component of Bs(T^o) has orbit size 1, survives every reduction, and
    kills the bite.  This packet's rebuild shows every one of the 1485 pairs
    of plus-planes MEETS (1320 in a point, 165 in a line), so the union of
    the 55 plus-planes is connected and G-stable -- and STAGE2 Prop 1.3 puts
    all 55 in Bs(T) at every degree.  Both forms of each congruence are
    reported; neither is exercised.  HYPOTHESIS H-PROPER is named wherever
    the section-3.1 form is used.

    d = 35, order 11.  35 = 2 (mod 11), 2 is not a fourth power mod 11,
    35^4 = 5 (mod 11), and the congruence gives s(C11) = 1 - 9 s(F55)
    (mod 11) -- section 3.1's form, reproduced.  Reported ONLY as:
    IF the only 11-heavy components of Bs(T^o) are the 60 C11-points AND the
    local level-4 contribution at each is the nondegenerate value mu^4, THEN
    mu^4 = 1 (mod 11), i.e. mu = +-1 (mod 11).  Both clauses are hypotheses.

    E3.  Lemma E3-L classifies the line families that pass through EVERY
    point (one centre of any kind; two planes; three planes; a line-centre
    plus a plane) and Lemma E3-T fixes what the strict transform actually
    meets.  19 rows certified at both primes with witnesses; 11 negative
    controls (four planes, all six line-centre pairs, point+plane, and
    line-centre+two-planes for each line orbit) all confirm non-covering.
    Exact LP: max m_{P_sigma}/d = 1/3, so m_{P_sigma} <= 11 at d = 35;
    max m_i/d = 1 for the other thirteen.  Adding the sealed order-cone
    coupling 3 m_{P_sigma} <= 2 m_{ell_V} changes no optimum.  With the
    sealed pinned lower bounds at d = 35 the system is FEASIBLE (no
    exclusion), and the binding row d >= m_{ell_V} + m_{P_sigma} >= 6 + 1
    gives the unconditional degree bound d >= 7.

    FLAG E3-DEGREE (branch STOPPED).  Only degree-1 covering families are
    enumerated, so the LP is an OUTER approximation of the movable-cone
    constraints.  A worked example of the gap is recorded: a general 2-plane
    through a general point meets all 55 plus-planes, so a plane curve of
    degree 9 through 53 of those points would give d >= (53/9) m_P, beating
    d >= 3 m_P; certifying it needs irreducibility of a member of a
    0-dimensional linear system through 54 non-general points, not
    established here.

    E4.  The system is emitted machine-readably (62 variables with kinds and
    roles, four equations with sources, the unknown extra-orbit columns
    declared).  Rank of the linear part = 4 over Q(d, m), certified by an
    explicit non-singular 4x4 minor on (s_G, t_G, eb_{pt_C11}, g); NO forced
    entries (4 equations, 46 declared columns plus the extra-orbit columns).
    One conditional narrowing recorded, not claimed: at an ISOLATED point
    centre E.D^3 = mu^3 = 3(E.C), so 3 | mu under hypothesis ND, and with
    the order-11 conditional plus E3's mu <= d the candidates at d = 35 are
    mu in {12, 21}.

    Other flags: E-REDUCED (E2/E3/E4 are about the reduced representative
    T^o and d^o; the sealed pinning rows are about T -- they coincide when
    gcd(T) = 1, and several sealed rows bound only T^- or T^+); and
    E2-EXTRA-ORBITS (the congruence sums over ALL orbits of components,
    including the unknown extra orbits Group G forces; the census supplies
    candidates only).

    Exits: E-LEDGER-ANCHORS-PASS, E-LEDGER-C1-REPRODUCED,
    E-LEDGER-CENSUS-REBUILT, E-LEDGER-FILTER-LEMMA-PROVED,
    E-LEDGER-E2-CONGRUENCE-TABLE, E-LEDGER-D35-ORDER11-CONDITIONAL,
    E-LEDGER-E3-COVERING-FAMILIES-CERTIFIED, E-LEDGER-E3-LP-EXACT,
    E-LEDGER-E3-DEGREE-BOUND-7, E-LEDGER-E4-SYSTEM-EMITTED-RANK-4,
    E-LEDGER-ND-COROLLARY-CONDITIONAL, E-LEDGER-SPEC-DIVERGENCE-FLAGS,
    E-LEDGER-NO-DEGREE-EXCLUSION.
    Machine markers: E_LEDGER_VERIFY_OK, ALLGREEN (214 checks, 0 failures).
```

## Downstream notes for the director (NOT acted on here)

1. `theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §3.1: the `|S| = 660` row of
   the E2 table needs either a proof of "proper components" or the explicit
   hypothesis H-PROPER attached to the three displayed congruences and to
   corollary 1. The plus-plane connectivity fact recorded here makes the gap
   concrete.
2. Same §3.1: "`d°⁴ ≡ 1 mod 5` and `mod 3` (Fermat)" is stated for
   `p ∤ d°`; at `d° = 35` the mod-5 right-hand side is 0. Worth a clause.
3. E3 in §3.1 is presented as if degree-1 families closed the movable cone.
   They do not; the degree-`e` plane-curve family beats `d ≥ 3m_P` for
   `e ≥ 4`. The L10 lane should say what it wants: the certified degree-1
   LP (this packet) or a genuine movable-cone computation on the wonderful
   model.
