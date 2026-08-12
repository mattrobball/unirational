# WORKORDER — The landing instruments swept across degrees
# (cycle 4, move 3 — turn the d = 35 endgame tools into degree-general data)

Issued 2026-08-12 (director). python3 (+ msolve/M2 on REDUCED systems only
— the 37-variable monolith is a known wall; never gap/gp/sage/magma);
primes 331, 661; no git; packet `goal_runs_20260812/LANDING_SWEEP/`.

## A. Why a sweep

`D35_LANDING` produced, at d = 35: Layer-0 dim 39; the six-flip cut to
37; `ord ≥ 2` on minus-lines impossible (rank full); the landing cubics
span exactly 1380 of 9139 in degree 3 (`HF(3) = 7759`); all random
sections origin-only. Each instrument is cheap enough to run at OTHER
degrees, and the campaign's standing directive is GENERAL-DEGREE results:
trends and closed forms beat one-window numbers. The D34 alive-table
(`D34_GUIDED_SWEEP/THEOREM.md` §the table: d = 35..42 upper bounds
39, 41, ..) gives the cells.

## B. Tasks, per degree d in {34, 35, 36, 37, 38, 39, 40, 41, 42}

(34 is the sealed-closed control; its cascade must reproduce 0.)

1. **Layer-0 dim** of the `(1, 6)`-window cell at d (structure + profile,
   the D34 ladder recipe; anchor: the alive-table's published numbers).
2. **The finisher instrument:** the parity-forced minimal line order at d
   (`ord ≡ d+1 mod 2`), and the rank of imposing the σ-band's minimal
   POSITIVE line-order option on the cell (at odd d: `ord ≥ 2`; at even
   d: `ord ≥ 1` is forced, so test `ord ≥ 3`). Record for which d the
   demanded order is IMPOSSIBLE (rank = full cell dim, as at 35) — each
   such d gets the same 398-style kill for the corresponding blueprint
   branches; report the per-degree kill fractions if the σ-band pattern
   data is available (it is only built at residue 5; for other residues
   report the instrument's verdict and leave the census to the σ-band
   machinery — do NOT rebuild pattern enumerations at other residues in
   this packet).
3. **The universal flip cut at d:** the six V4-children's forced-flip
   rank on the cell for the parity where it applies (odd d; at even d
   the level-0 value is the demanded one — state it and skip).
4. **The landing Hilbert number:** `P3(d)` = dim of the span of sampled
   landing cubics on the (post-flip) cell, saturated, and
   `HF(3)(d) = C(cell+2, 3) − P3(d)`. Also the section-probe battery
   (a smaller version: 10 line-, 10 plane-sections per prime) with
   origin-only-or-witness verdicts.
5. **The general-degree readout (the actual deliverable):** the table
   d ↦ (cell dim, finisher verdict, flip rank, P3, HF3, sections), and
   every closed-form or congruence pattern visible in it (e.g., is
   P3(d) a polynomial in d? does the finisher impossibility hold at
   every d in the sweep? does HF3 scale with cell dim in a way that
   suggests a structural identity?). State observed patterns as
   OBSERVATIONS with the data, never as theorems.

## C. Framing

Headline: "Problem E remains OPEN; this packet excludes no degree."
Instrument verdicts at unclosed degrees are map-level facts about the
`(1,6)` window cells, conditional on the cone-order premise (audited in
parallel — cite `WORKORDER_CONE_ORDER_T6_GENERAL.md`). Packet protocol as
always (`THEOREM.md`, replayable `verifier.py`, heavy binaries gitignored
with a regeneration note — hosting limit is 50 MB per file —
`REGISTRATION_SNIPPET.md`, tiering, exits `LANDING-SWEEP-*`, "Not
claimed"). Summary ≤ 25 lines: the full table, the observed patterns, the
control at d = 34.
