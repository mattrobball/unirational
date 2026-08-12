# WORKORDER — Cross-band gluing: scheme-level agreement on shared loci

Issued 2026-08-12 (director). python3 only (never gap/gp/sage/magma —
shell aliases trap); primes 331, 661; no git; packet
`goal_runs_20260812/CROSSBAND_GLUING/` only.

## A. The unused layer

The boundary datum of one map is ONE morphism: where the closures of two
sweep rows share a POSITIVE-DIMENSIONAL stratum, their leading data must
agree as restricted sections along it — not merely at the finitely many
census children. The σ-band machinery imposes only same-σ data plus
child-point values; conditions COUPLING different involutions' bands
along shared curves have never been imposed. They are linear, computable
with the existing jet machinery, and their loci/bidegrees are
degree-independent structures.

## B. Tasks

1. **Inventory the gluing loci:** from the census
   (`STAGE1_COMPLEX_MAPS`), all positive-dimensional intersections of
   sweep-row closures across DIFFERENT group elements' bands — at
   minimum: plus-plane pairwise intersections `P_σ ∩ P_σ'` (lines) for
   commuting and non-commuting involution pairs, plus-plane ∩ ℓ_V
   incidences, and the minus-line incidences with both. One orbit
   representative per G-orbit of pairs; record stabilizers.
2. **The gluing conditions at d = 35:** for each representative locus,
   the two rows' leading data restricted along it must be EQUAL as
   sections: sample the locus (saturation-checked point counts) and
   impose equality of the corresponding jet extractions of `T` from both
   sides as linear conditions on the 37-cell
   (`PAIR_ATTACK_D35` results; jet machinery from
   `director_worked_example.py` / `slicelib.jet_rows`). Rigidity anchors
   at every functional. Report: rank of the full cross-band gluing
   system on the 37-cell; new dimension; whether any of the 22 cells'
   closed data become inconsistent (deaths, with mechanism).
3. **General degree:** the same inventory with the multidegree
   bookkeeping symbolic in the residue class — state which gluing
   conditions exist at every degree and which are class-dependent; run
   the d = 36 instance on the 63-cell as the second data point.

## C. Framing

Headline: "Problem E remains OPEN; this packet excludes no degree." Any
kill among the 22 is a closed-condition death (state plainly, both
primes); an all-dead outcome is FLAGGED behind an ODDZERO-standard
audit. Packet protocol as always (`THEOREM.md` — never REPORT.md —
scripts/, results/, replayable `verifier.py`, `REGISTRATION_SNIPPET.md`,
ODDZERO format, entry E56, goal_run, tracked true; tiering; exits
`CROSSBAND-*`; "Not claimed"). Summary ≤ 25 lines: loci inventory size,
gluing-system rank at 35 (and 36), per-cell effects on the 22.
