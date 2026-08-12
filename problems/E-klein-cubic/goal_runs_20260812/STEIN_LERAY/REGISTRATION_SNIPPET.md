# NOTEBOOK registration snippet — `STEIN_LERAY`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.**

```yaml
- path: problems/E-klein-cubic/goal_runs_20260812/STEIN_LERAY/
  entry: E56
  kind: goal_run
  verification_class: independent in-packet re-derivation (PSL(2,11) built as
    permutations of P^1(F_11); the 5-dimensional character DERIVED from the
    Klein-cubic weight datum by exhaustive eigenvalue search under det = 1,
    power-map coherence and both orthogonality relations; Molien by exact
    convolution in Z[zeta_n] reduced mod Phi_330) plus exact cyclotomic
    evaluation of det Hess F; no code imported from
    tmp/scheme_map_20260812/molien_branch.py; 92 checks with a fatal gate group
  primary_exit: STEIN-LERAY-MENUS-JOINT-CHI0
  superseded_by: null
  char0_scope: |
    Char-0 unconditional: the J1 re-derivation (invariant divisor degrees on X
    are exactly {k >= 5}; all six sealed Molien anchors M_1 = 1, M_11 = 12,
    M_12 = 16, M_25 = 189, M_34 = 576, M_35 = 637 reproduce, and the ambient
    degree set {3} u [5,40] matches the independent EXCLUSION_TRANSPORT probe);
    Proposition PIN (a G-invariant divisor of degree k on X contains all five
    C11-pinned points unless 11 | k and all four C5-pinned points unless 5 | k,
    so missing every pinned point forces 55 | k); the explicit unique degree-5
    invariant divisor D_5 = {det Hess F = 0} n X, which contains every
    C11-pinned point and no C5-pinned point; the strengthened Leray package
    (the three J3 vanishings survive R^3 q_* O; H^0(R^1) = 0 forbids isolated
    points of supp R^1); Lemma FF (h^1 of a 1-dimensional fibre detects the
    support, via formal functions); Lemma FL (miracle flatness makes
    chi(O_fibre) constant on the whole 1-dimensional-fibre locus); Lemma BR
    (chi_top = 2 chi(O) + D - 2 chi(N) on a 1-dimensional fibre, D >= 0, D = 0
    iff F_red smooth); the Hurwitz rule that no faithful C_p action on a smooth
    curve has exactly one fixed point.
    Finite exact computation: the 92-check verifier, including the recomputed
    constancy of every Smith input over all 10 C11 menu entries and all 64 C5
    menu entries (deposit vector (5,5,5,5) every time), the F3 closures
    5*4 = 4*5 = 20, and the 22-row dichotomy ledger keyed by
    (cell_id, content_hash@p331).
    NOT claimed: any exclusion; connectedness or disconnectedness of the
    generic fibre; sufficiency of 55 | deg for a divisor missing every pinned
    point; anything about a 3-dimensional fibre (FLAGGED).
  tracked: true
  notes: |
    Lane 2 of DATA_SPEC_PIPELINE_FLUSH_20260812.md.  Authority:
    SCHEME_MAP_CONSEQUENCES_20260812 sec. 3.4 (J1-J3) combined with the SEALED
    SMITH_I3 (chi(fibre) = 4 mod 11 at each of the five C11-points with the
    five values EQUAL; = 0 mod 5 at each of the four C5-points; n_x = 4 and 5
    read on the terminus model Z).

    Headline: Problem E remains OPEN.  This packet excludes no degree and cuts
    none of the 22 live d = 35 cells; both branches of the Stein dichotomy stay
    live in all 22 ledger rows.

    THE FATAL GATE PASSED.  The J1 invariant-degree fact is re-derived from
    scratch by a different route from the scratch reference, and all six sealed
    Molien anchors reproduce.  The derived 5-dimensional character agrees line
    for line with the sealed sec. 3.3 restriction table (C2 3(+1)+2(-1); C3
    1+2w+2w^2; C5 all five 5th roots; C6 1,-w,-w^2,w,w^2; C11 QR / NQR).

    WHAT IS NEW.  (1) Proposition PIN: the escape-locus caveat of J3 cannot be
    dodged by general position -- unless 11 | deg (resp. 5 | deg) an invariant
    jump or branch divisor is FORCED through every C11- (resp. C5-) pinned
    point, and a divisor missing all of them needs degree >= 55.  (2) At the
    cheapest degree the branch/jump divisor is uniquely determined: deg 5 forces
    D_5 = {det Hess F = 0} n X, computed here, which contains all five
    C11-pinned points and no C5-pinned point.  (3) The joint menu: if the nine
    pinned points carry 1-dimensional fibres then chi(O_fibre) is ONE integer
    chi_0 (miracle flatness on the irreducible X), and in the smooth-fibre row
    chi_0 = 35 (mod 55).  Dichotomy: either chi_0 <= -20, so h^1 >= h^0 + 20 at
    every pinned point (h^0 = 1, h^1 = 21 mod 55, genus >= 21 in the connected
    branch), or chi_0 >= 35, which forces at least 35 fibre components and hence
    Stein degree s >= 35 -- impossible in the connected branch.  Cross-checked
    against Riemann-Hurwitz: g = 11a + 10 at a C11-point and g = 5b + 6 at a
    C5-point meet first at g = 21.

    THE HONEST GAP (flagged, sec. 7.1).  The Smith value is a TOPOLOGICAL Euler
    characteristic and (h^0, h^1) are coherent.  The spec's "chi = h^0 - h^1"
    identification is not made silently: Lemma BR supplies the bridge with an
    explicit non-negative defect, every menu carries the defect, and the sharp
    numbers are stated only in the zero-defect (smooth-fibre) row.

    DISCONNECTED BRANCH, PARAMETRIC HONESTY (sec. 5.3).  Nothing sealed at
    d = 35 bounds it: the Stein degree is explicitly carried as a menu variable
    by GLOBAL_LOCALIZATION_LEDGER sec. 8 Flag 1, MORPHISM_LEDGER L13 is UNSPENT,
    C1 is an unpinned genus identity, E1's fibre-class expansion is unpinned,
    SMITH_I3's F2/F3 are connectedness-free, and GENERIC_FIBER_STEIN_MORI's
    delta = 1 lemma runs on hypotheses its own banner declares NOT FORCED.  The
    only new coupling is this packet's s >= 35 above.  Also recorded: J3
    transfers to the Stein factor iff H^i(Y, O_Y) = 0 for i > 0.

    Exits: STEIN-LERAY-J1-REDERIVED, STEIN-LERAY-MOLIEN-ANCHORS-PASS,
    STEIN-LERAY-PIN-PROPOSITION, STEIN-LERAY-QUINTIC-EXPLICIT,
    STEIN-LERAY-LERAY-PACKAGE-STRENGTHENED, STEIN-LERAY-DICHOTOMY-LEDGER-22,
    STEIN-LERAY-MENUS-JOINT-CHI0, STEIN-LERAY-MENU-CONSTANCY-VERIFIED,
    STEIN-LERAY-DISC-BRANCH-UNBOUNDED-BY-SEALED-D35,
    STEIN-LERAY-NO-DEGREE-EXCLUSION.
    Machine markers: STEIN_LERAY_VERIFY_OK, ALLGREEN (92 checks, 0 failures,
    0 skips; groups A 25 gate / B 26 / C 41).
```

## Downstream edits this packet implies (for the director, NOT made here)

1. `theory/MORPHISM_LEDGER_20260812.md` row **L13** (Stein/branch) and the new
   **L14** (coherent-pushforward vanishing) can be moved from UNSPENT to
   *instantiated on the 22*, with Proposition PIN attached to both: the
   invariant-divisor degree bound is now `≥ 5` in general and `≥ 55` for any
   invariant divisor that misses the pinned odd-order points.
2. `theory/SCHEME_MAP_CONSEQUENCES_20260812.md` §3.4's escape caveat should
   record PIN: the escape divisor is *forced* through the pinned points in every
   degree not divisible by 11 (resp. 5), so corollary (ii) cannot be rescued by
   a position argument.
3. `DATA_SPEC_PIPELINE_FLUSH_20260812.md` Lane 2's "`χ = h⁰ − h¹`" should be
   read with the bridge of §3.5; the topological/coherent distinction is
   load-bearing for every numeric menu.
