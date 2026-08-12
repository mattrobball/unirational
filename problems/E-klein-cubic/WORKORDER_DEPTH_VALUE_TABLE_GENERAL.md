# WORKORDER — The general depth-value table, and the corrected keep-pass on the 22
# (cycle 4, move 1 — GENERAL-DEGREE FIRST)

Issued 2026-08-12 (director). python3 only (never gap/gp/sage/magma — shell
aliases trap); primes 331, 661 (+991 where cheap); no git; packet
`goal_runs_20260812/DEPTH_TABLE_GENERAL/` only.

## A. Why general

The audited fact (`D35_AUDIT` T4): the plus-row's children have arc-period
histogram 36 / 6 / 12 (periods 1 / 2 / 3), and values CHANGE with depth
wherever period > 1. The period structure and the value cycles are
**degree-independent** — the degree enters only through the class
`(a, ψ)` of the leading datum (mod-6 data, Theorem S). So the correct
deliverable is not a d = 35 patch but the sealed general table every
window consumes from now on.

## B. Deliverable 1 — the general table (the point of this packet)

For BOTH full-flag rows (`rid 1` = plus-row, `rid 2` = line-row) and every
child: tabulate, as a function of the multidegree class mod 6 (equivalently
`(d mod 6, m mod 6)` on rid 1, `(d mod 6, ν mod 6)` on rid 2):

  * the arc character and its period;
  * the full value CYCLE by depth level `κ = 0, 1, …, period−1`
    (labels via `own_frame`, machine-readable);
  * which cycle entries are arc-consistent (in the child's domain), per
    class — i.e., the depth levels a coherent blueprint may assert.

Sources: `STAGE1_STRATIFIED/scripts/s3jet.py` (`chi_arc_of`,
`value_at_level`), `STAGE1_TIGHTEN/scripts/s3sweep.py`, the `D35_AUDIT`
period data (reproduce it as an anchor). Verify the cycle claims by
explicit section evaluations at both primes for at least two distinct
degree classes (e.g., residues of 35 and of 34) — the table must be
usable at EVERY degree, so its verification must not be single-residue.

## C. Deliverable 2 — the application: the corrected keep-pass on the 22

At d = 35 (class of `(34,1)` on rid 1): for each of the 22 canonical
survivors (content-addressed files from `D35_AUDIT`'s repair — use those,
not the index-linked originals):

  1. its keeps at the 14 forced-deeper rows (`PAIR_ATTACK_D35`
     `results/worked_example_p*.json` context; recompute the dead-row set
     in-run) — split by the general table's period:
     * period 1: keep unaffected (value depth-constant) — no condition;
     * period > 1 with the kept value attainable only at levels
       `κ ≡ 0 (mod period)`: since level 0 is dead on the slice, the keep
       forces the CLOSED conditions "levels 1 … period−1 vanish" at that
       child (each level-κ functional = the κ-th arc-jet of the
       `(34,1)`-datum: double jets via the D34 engine, `p2lib.jet_rows2`
       or equivalent; derive the arc directions from the census frames as
       ODDZERO §5 does for the six);
  2. impose those closed conditions on each survivor's 37-cell; report
     new dims; any cell at dim 0 is soundly dead (say which);
  3. the surviving keeps' openness demands are RECORDED (not used to
     kill) — list them per cell as the realization checklist.

Rigidity anchors mandatory at every new functional (transverse components
vanish for all 637 basis covariants — the packet standard).

## D. Framing

Headline: "Problem E remains OPEN; this packet excludes no degree." The
general table is the sealed product; d = 35 numbers are its first
application. Any cell death is stated plainly (closed conditions, both
primes); no keep-based kill outside the period->1-with-dead-level-0 rule.
Packet protocol as always: `THEOREM.md` (never REPORT.md), `scripts/`,
`results/`, replayable `verifier.py`, `REGISTRATION_SNIPPET.md`, honesty
tiering, exit ledger (`DEPTH-TABLE-*`), "Not claimed". Summary ≤ 25 lines:
the general table's shape, the two-class verification, the d = 35 keep-pass
death count and surviving dims.
