# NOTEBOOK registration snippet — `CELL_SYNTHESIS`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.** No git operation was performed; nothing outside
`goal_runs_20260812/CELL_SYNTHESIS/` was written.

```yaml
- path: problems/E-klein-cubic/goal_runs_20260812/CELL_SYNTHESIS/
  entry: E56
  kind: goal_run
  verification_class: mechanical intersection of sealed constraint sets
    (python3 standard library only, exact integer CRT); no new morphism;
    menus re-read uncollapsed from vectors_d35.json and matched
    entry-for-entry against SMITH_I3; 79 checks with assemble.py replay
  primary_exit: CELL-SYNTHESIS-INTERSECTION
  superseded_by: null
  char0_scope: |
    Char-0 unconditional, exact: the CRT 2*chi_0 == 4 (mod 11) and
    2*chi_0 == 0 (mod 5) forces chi_0 == 35 (mod 55); the joint
    Riemann-Hurwitz genera are 21 + 55 Z; forced C11 blowup depths are
    min_extra_depth_for_R0 + 1 from the sealed L12 I3 table
    (3 for mu in {1,2,3,4,5,8,10}, 4 for mu in {6,9}, 5 for mu = 7).
    Finite re-read: the 22 cells by content_hash@p331 (D35_AUDIT, SMITH_I3
    and STEIN_LERAY pairings agree); F_odd(35) = 10*4*4*4*238*238 =
    36252160; 22*36252160 = 797547520 (cell, menu-entry) pairs; Smith
    n_x = 4 and 5 constant on all 10 C11 and all 64 C5 entries; L12
    genus-0 PASS = 0 on every mu (1540 at depth <= 3, 2674 extended);
    DEPTH_TABLE keep-pass 0 closed deaths, 22 live at dim <= 37 both
    primes.
    NOT claimed: any exclusion; any cell death; any all-22 death; the
    FLAG-M smooth-trace near-kill; connectedness or disconnectedness of
    the generic fibre; an all-depth genus-0 death.
  tracked: true
  notes: |
    Director synthesis deferred by HANDOFF_2026-08-12 item 4.2: compound
    the sealed realization constraints on the 22 into one joint
    fiber-structure verdict per cell at d = 35.

    Headline: Problem E remains OPEN; this packet excludes no degree.

    IDENTITY.  The 22 are ids
    5,7,13,15,21,23,29,31,37,39,45,47,53,55,61,63,69,71,697,699,701,703
    keyed by content_hash@p331.  They share one sigma-band
    (ord_L = 0, ord_P = 1) and one 37-cell.  DEPTH_TABLE keep_pass
    id<->hash pairing disagrees with D35_AUDIT (FLAG, hygiene); the
    LIVE / dim<=37 verdict is uniform, so the intersection does not
    depend on it.

    MENUS ARE MENUS.  No cell-to-menu linkage exists.  The full
    F_odd(35) product is admissible for every cell.  Factoring the
    report is not collapsing a menu.

    MUST-LOOK-LIKE (identical on all 22).  All 60 C11-points in the
    base locus; minus-line not in the base locus; plus-plane order 1;
    resolution depth over every C11-point >= 3 (>= 4 for mu in {6,9},
    >= 5 for mu = 7); chi_top == 4 (mod 11) at the five C11-points
    with the five values EQUAL, == 0 (mod 5) at the four C5-points;
    if those nine fibres are ordinary curves then one chi_0 == 35
    (mod 55), hence connected genus >= 21 or Stein degree >= 35;
    C14 genus-0 branch DEAD (0 of 2674).  PIN and J1 as sealed.

    CONTRADICTION SCAN.  n_flagged_kills = 0, claimed_kills = 0,
    ODDZERO audit idle.  FLAG-M (0 of 226 integrality survivors in
    the smooth C7 trace menu) is recorded as a near-kill of that row
    at enumerated tower scope and is not claimed.

    Exits: CELL-SYNTHESIS-22-IDENTITY, CELL-SYNTHESIS-MENUS-UNCOLLAPSED,
    CELL-SYNTHESIS-INVARIANT-TABLE, CELL-SYNTHESIS-PER-CELL-VERDICT,
    CELL-SYNTHESIS-INTERSECTION, CELL-SYNTHESIS-NO-CLAIMED-KILL,
    CELL-SYNTHESIS-NO-DEGREE-EXCLUSION.
    Machine markers: CELL_SYNTHESIS_VERIFY_OK, ALLGREEN (79 checks,
    0 failures, 0 skips).
```

## 4. ODDZERO-format status line

```text
E56 CELL_SYNTHESIS  kind=goal_run  tracked=true
HEADLINE: Problem E remains OPEN; this packet excludes no degree.
PRIMARY_EXIT: CELL-SYNTHESIS-INTERSECTION
CLAIMED_KILLS: 0
CLAIMED_DEGREE_EXCLUSION: false
ODDZERO_AUDIT: idle (outcome is not an all-22 death)
FLAG: FLAG-M smooth-trace near-kill (not claimed); keep-pass pairing hygiene
```
