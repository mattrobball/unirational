# NOTEBOOK registration snippet — `DEPTH_TABLE_GENERAL`

Paste into the repository manifest. **No manifest or NOTEBOOK edit was made by
this packet.**

```yaml
- path: problems/E-klein-cubic/goal_runs_20260812/DEPTH_TABLE_GENERAL/
  entry: E56
  kind: goal_run
  verification_class: python3-only rebuild of the general depth-value table
    (s3jet.chi_arc_of + value_at_level + FullSweep own_frame) at two split primes
    331, 661 for both full-flag rows; two distinct multidegree classes per row;
    T4 period-histogram anchor reproduced; keep-pass on the content-addressed 22
    with closed intermediate-level jet functionals (Reynolds jet_rows, rigidity
    anchors at every new functional) on the sealed 37-cell.
  primary_exit: DEPTH-TABLE-GENERAL-BUILT
  superseded_by: null
  char0_scope: |
    Char-0 unconditional: universal six-flip cut rank 2 on the sealed 39-slice
    (modular full rank of a corank-2 cut; sealed ODDZERO / PAIR_ATTACK).
    Two-prime finite exact: rid-1 period histogram 36/6/12; rid-2 histogram
    12/6; value-cycle invariance under same mod-6 class (lift a_i += 6); 14/18
    forced-deeper rows at d=35; closed keep-pass functionals rank 0 on the
    37-cell; 22 live at dim ≤ 37 under closed conditions only.
    NOT claimed: any degree exclusion; open-condition kill of the 22; a
    corrected global pattern count at odd residue.
  tracked: true
  notes: |
    WORKORDER_DEPTH_VALUE_TABLE_GENERAL (cycle 4, move 1 — GENERAL-DEGREE FIRST).

    PRIMARY PRODUCT: the general depth-value table for rid 1 and rid 2, every
    child, every multidegree class mod 6 — arc period, value cycle by depth,
    arc-consistent levels. Degree-independent period structure; degree enters
    only through the class of the leading datum.

    APPLICATION: corrected keep-pass on the 22 d=35 survivors (content-addressed
    D35_AUDIT blueprints). Period-1 keeps: no closed condition. Period>1 keeps
    of a κ≡0-only value at a forced-deeper child: force levels 1..period-1 to
    vanish. Those closed functionals already vanish on the 37-cell (rank 0);
    death count by closed keep-pass = 0; all 22 live at dim ≤ 37. Residual
    openness demands recorded per branch, not used to kill.

    Headline: Problem E remains OPEN; this packet excludes no degree.

    Exits: DEPTH-TABLE-GENERAL-BUILT, DEPTH-TABLE-TWO-CLASS-VERIFIED,
    DEPTH-TABLE-T4-ANCHOR-REPRODUCED, DEPTH-TABLE-KEEP-PASS-22,
    DEPTH-TABLE-NO-DEGREE-EXCLUSION.
    Machine markers: DEPTH_TABLE_GENERAL_VERIFY_OK, ALLGREEN.
```
